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

package main

import (
  "fmt"
)

func main() {
  var SIZE_A_I_IN, SIZE_A_J_IN int
  var SIZE_B_I_IN, SIZE_B_J_IN int
  var DATA_A_IN, DATA_B_IN, result [10][10] int

  fmt.Print("Enter no of rows of DATA_A_IN: ")
  fmt.Scanln(&SIZE_A_I_IN)
  fmt.Print("Enter no of column of DATA_A_IN: ")
  fmt.Scanln(&SIZE_A_J_IN)
  fmt.Print("Enter no of rows of DATA_B_IN: ")
  fmt.Scanln(&SIZE_B_I_IN)
  fmt.Print("Enter no of column of DATA_B_IN: ")
  fmt.Scanln(&SIZE_B_J_IN)
  fmt.Println("\nEnter matrix_1 elements: ")

  for i := 0; i < SIZE_A_I_IN; i++ {
    for j := 0; j < SIZE_A_J_IN; j++ {
      fmt.Scanf("%d ", &DATA_A_IN[i][j])
    }
  }

  fmt.Println("\nEnter matrix_2 elements: ")

  for i := 0; i < SIZE_B_I_IN; i++ {
    for j := 0; j < SIZE_B_J_IN; j++ {
      fmt.Scanf("%d ", &DATA_B_IN[i][j])
    }
  }

  // Multiplication of two matrix
  for i := 0; i < SIZE_A_I_IN; i++ {
    for j := 0; j < SIZE_B_J_IN; j++ {
      result[i][j] = 0

      for k := 0; k < SIZE_B_J_IN; k++ {
        result[i][j] += DATA_A_IN[i][k] * DATA_B_IN[k][j]
      }
    }
  }

  fmt.Println("\nAfter Multiplication Matrix is: \n")

  for i := 0; i < SIZE_A_I_IN; i++ {
    for j := 0; j < SIZE_B_J_IN; j++ {
      fmt.Printf("%d ", result[i][j])
    }
    fmt.Println("\n")
  }
}
