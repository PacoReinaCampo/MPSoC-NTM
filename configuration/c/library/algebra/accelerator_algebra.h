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

double accelerator_scalar_multiplication(double *);
double accelerator_scalar_summation(double *);

double accelerator_dot_product(double *, double *);
double accelerator_vector_convolution(double *, double *);
double accelerator_vector_cosine_similarity(double *, double *);
double accelerator_vector_module(double *);
double accelerator_vector_multiplication(double **);
double accelerator_vector_summation(double **);
double accelerator_vector_differentiation(double *, double);
double accelerator_vector_integration(double *, double);
double accelerator_vector_softmax(double *);

double accelerator_matrix_convolution(double **, double **);
double accelerator_matrix_inverse(double **);
double accelerator_matrix_multiplication(double ***);
double accelerator_matrix_product(double **, double **);
double accelerator_matrix_summation(double ***);
double accelerator_matrix_transpose(double **);
double accelerator_matrix_vector_convolution(double **, double *);
double accelerator_matrix_vector_product(double **, double *);
double accelerator_transpose_vector_product(double *, double *);
double accelerator_matrix_differentiation(double **, double, double, int);
double accelerator_matrix_integration(double **, double);
double accelerator_matrix_softmax(double **);

double accelerator_tensor_convolution(double ***, double ***);
double accelerator_tensor_inverse(double ***);
double accelerator_tensor_matrix_convolution(double ***, double **);
double accelerator_tensor_matrix_product(double ***, double **);
double accelerator_tensor_multiplication(double ***);
double accelerator_tensor_product(double ***, double ***);
double accelerator_tensor_summation(double ***);
double accelerator_tensor_transpose(double ***);
double accelerator_tensor_differentiation(double ***, double, double, double, int);
double accelerator_tensor_integration(double ***, double);
double accelerator_tensor_softmax(double ***);
