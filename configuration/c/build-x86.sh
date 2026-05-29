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
make x86

cd ../../../application/arithmetic/vector
make clean
make x86

cd ../../../application/arithmetic/matrix
make clean
make x86

cd ../../../application/arithmetic/tensor
make clean
make x86


#cd ../../../application/algebra/scalar
#make clean
#make x86

#cd ../../../application/algebra/vector
#make clean
#make x86

#cd ../../../application/algebra/matrix
#make clean
#make x86

#cd ../../../application/algebra/tensor
#make clean
#make x86


cd ../../../application/math/scalar
make clean
make x86

cd ../../../application/math/matrix
make clean
make x86

cd ../../../application/math/vector
make clean
make x86


cd ../../../application/intelligence/training/state/feedback
make clean
make x86

#cd ../../../application/intelligence/training/state/outputs
#make clean
#make x86

#cd ../../../application/intelligence/training/state/top
#make clean
#make x86


cd ../../../application/intelligence/modeling/ann/components
make clean
make x86

cd ../../../../application/intelligence/modeling/ann/functions
make clean
make x86

cd ../../../../application/intelligence/modeling/ann/inputs
make clean
make x86

cd ../../../../application/intelligence/modeling/ann/top
make clean
make x86

cd ../../../../../application/intelligence/modeling/ann/controller/fnn
make clean
make x86

cd ../../../../../application/intelligence/modeling/ann/controller/lstm
make clean
make x86

cd ../../../../application/intelligence/modeling/dnc/memory
make clean
make x86

cd ../../../../application/intelligence/modeling/dnc/read_heads
make clean
make x86

cd ../../../../application/intelligence/modeling/dnc/top
make clean
make x86

cd ../../../../application/intelligence/modeling/dnc/trained
make clean
make x86

cd ../../../../application/intelligence/modeling/dnc/write_heads
make clean
make x86

cd ../../../../application/intelligence/modeling/fnn/convolutional
make clean
make x86

cd ../../../../application/intelligence/modeling/fnn/standard
make clean
make x86

cd ../../../../application/intelligence/modeling/lstm/convolutional
make clean
make x86

cd ../../../../application/intelligence/modeling/lstm/standard
make clean
make x86

cd ../../../../application/intelligence/modeling/ntm/memory
make clean
make x86

cd ../../../../application/intelligence/modeling/ntm/read_heads
make clean
make x86

cd ../../../../application/intelligence/modeling/ntm/top
make clean
make x86

cd ../../../../application/intelligence/modeling/ntm/trained
make clean
make x86

cd ../../../../application/intelligence/modeling/ntm/write_heads
make clean
make x86


cd ../../../../application/intelligence/training/differentiation
make clean
make x86

cd ../../../application/intelligence/training/fnn
make clean
make x86

cd ../../../application/intelligence/training/lstm/activation
make clean
make x86

cd ../../../../application/intelligence/training/lstm/forget
make clean
make x86

cd ../../../../application/intelligence/training/lstm/input
make clean
make x86

cd ../../../../application/intelligence/training/lstm/output
make clean
make x86
