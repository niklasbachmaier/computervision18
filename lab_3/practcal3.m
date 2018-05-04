
clear all
 imIn1 = imread ('img1.pgm');
    im = im2double(imIn1);
    size(imIn1)
    if size(im,3) == 3
        im = rgb2gray(im); 
    end
img1= im2single(im);

imIn2 = imread ('img2.pgm');
    im2 = im2double(imIn2);
    size(imIn2)
    if size(im2,3) == 3
        im2 = rgb2gray(im2); 
    end
    
img2= im2single(im2);


[fa,d1]= vl_sift(img1);

[fb,d2]= vl_sift(img2);

[matches, scores] = vl_ubcmatch(d1, d2) ;

max(max(matches))

xa = fa(1,matches(1,:));
ya = fa(2,matches(1,:));
xb = fb(1,matches(2,:));
yb = fb(2,matches(2,:));

%% find best parameters

old_inliers = 0;
final_param = [];

for m = 1:100

perm=randperm(length(matches));
seed= perm(1:3);
for i=1:3
xa1(i) = fa(1,matches(1,seed(i)));
ya1(i) = fa(2,matches(1,seed(i)));
xb1(i) = fb(1,matches(2,seed(i)));
yb1(i) = fb(2,matches(2,seed(i)));
end

A=[xa1(1) ya1(1) 0 0 1 0; 0 0 xa1(1) ya1(1) 0 1;xa1(2) ya1(2) 0 0 1 0; 0 0 xa1(2) ya1(2) 0 1;xa1(3) ya1(3) 0 0 1 0; 0 0 xa1(3) ya1(3) 0 1];
b=[xb1(1);yb1(1);xb1(2);yb1(2);xb1(3);yb1(3)];
param= pinv(A)*b;

transformed = [];

for z=1:length(matches)
    A_trans=[xa(z) ya(z) 0 0 1 0; 0 0 xa(z) ya(z) 0 1];
    b_prime= A_trans*param;
    transformed=[transformed, b_prime];
end

inliers = find(sqrt(sum(([xb; yb] - transformed).^2)) < 10);

new_inliers = length(inliers);

if new_inliers > old_inliers
    
    old_inliers = new_inliers;
    final_param = param;
    
end

end

%% do transformation with best parameters
final_transformed = [];

for z=1:length(matches)
    A_trans=[xa(z) ya(z) 0 0 1 0; 0 0 xa(z) ya(z) 0 1];
    b_prime= A_trans*param;
    final_transformed=[final_transformed, b_prime];
end


% 
imshow(im)
hold on
plot(xa, ya, 'r*', 'LineWidth', 2, 'MarkerSize', 5)
title('matching keypoints')

figure
imshow(im2)
hold on
x_trans = transformed(1,:);
y_trans = transformed(2,:);
plot(x_trans, y_trans, 'r*', 'LineWidth', 2, 'MarkerSize', 5)
title('transformed points')

%% transorm with transormation procedure given in assignment

T = [final_param(1) final_param(2) final_param(5); final_param(3) final_param(4) final_param(6); 0 0 1];

tform = maketform('affine', T');
image1_transformed = imtransform(im,tform, 'bicubic');

tform = maketform('affine', inv(T)' );
image2_transformed = imtransform(im2,tform, 'bicubic');

figure
imshow(image1_transformed)

figure
imshow(image2_transformed)
%% plot lines

% figure(2) ; clf ;
% imagesc(cat(2, im, im2)) ;
%  
% hold on ;
% h = line([xa ; xb], [ya ; yb]) ;
% set(h,'linewidth', 0.1, 'color', 'b') ;
% 
% vl_plotframe(fa(:,matches(1,:))) ;
% fb(1,:) = fb(1,:) + size(im,2) ;
% vl_plotframe(fb(:,matches(2,:))) ;
% axis image off ;


