function [ x ] = least_squares_new( endPoints, startPoints )
%least_squares Genereates matrix A and b and uses least squares to solve for x

v = endPoints - startPoints;
n = size(v, 1);
vn = zeros(n,1);
for i = 1:n
  vn(i) = norm(v(i,:),2);
end
A = zeros(3*n,3);
b = zeros(3*n,1);
id3 = eye(3);
for i = 1:n
  k = 3 * i;
  j = k - 2;
  tmp = (1/vn(i)^2) * v(i,:)' * v(i,:) - id3;
  A(j:k,:) = tmp;
  b(j:k) = tmp * startPoints(i,:).';
end
x = A\b;

end

