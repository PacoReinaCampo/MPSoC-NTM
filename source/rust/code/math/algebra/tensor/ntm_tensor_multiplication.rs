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

pub fn ntm_tensor_multiplication(matrix: Vec<Vec<i32>>, scalar: i32) -> Vec<Vec<i32>> {
    // Multiply a matrix of any size with a scalar
    let mut result: Vec<Vec<i32>> = vec![Vec::with_capacity(matrix.len()); matrix[0].len()];

    for row in 0..matrix.len() {
        for column in 0..matrix[row].len() {
            result[row].push(scalar * matrix[row][column]);
        }
    }
    result
}

fn main() {
    let input0: Vec<Vec<i32>> = vec![vec![3, 2, 2], vec![0, 2, 0], vec![5, 4, 1]];
    let input1: Vec<Vec<i32>> = vec![vec![1, 0, 0], vec![0, 1, 0], vec![0, 0, 1]];

    let output0: Vec<Vec<i32>> = vec![vec![9, 6, 6], vec![0, 6, 0], vec![15, 12, 3]];
    let output1: Vec<Vec<i32>> = vec![vec![3, 0, 0], vec![0, 3, 0], vec![0, 0, 3]];

    assert_eq!(ntm_tensor_multiplication(input0, 3), output0);
    assert_eq!(ntm_tensor_multiplication(input1, 3), output1);
}
