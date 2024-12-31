f = figure(); % create a figure with an axes on it
%ax = axes('Units','pixels', 'Position',[0 0 560 420], 'XTick',[], 'YTick',[], ...
       % 'Nextplot','add', 'YDir','reverse');
% read the big logo image - background of the figure
%bigImage = imread('Matlab_Logo.png');
%image(bigImage, 'parent', ax);  % Display the image in the axes
% read a smaller image - background of button
img = imread('DraftGUIPic1.png');
s = size(img);
pos = [10 10 s(2) s(1)];  %Position of the button
% Extract the portion of the image where the button will be.
%F = getframe(ax,pos);  % take a screenshot of the parent figure
pb = uicontrol('Style','pushbutton', 'Position',pos, 'CData', img,...
             'Callback',@(a,b)disp('push button'));
% as before - calculate where the button image is white.
img = double(img)/255;
index1 = img(:,:,1) == 1;
index2 = img(:,:,2) == 1;
index3 = img(:,:,3) == 1;
indexWhite = index1+index2+index3==3;
% for each pixel, replace the white portion with the parent image data
for idx = 1 : 3
 rgb = img(:,:,idx);                   % To make the picture quirky change the RGB
 %pImage = double(F.cdata(:,:,idx))/255;  % extract part of the image
 rgb(indexWhite) = NaN;   % set the white portion of the image to the parent
 img(:,:,idx) = rgb;                     % substitute the update values
end
set(pb, 'CData', img)
set(f, 'Color', get(pb,'BackgroundColor'))