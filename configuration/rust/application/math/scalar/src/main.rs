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

extern crate math;

use math::scalar::accelerator_scalar_logistic_function::*;
use math::scalar::accelerator_scalar_oneplus_function::*;
use math::scalar::accelerator_scalar_mean_function::*;
use math::scalar::accelerator_scalar_deviation_function::*;

fn main() {
    let mut data_in_0: f64;
    let mut data_in_1: f64;

    let mut data_out_0: f64;
    let mut data_out_1: f64;

    data_in_0 = 0.8909031788043871;
    data_in_1 = 3.2155195231797550;

    data_out_0 = 0.7090765217957029;
    data_out_1 = 0.9614141454987156;

    assert_eq!(accelerator_scalar_logistic_function(data_in_0), data_out_0);
    assert_eq!(accelerator_scalar_logistic_function(data_in_1), data_out_1);

    data_in_0 = 0.8909031788043871;
    data_in_1 = 3.2155195231797550;

    data_out_0 = 2.2346950078883427;
    data_out_1 = 4.2548695333728740;

    assert_eq!(accelerator_scalar_oneplus_function(data_in_0), data_out_0);
    assert_eq!(accelerator_scalar_oneplus_function(data_in_1), data_out_1);

    let mut data_in_0: Vec<f64>;
    let mut data_in_1: Vec<f64>;

    let mut data_out_0: f64;
    let mut data_out_1: f64;

    data_in_0 = vec![3.0, 1.0, 2.0];
    data_in_1 = vec![1.0, 2.0, 3.0];

    data_out_0 = 2.0;
    data_out_1 = 2.0;

    assert_eq!(accelerator_scalar_mean_function(data_in_0), data_out_0);
    assert_eq!(accelerator_scalar_mean_function(data_in_1), data_out_1);

    data_in_0 = vec![3.0, 2.0, 2.0];
    data_in_1 = vec![1.0, 2.0, 1.0];

    let mean_0: f64 = 10.0;
    let mean_1: f64 = 10.0;

    data_out_0 = 7.681145747868608;
    data_out_1 = 8.679477710861024;

    assert_eq!(accelerator_scalar_deviation_function(data_in_0, mean_0), data_out_0);
    assert_eq!(accelerator_scalar_deviation_function(data_in_1, mean_1), data_out_1);
}
