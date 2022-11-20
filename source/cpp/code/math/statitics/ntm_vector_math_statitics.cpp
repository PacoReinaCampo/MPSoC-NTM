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

class VectorMathStatitics {
  public:
    vector<double> ntm_vector_mean(vector<vector<double>> data_in);
    vector<double> ntm_vector_deviation(vector<vector<double>> data_in, vector<double> mean);
};


vector<double> VectorMathStatitics::ntm_vector_mean(vector<vector<double>> data_in) {
  vector<double> data_out;

  for(int i=0; i<data_in.size(); i++) {
    double temporal = 0.0;

    for(int j=0; j<data_in[0].size(); j++) {
      temporal += data_in[i][j]/(double)data_in[0].size();
    }
    data_out.push_back(temporal);
  }

  return data_out;
}

vector<double> VectorMathStatitics::ntm_vector_deviation(vector<vector<double>> data_in, vector<double> mean) {
  vector<double> data_out;

  for(int i=0; i<data_in.size(); i++) {
    double temporal = 0.0;

    for(int j=0; j<data_in[0].size(); j++) {
      temporal += (data_in[i][j] - mean[i])*(data_in[i][j] - mean[i])/(double)data_in[0].size();
    }
    data_out.push_back(sqrt(temporal));
  }

  return data_out;
}

int main() {

  VectorMathStatitics MathStatitics;

   vector<vector<double>> mean_data_in_0 {
    {3.0, 1.0, 2.0},
    {1.0, 2.0, 0.0},
    {5.0, 3.0, 4.0}
  };
  vector<vector<double>> mean_data_in_1 {
    {1.0, 1.0, 1.0},
    {1.0, 1.0, 1.0},
    {1.0, 1.0, 1.0}
  };

  vector<vector<double>> deviation_data_in_0 {
    {3.0, 2.0, 2.0},
    {0.0, 2.0, 0.0},
    {5.0, 4.0, 1.0}
  };
  vector<vector<double>> deviation_data_in_1 {
    {1.0, 0.0, 0.0},
    {0.0, 1.0, 0.0},
    {0.0, 0.0, 1.0}
  };

  vector<double> mean_0{11.0, 12.0, 10.0};
  vector<double> mean_1{10.0, 11.0, 12.0};
  
  vector<double> mean_data_out_0{2.0, 1.0, 4.0};
  vector<double> mean_data_out_1{1.0, 1.0, 1.0};

  vector<double> deviation_data_out_0{8.679477710861024, 11.372481406154654, 6.879922480183431};
  vector<double> deviation_data_out_1{9.678154093971983, 10.677078252031311, 11.67618659209133};

  assert(MathStatitics.ntm_vector_mean(mean_data_in_0) == mean_data_out_0);
  assert(MathStatitics.ntm_vector_mean(mean_data_in_1) == mean_data_out_1);

  assert(MathStatitics.ntm_vector_deviation(deviation_data_in_0, mean_0) == deviation_data_out_0);
  assert(MathStatitics.ntm_vector_deviation(deviation_data_in_1, mean_1) == deviation_data_out_1);

  return 0;
}
