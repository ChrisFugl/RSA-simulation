function [ y1, y2 ] = valstar_minimize( image1, image2, markers )

% find estimated position of focus points by using least squares
F1 = least_squares_valstar(markers, image1);
F2 = least_squares_valstar(markers, image2);
n = size(markers, 1);

a1 = F1(1:n);
a2 = F2(1:n);
F1 = F1(n+1:n+3);
F2 = F2(n+1:n+3);

%exp1 = @(x) valstar_expression(x, image1, markers);
%exp2 = @(x) valstar_expression(x, image2, markers);

exp1 = @(x) valstar_gradient(x, image1, markers);
exp2 = @(x) valstar_gradient(x, image2, markers);

options = optimoptions(@fminunc, 'Display', 'off', 'GradObj', 'on', 'algorithm', 'quasi-newton');
x1 = fminunc(exp1, [a1 ; F1], options);
x2 = fminunc(exp2, [a2 ; F2], options);

y1 = x1(n+1:n+3);
y2 = x2(n+1:n+3);

end

