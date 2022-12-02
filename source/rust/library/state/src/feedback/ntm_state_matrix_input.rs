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

extern crate arithmetic;

extern crate math_algebra;

use arithmetic::matrix::ntm_matrix_adder::*;
use arithmetic::matrix::ntm_matrix_subtrator::*;

use math_algebra::matrix::ntm_matrix_inverse::*;
use math_algebra::matrix::ntm_matrix_product::*;

pub fn Vec<Vec<f64>> ntm_state_matrix_input(data_k_in: Vec<Vec<f64>>, data_b_in: Vec<Vec<f64>>, data_d_in: Vec<Vec<f64>>) -> Vec<Vec<f64>> {

  // Constants
  // SIZE: A[N,N]; B[N,P]; C[Q,N]; D[Q,P];
  // SIZE: K[P,P]; x[N,1]; y[Q,1]; u[P,1];

  let SIZE_D_I_IN = data_d_in.len();
  let SIZE_D_J_IN = data_d_in[0].len();

  // Variables
  let mut matrix_operation_int: Vec<Vec<f64>> = vec![];

  let mut data_b_out: Vec<Vec<f64>> = vec![];

  // Body
  // b = B·(I-K·inv(I + D·K)·D)
  matrix_operation_int = ntm_matrix_product(data_d_in, data_k_in);

  matrix_operation_int = ntm_matrix_adder(ntm_matrix_eye(SIZE_D_I_IN, SIZE_D_J_IN), matrix_operation_int);

  matrix_operation_int = ntm_matrix_inverse(matrix_operation_int);

  matrix_operation_int = ntm_matrix_product(matrix_operation_int, data_d_in);

  matrix_operation_int = ntm_matrix_product(data_k_in, matrix_operation_int);

  matrix_operation_int = ntm_matrix_subtrator(ntm_matrix_eye(SIZE_D_I_IN, SIZE_D_J_IN), matrix_operation_int);

  data_b_out = ntm_matrix_product(data_b_in, matrix_operation_int);

  return data_b_out
}
