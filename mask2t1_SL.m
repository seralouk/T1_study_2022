%% setup the paths to t1 and to the mask
t1 = '/Users/loukas/Desktop/T1_study_2022/mp2rage_T0_08.nii';
mask = '/Users/loukas/Desktop/T1_study_2022/OBF_L_mask.nii';

%% read the headers and data
t1_header = spm_vol(t1);
t1_data = spm_read_vols(t1_header);

% mask_header = spm_vol(mask);
% mask_data = spm_read_vols(mask_header);

%% Wrap the mask into the T1 space
Vout = mapVolumeToVolume(mask,t1); % this wll take some minutes

%% Optional: save the mask in T1 space
t1_header.fname = '/Users/loukas/Desktop/T1_study_2022/maskINt1.nii'; % name of mask in T1 space
spm_write_vol(t1_header, Vout); % the mask in the T1 space
disp(' '); disp([' -> We have: ' num2str(nnz(mask2t1space)) ' voxels in the new mask' ]);disp(' ');

%% Optional check the registration
% spm_check_registration(t1, t1_header.fname);

%% Extract the intensity values

% make mask logical
mask2t1space = Vout(:);
mask_logical = logical(mask2t1space);

% apply logical mask to the T1 image
ndim = numel(t1_data);
t1_data_flat = reshape(t1_data, [ndim, 1]);

intensity_of_roi = t1_data_flat(mask_logical); % apply the mask to the T1 image

% sanity check
assert(size(intensity_of_roi,1) == nnz(mask2t1space));

% estimate mean intensity values within the mask
mean_intensity_of_roi = mean(intensity_of_roi);

%% Make plot
bar(mean_intensity_of_roi)
title('Mean T1 intensity value within the ROI/mask')
xlabel('') 
ylabel('Mean T1 intensity ') 

