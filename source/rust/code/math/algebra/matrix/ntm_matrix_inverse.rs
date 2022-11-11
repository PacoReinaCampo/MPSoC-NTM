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
fn matrix_inverse(matrix: &mut Vec<Vec<f64>>) -> Vec<Vec<f64>>{
    let length = matrix.len();
    let mut aug = zero_matrix(length, length * 2);

    for i in 0..length {
        for j in 0.. length {
            aug[i][j] = matrix[i][j];
        }
        aug[i][i + length] = 1.0;
    }

    gauss_jordan_general(&mut aug);

    let mut unaug = zero_matrix(length, length);

    for i in 0..length {
        for j in 0..length {
            unaug[i][j] = aug[i][j+length];
        }
    }
    unaug
}

// Generalised Reduced Row Echelon Form
fn gauss_jordan_general(matrix: &mut Vec<Vec<f64>>) {
    let mut lead = 0;
    let row_count = matrix.len();
    let col_count = matrix[0].len();

    for r in 0..row_count {
        if col_count <= lead {
            break;
        }
        let mut i = r;
        while matrix[i][lead] == 0.0 {
            i = i + 1;
            if row_count == i {
                i = r;
                lead = lead + 1;
                if col_count == lead {
                    break;
                }
            }
        }

        let temp = matrix[i].to_owned();
        matrix[i] = matrix[r].to_owned();
        matrix[r] = temp.to_owned();

        if matrix[r][lead] != 0.0 {
            let div = matrix[r][lead];
            for j in 0..col_count {
                matrix[r][j] = matrix[r][j] / div;
            }
        }

        for k in 0..row_count {
            if k != r {
                let mult = matrix[k][lead];
                for j in 0..col_count {
                    matrix[k][j] = matrix[k][j] - matrix[r][j] * mult;
                }
            }
        }
        lead = lead + 1;
    }
}

// Zero Matrix
fn zero_matrix(rows: usize, columns: usize) -> Vec<Vec<f64>> {
    let mut matrix = Vec::with_capacity(columns);
    for _ in 0..rows {
        let mut col: Vec<f64> = Vec::with_capacity(rows);
        for _ in 0..columns {
            col.push(0.0);
        }
        matrix.push(col);
    }
    matrix
}

// Printed Matrix
fn print_matrix(matrix: &mut Vec<Vec<f64>>) {
    for i in 0..matrix.len(){
        println!("{:?}", matrix[i]);
    }
}

fn main() {
    let mut a: Vec<Vec<f64>> = vec![
        vec![1.0, 2.0, 3.0],
        vec![4.0, 1.0, 6.0],
        vec![7.0, 8.0, 9.0]
    ];
    let mut b: Vec<Vec<f64>> = vec![
        vec![2.0, -1.0, 0.0],
        vec![-1.0, 2.0, -1.0],
        vec![0.0, -1.0, 2.0]
    ];

    let mut ref_a = &mut a;
    let rref_a = &mut ref_a;

    let mut ref_b = &mut b;
    let rref_b = &mut ref_b;

    println!("Matrix A:\n");
    print_matrix(rref_a);
    println!("\nInverse of Matrix A:\n");
    print_matrix(&mut matrix_inverse(rref_a));

    println!("\n\nMatrix B:\n");
    print_matrix(rref_b);
    println!("\nInverse of Matrix B:\n");
    print_matrix(&mut matrix_inverse(rref_b));
}
