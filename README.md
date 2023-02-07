# Blurry_Spike_Trains

@author Adam D. Vareberg

This release provides the Matlab scripts necessary for generating and processing the learning data from the following manuscript:
https://doi.org/10.1101/2022.10.20.513050

Directories:

Binary\ - Contains scripts required to generate binary spike trains, the main method for learning presynaptic weights with this data, and all necessary support functions

InVitro\ - Contains scripts required to process microelectrode array recordings, the main method for learning presynaptic weights with this data, and all necessary support functions

\model_function\ - Within each parent directory, contains the relevant helper methods and scripts to generate and process presynaptic data

Files:
Within each of the above directories are two main functions containing synonymous prefixes.

iteration_test_*.m - Setup for the learning environment, where the user defines learning parameters and data and save locations. This script will call the adapted percetron script.

fit_weights_perceptron*.m - Adapted perceptron algorithm, which takes the relevant parameters and iteratively processes binary data as time-binned data

For help or more detailed descriptions, please contact the author.
