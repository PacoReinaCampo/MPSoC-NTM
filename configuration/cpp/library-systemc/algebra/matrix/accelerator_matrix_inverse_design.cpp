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

#include "systemc.h"

#define SIZE_I_IN 4
#define SIZE_J_IN 4

SC_MODULE(matrix_inverse) {
  sc_in_clk clock;
  sc_in<sc_int<64>> data_in[SIZE_I_IN][SIZE_J_IN];

  sc_out<sc_int<64>> data_out[SIZE_I_IN][SIZE_J_IN];

  SC_CTOR(matrix_inverse) {
    SC_METHOD(inverse);
    sensitive << clock.pos();
    for (int i = 0; i < SIZE_I_IN; i++) {
      for (int j = 0; j < SIZE_J_IN; j++) {
        sensitive << data_in[i][j];
      }
    }
  }

  void inverse() {
    sc_signal<sc_int<64>> vector_in_int[8];
    sc_signal<sc_int<64>> matrix_in_int[8][8];

    sc_signal<int> scalar_ratio_int;
    sc_signal<int> scalar_sum_int;

    // Augmenting Identity Matrix of Order SIZE_IN
    for (int i = 0; i < SIZE_I_IN; i++) {
      for (int j = 0; j < SIZE_J_IN; j++) {
        matrix_in_int[i][j].write(data_in[i][j].read());

        if (i = j) {
          matrix_in_int[i][j + 4].write(1);
        } else {
          matrix_in_int[i][j + 4].write(0);
        }
      }
    }

    for (int i = 0; i < SIZE_I_IN; i++) {
      // Row swapping
      int n = 1;

      while (data_in[i][i].read() == 0) {
        for (int j = 0; j < 8; j++) {
          vector_in_int[j].write(matrix_in_int[i][j].read());
        }

        if (i < 8) {
          for (int j = 0; j < 8; j++) {
            matrix_in_int[i][j].write(matrix_in_int[i + n][j].read());
          }

          for (int j = 0; j < 8; j++) {
            matrix_in_int[i + n][j].write(vector_in_int[j].read());
          }
        } else {
          for (int j = 0; j < 8; j++) {
            matrix_in_int[i][j].write(matrix_in_int[i - n][j].read());
          }

          for (int j = 0; j < 8; j++) {
            matrix_in_int[i - n][j].write(vector_in_int[j].read());
          }
        }

        n++;
      }

      // Applying Gauss Jordan Elimination
      for (int j = 0; j < SIZE_J_IN; j++) {
        if (i != j) {
          scalar_ratio_int.write(matrix_in_int[j][i].read() / matrix_in_int[i][i].read());

          for (int m = 0; m < 8; m++) {
            scalar_sum_int.write(scalar_ratio_int.read() * matrix_in_int[i][m].read());

            matrix_in_int[j][m].write(matrix_in_int[j][m].read() - scalar_sum_int.read());
          }
        }
      }
    }

    // Row Operation to Make Principal Diagonal to 1
    for (int i = 0; i < SIZE_I_IN; i++) {
      for (int j = 0; j < SIZE_J_IN; j++) {
        matrix_in_int[i][j].write(matrix_in_int[i][j].read() / matrix_in_int[i][i].read());
      }
    }

    // Output
    for (int i = 0; i < SIZE_I_IN; i++) {
      for (int j = 0; j < SIZE_J_IN; j++) {
        data_out[i][j].write(matrix_in_int[i][j + 4].read());
      }
    }
  }
};
