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

pub fn ntm_matrix_product(multiplier: Vec<Vec<f64>>, multiplicand: Vec<Vec<f64>>) -> Vec<Vec<f64>> {
    // Multiply two matching matrices.
    let mut result: Vec<Vec<f64>> = vec![];

    // The multiplier needs to have the same amount of columns as the multiplicand has rows.
    let mut temporal;

    // Using variable to compare lenghts of rows in multiplicand later
    let row_right_length = multiplicand[0].len();

    for row_left in 0..multiplier.len() {
        if multiplier[row_left].len() != multiplicand.len() {
            panic!("Matrix dimensions do not match");
        }
        result.push(vec![]);
        for column_right in 0..multiplicand[0].len() {
            temporal = 0.0;
            for row_right in 0..multiplicand.len() {
                if row_right_length != multiplicand[row_right].len() {
                    // If row is longer than a previous row cancel operation with error
                    panic!("Matrix dimensions do not match");
                }
                temporal += multiplier[row_left][row_right] * multiplicand[row_right][column_right];
            }
            result[row_left].push(temporal);
        }
    }
    result
}

fn main() {
    let input_a: Vec<Vec<f64>> = vec![
        vec![1.0, 2.0, 3.0],
        vec![4.0, 2.0, 6.0],
        vec![3.0, 4.0, 1.0],
        vec![2.0, 4.0, 8.0]
    ];
    let input_b: Vec<Vec<f64>> = vec![
        vec![1.0, 3.0, 3.0, 2.0],
        vec![7.0, 6.0, 2.0, 1.0],
        vec![3.0, 4.0, 2.0, 1.0]
    ];

    let output: Vec<Vec<f64>> = vec![
        vec![24.0, 27.0, 13.0, 7.0],
        vec![36.0, 48.0, 28.0, 16.0],
        vec![34.0, 37.0, 19.0, 11.0],
        vec![54.0, 62.0, 30.0, 16.0]
    ];

    assert_eq!(ntm_matrix_product(input_a, input_b), output);
}
