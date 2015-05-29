function [ x ] = least_squares_valstar( endPoints, startPoints)
%least_squares Genereates matrix A and b and uses least squares to solve for x

n = size(endPoints, 1);
v = (endPoints - startPoints)';
A = zeros(n);
for i = 1:n
  j = 3 * (i - 1) + 1;
  A(j:j+2,i) = v(:,i);
end
A(:,n+1:n+3) = repmat(eye(3), n, 1);
b = reshape(endPoints', 3*n, 1);
x = A\b;

end