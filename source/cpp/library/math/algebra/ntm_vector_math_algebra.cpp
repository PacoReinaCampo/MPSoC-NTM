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

class VectorMathAlgebra {
  public:
    double ntm_dot_product(vector<double> data_a_in, vector<double> data_b_in);
    double ntm_vector_cosine_similarity(vector<double> data_a_in, vector<double> data_b_in);
    double ntm_vector_module(vector<double> data_in);

    vector<double> ntm_vector_convolution(vector<double> data_a_in, vector<double> data_b_in);
    vector<double> ntm_vector_summation(vector<vector<double>> matrix);
    vector<double> ntm_vector_multiplication(vector<vector<double>> matrix);
};

double VectorMathAlgebra::ntm_dot_product(vector<double> data_a_in, vector<double> data_b_in) {
  double data_out = 0;

  for (int i=0; i<data_a_in.size(); i++) {
    data_out += data_a_in[i] * data_b_in[i];
  }

  return data_out;
}

double VectorMathAlgebra::ntm_vector_cosine_similarity(vector<double> data_a_in, vector<double> data_b_in) {
  double dot_result = 0.0;

  double input_a_result = 0.0;
  double input_b_result = 0.0;

  for (int i=0; i<data_a_in.size(); i++) {
    dot_result += data_a_in[i] * data_b_in[i];
  }

  for (int i=0; i<data_a_in.size(); i++) {
    input_a_result += data_a_in[i] * data_a_in[i];
  }

  for (int i=0; i<data_b_in.size(); i++) {
    input_b_result += data_b_in[i] * data_b_in[i];
  }

  return dot_result/(sqrt(input_a_result)*sqrt(input_b_result));
}

double VectorMathAlgebra::ntm_vector_module(vector<double> data_in) {
  double data_out = 0.0;

  for (int i=0; i<data_in.size(); i++) {
    data_out += data_in[i] * data_in[i];
  }

  return sqrt(data_out);
}

vector<double> VectorMathAlgebra::ntm_vector_convolution(vector<double> data_a_in, vector<double> data_b_in) {
  vector<double> data_out;

  for (int i=0; i<data_a_in.size(); i++) {
    double temporal = 0.0;

    for (int m=0; m<i+1; m++) {
      temporal += data_a_in[m] * data_b_in[i-m];
    }
    data_out.push_back(temporal);
  }

  return data_out;
}

vector<double> VectorMathAlgebra::ntm_vector_summation(vector<vector<double>> matrix) {
  vector<double> data_out;

  for (int i=0; i<matrix.size(); i++) {
    double temporal = 0.0;

    for (int j=0; j<matrix[0].size(); j++) {
      temporal += matrix[i][j];
    }
    data_out.push_back(temporal);
  }

  return data_out;
}

vector<double> VectorMathAlgebra::ntm_vector_multiplication(vector<vector<double>> matrix) {
  vector<double> data_out;

  for (int i=0; i<matrix.size(); i++) {
    double temporal = 1.0;

    for (int j=0; j<matrix[0].size(); j++) {
      temporal *= matrix[i][j];
    }
    data_out.push_back(temporal);
  }

  return data_out;
}

int main() {

  VectorMathAlgebra MathAlgebra;

  vector<double> dot_product_data_a_in{1.0, 2.0, 3.0};
  vector<double> dot_product_data_b_in{1.0, 3.0, 3.0};

  vector<double> cosine_similarity_data_a_in{4.0, 0.0, 3.0};
  vector<double> cosine_similarity_data_b_in{4.0, 0.0, 3.0};

  vector<double> module_data_in{4.0, 0.0, 3.0};


  vector<double> convolution_data_a_in{1.0, 2.0, 3.0};
  vector<double> convolution_data_b_in{1.0, 3.0, 3.0};


  vector<vector<double>> summation_data_in {
    {3.0, 2.0, 2.0},
    {0.0, 2.0, 0.0},
    {5.0, 4.0, 1.0}
  };

  vector<vector<double>> multiplication_data_in {
    {3.0, 2.0, 2.0},
    {0.0, 2.0, 0.0},
    {5.0, 4.0, 1.0}
  };


  double dot_product_data_out = 16.0;

  double cosine_similarity_data_out = 1.0;

  double module_data_out = 5.0;


  vector<double> convolution_data_out{1.0, 5.0, 12.0};

  vector<double> summation_data_out{7.0, 2.0, 10.0};

  vector<double> multiplication_data_out{12.0, 0.0, 20.0};


  assert(MathAlgebra.ntm_dot_product(dot_product_data_a_in, dot_product_data_b_in) == dot_product_data_out);

  assert(MathAlgebra.ntm_vector_cosine_similarity(cosine_similarity_data_a_in, cosine_similarity_data_b_in) == cosine_similarity_data_out);

  assert(MathAlgebra.ntm_vector_module(module_data_in) == module_data_out);


  assert(MathAlgebra.ntm_vector_convolution(convolution_data_a_in, convolution_data_b_in) == convolution_data_out);

  assert(MathAlgebra.ntm_vector_summation(summation_data_in) == summation_data_out);

  assert(MathAlgebra.ntm_vector_multiplication(multiplication_data_in) == multiplication_data_out);

  return 0;
}
