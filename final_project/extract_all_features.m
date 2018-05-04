%this script extracts the feature points frames and descriptors of
%all castle images and saves them in frames and descriptors variables

for i=1:19
    
    file_path = sprintf('model_castle/%d.JPG',i);
    
    im = imread(file_path);
    im = im2single(im);
    if size(im,3) == 3
        im = rgb2gray(im); 
    end
    
    [f, d] = vl_sift(im);
    
    frames{i} = f;
    descriptors{i} = d;
    
end
