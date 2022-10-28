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
 
use clap::{App, Arg, ArgMatches};
use std::io::Write;

pub mod matrix_product;

pub fn parse_args<'a>(name: &str, about: &str) -> ArgMatches<'a> {
    App::new(name)
        .about(about)
        .arg(
            Arg::with_name("n")
                .long("matrix-size")
                .short("n")
                .takes_value(true)
                .number_of_values(1)
                .help("Size of square matrices (default 100)"),
        )
        .get_matches()
}

pub fn main_inner<F: Fn(&[Vec<f64>], &[Vec<f64>]) -> Vec<Vec<f64>>>(
    opts: ArgMatches<'_>,
    f: F,
) -> Option<Vec<Vec<f64>>> {
    if let Ok(n) = opts
        .value_of("n")
        .map(|n| n.parse())
        .unwrap_or_else(|| Ok(100))
    {
        let a = vec![vec![1.0; n]; n];
        let b = vec![vec![1.0; n]; n];

        Some(f(&a, &b))
    } else {
        writeln!(std::io::stderr(), "Could not parse 'n' as usize")
            .expect("Could not write to stderr");
        None
    }
}
