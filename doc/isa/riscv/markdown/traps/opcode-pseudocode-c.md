## INSTRUCTION PSEUDO CODE (C)

Pseudo Code in C-like syntax provides a high-level representation of RISC-V instructions, illustrating their behavior and operational flow without delving into specific machine-level details. This abstraction aids in software development, algorithm design, and understanding of instruction semantics across different implementations and extensions of the RISC-V ISA.

Format of a line in the table:

`<instruction name> "<instruction pseudo code>"`

| instruction  | instruction pseudo code                                                                                     |                                     |
|--------------|:------------------------------------------------------------------------------------------------------------|:------------------------------------|
| `lui`        | `rd = imm`                                                                                                  |                                     |
| `auipc`      | `rd = pc + imm`                                                                                             |                                     |
| `jal`        | `rd = pc + length(inst); pc_offset = imm`                                                                   |                                     |
| `jalr`       | `ux new_offset = (rs1 + imm - pc) & ~1; rd = pc + length(inst); pc_offset = new_offset`                     |                                     |
| `beq`        | `if (sx(rs1) == sx(rs2)) pc_offset = imm`                                                                   |                                     |
| `bne`        | `if (sx(rs1) != sx(rs2)) pc_offset = imm`                                                                   |                                     |
| `blt`        | `if (sx(rs1) < sx(rs2)) pc_offset = imm`                                                                    |                                     |
| `bge`        | `if (sx(rs1) >= sx(rs2)) pc_offset = imm`                                                                   |                                     |
| `bltu`       | `if (ux(rs1) < ux(rs2)) pc_offset = imm`                                                                    |                                     |
| `bgeu`       | `if (ux(rs1) >= ux(rs2)) pc_offset = imm`                                                                   |                                     |
| `lb`         | `s8 t; mmu.load<s8>(rs1 + imm, t); rd = t`                                                                  | `rd = sx(*(s8*)ptr(rs1 + imm))`     |
| `lh`         | `s16 t; mmu.load<s16>(rs1 + imm, t); rd = t`                                                                | `rd = sx(*(s16*)ptr(rs1 + imm))`    |
| `lw`         | `s32 t; mmu.load<s32>(rs1 + imm, t); rd = t`                                                                | `rd = sx(*(s32*)ptr(rs1 + imm))`    |
| `lbu`        | `u8 t; mmu.load<u8>(rs1 + imm, t); rd = t`                                                                  | `rd = ux(*(u8*)ptr(rs1 + imm))`     |
| `lhu`        | `u16 t; mmu.load<u16>(rs1 + imm, t); rd = t`                                                                | `rd = ux(*(u16*)ptr(rs1 + imm))`    |
| `lwu`        | `u32 t; mmu.load<u32>(rs1 + imm, t); rd = t`                                                                | `rd = ux(*(u32*)ptr(rs1 + imm))`    |
| `sb`         | `mmu.store<s8>(rs1 + imm, s8(rs2))`                                                                         | `*((u8*)ptr(rs1 + imm)) = rs2`      |
| `sh`         | `mmu.store<s16>(rs1 + imm, s16(rs2))`                                                                       | `*((u16*)ptr(rs1 + imm)) = rs2`     |
| `sw`         | `mmu.store<s32>(rs1 + imm, s32(rs2))`                                                                       | `*((u32*)ptr(rs1 + imm)) = rs2`     |
| `addi`       | `rd = sx(rs1) + sx(imm)`                                                                                    |                                     |
| `slti`       | `rd = sx(rs1) < sx(imm)`                                                                                    |                                     |
| `sltiu`      | `rd = ux(rs1) < ux(imm)`                                                                                    |                                     |
| `xori`       | `rd = ux(rs1) ^ ux(imm)`                                                                                    |                                     |
| `ori`        | `rd = ux(rs1) \| ux(imm)`                                                                                   |                                     |
| `andi`       | `rd = ux(rs1) & ux(imm)`                                                                                    |                                     |
| `slli`       | `rd = ux(rs1) << imm`                                                                                       |                                     |
| `srli`       | `rd = ux(rs1) >> imm`                                                                                       |                                     |
| `srai`       | `rd = sx(rs1) >> imm`                                                                                       |                                     |
| `add`        | `rd = sx(rs1) + sx(rs2)`                                                                                    |                                     |
| `sub`        | `rd = sx(rs1) - sx(rs2)`                                                                                    |                                     |
| `sll`        | `rd = ux(rs1) << (rs2 & 0b1111111)`                                                                         | `7-bit mask for RV128I`             |
| `slt`        | `rd = sx(rs1) < sx(rs2)`                                                                                    |                                     |
| `sltu`       | `rd = ux(rs1) < ux(rs2)`                                                                                    |                                     |
| `xor`        | `rd = ux(rs1) ^ ux(rs2)`                                                                                    |                                     |
| `srl`        | `rd = ux(rs1) >> (rs2 & 0b1111111)`                                                                         | `7-bit mask for RV128I`             |
| `sra`        | `rd = sx(rs1) >> (rs2 & 0b1111111)`                                                                         | `7-bit mask for RV128I`             |
| `or`         | `rd = ux(rs1) \| ux(rs2)`                                                                                   |                                     |
| `and`        | `rd = ux(rs1) & ux(rs2)`                                                                                    |                                     |
| `fence`      |                                                                                                             |                                     |
| `fence.i`    |                                                                                                             |                                     |

:RV32I - "RV32I Base Integer Instruction Set"

| instruction  | instruction pseudo code                                                                                     |                                     |
|--------------|:------------------------------------------------------------------------------------------------------------|:------------------------------------|
| `ld`         | `s64 t; mmu.load<s64>(rs1 + imm, t); rd = t`                                                                | `rd = sx(*(s64*)ptr(rs1 + imm))`    |
| `sd`         | `mmu.store<s64>(rs1 + imm, s64(rs2))`                                                                       | `*(u64*)ptr(rs1 + imm) = rs2`       |
| `addiw`      | `rd = s32(s32(rs1) + imm)`                                                                                  | `clang requires -fwrapv`            |
| `slliw`      | `rd = s32(u32(rs1) << imm)`                                                                                 |                                     |
| `srliw`      | `rd = s32(u32(rs1) >> imm)`                                                                                 |                                     |
| `sraiw`      | `rd = s32(rs1) >> imm`                                                                                      |                                     |
| `addw`       | `rd = s32(s32(rs1) + s32(rs2))`                                                                             | `clang requires -fwrapv`            |
| `subw`       | `rd = s32(s32(rs1) - s32(rs2))`                                                                             | `clang requires -fwrapv`            |
| `sllw`       | `rd = s32(u32(rs1) << (rs2 & 0b11111))`                                                                     |                                     |
| `srlw`       | `rd = s32(u32(rs1) >> (rs2 & 0b11111))`                                                                     |                                     |
| `sraw`       | `rd = s32(s32(rs1) >> (rs2 & 0b11111))`                                                                     |                                     |

:RV64I - "RV64I Base Integer Instruction Set (+ RV32I)"

| instruction  | instruction pseudo code                                                                                     |                                     |
|--------------|:------------------------------------------------------------------------------------------------------------|:------------------------------------|
| `mul`        | `rd = sx(rs1) * sx(rs2)`                                                                                    |                                     |
| `mulh`       | `rd = riscv::mulh(sx(rs1), sx(rs2))`                                                                        |                                     |
| `mulhsu`     | `rd = riscv::mulhsu(sx(rs1), ux(rs2))`                                                                      |                                     |
| `mulhu`      | `rd = riscv::mulhu(ux(rs1), ux(rs2))`                                                                       |                                     |
| `div`        | `rd = sx(rs1) == sx(INT_MIN) && sx(rs2) == -1 ? sx(INT_MIN) : sx(rs2) == 0 ? -1 : sx(rs1) / sx(rs2)`        |                                     |
| `divu`       | `rd = sx(rs2) == 0 ? -1 : sx(ux(rs1) / ux(rs2))`                                                            |                                     |
| `rem`        | `rd = sx(rs1) == sx(INT_MIN) && sx(rs2) == -1 ? 0 : sx(rs2) == 0 ? sx(rs1) : sx(rs1) % sx(rs2)`             |                                     |
| `remu`       | `rd = sx(rs2) == 0 ? sx(rs1) : sx(ux(rs1) % ux(rs2))`                                                       |                                     |

:RV32M - "RV32M Standard Extension for Integer Multiply and Divide"

| instruction  | instruction pseudo code                                                                                     |                                     |
|--------------|:------------------------------------------------------------------------------------------------------------|:------------------------------------|
| `mulw`       | `rd = s32(u32(rs1) * u32(rs2))`                                                                             |                                     |
| `divw`       | `rd = s32(rs1) == s32(INT_MIN) && s32(rs2) == -1 ? s32(INT_MIN) : s32(rs2) == 0 ? -1 : s32(rs1) / s32(rs2)` |                                     |
| `divuw`      | `rd = s32(rs2) == 0 ? -1 : s32(u32(rs1) / u32(rs2))`                                                        |                                     |
| `remw`       | `rd = s32(rs1) == s32(INT_MIN) && s32(rs2) == -1 ? 0 : s32(rs2) == 0 ? s32(rs1) : s32(rs1) % s32(rs2)`      |                                     |
| `remuw`      | `rd = s32(rs2) == 0 ? s32(rs1) : s32(u32(rs1) % u32(rs2))`                                                  |                                     |

:RV64M - "RV64M Standard Extension for Integer Multiply and Divide (+ RV32M)"

| instruction  | instruction pseudo code                                                                                     |                                     |
|--------------|:------------------------------------------------------------------------------------------------------------|:------------------------------------|
| `lr.w`       | `lr = rs1; s32 t; mmu.load<s32>(rs1, t); rd = t`                                                            |                                     |
| `sc.w`       | `ux res = 0; if (lr != rs1) res = 1; else mmu.store<s32>(rs1, s32(rs2)); rd = res`                          |                                     |
| `amoswap.w`  | `s32 t1, t2 = s32(rs2); mmu.amo<s32>(amoswap, rs1, t1, t2); rd = t1`                                        |                                     |
| `amoadd.w`   | `s32 t1, t2 = s32(rs2); mmu.amo<s32>(amoadd, rs1, t1, t2); rd = t1`                                         |                                     |
| `amoxor.w`   | `s32 t1, t2 = s32(rs2); mmu.amo<s32>(amoxor, rs1, t1, t2); rd = t1`                                         |                                     |
| `amoor.w`    | `s32 t1, t2 = s32(rs2); mmu.amo<s32>(amoor, rs1, t1, t2); rd = t1`                                          |                                     |
| `amoand.w`   | `s32 t1, t2 = s32(rs2); mmu.amo<s32>(amoand, rs1, t1, t2); rd = t1`                                         |                                     |
| `amomin.w`   | `s32 t1, t2 = s32(rs2); mmu.amo<s32>(amomin, rs1, t1, t2); rd = t1`                                         |                                     |
| `amomax.w`   | `s32 t1, t2 = s32(rs2); mmu.amo<s32>(amomax, rs1, t1, t2); rd = t1`                                         |                                     |
| `amominu.w`  | `s32 t1, t2 = s32(rs2); mmu.amo<s32>(amominu, rs1, t1, t2); rd = t1`                                        |                                     |
| `amomaxu.w`  | `s32 t1, t2 = s32(rs2); mmu.amo<s32>(amomaxu, rs1, t1, t2); rd = t1`                                        |                                     |

:RV32A - "RV32A Standard Extension for Atomic Instructions"

| instruction  | instruction pseudo code                                                                                     |                                     |
|--------------|:------------------------------------------------------------------------------------------------------------|:------------------------------------|
| `lr.d`       | `lr = rs1; s64 t; mmu.load<s64>(rs1, t); rd = t`                                                            |                                     |
| `sc.d`       | `ux res = 0; if (lr != rs1) res = 1; else mmu.store<s64>(rs1, s64(rs2)); rd = res`                          |                                     |
| `amoswap.d`  | `s64 t1, t2 = s64(rs2); mmu.amo<s64>(amoswap, rs1, t1, t2); rd = t1`                                        |                                     |
| `amoadd.d`   | `s64 t1, t2 = s64(rs2); mmu.amo<s64>(amoadd, rs1, t1, t2); rd = t1`                                         |                                     |
| `amoxor.d`   | `s64 t1, t2 = s64(rs2); mmu.amo<s64>(amoxor, rs1, t1, t2); rd = t1`                                         |                                     |
| `amoor.d`    | `s64 t1, t2 = s64(rs2); mmu.amo<s64>(amoor, rs1, t1, t2); rd = t1`                                          |                                     |
| `amoand.d`   | `s64 t1, t2 = s64(rs2); mmu.amo<s64>(amoand, rs1, t1, t2); rd = t1`                                         |                                     |
| `amomin.d`   | `s64 t1, t2 = s64(rs2); mmu.amo<s64>(amomin, rs1, t1, t2); rd = t1`                                         |                                     |
| `amomax.d`   | `s64 t1, t2 = s64(rs2); mmu.amo<s64>(amomax, rs1, t1, t2); rd = t1`                                         |                                     |
| `amominu.d`  | `s64 t1, t2 = s64(rs2); mmu.amo<s64>(amominu, rs1, t1, t2); rd = t1`                                        |                                     |
| `amomaxu.d`  | `s64 t1, t2 = s64(rs2); mmu.amo<s64>(amomaxu, rs1, t1, t2); rd = t1`                                        |                                     |

:RV64A - "RV64A Standard Extension for Atomic Instructions (+ RV32A)"

| instruction  | instruction pseudo code                                                                                     |                                     |
|--------------|:------------------------------------------------------------------------------------------------------------|:------------------------------------|
| `ecall`      |                                                                                                             |                                     |
| `ebreak`     |                                                                                                             |                                     |
| `uret`       |                                                                                                             |                                     |
| `sret`       |                                                                                                             |                                     |
| `hret`       |                                                                                                             |                                     |
| `mret`       |                                                                                                             |                                     |
| `dret`       |                                                                                                             |                                     |
| `sfence.vm`  |                                                                                                             |                                     |
| `wfi`        |                                                                                                             |                                     |
| `rdcycle`    |                                                                                                             |                                     |
| `rdtime`     |                                                                                                             |                                     |
| `rdinstret`  |                                                                                                             |                                     |
| `rdcycleh`   |                                                                                                             |                                     |
| `rdtimeh`    |                                                                                                             |                                     |
| `rdinstreth` |                                                                                                             |                                     |
| `csrrw`      |                                                                                                             |                                     |
| `csrrs`      |                                                                                                             |                                     |
| `csrrc`      |                                                                                                             |                                     |
| `csrrwi`     |                                                                                                             |                                     |
| `csrrsi`     |                                                                                                             |                                     |
| `csrrci`     |                                                                                                             |                                     |

:RV32S - "RV32S Standard Extension for Supervisor-level Instructions"

| instruction  | instruction pseudo code                                                                                     |                                     |
|--------------|:------------------------------------------------------------------------------------------------------------|:------------------------------------|
| `flw`        | `u32 t; mmu.load<u32>(rs1 + imm, t); u32(frd) = t`                                                          | `f32(frd) = *(f32*)ptr(rs1 + imm)`  |
| `fsw`        | `mmu.store<f32>(rs1 + imm, f32(frs2))`                                                                      | `*(f32*)ptr(rs1 + imm) = f32(frs2)` |
| `fmadd.s`    | `fenv_setrm(rm); f32(frd) = f32(frs1) * f32(frs2) + f32(frs3)`                                              | `-mfma`                             |
| `fmsub.s`    | `fenv_setrm(rm); f32(frd) = f32(frs1) * f32(frs2) - f32(frs3)`                                              |                                     |
| `fnmadd.s`   | `fenv_setrm(rm); f32(frd) = f32(frs1) * -f32(frs2) - f32(frs3)`                                             |                                     |
| `fnmsub.s`   | `fenv_setrm(rm); f32(frd) = f32(frs1) * -f32(frs2) + f32(frs3)`                                             |                                     |
| `fadd.s`     | `fenv_setrm(rm); f32(frd) = f32(frs1) + f32(frs2)`                                                          |                                     |
| `fsub.s`     | `fenv_setrm(rm); f32(frd) = f32(frs1) - f32(frs2)`                                                          |                                     |
| `fmul.s`     | `fenv_setrm(rm); f32(frd) = f32(frs1) * f32(frs2)`                                                          |                                     |
| `fdiv.s`     | `fenv_setrm(rm); f32(frd) = f32(frs1) / f32(frs2)`                                                          |                                     |
| `fsgnj.s`    | `u32(frd) = (u32(frs1) & u32(~(1U<<31))) \| (u32(frs2) & u32(1U<<31))`                                      |                                     |
| `fsgnjn.s`   | `u32(frd) = (u32(frs1) & u32(~(1U<<31))) \| (~u32(frs2) & u32(1U<<31))`                                     |                                     |
| `fsgnjx.s`   | `u32(frd) = u32(frs1) ^ (u32(frs2) & u32(1U<<31))`                                                          |                                     |
| `fmin.s`     | `f32(frd) = (f32(frs1) < f32(frs2)) \|\| isnan(f32(frs2)) ? f32(frs1) : f32(frs2)`                          |                                     |
| `fmax.s`     | `f32(frd) = (f32(frs1) > f32(frs2)) \|\| isnan(f32(frs2)) ? f32(frs1) : f32(frs2)`                          |                                     |
| `fsqrt.s`    | `fenv_setrm(rm); f32(frd) = riscv::f32_sqrt(f32(frs1))`                                                     |                                     |
| `fle.s`      | `rd = f32(frs1) <= f32(frs2)`                                                                               |                                     |
| `flt.s`      | `rd = f32(frs1) < f32(frs2)`                                                                                |                                     |
| `feq.s`      | `rd = f32(frs1) == f32(frs2)`                                                                               |                                     |
| `fcvt.w.s`   | `fenv_setrm(rm); rd = riscv::fcvt_w(fcsr, f32(frs1))`                                                       | `s32(f32(frs1))`                    |
| `fcvt.wu.s`  | `fenv_setrm(rm); rd = riscv::fcvt_wu(fcsr, f32(frs1))`                                                      | `s32(u32(f32(frs1)))`               |
| `fcvt.s.w`   | `fenv_setrm(rm); f32(frd) = f32(s32(rs1))`                                                                  |                                     |
| `fcvt.s.wu`  | `fenv_setrm(rm); f32(frd) = f32(u32(rs1))`                                                                  |                                     |
| `fmv.x.s`    | `rd = isnan(f32(frs1)) ? s32(u32(f32(NAN))) : s32(frs1)`                                                    | `s32(frs1)`                         |
| `fclass.s`   | `rd = f32_classify(f32(frs1))`                                                                              |                                     |
| `fmv.s.x`    | `u32(frd) = u32(rs1)`                                                                                       |                                     |

:RV32F - "RV32F Standard Extension for Single-Precision Floating-Point"

| instruction  | instruction pseudo code                                                                                     |                                     |
|--------------|:------------------------------------------------------------------------------------------------------------|:------------------------------------|
| `fcvt.l.s`   | `fenv_setrm(rm); rd = riscv::fcvt_l(fcsr, f32(frs1))`                                                       | `s64(f32(frs1))`                    |
| `fcvt.lu.s`  | `fenv_setrm(rm); rd = riscv::fcvt_lu(fcsr, f32(frs1))`                                                      | `s64(u32(f32(frs1)))`               |
| `fcvt.s.l`   | `fenv_setrm(rm); f32(frd) = f32(s64(rs1))`                                                                  |                                     |
| `fcvt.s.lu`  | `fenv_setrm(rm); f32(frd) = f32(u64(rs1))`                                                                  |                                     |

:RV64F - "RV64F Standard Extension for Single-Precision Floating-Point (+ RV32F)"

| instruction  | instruction pseudo code                                                                                     |                                     |
|--------------|:------------------------------------------------------------------------------------------------------------|:------------------------------------|
| `fld`        | `u64 t; mmu.load<u64>(rs1 + imm, t); u64(frd) = t`                                                          | `f64(frd) = *(f64*)ptr(rs1 + imm)`  |
| `fsd`        | `mmu.store<f64>(rs1 + imm, f64(frs2))`                                                                      | `*(f64*)ptr(rs1 + imm) = f64(frs2)` |
| `fmadd.d`    | `fenv_setrm(rm); f64(frd) = f64(frs1) * f64(frs2) + f64(frs3)`                                              |                                     |
| `fmsub.d`    | `fenv_setrm(rm); f64(frd) = f64(frs1) * f64(frs2) - f64(frs3)`                                              |                                     |
| `fnmadd.d`   | `fenv_setrm(rm); f64(frd) = f64(frs1) * -f64(frs2) - f64(frs3)`                                             |                                     |
| `fnmsub.d`   | `fenv_setrm(rm); f64(frd) = f64(frs1) * -f64(frs2) + f64(frs3)`                                             |                                     |
| `fadd.d`     | `fenv_setrm(rm); f64(frd) = f64(frs1) + f64(frs2)`                                                          |                                     |
| `fsub.d`     | `fenv_setrm(rm); f64(frd) = f64(frs1) - f64(frs2)`                                                          |                                     |
| `fmul.d`     | `fenv_setrm(rm); f64(frd) = f64(frs1) * f64(frs2)`                                                          |                                     |
| `fdiv.d`     | `fenv_setrm(rm); f64(frd) = f64(frs1) / f64(frs2)`                                                          |                                     |
| `fsgnj.d`    | `u64(frd) = (u64(frs1) & u64(~(1ULL<<63))) \| (u64(frs2) & u64(1ULL<<63))`                                  |                                     |
| `fsgnjn.d`   | `u64(frd) = (u64(frs1) & u64(~(1ULL<<63))) \| (~u64(frs2) & u64(1ULL<<63))`                                 |                                     |
| `fsgnjx.d`   | `u64(frd) = u64(frs1) ^ (u64(frs2) & u64(1ULL<<63))`                                                        |                                     |
| `fmin.d`     | `f64(frd) = (f64(frs1) < f64(frs2)) \|\| isnan(f64(frs2)) ? f64(frs1) : f64(frs2)`                          |                                     |
| `fmax.d`     | `f64(frd) = (f64(frs1) > f64(frs2)) \|\| isnan(f64(frs2)) ? f64(frs1) : f64(frs2)`                          |                                     |
| `fcvt.s.d`   | `fenv_setrm(rm); f32(frd) = f32(f64(frs1))`                                                                 |                                     |
| `fcvt.d.s`   | `fenv_setrm(rm); f64(frd) = f64(f32(frs1))`                                                                 |                                     |
| `fsqrt.d`    | `fenv_setrm(rm); f64(frd) = riscv::f64_sqrt(f64(frs1))`                                                     |                                     |
| `fle.d`      | `rd = f64(frs1) <= f64(frs2)`                                                                               |                                     |
| `flt.d`      | `rd = f64(frs1) < f64(frs2)`                                                                                |                                     |
| `feq.d`      | `rd = f64(frs1) == f64(frs2)`                                                                               |                                     |
| `fcvt.w.d`   | `fenv_setrm(rm); rd = riscv::fcvt_w(fcsr, f64(frs1))`                                                       | `s32(f64(frs1))`                    |
| `fcvt.wu.d`  | `fenv_setrm(rm); rd = riscv::fcvt_wu(fcsr, f64(frs1))`                                                      | `s32(u32(f64(frs1)))`               |
| `fcvt.d.w`   | `fenv_setrm(rm); f64(frd) = f64(s32(rs1))`                                                                  |                                     |
| `fcvt.d.wu`  | `fenv_setrm(rm); f64(frd) = f64(u32(rs1))`                                                                  |                                     |
| `fclass.d`   | `rd = f64_classify(f64(frs1))`                                                                              |                                     |

:RV32D - "RV32D Standard Extension for Double-Precision Floating-Point"

| instruction  | instruction pseudo code                                                                                     |                                     |
|--------------|:------------------------------------------------------------------------------------------------------------|:------------------------------------|
| `fcvt.l.d`   | `fenv_setrm(rm); rd = riscv::fcvt_l(fcsr, f64(frs1))`                                                       | `s64(f64(frs1))`                    |
| `fcvt.lu.d`  | `fenv_setrm(rm); rd = riscv::fcvt_lu(fcsr, f64(frs1))`                                                      | `s64(u64(f64(frs1)))`               |
| `fmv.x.d`    | `rd = isnan(f64(frs1)) ? s64(u64(f64(NAN))) : s64(frs1)`                                                    | `s64(frs1)`                         |
| `fcvt.d.l`   | `fenv_setrm(rm); f64(frd) = f64(s64(rs1))`                                                                  |                                     |
| `fcvt.d.lu`  | `fenv_setrm(rm); f64(frd) = f64(u64(rs1))`                                                                  |                                     |
| `fmv.d.x`    | `u64(frd) = u64(rs1)`                                                                                       |                                     |

:RV64D - "RV64D Standard Extension for Double-Precision Floating-Point (+ RV32F)"

| instruction  | instruction pseudo code                                                                                     |                                     |
|--------------|:------------------------------------------------------------------------------------------------------------|:------------------------------------|
| `frcsr`      |                                                                                                             |                                     |
| `frrm`       |                                                                                                             |                                     |
| `frflags`    |                                                                                                             |                                     |
| `fscsr`      |                                                                                                             |                                     |
| `fsrm`       |                                                                                                             |                                     |
| `fsflags`    |                                                                                                             |                                     |
| `fsrmi`      |                                                                                                             |                                     |
| `fsflagsi`   |                                                                                                             |                                     |

:RV32FD - "RV32F and RV32D Common Floating-Point Instructions"
