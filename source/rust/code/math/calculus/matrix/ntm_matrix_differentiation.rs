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

pub fn ntm_matrix_differentiation(data_in: Vec<Vec<f64>>, length_i_in: f64, length_j_in: f64, control: u8) -> Vec<Vec<f64>> {
    let mut temporal: f64;

    let mut data_out: Vec<Vec<f64>> = vec![];

    for i in 0..data_in.len() {
        let mut vector: Vec<f64> = vec![];

        for j in 0..data_in[0].len() {
            if control == 0 {
                if i == 0 {
                    temporal = 0.0;
                }
                else {
                    temporal = (data_in[i][j] - data_in[i-1][j])/length_i_in;
                }
            }
            else {
                if j == 0 {
                    temporal = 0.0;
                }
                else {
                    temporal = (data_in[i][j] - data_in[i][j-1])/length_j_in;
                }
            }
            vector.push(temporal);
        }
        data_out.push(vector);
    }
    data_out
}

fn main() {
    let data_in: Vec<Vec<f64>> = vec![
        vec![6.3226113886226751, 3.1313826152262876, 8.3512687816132226],
        vec![4.3132651822261687, 5.3132616875182226, 6.6931471805599454],
        vec![9.9982079678583020, 7.9581688450893644, 2.9997639589554603]
    ];

    let data_out: Vec<Vec<f64>> = vec![
        vec![0.0, -3.1912287733963870,  5.2198861663869350],
        vec![0.0,  0.9999965052920539,  1.3798854930417228],
        vec![0.0, -2.0400391227689383, -4.9584048861339040]
    ];

    assert_eq!(ntm_matrix_differentiation(data_in, 1.0, 1.0, 1), data_out);
}
