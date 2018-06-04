%script for the final project

%% first extract feature points and their descriptors for all castle images

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


%% match the feature points between consecutive images

%the matches are stored in a cell where matches{1} are the matches of
%frames 1-2, matches{2} of 2-3, ... , matches{19} 19-1

for i=1:19
    
    im_1 = i;
    %important for the wraparound case 19-1
    if mod(i,19) == 0 
        im_2 = 1;
    else
        im_2 = i;
    end
    
    matches{i} = vl_ubcmatch(cell2mat(descriptors(im_1)),cell2mat(descriptors(im_2)));
    
end

%% reduce the matches with the eight-point RANSAC

%the meaning of the indices in matches_8pr is the same as before (i.e. 1
%for 1-2, ..., 19 for 19-1); at each index a matrix consisting of n
%columns is stored, where n is the number of matching points and each
%column is of this form: [x_im1; y_im1; i_im1; x_im2; y_im2; i_im2], here
%i_im1 and i_im2 refer to the indices the point has in the frames data

%setup for RANSAC
iter = 200;
thresh = 40000;

for i=1:19
    
    im_1 = i;
    %important for the wraparound case 19-1
    if mod(i,19) == 0 
        im_2 = 1;
    else
        im_2 = i;
    end
    
    p1 = cell2mat(frames(im_1));
    p2 = cell2mat(frames(im_2));
    
    m = cell2mat(matches(i));
    
    [p1_8pr,p2_8pr] = eightPointRansac(p1, p2, m, iter, thresh);
    
    matches_8pr{i} = [p1_8pr; p2_8pr];
    
end

%% build the point-view matrix




