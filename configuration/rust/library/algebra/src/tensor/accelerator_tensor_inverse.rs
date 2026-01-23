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

// Tensor Inversion
pub fn accelerator_tensor_inverse(data_in: &mut Vec<Vec<Vec<f64>>>) -> Vec<Vec<Vec<f64>>>{
    let length = data_in.len();

    let mut augmented_tensor = accelerator_zero_tensor(length, length, 2*length);

    for i in 0..length {
        for j in 0.. length {
            for k in 0.. length {
                augmented_tensor[i][j][k] = data_in[i][j][k];
            }
            augmented_tensor[i][j][j + length] = 1.0;
        }
    }

    accelerator_gauss_jordan_general(&mut augmented_tensor);

    let mut data_out = accelerator_zero_tensor(length, length, length);

    for i in 0..length {
        for j in 0..length {
            for k in 0..length {
                data_out[i][j][k] = augmented_tensor[i][j][k+length];
            }
        }
    }
    data_out
}

// Generalised Reduced Row Echelon Form
pub fn accelerator_gauss_jordan_general(data_in: &mut Vec<Vec<Vec<f64>>>) {
    let mut lead = 0;

    let i_counter = data_in.len();
    let j_counter = data_in[0].len();
    let k_counter = data_in[0][0].len();

    for i in 0..i_counter {
        for r in 0..j_counter {
            if k_counter <= lead {
                break;
            }

            let mut j = r;

            while data_in[i][j][lead] == 0.0 {
                j = j + 1;

                if j_counter == j {
                    j = r;
                    lead = lead + 1;

                    if k_counter == lead {
                        break;
                    }
                }
            }

            let temporal = data_in[i][j].to_owned();

            data_in[i][j] = data_in[i][r].to_owned();
            data_in[i][r] = temporal.to_owned();

            if data_in[i][r][lead] != 0.0 {
                let divider_ratio = data_in[i][r][lead];

                for k in 0..k_counter {
                    data_in[i][r][k] = data_in[i][r][k] / divider_ratio;
                }
            }

            for m in 0..j_counter {
                if m != r {
                    let multiplier_ratio = data_in[i][m][lead];

                    for k in 0..k_counter {
                        data_in[i][m][k] = data_in[i][m][k] - data_in[i][r][k] * multiplier_ratio;
                    }
                }
            }
            lead = lead + 1;
        }
    }
}

// Zero Tensor
pub fn accelerator_zero_tensor(size_i_in: usize, size_j_in: usize, size_k_in: usize) -> Vec<Vec<Vec<f64>>> {
    let mut data_in = Vec::with_capacity(size_i_in);

    for _ in 0..size_i_in {
        let mut matrix = Vec::with_capacity(size_j_in);

        for _ in 0..size_j_in {
            let mut vector = Vec::with_capacity(size_k_in);

            for _ in 0..size_k_in {
                vector.push(0.0);
            }
            matrix.push(vector);
        }
        data_in.push(matrix);
    }
    data_in
}

// Printed Tensor
pub fn accelerator_print_tensor(data_in: &mut Vec<Vec<Vec<f64>>>) {
    for i in 0..data_in.len(){
        for j in 0..data_in.len(){
            println!("{:?}", data_in[i][j]);
        }
        println!("\n");
    }
}
