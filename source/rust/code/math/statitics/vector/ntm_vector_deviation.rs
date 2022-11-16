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

pub fn ntm_vector_deviation(matrix: Vec<Vec<f64>>, mean: Vec<f64>) -> Vec<f64> {
    let mut data_out: Vec<f64> = vec![];

    for i in 0..matrix.len() {
        let mut temporal: f64 = 0.0;

        for j in 0..matrix[i].len() {
            temporal += (matrix[i][j] - mean[i])*(matrix[i][j] - mean[i])/matrix[0].len() as f64;
        }
        data_out.push(temporal.sqrt());
    }
    data_out
}

fn main() {
    let data_in_0: Vec<Vec<f64>> = vec![
        vec![3.0, 2.0, 2.0],
        vec![0.0, 2.0, 0.0],
        vec![5.0, 4.0, 1.0]
    ];
    let data_in_1: Vec<Vec<f64>> = vec![
        vec![1.0, 0.0, 0.0],
        vec![0.0, 1.0, 0.0],
        vec![0.0, 0.0, 1.0]
    ];

    let mean_0: Vec<f64> = vec![11.0, 12.0, 10.0];
    let mean_1: Vec<f64> = vec![10.0, 11.0, 12.0];

    let data_out_0: Vec<f64> = vec![8.679477710861024, 11.372481406154654, 6.879922480183431];
    let data_out_1: Vec<f64> = vec![9.678154093971983, 10.677078252031311, 11.67618659209133];

    assert_eq!(ntm_vector_deviation(data_in_0, mean_0), data_out_0);
    assert_eq!(ntm_vector_deviation(data_in_1, mean_1), data_out_1);
}
