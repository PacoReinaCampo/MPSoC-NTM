# Specify the minimum version for CMake

cmake_minimum_required(VERSION 2.8.10)

option(RISCV64_OpenNN "Build OpenNN on RISC-V" OFF)

if(RISCV64_OpenNN)
    set(CMAKE_CXX_STANDARD 11)
    set(CPACK_GENERATOR "TGZ")

    set(CMAKE_SYSTEM_NAME Generic)
    set(CMAKE_SYSTEM_PROCESSOR riscv)
    set(CMAKE_CXX_COMPILER "riscv64-unknown-elf-g++")
    set(CMAKE_C_COMPILER "riscv64-unknown-elf-gcc")
    set(CMAKE_ASM_COMPILER "riscv64-unknown-elf-gcc")
endif(RISCV64_OpenNN)

# Project's name

project(opennn)

add_library(opennn 
adaptive_moment_estimation.cpp
bounding_layer.cpp
conjugate_gradient.cpp
convolutional_layer.cpp
correlations.cpp
cross_entropy_error.cpp
data_set.cpp
functions.cpp
genetic_algorithm.cpp
gradient_descent.cpp
growing_inputs.cpp
incremental_neurons.cpp
inputs_selection.cpp
k_means.cpp
layer.cpp
learning_rate_algorithm.cpp
levenberg_marquardt_algorithm.cpp
long_short_term_memory_layer.cpp
loss_index.cpp
mean_squared_error.cpp
metrics.cpp
minkowski_error.cpp
model_selection.cpp
neural_network.cpp
neurons_selection.cpp
normalized_squared_error.cpp
numerical_differentiation.cpp
opennn_strings.cpp
optimization_algorithm.cpp
perceptron_layer.cpp
pooling_layer.cpp
principal_components_layer.cpp
probabilistic_layer.cpp
pruning_inputs.cpp
#pybind.cpp
quasi_newton_method.cpp
recurrent_layer.cpp
response_optimization.cpp
scaling_layer.cpp
statistics.cpp
stochastic_gradient_descent.cpp
sum_squared_error.cpp
testing_analysis.cpp
tinyxml2.cpp
training_strategy.cpp
transformations.cpp
unit_testing.cpp
unscaling_layer.cpp
weighted_squared_error.cpp
)

