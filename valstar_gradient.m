function [ fValue, fGradient ] = valstar_gradient( x, startPoints, endPoints )

n = size(endPoints, 1);
v = (endPoints - startPoints)';
A = zeros(n);
for i = 1:n
  j = 3 * (i - 1) + 1;
  A(j:j+2,i) = v(:,i);
end
A(:,n+1:n+3) = repmat(eye(3), n, 1);
b = reshape(endPoints', 3*n, 1);
minimizeVec = (A * x) - b;
sum = norm(minimizeVec);

dSum = 0;
for i = 1:n
  dSum = dSum + minimizeVec(i);
end

fValue = sum;
grad = - (1/2) * (1/sum) * (2 * dSum);
fGradient = zeros(1,n+3);
for i = 1:n+3
  fGradient(i) = grad * x(i);
end

end


