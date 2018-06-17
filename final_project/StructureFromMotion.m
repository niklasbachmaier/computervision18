%function demo3(tracked)
%A demo of the structure from motion that shows the 3d structure of the
%points in the space. Either from the original points or the tracked points
%INPUT
%- tracked: boolean that states whether to use the tracked points
%           if set to true the tracked points will be used otherwise
%           the ground truth is used. (default = false)
%
%OUTPUT
% an image showing the points in their estimated 3-dimensional position,
% where the yellow dots are the ground truth and the pink dots the tracked
% points from the LKtracker
%- M: The transformation matrix size of 2nx3. Where n is the number of 
%     cameras i.e. images.
%- S: The estimated 3-dimensional locations of the points (3x#points)
function [Points_3D] = StructureFromMotion(Points_2D)
% % %load points
Points = Points_2D;
% % %Shift the mean of the points to zero using "repmat" command
shifted_points = Points-repmat(mean(Points,2),1,size(Points,2));

% % %singular value decomposition
[U,W,V] = svd(shifted_points);

U = U(:,1:3);
W = W(1:3,1:3);
V = V(:,1:3);

M = U*sqrt(W);
S1 = sqrt(W)*V';

% % %solve for affine ambiguity
% A=[M(1,:);M(2,:);M(3,:)];
% L0=eye(3)/pinv(A*A');
% 
% %Solve for L
% L = lsqnonlin(@myfun,L0);
% %Recover C
% C = nearestSPD(L);
% 
% M=M*C;
% 
% Points_3D = pinv(C)*S1;

Points_3D = S1;

end
