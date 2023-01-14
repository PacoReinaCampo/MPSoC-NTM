/*
   Copyright 2013 Ray Salemi

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
class tester;

   virtual tinyalu_bfm bfm;

   function new (virtual tinyalu_bfm b);
       bfm = b;
   endfunction : new


   protected function operation_t get_op();
      bit [2:0] op_choice;
      op_choice = $random;
      case (op_choice)
        3'b000 : return no_op;
        3'b001 : return add_op;
        3'b010 : return and_op;
        3'b011 : return xor_op;
        3'b100 : return mul_op;
        3'b101 : return no_op;
        3'b110 : return rst_op;
        3'b111 : return rst_op;
      endcase // case (op_choice)
   endfunction : get_op

   protected function byte get_data();
      bit [1:0] zero_ones;
      zero_ones = $random;
      if (zero_ones == 2'b00)
        return 8'h00;
      else if (zero_ones == 2'b11)
        return 8'hFF;
      else
        return $random;
   endfunction : get_data
   
   task execute();
      byte         unsigned        iA;
      byte         unsigned        iB;
      shortint     unsigned        result;
      operation_t                  op_set;
      bfm.reset_alu();
      op_set = rst_op;
      iA = get_data();
      iB = get_data();
      bfm.send_op(iA, iB, op_set, result);
      op_set = mul_op;
      bfm.send_op(iA, iB, op_set, result);
      bfm.send_op(iA, iB, op_set, result);
      op_set = rst_op;
      bfm.send_op(iA, iB, op_set, result);
      repeat (10) begin : random_loop
         op_set = get_op();
         iA = get_data();
         iB = get_data();
         bfm.send_op(iA, iB, op_set, result );
         $display("%2h %6s %2h = %4h",iA, op_set.name(), iB, result);
      end : random_loop
      $stop;
   endtask : execute
   
endclass : tester






