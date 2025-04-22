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

pub struct StateFeedback {
    pub data_a_in: Vec<Vec<f64>>,
    pub data_b_in: Vec<Vec<f64>>,
    pub data_c_in: Vec<Vec<f64>>,
    pub data_d_in: Vec<Vec<f64>>,

    pub data_k_in: Vec<Vec<f64>>,
    pub data_u_in: Vec<Vec<f64>>,

    pub initial_x: Vec<f64>,

    pub k: f64
}

pub struct StateOutputs {
    pub data_a_in: Vec<Vec<f64>>,
    pub data_b_in: Vec<Vec<f64>>,
    pub data_c_in: Vec<Vec<f64>>,
    pub data_d_in: Vec<Vec<f64>>,

    pub data_k_in: Vec<Vec<f64>>,
    pub data_u_in: Vec<Vec<f64>>,

    pub initial_x: Vec<f64>,

    pub k: f64
}

pub struct StateTop {
    pub data_a_in: Vec<Vec<f64>>,
    pub data_b_in: Vec<Vec<f64>>,
    pub data_c_in: Vec<Vec<f64>>,
    pub data_d_in: Vec<Vec<f64>>,

    pub data_k_in: Vec<Vec<f64>>,
    pub data_u_in: Vec<Vec<f64>>,

    pub initial_x: Vec<f64>,

    pub k: f64
}

impl StateFeedback {
    pub fn ntm_state_matrix_feedforward(&self)-> Vec<Vec<f64>> {
        // calculating feedback
        return self.data_a_in + self.data_b_in
    }

    pub fn ntm_state_matrix_input(&self)-> Vec<Vec<f64>> {
        // calculating outputs
        return self.data_a_in * self.data_b_in
    }

    pub fn ntm_state_matrix_output(&self)-> Vec<Vec<f64>> {
        // calculating top
        return self.data_a_in / self.data_b_in
    }

    pub fn ntm_state_matrix_state(&self)-> Vec<Vec<f64>> {
        // calculating top
        return self.data_a_in / self.data_b_in
    }
}

impl StateOutputs {
    pub fn ntm_state_vector_output(&self)-> Vec<f64> {
        // calculating outputs
        return self.data_a_in * self.data_b_in
    }

    pub fn ntm_state_vector_state(&self)-> Vec<f64> {
        // calculating top
        return self.data_a_in / self.data_b_in
    }
}

impl StateTop {
    pub fn ntm_state_top(&self)-> Vec<f64> {
        // calculating top
        return self.data_a_in / self.data_b_in
    }
}

#[allow(dead_code)]
fn main() {
    let feedback = StateFeedback {
        data_a_in: 48.0,
        data_b_in: 16.0,

        data_out: 64.0
    };
    let outputs = StateOutputs {
        data_a_in: 48.0,
        data_b_in: 16.0,

        data_out: 768.0
    };
    let top = StateTop {
        data_a_in: 48.0,
        data_b_in: 16.0,

        data_out: 3.0
    };

    assert_eq!(feedback.ntm_state_matrix_feedforward(), feedback.data_out);
    assert_eq!(feedback.ntm_state_matrix_input(), feedback.data_out);
    assert_eq!(feedback.ntm_state_matrix_output(), feedback.data_out);
    assert_eq!(feedback.ntm_state_matrix_state(), feedback.data_out);

    assert_eq!(outputs.ntm_state_vector_output(), outputs.data_out);
    assert_eq!(outputs.ntm_state_vector_state(), outputs.data_out);

    assert_eq!(top.ntm_state_top(), top.data_out);
}
