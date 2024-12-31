function superSnake2() 
	global stop;
	global az el;
	global az_step el_step;
	global az_step_step el_step_step;

	stop = 0;

	% Set up ring buffer
	rbLength = 20;
	bufptr = 1; 
	buffer_x = zeros(1,rbLength);
	buffer_y = zeros(1,rbLength);
	buffer_z = zeros(1,rbLength);

	% Boundary of 3D arena
	bound = 5;

	% Create initial dummy plots 
	makeFigure(1,[ 0.397 0.051 0.575 0.842 ],@keypressFunction);
	h = plot3(0,0,0,'g-',0,0,0,'ro'); % blue line plot, red circle plot
	set(h(1),'LineWidth',3); % thick line
	set(h(2),'MarkerSize',10,'MarkerFaceColor',[1 0 0]); % filled red circle
	axis([-bound bound -bound bound -bound bound]); % size of arena
	grid on; % show grid
	set(gcf,'Color','black');
	p = h(1).Parent;
	%p.AmbientLightColor = [0 0 0];  % [1 1 1]
	p.GridColor = [ 1 1 1 ];
	p.MinorGridColor = [ 1 1 1 ];
	p.Color = [ 0 0 0.5 ];

	% plot lines on all 12 boundaries
	hold on;
	plot3([-bound -bound],[bound -bound],[bound bound],'k-');
	plot3([-bound bound],[-bound -bound],[bound bound],'k-');
	plot3([-bound -bound],[-bound -bound],[bound -bound],'k-');
	plot3([-bound -bound],[bound -bound],[-bound -bound],'k-');
	plot3([-bound bound],[-bound -bound],[-bound -bound],'k-');
	plot3([-bound bound],[bound bound],[bound bound],'k-');
	plot3([-bound -bound],[bound bound],[bound -bound],'k-');
	plot3([bound bound],[bound -bound],[bound bound],'k-');
	plot3([bound bound],[-bound -bound],[bound -bound],'k-');
	plot3([bound bound],[bound bound],[bound -bound],'k-');
	plot3([-bound bound],[bound bound],[-bound -bound],'k-');
	plot3([bound bound],[-bound bound],[-bound -bound],'k-');

	% Get initial view to allow spin
	[az el]  = view;
	az_step = 0;
	el_step = 0;
	az_step_step = 0.05;
	el_step_step = 0.05;

	% x,y,z position of head of snake
	x = 0;
	y = 0;
	z = 0;

	%az_step = 0.5; % spin rate 

	while ~stop
		% Use ring buffer for history of snake (body)
   		buffer_x(bufptr)=x;
   		buffer_y(bufptr)=y;
   		buffer_z(bufptr)=z;
   	 	ind=rbIndexes(bufptr,rbLength);
    	bufptr=rbNextBufferPosition(bufptr,rbLength);

		% Smooth random trajectory for visual appeal
		nx = buffer_x(ind);
		ny = buffer_y(ind);
		nz = buffer_z(ind);
		kernel = ones(1,5);
		kernel = kernel/sum(kernel);
		nx = conv2(nx,kernel,'valid');
		ny = conv2(ny,kernel,'valid');
		nz = conv2(nz,kernel,'valid');

		% Put data into plot
		change_plot_xyz_data(h(1),nx,ny,nz); % body (line)
		change_plot_xyz_data(h(2),nx(end),ny(end),nz(end)); % head (circle)
		az = az + az_step;
		el = el + el_step;
		view(az,el);

		% Change width of line based on average depth (z) of snake
		% 	LW: Min 1, max 5
		% 	Depth: Min 3, max 9, roughly
		near_corner = [-5 -5 5];
		depth = norm([mean(nx) mean(ny) mean(nz)] - near_corner);
		line_w = 1+(5-1)*(1 - (depth-3)/(9-3));
		line_w = max(1,line_w);
		line_w = min(5,line_w);
		set(h(1),'LineWidth',line_w); 

		% Update random trajectory
		x = x + randNum(1,1,-0.5, 0.5);
		y = y + randNum(1,1,-0.5, 0.5);
		z = z + randNum(1,1,-0.5, 0.5);

		% Keep "snake" from going outside arena
		if (x >= bound)
			x = bound;
		elseif (x <= -bound)
			x = -bound;
		elseif (y >= bound)
			y = bound;
		elseif (y <= -bound)
			y = -bound;
		elseif (z >= bound)
			z = bound;
		elseif (z <= -bound)
			z = -bound;
		end;

		pause(0.05);
		%drawnow;
	    
	end;

	close all;
end

function keypressFunction(a,b)
	global stop;
	global az el;
	global az_step el_step;
	global az_step_step el_step_step;
	if strcmp(b.Key,'space')
		stop = 1;
	elseif strcmp(b.Key,'leftarrow')
		az_step = az_step + az_step_step;
	elseif strcmp(b.Key,'rightarrow')
		az_step = az_step - az_step_step;
	elseif strcmp(b.Key,'uparrow')
		el_step = el_step - el_step_step;
	elseif strcmp(b.Key,'downarrow')
		el_step = el_step + el_step_step;
	elseif strcmp(b.Key,'return')
		el_step = 0;
		az_step = 0;
	end;
end
