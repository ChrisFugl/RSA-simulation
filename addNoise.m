function [ image1, image2 ] = addNoise(std, image1, image2, withNoiseLimit)

variance = sqrt(std);
n_control = size(image1.control_markers, 1);
n_bone = size(image1.bone_markers, 1);

if withNoiseLimit
  limit = 1;
  noise1_control = variance * min(max(randn(n_control, 2), -limit), limit);
  noise1_bone = variance * min(max(randn(n_bone, 2), -limit), limit);
  noise2_control = variance * min(max(randn(n_control, 2), -limit), limit);
  noise2_bone = variance * min(max(randn(n_bone, 2), -limit), limit);
else
  noise1_control = variance * randn(n_control, 2);
  noise1_bone = variance * randn(n_bone, 2);
  noise2_control = variance * randn(n_control,2);
  noise2_bone = variance * randn(n_bone, 2);
end

image1.control_markers(:,1:2) = image1.control_markers(:,1:2) + noise1_control;
image1.bone_markers(:,1:2) = image1.bone_markers(:,1:2) + noise1_bone;
image2.control_markers(:,1:2) = image2.control_markers(:,1:2) + noise2_control;
image2.bone_markers(:,1:2) = image2.bone_markers(:,1:2) + noise2_bone;

end

