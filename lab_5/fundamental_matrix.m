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
f1_m = f1(:,matches_r(1,:));
f2_m = f2(:,matches_r(2,:));

A = build_A(f1_m, f2_m);

F = get_F(A);

%% display epipolar lines for a point with non-normalized eight_point algo

% %pick a random point from matches_r
% m_rand = matches_r(:,randsample(length(matches_r),1));
% 
% epiLine = epipolarLine(F,[f1(1,m_rand(1)),f1(2,m_rand(1))]);
% points = lineToBorderPoints(epiLine,size(im2));
% 
% figure
% title(sprintf('Matching point in %s',img1))
% imshow(im1)
% hold on
% plot(f1(1,m_rand(1)),f1(2,m_rand(1)),'r*')
% 
% figure
% title(sprintf('Matching point and epipolar line in %s',img2))
% imshow(im2)
% hold on
% plot(f2(1,m_rand(2)),f2(2,m_rand(2)),'r*')
% line(points([1,3]),points([2,4]));

%% normalized eight-point algo with RANSAC
%first normalize the matching points from f1 and f2 to zero mean and 
%average distance sqrt(2)

%do it for f1
[f1_m_xnorm, f1_m_ynorm, T_1] = norm_points(f1_m(1,:), f1_m(2,:));
f1_m_norm = [f1_m_xnorm; f1_m_ynorm];

%do it for f2
[f2_m_xnorm, f2_m_ynorm, T_2] = norm_points(f2_m(1,:), f2_m(2,:));
f2_m_norm = [f2_m_xnorm; f2_m_ynorm];

%construct the A matrix
A_norm = build_A(f1_m_norm,f2_m_norm);

F_norm = get_F(A_norm);

%denormalize
F_denorm = T_2.'*F_norm*T_1;

%% display epipolar lines for a point with normalized eight_point algo

% %pick a random point from matches_r
% m_rand = matches_r(:,randsample(length(matches_r),1));
% 
% epiLine = epipolarLine(F_denorm,[f1(1,m_rand(1)),f1(2,m_rand(1))]);
% points = lineToBorderPoints(epiLine,size(im2));
% 
% figure
% title(sprintf('Matching point in %s, norm algo',img1))
% imshow(im1)
% hold on
% plot(f1(1,m_rand(1)),f1(2,m_rand(1)),'r*')
% 
% figure
% title(sprintf('Matching point and epipolar line in %s, norm algo',img2))
% imshow(im2)
% hold on
% plot(f2(1,m_rand(2)),f2(2,m_rand(2)),'r*')
% line(points([1,3]),points([2,4]));

%% normalized eight-point algo with RANSAC

num_iter = 50;
thresh = 3000;

F_best = [];
num_inliers_best = 0;

f1_m_hom = [f1_m(1,:);f1_m(2,:); ones(1, length(f1_m))];
f2_m_hom = [f2_m(1,:);f2_m(2,:); ones(1, length(f2_m))];

for i=1:num_iter
    
    %construct the A matrix, build_A selects 8 random matches
    A_norm_i = build_A(f1_m_norm,f2_m_norm);
    F_norm_i = get_F(A_norm_i);

    %denormalize
    F_denorm_i = T_2.'*F_norm_i*T_1;
    
    %find number of inliers with this F
    num_inliers_i = 0;
    
    d_tot_s = 0;
    
    for s=1:length(f1_m_hom)
        
        F_ps = F_denorm_i * f1_m_hom(:,s);
        F_T_ps = F_denorm_i.' * f1_m_hom(:,s);
        
        d_s = (f2_m_hom(:,s).'*F_denorm_i*f1_m_hom(:,s))^2 / ...
            (F_ps(1)^2 + F_ps(2)^2 + F_T_ps(1)^2 + F_T_ps(2)^2);
        
        if d_s < thresh 
            num_inliers_i = num_inliers_i + 1;
        end
        
    end
    
    %if the number of inliers is greater than the number of inliers of the
    %best F found before, we save this F as the new best one
    if num_inliers_i > num_inliers_best
        F_best = F_denorm_i; 
    end
    
    
end

%% display epipolar lines for a point with normalized eight_point algo with RANSAC

%pick a random point from matches_r
m_rand = matches_r(:,randsample(length(matches_r),1));

epiLine = epipolarLine(F_best,[f1(1,m_rand(1)),f1(2,m_rand(1))]);
points = lineToBorderPoints(epiLine,size(im2));

figure
title(sprintf('Matching point in %s, norm algo',img1))
imshow(im1)
hold on
plot(f1(1,m_rand(1)),f1(2,m_rand(1)),'r*')

figure
title(sprintf('Matching point and epipolar line in %s, norm algo',img2))
imshow(im2)
hold on
plot(f2(1,m_rand(2)),f2(2,m_rand(2)),'r*')
line(points([1,3]),points([2,4]));




