imIn = imread ('landscape-a.jpg');
    im = im2double(imIn);

    if size(im,3) == 3
        im = rgb2gray(im); 
    end
    
    size(im)