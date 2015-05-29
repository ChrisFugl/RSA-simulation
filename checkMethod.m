function [ isAcceptedMethods ] = checkMethod( methods )

validMethods = {'least squares valstar', ...
                'least squares new', ...
                'statistical mixed', ...
                'valstar test', ...
                'statistical complete'};

cm_helper = @(x) any(validatestring(x, validMethods));
n = size(methods, 1);
isAcceptedMethods = true;
for i = 1:n
  isAcceptedMethods = isAcceptedMethods && cm_helper(strtrim(methods(i,:)));
end

end

