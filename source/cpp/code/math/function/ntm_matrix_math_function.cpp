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

#include<iostream>
#include<math.h>
#include<vector>
#include<cassert>

using namespace std;

class MatrixMathFunction {
  public:
    vector<vector<double>> ntm_matrix_logistic_function(vector<vector<double>> data_in);
    vector<vector<double>> ntm_matrix_oneplus_function(vector<vector<double>> data_in);
};

vector<vector<double>> MatrixMathFunction::ntm_matrix_logistic_function(vector<vector<double>> data_in) {

  double ONE = 1.0;

  vector<vector<double>> data_out;

  for (int i = 0; i < data_in.size(); i++) {
    vector<double> vector;

    for (int j = 0; j < data_in[0].size(); j++) {
      double temporal = ONE/(ONE + ONE/exp(data_in[i][j]));

      vector.push_back(temporal);
    }
    data_out.push_back(vector);
  }

  return data_out;
}

vector<vector<double>> MatrixMathFunction::ntm_matrix_oneplus_function(vector<vector<double>> data_in) {

  double ONE = 1.0;

  vector<vector<double>> data_out;

  for (int i = 0; i < data_in.size(); i++) {
    vector<double> vector;

    for (int j = 0; j < data_in[0].size(); j++) {
      double temporal0 = ONE + exp(data_in[i][j]);
      double temporal1 = ONE + log(temporal0);

      vector.push_back(temporal1);
    }
    data_out.push_back(vector);
  }

  return data_out;
}

int main() {

  MatrixMathFunction MathFunction;

  vector<vector<double>> data_in {
    { 6.3226113886226751, 3.1313826152262876, 8.3512687816132226 },
    { 4.3132651822261687, 5.3132616875182226, 6.6931471805599454 },
    { 9.9982079678583020, 7.9581688450893644, 2.9997639589554603 }
  };

  vector<vector<double>> logistic_data_out {
    { 0.9982079678583020, 0.9581688450893644, 0.9997639589554603 },
    { 0.9867871586112067, 0.9950983109503272, 0.9987621580633643 },
    { 0.9999545207076224, 0.9996503292557579, 0.9525634621372647 }
  };

  vector<vector<double>> oneplus_data_out {
    {  7.324405028374851, 4.174113884283648, 9.351504850519834 },
    {  5.326566089800315, 6.318175429247454, 7.694385789255728 },
    { 10.998253448184894, 8.958518576982677, 4.048362506240452 }
  };

  assert(MathFunction.ntm_matrix_logistic_function(data_in) == logistic_data_out);

  assert(MathFunction.ntm_matrix_oneplus_function(data_in) == oneplus_data_out);

  return 0;
}
