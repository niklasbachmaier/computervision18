%% get actual point coordinates from PT matrix
function [XY_PT_matrix]=getXY(PT_matrix, frames)
XY_PT_matrix=[];
for i = 1:19
    for j =1:length(PT_matrix)
        points= frames{1,i};
        if PT_matrix(i,j) ~= 0
            
           XY_PT_matrix(i+i-1:i+i,j)= points(1:2,PT_matrix(i,j));
           
    else 
        
XY_PT_matrix(i+i-1:i+i,j)= [0;0];

    end
    end
end