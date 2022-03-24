#!/bin/bash
# this is an example shell script
# <--- this symbol here identifies a comment
# Before executing the first time, you need to run
# chmod +x example_shell_script.sh
# afterwards you can execute it with
# ./Fully_Sampled_Slice_Extraction.sh

echo "Hello World and Goodbye Cruel World!!!!!"
cd
cd bart/
. startup.sh
# starting up Bart
bart twixread -A /home/andreas/bart/My_heart_data/Andreas/Fully_sampled-meas_MID00100_FID00088_ufssfp_inv.dat full_data
#reading raw Siemens data
bart show -m full_data
#full_data overview
bart poisson -Y 288 -y 2 -Z 150 -C 12 tmp_poisson
#undersampling pattern
bart fmac full_data poisson undersampled_data
#applying pattern to the fully sampled data
bart fft -i -u `bitmask 0 1` undersampled_data under_simple_recon
bart rss `bitmask 3` under_simple_recon under_simple_recon_rss
bart fft -i -u `bitmask 0 1` full_data full_recon
bart rss `bitmask 3` full_recon full_recon_rss
bart slice 10 4 full_recon_rss full_fifth_slice
bart slice 10 4 under_simple_recon_rss under_fifth_slice
bart toimg full_fifth_slice full_fifth
bart toimg under_fifth_slice under_fifth
#reconstruct and compare 5th temporal slice of full and undersampled data
bart ecalib -m1 full_data sens_maps_full
#Sensitivity maps from the full data
bart ecalib -m1 undersampled_data sens_maps_under
#Sensitivity maps from the undersampled data
bart pics -S -l2 -r0.005 -i 100 undersampled_data sens_maps_full l2_recon_fullmaps
#the recon with the undersampled sensitivity maps didn't work so I used the ones acquired from the fully sampled data
bart slice 10 4 l2_recon_fullmaps l2_recon_fullmaps_fifth_slice
bart toimg l2_recon_fullmaps_fifth_slice l2_recon_fifth
#save image for comparison
bart pics -R W:`bart bitmask 0 1`:0:0.005 -i 100 undersampled_data sens_maps_full l1_recon_fullmaps
#Reconstruction with l1-Wavelet regularization
bart slice 10 4 l1_recon_fullmaps l1_recon_fullmaps_fifth_slice
bart toimg l1_recon_fullmaps_fifth_slice l1_recon_fifth
#save image for comparison







