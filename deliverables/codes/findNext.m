function [ rowNext, colNext ] = findNext( rowCurrent, colCurrent, borderImage, colorNum )
    
    d = size(borderImage);
    rowNext = 0;
    colNext = 0;

    if (rowCurrent > 1 && rowCurrent < d(1) && colCurrent > 1 && colCurrent < d(2))
        if borderImage(rowCurrent+1,colCurrent) == colorNum
            rowNext = rowCurrent + 1;
            colNext = colCurrent;
        elseif borderImage(rowCurrent,colCurrent-1) == colorNum
            rowNext = rowCurrent;
            colNext = colCurrent - 1;
        elseif borderImage(rowCurrent,colCurrent+1) == colorNum
            rowNext = rowCurrent;
            colNext = colCurrent + 1; 
        elseif borderImage(rowCurrent-1,colCurrent) == colorNum
            rowNext = rowCurrent - 1;
            colNext = colCurrent;  
        elseif borderImage(rowCurrent+1,colCurrent-1) == colorNum 
            rowNext = rowCurrent + 1;
            colNext = colCurrent - 1;
        elseif borderImage(rowCurrent+1,colCurrent+1) == colorNum
            rowNext = rowCurrent + 1;
            colNext = colCurrent + 1;
        elseif borderImage(rowCurrent-1,colCurrent+1) == colorNum
            rowNext = rowCurrent - 1;
            colNext = colCurrent + 1;  
        elseif borderImage(rowCurrent-1,colCurrent-1) == colorNum
            rowNext = rowCurrent - 1;
            colNext = colCurrent - 1;
        else
            rowNext = 0;
            colNext = 0;
        end
    end
end

