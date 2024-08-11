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

#include "ntm_matrix_vector_product_design.cpp"
#include "systemc.h"

int sc_main(int argc, char *argv[]) {
  matrix_vector_product matrix_vector_product("MATRIX_VECTOR_PRODUCT");

  sc_signal<bool> clock;
  sc_signal<sc_int<64>> data_a_in[SIZE_I_IN][SIZE_J_IN];
  sc_signal<sc_int<64>> data_b_in[SIZE_I_IN];
  sc_signal<sc_int<64>> data_out[SIZE_I_IN];

  matrix_vector_product.clock(clock);

  for (int i = 0; i < SIZE_I_IN; i++) {
    for (int j = 0; j < SIZE_J_IN; j++) {
      matrix_vector_product.data_a_in[i][j](data_a_in[i][j]);
    }
    matrix_vector_product.data_b_in[i](data_b_in[i]);

    matrix_vector_product.data_out[i](data_out[i]);
  }

  for (int i = 0; i < SIZE_I_IN; i++) {
    for (int j = 0; j < SIZE_J_IN; j++) {
      data_a_in[i][j] = i + j;
    }
    data_b_in[i] = i;
  }

  clock = 0;
  sc_start(1, SC_NS);
  clock = 1;
  sc_start(1, SC_NS);

  for (int i = 0; i < SIZE_I_IN; i++) {
    cout << "@" << sc_time_stamp() << ": data_out[" << i << "] = " << data_out[i].read() << endl;
  }

  return 0;
}
