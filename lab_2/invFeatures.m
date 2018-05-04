%this function calculates scale invariant harris corner points by comparing
%the laplacian of a value to the laplacians of all neighbours in a 3x3
%window in all scale levels

%INPUT: im is path of image of which to find scale invariant feature points
%OUTPUT: row and column indices of feature points in the image

function inv_feat = invFeatures(im)

sigmas = 1.2.^[0:12];

%get size of the image
imC = imread(im);
imC = im2double(imC);

if size(imC,3) == 3
    imC = rgb2gray(imC); 
end

[im_y,im_x]=size(imC);

%lapl is a tensor of size ( size_y(img) x size_x(img) x size(sigmas))
%at each position in a level it has the value of the 2D Laplacian gaussian
lapl = zeros(im_y, im_x, size(sigmas,2));

%laplmax is a tensor of size ( size_y(img) x size_x(img) x size(sigmas))
%at each level it includes the maximum value in a 3x3 window
laplmax = zeros(im_y, im_x, size(sigmas,2));

for i = 1:size(sigmas,2)
    
    Lx = sigmas(i)^2.*ImageDerivatives(im,sigmas(i),'xx','');
    Ly = sigmas(i)^2.*ImageDerivatives(im,sigmas(i),'yy',''); 
    
    L = Lx + Ly; 
    
    %calculate 
    lapl(:,:,i) = L;
    
    %find maximum in 3x3 window at the level by first computing movmax
    %for each row and then for each column
    
    L_rowmax = movmax(L,3,2);
    L_max = movmax(L_rowmax,3,1);
    
    laplmax(:,:,i) = L_max;
    
end

%inv_feat contains the final scale invariant feature points
inv_feat = [];
%discardedpoints keeps track of how many feature points where discarded for
%informative reasons
discardedpoints = 0;

%now get the feature points for each sigma level and only keep those
%feature points where the value of the laplacian is higher than the local
%maximum in all levels

for i = 1:size(sigmas,2)
    
    [r,c] = harris(im,sigmas(i));
    
    for p = 1:size(r,1)
        
        %try to find the sigma where the Laplacian for the keypoint has a
        %local maximum; if there is no local maximum (monotonically
        %increasing or decreasing function, discard the feature point
        for s = 2:(size(sigmas,2)-1)
        
            if lapl(r(p),c(p),s) == laplmax(r(p),c(p),s) && lapl(r(p),c(p),s) > laplmax(r(p),c(p),s-1) && lapl(r(p),c(p),s) > laplmax(r(p),c(p),s+1)
                %add point to final points
                inv_feat = cat(2,inv_feat,[r(p);c(p);sigmas(s)]);
            end
        end
        
    end
    
end

fprintf("Number of discarded feature points: %d",discardedpoints);

end