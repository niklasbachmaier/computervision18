function [magnitude , orientation] = gradmag(img , sigma)

    %first blur the image with our 2D-gaussian
    blurIm = gaussianImage(img,sigma,sigma);
    
    %then get magnitude and orientation with the built-in Matlab function
    [magnitude,orientation] = imgradient(blurIm);

end