///////////////////////////////////////////////////////////////////////////////////
//                                            __ _      _     _                  //
//                                          /_(_)    | |   | |                 //
//                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |                 //
//              /_` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |                 //
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
// Permission is hereby granted, free of charge, to any person obtaining matrix copy  //
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

#define SIZE 10

#define SIZE_IN 3

double ntm_matrix_inverse(double **data_in) {
  double matrix[SIZE][SIZE];

  double **data_out;

  double ratio;

  int i, j, m;

  data_out = (double **) malloc(SIZE_IN*sizeof(int*));

  for (i = 0; i < SIZE_IN; i++) {
    data_out[i] = (double *)malloc(SIZE_IN*sizeof(int));
  }

  // Augmenting Identity Matrix of Order SIZE_IN
  for (i = 0; i < SIZE_IN; i++) {
    for (j = 0; j < SIZE_IN; j++) {
      matrix[i][j] = data_in[i][j];

      if (i == j) {
        matrix[i][j + SIZE_IN] = 1;
      } else {
        matrix[i][j + SIZE_IN] = 0;
      }
    }
  }

  // Applying Gauss Jordan Elimination
  for (i = 0; i < SIZE_IN; i++) {
    if (matrix[i][i] == 0.0) {
      printf("Mathematical Error!");
    }
    for (j = 0; j < SIZE_IN; j++) {
      if (i != j) {
        ratio = matrix[j][i]/matrix[i][i];
        for (m = 1; m <= 2*SIZE_IN; m++) {
          matrix[j][m] = matrix[j][m] - ratio*matrix[i][m];
        }
      }
    }
  }

  // Row Operation to Make Principal Diagonal to 1
  for (i = 0; i < SIZE_IN; i++) {
    for (j = SIZE_IN; j < 2*SIZE_IN; j++) {
      matrix[i][j] = matrix[i][j]/matrix[i][i];
    }
  }

  // Output
  for (i = 0; i < SIZE_IN; i++) {
    for (j = 0; j < SIZE_IN; j++) {
      data_out[i][j] = matrix[i][j + SIZE_IN];
    }
  }

  return **data_out;
}

int main() {
  double **data_in;

  double **data_out;

  int i;

  data_in = (double **) malloc(SIZE_IN*sizeof(int*));

  data_out = (double **) malloc(SIZE_IN*sizeof(int*));

  for (i = 0; i < SIZE_IN; i++) {
    data_in[i] = (double *)malloc(SIZE_IN*sizeof(int));

    data_out[i] = (double *)malloc(SIZE_IN*sizeof(int));
  }

  data_in[0][0] = 1.0; data_in[1][0] =  1.0; data_in[2][0] = -2.0;
  data_in[0][1] = 1.0; data_in[1][1] =  3.0; data_in[2][1] = -4.0;
  data_in[0][2] = 3.0; data_in[1][2] = -3.0; data_in[2][2] = -4.0;

  data_out[0][0] =  3.00; data_out[1][0] =  1.00; data_out[2][0] =  1.50;
  data_out[0][1] = -1.25; data_out[1][1] = -0.25; data_out[2][1] = -0.75;
  data_out[0][2] = -0.25; data_out[1][2] = -0.25; data_out[2][2] = -0.25;

  assert(ntm_matrix_inverse(data_in)==**data_out);

  free(data_in);

  free(data_out);

  return 0;
}
