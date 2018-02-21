function imOut = imGrayscale(image_path) 

    imIn = imread (image_path);
    im = im2double(imIn);
    if size(im,3) == 3
        im = rgb2gray(im); 
    end
    
    imOut = im;

end