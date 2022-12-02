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
pub fn ntm_matrix_inverse(matrix: &mut Vec<Vec<f64>>) -> Vec<Vec<f64>>{
    let length = matrix.len();

    let mut augmented_matrix = ntm_zero_matrix(length, 2*length);

    for i in 0..length {
        for j in 0.. length {
            augmented_matrix[i][j] = matrix[i][j];
        }
        augmented_matrix[i][i + length] = 1.0;
    }

    ntm_gauss_jordan_general(&mut augmented_matrix);

    let mut data_out = ntm_zero_matrix(length, length);

    for i in 0..length {
        for j in 0..length {
            data_out[i][j] = augmented_matrix[i][j+length];
        }
    }
    data_out
}

// Generalised Reduced Row Echelon Form
pub fn ntm_gauss_jordan_general(matrix: &mut Vec<Vec<f64>>) {
    let mut lead = 0;

    let i_counter = matrix.len();
    let j_counter = matrix[0].len();

    for r in 0..i_counter {
        if j_counter <= lead {
            break;
        }

        let mut i = r;

        while matrix[i][lead] == 0.0 {
            i = i + 1;

            if i_counter == i {
                i = r;
                lead = lead + 1;

                if j_counter == lead {
                    break;
                }
            }
        }

        let temporal = matrix[i].to_owned();

        matrix[i] = matrix[r].to_owned();
        matrix[r] = temporal.to_owned();

        if matrix[r][lead] != 0.0 {
            let divider_ratio = matrix[r][lead];

            for j in 0..j_counter {
                matrix[r][j] = matrix[r][j] / divider_ratio;
            }
        }

        for k in 0..i_counter {
            if k != r {
                let multiplier_ratio = matrix[k][lead];

                for j in 0..j_counter {
                    matrix[k][j] = matrix[k][j] - matrix[r][j] * multiplier_ratio;
                }
            }
        }
        lead = lead + 1;
    }
}

// Zero Matrix
pub fn ntm_zero_matrix(size_i_in: usize, size_j_in: usize) -> Vec<Vec<f64>> {
    let mut matrix = Vec::with_capacity(size_i_in);

    for _ in 0..size_i_in {
        let mut vector: Vec<f64> = Vec::with_capacity(size_j_in);

        for _ in 0..size_j_in {
            vector.push(0.0);
        }
        matrix.push(vector);
    }
    matrix
}

// Printed Matrix
pub fn ntm_print_matrix(matrix: &mut Vec<Vec<f64>>) {
    for i in 0..matrix.len(){
        println!("{:?}", matrix[i]);
    }
}
