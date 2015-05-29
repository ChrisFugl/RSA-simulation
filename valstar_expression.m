function [ sum ] = valstar_expression( x, startPoints, endPoints )

n = size(endPoints, 1);
v = (endPoints - startPoints)';
A = zeros(n);
for i = 1:n
  j = 3 * (i - 1) + 1;
  A(j:j+2,i) = v(:,i);
end
A(:,n+1:n+3) = repmat(eye(3), n, 1);
b = reshape(endPoints', 3*n, 1);
sum = (A * x) - b;
sum = norm(sum);

end

