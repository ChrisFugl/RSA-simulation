function [ control_markers, bone_markers, focus_points, image1, image2, proj_height ] = setupRSA( filename )
% setupRSA: generates neccessary points to perform RSA simulation by reading
% input from a specified json file

% x is distance from eye
% y is horizontal distance
% z is height
% assumes that points in projected plane have same z-coordinate (height)
% assumes that points in control plane have same z-coordinate (height)

data = loadjson(filename);

control_markers = data.control_markers;
bone_markers = data.bone_markers;
focus_points = data.focus_points;
proj_height = data.projected_height;

% find projected control markers
n_control = size(control_markers, 1);
x = control_markers;
h = repmat(proj_height, n_control, 1);
R1 = repmat(focus_points(1,:), n_control, 1);
R2 = repmat(focus_points(2,:), n_control, 1);
lambda1 = (h - x(:,3)) ./ (x(:,3) - R1(:,3));
lambda2 = (h - x(:,3)) ./ (x(:,3) - R2(:,3));
pc1 = x + diag(lambda1) * (x - R1);
pc2 = x + diag(lambda2) * (x - R2);

% find projected bone markers
n_bone = size(bone_markers, 1);
x = bone_markers;
h = repmat(proj_height, n_bone, 1);
R1 = repmat(focus_points(1,:), n_bone, 1);
R2 = repmat(focus_points(2,:), n_bone, 1);
lambda1 = (h - x(:,3)) ./ (x(:,3) - R1(:,3));
lambda2 = (h - x(:,3)) ./ (x(:,3) - R2(:,3));
pb1 = x + diag(lambda1) * (x - R1);
pb2 = x + diag(lambda2) * (x - R2);

image1 = [];
image1.control_markers = pc1;
image1.bone_markers = pb1;

image2 = [];
image2.control_markers = pc2;
image2.bone_markers = pb2;
end