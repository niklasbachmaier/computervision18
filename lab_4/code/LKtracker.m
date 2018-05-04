% the Lukas Kanade Tracker:
% the initial points in the first frams are tracked. In the video
% 'tracked.avi' this is shown, where yellow dots are the ground truth and
% pink dots are the tracked points
%%%You can also not follow this instrcution and implement the tracker
%%%according to your own interpretation!
function [pointsx, pointsy] = LKtracker(p,im,sigma)

%pre-alocate point locations and image derivatives
pointsx = zeros(size(im,3),size(p,2));
pointsy = zeros(size(im,3),size(p,2));
pointsx(1,:) = p(1,:);
pointsy(1,:) = p(2,:);
%fill in starting points

It=zeros(size(im) - [0 0 1]);
Ix=zeros(size(im) - [0 0 1]);
Iy=zeros(size(im) - [0 0 1]);

%find x,y and t derivative
for i=1:size(im,3)-1
    Ix(:,:,i)= ImageDerivatives(im(:,:,i),sigma,'x','t');
    Iy(:,:,i)= ImageDerivatives(im(:,:,i),sigma,'y','t');
    It(:,:,i)= im(:,:,i) - im(:,:,i+1);
end

writerObj = VideoWriter('test.avi');
open(writerObj);

for num = 1:size(im,3)-1 % iterating through images
    for i = 1:size(p,2) % iterating throught points
        % make a matrix consisting of derivatives around the pixel location
        x = pointsx(num,i);                     %%%center of the patch
        y = pointsy(num,i);                    %%%center of the patch
        A1 = Ix(floor(y-7.5):floor(y+7.5),floor(x-7.5):floor(x+7.5),num);
        A2 = Iy(floor(y-7.5):floor(y+7.5),floor(x-7.5):floor(x+7.5),num);
        A = [A1(:),A2(:)];
        % make b matrix consisting of derivatives in time
        b = -It(floor(y-7.5):floor(y+7.5),floor(x-7.5):floor(x+7.5),num);
        b=b(:);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        v = pinv(A'*A) * A' * double(b);
        pointsx(num+1,i) = x + v(1);
        pointsy(num+1,i) = y + v(2);
    end
        figure(1)
        imshow(im(:,:,num),[])
        hold on
        plot(pointsx(num,:),pointsy(num,:),'.y') %tracked points
        plot(p(num*2-1,:),p(num*2,:),'.m')  %ground truth
        frame = getframe;
        writeVideo(writerObj,frame);
end
%close(writerObj);


end
