///////////////////////////////////////////////////////////////////////////////////
//                                            __ _      _     _                  //
//                                           / _(_)    | |   | |                 //
//                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |                 //
//               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |                 //
//              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |                 //
//               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|                 //
//                  | |                                                          //
//                  |_|                                                          //
//                                                                               //
//                                                                               //
//              Peripheral-NTM for MPSoC                                         //
//              Neural Turing Machine for MPSoC                                  //
//                                                                               //
///////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////
//                                                                               //
// Copyright (c) 2020-2024 by the author(s)                                      //
//                                                                               //
// Permission is hereby granted, free of charge, to any person obtaining a copy  //
// of this software and associated documentation files (the "Software"), to deal //
// in the Software without restriction, including without limitation the rights  //
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell     //
// copies of the Software, and to permit persons to whom the Software is         //
// furnished to do so, subject to the following conditions:                      //
//                                                                               //
// The above copyright notice and this permission notice shall be included in    //
// all copies or substantial portions of the Software.                           //
//                                                                               //
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    //
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,      //
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   //
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        //
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, //
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN     //
// THE SOFTWARE.                                                                 //
//                                                                               //
// ============================================================================= //
// Author(s):                                                                    //
//   Paco Reina Campo <pacoreinacampo@queenfield.tech>                           //
//                                                                               //
///////////////////////////////////////////////////////////////////////////////////

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

#define X 3
#define Y 3

double ntm_matrix_adder(double **input_a, double **input_b) {

  double **result;

  int i, j;

  result = (double **) malloc(sizeof(int)*X*Y);

  // calculating multiplication
  for (i = 0; i < X; i++) {
    for (j = 0; j < Y; j++) {
      result[i][j] = input_a[i][j] * input_b[i][j];
    }
  }

  return **result;
}

int main() {

  double **input_a;
  double **input_b;

  double **output;

  input_a = (double **) malloc(sizeof(int)*X*Y);
  input_b = (double **) malloc(sizeof(int)*X*Y);

  output = (double **) malloc(sizeof(int)*X*Y);

  input_a[0][0] = 2.0; input_a[1][0] = 2.0; input_a[2][0] = 2.0;
  input_a[0][1] = 0.0; input_a[1][1] = 0.0; input_a[2][1] = 0.0;
  input_a[0][2] = 4.0; input_a[1][2] = 4.0; input_a[2][2] = 4.0;

  input_b[0][0] = 1.0; input_b[1][0] = 1.0; input_b[2][0] = 1.0;
  input_b[0][1] = 1.0; input_b[1][1] = 1.0; input_b[2][1] = 1.0;
  input_b[0][2] = 2.0; input_b[1][2] = 2.0; input_b[2][2] = 2.0;

  output[0][0] = 2.0; output[1][0] = 2.0; output[2][0] = 2.0;
  output[0][1] = 0.0; output[1][1] = 0.0; output[2][1] = 0.0;
  output[0][2] = 8.0; output[1][2] = 8.0; output[2][2] = 8.0;

  assert(ntm_matrix_adder(input_a, input_b)==**output);

  free(input_a);
  free(input_b);

  free(output);

  return 0;
}
