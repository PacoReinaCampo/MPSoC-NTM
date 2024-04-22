###################################################################################
##                                            __ _      _     _                  ##
##                                           / _(_)    | |   | |                 ##
##                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |                 ##
##               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |                 ##
##              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |                 ##
##               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|                 ##
##                  | |                                                          ##
##                  |_|                                                          ##
##                                                                               ##
##                                                                               ##
##              QueenField                                                       ##
##              Multi-Processor System on Chip                                   ##
##                                                                               ##
###################################################################################

###################################################################################
##                                                                               ##
## Copyright (c) 2022-2025 by the author(s)                                      ##
##                                                                               ##
## Permission is hereby granted, free of charge, to any person obtaining a copy  ##
## of this software and associated documentation files (the "Software"), to deal ##
## in the Software without restriction, including without limitation the rights  ##
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell     ##
## copies of the Software, and to permit persons to whom the Software is         ##
## furnished to do so, subject to the following conditions:                      ##
##                                                                               ##
## The above copyright notice and this permission notice shall be included in    ##
## all copies or substantial portions of the Software.                           ##
##                                                                               ##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    ##
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,      ##
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   ##
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        ##
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, ##
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN     ##
## THE SOFTWARE.                                                                 ##
##                                                                               ##
## ============================================================================= ##
## Author(s):                                                                    ##
##   Paco Reina Campo <pacoreinacampo@queenfield.tech>                           ##
##                                                                               ##
###################################################################################

cd application/arithmetic/scalar
make clean

cd ../../../application/arithmetic/vector
make clean

cd ../../../application/arithmetic/matrix
make clean

cd ../../../application/arithmetic/tensor
make clean


cd ../../../application/algebra/scalar
make clean

cd ../../../application/algebra/vector
make clean

cd ../../../application/algebra/matrix
make clean

cd ../../../application/algebra/tensor
make clean


cd ../../../application/math/scalar
make clean

cd ../../../application/math/matrix
make clean

cd ../../../application/math/vector
make clean


#cd ../../../application/nn/ann/components
#make clean

#cd ../../../application/nn/ann/controller/fnn
#make clean

#cd ../../../application/nn/ann/controller/lstm
#make clean

#cd ../../../application/nn/ann/functions
#make clean

#cd ../../../application/nn/ann/inputs
#make clean

#cd ../../../application/nn/ann/top
#make clean

#cd ../../../application/nn/fnn/convolutional
#make clean

#cd ../../../application/nn/fnn/standard
#make clean

#cd ../../../application/nn/lstm/convolutional
#make clean

#cd ../../../application/nn/lstm/standard
#make clean

#cd ../../../application/nn/ntm/memory
#make clean

#cd ../../../application/nn/ntm/read_heads
#make clean

#cd ../../../application/nn/ntm/top
#make clean

#cd ../../../application/nn/ntm/trained
#make clean

#cd ../../../application/nn/ntm/write_heads
#make clean


#cd ../../../application/state/feedback
#make clean

#cd ../../../application/state/outputs
#make clean

#cd ../../../application/state/top
#make clean


#cd ../../../application/trainer/differentiation
#make clean

#cd ../../../application/trainer/fnn
#make clean

#cd ../../../application/trainer/lstm/activation
#make clean

#cd ../../../application/trainer/lstm/forget
#make clean

#cd ../../../application/trainer/lstm/input
#make clean

#cd ../../../application/trainer/lstm/output
#make clean
