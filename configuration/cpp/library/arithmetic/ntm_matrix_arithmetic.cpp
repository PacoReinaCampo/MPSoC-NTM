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

#include "ntm_arithmetic.hpp"

using namespace std;

vector<vector<double>> MatrixArithmetic::ntm_matrix_adder(vector<vector<double>> data_a_in, vector<vector<double>> data_b_in) {
  vector<vector<double>> data_out;

  for (int i = 0; i < data_a_in.size(); i++) {
    vector<double> vector;

    for (int j = 0; j < data_a_in[0].size(); j++) {
      double temporal = data_a_in[i][j] + data_b_in[i][j];

      vector.push_back(temporal);
    }
    data_out.push_back(vector);
  }

  return data_out;
}

vector<vector<double>> MatrixArithmetic::ntm_matrix_subtract(vector<vector<double>> data_a_in, vector<vector<double>> data_b_in) {
  vector<vector<double>> data_out;

  for (int i = 0; i < data_a_in.size(); i++) {
    vector<double> vector;

    for (int j = 0; j < data_a_in[0].size(); j++) {
      double temporal = data_a_in[i][j] - data_b_in[i][j];

      vector.push_back(temporal);
    }
    data_out.push_back(vector);
  }

  return data_out;
}

vector<vector<double>> MatrixArithmetic::ntm_matrix_multiplier(vector<vector<double>> data_a_in, vector<vector<double>> data_b_in) {
  vector<vector<double>> data_out;

  for (int i = 0; i < data_a_in.size(); i++) {
    vector<double> vector;

    for (int j = 0; j < data_a_in[0].size(); j++) {
      double temporal = data_a_in[i][j] * data_b_in[i][j];

      vector.push_back(temporal);
    }
    data_out.push_back(vector);
  }

  return data_out;
}

vector<vector<double>> MatrixArithmetic::ntm_matrix_divider(vector<vector<double>> data_a_in, vector<vector<double>> data_b_in) {
  vector<vector<double>> data_out;

  for (int i = 0; i < data_a_in.size(); i++) {
    vector<double> vector;

    for (int j = 0; j < data_a_in[0].size(); j++) {
      double temporal = data_a_in[i][j] / data_b_in[i][j];

      vector.push_back(temporal);
    }
    data_out.push_back(vector);
  }

  return data_out;
}
