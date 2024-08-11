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

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#include "../../../library/algebra/ntm_algebra.h"

int main() {
  double **data_a_in;
  double **data_b_in;

  double **data_in;

  double **data_out;

  int i;

  data_a_in = (double **)malloc(SIZE_I_A_IN * sizeof(int *));
  data_b_in = (double **)malloc(SIZE_I_B_IN * sizeof(int *));

  data_in = (double **)malloc(SIZE_IN * sizeof(int *));

  data_out = (double **)malloc(SIZE_IN * sizeof(int *));

  for (i = 0; i < SIZE_IN; i++) {
    data_in[i] = (double *)malloc(SIZE_IN * sizeof(int));

    data_out[i] = (double *)malloc(SIZE_IN * sizeof(int));
  }

  for (i = 0; i < SIZE_I_A_IN; i++) {
    data_a_in[i] = (double *)malloc(SIZE_J_A_IN * sizeof(int));
    data_b_in[i] = (double *)malloc(SIZE_J_B_IN * sizeof(int));

    data_out[i] = (double *)malloc(SIZE_J_B_IN * sizeof(int));
  }

  data_a_in[0][0] = 1.0;
  data_a_in[0][1] = 2.0;
  data_a_in[0][2] = 3.0;
  data_a_in[1][0] = 4.0;
  data_a_in[1][1] = 2.0;
  data_a_in[1][2] = 6.0;
  data_a_in[2][0] = 3.0;
  data_a_in[2][1] = 4.0;
  data_a_in[2][2] = 1.0;
  data_a_in[3][0] = 2.0;
  data_a_in[3][1] = 4.0;
  data_a_in[3][2] = 8.0;

  data_b_in[0][0] = 1.0;
  data_b_in[0][1] = 3.0;
  data_b_in[0][2] = 3.0;
  data_b_in[0][3] = 2.0;
  data_b_in[1][0] = 7.0;
  data_b_in[1][1] = 6.0;
  data_b_in[1][2] = 2.0;
  data_b_in[1][3] = 1.0;
  data_b_in[2][0] = 3.0;
  data_b_in[2][1] = 4.0;
  data_b_in[2][2] = 2.0;
  data_b_in[2][3] = 1.0;

  data_out[0][0] = 24.0;
  data_out[0][1] = 27.0;
  data_out[0][2] = 13.0;
  data_out[0][3] = 7.0;
  data_out[1][0] = 36.0;
  data_out[1][1] = 48.0;
  data_out[1][2] = 28.0;
  data_out[1][3] = 16.0;
  data_out[2][0] = 34.0;
  data_out[2][1] = 37.0;
  data_out[2][2] = 19.0;
  data_out[2][3] = 11.0;
  data_out[3][0] = 54.0;
  data_out[3][1] = 62.0;
  data_out[3][2] = 30.0;
  data_out[3][3] = 16.0;

  assert(ntm_matrix_product(data_a_in, data_b_in) == **data_out);

  data_in[0][0] = 1.0;
  data_in[0][1] = 1.0;
  data_in[0][2] = 3.0;
  data_in[1][0] = 1.0;
  data_in[1][1] = 3.0;
  data_in[1][2] = -3.0;
  data_in[2][0] = -2.0;
  data_in[2][1] = -4.0;
  data_in[2][2] = -4.0;

  data_out[0][0] = 3.00;
  data_out[0][1] = 1.00;
  data_out[0][2] = 1.50;
  data_out[1][0] = -1.25;
  data_out[1][1] = -0.25;
  data_out[1][2] = -0.75;
  data_out[2][0] = -0.25;
  data_out[2][1] = -0.25;
  data_out[2][2] = -0.25;

  assert(ntm_matrix_inverse(data_in) == **data_out);

  data_in[0][0] = 1.0;
  data_in[0][1] = 1.0;
  data_in[0][2] = -2.0;
  data_in[1][0] = 1.0;
  data_in[1][1] = 3.0;
  data_in[1][2] = -4.0;
  data_in[2][0] = 3.0;
  data_in[2][1] = -3.0;
  data_in[2][2] = -4.0;

  data_out[0][0] = 1.0;
  data_out[0][1] = 1.0;
  data_out[0][2] = 3.0;
  data_out[1][0] = 1.0;
  data_out[1][1] = 3.0;
  data_out[1][2] = -3.0;
  data_out[2][0] = -2.0;
  data_out[2][1] = -4.0;
  data_out[2][2] = -4.0;

  assert(ntm_matrix_transpose(data_in) == **data_out);

  free(data_a_in);
  free(data_b_in);

  free(data_in);

  free(data_out);

  return 0;
}
