function A = build_A(f1,f2)
%build_A builds the A matrix for the eight-point-algo from a set
%of matches between two images; f1 and f2 contain the matching feature points 
%of image 1 and 2 

%pick 8 random matches to ensure that matches are well distributed 
point_ind = randsample(length(f1),8);

eightp_1 = f1(:,point_ind);
eightp_2 = f2(:,point_ind);

%construct the A matrix, x is im1 and x' is im2 (referring to manual
%notation)
x_1 = eightp_1(1,:);
y_1 = eightp_1(2,:);
x_2 = eightp_2(1,:);
y_2 = eightp_2(2,:);

A = [];
for i=1:8
    
    l = [x_1(i)*x_2(i) x_1(i)*y_2(i) x_1(i) y_1(i)*x_2(i) y_1(i)*y_2(i) ...
        y_1(i) x_2(i) y_2(i) 1];
    A = [A;l];
    
end

end

