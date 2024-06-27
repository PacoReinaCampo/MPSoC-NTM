## INSTRUCTION DESCRIPTIONS

Instructions in RISC-V are designed to perform specific operations ranging from basic arithmetic and logical computations to memory access and control flow. Each instruction description outlines its functionality, including operands (registers or immediates), effects on status flags, memory access patterns, and control flow implications. Descriptions provide a clear understanding of how instructions interact with processor state and contribute to program execution.

Format of a line in the table:

`<instruction name> "<instruction description>"`

| instruction name   | instruction description                                                                                                          |
|--------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| `lui`              | `Set and sign extend the 20-bit immediate (shited 12 bits left) and zero the bottom 12 bits into rd`                             |
| `auipc`            | `Place the PC plus the 20-bit signed immediate (shited 12 bits left) into rd (used before JALR)`                                 |
| `jal`              | `Jump to the PC plus 20-bit signed immediate while saving PC+4 into rd`                                                          |
| `jalr`             | `Jump to rs1 plus the 12-bit signed immediate while saving PC+4 into rd`                                                         |
| `beq`              | `Branch to PC relative 12-bit signed immediate (shifted 1 bit left) if rs1 == rs2`                                               |
| `bne`              | `Branch to PC relative 12-bit signed immediate (shifted 1 bit left) if rs1 != rs2`                                               |
| `blt`              | `Branch to PC relative 12-bit signed immediate (shifted 1 bit left) if rs1 < rs2 (signed)`                                       |
| `bge`              | `Branch to PC relative 12-bit signed immediate (shifted 1 bit left) if rs1 >= rs2 (signed)`                                      |
| `bltu`             | `Branch to PC relative 12-bit signed immediate (shifted 1 bit left) if rs1 < rs2 (unsigned)`                                     |
| `bgeu`             | `Branch to PC relative 12-bit signed immediate (shifted 1 bit left) if rs1 >= rs2 (unsigned)`                                    |
| `lb`               | `Load 8-bit value from addr in rs1 plus the 12-bit signed immediate and place sign-extended result into rd`                      |
| `lh`               | `Load 16-bit value from addr in rs1 plus the 12-bit signed immediate and place sign-extended result into rd`                     |
| `lw`               | `Load 32-bit value from addr in rs1 plus the 12-bit signed immediate and place sign-extended result into rd`                     |
| `lbu`              | `Load 8-bit value from addr in rs1 plus the 12-bit signed immediate and place zero-extended result into rd`                      |
| `lhu`              | `Load 32-bit value from addr in rs1 plus the 12-bit signed immediate and place zero-extended result into rd`                     |
| `lwu`              | `Load 32-bit value from addr in rs1 plus the 12-bit signed immediate and place zero-extended result into rd`                     |
| `sb`               | `Store 8-bit value from the low bits of rs2 to addr in rs1 plus the 12-bit signed immediate`                                     |
| `sh`               | `Store 16-bit value from the low bits of rs2 to addr in rs1 plus the 12-bit signed immediate`                                    |
| `sw`               | `Store 32-bit value from the low bits of rs2 to addr in rs1 plus the 12-bit signed immediate`                                    |
| `addi`             | `Add sign-extended 12-bit immediate to register rs1 and place the result in rd`                                                  |
| `slti`             | `Set rd to 1 if rs1 is less than the sign-extended 12-bit immediate, otherwise set rd to 0 (signed)`                             |
| `sltiu`            | `Set rd to 1 if rs1 is less than the sign-extended 12-bit immediate, otherwise set rd to 0 (unsigned)`                           |
| `xori`             | `Set rd to the bitwise xor of rs1 with the sign-extended 12-bit immediate`                                                       |
| `ori`              | `Set rd to the bitwise or of rs1 with the sign-extended 12-bit immediate`                                                        |
| `andi`             | `Set rd to the bitwise and of rs1 with the sign-extended 12-bit immediate`                                                       |
| `slli`             | `Shift rs1 left by the 5 or 6 (RV32/64) bit (RV64) immediate and place the result into rd`                                       |
| `srli`             | `Shift rs1 right by the 5 or 6 (RV32/64) bit immediate and place the result into rd`                                             |
| `srai`             | `Shift rs1 right by the 5 or 6 (RV32/64) bit immediate and place the result into rd while retaining the sign`                    |
| `add`              | `Add rs2 to rs1 and place the result into rd`                                                                                    |
| `sub`              | `Subtract rs2 from rs1 and place the result into rd`                                                                             |
| `sll`              | `Shift rs1 left by the by the lower 5 or 6 (RV32/64) bits in rs2 and place the result into rd`                                   |
| `slt`              | `Set rd to 1 if rs1 is less than rs2, otherwise set rd to 0 (signed)`                                                            |
| `sltu`             | `Set rd to 1 if rs1 is less than rs2, otherwise set rd to 0 (unsigned)`                                                          |
| `xor`              | `Set rd to the bitwise xor of rs1 and rs2`                                                                                       |
| `srl`              | `Shift rs1 right by the by the lower 5 or 6 (RV32/64) bits in rs2 and place the result into rd`                                  |
| `sra`              | `Shift rs1 right by the by the lower 5 or 6 (RV32/64) bits in rs2 and place the result into rd while retaining the sign`         |
| `or`               | `Set rd to the bitwise or of rs1 and rs2`                                                                                        |
| `and`              | `Set rd to the bitwise and of rs1 and rs2`                                                                                       |
| `fence`            | `Order device I/O and memory accesses viewed by other threads and devices`                                                       |
| `fence.i`          | `Synchronize the instruction and data streams`                                                                                   |
: RV32I - "RV32I Base Integer Instruction Set"

| instruction name   | instruction description                                                                                                          |
|--------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| `ld`               | `Load 64-bit value from addr in rs1 plus 12-bit signed immediate and place sign-extended result into rd`                         |
| `sd`               | `Store 64-bit value from the low bits of rs2 to addr in rs1 plus the 12-bit signed immediate`                                    |
| `addiw`            | `Add sign-extended 12-bit immediate to register rs1 and place 32-bit sign extended result in rs2 zeroing upper bits`             |
| `slliw`            | `Shift 32-bit value in rs1 left by the 5 bit immediate and place the result into rd while zeroing upper bits`                    |
| `srliw`            | `Shift 32-bit value in rs1 right by the 5 bit immediate and place the result into rd while zeroing upper bits`                   |
| `sraiw`            | `Shift 32-bit value in rs1 right by the 5 bit immediate and place the result into rd and retaining the sign`                     |
| `addw`             | `Add 32-bit value in rs2 to rs1 and place the 32-bit result into rd`                                                             |
| `subw`             | `Subtract 32-bit value in rs2 from rs1 and place the 32-bit result into rd`                                                      |
| `sllw`             | `Shift 32-bit value in rs1 left by the by the lower 5 bits in rs2 and place the 32-bit result into rd`                           |
| `srlw`             | `Shift 32-bit value in rs1 right by the by the lower 5 bits in rs2 and place the 32-bit result into rd`                          |
| `sraw`             | `Shift 32-bit value in rs1 right by the by the lower 5 bits in rs2 and place the 32-bit result into rd while retaining the sign` |
: RV64I - "RV64I Base Integer Instruction Set (+ RV32I)"

| instruction name   | instruction description                                                                                                          |
|--------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| `mul`              | `Multiply rs1 by rs2 and place the result in rd`                                                                                 |
| `mulh`             | `Multiply signed rs1 by signed rs2 and place the high bits of the result in rd`                                                  |
| `mulhsu`           | `Multiply signed rs1 by unsigned rs2 and place the high bits of the result in rd`                                                |
| `mulhu`            | `Multiply unsigned rs1 by unsigned rs2 and place the high bits of the result in rd`                                              |
| `div`              | `Divide rs1 (dividend) by rs2 (divisor) and place the quotient in rd (signed)`                                                   |
| `divu`             | `Divide rs1 (dividend) by rs2 (divisor) and place the quotient in rd (unsigned)`                                                 |
| `rem`              | `Divide rs1 (dividend) by rs2 (divisor) and place the remainder in rd (signed)`                                                  |
| `remu`             | `Divide rs1 (dividend) by rs2 (divisor) and place the remainder in rd (unsigned)`                                                |
: RV32M - "RV32M Standard Extension for Integer Multiply and Divide"

| instruction name   | instruction description                                                                                                          |
|--------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| `mulw`             | `Multiply with lower 32-bits of rs1 by the lower 32-bits of rs2 and place the result in rd`                                      |
| `divw`             | `Divide lower 32-bits of rs1 (dividend) by lower 32-bits of rs2 (divisor) and place the quotient in rd (signed)`                 |
| `divuw`            | `Divide lower 32-bits of rs1 (dividend) by lower 32-bits of rs2 (divisor) and place the quotient in rd (unsigned)`               |
| `remw`             | `Divide lower 32-bits of rs1 (dividend) by lower 32-bits of rs2 (divisor) and place the remainder in rd (signed)`                |
| `remuw`            | `Divide lower 32-bits of rs1 (dividend) by lower 32-bits of rs2 (divisor) and place the remainder in rd (unsigned)`              |
: RV64M - "RV64M Standard Extension for Integer Multiply and Divide (+ RV32M)"

| instruction name   | instruction description                                                                                                          |
|--------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| `lr.w`             | `Load word from address in rs1, place the sign-extended result in rd and register a reservation on the memory word`              |
| `sc.w`             | `Write word in rs1 to the address in rs2 if a valid reservation exists, write 0 on success or 1 on failure to rd`                |
| `amoswap.w`        | `Load word from address in rs1 into rd, swap rd and rs2, write the result to the address in rs1`                                 |
| `amoadd.w`         | `Load word from address in rs1 into rd, add rd and rs2, write the result to the address in rs1`                                  |
| `amoxor.w`         | `Load word from address in rs1 into rd, xor rd and rs2, write the result to the address in rs1`                                  |
| `amoor.w`          | `Load word from address in rs1 into rd, or rd and rs2, write the result to the address in rs1`                                   |
| `amoand.w`         | `Load word from address in rs1 into rd, and rd and rs2, write the result to the address in rs1`                                  |
| `amomin.w`         | `Load word from address in rs1 into rd, find minimum of rd and rs2, write the result to the address in rs1 (signed)`             |
| `amomax.w`         | `Load word from address in rs1 into rd, find maximum of rd and rs2, write the result to the address in rs1 (signed)`             |
| `amominu.w`        | `Load word from address in rs1 into rd, find minimum of rd and rs2, write the result to the address in rs1 (unsigned)`           |
| `amomaxu.w`        | `Load word from address in rs1 into rd, find maximum of rd and rs2, write the result to the address in rs1 (unsigned)`           |
: RV32A - "RV32A Standard Extension for Atomic Instructions"

| instruction name   | instruction description                                                                                                          |
|--------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| `lr.d`             | `Load double word from address in rs1, place the sign-extended result in rd and register a reservation on the memory word`       |
| `sc.d`             | `Write double word in rs1 to the address in rs2 if a valid reservation exists, write 0 on success or 1 on failure to rd`         |
| `amoswap.d`        | `Load double word from address in rs1 into rd, swap rd and rs2, write the result to the address in rs1`                          |
| `amoadd.d`         | `Load double word from address in rs1 into rd, add rd and rs2, write the result to the address in rs1`                           |
| `amoxor.d`         | `Load double word from address in rs1 into rd, xor rd and rs2, write the result to the address in rs1`                           |
| `amoor.d`          | `Load double word from address in rs1 into rd, or rd and rs2, write the result to the address in rs1`                            |
| `amoand.d`         | `Load double word from address in rs1 into rd, and rd and rs2, write the result to the address in rs1`                           |
| `amomin.d`         | `Load double word from address in rs1 into rd, find minimum of rd and rs2, write the result to the address in rs1 (signed)`      |
| `amomax.d`         | `Load double word from address in rs1 into rd, find maximum of rd and rs2, write the result to the address in rs1 (signed)`      |
| `amominu.d`        | `Load double word from address in rs1 into rd, find minimum of rd and rs2, write the result to the address in rs1 (unsigned)`    |
| `amomaxu.d`        | `Load double word from address in rs1 into rd, find maximum of rd and rs2, write the result to the address in rs1 (unsigned)`    |
: RV64A - "RV64A Standard Extension for Atomic Instructions (+ RV32A)"

| instruction name   | instruction description                                                                                                          |
|--------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| `scall`            | `System call is used to make a request to a higher privilege level`                                                              |
| `sbreak`           | `Break to Debugger causes control to be transferred back to the debugging environment via a breakpoint exception`                |
| `sret`             | `System Return returns to the supervisor mode privilege level after handling a trap`                                             |
| `sfence.vm`        | `Supervisor memory-management fence synchronizes updates to in-memory memory-management data structures`                         |
| `wfi`              | `Wait for Interrupt indicates the hart can be stalled until an interrupt needs servicing`                                        |
| `rdcycle`          | `Read cycle counter status register`                                                                                             |
| `rdtime`           | `Read timer status register`                                                                                                     |
| `rdinstret`        | `Read instructions retired status register`                                                                                      |
| `rdcycleh`         | `Read cycle counter status register (upper 32-bits on RV32)`                                                                     |
| `rdtimeh`          | `Read timer status register (upper 32-bits on RV32)`                                                                             |
| `rdinstreth`       | `Read instructions retired status register (upper 32-bits on RV32)`                                                              |
| `csrrw`            | `CSR Atomic Read Write writes the value in rs1 to the CSR, and writes previous value to rd`                                      |
| `csrrs`            | `CSR Atomic Set Bit reads the CSR, sets CSR bits set in rs1, and writes previous value to rd`                                    |
| `csrrc`            | `CSR Atomic Clear Bit reads the CSR, clears CSR bits set in rs1, and writes previous value to rd`                                |
| `csrrwi`           | `CSR Atomic Read Write Immediate writes the immediate value to the CSR, and writes previous value to rd`                         |
| `csrrsi`           | `CSR Atomic Set Bit Immediate reads the CSR, sets CSR bits set in the immediate, and writes previous value to rd`                |
| `csrrci`           | `CSR Atomic Clear Bit Immediate reads the CSR, clears CSR bits set in the immediate, and writes previous value to rd`            |
: RV32S - "RV32S Standard Extension for Supervisor-level Instructions"

| instruction name   | instruction description                                                                                                          |
|--------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| `flw`              | `Loads a single-precision foating-point value from memory into foating-point register frd`                                       |
| `fsw`              | `Stores a single-precision foating-point value from foating-point register frs2 to memory`                                       |
| `fmadd.s`          | `Multiply the single-precision values in frs1 and frs2, then add rs3 and write the result to frd`                                |
| `fmsub.s`          | `Multiply the single-precision values in frs1 and frs2, then subtract rs3 and write the result to frd`                           |
| `fnmsub.s`         | `Multiply the single-precision value in frs1 with the negated value in frs2, then add rs3 and write the result to frd`           |
| `fnmadd.s`         | `Multiply the single-precision value in frs1 with the negated value in frs2, then subtract rs3 and write the result to frd`      |
| `fadd.s`           | `Add the single-precision values in frs1 and frs2, then write the result to frd`                                                 |
| `fsub.s`           | `Subtract the single-precision values in frs1 from frs2, then write the result to frd`                                           |
| `fmul.s`           | `Multiply the single-precision values in frs1 and frs2, then write the result to frd`                                            |
| `fdiv.s`           | `Divide the single-precision value in frs1 into frs2, then write the result to frd`                                              |
| `fsgnj.s`          | `Take the single-precision value from frs1 and inject the sign bit from frs2, then write the result to frd`                      |
| `fsgnjn.s`         | `Take the single-precision value from frs1 and inject the negated sign bit from frs2, then write the result to frd`              |
| `fsgnjx.s`         | `Take the single-precision value from frs1 and inject the xor of the sign bits frs1 and frs2, then write the result to frd`      |
| `fmin.s`           | `Take the smaller single-precision value from frs1 and frs2, then write the result to frd`                                       |
| `fmax.s`           | `Take the larger single-precision value from frs1 and frs2, then write the result to frd`                                        |
| `fsqrt.s`          | `Calculate the square root of the single-precision value in frs1, then write the result to frd`                                  |
| `fle.s`            | `Set rd to 1 if the single-precision value in frs1 is less than or equal to frs2, otherwise set rd to 0`                         |
| `flt.s`            | `Set rd to 1 if the single-precision value in frs1 is less than frs2, otherwise set rd to 0`                                     |
| `feq.s`            | `Set rd to 1 if the single-precision value in frs1 is equal to frs2, otherwise set rd to 0`                                      |
| `fcvt.w.s`         | `Convert the single-precision value in frs1 to a 32-bit signed integer, then write the result to rd`                             |
| `fcvt.wu.s`        | `Convert the single-precision value in frs1 to a 32-bit unsigned integer, then write the result to rd`                           |
| `fcvt.s.w`         | `Convert the 32-bit signed integer in rs1 to a single-precision value, then write the result to frd`                             |
| `fcvt.s.wu`        | `Convert the 32-bit unsigned integer in rs1 to a single-precision value, then write the result to frd`                           |
| `fclass.s`         | `Set rd to a 10-bit mask indicating the class of the single-precision value in frs1`                                             |
: RV32F - "RV32F Standard Extension for Single-Precision Floating-Point"

| instruction name   | instruction description                                                                                                          |
|--------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| `fcvt.l.s`         | `Convert the single-precision value in frs1 to a 64-bit signed integer, then write the result to rd`                             |
| `fcvt.lu.s`        | `Convert the single-precision value in frs1 to a 64-bit unsigned integer, then write the result to rd`                           |
| `fmv.x.s`          | `Write the sign extended single-precision value in frs1 into the integer register rd`                                            |
| `fcvt.s.l`         | `Convert the 64-bit signed integer in rs1 to a single-precision value, then write the result to frd`                             |
| `fcvt.s.lu`        | `Convert the 64-bit unsigned integer in rs1 to a single-precision value, then write the result to frd`                           |
| `fmv.s.x`          | `Write the lower 32-bits of the integer register rs1 into the single-precision register frd`                                     |
: RV64F - "RV64F Standard Extension for Single-Precision Floating-Point (+ RV32F)"

| instruction name   | instruction description                                                                                                          |
|--------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| `fld`              | `Loads a double-precision foating-point value from memory into foating-point register frd`                                       |
| `fsd`              | `Stores a double-precision foating-point value from foating-point register frs2 to memory`                                       |
| `fmadd.d`          | `Multiply the double-precision values in frs1 and frs2, then add rs3 and write the result to frd`                                |
| `fmsub.d`          | `Multiply the double-precision values in frs1 and frs2, then subtract rs3 and write the result to frd`                           |
| `fnmsub.d`         | `Multiply the double-precision value in frs1 with the negated value in frs2, then add rs3 and write the result to frd`           |
| `fnmadd.d`         | `Multiply the double-precision value in frs1 with the negated value in frs2, then subtract rs3 and write the result to frd`      |
| `fadd.d`           | `Add the double-precision values in frs1 and frs2, then write the result to frd`                                                 |
| `fsub.d`           | `Subtract the double-precision values in frs1 from frs2, then write the result to frd`                                           |
| `fmul.d`           | `Multiply the double-precision values in frs1 and frs2, then write the result to frd`                                            |
| `fdiv.d`           | `Divide the double-precision value in frs1 into frs2, then write the result to frd`                                              |
| `fsgnj.d`          | `Take the double-precision value from frs1 and inject the sign bit from frs2, then write the result to frd`                      |
| `fsgnjn.d`         | `Take the double-precision value from frs1 and inject the negated sign bit from frs2, then write the result to frd`              |
| `fsgnjx.d`         | `Take the double-precision value from frs1 and inject the xor of the sign bits frs1 and frs2, then write the result to frd`      |
| `fmin.s`           | `Take the smaller double-precision value from frs1 and frs2, then write the result to frd`                                       |
| `fmax.s`           | `Take the larger double-precision value from frs1 and frs2, then write the result to frd`                                        |
| `fcvt.s.d`         | `Convert the double-precision value in frs1 to single-precision, then write the result to frd`                                   |
| `fcvt.d.s`         | `Convert the single-precision value in frs1 to double-precision, then write the result to frd`                                   |
| `fsqrt.d`          | `Calculate the square root of the double-precision value in frs1, then write the result to frd`                                  |
| `fle.d`            | `Set rd to 1 if frs1 is less than or equal to frs2, otherwise set rd to 0`                                                       |
| `flt.d`            | `Set rd to 1 if frs1 is less than frs2, otherwise set rd to 0`                                                                   |
| `feq.d`            | `Set rd to 1 if frs1 is equal to frs2, otherwise set rd to 0`                                                                    |
| `fcvt.w.d`         | `Convert the double-precision value in frs1 to a 32-bit signed integer, then write the result to rd`                             |
| `fcvt.wu.d`        | `Convert the double-precision value in frs1 to a 32-bit unsigned integer, then write the result to rd`                           |
| `fcvt.d.w`         | `Convert the 64-bit signed integer in rs1 to a double-precision value, then write the result to frd`                             |
| `fcvt.d.wu`        | `Convert the 64-bit unsigned integer in rs1 to a double-precision value, then write the result to frd`                           |
| `fmv.x.d`          | `Write the sign extended double-precision value in frs1 into integer register rd`                                                |
| `fclass.d`         | `Set rd to a 10-bit mask indicating the class of the double-precision value in frs1`                                             |
| `fmv.d.x`          | `Write the 64-bit integer register rs1 into the double-precision register frd`                                                   |
: RV32D - "RV32D Standard Extension for Double-Precision Floating-Point"

| instruction name   | instruction description                                                                                                          |
|--------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| `fcvt.l.d`         | `Convert the double-precision value in frs1 to a 64-bit signed integer, then write the result to rd`                             |
| `fcvt.lu.d`        | `Convert the double-precision value in frs1 to a 64-bit unsigned integer, then write the result to rd`                           |
| `fcvt.d.l`         | `Convert the 64-bit signed integer in rs1 to a double-precision value, then write the result to frd`                             |
| `fcvt.d.lu`        | `Convert the 64-bit unsigned integer in rs1 to a double-precision value, then write the result to frd`                           |
: RV64D - "RV64D Standard Extension for Double-Precision Floating-Point (+ RV32D)"

| instruction name   | instruction description                                                                                                          |
|--------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| `frcsr`            | `Read FP Control and Status Register`                                                                                            |
| `frrm`             | `Read FP Rounding Mode (Bits 7:5 of fcsr Control and Status Register)`                                                           |
| `frflags`          | `Read FP Accrued Exception Flags (Bits 4:0 of fcsr Control and Status Register)`                                                 |
| `fscsr`            | `Read FP Control and Status Register`                                                                                            |
| `fsrm`             | `Set FP Rounding Mode (Bits 7:5 of fcsr Control and Status Register)`                                                            |
| `fsflags`          | `Set FP Accrued Exception Flags (Bits 4:0 of fcsr Control and Status Register)`                                                  |
| `fsrmi`            | `Set FP Rounding Mode Immediate (Bits 7:5 of fcsr Control and Status Register)`                                                  |
| `fsflagsi`         | `Set FP Accrued Exception Flags Immediate (Bits 4:0 of fcsr Control and Status Register)`                                        |
: RV32FD - "RV32F and RV32D Common Floating-Point Instructions"

| instruction name   | instruction description                                                                                                          |
|--------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| `flq`              | `Loads a quadruple-precision foating-point value from memory into foating-point register frd`                                    |
| `fsq`              | `Stores a quadruple-precision foating-point value from foating-point register frs2 to memory`                                    |
| `fmadd.q`          | `Multiply the quadruple-precision values in frs1 and frs2, then add rs3 and write the result to frd`                             |
| `fmsub.q`          | `Multiply the quadruple-precision values in frs1 and frs2, then subtract rs3 and write the result to frd`                        |
| `fnmsub.q`         | `Multiply the quadruple-precision value in frs1 with the negated value in frs2, then add rs3 and write the result to frd`        |
| `fnmadd.q`         | `Multiply the quadruple-precision value in frs1 with the negated value in frs2, then subtract rs3 and write the result to frd`   |
| `fadd.q`           | `Add the quadruple-precision values in frs1 and frs2, then write the result to frd`                                              |
| `fsub.q`           | `Subtract the quadruple-precision values in frs1 from frs2, then write the result to frd`                                        |
| `fmul.q`           | `Multiply the quadruple-precision values in frs1 and frs2, then write the result to frd`                                         |
| `fdiv.q`           | `Divide the quadruple-precision value in frs1 into frs2, then write the result to frd`                                           |
| `fsgnj.q`          | `Take the quadruple-precision value from frs1 and inject the sign bit from frs2, then write the result to frd`                   |
| `fsgnjn.q`         | `Take the quadruple-precision value from frs1 and inject the negated sign bit from frs2, then write the result to frd`           |
| `fsgnjx.q`         | `Take the quadruple-precision value from frs1 and inject the xor of the sign bits frs1 and frs2, then write the result to frd`   |
| `fmin.s`           | `Take the smaller quadruple-precision value from frs1 and frs2, then write the result to frd`                                    |
| `fmax.s`           | `Take the larger quadruple-precision value from frs1 and frs2, then write the result to frd`                                     |
| `fcvt.s.q`         | `Convert the quadruple-precision value in frs1 to single-precision, then write the result to frd`                                |
| `fcvt.q.s`         | `Convert the single-precision value in frs1 to quadruple-precision, then write the result to frd`                                |
| `fcvt.d.q`         | `Convert the quadruple-precision value in frs1 to double-precision, then write the result to frd`                                |
| `fcvt.q.d`         | `Convert the double-precision value in frs1 to quadruple-precision, then write the result to frd`                                |
| `fsqrt.q`          | `Calculate the square root of the quadruple-precision value in frs1, then write the result to frd`                               |
| `fle.q`            | `Set rd to 1 if frs1 is less than or equal to frs2, otherwise set rd to 0`                                                       |
| `flt.q`            | `Set rd to 1 if frs1 is less than frs2, otherwise set rd to 0`                                                                   |
| `feq.q`            | `Set rd to 1 if frs1 is equal to frs2, otherwise set rd to 0`                                                                    |
| `fcvt.w.q`         | `Convert the quadruple-precision value in frs1 to a 32-bit signed integer, then write the result to rd`                          |
| `fcvt.wu.q`        | `Convert the quadruple-precision value in frs1 to a 32-bit unsigned integer, then write the result to rd`                        |
| `fcvt.q.w`         | `Convert the 64-bit signed integer in rs1 to a quadruple-precision value, then write the result to frd`                          |
| `fcvt.q.wu`        | `Convert the 64-bit unsigned integer in rs1 to a quadruple-precision value, then write the result to frd`                        |
| `fclass.q`         | `Set rd to a 10-bit mask indicating the class of the quadruple-precision value in frs1`                                          |
: RV32Q - "RV32Q Standard Extension for Quadruple-Precision Floating-Point"

| instruction name   | instruction description                                                                                                          |
|--------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| `fcvt.l.q`         | `Convert the quadruple-precision value in frs1 to a 64-bit signed integer, then write the result to rd`                          |
| `fcvt.lu.q`        | `Convert the quadruple-precision value in frs1 to a 64-bit unsigned integer, then write the result to rd`                        |
| `fcvt.q.l`         | `Convert the 64-bit signed integer in rs1 to a quadruple-precision value, then write the result to frd`                          |
| `fcvt.q.lu`        | `Convert the 64-bit unsigned integer in rs1 to a quadruple-precision value, then write the result to frd`                        |
: RV64Q - "RV64Q Standard Extension for Quadruple-Precision Floating-Point (+ RV32Q)"

| instruction name   | instruction description                                                                                                          |
|--------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| `fmv.x.q`          | `Write the sign extended quadruple-precision value in frs1 into integer register rd`                                             |
| `fmv.q.x`          | `Write the 64-bit integer register rs1 into the quadruple-precision register frd`                                                |
: RV128Q - "RV128Q Standard Extension for Quadruple-Precision Floating-Point (+ RV64Q)"

| instruction name   | instruction description                                                                                                          |
|--------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| `radd.scalar.w`    | `Add the double-precision scalar values in frs1 and frs2, then write the result to frd`                                          |
| `rsub.scalar.w`    | `Subtract the double-precision scalar values in frs1 from frs2, then write the result to frd`                                    |
| `rmul.scalar.w`    | `Multiply the double-precision scalar values in frs1 and frs2, then write the result to frd`                                     |
| `rdiv.scalar.w`    | `Divide the double-precision scalar value in frs1 into frs2, then write the result to frd`                                       |
| `radd.vector.w`    | `Add the double-precision vector values in frs1 and frs2, then write the result to frd`                                          |
| `rsub.vector.w`    | `Subtract the double-precision vector values in frs1 from frs2, then write the result to frd`                                    |
| `rmul.vector.w`    | `Multiply the double-precision vector values in frs1 and frs2, then write the result to frd`                                     |
| `rdiv.vector.w`    | `Divide the double-precision vector value in frs1 into frs2, then write the result to frd`                                       |
| `radd.matrix.w`    | `Add the double-precision matrix values in frs1 and frs2, then write the result to frd`                                          |
| `rsub.matrix.w`    | `Subtract the double-precision matrix values in frs1 from frs2, then write the result to frd`                                    |
| `rmul.matrix.w`    | `Multiply the double-precision matrix values in frs1 and frs2, then write the result to frd`                                     |
| `rdiv.matrix.w`    | `Divide the double-precision matrix value in frs1 into frs2, then write the result to frd`                                       |
| `radd.tensor.w`    | `Add the double-precision tensor values in frs1 and frs2, then write the result to frd`                                          |
| `rsub.tensor.w`    | `Subtract the double-precision tensor values in frs1 from frs2, then write the result to frd`                                    |
| `rmul.tensor.w`    | `Multiply the double-precision tensor values in frs1 and frs2, then write the result to frd`                                     |
| `rdiv.tensor.w`    | `Divide the double-precision tensor value in frs1 into frs2, then write the result to frd`                                       |
: RV32RARITH - "RV32RARITH Expanded Extension for Real Arithmetic"

| instruction name   | instruction description                                                                                                          |
|--------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| `radd.scalar.d`    | `Add the double-precision scalar values in frs1 and frs2, then write the result to frd`                                          |
| `rsub.scalar.d`    | `Subtract the double-precision scalar values in frs1 from frs2, then write the result to frd`                                    |
| `rmul.scalar.d`    | `Multiply the double-precision scalar values in frs1 and frs2, then write the result to frd`                                     |
| `rdiv.scalar.d`    | `Divide the double-precision scalar value in frs1 into frs2, then write the result to frd`                                       |
| `radd.vector.d`    | `Add the double-precision vector values in frs1 and frs2, then write the result to frd`                                          |
| `rsub.vector.d`    | `Subtract the double-precision vector values in frs1 from frs2, then write the result to frd`                                    |
| `rmul.vector.d`    | `Multiply the double-precision vector values in frs1 and frs2, then write the result to frd`                                     |
| `rdiv.vector.d`    | `Divide the double-precision vector value in frs1 into frs2, then write the result to frd`                                       |
| `radd.matrix.d`    | `Add the double-precision matrix values in frs1 and frs2, then write the result to frd`                                          |
| `rsub.matrix.d`    | `Subtract the double-precision matrix values in frs1 from frs2, then write the result to frd`                                    |
| `rmul.matrix.d`    | `Multiply the double-precision matrix values in frs1 and frs2, then write the result to frd`                                     |
| `rdiv.matrix.d`    | `Divide the double-precision matrix value in frs1 into frs2, then write the result to frd`                                       |
| `radd.tensor.d`    | `Add the double-precision tensor values in frs1 and frs2, then write the result to frd`                                          |
| `rsub.tensor.d`    | `Subtract the double-precision tensor values in frs1 from frs2, then write the result to frd`                                    |
| `rmul.tensor.d`    | `Multiply the double-precision tensor values in frs1 and frs2, then write the result to frd`                                     |
| `rdiv.tensor.d`    | `Divide the double-precision tensor value in frs1 into frs2, then write the result to frd`                                       |
: RV64RARITH - "RV64RARITH Expanded Extension for Real Arithmetic (+ RV32RARITH)"

| instruction name   | instruction description                                                                                                          |
|--------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| `radd.scalar.q`    | `Add the double-precision scalar values in frs1 and frs2, then write the result to frd`                                          |
| `rsub.scalar.q`    | `Subtract the double-precision scalar values in frs1 from frs2, then write the result to frd`                                    |
| `rmul.scalar.q`    | `Multiply the double-precision scalar values in frs1 and frs2, then write the result to frd`                                     |
| `rdiv.scalar.q`    | `Divide the double-precision scalar value in frs1 into frs2, then write the result to frd`                                       |
| `radd.vector.q`    | `Add the double-precision vector values in frs1 and frs2, then write the result to frd`                                          |
| `rsub.vector.q`    | `Subtract the double-precision vector values in frs1 from frs2, then write the result to frd`                                    |
| `rmul.vector.q`    | `Multiply the double-precision vector values in frs1 and frs2, then write the result to frd`                                     |
| `rdiv.vector.q`    | `Divide the double-precision vector value in frs1 into frs2, then write the result to frd`                                       |
| `radd.matrix.q`    | `Add the double-precision matrix values in frs1 and frs2, then write the result to frd`                                          |
| `rsub.matrix.q`    | `Subtract the double-precision matrix values in frs1 from frs2, then write the result to frd`                                    |
| `rmul.matrix.q`    | `Multiply the double-precision matrix values in frs1 and frs2, then write the result to frd`                                     |
| `rdiv.matrix.q`    | `Divide the double-precision matrix value in frs1 into frs2, then write the result to frd`                                       |
| `radd.tensor.q`    | `Add the double-precision tensor values in frs1 and frs2, then write the result to frd`                                          |
| `rsub.tensor.q`    | `Subtract the double-precision tensor values in frs1 from frs2, then write the result to frd`                                    |
| `rmul.tensor.q`    | `Multiply the double-precision tensor values in frs1 and frs2, then write the result to frd`                                     |
| `rdiv.tensor.q`    | `Divide the double-precision tensor value in frs1 into frs2, then write the result to frd`                                       |
: RV128RARITH - "RV128RARITH Expanded Extension for Real Arithmetic (+ RV64RARITH)"

| instruction name   | instruction description                                                                                                          |
|--------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| `fmod.scalar.s`    | `Calculate the modulus of the single-precision scalar values in frs1 and frs2, then write the result to frd`                     |
| `fcbrt.scalar.s`   | `Calculate the cube root of the single-precision scalar value in frs1, then write the result to frd`                             |
| `fpow.scalar.s`    | `Calculate the pow of the single-precision scalar values in frs1 and frs2, then write the result to frd`                         |
| `fexp.scalar.s`    | `Calculate the exp of the single-precision scalar values in frs1 and frs2, then write the result to frd`                         |
| `flog.scalar.s`    | `Calculate the natural logarithm of the single-precision scalar value in frs1, then write the result to frd`                     |
| `flog2.scalar.s`   | `Calculate the logarithm base 2 of the single-precision scalar value in frs1, then write the result to frd`                      |
| `flog10.scalar.s`  | `Calculate the logarithm base 10 of the single-precision scalar value in frs1, then write the result to frd`                     |
| `flog.scalar.s`    | `Calculate the logarithm base of the single-precision scalar values in frs1 and frs2, then write the result to frd`              |
| `fsin.scalar.s`    | `Calculate the sine in radians of the single-precision scalar value in frs1, then write the result to frd`                       |
| `fcos.scalar.s`    | `Calculate the cosine in radians of the single-precision scalar value in frs1, then write the result to frd`                     |
| `ftan.scalar.s`    | `Calculate the tangent in radians of the single-precision scalar value in frs1, then write the result to frd`                    |
| `farcsin.scalar.s` | `Calculate the inverse sine of the single-precision scalar value in frs1, then write the result to frd`                          |
| `farccos.scalar.s` | `Calculate the inverse cosine of the single-precision scalar value in frs1, then write the result to frd`                        |
| `farctan.scalar.s` | `Calculate the inverse tangent of the single-precision scalar value in frs1, then write the result to frd`                       |
| `fsinh.scalar.s`   | `Calculate the hyperbolic sine of the single-precision scalar value in frs1, then write the result to frd`                       |
| `fcosh.scalar.s`   | `Calculate the hyperbolic cosine of the single-precision scalar value in frs1, then write the result to frd`                     |
| `ftanh.scalar.s`   | `Calculate the hyperbolic tangent of the single-precision scalar value in frs1, then write the result to frd`                    |
| `farcsinh.scalar.s`| `Calculate the inverse hyperbolic sine of the single-precision scalar value in frs1, then write the result to frd`               |
| `farccosh.scalar.s`| `Calculate the inverse hyperbolic cosine of the single-precision scalar value in frs1, then write the result to frd`             |
| `farctanh.scalar.s`| `Calculate the inverse hyperbolic tangent of the single-precision scalar value in frs1, then write the result to frd`            |
| `fmod.vector.s`    | `Calculate the modulus of the single-precision vector values in frs1 and frs2, then write the result to frd`                     |
| `fcbrt.vector.s`   | `Calculate the cube root of the single-precision vector value in frs1, then write the result to frd`                             |
| `fpow.vector.s`    | `Calculate the pow of the single-precision vector values in frs1 and frs2, then write the result to frd`                         |
| `fexp.vector.s`    | `Calculate the exp of the single-precision vector values in frs1 and frs2, then write the result to frd`                         |
| `flog.vector.s`    | `Calculate the natural logarithm of the single-precision vector value in frs1, then write the result to frd`                     |
| `flog2.vector.s`   | `Calculate the logarithm base 2 of the single-precision vector value in frs1, then write the result to frd`                      |
| `flog10.vector.s`  | `Calculate the logarithm base 10 of the single-precision vector value in frs1, then write the result to frd`                     |
| `flog.vector.s`    | `Calculate the logarithm base of the single-precision vector values in frs1 and frs2, then write the result to frd`              |
| `fsin.vector.s`    | `Calculate the sine in radians of the single-precision vector value in frs1, then write the result to frd`                       |
| `fcos.vector.s`    | `Calculate the cosine in radians of the single-precision vector value in frs1, then write the result to frd`                     |
| `ftan.vector.s`    | `Calculate the tangent in radians of the single-precision vector value in frs1, then write the result to frd`                    |
| `farcsin.vector.s` | `Calculate the inverse sine of the single-precision vector value in frs1, then write the result to frd`                          |
| `farccos.vector.s` | `Calculate the inverse cosine of the single-precision vector value in frs1, then write the result to frd`                        |
| `farctan.vector.s` | `Calculate the inverse tangent of the single-precision vector value in frs1, then write the result to frd`                       |
| `fsinh.vector.s`   | `Calculate the hyperbolic sine of the single-precision vector value in frs1, then write the result to frd`                       |
| `fcosh.vector.s`   | `Calculate the hyperbolic cosine of the single-precision vector value in frs1, then write the result to frd`                     |
| `ftanh.vector.s`   | `Calculate the hyperbolic tangent of the single-precision vector value in frs1, then write the result to frd`                    |
| `farcsinh.vector.s`| `Calculate the inverse hyperbolic sine of the single-precision vector value in frs1, then write the result to frd`               |
| `farccosh.vector.s`| `Calculate the inverse hyperbolic cosine of the single-precision vector value in frs1, then write the result to frd`             |
| `farctanh.vector.s`| `Calculate the inverse hyperbolic tangent of the single-precision vector value in frs1, then write the result to frd`            |
| `fmod.matrix.s`    | `Calculate the modulus of the single-precision matrix values in frs1 and frs2, then write the result to frd`                     |
| `fcbrt.matrix.s`   | `Calculate the cube root of the single-precision matrix value in frs1, then write the result to frd`                             |
| `fpow.matrix.s`    | `Calculate the pow of the single-precision matrix values in frs1 and frs2, then write the result to frd`                         |
| `fexp.matrix.s`    | `Calculate the exp of the single-precision matrix values in frs1 and frs2, then write the result to frd`                         |
| `flog.matrix.s`    | `Calculate the natural logarithm of the single-precision matrix value in frs1, then write the result to frd`                     |
| `flog2.matrix.s`   | `Calculate the logarithm base 2 of the single-precision matrix value in frs1, then write the result to frd`                      |
| `flog10.matrix.s`  | `Calculate the logarithm base 10 of the single-precision matrix value in frs1, then write the result to frd`                     |
| `flog.matrix.s`    | `Calculate the logarithm base of the single-precision matrix values in frs1 and frs2, then write the result to frd`              |
| `fsin.matrix.s`    | `Calculate the sine in radians of the single-precision matrix value in frs1, then write the result to frd`                       |
| `fcos.matrix.s`    | `Calculate the cosine in radians of the single-precision matrix value in frs1, then write the result to frd`                     |
| `ftan.matrix.s`    | `Calculate the tangent in radians of the single-precision matrix value in frs1, then write the result to frd`                    |
| `farcsin.matrix.s` | `Calculate the inverse sine of the single-precision matrix value in frs1, then write the result to frd`                          |
| `farccos.matrix.s` | `Calculate the inverse cosine of the single-precision matrix value in frs1, then write the result to frd`                        |
| `farctan.matrix.s` | `Calculate the inverse tangent of the single-precision matrix value in frs1, then write the result to frd`                       |
| `fsinh.matrix.s`   | `Calculate the hyperbolic sine of the single-precision matrix value in frs1, then write the result to frd`                       |
| `fcosh.matrix.s`   | `Calculate the hyperbolic cosine of the single-precision matrix value in frs1, then write the result to frd`                     |
| `ftanh.matrix.s`   | `Calculate the hyperbolic tangent of the single-precision matrix value in frs1, then write the result to frd`                    |
| `farcsinh.matrix.s`| `Calculate the inverse hyperbolic sine of the single-precision matrix value in frs1, then write the result to frd`               |
| `farccosh.matrix.s`| `Calculate the inverse hyperbolic cosine of the single-precision matrix value in frs1, then write the result to frd`             |
| `farctanh.matrix.s`| `Calculate the inverse hyperbolic tangent of the single-precision matrix value in frs1, then write the result to frd`            |
| `fmod.tensor.s`    | `Calculate the modulus of the single-precision tensor values in frs1 and frs2, then write the result to frd`                     |
| `fcbrt.tensor.s`   | `Calculate the cube root of the single-precision tensor value in frs1, then write the result to frd`                             |
| `fpow.tensor.s`    | `Calculate the pow of the single-precision tensor values in frs1 and frs2, then write the result to frd`                         |
| `fexp.tensor.s`    | `Calculate the exp of the single-precision tensor values in frs1 and frs2, then write the result to frd`                         |
| `flog.tensor.s`    | `Calculate the natural logarithm of the single-precision tensor value in frs1, then write the result to frd`                     |
| `flog2.tensor.s`   | `Calculate the logarithm base 2 of the single-precision tensor value in frs1, then write the result to frd`                      |
| `flog10.tensor.s`  | `Calculate the logarithm base 10 of the single-precision tensor value in frs1, then write the result to frd`                     |
| `flog.tensor.s`    | `Calculate the logarithm base of the single-precision tensor values in frs1 and frs2, then write the result to frd`              |
| `fsin.tensor.s`    | `Calculate the sine in radians of the single-precision tensor value in frs1, then write the result to frd`                       |
| `fcos.tensor.s`    | `Calculate the cosine in radians of the single-precision tensor value in frs1, then write the result to frd`                     |
| `ftan.tensor.s`    | `Calculate the tangent in radians of the single-precision tensor value in frs1, then write the result to frd`                    |
| `farcsin.tensor.s` | `Calculate the inverse sine of the single-precision tensor value in frs1, then write the result to frd`                          |
| `farccos.tensor.s` | `Calculate the inverse cosine of the single-precision tensor value in frs1, then write the result to frd`                        |
| `farctan.tensor.s` | `Calculate the inverse tangent of the single-precision tensor value in frs1, then write the result to frd`                       |
| `fsinh.tensor.s`   | `Calculate the hyperbolic sine of the single-precision tensor value in frs1, then write the result to frd`                       |
| `fcosh.tensor.s`   | `Calculate the hyperbolic cosine of the single-precision tensor value in frs1, then write the result to frd`                     |
| `ftanh.tensor.s`   | `Calculate the hyperbolic tangent of the single-precision tensor value in frs1, then write the result to frd`                    |
| `farcsinh.tensor.s`| `Calculate the inverse hyperbolic sine of the single-precision tensor value in frs1, then write the result to frd`               |
| `farccosh.tensor.s`| `Calculate the inverse hyperbolic cosine of the single-precision tensor value in frs1, then write the result to frd`             |
| `farctanh.tensor.s`| `Calculate the inverse hyperbolic tangent of the single-precision tensor value in frs1, then write the result to frd`            |
: RV32RMATH - "RV32RMATH Expanded Extension for Real Math"

| instruction name   | instruction description                                                                                                          |
|--------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| `fmod.scalar.d`    | `Calculate the modulus of the double-precision scalar values in frs1 and frs2, then write the result to frd`                     |
| `fcbrt.scalar.d`   | `Calculate the cube root of the double-precision scalar value in frs1, then write the result to frd`                             |
| `fpow.scalar.d`    | `Calculate the pow of the double-precision scalar values in frs1 and frs2, then write the result to frd`                         |
| `fexp.scalar.d`    | `Calculate the exp of the double-precision scalar values in frs1 and frs2, then write the result to frd`                         |
| `flog.scalar.d`    | `Calculate the natural logarithm of the double-precision scalar value in frs1, then write the result to frd`                     |
| `flog2.scalar.d`   | `Calculate the logarithm base 2 of the double-precision scalar value in frs1, then write the result to frd`                      |
| `flog10.scalar.d`  | `Calculate the logarithm base 10 of the double-precision scalar value in frs1, then write the result to frd`                     |
| `flog.scalar.d`    | `Calculate the logarithm base of the double-precision scalar values in frs1 and frs2, then write the result to frd`              |
| `fsin.scalar.d`    | `Calculate the sine in radians of the double-precision scalar value in frs1, then write the result to frd`                       |
| `fcos.scalar.d`    | `Calculate the cosine in radians of the double-precision scalar value in frs1, then write the result to frd`                     |
| `ftan.scalar.d`    | `Calculate the tangent in radians of the double-precision scalar value in frs1, then write the result to frd`                    |
| `farcsin.scalar.d` | `Calculate the inverse sine of the double-precision scalar value in frs1, then write the result to frd`                          |
| `farccos.scalar.d` | `Calculate the inverse cosine of the double-precision scalar value in frs1, then write the result to frd`                        |
| `farctan.scalar.d` | `Calculate the inverse tangent of the double-precision scalar value in frs1, then write the result to frd`                       |
| `fsinh.scalar.d`   | `Calculate the hyperbolic sine of the double-precision scalar value in frs1, then write the result to frd`                       |
| `fcosh.scalar.d`   | `Calculate the hyperbolic cosine of the double-precision scalar value in frs1, then write the result to frd`                     |
| `ftanh.scalar.d`   | `Calculate the hyperbolic tangent of the double-precision scalar value in frs1, then write the result to frd`                    |
| `farcsinh.scalar.d`| `Calculate the inverse hyperbolic sine of the double-precision scalar value in frs1, then write the result to frd`               |
| `farccosh.scalar.d`| `Calculate the inverse hyperbolic cosine of the double-precision scalar value in frs1, then write the result to frd`             |
| `farctanh.scalar.d`| `Calculate the inverse hyperbolic tangent of the double-precision scalar value in frs1, then write the result to frd`            |
| `fmod.vector.d`    | `Calculate the modulus of the double-precision vector values in frs1 and frs2, then write the result to frd`                     |
| `fcbrt.vector.d`   | `Calculate the cube root of the double-precision vector value in frs1, then write the result to frd`                             |
| `fpow.vector.d`    | `Calculate the pow of the double-precision vector values in frs1 and frs2, then write the result to frd`                         |
| `fexp.vector.d`    | `Calculate the exp of the double-precision vector values in frs1 and frs2, then write the result to frd`                         |
| `flog.vector.d`    | `Calculate the natural logarithm of the double-precision vector value in frs1, then write the result to frd`                     |
| `flog2.vector.d`   | `Calculate the logarithm base 2 of the double-precision vector value in frs1, then write the result to frd`                      |
| `flog10.vector.d`  | `Calculate the logarithm base 10 of the double-precision vector value in frs1, then write the result to frd`                     |
| `flog.vector.d`    | `Calculate the logarithm base of the double-precision vector values in frs1 and frs2, then write the result to frd`              |
| `fsin.vector.d`    | `Calculate the sine in radians of the double-precision vector value in frs1, then write the result to frd`                       |
| `fcos.vector.d`    | `Calculate the cosine in radians of the double-precision vector value in frs1, then write the result to frd`                     |
| `ftan.vector.d`    | `Calculate the tangent in radians of the double-precision vector value in frs1, then write the result to frd`                    |
| `farcsin.vector.d` | `Calculate the inverse sine of the double-precision vector value in frs1, then write the result to frd`                          |
| `farccos.vector.d` | `Calculate the inverse cosine of the double-precision vector value in frs1, then write the result to frd`                        |
| `farctan.vector.d` | `Calculate the inverse tangent of the double-precision vector value in frs1, then write the result to frd`                       |
| `fsinh.vector.d`   | `Calculate the hyperbolic sine of the double-precision vector value in frs1, then write the result to frd`                       |
| `fcosh.vector.d`   | `Calculate the hyperbolic cosine of the double-precision vector value in frs1, then write the result to frd`                     |
| `ftanh.vector.d`   | `Calculate the hyperbolic tangent of the double-precision vector value in frs1, then write the result to frd`                    |
| `farcsinh.vector.d`| `Calculate the inverse hyperbolic sine of the double-precision vector value in frs1, then write the result to frd`               |
| `farccosh.vector.d`| `Calculate the inverse hyperbolic cosine of the double-precision vector value in frs1, then write the result to frd`             |
| `farctanh.vector.d`| `Calculate the inverse hyperbolic tangent of the double-precision vector value in frs1, then write the result to frd`            |
| `fmod.matrix.d`    | `Calculate the modulus of the double-precision matrix values in frs1 and frs2, then write the result to frd`                     |
| `fcbrt.matrix.d`   | `Calculate the cube root of the double-precision matrix value in frs1, then write the result to frd`                             |
| `fpow.matrix.d`    | `Calculate the pow of the double-precision matrix values in frs1 and frs2, then write the result to frd`                         |
| `fexp.matrix.d`    | `Calculate the exp of the double-precision matrix values in frs1 and frs2, then write the result to frd`                         |
| `flog.matrix.d`    | `Calculate the natural logarithm of the double-precision matrix value in frs1, then write the result to frd`                     |
| `flog2.matrix.d`   | `Calculate the logarithm base 2 of the double-precision matrix value in frs1, then write the result to frd`                      |
| `flog10.matrix.d`  | `Calculate the logarithm base 10 of the double-precision matrix value in frs1, then write the result to frd`                     |
| `flog.matrix.d`    | `Calculate the logarithm base of the double-precision matrix values in frs1 and frs2, then write the result to frd`              |
| `fsin.matrix.d`    | `Calculate the sine in radians of the double-precision matrix value in frs1, then write the result to frd`                       |
| `fcos.matrix.d`    | `Calculate the cosine in radians of the double-precision matrix value in frs1, then write the result to frd`                     |
| `ftan.matrix.d`    | `Calculate the tangent in radians of the double-precision matrix value in frs1, then write the result to frd`                    |
| `farcsin.matrix.d` | `Calculate the inverse sine of the double-precision matrix value in frs1, then write the result to frd`                          |
| `farccos.matrix.d` | `Calculate the inverse cosine of the double-precision matrix value in frs1, then write the result to frd`                        |
| `farctan.matrix.d` | `Calculate the inverse tangent of the double-precision matrix value in frs1, then write the result to frd`                       |
| `fsinh.matrix.d`   | `Calculate the hyperbolic sine of the double-precision matrix value in frs1, then write the result to frd`                       |
| `fcosh.matrix.d`   | `Calculate the hyperbolic cosine of the double-precision matrix value in frs1, then write the result to frd`                     |
| `ftanh.matrix.d`   | `Calculate the hyperbolic tangent of the double-precision matrix value in frs1, then write the result to frd`                    |
| `farcsinh.matrix.d`| `Calculate the inverse hyperbolic sine of the double-precision matrix value in frs1, then write the result to frd`               |
| `farccosh.matrix.d`| `Calculate the inverse hyperbolic cosine of the double-precision matrix value in frs1, then write the result to frd`             |
| `farctanh.matrix.d`| `Calculate the inverse hyperbolic tangent of the double-precision matrix value in frs1, then write the result to frd`            |
| `fmod.tensor.d`    | `Calculate the modulus of the double-precision tensor values in frs1 and frs2, then write the result to frd`                     |
| `fcbrt.tensor.d`   | `Calculate the cube root of the double-precision tensor value in frs1, then write the result to frd`                             |
| `fpow.tensor.d`    | `Calculate the pow of the double-precision tensor values in frs1 and frs2, then write the result to frd`                         |
| `fexp.tensor.d`    | `Calculate the exp of the double-precision tensor values in frs1 and frs2, then write the result to frd`                         |
| `flog.tensor.d`    | `Calculate the natural logarithm of the double-precision tensor value in frs1, then write the result to frd`                     |
| `flog2.tensor.d`   | `Calculate the logarithm base 2 of the double-precision tensor value in frs1, then write the result to frd`                      |
| `flog10.tensor.d`  | `Calculate the logarithm base 10 of the double-precision tensor value in frs1, then write the result to frd`                     |
| `flog.tensor.d`    | `Calculate the logarithm base of the double-precision tensor values in frs1 and frs2, then write the result to frd`              |
| `fsin.tensor.d`    | `Calculate the sine in radians of the double-precision tensor value in frs1, then write the result to frd`                       |
| `fcos.tensor.d`    | `Calculate the cosine in radians of the double-precision tensor value in frs1, then write the result to frd`                     |
| `ftan.tensor.d`    | `Calculate the tangent in radians of the double-precision tensor value in frs1, then write the result to frd`                    |
| `farcsin.tensor.d` | `Calculate the inverse sine of the double-precision tensor value in frs1, then write the result to frd`                          |
| `farccos.tensor.d` | `Calculate the inverse cosine of the double-precision tensor value in frs1, then write the result to frd`                        |
| `farctan.tensor.d` | `Calculate the inverse tangent of the double-precision tensor value in frs1, then write the result to frd`                       |
| `fsinh.tensor.d`   | `Calculate the hyperbolic sine of the double-precision tensor value in frs1, then write the result to frd`                       |
| `fcosh.tensor.d`   | `Calculate the hyperbolic cosine of the double-precision tensor value in frs1, then write the result to frd`                     |
| `ftanh.tensor.d`   | `Calculate the hyperbolic tangent of the double-precision tensor value in frs1, then write the result to frd`                    |
| `farcsinh.tensor.d`| `Calculate the inverse hyperbolic sine of the double-precision tensor value in frs1, then write the result to frd`               |
| `farccosh.tensor.d`| `Calculate the inverse hyperbolic cosine of the double-precision tensor value in frs1, then write the result to frd`             |
| `farctanh.tensor.d`| `Calculate the inverse hyperbolic tangent of the double-precision tensor value in frs1, then write the result to frd`            |
: RV64RMATH - "RV64RMATH Expanded Extension for Real Math (+ RV32RMATH)"

| instruction name   | instruction description                                                                                                          |
|--------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| `fmod.scalar.q`    | `Calculate the modulus of the quadruple-precision scalar values in frs1 and frs2, then write the result to frd`                  |
| `fcbrt.scalar.q`   | `Calculate the cube root of the quadruple-precision scalar value in frs1, then write the result to frd`                          |
| `fpow.scalar.q`    | `Calculate the pow of the quadruple-precision scalar values in frs1 and frs2, then write the result to frd`                      |
| `fexp.scalar.q`    | `Calculate the exp of the quadruple-precision scalar values in frs1 and frs2, then write the result to frd`                      |
| `flog.scalar.q`    | `Calculate the natural logarithm of the quadruple-precision scalar value in frs1, then write the result to frd`                  |
| `flog2.scalar.q`   | `Calculate the logarithm base 2 of the quadruple-precision scalar value in frs1, then write the result to frd`                   |
| `flog10.scalar.q`  | `Calculate the logarithm base 10 of the quadruple-precision scalar value in frs1, then write the result to frd`                  |
| `flog.scalar.q`    | `Calculate the logarithm base of the quadruple-precision scalar values in frs1 and frs2, then write the result to frd`           |
| `fsin.scalar.q`    | `Calculate the sine in radians of the quadruple-precision scalar value in frs1, then write the result to frd`                    |
| `fcos.scalar.q`    | `Calculate the cosine in radians of the quadruple-precision scalar value in frs1, then write the result to frd`                  |
| `ftan.scalar.q`    | `Calculate the tangent in radians of the quadruple-precision scalar value in frs1, then write the result to frd`                 |
| `farcsin.scalar.q` | `Calculate the inverse sine of the quadruple-precision scalar value in frs1, then write the result to frd`                       |
| `farccos.scalar.q` | `Calculate the inverse cosine of the quadruple-precision scalar value in frs1, then write the result to frd`                     |
| `farctan.scalar.q` | `Calculate the inverse tangent of the quadruple-precision scalar value in frs1, then write the result to frd`                    |
| `fsinh.scalar.q`   | `Calculate the hyperbolic sine of the quadruple-precision scalar value in frs1, then write the result to frd`                    |
| `fcosh.scalar.q`   | `Calculate the hyperbolic cosine of the quadruple-precision scalar value in frs1, then write the result to frd`                  |
| `ftanh.scalar.q`   | `Calculate the hyperbolic tangent of the quadruple-precision scalar value in frs1, then write the result to frd`                 |
| `farcsinh.scalar.q`| `Calculate the inverse hyperbolic sine of the quadruple-precision scalar value in frs1, then write the result to frd`            |
| `farccosh.scalar.q`| `Calculate the inverse hyperbolic cosine of the quadruple-precision scalar value in frs1, then write the result to frd`          |
| `farctanh.scalar.q`| `Calculate the inverse hyperbolic tangent of the quadruple-precision scalar value in frs1, then write the result to frd`         |
| `fmod.vector.q`    | `Calculate the modulus of the quadruple-precision vector values in frs1 and frs2, then write the result to frd`                  |
| `fcbrt.vector.q`   | `Calculate the cube root of the quadruple-precision vector value in frs1, then write the result to frd`                          |
| `fpow.vector.q`    | `Calculate the pow of the quadruple-precision vector values in frs1 and frs2, then write the result to frd`                      |
| `fexp.vector.q`    | `Calculate the exp of the quadruple-precision vector values in frs1 and frs2, then write the result to frd`                      |
| `flog.vector.q`    | `Calculate the natural logarithm of the quadruple-precision vector value in frs1, then write the result to frd`                  |
| `flog2.vector.q`   | `Calculate the logarithm base 2 of the quadruple-precision vector value in frs1, then write the result to frd`                   |
| `flog10.vector.q`  | `Calculate the logarithm base 10 of the quadruple-precision vector value in frs1, then write the result to frd`                  |
| `flog.vector.q`    | `Calculate the logarithm base of the quadruple-precision vector values in frs1 and frs2, then write the result to frd`           |
| `fsin.vector.q`    | `Calculate the sine in radians of the quadruple-precision vector value in frs1, then write the result to frd`                    |
| `fcos.vector.q`    | `Calculate the cosine in radians of the quadruple-precision vector value in frs1, then write the result to frd`                  |
| `ftan.vector.q`    | `Calculate the tangent in radians of the quadruple-precision vector value in frs1, then write the result to frd`                 |
| `farcsin.vector.q` | `Calculate the inverse sine of the quadruple-precision vector value in frs1, then write the result to frd`                       |
| `farccos.vector.q` | `Calculate the inverse cosine of the quadruple-precision vector value in frs1, then write the result to frd`                     |
| `farctan.vector.q` | `Calculate the inverse tangent of the quadruple-precision vector value in frs1, then write the result to frd`                    |
| `fsinh.vector.q`   | `Calculate the hyperbolic sine of the quadruple-precision vector value in frs1, then write the result to frd`                    |
| `fcosh.vector.q`   | `Calculate the hyperbolic cosine of the quadruple-precision vector value in frs1, then write the result to frd`                  |
| `ftanh.vector.q`   | `Calculate the hyperbolic tangent of the quadruple-precision vector value in frs1, then write the result to frd`                 |
| `farcsinh.vector.q`| `Calculate the inverse hyperbolic sine of the quadruple-precision vector value in frs1, then write the result to frd`            |
| `farccosh.vector.q`| `Calculate the inverse hyperbolic cosine of the quadruple-precision vector value in frs1, then write the result to frd`          |
| `farctanh.vector.q`| `Calculate the inverse hyperbolic tangent of the quadruple-precision vector value in frs1, then write the result to frd`         |
| `fmod.matrix.q`    | `Calculate the modulus of the quadruple-precision matrix values in frs1 and frs2, then write the result to frd`                  |
| `fcbrt.matrix.q`   | `Calculate the cube root of the quadruple-precision matrix value in frs1, then write the result to frd`                          |
| `fpow.matrix.q`    | `Calculate the pow of the quadruple-precision matrix values in frs1 and frs2, then write the result to frd`                      |
| `fexp.matrix.q`    | `Calculate the exp of the quadruple-precision matrix values in frs1 and frs2, then write the result to frd`                      |
| `flog.matrix.q`    | `Calculate the natural logarithm of the quadruple-precision matrix value in frs1, then write the result to frd`                  |
| `flog2.matrix.q`   | `Calculate the logarithm base 2 of the quadruple-precision matrix value in frs1, then write the result to frd`                   |
| `flog10.matrix.q`  | `Calculate the logarithm base 10 of the quadruple-precision matrix value in frs1, then write the result to frd`                  |
| `flog.matrix.q`    | `Calculate the logarithm base of the quadruple-precision matrix values in frs1 and frs2, then write the result to frd`           |
| `fsin.matrix.q`    | `Calculate the sine in radians of the quadruple-precision matrix value in frs1, then write the result to frd`                    |
| `fcos.matrix.q`    | `Calculate the cosine in radians of the quadruple-precision matrix value in frs1, then write the result to frd`                  |
| `ftan.matrix.q`    | `Calculate the tangent in radians of the quadruple-precision matrix value in frs1, then write the result to frd`                 |
| `farcsin.matrix.q` | `Calculate the inverse sine of the quadruple-precision matrix value in frs1, then write the result to frd`                       |
| `farccos.matrix.q` | `Calculate the inverse cosine of the quadruple-precision matrix value in frs1, then write the result to frd`                     |
| `farctan.matrix.q` | `Calculate the inverse tangent of the quadruple-precision matrix value in frs1, then write the result to frd`                    |
| `fsinh.matrix.q`   | `Calculate the hyperbolic sine of the quadruple-precision matrix value in frs1, then write the result to frd`                    |
| `fcosh.matrix.q`   | `Calculate the hyperbolic cosine of the quadruple-precision matrix value in frs1, then write the result to frd`                  |
| `ftanh.matrix.q`   | `Calculate the hyperbolic tangent of the quadruple-precision matrix value in frs1, then write the result to frd`                 |
| `farcsinh.matrix.q`| `Calculate the inverse hyperbolic sine of the quadruple-precision matrix value in frs1, then write the result to frd`            |
| `farccosh.matrix.q`| `Calculate the inverse hyperbolic cosine of the quadruple-precision matrix value in frs1, then write the result to frd`          |
| `farctanh.matrix.q`| `Calculate the inverse hyperbolic tangent of the quadruple-precision matrix value in frs1, then write the result to frd`         |
| `fmod.tensor.q`    | `Calculate the modulus of the quadruple-precision tensor values in frs1 and frs2, then write the result to frd`                  |
| `fcbrt.tensor.q`   | `Calculate the cube root of the quadruple-precision tensor value in frs1, then write the result to frd`                          |
| `fpow.tensor.q`    | `Calculate the pow of the quadruple-precision tensor values in frs1 and frs2, then write the result to frd`                      |
| `fexp.tensor.q`    | `Calculate the exp of the quadruple-precision tensor values in frs1 and frs2, then write the result to frd`                      |
| `flog.tensor.q`    | `Calculate the natural logarithm of the quadruple-precision tensor value in frs1, then write the result to frd`                  |
| `flog2.tensor.q`   | `Calculate the logarithm base 2 of the quadruple-precision tensor value in frs1, then write the result to frd`                   |
| `flog10.tensor.q`  | `Calculate the logarithm base 10 of the quadruple-precision tensor value in frs1, then write the result to frd`                  |
| `flog.tensor.q`    | `Calculate the logarithm base of the quadruple-precision tensor values in frs1 and frs2, then write the result to frd`           |
| `fsin.tensor.q`    | `Calculate the sine in radians of the quadruple-precision tensor value in frs1, then write the result to frd`                    |
| `fcos.tensor.q`    | `Calculate the cosine in radians of the quadruple-precision tensor value in frs1, then write the result to frd`                  |
| `ftan.tensor.q`    | `Calculate the tangent in radians of the quadruple-precision tensor value in frs1, then write the result to frd`                 |
| `farcsin.tensor.q` | `Calculate the inverse sine of the quadruple-precision tensor value in frs1, then write the result to frd`                       |
| `farccos.tensor.q` | `Calculate the inverse cosine of the quadruple-precision tensor value in frs1, then write the result to frd`                     |
| `farctan.tensor.q` | `Calculate the inverse tangent of the quadruple-precision tensor value in frs1, then write the result to frd`                    |
| `fsinh.tensor.q`   | `Calculate the hyperbolic sine of the quadruple-precision tensor value in frs1, then write the result to frd`                    |
| `fcosh.tensor.q`   | `Calculate the hyperbolic cosine of the quadruple-precision tensor value in frs1, then write the result to frd`                  |
| `ftanh.tensor.q`   | `Calculate the hyperbolic tangent of the quadruple-precision tensor value in frs1, then write the result to frd`                 |
| `farcsinh.tensor.q`| `Calculate the inverse hyperbolic sine of the quadruple-precision tensor value in frs1, then write the result to frd`            |
| `farccosh.tensor.q`| `Calculate the inverse hyperbolic cosine of the quadruple-precision tensor value in frs1, then write the result to frd`          |
| `farctanh.tensor.q`| `Calculate the inverse hyperbolic tangent of the quadruple-precision tensor value in frs1, then write the result to frd`         |
: RV128RMATH - "RV128MATH Expanded Extension for Quadruple-Precision Real Math (+ RV64RMATH)"

| instruction name   | instruction description                                                                                                          |
|--------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| `rconv.vector.w`   | `Calculate the convolution of the single-precision vector value in frs1, then write the result to frd`                           |
| `rinv.vector.w`    | `Calculate the inversion of the single-precision vector value in frs1, then write the result to frd`                             |
| `rmult.vector.w`   | `Calculate the multiplication of the single-precision vector value in frs1, then write the result to frd`                        |
| `rprod.vector.w`   | `Calculate the product of the single-precision vector value in frs1, then write the result to frd`                               |
| `rsum.vector.w`    | `Calculate the summation of the single-precision vector value in frs1, then write the result to frd`                             |
| `rtrans.vector.w`  | `Calculate the transpose of the single-precision vector value in frs1, then write the result to frd`                             |
| `rdiff.vector.w`   | `Calculate the differentiation of the single-precision vector value in frs1, then write the result to frd`                       |
| `rint.vector.w`    | `Calculate the integration of the single-precision vector value in frs1, then write the result to frd`                           |
| `rconv.matrix.w`   | `Calculate the convolution of the single-precision matrix value in frs1, then write the result to frd`                           |
| `rinv.matrix.w`    | `Calculate the inversion of the single-precision matrix value in frs1, then write the result to frd`                             |
| `rmult.matrix.w`   | `Calculate the multiplication of the single-precision matrix value in frs1, then write the result to frd`                        |
| `rprod.matrix.w`   | `Calculate the product of the single-precision matrix value in frs1, then write the result to frd`                               |
| `rsum.matrix.w`    | `Calculate the summation of the single-precision matrix value in frs1, then write the result to frd`                             |
| `rtrans.matrix.w`  | `Calculate the transpose of the single-precision matrix value in frs1, then write the result to frd`                             |
| `rdiff.matrix.w`   | `Calculate the differentiation of the single-precision matrix value in frs1, then write the result to frd`                       |
| `rint.matrix.w`    | `Calculate the integration of the single-precision matrix value in frs1, then write the result to frd`                           |
| `rconv.tensor.w`   | `Calculate the convolution of the single-precision tensor value in frs1, then write the result to frd`                           |
| `rinv.tensor.w`    | `Calculate the inversion of the single-precision tensor value in frs1, then write the result to frd`                             |
| `rmult.tensor.w`   | `Calculate the multiplication of the single-precision tensor value in frs1, then write the result to frd`                        |
| `rprod.tensor.w`   | `Calculate the product of the single-precision tensor value in frs1, then write the result to frd`                               |
| `rsum.tensor.w`    | `Calculate the summation of the single-precision tensor value in frs1, then write the result to frd`                             |
| `rtrans.tensor.w`  | `Calculate the transpose of the single-precision tensor value in frs1, then write the result to frd`                             |
| `rdiff.tensor.w`   | `Calculate the differentiation of the single-precision tensor value in frs1, then write the result to frd`                       |
| `rint.tensor.w`    | `Calculate the integration of the single-precision tensor value in frs1, then write the result to frd`                           |
: RV32RALG - "RV32RALG Expanded Extension for Real Linear Algebra"

| instruction name   | instruction description                                                                                                          |
|--------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| `rconv.vector.d`   | `Calculate the convolution of the double-precision vector value in frs1, then write the result to frd`                           |
| `rinv.vector.d`    | `Calculate the inversion of the double-precision vector value in frs1, then write the result to frd`                             |
| `rmult.vector.d`   | `Calculate the multiplication of the double-precision vector value in frs1, then write the result to frd`                        |
| `rprod.vector.d`   | `Calculate the product of the double-precision vector value in frs1, then write the result to frd`                               |
| `rsum.vector.d`    | `Calculate the summation of the double-precision vector value in frs1, then write the result to frd`                             |
| `rtrans.vector.d`  | `Calculate the transpose of the double-precision vector value in frs1, then write the result to frd`                             |
| `rdiff.vector.d`   | `Calculate the differentiation of the double-precision vector value in frs1, then write the result to frd`                       |
| `rint.vector.d`    | `Calculate the integration of the double-precision vector value in frs1, then write the result to frd`                           |
| `rconv.matrix.d`   | `Calculate the convolution of the double-precision matrix value in frs1, then write the result to frd`                           |
| `rinv.matrix.d`    | `Calculate the inversion of the double-precision matrix value in frs1, then write the result to frd`                             |
| `rmult.matrix.d`   | `Calculate the multiplication of the double-precision matrix value in frs1, then write the result to frd`                        |
| `rprod.matrix.d`   | `Calculate the product of the double-precision matrix value in frs1, then write the result to frd`                               |
| `rsum.matrix.d`    | `Calculate the summation of the double-precision matrix value in frs1, then write the result to frd`                             |
| `rtrans.matrix.d`  | `Calculate the transpose of the double-precision matrix value in frs1, then write the result to frd`                             |
| `rdiff.matrix.d`   | `Calculate the differentiation of the double-precision matrix value in frs1, then write the result to frd`                       |
| `rint.matrix.d`    | `Calculate the integration of the double-precision matrix value in frs1, then write the result to frd`                           |
| `rconv.tensor.d`   | `Calculate the convolution of the double-precision tensor value in frs1, then write the result to frd`                           |
| `rinv.tensor.d`    | `Calculate the inversion of the double-precision tensor value in frs1, then write the result to frd`                             |
| `rmult.tensor.d`   | `Calculate the multiplication of the double-precision tensor value in frs1, then write the result to frd`                        |
| `rprod.tensor.d`   | `Calculate the product of the double-precision tensor value in frs1, then write the result to frd`                               |
| `rsum.tensor.d`    | `Calculate the summation of the double-precision tensor value in frs1, then write the result to frd`                             |
| `rtrans.tensor.d`  | `Calculate the transpose of the double-precision tensor value in frs1, then write the result to frd`                             |
| `rdiff.tensor.d`   | `Calculate the differentiation of the double-precision tensor value in frs1, then write the result to frd`                       |
| `rint.tensor.d`    | `Calculate the integration of the double-precision tensor value in frs1, then write the result to frd`                           |
: RV64RALG - "RV64RALG Expanded Extension for Real Linear Algebra (+ RV32RALG)"

| instruction name   | instruction description                                                                                                          |
|--------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| `rconv.vector.q`   | `Calculate the convolution of the quadruple-precision vector value in frs1, then write the result to frd`                        |
| `rinv.vector.q`    | `Calculate the inversion of the quadruple-precision vector value in frs1, then write the result to frd`                          |
| `rmult.vector.q`   | `Calculate the multiplication of the quadruple-precision vector value in frs1, then write the result to frd`                     |
| `rprod.vector.q`   | `Calculate the product of the quadruple-precision vector value in frs1, then write the result to frd`                            |
| `rsum.vector.q`    | `Calculate the summation of the quadruple-precision vector value in frs1, then write the result to frd`                          |
| `rtrans.vector.q`  | `Calculate the transpose of the quadruple-precision vector value in frs1, then write the result to frd`                          |
| `rdiff.vector.q`   | `Calculate the differentiation of the quadruple-precision vector value in frs1, then write the result to frd`                    |
| `rint.vector.q`    | `Calculate the integration of the quadruple-precision vector value in frs1, then write the result to frd`                        |
| `rconv.matrix.q`   | `Calculate the convolution of the quadruple-precision matrix value in frs1, then write the result to frd`                        |
| `rinv.matrix.q`    | `Calculate the inversion of the quadruple-precision matrix value in frs1, then write the result to frd`                          |
| `rmult.matrix.q`   | `Calculate the multiplication of the quadruple-precision matrix value in frs1, then write the result to frd`                     |
| `rprod.matrix.q`   | `Calculate the product of the quadruple-precision matrix value in frs1, then write the result to frd`                            |
| `rsum.matrix.q`    | `Calculate the summation of the quadruple-precision matrix value in frs1, then write the result to frd`                          |
| `rtrans.matrix.q`  | `Calculate the transpose of the quadruple-precision matrix value in frs1, then write the result to frd`                          |
| `rdiff.matrix.q`   | `Calculate the differentiation of the quadruple-precision matrix value in frs1, then write the result to frd`                    |
| `rint.matrix.q`    | `Calculate the integration of the quadruple-precision matrix value in frs1, then write the result to frd`                        |
| `rconv.tensor.q`   | `Calculate the convolution of the quadruple-precision tensor value in frs1, then write the result to frd`                        |
| `rinv.tensor.q`    | `Calculate the inversion of the quadruple-precision tensor value in frs1, then write the result to frd`                          |
| `rmult.tensor.q`   | `Calculate the multiplication of the quadruple-precision tensor value in frs1, then write the result to frd`                     |
| `rprod.tensor.q`   | `Calculate the product of the quadruple-precision tensor value in frs1, then write the result to frd`                            |
| `rsum.tensor.q`    | `Calculate the summation of the quadruple-precision tensor value in frs1, then write the result to frd`                          |
| `rtrans.tensor.q`  | `Calculate the transpose of the quadruple-precision tensor value in frs1, then write the result to frd`                          |
| `rdiff.tensor.q`   | `Calculate the differentiation of the quadruple-precision tensor value in frs1, then write the result to frd`                    |
| `rint.tensor.q`    | `Calculate the integration of the quadruple-precision tensor value in frs1, then write the result to frd`                        |
: RV128RALG - "RV128RALG Expanded Extension for Real Linear Algebra (+ RV64RALG)"

| instruction name   | instruction description                                                                                                          |
|--------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| `pnn.w`            | `Real Perceptron Neural Network`                                                                                                 |
| `cnn.w`            | `Real Convolutional Neural Network`                                                                                              |
| `fnn.w`            | `Real Feed-Forward Neural Network`                                                                                               |
| `lstm.w`           | `Real Long-Short Term Memory Neural Network`                                                                                     |
| `ann.w`            | `Real Attention Neural Network`                                                                                                  |
| `dnc.w`            | `Real Differentiable Neural Computer`                                                                                            |
: RV32RNN - "RV32RNN Expanded Extension for Real Neural Network"

| instruction name   | instruction description                                                                                                          |
|--------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| `pnn.d`            | `Real Perceptron Neural Network`                                                                                                 |
| `cnn.d`            | `Real Convolutional Neural Network`                                                                                              |
| `fnn.d`            | `Real Feed-Forward Neural Network`                                                                                               |
| `lstm.d`           | `Real Long-Short Term Memory Neural Network`                                                                                     |
| `ann.d`            | `Real Attention Neural Network`                                                                                                  |
| `dnc.d`            | `Real Differentiable Neural Computer`                                                                                            |
: RV64RNN - "RV64RNN Expanded Extension for Real Neural Network (+ RV32RNN)"

| instruction name   | instruction description                                                                                                          |
|--------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| `pnn.q`            | `Real Perceptron Neural Network`                                                                                                 |
| `cnn.q`            | `Real Convolutional Neural Network`                                                                                              |
| `fnn.q`            | `Real Feed-Forward Neural Network`                                                                                               |
| `lstm.q`           | `Real Long-Short Term Memory Neural Network`                                                                                     |
| `ann.q`            | `Real Attention Neural Network`                                                                                                  |
| `dnc.q`            | `Real Differentiable Neural Computer`                                                                                            |
: RV128RNN - "RV128RNN Expanded Extension for Real Neural Network (+ RV64RNN)"

| instruction name   | instruction description                                                                                                          |
|--------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| `nop`              | `No operation`                                                                                                                   |
| `#li`              | `Load immediate`                                                                                                                 |
| `mv`               | `Copy register`                                                                                                                  |
| `not`              | `One’s complement`                                                                                                               |
| `neg`              | `Two’s complement`                                                                                                               |
| `negw`             | `Two’s complement Word`                                                                                                          |
| `sext.w`           | `Sign extend Word`                                                                                                               |
| `seqz`             | `Set if = zero`                                                                                                                  |
| `snez`             | `Set if != zero`                                                                                                                 |
| `sltz`             | `Set if < zero`                                                                                                                  |
| `sgtz`             | `Set if > zero`                                                                                                                  |
| `fmv.s`            | `Single-precision move`                                                                                                          |
| `fabs.s`           | `Single-precision absolute value`                                                                                                |
| `fneg.s`           | `Single-precision negate`                                                                                                        |
| `fmv.d`            | `Double-precision move`                                                                                                          |
| `fabs.d`           | `Double-precision absolute value`                                                                                                |
| `fneg.d`           | `Double-precision negate`                                                                                                        |
| `fmv.q`            | `Quadruple-precision move`                                                                                                       |
| `fabs.q`           | `Quadruple-precision absolute value`                                                                                             |
| `fneg.q`           | `Quadruple-precision negate`                                                                                                     |
| `beqz`             | `Branch if = zero`                                                                                                               |
| `bnez`             | `Branch if != zero`                                                                                                              |
| `blez`             | `Branch if <= zero`                                                                                                              |
| `bgez`             | `Branch if >= zero`                                                                                                              |
| `bltz`             | `Branch if < zero`                                                                                                               |
| `bgtz`             | `Branch if > zero`                                                                                                               |
| `j`                | `Jump`                                                                                                                           |
| `jr`               | `Jump register`                                                                                                                  |
| `ret`              | `Return from subroutine`                                                                                                         |
: Pseudo Instructions
