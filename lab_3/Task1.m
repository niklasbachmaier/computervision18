image_path_1 = 'img1.pgm';
image_path_2 = 'img2.pgm';

%read image 1 and 2
imIn1 = imread (image_path_1);
im1 = im2single(imIn1);
if size(im1,3) == 3
    im1 = rgb2gray(im1); 
end

imIn2 = imread (image_path_2);
im2 = im2single(imIn1);
if size(im2,3) == 3
    im2 = rgb2gray(im2); 
end

[frames1, desc1]=vl_sift(im1);
[frames2, desc2]=vl_sift(im2);
[matches] = vl_ubcmatch(desc1,desc2);

frames1 = [transpose(frames

I1 = insertMarker(im1,frames1,'o','color','yellow','size',1);
I2 = insertMarker(im2,frames2,'o','color','yellow','size',1);

imshow(I1)
imshow(I2)