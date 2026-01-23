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

// Matrix Inversion
pub fn accelerator_matrix_inverse(data_in: &mut Vec<Vec<f64>>) -> Vec<Vec<f64>>{
    let length = data_in.len();

    let mut augmented_matrix = accelerator_zero_matrix(length, 2*length);

    for i in 0..length {
        for j in 0.. length {
            augmented_matrix[i][j] = data_in[i][j];
        }
        augmented_matrix[i][i + length] = 1.0;
    }

    accelerator_gauss_jordan_general(&mut augmented_matrix);

    let mut data_out = accelerator_zero_matrix(length, length);

    for i in 0..length {
        for j in 0..length {
            data_out[i][j] = augmented_matrix[i][j+length];
        }
    }
    data_out
}

// Generalised Reduced Row Echelon Form
pub fn accelerator_gauss_jordan_general(data_in: &mut Vec<Vec<f64>>) {
    let mut lead = 0;

    let i_counter = data_in.len();
    let j_counter = data_in[0].len();

    for r in 0..i_counter {
        if j_counter <= lead {
            break;
        }

        let mut i = r;

        while data_in[i][lead] == 0.0 {
            i = i + 1;

            if i_counter == i {
                i = r;
                lead = lead + 1;

                if j_counter == lead {
                    break;
                }
            }
        }

        let temporal = data_in[i].to_owned();

        data_in[i] = data_in[r].to_owned();
        data_in[r] = temporal.to_owned();

        if data_in[r][lead] != 0.0 {
            let divider_ratio = data_in[r][lead];

            for j in 0..j_counter {
                data_in[r][j] = data_in[r][j] / divider_ratio;
            }
        }

        for k in 0..i_counter {
            if k != r {
                let multiplier_ratio = data_in[k][lead];

                for j in 0..j_counter {
                    data_in[k][j] = data_in[k][j] - data_in[r][j] * multiplier_ratio;
                }
            }
        }
        lead = lead + 1;
    }
}

// Zero Matrix
pub fn accelerator_zero_matrix(size_i_in: usize, size_j_in: usize) -> Vec<Vec<f64>> {
    let mut data_in = Vec::with_capacity(size_i_in);

    for _ in 0..size_i_in {
        let mut vector: Vec<f64> = Vec::with_capacity(size_j_in);

        for _ in 0..size_j_in {
            vector.push(0.0);
        }
        data_in.push(vector);
    }
    data_in
}

// Printed Matrix
pub fn accelerator_print_matrix(data_in: &mut Vec<Vec<f64>>) {
    for i in 0..data_in.len(){
        println!("{:?}", data_in[i]);
    }
}
