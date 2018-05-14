function F = get_F(A)
%get_F gets the fundamental matrix F from the A matrix

[~,~,V] = svd(A);

%the smallest singular value is in the 8th column of V, because the
%singular values are ordered from big to small (from left to right), but
%there are only 8 singular values (matrix A only rank 8)
F_c = V(:,8);

F = [F_c(1) F_c(2) F_c(3); F_c(4) F_c(5) F_c(6); F_c(7) F_c(8) F_c(9)].';

%enforce the singularity of F: set smallest singular value (=third value in
%third column, because values ordered) to zero
[U_f,S_f,V_f] = svd(F);

S_f(3,3) = 0;

F = U_f .* S_f .* V_f.';


end

