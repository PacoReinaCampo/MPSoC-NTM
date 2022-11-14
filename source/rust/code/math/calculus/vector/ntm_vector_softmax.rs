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

pub fn ntm_vector_softmax(data_in: Vec<f64>) -> Vec<f64> {
    let mut temporal0: f64 = 0.0;

    let mut data_int: Vec<f64> = vec![];

    let mut data_out: Vec<f64> = vec![];

    for i in 0..data_in.len() {
        temporal0 += data_in[i].exp();

        let temporal1: f64 = data_in[i].exp();

        data_int.push(temporal1);
    }

    for i in 0..data_in.len() {
        data_out.push(data_int[i]/temporal0);
    }
    data_out
}

fn main() {
    let data_in_0: Vec<f64> = vec![6.3226113886226751, 3.1313826152262876, 8.3512687816132226];
    let data_in_1: Vec<f64> = vec![4.3132651822261687, 5.3132616875182226, 6.6931471805599454];

    let data_out_0: Vec<f64> = vec![0.11567390955504045, 0.004756662822010267, 0.8795694276229492];
    let data_out_1: Vec<f64> = vec![0.06886151132461793, 0.187184340758189600, 0.7439541479171924];

    assert_eq!(ntm_vector_softmax(data_in_0), data_out_0);
    assert_eq!(ntm_vector_softmax(data_in_1), data_out_1);
}
