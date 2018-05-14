function [x_coord_norm,y_coord_norm,T] = norm_points(x_coord,y_coord)
%norm_points normalizes the points with x_coord and y_coord to have zero
%   mean and average distance sqrt(2); also return the T matrix

points = [x_coord; y_coord];

sum_elem = sum(points,2);
m_x = (1/length(points)) * sum_elem(1);
m_y = (1/length(points)) * sum_elem(2);
d = sum(sqrt(((points(1,:) - m_x).^2 + (points(2,:) - m_y).^2)));

T = [sqrt(2)/d 0 -m_x*sqrt(2)/d; 0 sqrt(2)/d -m_y*sqrt(2)/d; 0 0 1];

%convert points to homogeneous coordinates and normalize
points_hom = [points; ones(1,length(points))];
points_hom_norm = transpose(transpose(points_hom) * transpose(T));

x_coord_norm = points_hom_norm(1,:);
y_coord_norm = points_hom_norm(2,:);

end

