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

extern crate arithmetic;

use arithmetic::tensor::accelerator_tensor_adder::*;
use arithmetic::tensor::accelerator_tensor_subtractor::*;
use arithmetic::tensor::accelerator_tensor_multiplier::*;
use arithmetic::tensor::accelerator_tensor_divider::*;

use arithmetic::tensor::accelerator_tensor_arithmetic::*;

fn main() {
    let mut data_a_in: Vec<Vec<Vec<f64>>>;
    let mut data_b_in: Vec<Vec<Vec<f64>>>;

    let mut data_out: Vec<Vec<Vec<f64>>>;

    data_a_in = vec![
        vec![
            vec![2.0, 2.0, 2.0],
            vec![0.0, 0.0, 0.0],
            vec![4.0, 4.0, 4.0]
        ],
        vec![
            vec![2.0, 2.0, 2.0],
            vec![0.0, 0.0, 0.0],
            vec![4.0, 4.0, 4.0]
        ],
        vec![
            vec![2.0, 2.0, 2.0],
            vec![0.0, 0.0, 0.0],
            vec![4.0, 4.0, 4.0]
        ]
    ];
    data_b_in = vec![
        vec![
            vec![1.0, 1.0, 1.0],
            vec![1.0, 1.0, 1.0],
            vec![2.0, 2.0, 2.0]
        ],
        vec![
            vec![1.0, 1.0, 1.0],
            vec![1.0, 1.0, 1.0],
            vec![2.0, 2.0, 2.0]
        ],
        vec![
            vec![1.0, 1.0, 1.0],
            vec![1.0, 1.0, 1.0],
            vec![2.0, 2.0, 2.0]
        ]
    ];

    data_out = vec![
        vec![
            vec![3.0, 3.0, 3.0],
            vec![1.0, 1.0, 1.0],
            vec![6.0, 6.0, 6.0]
        ],
        vec![
            vec![3.0, 3.0, 3.0],
            vec![1.0, 1.0, 1.0],
            vec![6.0, 6.0, 6.0]
        ],
        vec![
            vec![3.0, 3.0, 3.0],
            vec![1.0, 1.0, 1.0],
            vec![6.0, 6.0, 6.0]
        ]
    ];

    assert_eq!(accelerator_tensor_adder(data_a_in, data_b_in), data_out);

    data_a_in = vec![
        vec![
            vec![2.0, 2.0, 2.0],
            vec![0.0, 0.0, 0.0],
            vec![4.0, 4.0, 4.0]
        ],
        vec![
            vec![2.0, 2.0, 2.0],
            vec![0.0, 0.0, 0.0],
            vec![4.0, 4.0, 4.0]
        ],
        vec![
            vec![2.0, 2.0, 2.0],
            vec![0.0, 0.0, 0.0],
            vec![4.0, 4.0, 4.0]
        ]
    ];
    data_b_in = vec![
        vec![
            vec![1.0, 1.0, 1.0],
            vec![1.0, 1.0, 1.0],
            vec![2.0, 2.0, 2.0]
        ],
        vec![
            vec![1.0, 1.0, 1.0],
            vec![1.0, 1.0, 1.0],
            vec![2.0, 2.0, 2.0]
        ],
        vec![
            vec![1.0, 1.0, 1.0],
            vec![1.0, 1.0, 1.0],
            vec![2.0, 2.0, 2.0]
        ]
    ];

    data_out = vec![
        vec![
            vec![ 1.0,  1.0,  1.0],
            vec![-1.0, -1.0, -1.0],
            vec![ 2.0,  2.0,  2.0]
        ],
        vec![
            vec![ 1.0,  1.0,  1.0],
            vec![-1.0, -1.0, -1.0],
            vec![ 2.0,  2.0,  2.0]
        ],
        vec![
            vec![ 1.0,  1.0,  1.0],
            vec![-1.0, -1.0, -1.0],
            vec![ 2.0,  2.0,  2.0]
        ]
    ];

    assert_eq!(accelerator_tensor_subtractor(data_a_in, data_b_in), data_out);

    data_a_in = vec![
        vec![
            vec![2.0, 2.0, 2.0],
            vec![0.0, 0.0, 0.0],
            vec![4.0, 4.0, 4.0]
        ],
        vec![
            vec![2.0, 2.0, 2.0],
            vec![0.0, 0.0, 0.0],
            vec![4.0, 4.0, 4.0]
        ],
        vec![
            vec![2.0, 2.0, 2.0],
            vec![0.0, 0.0, 0.0],
            vec![4.0, 4.0, 4.0]
        ]
    ];
    data_b_in = vec![
        vec![
            vec![1.0, 1.0, 1.0],
            vec![1.0, 1.0, 1.0],
            vec![2.0, 2.0, 2.0]
        ],
        vec![
            vec![1.0, 1.0, 1.0],
            vec![1.0, 1.0, 1.0],
            vec![2.0, 2.0, 2.0]
        ],
        vec![
            vec![1.0, 1.0, 1.0],
            vec![1.0, 1.0, 1.0],
            vec![2.0, 2.0, 2.0]
        ]
    ];

    data_out = vec![
        vec![
            vec![2.0, 2.0, 2.0],
            vec![0.0, 0.0, 0.0],
            vec![8.0, 8.0, 8.0]
        ],
        vec![
            vec![2.0, 2.0, 2.0],
            vec![0.0, 0.0, 0.0],
            vec![8.0, 8.0, 8.0]
        ],
        vec![
            vec![2.0, 2.0, 2.0],
            vec![0.0, 0.0, 0.0],
            vec![8.0, 8.0, 8.0]
        ]
    ];

    assert_eq!(accelerator_tensor_multiplier(data_a_in, data_b_in), data_out);

    data_a_in = vec![
        vec![
            vec![2.0, 2.0, 2.0],
            vec![0.0, 0.0, 0.0],
            vec![4.0, 4.0, 4.0]
        ],
        vec![
            vec![2.0, 2.0, 2.0],
            vec![0.0, 0.0, 0.0],
            vec![4.0, 4.0, 4.0]
        ],
        vec![
            vec![2.0, 2.0, 2.0],
            vec![0.0, 0.0, 0.0],
            vec![4.0, 4.0, 4.0]
        ]
    ];
    data_b_in = vec![
        vec![
            vec![1.0, 1.0, 1.0],
            vec![1.0, 1.0, 1.0],
            vec![2.0, 2.0, 2.0]
        ],
        vec![
            vec![1.0, 1.0, 1.0],
            vec![1.0, 1.0, 1.0],
            vec![2.0, 2.0, 2.0]
        ],
        vec![
            vec![1.0, 1.0, 1.0],
            vec![1.0, 1.0, 1.0],
            vec![2.0, 2.0, 2.0]
        ]
    ];

    data_out = vec![
        vec![
            vec![2.0, 2.0, 2.0],
            vec![0.0, 0.0, 0.0],
            vec![2.0, 2.0, 2.0]
        ],
        vec![
            vec![2.0, 2.0, 2.0],
            vec![0.0, 0.0, 0.0],
            vec![2.0, 2.0, 2.0]
        ],
        vec![
            vec![2.0, 2.0, 2.0],
            vec![0.0, 0.0, 0.0],
            vec![2.0, 2.0, 2.0]
        ]
    ];

    assert_eq!(accelerator_tensor_divider(data_a_in, data_b_in), data_out);


    let addition = TensorArithmetic {
        data_a_in: vec![
            vec![
                vec![2.0, 2.0, 2.0],
                vec![0.0, 0.0, 0.0],
                vec![4.0, 4.0, 4.0]
            ],
            vec![
                vec![2.0, 2.0, 2.0],
                vec![0.0, 0.0, 0.0],
                vec![4.0, 4.0, 4.0]
            ],
            vec![
                vec![2.0, 2.0, 2.0],
                vec![0.0, 0.0, 0.0],
                vec![4.0, 4.0, 4.0]
            ]
        ],
        data_b_in: vec![
            vec![
                vec![1.0, 1.0, 1.0],
                vec![1.0, 1.0, 1.0],
                vec![2.0, 2.0, 2.0]
            ],
            vec![
                vec![1.0, 1.0, 1.0],
                vec![1.0, 1.0, 1.0],
                vec![2.0, 2.0, 2.0]
            ],
            vec![
                vec![1.0, 1.0, 1.0],
                vec![1.0, 1.0, 1.0],
                vec![2.0, 2.0, 2.0]
            ]
        ],

        data_out: vec![
            vec![
                vec![3.0, 3.0, 3.0],
                vec![1.0, 1.0, 1.0],
                vec![6.0, 6.0, 6.0]
            ],
            vec![
                vec![3.0, 3.0, 3.0],
                vec![1.0, 1.0, 1.0],
                vec![6.0, 6.0, 6.0]
            ],
            vec![
                vec![3.0, 3.0, 3.0],
                vec![1.0, 1.0, 1.0],
                vec![6.0, 6.0, 6.0]
            ]
        ]
    };

    assert_eq!(addition.accelerator_tensor_adder(), addition.data_out);

    let subtraction = TensorArithmetic {
        data_a_in: vec![
            vec![
                vec![2.0, 2.0, 2.0],
                vec![0.0, 0.0, 0.0],
                vec![4.0, 4.0, 4.0]
            ],
            vec![
                vec![2.0, 2.0, 2.0],
                vec![0.0, 0.0, 0.0],
                vec![4.0, 4.0, 4.0]
            ],
            vec![
                vec![2.0, 2.0, 2.0],
                vec![0.0, 0.0, 0.0],
                vec![4.0, 4.0, 4.0]
            ]
        ],
        data_b_in: vec![
            vec![
                vec![1.0, 1.0, 1.0],
                vec![1.0, 1.0, 1.0],
                vec![2.0, 2.0, 2.0]
            ],
            vec![
                vec![1.0, 1.0, 1.0],
                vec![1.0, 1.0, 1.0],
                vec![2.0, 2.0, 2.0]
            ],
            vec![
                vec![1.0, 1.0, 1.0],
                vec![1.0, 1.0, 1.0],
                vec![2.0, 2.0, 2.0]
            ]
        ],

        data_out: vec![
            vec![
                vec![ 1.0,  1.0,  1.0],
                vec![-1.0, -1.0, -1.0],
                vec![ 2.0,  2.0,  2.0]
            ],
            vec![
                vec![ 1.0,  1.0,  1.0],
                vec![-1.0, -1.0, -1.0],
                vec![ 2.0,  2.0,  2.0]
            ],
            vec![
                vec![ 1.0,  1.0,  1.0],
                vec![-1.0, -1.0, -1.0],
                vec![ 2.0,  2.0,  2.0]
            ]
        ]
    };

    assert_eq!(subtraction.accelerator_tensor_subtractor(), subtraction.data_out);

    let multiplication = TensorArithmetic {
        data_a_in: vec![
            vec![
                vec![2.0, 2.0, 2.0],
                vec![0.0, 0.0, 0.0],
                vec![4.0, 4.0, 4.0]
            ],
            vec![
                vec![2.0, 2.0, 2.0],
                vec![0.0, 0.0, 0.0],
                vec![4.0, 4.0, 4.0]
            ],
            vec![
                vec![2.0, 2.0, 2.0],
                vec![0.0, 0.0, 0.0],
                vec![4.0, 4.0, 4.0]
            ]
        ],
        data_b_in: vec![
            vec![
                vec![1.0, 1.0, 1.0],
                vec![1.0, 1.0, 1.0],
                vec![2.0, 2.0, 2.0]
            ],
            vec![
                vec![1.0, 1.0, 1.0],
                vec![1.0, 1.0, 1.0],
                vec![2.0, 2.0, 2.0]
            ],
            vec![
                vec![1.0, 1.0, 1.0],
                vec![1.0, 1.0, 1.0],
                vec![2.0, 2.0, 2.0]
            ]
        ],

        data_out: vec![
            vec![
                vec![2.0, 2.0, 2.0],
                vec![0.0, 0.0, 0.0],
                vec![8.0, 8.0, 8.0]
            ],
            vec![
                vec![2.0, 2.0, 2.0],
                vec![0.0, 0.0, 0.0],
                vec![8.0, 8.0, 8.0]
            ],
            vec![
                vec![2.0, 2.0, 2.0],
                vec![0.0, 0.0, 0.0],
                vec![8.0, 8.0, 8.0]
            ]
        ]
    };

    assert_eq!(multiplication.accelerator_tensor_multiplier(), multiplication.data_out);

    let division = TensorArithmetic {
        data_a_in: vec![
            vec![
                vec![2.0, 2.0, 2.0],
                vec![0.0, 0.0, 0.0],
                vec![4.0, 4.0, 4.0]
            ],
            vec![
                vec![2.0, 2.0, 2.0],
                vec![0.0, 0.0, 0.0],
                vec![4.0, 4.0, 4.0]
            ],
            vec![
                vec![2.0, 2.0, 2.0],
                vec![0.0, 0.0, 0.0],
                vec![4.0, 4.0, 4.0]
            ]
        ],
        data_b_in: vec![
            vec![
                vec![1.0, 1.0, 1.0],
                vec![1.0, 1.0, 1.0],
                vec![2.0, 2.0, 2.0]
            ],
            vec![
                vec![1.0, 1.0, 1.0],
                vec![1.0, 1.0, 1.0],
                vec![2.0, 2.0, 2.0]
            ],
            vec![
                vec![1.0, 1.0, 1.0],
                vec![1.0, 1.0, 1.0],
                vec![2.0, 2.0, 2.0]
            ]
        ],

        data_out: vec![
            vec![
                vec![2.0, 2.0, 2.0],
                vec![0.0, 0.0, 0.0],
                vec![2.0, 2.0, 2.0]
            ],
            vec![
                vec![2.0, 2.0, 2.0],
                vec![0.0, 0.0, 0.0],
                vec![2.0, 2.0, 2.0]
            ],
            vec![
                vec![2.0, 2.0, 2.0],
                vec![0.0, 0.0, 0.0],
                vec![2.0, 2.0, 2.0]
            ]
        ]
    };

    assert_eq!(division.accelerator_tensor_divider(), division.data_out);
}
