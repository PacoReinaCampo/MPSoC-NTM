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

vector<vector<double>> ntm_matrix_divider(vector<vector<double>> input_a, vector<vector<double>> input_b) {

  vector<vector<double>> result;

  for (int i = 0; i < input_a.size(); i++) {
    vector<double> vector;

    for (int j = 0; j < input_a[0].size(); j++) {
      double temporal = input_a[i][j] / input_b[i][j];

      vector.push_back(temporal);
    }
    result.push_back(vector);
  }

  return result;
}

int main() {
  vector<vector<double>> input_a {
    { 2.0, 2.0, 2.0 },
    { 0.0, 0.0, 0.0 },
    { 4.0, 4.0, 4.0 }
  };
  vector<vector<double>> input_b {
    { 1.0, 1.0, 1.0 },
    { 1.0, 1.0, 1.0 },
    { 2.0, 2.0, 2.0 }
  };

  vector<vector<double>> output {
    { 2.0, 2.0, 2.0 },
    { 0.0, 0.0, 0.0 },
    { 2.0, 2.0, 2.0 }
  };

  assert(ntm_matrix_divider(input_a, input_b)==output);

  return 0;
}
