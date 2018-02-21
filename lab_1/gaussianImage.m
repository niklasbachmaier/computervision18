function imOut = gaussianImage(image_path , sigma_x , sigma_y)
    imIn = imread (image_path);
    im = im2double(imIn);
    if size(im,3) == 3
        im = rgb2gray(im); 
    end
    Gx= gaussianFilter(sigma_x);
    Gy= gaussianFilter(sigma_y);
    imOut = conv2(Gy,Gx,im,'same');
end