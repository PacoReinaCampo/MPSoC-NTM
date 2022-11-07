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

pub fn ntm_tensor_adder(input_a: Vec<Vec<Vec<i32>>>, input_b: Vec<Vec<Vec<i32>>>) -> Vec<Vec<Vec<i32>>> {
    // Add two tensors of identical dimensions
    let mut result: Vec<Vec<Vec<i32>>> = vec![vec![]];

    if input_a.len() != input_b.len() {
        panic!("Tensor dimensions do not match");
    }

    for block in 0..input_a.len() {
        if input_a[block].len() != input_b[block].len() {
            panic!("Tensor dimensions do not match");
        }
        result.push(vec![]);
        for row in 0..input_b[0].len() {
            if input_a[block][row].len() != input_b[block][row].len() {
                panic!("Tensor dimensions do not match");
            }
            result.push(vec![vec![]]);
            for column in 0..input_b[0][0].len() {
                result[block][row].push(input_a[block][row][column] + input_b[block][row][column]);
            }
        }
    }
    result
}

fn main() {
    let input_a: Vec<Vec<Vec<i32>>> = vec![
        vec![vec![1, 0, 1], vec![0, 2, 0], vec![5, 0, 1]],
        vec![vec![1, 0, 1], vec![0, 2, 0], vec![5, 0, 1]],
        vec![vec![1, 0, 1], vec![0, 2, 0], vec![5, 0, 1]]
    ];
    let input_b: Vec<Vec<Vec<i32>>> = vec![
        vec![vec![1, 0, 0], vec![0, 1, 0], vec![0, 0, 1]],
        vec![vec![1, 0, 0], vec![0, 1, 0], vec![0, 0, 1]],
        vec![vec![1, 0, 0], vec![0, 1, 0], vec![0, 0, 1]]
    ];

    let output: Vec<Vec<Vec<i32>>> = vec![
        vec![vec![2, 0, 1], vec![0, 3, 0], vec![5, 0, 2]],
        vec![vec![2, 0, 1], vec![0, 3, 0], vec![5, 0, 2]],
        vec![vec![2, 0, 1], vec![0, 3, 0], vec![5, 0, 2]]
    ];

    assert_eq!(ntm_tensor_adder(input_a, input_b), output);
}
