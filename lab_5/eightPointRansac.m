function [p1_8pr,p2_8pr] = eightPointRansac(p1, p2, matches, iter, thresh)
%eightPointRansac gets feature points in 2 images and the indices of
%the matching points and puts out the points that are inliers with 
%the fundamental matrix constraint; it also gets the number of iterations
%it should perform and the threshold for the Sampson distances
%the output for each of the two images:
%[x,y,i] where x and y are the coordinate of the point and i refers to the
%index the point had in the original points input

%matching points
p1_m = p1(:,matches(1,:));
p2_m = p2(:,matches(2,:));

%normalize points
[p1_m_xnorm, p1_m_ynorm, T_1] = norm_points(p1_m(1,:), p1_m(2,:));
p1_m_norm = [p1_m_xnorm; p1_m_ynorm];

[p2_m_xnorm, p2_m_ynorm, T_2] = norm_points(p2_m(1,:), p2_m(2,:));
p2_m_norm = [p2_m_xnorm; p2_m_ynorm];

%homogeneous points
p1_m_hom = [p1_m(1,:);p1_m(2,:); ones(1, length(p1_m))];
p2_m_hom = [p2_m(1,:);p2_m(2,:); ones(1, length(p2_m))];

%8-point-ransac
num_inliers_best = 0;

p1_8pr = [];
p2_8pr = [];

for i=1:iter
    
    %construct the A matrix, build_A selects 8 random matches
    A_norm_i = build_A(p1_m_norm,p2_m_norm);
    F_norm_i = get_F(A_norm_i);

    %denormalize
    F_denorm_i = T_2.'*F_norm_i*T_1;
    
    %find number of inliers with this F
    num_inliers_i = 0;
    
    p1_8pr_i = [];
    p2_8pr_i = [];
    
    for s=1:length(p1_m_hom)
        
        F_ps = F_denorm_i * p1_m_hom(:,s);
        F_T_ps = F_denorm_i.' * p1_m_hom(:,s);
        
        d_s = (p2_m_hom(:,s).'*F_denorm_i*p1_m_hom(:,s))^2 / ...
            (F_ps(1)^2 + F_ps(2)^2 + F_T_ps(1)^2 + F_T_ps(2)^2);
        
        if d_s < thresh 
            num_inliers_i = num_inliers_i + 1;
            
            %also collect the final matches 
            p1_8pr_i = [[p1_m(1,s); p1_m(2,s); matches(1,s)], p1_8pr_i];
            p2_8pr_i = [[p2_m(1,s); p2_m(2,s); matches(2,s)], p2_8pr_i];

        end
        
    end
    
    %if the number of inliers is greater than the number of inliers of the
    %best F found before, we save this F as the new best one
    if num_inliers_i > num_inliers_best
        num_inliers_best = num_inliers_i;
        p1_8pr = p1_8pr_i;
        p2_8pr = p2_8pr_i;
    end
     
    
end


end

