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
bart slice 10 0 FullySampled A_slice
# Extracting a slice of the temporal dimension to have just a 2D slice
bart show -m A_slice
bart cc -p 4 -G A_slice slice_cc
# Compress coils to four virtual ones
bart show -m slice_cc
# Having already computed the bart bitmask 0 1 (for the first two dimensions) I perform an inverse unitary fft
# need input on how to save the result in the view folder or how to copy/move it there or make viewer run from the current directory
bart fft -u -i 3 slice_cc image
bart show -m image

# bart bitmask for coil dimension is 8 so
bart rss 8 image final_image 
bart show -m final_image
# Go to viewer directory
cd
cd view/
./view final_image
