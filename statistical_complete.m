function [ F1, F2, B1, B2, variance ] = statistical_complete( image1, image2, cmarkers, h )
%statistical complete

% find estimated position of focus points by using least squares
b1_est = [image1.bone_markers(1,:) ; image2.bone_markers(1,:)];
b2_est = [image1.bone_markers(2,:) ; image2.bone_markers(2,:)];

n = size(cmarkers, 1);
F1 = least_squares_valstar(cmarkers, image1.control_markers);
F1 = F1(n+1:n+3);
F2 = least_squares_valstar(cmarkers, image2.control_markers);
F2 = F2(n+1:n+3);
F = [F1.' ; F2.'];
n = size(F, 1);
B1 = least_squares_valstar(F, b1_est);
B1 = B1(n+1:n+3);
B2 = least_squares_valstar(F, b2_est);
B2 = B2(n+1:n+3);

options = optimoptions(@fminunc, 'Display', 'off', 'algorithm', 'quasi-newton');
exp = @(x) statistical_complete_expression(x, ...
                                           image1.control_markers, ...
                                           image2.control_markers, ...
                                           image1.bone_markers, ...
                                           image2.bone_markers, ...
                                           cmarkers, ...
                                           h);

% sqt(0.005^2 / 2) = 0.003535534
y = fminunc(exp, [0.003535534, F1', F2', B1', B2'], options);

variance = y(1)^2;
F1 = y(2:4)';
F2 = y(5:7)';
B1 = y(8:10)';
B2 = y(11:13)';

end

