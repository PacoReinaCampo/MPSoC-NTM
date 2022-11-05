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

#define SIZE 10

int main() {
  float a[SIZE][SIZE], x[SIZE], ratio;

  int i, j, k, n;

  // Inputs
  // 1. Reading order of matrix
  printf("Enter order of matrix: ");
  scanf("%d", & n);

  // 2. Reading Matrix
  printf("Enter coefficients of Matrix:\n");
  for (i = 1; i <= n; i++) {
    for (j = 1; j <= n; j++) {
      printf("a[%d][%d] = ", i, j);
      scanf("%f", & a[i][j]);
    }
  }

  // Augmenting Identity Matrix of Order n
  for (i = 1; i <= n; i++) {
    for (j = 1; j <= n; j++) {
      if (i == j) {
        a[i][j + n] = 1;
      } else {
        a[i][j + n] = 0;
      }
    }
  }

  // Applying Gauss Jordan Elimination
  for (i = 1; i <= n; i++) {
    if (a[i][i] == 0.0) {
      printf("Mathematical Error!");
    }
    for (j = 1; j <= n; j++) {
      if (i != j) {
        ratio = a[j][i] / a[i][i];
        for (k = 1; k <= 2 * n; k++) {
          a[j][k] = a[j][k] - ratio * a[i][k];
        }
      }
    }
  }

  // Row Operation to Make Principal Diagonal to 1
  for (i = 1; i <= n; i++) {
    for (j = n + 1; j <= 2 * n; j++) {
      a[i][j] = a[i][j] / a[i][i];
    }
  }

  // Displaying Inverse Matrix
  printf("\nInverse Matrix is:\n");
  for (i = 1; i <= n; i++) {
    for (j = n + 1; j <= 2 * n; j++) {
      printf("%0.3f\t", a[i][j]);
    }
    printf("\n");
  }
  return (0);
}
