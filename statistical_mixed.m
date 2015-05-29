function [ y1, y2, variance ] = statistical_mixed( image1, image2, markers, h )
%statistical

% find estimated position of focus points by using least squares
n = size(markers, 1);
F1 = least_squares_valstar(markers, image1);
F2 = least_squares_valstar(markers, image2);
F1 = F1(n+1:n+3);
F2 = F2(n+1:n+3);
F = [F1' , F2'];

options = optimoptions(@fminunc, 'Display', 'off', 'algorithm', 'quasi-newton');
exp = @(x) statistical_mixed_expression(x, image1, image2, markers, h);
% sqt(0.005^2 / 2) = 0.003535534
y = fminunc(exp, [003535534, F], options);
y1 = y(2:4)';
y2 = y(5:7)';
variance = y(1)^2;

end

