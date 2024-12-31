function Assignment5MiguelFermaint(varargin)

    F4MainLoop(varargin, @chooseBestPassword);

end

function passwordAttempt = chooseBestPassword(lastPasswordAttempt,lastNumLetterMatches)

    global remainingPotentialPasswords;

    if ~ isempty(lastPasswordAttempt)
        
         remainingPotentialPasswords = eliminatePasswords(lastPasswordAttempt,lastNumLetterMatches,remainingPotentialPasswords);
         
    end
    
    passwordAttempt = computeMostMatches(remainingPotentialPasswords);
    
end

function outlist = eliminatePasswords(lastPasswordAttempt,lastNumLetterMatches,pwdList)
    
    letterMatches = computeAllLetterMatches(lastPasswordAttempt,pwdList);
    
    outlist = pwdList;
    
    for s = 1:length(pwdList)
        
        if letterMatches(s) ~= lastNumLetterMatches
            
            outlist = deleteFromList(pwdList{s},outlist);
            
        end
        
    end
    
end

function numMatches = computeNumMatches(pwdList)
    
    for h = 1:length(pwdList)
        
            letterMatches = computeAllLetterMatches(pwdList{h},pwdList);
            
            numMatches(h) = nnz(letterMatches);
    end
end

function pwToTry = computeMostMatches(pwdList)

    numMatches = computeNumMatches(pwdList);
    
    [y , i] = max(numMatches);
    
    pwToTry = pwdList{i};
    
end


function letterMatches = computeAllLetterMatches(pwd,pwdList)
    
    for i = 1:length(pwdList)
        
        letterMatches(i) = computeLetterMatches(pwdList{i},pwd);
        
    end
    
end

function matches = computeLetterMatches(pw1,pw2)

    matches = 0;
    
    i = min(length(pw1),length(pw2));
    
    for U = 1:i
        
        if pw1(U) == pw2(U)
            
            matches = matches + 1;
            
        end
        
    end
    
end