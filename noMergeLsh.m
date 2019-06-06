function [ tempLocation,number, meaLocation] = noMergeLsh( temp,bili,splitNumber )
%noMergeLsh 没有合并的桶
%   此处显示详细说明
[m,n] = size(temp);

number_1 = 1;
startLine = 0;
for i=2:m
    if temp(i,2) ~= temp(i-1,2)
        number_1 = number_1 + 1;
    end
end

meaLocation = zeros(number_1,2);
meaLocation(1,1) = 1;
startLine = 1;
for i=2:m
    if temp(i,2) ~= temp(i-1,2)
         meaLocation(startLine,2) = i-1;
        if i ~= m
            startLine = startLine + 1;
            meaLocation(startLine,1) = i;
        else
            meaLocation(startLine+1,1) = i;
            meaLocation(startLine+1,2) = i;
        end
    else
        if i== m
            meaLocation(startLine,2) = i;
        end
    end
end

tempLocation = zeros(size(meaLocation));

maxRowNumber = ceil(m/splitNumber);

tempRow = size(meaLocation,1);

rowNumber = maxRowNumber;
for i=1:tempRow
    tempNumber = meaLocation(tempRow,2)-meaLocation(tempRow,1)+1;
    if tempNumber > maxRowNumber
        maxRowNumber = tempNumber;
    end
end

rowNumber = maxRowNumber;

tempRowNumber = 1;
while(tempRow > 0)
    tempLocation(tempRowNumber,2)=meaLocation(tempRow,2);
    tempNumber = meaLocation(tempRow,2)-meaLocation(tempRow,1)+1;
    while(tempNumber < rowNumber)
        if tempRow > 1
            tempRow = tempRow - 1;
        else
            tempRow = tempRow;
        end
        tempNumber = tempNumber + meaLocation(tempRow,2)-meaLocation(tempRow,1)+1;
        if tempRow == 1
            break;
        end
    end
     tempLocation(tempRowNumber,1)=meaLocation(tempRow,1);
     tempRowNumber = tempRowNumber + 1;
     tempRow = tempRow - 1;
end
A1=sum(abs(tempLocation'));
index=find(A1==0);
tempLocation(index,:)=[];
tempLocation=sortrows(tempLocation,1);
number = size(tempLocation,1);
end

