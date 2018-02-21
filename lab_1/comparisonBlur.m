function comparisonBlur(sigma)

figure

G=fspecial('gaussian',1000,sigma);

%first do the pn1 image
pn1ourGauss = gaussianImage('pn1.jpg',sigma,sigma);
pn1 = imread('pn1.jpg');
pn1 = im2double(pn1);
pn1matlabGauss=conv2(pn1,G,'same');

subplot(2,2,1)
imshow(pn1matlabGauss)
title(sprintf('Matlab pn1.jpg, sigma %0.4f',sigma))

subplot(2,2,2)
imshow(pn1ourGauss)
title(sprintf('We pn1.jpg, sigma %0.4f',sigma))

%now zebra image
zebraOurGauss = gaussianImage('zebra.png',sigma,sigma);
G=fspecial('gaussian',1000,sigma);
zebra = imread('zebra.png');
zebra = im2double(zebra);
zebra= rgb2gray(zebra);
zebraMatlabGauss=conv2(zebra,G,'same');

subplot(2,2,3)
imshow(zebraMatlabGauss)
title(sprintf('Matlab zebra.png, sigma %0.4f',sigma))

subplot(2,2,4)
imshow(zebraOurGauss)
title(sprintf('We zebra.png, sigma %0.4f',sigma))

end