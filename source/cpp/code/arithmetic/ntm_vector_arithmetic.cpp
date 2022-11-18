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
#include<vector>
#include<cassert>

using namespace std;

class VectorArithmetic {
  public:
    vector<double> ntm_vector_adder(vector<double> data_a_in, vector<double> data_b_in);
    vector<double> ntm_vector_multiplier(vector<double> data_a_in, vector<double> data_b_in);
    vector<double> ntm_vector_divider(vector<double> data_a_in, vector<double> data_b_in);
};


vector<double> VectorArithmetic::ntm_vector_adder(vector<double> data_a_in, vector<double> data_b_in) {
  // Add two vectors of identical dimensions
  vector<double> data_out;

  if (data_a_in.size() != data_b_in.size()) {
    throw std::runtime_error("Vector dimensions do not match");
  }

  for (int i = 0; i < data_a_in.size(); i++) {
    double temporal = data_a_in[i] + data_b_in[i];

    data_out.push_back(temporal);
  }

  return data_out;
}

vector<double> VectorArithmetic::ntm_vector_multiplier(vector<double> data_a_in, vector<double> data_b_in) {
  // Multiply two vectors of identical dimensions
  vector<double> data_out;

  if (data_a_in.size() != data_b_in.size()) {
    throw std::runtime_error("Vector dimensions do not match");
  }

  for (int i = 0; i < data_a_in.size(); i++) {
    double temporal = data_a_in[i] * data_b_in[i];

    data_out.push_back(temporal);
  }

  return data_out;
}

vector<double> VectorArithmetic::ntm_vector_divider(vector<double> data_a_in, vector<double> data_b_in) {
  // Divide two vectors of identical dimensions
  vector<double> data_out;

  if (data_a_in.size() != data_b_in.size()) {
    throw std::runtime_error("Vector dimensions do not match");
  }

  for (int i = 0; i < data_a_in.size(); i++) {
    double temporal = data_a_in[i] / data_b_in[i];

    data_out.push_back(temporal);
  }

  return data_out;
}

int main() {

  VectorArithmetic Arithmetic;

  vector<double> data_a_in{2.0, 0.0, 4.0};
  vector<double> data_b_in{1.0, 1.0, 2.0};

  vector<double> addition_data_out{3.0, 1.0, 6.0};

  vector<double> multiplication_data_out{2.0, 0.0, 8.0};

  vector<double> division_data_out{2.0, 0.0, 2.0};

  assert(Arithmetic.ntm_vector_adder(data_a_in, data_b_in) == addition_data_out);

  assert(Arithmetic.ntm_vector_multiplier(data_a_in, data_b_in) == multiplication_data_out);

  assert(Arithmetic.ntm_vector_divider(data_a_in, data_b_in) == division_data_out);

  return 0;
}
