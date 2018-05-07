%imConv (image conversion) gets an image path and returns the image data
%converted to single and grayscale
function im2s = imConv(im_path)

im = imread (im_path);
im = im2double(im);
if size(im,3) == 3
 im = rgb2gray(im); 
end
im2s= im2single(im);

end