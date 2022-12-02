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

use math_algebra::tensor::ntm_tensor_convolution::*;
use math_algebra::tensor::ntm_tensor_inverse::*;
use math_algebra::tensor::ntm_tensor_matrix_convolution::*;
use math_algebra::tensor::ntm_tensor_matrix_product::*;
use math_algebra::tensor::ntm_tensor_multiplication::*;
use math_algebra::tensor::ntm_tensor_product::*;
use math_algebra::tensor::ntm_tensor_summation::*;
use math_algebra::tensor::ntm_tensor_transpose::*;

fn main() {
    let mut data_a_in: Vec<Vec<Vec<f64>>>;
    let mut data_b_in: Vec<Vec<Vec<f64>>>;

    let mut data_out: Vec<Vec<Vec<f64>>>;

    data_a_in = vec![
        vec![
            vec![1.0, 2.0, 3.0],
            vec![4.0, 2.0, 6.0],
            vec![3.0, 4.0, 1.0],
            vec![2.0, 4.0, 8.0]
        ],
        vec![
            vec![1.0, 2.0, 3.0],
            vec![4.0, 2.0, 6.0],
            vec![3.0, 4.0, 1.0],
            vec![2.0, 4.0, 8.0]
        ],
        vec![
            vec![1.0, 2.0, 3.0],
            vec![4.0, 2.0, 6.0],
            vec![3.0, 4.0, 1.0],
            vec![2.0, 4.0, 8.0]
        ]
    ];
    data_b_in = vec![
        vec![
            vec![1.0],
            vec![7.0],
            vec![3.0]
        ],
        vec![
            vec![1.0],
            vec![7.0],
            vec![3.0]
        ],
        vec![
            vec![1.0],
            vec![7.0],
            vec![3.0]
        ]
    ];

    data_out = vec![
        vec![
            vec![24.0],
            vec![36.0],
            vec![34.0],
            vec![54.0]
        ],
        vec![
            vec![24.0],
            vec![36.0],
            vec![34.0],
            vec![54.0]
        ],
        vec![
            vec![24.0],
            vec![36.0],
            vec![34.0],
            vec![54.0]
        ]
    ];

    assert_eq!(ntm_tensor_matrix_product(data_a_in, data_b_in), data_out);

    data_a_in = vec![
        vec![
            vec![1.0, 2.0, 3.0],
            vec![4.0, 2.0, 6.0],
            vec![3.0, 4.0, 1.0]
        ],
        vec![
            vec![1.0, 2.0, 3.0],
            vec![4.0, 2.0, 6.0],
            vec![3.0, 4.0, 1.0]
        ],
        vec![
            vec![1.0, 2.0, 3.0],
            vec![4.0, 2.0, 6.0],
            vec![3.0, 4.0, 1.0]
        ]
    ];
    data_b_in = vec![
        vec![
            vec![1.0],
            vec![7.0],
            vec![3.0]
        ],
        vec![
            vec![1.0],
            vec![7.0],
            vec![3.0]
        ],
        vec![
            vec![1.0],
            vec![7.0],
            vec![3.0]
        ]
    ];

    data_out = vec![
        vec![
            vec![ 1.0],
            vec![11.0],
            vec![34.0]
        ],
        vec![
            vec![ 1.0],
            vec![11.0],
            vec![34.0]
        ],
        vec![
            vec![ 1.0],
            vec![11.0],
            vec![34.0]
        ]
    ];

    assert_eq!(ntm_tensor_matrix_convolution(data_a_in, data_b_in), data_out);

    let mut data_a_in:Vec<Vec<Vec<f64>>>;
    let mut data_b_in:Vec<Vec<Vec<f64>>>;

    let mut data_out: Vec<Vec<Vec<f64>>>;

    data_a_in = vec![
        vec![
            vec![1.0, 2.0, 3.0],
            vec![4.0, 2.0, 6.0],
            vec![3.0, 4.0, 1.0],
            vec![2.0, 4.0, 8.0]
        ],
        vec![
            vec![1.0, 2.0, 3.0],
            vec![4.0, 2.0, 6.0],
            vec![3.0, 4.0, 1.0],
            vec![2.0, 4.0, 8.0]
        ],
        vec![
            vec![1.0, 2.0, 3.0],
            vec![4.0, 2.0, 6.0],
            vec![3.0, 4.0, 1.0],
            vec![2.0, 4.0, 8.0]
        ]
    ];
    data_b_in = vec![
        vec![
            vec![1.0, 3.0, 3.0, 2.0],
            vec![7.0, 6.0, 2.0, 1.0],
            vec![3.0, 4.0, 2.0, 1.0]
        ],
        vec![
            vec![1.0, 3.0, 3.0, 2.0],
            vec![7.0, 6.0, 2.0, 1.0],
            vec![3.0, 4.0, 2.0, 1.0]
        ],
        vec![
            vec![1.0, 3.0, 3.0, 2.0],
            vec![7.0, 6.0, 2.0, 1.0],
            vec![3.0, 4.0, 2.0, 1.0]
        ]
    ];

    data_out = vec![
        vec![
            vec![24.0, 27.0, 13.0,  7.0],
            vec![36.0, 48.0, 28.0, 16.0],
            vec![34.0, 37.0, 19.0, 11.0],
            vec![54.0, 62.0, 30.0, 16.0]
        ],
        vec![
            vec![24.0, 27.0, 13.0,  7.0],
            vec![36.0, 48.0, 28.0, 16.0],
            vec![34.0, 37.0, 19.0, 11.0],
            vec![54.0, 62.0, 30.0, 16.0]
        ],
        vec![
            vec![24.0, 27.0, 13.0,  7.0],
            vec![36.0, 48.0, 28.0, 16.0],
            vec![34.0, 37.0, 19.0, 11.0],
            vec![54.0, 62.0, 30.0, 16.0]
        ]
    ];

    assert_eq!(ntm_tensor_product(data_a_in, data_b_in), data_out);

    data_a_in = vec![
        vec![
            vec![1.0, 2.0, 3.0],
            vec![4.0, 2.0, 6.0],
            vec![3.0, 4.0, 1.0]
        ],
        vec![
            vec![1.0, 2.0, 3.0],
            vec![4.0, 2.0, 6.0],
            vec![3.0, 4.0, 1.0]
        ],
        vec![
            vec![1.0, 2.0, 3.0],
            vec![4.0, 2.0, 6.0],
            vec![3.0, 4.0, 1.0]
        ]
    ];
    data_b_in = vec![
        vec![
            vec![1.0, 3.0, 3.0],
            vec![7.0, 6.0, 2.0],
            vec![3.0, 4.0, 2.0]
        ],
        vec![
            vec![1.0, 3.0, 3.0],
            vec![7.0, 6.0, 2.0],
            vec![3.0, 4.0, 2.0]
        ],
        vec![
            vec![1.0, 3.0, 3.0],
            vec![7.0, 6.0, 2.0],
            vec![3.0, 4.0, 2.0]
        ]
    ];

    data_out = vec![
        vec![
            vec![ 1.0,  5.0,  12.0],
            vec![11.0, 34.0,  59.0],
            vec![34.0, 61.0, 103.0]
        ],
        vec![
            vec![ 1.0,  5.0,  12.0],
            vec![11.0, 34.0,  59.0],
            vec![34.0, 61.0, 103.0]
        ],
        vec![
            vec![ 1.0,  5.0,  12.0],
            vec![11.0, 34.0,  59.0],
            vec![34.0, 61.0, 103.0]
        ]
    ];

    assert_eq!(ntm_tensor_convolution(data_a_in, data_b_in), data_out);

    let mut data_in: Vec<Vec<Vec<f64>>>;

    let mut data_out: Vec<Vec<Vec<f64>>>;

    data_in = vec![
        vec![
            vec![1.0, 0.0, 1.0],
            vec![0.0, 2.0, 0.0],
            vec![5.0, 0.0, 1.0]
        ],
        vec![
            vec![3.0, 4.0, 2.0],
            vec![0.0, 1.0, 3.0],
            vec![3.0, 1.0, 1.0]
        ],
        vec![
            vec![1.0, 0.0, 5.0],
            vec![0.0, 2.0, 0.0],
            vec![1.0, 0.0, 1.0]
        ]
    ];

    data_out = vec![
        vec![
            vec![1.0, 0.0, 5.0], 
            vec![0.0, 2.0, 0.0], 
            vec![1.0, 0.0, 1.0]
        ],
        vec![
            vec![3.0, 0.0, 3.0],
            vec![4.0, 1.0, 1.0], 
            vec![2.0, 3.0, 1.0]
        ],
        vec![
            vec![1.0, 0.0, 1.0],
            vec![0.0, 2.0, 0.0],
            vec![5.0, 0.0, 1.0]
        ]
    ];

    assert_eq!(ntm_tensor_transpose(data_in), data_out);

    data_in = vec![
        vec![
            vec![ 0.0, -1.0,  0.0],
            vec![-1.0,  2.0, -1.0],
            vec![ 0.0, -1.0,  2.0]
        ],
        vec![
            vec![ 0.0, -1.0,  0.0],
            vec![-1.0,  2.0, -1.0],
            vec![ 0.0, -1.0,  2.0]
        ],
        vec![
            vec![ 0.0, -1.0,  0.0],
            vec![-1.0,  2.0, -1.0],
            vec![ 0.0, -1.0,  2.0]
        ]
    ];

    data_out = vec![
        vec![
            vec![-1.5, -1.0, -0.5],
            vec![-1.0,  0.0,  0.0],
            vec![-0.5,  0.0,  0.5]
        ],
        vec![
            vec![-1.5, -1.0, -0.5],
            vec![-1.0,  0.0,  0.0],
            vec![-0.5,  0.0,  0.5]
        ],
        vec![
            vec![-1.5, -1.0, -0.5],
            vec![-1.0,  0.0,  0.0],
            vec![-0.5,  0.0,  0.5]
        ]
    ];

    let mut reference = &mut data_in;

    let double_reference = &mut reference;

    assert_eq!(ntm_tensor_inverse(double_reference), data_out);

    let mut data_in: Vec<Vec<Vec<Vec<f64>>>>;

    let mut data_out: Vec<Vec<Vec<f64>>>;

    data_in = vec![
        vec![
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
        ],
        vec![
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
        ],
        vec![
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
        ]
    ];

    data_out = vec![
        vec![
            vec![12.0, 0.0, 20.0],
            vec![12.0, 0.0, 20.0],
            vec![12.0, 0.0, 20.0]
        ],
        vec![
            vec![12.0, 0.0, 20.0],
            vec![12.0, 0.0, 20.0],
            vec![12.0, 0.0, 20.0]
        ],
        vec![
            vec![12.0, 0.0, 20.0],
            vec![12.0, 0.0, 20.0],
            vec![12.0, 0.0, 20.0]
        ]
    ];

    assert_eq!(ntm_tensor_multiplication(data_in), data_out);

    data_in = vec![
        vec![
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
        ],
        vec![
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
        ],
        vec![
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
        ]
    ];

    data_out = vec![
        vec![
            vec![7.0, 2.0, 10.0],
            vec![7.0, 2.0, 10.0],
            vec![7.0, 2.0, 10.0]
        ],
        vec![
            vec![7.0, 2.0, 10.0],
            vec![7.0, 2.0, 10.0],
            vec![7.0, 2.0, 10.0]
        ],
        vec![
            vec![7.0, 2.0, 10.0],
            vec![7.0, 2.0, 10.0],
            vec![7.0, 2.0, 10.0]
        ]
    ];

    assert_eq!(ntm_tensor_summation(data_in), data_out);
}
