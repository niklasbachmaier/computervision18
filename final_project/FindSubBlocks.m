function [Matches, indices] = FindSubBlocks(M,beginframe,endframe,num_im, dim)
% input the point view matrix startframe and endframe
%   Find points which are present in consecutive images in a point-view
%   matrix

% INPUT: M the point-view matrix, beginframe and endframe the begin and end
% elements where to look for consecutive matches, num_im total number of
% elements (=views), dim which dimension the points have (2 or 3)

Matches=[];
indices = [];

startindex = beginframe + (beginframe - 1) * (dim - 1);
endindex = endframe * dim;

%to care for the overlapping case
if endframe > num_im 
   view_set = [M(startindex:num_im*dim,:); M(1:(endframe-num_im)*dim,:)];    
else 
   view_set = M(startindex:endindex,:);
end

for i=1:length(M)
    
    if any(view_set(:,i),2) == ones(length(startindex:endindex),1)
        Matches=[Matches view_set(:,i)];
        indices = [indices, i];
    end 
end

end

