G=fspecial('gaussian',5,0.5);
I = imread('zebra.png');
zebra= rgb2gray(I);
zebraMatlabGauss=conv2(zebra,G,'same');
t = imgaussfilt(I,2);

figure, imshow(t)