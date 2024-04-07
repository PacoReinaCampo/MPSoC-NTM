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

extern crate algebra;

use algebra::matrix::ntm_matrix_differentiation::*;
use algebra::matrix::ntm_matrix_integration::*;
use algebra::matrix::ntm_matrix_softmax::*;

fn main() {
    let mut data_a_in: Vec<Vec<f64>>;
    let mut data_b_in: Vec<Vec<f64>>;

    let mut data_out: Vec<Vec<f64>>;

    data_a_in = vec![
        vec![1.0, 2.0, 3.0],
        vec![4.0, 2.0, 6.0],
        vec![3.0, 4.0, 1.0],
        vec![2.0, 4.0, 8.0]
    ];
    data_b_in = vec![
        vec![1.0],
        vec![7.0],
        vec![3.0]
    ];

    data_out = vec![
        vec![24.0],
        vec![36.0],
        vec![34.0],
        vec![54.0]
    ];

    assert_eq!(ntm_matrix_vector_product(data_a_in, data_b_in), data_out);

    data_a_in = vec![
        vec![1.0, 2.0, 3.0],
        vec![4.0, 2.0, 6.0],
        vec![3.0, 4.0, 1.0]
    ];
    data_b_in = vec![
        vec![1.0],
        vec![7.0],
        vec![3.0]
    ];

    data_out = vec![
        vec![ 1.0],
        vec![11.0],
        vec![34.0]
    ];

    assert_eq!(ntm_matrix_vector_convolution(data_a_in, data_b_in), data_out);

    let mut data_b_in: Vec<Vec<f64>>;

    let mut data_out: Vec<Vec<f64>>;

    data_a_in = vec![
        vec![1.0, 2.0, 3.0],
        vec![4.0, 2.0, 6.0],
        vec![3.0, 4.0, 1.0],
        vec![2.0, 4.0, 8.0]
    ];
    data_b_in = vec![
        vec![1.0, 3.0, 3.0, 2.0],
        vec![7.0, 6.0, 2.0, 1.0],
        vec![3.0, 4.0, 2.0, 1.0]
    ];

    data_out = vec![
        vec![24.0, 27.0, 13.0, 7.0],
        vec![36.0, 48.0, 28.0, 16.0],
        vec![34.0, 37.0, 19.0, 11.0],
        vec![54.0, 62.0, 30.0, 16.0]
    ];

    assert_eq!(ntm_matrix_product(data_a_in, data_b_in), data_out);

    data_a_in = vec![
        vec![1.0, 2.0, 3.0],
        vec![4.0, 2.0, 6.0],
        vec![3.0, 4.0, 1.0]
    ];
    data_b_in = vec![
        vec![1.0, 3.0, 3.0],
        vec![7.0, 6.0, 2.0],
        vec![3.0, 4.0, 2.0]
    ];

    data_out = vec![
        vec![ 1.0,  5.0,  12.0],
        vec![11.0, 34.0,  59.0],
        vec![34.0, 61.0, 103.0]
    ];

    assert_eq!(ntm_matrix_convolution(data_a_in, data_b_in), data_out);

    let mut data_in: Vec<Vec<f64>>;

    let mut data_out: Vec<Vec<f64>>;

    data_in = vec![
        vec![3.0, 4.0, 2.0],
        vec![0.0, 1.0, 3.0],
        vec![3.0, 1.0, 1.0]
    ];
    data_out = vec![
        vec![3.0, 0.0, 3.0],
        vec![4.0, 1.0, 1.0],
        vec![2.0, 3.0, 1.0]
    ];

    assert_eq!(ntm_matrix_transpose(data_in), data_out);

    data_in = vec![
        vec![ 0.0, -1.0,  0.0],
        vec![-1.0,  2.0, -1.0],
        vec![ 0.0, -1.0,  2.0]
    ];

    let mut reference = &mut data_in;

    let double_reference = &mut reference;

    data_out = vec![
        vec![-1.5, -1.0, -0.5],
        vec![-1.0,  0.0,  0.0],
        vec![-0.5,  0.0,  0.5]
    ];

    assert_eq!(ntm_matrix_inverse(double_reference), data_out);

    let mut data_in: Vec<Vec<Vec<f64>>>;

    let mut data_out: Vec<Vec<f64>>;

    data_in = vec![
        vec![
            vec![3.0, 2.0, 2.0],
            vec![0.0, 2.0, 0.0],
            vec![5.0, 4.0, 1.0]
        ],
        vec![
            vec![3.0, 2.0, 2.0],
            vec![0.0, 2.0, 0.0],
            vec![5.0, 4.0, 1.0]
        ],
        vec![
            vec![3.0, 2.0, 2.0],
            vec![0.0, 2.0, 0.0],
            vec![5.0, 4.0, 1.0]
        ]
    ];

    data_out = vec![
        vec![12.0, 0.0, 20.0],
        vec![12.0, 0.0, 20.0],
        vec![12.0, 0.0, 20.0]
    ];

    assert_eq!(ntm_matrix_multiplication(data_in), data_out);

    data_in = vec![
        vec![
            vec![3.0, 2.0, 2.0],
            vec![0.0, 2.0, 0.0],
            vec![5.0, 4.0, 1.0]
        ],
        vec![
            vec![3.0, 2.0, 2.0],
            vec![0.0, 2.0, 0.0],
            vec![5.0, 4.0, 1.0]
        ],
        vec![
            vec![3.0, 2.0, 2.0],
            vec![0.0, 2.0, 0.0],
            vec![5.0, 4.0, 1.0]
        ]
    ];

    data_out = vec![
        vec![7.0, 2.0, 10.0],
        vec![7.0, 2.0, 10.0],
        vec![7.0, 2.0, 10.0]
    ];

    assert_eq!(ntm_matrix_summation(data_in), data_out);

    let data_a_in: Vec<f64> = vec![1.0, 2.0, 3.0, 4.0];
    let data_b_in: Vec<f64> = vec![1.0, 3.0, 2.0];

    data_out = vec![
        vec![1.0, 3.0, 2.0],
        vec![2.0, 6.0, 4.0],
        vec![3.0, 9.0, 6.0],
        vec![4.0, 12.0, 8.0]
    ];

    assert_eq!(ntm_transpose_vector_product(data_a_in, data_b_in), data_out);

    let mut data_in: Vec<Vec<f64>>;

    let mut data_out: Vec<Vec<f64>>;

    data_in = vec![
        vec![6.3226113886226751, 3.1313826152262876, 8.3512687816132226],
        vec![4.3132651822261687, 5.3132616875182226, 6.6931471805599454],
        vec![9.9982079678583020, 7.9581688450893644, 2.9997639589554603]
    ];

    data_out = vec![
        vec![0.0, -3.1912287733963870,  5.2198861663869350],
        vec![0.0,  0.9999965052920539,  1.3798854930417228],
        vec![0.0, -2.0400391227689383, -4.9584048861339040]
    ];

    assert_eq!(ntm_matrix_differentiation(data_in, 1.0, 1.0, 1), data_out);

    data_in = vec![
        vec![6.3226113886226751, 3.1313826152262876, 8.3512687816132226],
        vec![4.3132651822261687, 5.3132616875182226, 6.6931471805599454],
        vec![9.9982079678583020, 7.9581688450893644, 2.9997639589554603]
    ];

    data_out = vec![
        vec![6.322611388622675,  9.453994003848962, 17.805262785462183],
        vec![4.313265182226169,  9.626526869744392, 16.319674050304336],
        vec![9.998207967858303, 17.956376812947667, 20.956140771903126]
    ];

    assert_eq!(ntm_matrix_integration(data_in, 1.0), data_out);

    data_in = vec![
        vec![6.3226113886226751, 3.1313826152262876, 8.3512687816132226],
        vec![4.3132651822261687, 5.3132616875182226, 6.6931471805599454],
        vec![9.9982079678583020, 7.9581688450893644, 2.9997639589554603]
    ];

    data_out = vec![
        vec![0.115673909555040450, 0.004756662822010267, 0.8795694276229492000],
        vec![0.012658220095684168, 0.034408489418901890, 0.1367547003294767900],
        vec![0.714653980863293200, 0.092921900422636110, 0.0006526948744619639]
    ];

    assert_eq!(ntm_matrix_softmax(data_in), data_out);
}
