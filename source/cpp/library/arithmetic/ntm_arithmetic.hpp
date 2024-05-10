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

#include <iostream>
#include <vector>

using namespace std;

double ntm_scalar_adder(double, double);
double ntm_scalar_subtract(double, double);
double ntm_scalar_multiplier(double, double);
double ntm_scalar_divider(double, double);

vector<double> ntm_vector_adder(vector<double>, vector<double>);
vector<double> ntm_vector_subtract(vector<double>, vector<double>);
vector<double> ntm_vector_multiplier(vector<double>, vector<double>);
vector<double> ntm_vector_divider(vector<double>, vector<double>);

vector<vector<double>> ntm_matrix_adder(vector<vector<double>>, vector<vector<double>>);
vector<vector<double>> ntm_matrix_subtract(vector<vector<double>>, vector<vector<double>>);
vector<vector<double>> ntm_matrix_multiplier(vector<vector<double>>, vector<vector<double>>);
vector<vector<double>> ntm_matrix_divider(vector<vector<double>>, vector<vector<double>>);

vector<vector<vector<double>>> ntm_tensor_adder(vector<vector<vector<double>>>, vector<vector<vector<double>>>);
vector<vector<vector<double>>> ntm_tensor_subtract(vector<vector<vector<double>>>, vector<vector<vector<double>>>);
vector<vector<vector<double>>> ntm_tensor_multiplier(vector<vector<vector<double>>>, vector<vector<vector<double>>>);
vector<vector<vector<double>>> ntm_tensor_divider(vector<vector<vector<double>>>, vector<vector<vector<double>>>);

class ScalarArithmetic {
 public:
  double ntm_scalar_adder(double data_a_in, double data_b_in);
  double ntm_scalar_subtract(double data_a_in, double data_b_in);
  double ntm_scalar_multiplier(double data_a_in, double data_b_in);
  double ntm_scalar_divider(double data_a_in, double data_b_in);
};

class VectorArithmetic {
 public:
  vector<double> ntm_vector_adder(vector<double> data_a_in, vector<double> data_b_in);
  vector<double> ntm_vector_subtract(vector<double> data_a_in, vector<double> data_b_in);
  vector<double> ntm_vector_multiplier(vector<double> data_a_in, vector<double> data_b_in);
  vector<double> ntm_vector_divider(vector<double> data_a_in, vector<double> data_b_in);
};

class MatrixArithmetic {
 public:
  vector<vector<double>> ntm_matrix_adder(vector<vector<double>> data_a_in, vector<vector<double>> data_b_in);
  vector<vector<double>> ntm_matrix_subtract(vector<vector<double>> data_a_in, vector<vector<double>> data_b_in);
  vector<vector<double>> ntm_matrix_multiplier(vector<vector<double>> data_a_in, vector<vector<double>> data_b_in);
  vector<vector<double>> ntm_matrix_divider(vector<vector<double>> data_a_in, vector<vector<double>> data_b_in);
};

class TensorArithmetic {
 public:
  vector<vector<vector<double>>> ntm_tensor_adder(vector<vector<vector<double>>> data_a_in, vector<vector<vector<double>>> data_b_in);
  vector<vector<vector<double>>> ntm_tensor_subtract(vector<vector<vector<double>>> data_a_in, vector<vector<vector<double>>> data_b_in);
  vector<vector<vector<double>>> ntm_tensor_multiplier(vector<vector<vector<double>>> data_a_in, vector<vector<vector<double>>> data_b_in);
  vector<vector<vector<double>>> ntm_tensor_divider(vector<vector<vector<double>>> data_a_in, vector<vector<vector<double>>> data_b_in);
};
