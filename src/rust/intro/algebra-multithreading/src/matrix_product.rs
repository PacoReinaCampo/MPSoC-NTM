////////////////////////////////////////////////////////////////////////////////
//                                            __ _      _     _               //
//                                           / _(_)    | |   | |              //
//                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |              //
//               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |              //
//              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |              //
//               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|              //
//                  | |                                                       //
//                  |_|                                                       //
//                                                                            //
//                                                                            //
//              RISC-V CPU                                                    //
//              Hello World                                                   //
//              Software                                                      //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

/* Copyright (c) 2021-2022 by the author(s)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * =============================================================================
 * Author(s):
 *   Paco Reina Campo <pacoreinacampo@queenfield.tech>
 */

use rayon::prelude::*;

// Sequentially product A and B square matrices.
pub fn simple_product_ab(a: &[Vec<f64>], b: &[Vec<f64>]) -> Vec<Vec<f64>> {
    if b.len() == 0 {
        return vec![];
    } else {
        if b[0].len() == 0 {
            return vec![];
        }
    }

    if a.len() == 0 {
        return vec![];
    } else {
        if a[0].len() == 0 {
            return vec![];
        }
    }

    // Assert that a and b are square matrices of the same size.
    assert_eq!(a.len(), a[0].len());
    assert_eq!(a.len(), b.len());
    assert_eq!(b.len(), b[0].len());

    let n = b.len();

    let mut c = vec![vec![0.0_f64; b[0].len()]; a.len()];

    for j in 0..n {
        for i in 0..n {
            for k in 0..n {
                c[i][j] += a[i][k] * b[k][j];
            }
        }
    }
    c
}

pub fn product_ab(a: &[Vec<f64>], b: &[Vec<f64>]) -> Vec<Vec<f64>> {
    if b.len() == 0 {
        return vec![];
    } else {
        if b[0].len() == 0 {
            return vec![];
        }
    }

    if a.len() == 0 {
        return vec![];
    } else {
        if a[0].len() == 0 {
            return vec![];
        }
    }

    // Assert that a and b are square matrices of the same size.
    assert_eq!(a.len(), a[0].len());
    assert_eq!(a.len(), b.len());
    assert_eq!(b.len(), b[0].len());

    let n = b.len();

    compute_matrix_combinators_2(n, a, b)
}

fn compute_matrix_combinators(n: usize, a: &[Vec<f64>], b: &[Vec<f64>]) -> Vec<Vec<f64>> {
    (0..n)
        .map(|i| {
            (0..n)
                .map(|j| (0..n).map(|k| a[i][k] * b[k][j]).sum())
                .collect::<Vec<f64>>()
        })
        .collect::<Vec<Vec<f64>>>()
}

fn compute_matrix_combinators_2(n: usize, a: &[Vec<f64>], b: &[Vec<f64>]) -> Vec<Vec<f64>> {
    (0..n)
        .map(|i| {
            let a_row = &a[i];
            compute_row_of_sums(a_row, b, n)
        })
        .collect::<Vec<Vec<f64>>>()
}

fn compute_row_of_sums(a_row: &[f64], b: &[Vec<f64>], n: usize) -> Vec<f64> {
    (0..n)
        .map(|j| (0..n).map(|k| a_row[k] * b[k][j]).sum())
        .collect::<Vec<f64>>()
}

fn compute_row_of_sums_rayon(a_row: &[f64], b: &[Vec<f64>], n: usize) -> Vec<f64> {
    let mut unordered_columns = (0..n)
        .into_par_iter()
        .map(|j| (j, (0..n).map(|k| a_row[k] * b[k][j]).sum()))
        .collect::<Vec<(usize, f64)>>();

    unordered_columns.par_sort_by(|left, right| left.0.cmp(&right.0));

    unordered_columns
        .into_iter()
        .map(|(_, col_el)| col_el)
        .collect()
}

fn compute_matrix_combinators_rayon(n: usize, a: &[Vec<f64>], b: &[Vec<f64>]) -> Vec<Vec<f64>> {
    let mut unordered_rows = (0..n)
        .into_par_iter()
        .map(move |i| {
            let a_row = &a[i];

            (i, compute_row_of_sums(a_row, b, n))
        })
        .collect::<Vec<(usize, Vec<f64>)>>();

    unordered_rows.par_sort_by(|left, right| left.0.cmp(&right.0));

    unordered_rows.into_iter().map(|(_, row)| row).collect()
}

fn compute_matrix_combinators_2_rayon(n: usize, a: &[Vec<f64>], b: &[Vec<f64>]) -> Vec<Vec<f64>> {
    let mut unordered_rows = (0..n)
        .into_par_iter()
        .map(move |i| {
            let a_row = &a[i];

            (i, compute_row_of_sums_rayon(a_row, b, n))
        })
        .collect::<Vec<(usize, Vec<f64>)>>();

    unordered_rows.par_sort_by(|left, right| left.0.cmp(&right.0));

    unordered_rows.into_iter().map(|(_, row)| row).collect()
}

pub fn par_product_ab_rayon(a: &[Vec<f64>], b: &[Vec<f64>]) -> Vec<Vec<f64>> {
    if b.len() == 0 {
        return vec![];
    } else {
        if b[0].len() == 0 {
            return vec![];
        }
    }

    if a.len() == 0 {
        return vec![];
    } else {
        if a[0].len() == 0 {
            return vec![];
        }
    }

    // Assert that a and b are square matrices of the same size.
    assert_eq!(a.len(), a[0].len());
    assert_eq!(a.len(), b.len());
    assert_eq!(b.len(), b[0].len());

    let n = b.len();

    compute_matrix_combinators_rayon(n, a, b)
}

pub fn par_par_product_ab_rayon(a: &[Vec<f64>], b: &[Vec<f64>]) -> Vec<Vec<f64>> {
    if b.len() == 0 {
        return vec![];
    } else {
        if b[0].len() == 0 {
            return vec![];
        }
    }

    if a.len() == 0 {
        return vec![];
    } else {
        if a[0].len() == 0 {
            return vec![];
        }
    }

    // Assert that a and b are square matrices of the same size.
    assert_eq!(a.len(), a[0].len());
    assert_eq!(a.len(), b.len());
    assert_eq!(b.len(), b[0].len());

    let n = b.len();

    compute_matrix_combinators_2_rayon(n, a, b)
}

#[cfg(test)]
pub mod tests {
    use super::*;
    use rand::distributions::{Distribution, Uniform};
    use rand::thread_rng;

    fn random_matrix(n: usize) -> Vec<Vec<f64>> {
        let mut rng = thread_rng();
        let uniform = Uniform::from(-1.0..1.0);
        (0..n)
            .map(|_| (0..n).map(|_| uniform.sample(&mut rng)).collect())
            .collect()
    }

    #[test]
    fn test_sequential_product() {
        let a = random_matrix(40);
        let b = random_matrix(40);

        assert_eq!(simple_product_ab(&a, &b), product_ab(&a, &b));
    }

    #[test]
    fn test_outer_loop_parallelized() {
        let a = random_matrix(40);
        let b = random_matrix(40);

        assert_eq!(par_product_ab_rayon(&a, &b), simple_product_ab(&a, &b));
    }

    #[test]
    fn test_both_loops_parallelized() {
        let a = random_matrix(40);
        let b = random_matrix(40);

        assert_eq!(
            par_par_product_ab_rayon(&a, &b),
            simple_product_ab(&a, &b)
        );
    }
}
