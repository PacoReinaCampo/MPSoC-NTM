## Instruction Pseudo Code (Alternative)

Format of a line in the table:

`<instruction name> "<instruction pseudo code>"`

| instruction name    | instruction pseudo code                                                    | status    |
|---------------------|:---------------------------------------------------------------------------|:----------|
| `ADC(.B)  dst`      | `dst + C -> dst`                                                           | `x x x x` |
| `ADD(.B)  src,dst`  | `src + dst -> dst`                                                         | `x x x x` |
| `ADDC(.B) src,dst`  | `src + dst + C -> dst`                                                     | `x x x x` |
| `AND(.B)  src,dst`  | `src .and. dst -> dst`                                                     | `0 x x x` |
| `BIC(.B)  src,dst`  | `.not.src .and. dst -> dst`                                                | `- - - -` |
| `BIS(.B)  src,dst`  | `src .or. dst -> dst`                                                      | `- - - -` |
| `BIT(.B)  src,dst`  | `src .and. dst`                                                            | `0 x x x` |
| `BR dst`            | `Branch to ...`                                                            | `- - - -` |
| `CALL     dst`      | `PC+2 -> stack, dst -> PC`                                                 | `- - - -` |
| `CLR(.B)  dst`      | `Clear destination`                                                        | `- - - -` |
| `CLRC`              | `Clear carry bit`                                                          | `- - - 0` |
| `CLRN`              | `Clear negative bit`                                                       | `- 0 - -` |
| `CLRZ`              | `Clear zero bit`                                                           | `- - 0 -` |
| `CMP(.B)  src,dst`  | `dst - src`                                                                | `x x x x` |
| `DADC(.B) dst`      | `dst + C -> dst (decimal)`                                                 | `x x x x` |
| `DADD(.B) src,dst`  | `src + dst + C -> dst (decimal)`                                           | `x x x x` |
| `DEC(.B)  dst`      | `dst - 1 -> dst`                                                           | `x x x x` |
| `DECD(.B) dst`      | `dst - 2 -> dst`                                                           | `x x x x` |
| `DINT`              | `Disable interrupt`                                                        | `- - - -` |
| `EINT`              | `Enable interrupt`                                                         | `- - - -` |
| `INC(.B)  dst`      | `Increment destination, dst +1 -> dst`                                     | `x x x x` |
| `INCD(.B) dst`      | `Double-Increment destination, dst+2->dst`                                 | `x x x x` |
| `INV(.B)  dst`      | `Invert destination`                                                       | `x x x x` |
| `JC       Label`    | `Jump to Label if Carry-bit is set`                                        | `- - - -` |
| `JHS      Label`    | `Jump to Label if Carry-bit is set`                                        | `- - - -` |
| `JZ       Label`    | `Jump to Label if Zero-bit is set`                                         | `- - - -` |
| `JEQ      Label`    | `Jump to Label if Zero-bit is set`                                         | `- - - -` |
| `JGE      Label`    | `Jump to Label if (N .XOR. V) = 0`                                         | `- - - -` |
| `JL       Label`    | `Jump to Label if (N .XOR. V) = 1`                                         | `- - - -` |
| `JMP      Label`    | `Jump to Label unconditionally`                                            | `- - - -` |
| `JN       Label`    | `Jump to Label if Negative-bit is set`                                     | `- - - -` |
| `JNC      Label`    | `Jump to Label if Carry-bit is reset`                                      | `- - - -` |
| `JLO      Label`    | `Jump to Label if Carry-bit is reset`                                      | `- - - -` |
| `JNE      Label`    | `Jump to Label if Zero-bit is reset`                                       | `- - - -` |
| `JNZ      Label`    | `Jump to Label if Zero-bit is reset`                                       | `- - - -` |
| `MOV(.B)  src,dst`  | `src -> dst`                                                               | `- - - -` |
| `NOP`               | `No operation`                                                             | `- - - -` |
| `POP(.B)  dst`      | `Item from stack, SP+2 -> SP`                                              | `- - - -` |
| `PUSH(.B) src`      | `SP - 2 -> SP, src -> @SP`                                                 | `- - - -` |
| `RETI`              | `Return from interrupt, TOS -> SR, SP + 2 -> SP, TOS -> PC, SP + 2 -> SZ`  | `x x x x` |
| `RET`               | `Return from subroutine, TOS -> PC, SP + 2 -> SP`                          | `- - - -` |
| `RLA(.B)  dst`      | `Rotate left arithmetically`                                               | `x x x x` |
| `RLC(.B)  dst`      | `Rotate left through carry`                                                | `x x x x` |
| `RRA(.B)  dst`      | `MSB -> MSB ... LSB -> C`                                                  | `0 x x x` |
| `RRC(.B)  dst`      | `C -> MSB ... LSB -> C`                                                    | `x x x x` |
| `SBC(.B)  dst`      | `Subtract carry from destination`                                          | `x x x x` |
| `SETC`              | `Set carry bit`                                                            | `- - - 1` |
| `SETN`              | `Set negative bit`                                                         | `- 1 - -` |
| `SETZ`              | `Set zero bit`                                                             | `- - 1 -` |
| `SUB(.B)  src,dst`  | `dst + .not.src + 1 -> dst`                                                | `x x x x` |
| `SUBC(.B) src,dst`  | `dst + .not.src + C -> dst`                                                | `x x x x` |
| `SWPB     dst`      | `swap bytes`                                                               | `- - - -` |
| `SXT      dst`      | `Bit7 -> Bit8 ... Bit15`                                                   | `0 x x x` |
| `TST(.B)  dst`      | `Test destination`                                                         | `x x x x` |
| `XOR(.B)  src,dst`  | `src .xor. dst -> dst`                                                     | `x x x x` |
: MSP430 - "MSP430 Base Integer Instruction Set"
