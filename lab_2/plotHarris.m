%display image with corners
function plotHarris(im, sigma) 

I = imread(im);

[r,c] = harris(im, sigma);

pos = [r,c];

I = insertMarker(I,pos,'o','color','yellow','size',1);

imshow(I)

end