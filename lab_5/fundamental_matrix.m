%% extract feature points and descriptors

%IMPORTANT: if other images than obj02_001.jpg and obj02_002.jpg, then
%procedure to manually discard background features has to be adapted
img1 = 'obj02_001.jpg';
img2 = 'obj02_002.jpg';

%get images to single
im1 = imConv(img1);
im2 = imConv(img2);

%extract feature points and descriptors
[f1,d1]= vl_sift(im1);
[f2,d2]= vl_sift(im2);

%match features
matches = vl_ubcmatch(d1,d2);

%display image and plot feature points
% figure('Name','Image 1');
% I = insertMarker(im1,[f1(1,matches(1,:)).',f1(2,matches(1,:)).'],'o','color','yellow','size',1);
% imshow(I)
% 
% figure('Name','Image 2');
% I = insertMarker(im1,[f2(1,matches(2,:)).',f2(2,matches(2,:)).'],'o','color','yellow','size',1);
% imshow(I)

%manually eliminate matches that are not the teddy bear:
%done by clicking in the image and looking in which range of x and y
%coordinates the teddy bear lies

%for image 1:
x_min_1 = 728;
x_max_1 = 1619;
y_min_1 = 359;
y_max_1 = 1202;

%for image 2:
x_min_2 = 728;
x_max_2 = 1619;
y_min_2 = 362;
y_max_2 = 1196;

matches_r = [];

for i = 1:length(matches)
    
    m_1 = matches(1,i);
    m_2 = matches(2,i);
    
   if x_min_1 <= f1(1,m_1) && f1(1,m_1) <= x_max_1 ... 
           && y_min_1 <= f1(2,m_1) && f1(2,m_1) <= y_max_1 ...
           && x_min_2 <= f2(1,m_2) && f2(1,m_2) <= x_max_2 ...
           && y_min_2 <= f2(2,m_2) && f2(2,m_2) <= y_max_2
      matches_r = [matches_r, matches(:,i)];
   end
    
end

%display image and plot feature points
% figure('Name','Image 1 reduced');
% I = insertMarker(im1,[f1(1,matches_r(1,:)).',f1(2,matches_r(1,:)).'],'o','color','yellow','size',1);
% imshow(I)
% 
% figure('Name','Image 2 reduced');
% I = insertMarker(im1,[f2(1,matches_r(2,:)).',f2(2,matches_r(2,:)).'],'o','color','yellow','size',1);
% imshow(I)


%% non-normalized eight-point algo
%pick 8 random matches to ensure that matches are well distributed 
point_ind = randsample(length(matches_r),8);

eightp_m = matches_r(:,point_ind);

eightp_1 = f1(:,eightp_m(1,:));
eightp_2 = f2(:,eightp_m(2,:));

%construct the A matrix, x is im1 and x' is im2 (referring to manual
%notation)
x_1 = eightp_1(1,:);
y_1 = eightp_1(2,:);
x_2 = eightp_2(1,:);
y_2 = eightp_2(2,:);

A = [];
for i=1:8
    
    l = [x_1(i)*x_2(i) x_1(i)*y_2(i) x_1(i) y_1(i)*x_2(i) y_1(i)*y_2(i) ...
        y_1(i) x_2(i) y_2(i) 1];
    A = [A;l];
    
end

[U,S,V] = svd(A);

%the smallest singular value is in the 8th column of V, because the
%singular values are ordered from big to small (from left to right), but
%there are only 8 singular values (matrix A only rank 8)
F_c = V(:,8);

F = [F_c(1) F_c(2) F_c(3); F_c(4) F_c(5) F_c(6); F_c(7) F_c(8) F_c(9)].';

%enforce the singularity of F: set smallest singular value (=third value in
%third column, because values ordered) to zero
[U_f,S_f,V_f] = svd(F);

S_f(3,3) = 0;

F = U_f .* S_f .* V_f.';

%% display epipolar lines for a point

%pick a random point from matches_r
m_rand = matches_r(:,randsample(length(matches_r),1));

epiLine = epipolarLine(F,[f1(1,m_rand(1)),f1(2,m_rand(1))]);
points = lineToBorderPoints(epiLine,size(im2));

figure
title(sprintf('Matching point in %s',img1))
imshow(im1)
hold on
plot(f1(1,m_rand(1)),f1(2,m_rand(1)),'r*')

figure
title(sprintf('Matching point and epipolar line in %s',img2))
imshow(im2)
hold on
plot(f2(1,m_rand(2)),f2(2,m_rand(2)),'r*')
line(points([1,3]),points([2,4]));

%% normalized eight-point algo with RANSAC

