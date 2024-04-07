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

class TensorAlgebra {
  public:
    vector<vector<vector<double>>> ntm_tensor_differentiation(vector<vector<vector<double>>> data_in, double length_i_in, double length_j_in, double length_k_in, int control);
    vector<vector<vector<double>>> ntm_tensor_integration(vector<vector<vector<double>>> data_in, double length_in);
    vector<vector<vector<double>>> ntm_tensor_softmax(vector<vector<vector<double>>> data_in);
};

vector<vector<vector<double>>> TensorAlgebra::ntm_tensor_differentiation(vector<vector<vector<double>>> data_in, double length_i_in, double length_j_in, double length_k_in, int control) {

  double temporal;

  vector<vector<vector<double>>> data_out;

  for (int i = 0; i < data_in[0].size(); i++) {
    vector<vector<double>> matrix;

    for (int j = 0; j < data_in[0].size(); j++) {
      vector<double> vector;

      for (int k = 0; k < data_in[0][0].size(); k++) {
        if (control == 0) {
          if (i == 0) {
            temporal = 0.0;
          }
          else {
            temporal = (data_in[i][j][k] - data_in[i-1][j][k])/length_i_in;
          }
        }
        else if (control == 1) {
          if (j == 0) {
            temporal = 0.0;
          }
          else {
            temporal = (data_in[i][j][k] - data_in[i][j-1][k])/length_j_in;
          }
        }
        else {
          if (k == 0) {
            temporal = 0.0;
          }
          else {
            temporal = (data_in[i][j][k] - data_in[i][j][k-1])/length_k_in;
          }
        }
        vector.push_back(temporal);
      }
      matrix.push_back(vector);
    }
    data_out.push_back(matrix);
  }

  return data_out;
}

vector<vector<vector<double>>> TensorAlgebra::ntm_tensor_integration(vector<vector<vector<double>>> data_in, double length_in) {

  vector<vector<vector<double>>> data_out;

  for (int i = 0; i < data_in.size(); i++) {

    vector<vector<double>> matrix;

    for (int j = 0; j < data_in[0].size(); j++) {
      double temporal = 0.0;

      vector<double> vector;

      for (int k = 0; k < data_in[0][0].size(); k++) {
        temporal += data_in[i][j][k];

        vector.push_back(temporal*length_in);
      }
      matrix.push_back(vector);
    }
    data_out.push_back(matrix);
  }

  return data_out;
}

vector<vector<vector<double>>> TensorAlgebra::ntm_tensor_softmax(vector<vector<vector<double>>> data_in) {
  double temporal0 = 0.0;

  vector<vector<double>> data_matrix_int;

  vector<vector<vector<double>>> data_tensor_int;

  vector<vector<vector<double>>> data_out;

  for (int i = 0; i < data_in[0].size(); i++) {

    vector<vector<double>> matrix0;

    for (int j = 0; j < data_in[0].size(); j++) {

      vector<double> vector0;

      for (int k = 0; k < data_in[0][0].size(); k++) {
        temporal0 += exp(data_in[i][j][k]);

        double temporal1 = exp(data_in[i][j][k]);

        vector0.push_back(temporal1);
      }
      data_matrix_int.push_back(vector0);
    }
    data_tensor_int.push_back(data_matrix_int);

    vector<vector<double>> matrix1;

    for (int j = 0; j < data_in[0].size(); j++) {
    
      vector<double> vector1;

      for (int k = 0; k < data_in[0][0].size(); k++) {
        vector1.push_back(data_tensor_int[i][j][k]/temporal0);
      }
      matrix1.push_back(vector1);
    }
    data_out.push_back(matrix1);
  }

  return data_out;
}

int main() {

  TensorAlgebra Algebra;

  vector<vector<vector<double>>> data_in {
    {
      { 6.3226113886226751, 3.1313826152262876, 8.3512687816132226 },
      { 4.3132651822261687, 5.3132616875182226, 6.6931471805599454 },
      { 9.9982079678583020, 7.9581688450893644, 2.9997639589554603 }
    },
    {
      { 6.3226113886226751, 3.1313826152262876, 8.3512687816132226 },
      { 4.3132651822261687, 5.3132616875182226, 6.6931471805599454 },
      { 9.9982079678583020, 7.9581688450893644, 2.9997639589554603 }
    },
    {
      { 6.3226113886226751, 3.1313826152262876, 8.3512687816132226 },
      { 4.3132651822261687, 5.3132616875182226, 6.6931471805599454 },
      { 9.9982079678583020, 7.9581688450893644, 2.9997639589554603 }
    }
  };

  vector<vector<vector<double>>> differentiation_data_out {
    {
      {  0.000000000000000, 0.000000000000000,  0.0000000000000000 },
      { -2.009346206396506, 2.181879072291935, -1.6581216010532778 },
      {  5.684942785632134, 2.644907157571142, -3.6933832216044853 }
    },
    {
      {  0.000000000000000, 0.000000000000000,  0.0000000000000000 },
      { -2.009346206396506, 2.181879072291935, -1.6581216010532778 },
      {  5.684942785632134, 2.644907157571142, -3.6933832216044853 }
    },
    {
      {  0.000000000000000, 0.000000000000000,  0.0000000000000000 },
      { -2.009346206396506, 2.181879072291935,-1.65812160105327780 },
      {  5.684942785632134, 2.644907157571142, -3.6933832216044853 }
    }
  };

  vector<vector<vector<double>>> integration_data_out {
    {
      { 6.322611388622675,  9.453994003848962, 17.805262785462183 },
      { 4.313265182226169,  9.626526869744392, 16.319674050304336 },
      { 9.998207967858303, 17.956376812947667, 20.956140771903126 }
    },
    {
      { 6.322611388622675,  9.453994003848962, 17.805262785462183 },
      { 4.313265182226169,  9.626526869744392, 16.319674050304336 },
      { 9.998207967858303, 17.956376812947667, 20.956140771903126 }
    },
    {
      { 6.322611388622675,  9.453994003848962, 17.805262785462183 },
      { 4.313265182226169,  9.626526869744392, 16.319674050304336 },
      { 9.998207967858303, 17.956376812947667, 20.956140771903126 }
    }
  };

  vector<vector<vector<double>>> softmax_data_out {
    {
      { 0.0181052491311145360, 0.0007445115822270013, 0.1376699696282669000 },
      { 0.0024274848910245004, 0.0065985650080329240, 0.0262256435989427600 },
      { 0.7146539808632932000, 0.0929219004226361100, 0.0006526948744619639 }
    },
    {
      { 0.0090526245655572700, 0.0003722557911135007, 0.068834984814133460 },
      { 0.0012137424455122502, 0.0032992825040164620, 0.013112821799471382 },
      { 0.3573269904316467000, 0.0464609502113180540, 0.000326347437230982 }
    },
    {
      { 0.0060350830437048470, 0.0002481705274090005, 0.04588998987608898000 },
      { 0.0008091616303415002, 0.0021995216693443080, 0.00874188119964758800 },
      { 0.2382179936210978000, 0.0309739668075453730, 0.00021756495815398801 }
    }
  };

  assert(Algebra.ntm_tensor_differentiation(data_in, 1.0, 1.0, 1.0, 1) == differentiation_data_out);

  assert(Algebra.ntm_tensor_integration(data_in, 1.0) == integration_data_out);

  assert(Algebra.ntm_tensor_softmax(data_in) == softmax_data_out);

  return 0;
}
