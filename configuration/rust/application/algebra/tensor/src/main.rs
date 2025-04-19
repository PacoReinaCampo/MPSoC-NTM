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

use algebra::tensor::ntm_tensor_convolution::*;
use algebra::tensor::ntm_tensor_inverse::*;
use algebra::tensor::ntm_tensor_matrix_convolution::*;
use algebra::tensor::ntm_tensor_matrix_product::*;
use algebra::tensor::ntm_tensor_multiplication::*;
use algebra::tensor::ntm_tensor_product::*;
use algebra::tensor::ntm_tensor_summation::*;
use algebra::tensor::ntm_tensor_transpose::*;
use algebra::tensor::ntm_tensor_differentiation::*;
use algebra::tensor::ntm_tensor_integration::*;
use algebra::tensor::ntm_tensor_softmax::*;

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

    let mut data_in: Vec<Vec<Vec<f64>>>;

    let mut data_out: Vec<Vec<Vec<f64>>>;

    data_in = vec![
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

    data_out = vec![
        vec![
            vec![ 0.000000000000000, 0.000000000000000,  0.0000000000000000],
            vec![-2.009346206396506, 2.181879072291935, -1.6581216010532778],
            vec![ 5.684942785632134, 2.644907157571142, -3.6933832216044853]
        ],
        vec![
            vec![ 0.000000000000000, 0.000000000000000,  0.0000000000000000],
            vec![-2.009346206396506, 2.181879072291935, -1.6581216010532778],
            vec![ 5.684942785632134, 2.644907157571142, -3.6933832216044853]
        ],
        vec![
            vec![ 0.000000000000000, 0.000000000000000,  0.0000000000000000],
            vec![-2.009346206396506, 2.181879072291935,-1.65812160105327780],
            vec![ 5.684942785632134, 2.644907157571142, -3.6933832216044853]
        ]
    ];

    assert_eq!(ntm_tensor_differentiation(data_in, 1.0, 1.0, 1.0, 1), data_out);

    data_in = vec![
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

    data_out = vec![
        vec![
            vec![6.322611388622675,  9.453994003848962, 17.805262785462183],
            vec![4.313265182226169,  9.626526869744392, 16.319674050304336],
            vec![9.998207967858303, 17.956376812947667, 20.956140771903126]
        ],
        vec![
            vec![6.322611388622675,  9.453994003848962, 17.805262785462183],
            vec![4.313265182226169,  9.626526869744392, 16.319674050304336],
            vec![9.998207967858303, 17.956376812947667, 20.956140771903126]
        ],
        vec![
            vec![6.322611388622675,  9.453994003848962, 17.805262785462183],
            vec![4.313265182226169,  9.626526869744392, 16.319674050304336],
            vec![9.998207967858303, 17.956376812947667, 20.956140771903126]
        ]
    ];

    assert_eq!(ntm_tensor_integration(data_in, 1.0), data_out);

    data_in = vec![
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

    data_out = vec![
        vec![
            vec![0.0181052491311145360, 0.0007445115822270013, 0.1376699696282669000],
            vec![0.0024274848910245004, 0.0065985650080329240, 0.0262256435989427600],
            vec![0.7146539808632932000, 0.0929219004226361100, 0.0006526948744619639]
        ],
        vec![
            vec![0.0090526245655572700, 0.0003722557911135007, 0.068834984814133460],
            vec![0.0012137424455122502, 0.0032992825040164620, 0.013112821799471382],
            vec![0.3573269904316467000, 0.0464609502113180540, 0.000326347437230982]
        ],
        vec![
            vec![0.0060350830437048470, 0.0002481705274090005, 0.04588998987608898000],
            vec![0.0008091616303415002, 0.0021995216693443080, 0.00874188119964758800],
            vec![0.2382179936210978000, 0.0309739668075453730, 0.00021756495815398801]
        ]
    ];

    assert_eq!(ntm_tensor_softmax(data_in), data_out);
}
