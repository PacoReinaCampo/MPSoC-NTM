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

#include "../ntm_algebra.h"

#define SIZE 10

#define SIZE_IN 3

double ntm_tensor_inverse(double **data_in) {
  double tensor[SIZE][SIZE];

  double **data_out;

  double ratio;

  int i, j, m;

  data_out = (double **)malloc(SIZE_IN * sizeof(int *));

  for (i = 0; i < SIZE_IN; i++) {
    data_out[i] = (double *)malloc(SIZE_IN * sizeof(int));
  }

  // Augmenting Identity Matrix of Order SIZE_IN
  for (i = 0; i < SIZE_IN; i++) {
    for (j = 0; j < SIZE_IN; j++) {
      tensor[i][j] = data_in[i][j];

      if (i == j) {
        tensor[i][j + SIZE_IN] = 1.0;
      } else {
        tensor[i][j + SIZE_IN] = 0.0;
      }
    }
  }

  // Applying Gauss Jordan Elimination
  for (i = 0; i < SIZE_IN; i++) {
    if (tensor[i][i] == 0.0) {
      printf("Mathematical Error!");
    }
    for (j = 0; j < SIZE_IN; j++) {
      if (i != j) {
        ratio = tensor[j][i] / tensor[i][i];
        for (m = 0; m < 2 * SIZE_IN; m++) {
          tensor[j][m] = tensor[j][m] - ratio * tensor[i][m];
        }
      }
    }
  }

  // Row Operation to Make Principal Diagonal to 1
  for (i = 0; i < SIZE_IN; i++) {
    for (j = SIZE_IN; j < 2 * SIZE_IN; j++) {
      tensor[i][j] = tensor[i][j] / tensor[i][i];
    }
  }

  // Output
  for (i = 0; i < SIZE_IN; i++) {
    for (j = 0; j < SIZE_IN; j++) {
      data_out[i][j] = tensor[i][j + SIZE_IN];
    }
  }

  return **data_out;
}
