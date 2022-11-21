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

class VectorMathCalculus {
  public:
    vector<double> ntm_vector_differentiation(vector<double> data_in, double length_in);
    vector<double> ntm_vector_integration(vector<double> data_in, double length_in);
    vector<double> ntm_vector_softmax(vector<double> data_in);
};

vector<double> VectorMathCalculus::ntm_vector_differentiation(vector<double> data_in, double length_in) {

  double temporal = 0.0;

  vector<double> data_out;

  for (int i = 0; i < data_in.size(); i++) {
    if (i == 0) {
      temporal = 0.0;
    }
    else {
      temporal = (data_in[i] - data_in[i-1])/length_in;
    }

    data_out.push_back(temporal);
  }

  return data_out;
}

vector<double> VectorMathCalculus::ntm_vector_integration(vector<double> data_in, double length_in) {

  double temporal = 0.0;

  vector<double> data_out;

  for (int i = 0; i < data_in.size(); i++) {
    temporal += data_in[i];

    data_out.push_back(temporal*length_in);
  }

  return data_out;
}

vector<double> VectorMathCalculus::ntm_vector_softmax(vector<double> data_in) {

  double temporal0 = 0.0;

  vector<double> data_int;

  vector<double> data_out;

  for (int i = 0; i < data_in.size(); i++) {
    temporal0 += exp(data_in[i]);

    double temporal1 = exp(data_in[i]);

    data_int.push_back(temporal1);
  }

  for (int i = 0; i < data_in.size(); i++) {
    data_out.push_back(data_int[i]/temporal0);
  }

  return data_out;
}

int main() {

  VectorMathCalculus MathCalculus;

  vector<double> differentiation_data_in{ 6.0, 3.0, 8.0 };

  vector<double> integration_data_in{ 6.0, 3.0, 8.0 };

  vector<double> softmax_data_in{ 6.3226113886226751, 3.1313826152262876, 8.3512687816132226 };


  vector<double> differentiation_data_out{ 0.0, -3.0, 5.0 };

  vector<double> integration_data_out{ 6.0, 9.0, 17.0 };

  vector<double> softmax_data_out{ 0.11567390955504045, 0.004756662822010267, 0.8795694276229492 };


  double length_in = 1.0;


  assert(MathCalculus.ntm_vector_differentiation(differentiation_data_in, length_in) == differentiation_data_out);

  assert(MathCalculus.ntm_vector_integration(integration_data_in, length_in) == integration_data_out);

  assert(MathCalculus.ntm_vector_softmax(softmax_data_in) == softmax_data_out);

  return 0;
}
