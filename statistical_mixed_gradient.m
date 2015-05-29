function [ fValue, fGradient ] = statistical_mixed_gradient( x0, y1, y2, markers, h )
%stat_exp

n0 = numel(x0);
R0 = reshape(x0(2:n0), [3,2])';

F = @(x,R) x + ((h - x(3)) / (x(3) - R(3))) * (x - R);
mu = @(i,j,x) F(x(i,:), R0(j,:));

sgm = x0(1);
s = sgm^2;
Sigma = s * eye(2);
exp1 = inv(Sigma);
exp2 = log(det(Sigma));

c1 = 4/sgm;

n = size(markers,1);
x = markers;
fValue = 0;
grad = zeros(n0, 1);
for j = 1:2
  gR1 = 0;
  gR2 = 0;
  gR3 = 0;
  for i = 1:n
    exp3 = mu(i,j,markers);
    exp3 = exp3(:,1:2);
    if j == 1
      exp3 = y1(i,1:2) - exp3;
    else
      exp3 = y2(i,1:2) - exp3;
    end
    fValue = fValue + (0.5 * (exp3 * exp1 * exp3') + exp2);
    grad(1) = grad(1) + sgm * (exp3 * exp3') + c1;
    c2 = (h - x(i,3)) / (x(i,3) - R0(j,3));
    c3 = - ((h - x(i,3)) / (x(i,3) - R0(j,3))^2);
    c4 = c3 * (x(i,1) - R0(j,1));
    c5 = c3 * (x(i,2) - R0(j,2));
    gR1 = gR1 + exp3(1) * c2;
    gR2 = gR2 + exp3(2) * c2;
    gR3 = gR3 + (exp3(1) * c4) + (exp3(2) * c5);
  end
  grad(3*j - 1) = s * gR1;
  grad(3*j) = s * gR2;
  grad(3*j + 1) = s * gR3;
end
fGradient = grad;

end