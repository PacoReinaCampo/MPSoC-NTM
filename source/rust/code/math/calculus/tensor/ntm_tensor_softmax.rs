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

pub fn ntm_tensor_softmax(data_in: Vec<Vec<Vec<f64>>>) -> Vec<Vec<Vec<f64>>> {
    let mut temporal0: f64 = 0.0;

    let mut data_matrix_int: Vec<Vec<f64>> = vec![];
    let mut data_tensor_int: Vec<Vec<Vec<f64>>> = vec![];

    let mut data_out: Vec<Vec<Vec<f64>>> = vec![];

    for i in 0..data_in.len() {

        let mut matrix0: Vec<Vec<f64>> = vec![];

        for j in 0..data_in[0].len() {

            let mut vector0: Vec<f64> = vec![];

            for k in 0..data_in[0][0].len() {
                temporal0 += data_in[i][j][k].exp();

                let temporal1: f64 = data_in[i][j][k].exp();

                vector0.push(temporal1);
            }
            data_matrix_int.push(vector0);

            data_tensor_int.push(data_matrix_int);

            let mut vector1: Vec<f64> = vec![];

            for k in 0..data_in[0][0].len() {
                vector1.push(data_tensor_int[i][j][k]/temporal0);
            }
            matrix0.push(vector1);
        }
        data_out.push(matrix0);
    }
    data_out
}

fn main() {
    let data_in: Vec<Vec<Vec<f64>>> = vec![
        vec![
            vec![6.3226113886226751, 3.1313826152262876, 8.3512687816132226],
            vec![4.3132651822261687, 5.3132616875182226, 6.6931471805599454],
            vec![9.9982079678583020, 7.9581688450893644, 2.9997639589554603]
        ],
        vec![
            vec![6.3226113886226751, 3.1313826152262876, 8.3512687816132226],
            vec![4.3132651822261687, 5.3132616875182226, 6.6931471805599454],
            vec![9.9982079678583020, 7.9581688450893644, 2.9997639589554603]
        ],
        vec![
            vec![6.3226113886226751, 3.1313826152262876, 8.3512687816132226],
            vec![4.3132651822261687, 5.3132616875182226, 6.6931471805599454],
            vec![9.9982079678583020, 7.9581688450893644, 2.9997639589554603]
        ]
    ];

    let data_out: Vec<Vec<Vec<f64>>> = vec![
        vec![
            vec![0.115673909555040450, 0.004756662822010267, 0.8795694276229492000],
            vec![0.012658220095684168, 0.034408489418901890, 0.1367547003294767900],
            vec![0.714653980863293200, 0.092921900422636110, 0.0006526948744619639]
        ],
        vec![
            vec![0.115673909555040450, 0.004756662822010267, 0.8795694276229492000],
            vec![0.012658220095684168, 0.034408489418901890, 0.1367547003294767900],
            vec![0.714653980863293200, 0.092921900422636110, 0.0006526948744619639]
        ],
        vec![
            vec![0.115673909555040450, 0.004756662822010267, 0.8795694276229492000],
            vec![0.012658220095684168, 0.034408489418901890, 0.1367547003294767900],
            vec![0.714653980863293200, 0.092921900422636110, 0.0006526948744619639]
        ]
    ];

    assert_eq!(ntm_tensor_softmax(data_in), data_out);
}
