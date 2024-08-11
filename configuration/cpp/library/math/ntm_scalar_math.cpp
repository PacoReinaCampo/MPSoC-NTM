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

#include <math.h>

#include <cassert>
#include <iostream>

using namespace std;

class ScalarMath {
 public:
  double ntm_scalar_logistic_function(double data_in);
  double ntm_scalar_oneplus_function(double data_in);
  double ntm_scalar_mean_function(vector<double> data_in);
  double ntm_scalar_deviation_function(vector<double> data_in, double mean);
};

double ScalarMath::ntm_scalar_logistic_function(double data_in) {
  double ONE = 1.0;

  // calculating data_out
  return ONE / (ONE + ONE / exp(data_in));
}

double ScalarMath::ntm_scalar_oneplus_function(double data_in) {
  double ONE = 1.0;

  // calculating data_out
  double temporal = ONE + exp(data_in);

  return ONE + log(temporal);
}

double ScalarMath::ntm_scalar_mean_function(vector<double> data_in) {
  double data_out = 0.0;

  for (int i = 0; i < data_in.size(); i++) {
    data_out += data_in[i] / (double)data_in.size();
  }

  return data_out;
}

double ScalarMath::ntm_scalar_deviation_function(vector<double> data_in, double mean) {
  double data_out = 0.0;

  for (int i = 0; i < data_in.size(); i++) {
    data_out += (data_in[i] - mean) * (data_in[i] - mean) / (double)data_in.size();
  }

  return sqrt(data_out);
}

int main() {
  ScalarMath Math;

  double data_in_0 = 0.8909031788043871;
  double data_in_1 = 3.2155195231797550;

  double logistic_data_out_0 = 0.7090765217957029;
  double logistic_data_out_1 = 0.9614141454987156;

  double oneplus_data_out_0 = 2.2346950078883427;
  double oneplus_data_out_1 = 4.2548695333728740;

  assert(Math.ntm_scalar_logistic_function(data_in_0) == logistic_data_out_0);
  assert(Math.ntm_scalar_logistic_function(data_in_1) == logistic_data_out_1);

  assert(Math.ntm_scalar_oneplus_function(data_in_0) == oneplus_data_out_0);
  assert(Math.ntm_scalar_oneplus_function(data_in_1) == oneplus_data_out_1);

  vector<double> mean_data_in_0{3.0, 1.0, 2.0};
  vector<double> mean_data_in_1{1.0, 2.0, 3.0};

  vector<double> deviation_data_in_0{3.0, 2.0, 2.0};
  vector<double> deviation_data_in_1{1.0, 2.0, 1.0};

  double mean_data_out_0 = 2.0;
  double mean_data_out_1 = 2.0;

  double deviation_data_out_0 = 7.681145747868608;
  double deviation_data_out_1 = 8.679477710861024;

  assert(Math.ntm_scalar_mean_function(mean_data_in_0) == mean_data_out_0);
  assert(Math.ntm_scalar_mean_function(mean_data_in_1) == mean_data_out_1);

  assert(Math.ntm_scalar_deviation_function(deviation_data_in_0, 10.0) == deviation_data_out_0);
  assert(Math.ntm_scalar_deviation_function(deviation_data_in_1, 10.0) == deviation_data_out_1);

  return 0;
}
