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

use math::matrix::ntm_matrix_logistic_function::*;
use math::matrix::ntm_matrix_oneplus_function::*;
use math::matrix::ntm_matrix_mean::*;
use math::matrix::ntm_matrix_deviation::*;

fn main() {
    let mut data_in: Vec<Vec<f64>>;

    let mut data_out: Vec<Vec<f64>>;

    data_in = vec![
        vec![6.3226113886226751, 3.1313826152262876, 8.3512687816132226],
        vec![4.3132651822261687, 5.3132616875182226, 6.6931471805599454],
        vec![9.9982079678583020, 7.9581688450893644, 2.9997639589554603]
    ];

    data_out = vec![
        vec![0.9982079678583020, 0.9581688450893644, 0.9997639589554603],
        vec![0.9867871586112067, 0.9950983109503272, 0.9987621580633643],
        vec![0.9999545207076224, 0.9996503292557579, 0.9525634621372647]
    ];

    assert_eq!(ntm_matrix_logistic_function(data_in), data_out);

    data_in = vec![
        vec![6.3226113886226751, 3.1313826152262876, 8.3512687816132226],
        vec![4.3132651822261687, 5.3132616875182226, 6.6931471805599454],
        vec![9.9982079678583020, 7.9581688450893644, 2.9997639589554603]
    ];

    data_out = vec![
        vec![ 7.324405028374851, 4.174113884283648, 9.351504850519834],
        vec![ 5.326566089800315, 6.318175429247454, 7.694385789255728],
        vec![10.998253448184894, 8.958518576982677, 4.048362506240452]
    ];

    assert_eq!(ntm_matrix_oneplus_function(data_in), data_out);

    let mut data_in_0: Vec<Vec<Vec<f64>>>;
    let mut data_in_1: Vec<Vec<Vec<f64>>>;

    let mut data_out_0: Vec<Vec<f64>>;
    let mut data_out_1: Vec<Vec<f64>>;

    data_in_0 = vec![
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
    data_in_1 = vec![
        vec![
            vec![0.0, 2.0, 0.0],
            vec![3.0, 2.0, 2.0],
            vec![5.0, 4.0, 1.0]
        ],
        vec![
            vec![0.0, 2.0, 0.0],
            vec![3.0, 2.0, 2.0],
            vec![5.0, 4.0, 1.0]
        ],
        vec![
            vec![0.0, 2.0, 0.0],
            vec![3.0, 2.0, 2.0],
            vec![5.0, 4.0, 1.0]
        ]
    ];

    data_out_0 = vec![
        vec![2.333333333333333, 0.6666666666666666, 3.3333333333333335],
        vec![2.333333333333333, 0.6666666666666666, 3.3333333333333335],
        vec![2.333333333333333, 0.6666666666666666, 3.3333333333333335]
    ];
    data_out_1 = vec![
        vec![0.6666666666666666, 2.333333333333333, 3.3333333333333335], 
        vec![0.6666666666666666, 2.333333333333333, 3.3333333333333335],
        vec![0.6666666666666666, 2.333333333333333, 3.3333333333333335]
    ];

    assert_eq!(ntm_matrix_mean(data_in_0), data_out_0);
    assert_eq!(ntm_matrix_mean(data_in_1), data_out_1);

    data_in_0 = vec![
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
    data_in_1 = vec![
        vec![
            vec![1.0, 0.0, 0.0],
            vec![0.0, 1.0, 0.0],
            vec![0.0, 0.0, 1.0]
        ],
        vec![
            vec![1.0, 0.0, 0.0],
            vec![0.0, 1.0, 0.0],
            vec![0.0, 0.0, 1.0]
        ],
        vec![
            vec![1.0, 0.0, 0.0],
            vec![0.0, 1.0, 0.0],
            vec![0.0, 0.0, 1.0]
        ]
    ];

    let mean_0: Vec<Vec<f64>> = vec![
        vec![11.0, 12.0, 10.0],
        vec![11.0, 12.0, 10.0],
        vec![11.0, 12.0, 10.0]
    ];
    let mean_1: Vec<Vec<f64>> = vec![
        vec![12.0, 10.0, 11.0],
        vec![12.0, 10.0, 11.0],
        vec![12.0, 10.0, 11.0]
    ];

    data_out_0 = vec![
        vec![8.679477710861024, 11.372481406154654, 6.879922480183431],
        vec![8.679477710861024, 11.372481406154654, 6.879922480183431],
        vec![8.679477710861024, 11.372481406154654, 6.879922480183431]
    ];
    data_out_1 = vec![
        vec![11.67618659209133, 9.678154093971983, 10.677078252031311],
        vec![11.67618659209133, 9.678154093971983, 10.677078252031311],
        vec![11.67618659209133, 9.678154093971983, 10.677078252031311]
    ];

    assert_eq!(ntm_matrix_deviation(data_in_0, mean_0), data_out_0);
    assert_eq!(ntm_matrix_deviation(data_in_1, mean_1), data_out_1);
}
