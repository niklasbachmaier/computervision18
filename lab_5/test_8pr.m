%script to test the eightPoint Ransac function

%% use bear images
%IMPORTANT: if other images than obj02_001.jpg and obj02_002.jpg, then
%procedure to manually discard background features has to be adapted
img1 = 'obj02_001.jpg';
img2 = 'obj02_002.jpg';

%get images to single
im1 = imConv(img1);
im2 = imConv(img2);

%extract feature points and descriptors
% [f1,d1]= vl_sift(im1,'FirstOctave',-1);
% [f2,d2]= vl_sift(im2,'FirstOctave',-1);
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

%% do the 8-point RANSAC

%number of iterations
iter = 300;
thresh = 40000;

%threshold for sampson distance

[p1_8pr,p2_8pr] = eightPointRansac(f1, f2, matches_r, iter, thresh);

%% plot the points in the 2 images

figure
title(sprintf('Matching point in %s, norm algo',img1))
imshow(im1)
hold on
plot(p1_8pr(1,:),p1_8pr(2,:),'r*')

figure
title(sprintf('Matching point in %s, norm algo',img1))
imshow(im2)
hold on
plot(p2_8pr(1,:),p2_8pr(2,:),'r*')

