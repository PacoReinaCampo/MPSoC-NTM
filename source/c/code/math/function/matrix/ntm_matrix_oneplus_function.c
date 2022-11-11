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
#include <math.h>
#include <stdlib.h>
#include <assert.h>

#define SIZE_I_IN 3
#define SIZE_J_IN 3

double ntm_matrix_logistic_function(double **data_in) {
  double ONE = 1.0;

  double temporal;

  double **data_out;

  int i, j;

  data_out = (double **) malloc(SIZE_I_IN*sizeof(int*));

  for (i=0;i<SIZE_I_IN;i++) {
    data_out[i] = (double *)malloc(SIZE_J_IN*sizeof(int)); 
  }
		
  // calculating addition
  for (i = 0; i < SIZE_I_IN; i++) {
    for (j = 0; j < SIZE_J_IN; j++) {
      temporal = ONE + exp(data_in[i][j]);

      data_out[i][j] = ONE + log(temporal);
    }
  }

  return **data_out;
}

int main() {

  double **data_in;

  double **data_out;

  int i;

  data_in = (double **) malloc(SIZE_I_IN*sizeof(int*));

  data_out = (double **) malloc(SIZE_I_IN*sizeof(int*));

  for (i=0;i<SIZE_I_IN;i++) {
    data_in[i] = (double *)malloc(SIZE_J_IN*sizeof(int));

    data_out[i] = (double *)malloc(SIZE_J_IN*sizeof(int));
  }

  data_in[0][0] = 6.3226113886226751; data_in[1][0] = 3.1313826152262876; data_in[2][0] = 8.3512687816132226;
  data_in[0][1] = 4.3132651822261687; data_in[1][1] = 5.3132616875182226; data_in[2][1] = 6.6931471805599454;
  data_in[0][2] = 9.9982079678583020; data_in[1][2] = 7.9581688450893644; data_in[2][2] = 2.9997639589554603;

  data_out[0][0] =  7.324405028374851; data_out[1][0] = 4.174113884283648; data_out[2][0] = 9.351504850519834;
  data_out[0][1] =  5.326566089800315; data_out[1][1] = 6.318175429247454; data_out[2][1] = 7.694385789255728;
  data_out[0][2] = 10.998253448184894; data_out[1][2] = 8.958518576982677; data_out[2][2] = 4.048362506240452;

  assert(ntm_matrix_logistic_function(data_in)==**data_out);

  free(data_in);

  free(data_out);

  return 0;
}
