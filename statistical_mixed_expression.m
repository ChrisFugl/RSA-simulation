function [ sum ] = statistical_mixed_expression( x0, y1, y2, markers, h )
%stat_exp

n0 = numel(x0);
n = (n0 - 1) / 3;
R0 = reshape(x0(2:n0), [3,n])';

F = @(x,R) x + ((h - x(3)) / (x(3) - R(3))) * (x - R);
mu = @(i,j,x) F(x(i,:), R0(j,:));

s = x0(1)^2;
Sigma = s * eye(2);
exp1 = inv(Sigma);
exp2 = log(det(Sigma));

n = size(markers,1);
sum = 0;
for j = 1:2
  for i = 1:n
    exp3 = mu(i,j,markers);
    exp3 = exp3(:,1:2);
    if j == 1
      exp3 = y1(i,1:2) - exp3;
    else
      exp3 = y2(i,1:2) - exp3;
    end
    sum = sum + (0.5 * (exp3 * exp1 * exp3') + exp2);
  end
end

end