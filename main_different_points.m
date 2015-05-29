warning('off', 'optim:fminunc:SwitchingMethod');
warning('off', 'MATLAB:singularMatrix');

iterations = 100;
variances = 0:0.000001:0.000025; % 0.005 ^2 = 0.000025
images = 1:30;

saveDirectories = char('out/lsv/', ...
                       'out/lsn/', ...
                       'out/vt/', ...
                       'out/sm/', ...
                       'out/sc/');
methods = char('least squares valstar', ...
               'least squares new', ...
               'valstar test', ...
               'statistical mixed', ...
               'statistical complete');

test_variance('iterations', iterations, ...
              'values', variances, ...
              'saveDirectories', saveDirectories, ...
              'methods', methods);

test_images('iterations', iterations, ...
            'values', images, ...
            'saveDirectories', saveDirectories, ...
            'methods', methods);

% warning('off', 'optim:fminunc:SwitchingMethod');
% warning('off', 'MATLAB:singularMatrix');
% 
% iterations = 1;
% variances = 0.001;
% images = 1;
% 
% iterations = 1000;
% variances = 0:0.0001:0.005;
% images = 1:30;
% 
% ls_headers = {'xaxis', 'f1', 'f2', 'b1', 'b2'};
% stat_headers = {'xaxis', 'f1', 'f2', 'b1', 'b2', 'variance'};
% 
% sd = 'out/least_squares_new/';
% display('least squares new (images):');
% [img_lsn_f1, img_lsn_f2, img_lsn_b1, img_lsn_b2, ~] = ...
%   test_images('iterations', iterations, 'values', images, 'methods', 'least squares new', 'saveDirectories', sd);
% display('least squares new (variance):');
% [var_lsn_f1, var_lsn_f2, var_lsn_b1, var_lsn_b2, ~] = ...
%   test_variance('iterations', iterations, 'values', variances, 'methods', 'least squares new', 'saveDirectories', sd);
% 
% images_lsn = [images', img_lsn_f1' , img_lsn_f2' , img_lsn_b1' , img_lsn_b2'];
% variance_lsn = [variances', var_lsn_f1' , var_lsn_f2' , var_lsn_b1' , var_lsn_b2'];
% 
% csvwrite_with_headers('out/images_lsn.csv', images_lsn, ls_headers);
% csvwrite_with_headers('out/variance_lsn.csv', variance_lsn, ls_headers);
% 
% sd = 'out/least_squares_valstar/';
% display('least squares valstar (images):');
% [img_lsv_f1, img_lsv_f2, img_lsv_b1, img_lsv_b2, ~] = ...
%   test_images('iterations', iterations, 'values', images, 'methods', 'least squares valstar', 'saveDirectories', sd);
% display('least squares valstar (variance):');
% [var_lsv_f1, var_lsv_f2, var_lsv_b1, var_lsv_b2, ~] = ...
%   test_variance('iterations', iterations, 'values', variances, 'methods', 'least squares valstar', 'saveDirectories', sd);
% 
% images_lsv = [images', img_lsv_f1' , img_lsv_f2' , img_lsv_b1' , img_lsv_b2'];
% variance_lsv = [variances', var_lsv_f1' , var_lsv_f2' , var_lsv_b1' , var_lsv_b2'];
% 
% csvwrite_with_headers('out/images_lsv.csv', images_lsv, ls_headers);
% csvwrite_with_headers('out/variance_lsv.csv', variance_lsv, ls_headers);
% 
% sd = 'out/statistical_complete/';
% display('statistical complete (images):');
% [img_statC_f1, img_statC_f2, img_statC_b1, img_statC_b2, img_varianceC] = ...
%   test_images('iterations', iterations, 'values', images, 'methods', 'statistical complete', 'saveDirectories', sd);
% display('statistical complete (variance):');
% [var_statC_f1, var_statC_f2, var_statC_b1, var_statC_b2, var_varianceC] = ...
%   test_variance('iterations', iterations, 'values', variances, 'methods', 'statistical complete', 'saveDirectories', sd);
% 
% images_statC = [images', img_statC_f1' , img_statC_f2' , img_statC_b1' , img_statC_b2' , img_varianceC'];
% variance_statC = [variances', var_statC_f1' , var_statC_f2' , var_statC_b1' , var_statC_b2' , var_varianceC'];
% 
% csvwrite_with_headers('out/images_stat_complete.csv', images_statC, stat_headers);
% csvwrite_with_headers('out/variance_stat_complete.csv', variance_statC, stat_headers);
% 
% sd = 'out/statistical/';
% display('statistical (images):');
% [img_stat_f1, img_stat_f2, img_stat_b1, img_stat_b2, img_variance] = ...
%   test_images('iterations', iterations, 'values', images, 'methods', 'statistical', 'saveDirectories', sd);
% display('statistical (variance):');
% [var_stat_f1, var_stat_f2, var_stat_b1, var_stat_b2, var_variance] = ...
%   test_variance('iterations', iterations, 'values', variances, 'methods', 'statistical', 'saveDirectories', sd);
% 
% images_stat = [images', img_stat_f1' , img_stat_f2' , img_stat_b1' , img_stat_b2' , img_variance'];
% variance_stat = [variances', var_stat_f1' , var_stat_f2' , var_stat_b1' , var_stat_b2' , var_variance'];
% 
% csvwrite_with_headers('out/images_stat.csv', images_stat, stat_headers);
% csvwrite_with_headers('out/variance_stat.csv', variance_stat, stat_headers);
% 
% test_valstar('iterations', iterations, 'images', images, 'variances', variances);