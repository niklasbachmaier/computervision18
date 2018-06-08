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
        im_2 = i + 1;
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
        im_2 = i + 1;
    end
    
    p1 = cell2mat(frames(im_1));
    p2 = cell2mat(frames(im_2));
    
    m = cell2mat(matches(i));
    
    [p1_8pr,p2_8pr] = eightPointRansac(p1, p2, m, iter, thresh);
    
    matches_8pr{i} = [p1_8pr; p2_8pr];
    
end

%% build the point-view matrix and the matrix with XY points

%point_view matrix only has the indices of the points in the frames
%structure
PT_matrix = getPointView(matches_8pr);

XY_matrix = getXY(PT_matrix, frames);

%% try out stuff

start_frame = 19;
end_frame = 21; %use three consecutive frames
    
%indices gives the locations of the points contained in submatrix in
%the original XY_matrix
[submatrix, indices] = FindTrackablePoints(XY_matrix,start_frame,end_frame,19);
    
%do structure from motion 
points_3D = StructureFromMotion(submatrix);

%% extract subblocks and do structure from motion

%do it for three consecutive frames

%build a point-viewset matrix for the 19 viewsets (1-2-3, 2-3-4, ...,
%19-1-2)
point_viewset = zeros(19*3, length(XY_matrix));

for i=1:19
    
    start_frame = i;
    end_frame = i + 2; %use three consecutive frames; case end_frame > num_frame handled in FindTrackablePoints
    
    %indices gives the locations of the points contained in submatrix in
    %the original XY_matrix
    [submatrix, indices] = FindSubBlocks(XY_matrix,start_frame,end_frame,19);
    
    %do structure from motion 
    points_3D = StructureFromMotion(submatrix);
    
    %start index for adding to point_viewset
    s = i + (2*(i-1));
    
    %put the points in the point_viewset matrix
    for m=1:length(indices)
  
        point_viewset(s:s+2,indices(m)) = points_3D(:,m);
        
    end
    
end


%% use procrustes to transform all 3D points to 1 coord system
%reference coordinate system is the one of the first set (views 1-2-3)



