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

    let mut data_int: Vec<Vec<Vec<f64>>> = vec![];

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
            matrix0.push(vector0);
        }
        data_int.push(matrix0);

        let mut matrix1: Vec<Vec<f64>> = vec![];

        for j in 0..data_in[0].len() {

            let mut vector1: Vec<f64> = vec![];

            for k in 0..data_in[0][0].len() {
                vector1.push(data_int[i][j][k]/temporal0);
            }
            matrix1.push(vector1);
        }
        data_out.push(matrix1);
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
