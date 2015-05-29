function [ sum ] = statistical_complete_expression( x0, icmarkers1, icmarkers2, ibmarkers1, ibmarkers2, cmarkers, h )
%stat_exp

s = x0(1)^2;
R0 = reshape(x0(2:7), [3,2])';
B = reshape(x0(8:13), [3,2])';

F = @(x,R) x + ((h - x(3)) / (x(3) - R(3))) * (x - R);
mu = @(i,j,x) F(x(i,:), R0(j,:));

Sigma = s * eye(2);
exp1 = inv(Sigma);
exp2 = log(det(Sigma));

nc = size(cmarkers, 1);
nb = size(B, 1);

sum = 0;
for j = 1:2
  jIsOne = j == 1;
  for i = 1:nc
    exp3 = mu(i,j,cmarkers);
    exp3 = exp3(:,1:2);
    if jIsOne
      exp3 = icmarkers1(i,1:2) - exp3;
    else
      exp3 = icmarkers2(i,1:2) - exp3;
    end
    sum = sum + (0.5 * (exp3 * exp1 * exp3') + exp2);
  end
  for i = 1:nb
    exp3 = mu(i,j,B);
    exp3 = exp3(:,1:2);
    if jIsOne
      exp3 = ibmarkers1(i,1:2) - exp3;
    else
      exp3 = ibmarkers2(i,1:2) - exp3;
    end
    sum = sum + (0.5 * (exp3 * exp1 * exp3') + exp2);
  end
end

end