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

extern crate math_algebra;

use math_algebra::vector::ntm_dot_product::*;
use math_algebra::vector::ntm_vector_convolution::*;
use math_algebra::vector::ntm_vector_cosine_similarity::*;
use math_algebra::vector::ntm_vector_module::*;
use math_algebra::vector::ntm_vector_multiplication::*;
use math_algebra::vector::ntm_vector_summation::*;

fn main() {
    let mut data_a_in: Vec<f64>;
    let mut data_b_in: Vec<f64>;

    let mut data_out: f64;

    data_a_in = vec![1.0, 2.0, 3.0];
    data_b_in = vec![1.0, 3.0, 3.0];

    data_out = 16.0;

    assert_eq!(ntm_dot_product(data_a_in, data_b_in), data_out);

    data_a_in = vec![4.0, 0.0, 3.0];
    data_b_in = vec![4.0, 0.0, 3.0];

    data_out = 1.0;

    assert_eq!(ntm_vector_cosine_similarity(data_a_in, data_b_in), data_out);

    let data_in: Vec<f64> = vec![4.0, 0.0, 3.0];

    data_out = 5.0;

    assert_eq!(ntm_vector_module(data_in), data_out);

    data_a_in = vec![1.0, 2.0, 3.0];
    data_b_in = vec![1.0, 3.0, 3.0];

    let data_out: Vec<f64> = vec![1.0, 5.0, 12.0];

    assert_eq!(ntm_vector_convolution(data_a_in, data_b_in), data_out);

    let mut data_in_0: Vec<Vec<f64>>;
    let mut data_in_1: Vec<Vec<f64>>;

    let mut data_out_0: Vec<f64>;
    let mut data_out_1: Vec<f64>;

    data_in_0 = vec![
        vec![3.0, 2.0, 2.0],
        vec![0.0, 2.0, 0.0],
        vec![5.0, 4.0, 1.0]
    ];
    data_in_1 = vec![
        vec![1.0, 0.0, 0.0],
        vec![0.0, 1.0, 0.0],
        vec![0.0, 0.0, 1.0]
    ];

    data_out_0 = vec![12.0, 0.0, 20.0];
    data_out_1 = vec![0.0, 0.0, 0.0];

    assert_eq!(ntm_vector_multiplication(data_in_0), data_out_0);
    assert_eq!(ntm_vector_multiplication(data_in_1), data_out_1);

    data_in_0 = vec![
        vec![3.0, 2.0, 2.0],
        vec![0.0, 2.0, 0.0],
        vec![5.0, 4.0, 1.0]
    ];
    data_in_1 = vec![
        vec![1.0, 0.0, 0.0],
        vec![0.0, 1.0, 0.0],
        vec![0.0, 0.0, 1.0]
    ];

    data_out_0 = vec![7.0, 2.0, 10.0];
    data_out_1 = vec![1.0, 1.0, 1.0];

    assert_eq!(ntm_vector_summation(data_in_0), data_out_0);
    assert_eq!(ntm_vector_summation(data_in_1), data_out_1);
}
