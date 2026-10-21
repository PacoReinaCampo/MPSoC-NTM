# REGISTERS

`INSERT HERE`

## COMPLEX BASE

`INSERT HERE`

## COMPLEX STANDARD

`INSERT HERE`

## COMPLEX SPECIFIC

`INSERT HERE`

### Complex Arithmetic

`INSERT HERE`

#### Single Precision Float-Point

`INSERT HERE`

#### Double Precision Float-Point

`INSERT HERE`

#### Quadruple Precision Float-Point

`INSERT HERE`

### Complex Algebra

`INSERT HERE`

#### Vector Algebra

* **New Specific Registers**

  | **Register**       | **Type** | **Name**      | **Quantity** | **Description**                                                                                                                                                                                                                                                                                                                                        |
  |:-------------------|:---------|:--------------|:-------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
  | Vector Registers   | `Vector` | `v0` to `v31` | 32           | Architectural registers used to hold vector elements. Each vector register has a fixed size of `VLEN` bits of state. They can be grouped together using the `LMUL` (Vector Register Group Multiplier) setting to operate on wider data types or longer vectors. Vector mask registers are also held in a single vector register, typically using `v0`. |
  | Vector Length      | `CSR`    | `vl`          | 1            | Holds an unsigned integer specifying the number of elements to be updated with results from a vector instruction. It is updated via the `vset{i}vl{i}` configuration instructions.                                                                                                                                                                     |
  | Vector Data Type   | `CSR`    | `vtype`       | 1            | A read-only register that provides the default data type used to interpret the contents of the vector registers. It includes settings for the selected element width (`vsew`), register group multiplier (`vlmul`), tail agnostic policy (`vta`), and mask agnostic policy (`vma`).                                                                    |
  | Vector Byte Length | `CSR`    | `vlenb`       | 1            | Exposes the hardware constant value `VLEN / 8` (the vector register length in bytes). This allows software to calculate memory offsets without hardcoding implementation-specific constants.                                                                                                                                                           |
  | Vector Start Index | `CSR`    | `vstart`      | 1            | Specifies the index of the first element to be executed by a vector instruction. It is primarily written by the hardware when taking a trap on a vector instruction to allow resumption after the trap is handled.                                                                                                                                     |
  | Control and Status | `CSR`    | `vcsr`        | 1            | The vector control and status register, which groups the fixed-point rounding mode (`vxrm`) and saturation flag (`vxsat`) fields.                                                                                                                                                                                                                      |
  | Rounding Mode      | `CSR`    | `vxrm`        | 1            | Holds a two-bit field that specifies the rounding mode for fixed-point arithmetic instructions (e.g., round-to-nearest-up, round-to-nearest-even, round-down, round-to-odd).                                                                                                                                                                           |
  | Saturation Flag    | `CSR`    | `vxsat`       | 1            | A fixed-point accrued saturation flag that is set to 1 if any destination element is saturated during a saturating add/subtract or fractional multiply operation.                                                                                                                                                                                      |

  : Vector Register Type

* **Vector GPR Registers**

  | **Name** | **Alias** | **Type** | **Save** | **Description**                 |
  |----------|:----------|:---------|:---------|:--------------------------------|
  | `v0`     | `vt0`     | `vreg`   | `caller` | `Vector temporaries Caller`     |
  | `v1`     | `vt1`     | `vreg`   | `caller` | `Vector temporaries Caller`     |
  | `v2`     | `vt2`     | `vreg`   | `caller` | `Vector temporaries Caller`     |
  | `v3`     | `vt3`     | `vreg`   | `caller` | `Vector temporaries Caller`     |
  | `v4`     | `vt4`     | `vreg`   | `caller` | `Vector temporaries Caller`     |
  | `v5`     | `vt5`     | `vreg`   | `caller` | `Vector temporaries Caller`     |
  | `v6`     | `vt6`     | `vreg`   | `caller` | `Vector temporaries Caller`     |
  | `v7`     | `vt7`     | `vreg`   | `caller` | `Vector temporaries Caller`     |
  | `v8`     | `vs0`     | `vreg`   | `callee` | `Vector saved registers Callee` |
  | `v9`     | `vs1`     | `vreg`   | `callee` | `Vector saved registers Callee` |
  | `v10`    | `va0`     | `vreg`   | `caller` | `Vector arguments Caller`       |
  | `v11`    | `va1`     | `vreg`   | `caller` | `Vector arguments Caller`       |
  | `v12`    | `va2`     | `vreg`   | `caller` | `Vector arguments Caller`       |
  | `v13`    | `va3`     | `vreg`   | `caller` | `Vector arguments Caller`       |
  | `v14`    | `va4`     | `vreg`   | `caller` | `Vector arguments Caller`       |
  | `v15`    | `va5`     | `vreg`   | `caller` | `Vector arguments Caller`       |
  | `v16`    | `va6`     | `vreg`   | `caller` | `Vector arguments Caller`       |
  | `v17`    | `va7`     | `vreg`   | `caller` | `Vector arguments Caller`       |
  | `v18`    | `vs2`     | `vreg`   | `callee` | `Vector saved registers Callee` |
  | `v19`    | `vs3`     | `vreg`   | `callee` | `Vector saved registers Callee` |
  | `v20`    | `vs4`     | `vreg`   | `callee` | `Vector saved registers Callee` |
  | `v21`    | `vs5`     | `vreg`   | `callee` | `Vector saved registers Callee` |
  | `v22`    | `vs6`     | `vreg`   | `callee` | `Vector saved registers Callee` |
  | `v23`    | `vs7`     | `vreg`   | `callee` | `Vector saved registers Callee` |
  | `v24`    | `vs8`     | `vreg`   | `callee` | `Vector saved registers Callee` |
  | `v25`    | `vs9`     | `vreg`   | `callee` | `Vector saved registers Callee` |
  | `v26`    | `vs10`    | `vreg`   | `callee` | `Vector saved registers Callee` |
  | `v27`    | `vs11`    | `vreg`   | `callee` | `Vector saved registers Callee` |
  | `v28`    | `vt8`     | `vreg`   | `caller` | `Vector temporaries Caller`     |
  | `v29`    | `vt9`     | `vreg`   | `caller` | `Vector temporaries Caller`     |
  | `v30`    | `vt10`    | `vreg`   | `caller` | `Vector temporaries Caller`     |
  | `v31`    | `vt11`    | `vreg`   | `caller` | `Vector temporaries Caller`     |

  : Vector Registers

* **Vector CSR Registers**

  | **Address** | **Privilege** | **Name** | **Description**                          |
  |-------------|---------------|----------|------------------------------------------|
  | `0x008`     | `URW`         | `vstart` | Vector start position                    |
  | `0x009`     | `URW`         | `vxsat`  | Fixed-Point Saturate Flag                |
  | `0x00A`     | `URW`         | `vxrm`   | Fixed-Point Rounding Mode                |
  | `0x00F`     | `URW`         | `vcsr`   | Vector control and status register       |
  | `0xC20`     | `URO`         | `vl`     | Vector length                            |
  | `0xC21`     | `URO`         | `vtype`  | Vector data type register                |
  | `0xC22`     | `URO`         | `vlenb`  | VLEN/8 (vector register length in bytes) |

  : New Vector CSRs

* **Configuration-Setting**

  | **Bits**   | **Name**     | **Description**                                 |
  |------------|--------------|-------------------------------------------------|
  | `XLEN-1`   | `vill`       | Illegal value if set                            |
  | `XLEN-2:8` | `0`          | Reserved if non-zero                            |
  | `7`        | `vma`        | Vector mask agnostic                            |
  | `6`        | `vta`        | Vector tail agnostic                            |
  | `5:3`      | `vsew[2:0]`  | Selected element width (SEW) setting            |
  | `2:0`      | `vlmul[2:0]` | Vector register group multiplier (LMUL) setting |

  : `vtype` Register Layout

* **Vector Loads and Stores**

  | **Field**    | **Description**                                                                   |
  |--------------|-----------------------------------------------------------------------------------|
  | `rs1[4:0]`   | specifies `x` register holding base address                                       |
  | `rs2[4:0]`   | specifies `x` register holding stride                                             |
  | `vs2[4:0]`   | specifies `v` register holding address offsets                                    |
  | `vs3[4:0]`   | specifies `v` register holding store data                                         |
  | `vd[4:0]`    | specifies `v` register destination of load                                        |
  | `vm`         | specifies whether vector masking is enabled (0 = mask enabled, 1 = mask disabled) |
  | `width[2:0]` | specifies size of memory elements, and distinguishes from FP scalar               |
  | `mew`        | extended memory element width. See Vector Load/Store Width Encoding               |
  | `mop[1:0]`   | specifies memory addressing mode                                                  |
  | `nf[2:0]`    | specifies the number of fields in each segment, for segment load/stores           |
  | `lumop[4:0]` | additional fields encoding variants of unit-stride instructions                   |
  | `sumop[4:0]` | additional fields encoding variants of unit-stride instructions                   |

  : Vector Field Descriptions

  | **Type**           | **mew** | **width `[2:0]`** | **Memory Bits** | **Data Register Bits** | **Index Bits** | **Opcodes**       |
  |--------------------|---------|-------------------|-----------------|------------------------|----------------|-------------------|
  | Standard scalar FP | `x`     | `001`             | `16`            | `FLEN`                 | `-`            | `FLH/FSH`         |
  | Standard scalar FP | `x`     | `010`             | `32`            | `FLEN`                 | `-`            | `FLW/FSW`         |
  | Standard scalar FP | `x`     | `011`             | `64`            | `FLEN`                 | `-`            | `FLD/FSD`         |
  | Standard scalar FP | `x`     | `100`             | `128`           | `FLEN`                 | `-`            | `FLQ/FSQ`         |
  | Vector 08b element | `0`     | `000`             | `8`             | `8`                    | `-`            | `VLxE8/VSxE8`     |
  | Vector 16b element | `0`     | `101`             | `16`            | `16`                   | `-`            | `VLxE16/VSxE16`   |
  | Vector 32b element | `0`     | `110`             | `32`            | `32`                   | `-`            | `VLxE32/VSxE32`   |
  | Vector 64b element | `0`     | `111`             | `64`            | `64`                   | `-`            | `VLxE64/VSxE64`   |
  | Vector 08b index   | `0`     | `000`             | `SEW`           | `SEW`                  | `8`            | `VLxEI8/VSxEI8`   |
  | Vector 16b index   | `0`     | `101`             | `SEW`           | `SEW`                  | `16`           | `VLxEI16/VSxEI16` |
  | Vector 32b index   | `0`     | `110`             | `SEW`           | `SEW`                  | `32`           | `VLxEI32/VSxEI32` |
  | Vector 64b index   | `0`     | `111`             | `SEW`           | `SEW`                  | `64`           | `VLxEI64/VSxEI64` |
  | Reserved           | `1`     | `XXX`             | `-`             | `-`                    | `-`            | `-`               |

  : Width Encoding for Vector Loads and Stores

#### Matrix Algebra

* **New Specific Registers**

  | **Register**       | **Type** | **Name**      | **Quantity** | **Description**                                                                                                                                                                                                                                                                                                                                        |
  |:-------------------|:---------|:--------------|:-------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
  | Matrix Registers   | `Matrix` | `w0` to `w31` | 32           | Architectural registers used to hold matrix elements. Each matrix register has a fixed size of `WLEN` bits of state. They can be grouped together using the `LMUL` (Matrix Register Group Multiplier) setting to operate on wider data types or longer matrixs. Matrix mask registers are also held in a single matrix register, typically using `w0`. |
  | Matrix Length      | `CSR`    | `wl`          | 1            | Holds an unsigned integer specifying the number of elements to be updated with results from a matrix instruction. It is updated via the `wset{i}vl{i}` configuration instructions.                                                                                                                                                                     |
  | Matrix Data Type   | `CSR`    | `wtype`       | 1            | A read-only register that provides the default data type used to interpret the contents of the matrix registers. It includes settings for the selected element width (`wsew`), register group multiplier (`wlmul`), tail agnostic policy (`wta`), and mask agnostic policy (`wma`).                                                                    |
  | Matrix Byte Length | `CSR`    | `wlenb`       | 1            | Exposes the hardware constant value `WLEN / 8` (the matrix register length in bytes). This allows software to calculate memory offsets without hardcoding implementation-specific constants.                                                                                                                                                           |
  | Matrix Start Index | `CSR`    | `wstart`      | 1            | Specifies the index of the first element to be executed by a matrix instruction. It is primarily written by the hardware when taking a trap on a matrix instruction to allow resumption after the trap is handled.                                                                                                                                     |
  | Control and Status | `CSR`    | `wcsr`        | 1            | The matrix control and status register, which groups the fixed-point rounding mode (`wxrm`) and saturation flag (`wxsat`) fields.                                                                                                                                                                                                                      |
  | Rounding Mode      | `CSR`    | `wxrm`        | 1            | Holds a two-bit field that specifies the rounding mode for fixed-point arithmetic instructions (e.g., round-to-nearest-up, round-to-nearest-even, round-down, round-to-odd).                                                                                                                                                                           |
  | Saturation Flag    | `CSR`    | `wxsat`       | 1            | A fixed-point accrued saturation flag that is set to 1 if any destination element is saturated during a saturating add/subtract or fractional multiply operation.                                                                                                                                                                                      |

  : Matrix Register Type

* **Matrix GPR Registers**

  | **Name** | **Alias** | **Type** | **Save** | **Description**                 |
  |----------|:----------|:---------|:---------|:--------------------------------|
  | `w0`     | `wt0`     | `wreg`   | `caller` | `Matrix temporaries Caller`     |
  | `w1`     | `wt1`     | `wreg`   | `caller` | `Matrix temporaries Caller`     |
  | `w2`     | `wt2`     | `wreg`   | `caller` | `Matrix temporaries Caller`     |
  | `w3`     | `wt3`     | `wreg`   | `caller` | `Matrix temporaries Caller`     |
  | `w4`     | `wt4`     | `wreg`   | `caller` | `Matrix temporaries Caller`     |
  | `w5`     | `wt5`     | `wreg`   | `caller` | `Matrix temporaries Caller`     |
  | `w6`     | `wt6`     | `wreg`   | `caller` | `Matrix temporaries Caller`     |
  | `w7`     | `wt7`     | `wreg`   | `caller` | `Matrix temporaries Caller`     |
  | `w8`     | `ws0`     | `wreg`   | `callee` | `Matrix saved registers Callee` |
  | `w9`     | `ws1`     | `wreg`   | `callee` | `Matrix saved registers Callee` |
  | `w10`    | `wa0`     | `wreg`   | `caller` | `Matrix arguments Caller`       |
  | `w11`    | `wa1`     | `wreg`   | `caller` | `Matrix arguments Caller`       |
  | `w12`    | `wa2`     | `wreg`   | `caller` | `Matrix arguments Caller`       |
  | `w13`    | `wa3`     | `wreg`   | `caller` | `Matrix arguments Caller`       |
  | `w14`    | `wa4`     | `wreg`   | `caller` | `Matrix arguments Caller`       |
  | `w15`    | `wa5`     | `wreg`   | `caller` | `Matrix arguments Caller`       |
  | `w16`    | `wa6`     | `wreg`   | `caller` | `Matrix arguments Caller`       |
  | `w17`    | `wa7`     | `wreg`   | `caller` | `Matrix arguments Caller`       |
  | `w18`    | `ws2`     | `wreg`   | `callee` | `Matrix saved registers Callee` |
  | `w19`    | `ws3`     | `wreg`   | `callee` | `Matrix saved registers Callee` |
  | `w20`    | `ws4`     | `wreg`   | `callee` | `Matrix saved registers Callee` |
  | `w21`    | `ws5`     | `wreg`   | `callee` | `Matrix saved registers Callee` |
  | `w22`    | `ws6`     | `wreg`   | `callee` | `Matrix saved registers Callee` |
  | `w23`    | `ws7`     | `wreg`   | `callee` | `Matrix saved registers Callee` |
  | `w24`    | `ws8`     | `wreg`   | `callee` | `Matrix saved registers Callee` |
  | `w25`    | `ws9`     | `wreg`   | `callee` | `Matrix saved registers Callee` |
  | `w26`    | `ws10`    | `wreg`   | `callee` | `Matrix saved registers Callee` |
  | `w27`    | `ws11`    | `wreg`   | `callee` | `Matrix saved registers Callee` |
  | `w28`    | `wt8`     | `wreg`   | `caller` | `Matrix temporaries Caller`     |
  | `w29`    | `wt9`     | `wreg`   | `caller` | `Matrix temporaries Caller`     |
  | `w30`    | `wt10`    | `wreg`   | `caller` | `Matrix temporaries Caller`     |
  | `w31`    | `wt11`    | `wreg`   | `caller` | `Matrix temporaries Caller`     |

  : Matrix Registers

* **Matrix CSR Registers**

  | **Address** | **Privilege** | **Name** | **Description**                          |
  |-------------|---------------|----------|------------------------------------------|
  | `0x008`     | `URW`         | `wstart` | Matrix start position                    |
  | `0x009`     | `URW`         | `wxsat`  | Fixed-Point Saturate Flag                |
  | `0x00A`     | `URW`         | `wxrm`   | Fixed-Point Rounding Mode                |
  | `0x00F`     | `URW`         | `wcsr`   | Matrix control and status register       |
  | `0xC20`     | `URO`         | `wl`     | Matrix length                            |
  | `0xC21`     | `URO`         | `wtype`  | Matrix data type register                |
  | `0xC22`     | `URO`         | `wlenb`  | WLEN/8 (matrix register length in bytes) |

  : New Matrix CSRs

* **Configuration-Setting**

  | **Bits**   | **Name**     | **Description**                                 |
  |------------|--------------|-------------------------------------------------|
  | `XLEN-1`   | `will`       | Illegal value if set                            |
  | `XLEN-2:8` | `0`          | Reserved if non-zero                            |
  | `7`        | `wma`        | Matrix mask agnostic                            |
  | `6`        | `wta`        | Matrix tail agnostic                            |
  | `5:3`      | `wsew[2:0]`  | Selected element width (SEW) setting            |
  | `2:0`      | `wlmul[2:0]` | Matrix register group multiplier (LMUL) setting |

  : `wtype` Register Layout

* **Matrix Loads and Stores**

  | **Field**    | **Description**                                                                   |
  |--------------|-----------------------------------------------------------------------------------|
  | `rs1[4:0]`   | specifies `x` register holding base address                                       |
  | `rs2[4:0]`   | specifies `x` register holding stride                                             |
  | `ws2[4:0]`   | specifies `w` register holding address offsets                                    |
  | `ws3[4:0]`   | specifies `w` register holding store data                                         |
  | `wd[4:0]`    | specifies `w` register destination of load                                        |
  | `wm`         | specifies whether matrix masking is enabled (0 = mask enabled, 1 = mask disabled) |
  | `width[2:0]` | specifies size of memory elements, and distinguishes from FP scalar               |
  | `mew`        | extended memory element width. See Matrix Load/Store Width Encoding               |
  | `mop[1:0]`   | specifies memory addressing mode                                                  |
  | `nf[2:0]`    | specifies the number of fields in each segment, for segment load/stores           |
  | `lumop[4:0]` | additional fields encoding variants of unit-stride instructions                   |
  | `sumop[4:0]` | additional fields encoding variants of unit-stride instructions                   |

  : Matrix Field Descriptions

  | **Type**           | **mew** | **width `[2:0]`** | **Memory Bits** | **Data Register Bits** | **Index Bits** | **Opcodes**       |
  |--------------------|---------|-------------------|-----------------|------------------------|----------------|-------------------|
  | Standard scalar FP | `x`     | `001`             | `16`            | `FLEN`                 | `-`            | `FLH/FSH`         |
  | Standard scalar FP | `x`     | `010`             | `32`            | `FLEN`                 | `-`            | `FLW/FSW`         |
  | Standard scalar FP | `x`     | `011`             | `64`            | `FLEN`                 | `-`            | `FLD/FSD`         |
  | Standard scalar FP | `x`     | `100`             | `128`           | `FLEN`                 | `-`            | `FLQ/FSQ`         |
  | Matrix 08b element | `0`     | `000`             | `8`             | `8`                    | `-`            | `WLxE8/WSxE8`     |
  | Matrix 16b element | `0`     | `101`             | `16`            | `16`                   | `-`            | `WLxE16/WSxE16`   |
  | Matrix 32b element | `0`     | `110`             | `32`            | `32`                   | `-`            | `WLxE32/WSxE32`   |
  | Matrix 64b element | `0`     | `111`             | `64`            | `64`                   | `-`            | `WLxE64/WSxE64`   |
  | Matrix 08b index   | `0`     | `000`             | `SEW`           | `SEW`                  | `8`            | `WLxEI8/WSxEI8`   |
  | Matrix 16b index   | `0`     | `101`             | `SEW`           | `SEW`                  | `16`           | `WLxEI16/WSxEI16` |
  | Matrix 32b index   | `0`     | `110`             | `SEW`           | `SEW`                  | `32`           | `WLxEI32/WSxEI32` |
  | Matrix 64b index   | `0`     | `111`             | `SEW`           | `SEW`                  | `64`           | `WLxEI64/WSxEI64` |
  | Reserved           | `1`     | `XXX`             | `-`             | `-`                    | `-`            | `-`               |

  : Width Encoding for Matrix Loads and Stores

#### Tensor Algebra

* **New Specific Registers**

  | **Register**       | **Type** | **Name**      | **Quantity** | **Description**                                                                                                                                                                                                                                                                                                                                        |
  |:-------------------|:---------|:--------------|:-------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
  | Tensor Registers   | `Tensor` | `y0` to `y31` | 32           | Architectural registers used to hold tensor elements. Each tensor register has a fixed size of `YLEN` bits of state. They can be grouped together using the `LMUL` (Tensor Register Group Multiplier) setting to operate on wider data types or longer tensors. Tensor mask registers are also held in a single tensor register, typically using `y0`. |
  | Tensor Length      | `CSR`    | `yl`          | 1            | Holds an unsigned integer specifying the number of elements to be updated with results from a tensor instruction. It is updated via the `yset{i}vl{i}` configuration instructions.                                                                                                                                                                     |
  | Tensor Data Type   | `CSR`    | `ytype`       | 1            | A read-only register that provides the default data type used to interpret the contents of the tensor registers. It includes settings for the selected element width (`ysew`), register group multiplier (`ylmul`), tail agnostic policy (`yta`), and mask agnostic policy (`yma`).                                                                    |
  | Tensor Byte Length | `CSR`    | `ylenb`       | 1            | Exposes the hardware constant value `YLEN / 8` (the tensor register length in bytes). This allows software to calculate memory offsets without hardcoding implementation-specific constants.                                                                                                                                                           |
  | Tensor Start Index | `CSR`    | `ystart`      | 1            | Specifies the index of the first element to be executed by a tensor instruction. It is primarily written by the hardware when taking a trap on a tensor instruction to allow resumption after the trap is handled.                                                                                                                                     |
  | Control and Status | `CSR`    | `ycsr`        | 1            | The tensor control and status register, which groups the fixed-point rounding mode (`yxrm`) and saturation flag (`yxsat`) fields.                                                                                                                                                                                                                      |
  | Rounding Mode      | `CSR`    | `yxrm`        | 1            | Holds a two-bit field that specifies the rounding mode for fixed-point arithmetic instructions (e.g., round-to-nearest-up, round-to-nearest-even, round-down, round-to-odd).                                                                                                                                                                           |
  | Saturation Flag    | `CSR`    | `yxsat`       | 1            | A fixed-point accrued saturation flag that is set to 1 if any destination element is saturated during a saturating add/subtract or fractional multiply operation.                                                                                                                                                                                      |

  : Tensor Register Type

* **Tensor GPR Registers**

  | **Name** | **Alias** | **Type** | **Save** | **Description**                 |
  |----------|:----------|:---------|:---------|:--------------------------------|
  | `y0`     | `yt0`     | `yreg`   | `caller` | `Tensor temporaries Caller`     |
  | `y1`     | `yt1`     | `yreg`   | `caller` | `Tensor temporaries Caller`     |
  | `y2`     | `yt2`     | `yreg`   | `caller` | `Tensor temporaries Caller`     |
  | `y3`     | `yt3`     | `yreg`   | `caller` | `Tensor temporaries Caller`     |
  | `y4`     | `yt4`     | `yreg`   | `caller` | `Tensor temporaries Caller`     |
  | `y5`     | `yt5`     | `yreg`   | `caller` | `Tensor temporaries Caller`     |
  | `y6`     | `yt6`     | `yreg`   | `caller` | `Tensor temporaries Caller`     |
  | `y7`     | `yt7`     | `yreg`   | `caller` | `Tensor temporaries Caller`     |
  | `y8`     | `ys0`     | `yreg`   | `callee` | `Tensor saved registers Callee` |
  | `y9`     | `ys1`     | `yreg`   | `callee` | `Tensor saved registers Callee` |
  | `y10`    | `ya0`     | `yreg`   | `caller` | `Tensor arguments Caller`       |
  | `y11`    | `ya1`     | `yreg`   | `caller` | `Tensor arguments Caller`       |
  | `y12`    | `ya2`     | `yreg`   | `caller` | `Tensor arguments Caller`       |
  | `y13`    | `ya3`     | `yreg`   | `caller` | `Tensor arguments Caller`       |
  | `y14`    | `ya4`     | `yreg`   | `caller` | `Tensor arguments Caller`       |
  | `y15`    | `ya5`     | `yreg`   | `caller` | `Tensor arguments Caller`       |
  | `y16`    | `ya6`     | `yreg`   | `caller` | `Tensor arguments Caller`       |
  | `y17`    | `ya7`     | `yreg`   | `caller` | `Tensor arguments Caller`       |
  | `y18`    | `ys2`     | `yreg`   | `callee` | `Tensor saved registers Callee` |
  | `y19`    | `ys3`     | `yreg`   | `callee` | `Tensor saved registers Callee` |
  | `y20`    | `ys4`     | `yreg`   | `callee` | `Tensor saved registers Callee` |
  | `y21`    | `ys5`     | `yreg`   | `callee` | `Tensor saved registers Callee` |
  | `y22`    | `ys6`     | `yreg`   | `callee` | `Tensor saved registers Callee` |
  | `y23`    | `ys7`     | `yreg`   | `callee` | `Tensor saved registers Callee` |
  | `y24`    | `ys8`     | `yreg`   | `callee` | `Tensor saved registers Callee` |
  | `y25`    | `ys9`     | `yreg`   | `callee` | `Tensor saved registers Callee` |
  | `y26`    | `ys10`    | `yreg`   | `callee` | `Tensor saved registers Callee` |
  | `y27`    | `ys11`    | `yreg`   | `callee` | `Tensor saved registers Callee` |
  | `y28`    | `yt8`     | `yreg`   | `caller` | `Tensor temporaries Caller`     |
  | `y29`    | `yt9`     | `yreg`   | `caller` | `Tensor temporaries Caller`     |
  | `y30`    | `yt10`    | `yreg`   | `caller` | `Tensor temporaries Caller`     |
  | `y31`    | `yt11`    | `yreg`   | `caller` | `Tensor temporaries Caller`     |

  : Tensor Registers

* **Tensor CSR Registers**

  | **Address** | **Privilege** | **Name** | **Description**                          |
  |-------------|---------------|----------|------------------------------------------|
  | `0x008`     | `URW`         | `ystart` | Tensor start position                    |
  | `0x009`     | `URW`         | `yxsat`  | Fixed-Point Saturate Flag                |
  | `0x00A`     | `URW`         | `yxrm`   | Fixed-Point Rounding Mode                |
  | `0x00F`     | `URW`         | `ycsr`   | Tensor control and status register       |
  | `0xC20`     | `URO`         | `yl`     | Tensor length                            |
  | `0xC21`     | `URO`         | `ytype`  | Tensor data type register                |
  | `0xC22`     | `URO`         | `ylenb`  | YLEN/8 (tensor register length in bytes) |

  : New Tensor CSRs

* **Configuration-Setting**

  | **Bits**   | **Name**     | **Description**                                 |
  |------------|--------------|-------------------------------------------------|
  | `XLEN-1`   | `yill`       | Illegal value if set                            |
  | `XLEN-2:8` | `0`          | Reserved if non-zero                            |
  | `7`        | `yma`        | Tensor mask agnostic                            |
  | `6`        | `yta`        | Tensor tail agnostic                            |
  | `5:3`      | `ysew[2:0]`  | Selected element width (SEW) setting            |
  | `2:0`      | `ylmul[2:0]` | Tensor register group multiplier (LMUL) setting |

  : `wtype` Register Layout

* **Tensor Loads and Stores**

  | **Field**    | **Description**                                                                   |
  |--------------|-----------------------------------------------------------------------------------|
  | `rs1[4:0]`   | specifies `x` register holding base address                                       |
  | `rs2[4:0]`   | specifies `x` register holding stride                                             |
  | `ys2[4:0]`   | specifies `y` register holding address offsets                                    |
  | `ys3[4:0]`   | specifies `y` register holding store data                                         |
  | `yd[4:0]`    | specifies `y` register destination of load                                        |
  | `ym`         | specifies whether tensor masking is enabled (0 = mask enabled, 1 = mask disabled) |
  | `width[2:0]` | specifies size of memory elements, and distinguishes from FP scalar               |
  | `mew`        | extended memory element width. See Tensor Load/Store Width Encoding               |
  | `mop[1:0]`   | specifies memory addressing mode                                                  |
  | `nf[2:0]`    | specifies the number of fields in each segment, for segment load/stores           |
  | `lumop[4:0]` | additional fields encoding variants of unit-stride instructions                   |
  | `sumop[4:0]` | additional fields encoding variants of unit-stride instructions                   |

  : Tensor Field Descriptions

  | **Type**           | **mew** | **width `[2:0]`** | **Memory Bits** | **Data Register Bit**s | **Index Bits** | **Opcodes**       |
  |--------------------|---------|-------------------|-----------------|------------------------|----------------|-------------------|
  | Standard scalar FP | `x`     | `001`             | `16`            | `FLEN`                 | `-`            | `FLH/FSH`         |
  | Standard scalar FP | `x`     | `010`             | `32`            | `FLEN`                 | `-`            | `FLW/FSW`         |
  | Standard scalar FP | `x`     | `011`             | `64`            | `FLEN`                 | `-`            | `FLD/FSD`         |
  | Standard scalar FP | `x`     | `100`             | `128`           | `FLEN`                 | `-`            | `FLQ/FSQ`         |
  | Tensor 08b element | `0`     | `000`             | `8`             | `8`                    | `-`            | `VLxE8/YSxE8`     |
  | Tensor 16b element | `0`     | `101`             | `16`            | `16`                   | `-`            | `VLxE16/YSxE16`   |
  | Tensor 32b element | `0`     | `110`             | `32`            | `32`                   | `-`            | `VLxE32/YSxE32`   |
  | Tensor 64b element | `0`     | `111`             | `64`            | `64`                   | `-`            | `VLxE64/YSxE64`   |
  | Tensor 08b index   | `0`     | `000`             | `SEW`           | `SEW`                  | `8`            | `VLxEI8/YSxEI8`   |
  | Tensor 16b index   | `0`     | `101`             | `SEW`           | `SEW`                  | `16`           | `VLxEI16/YSxEI16` |
  | Tensor 32b index   | `0`     | `110`             | `SEW`           | `SEW`                  | `32`           | `VLxEI32/YSxEI32` |
  | Tensor 64b index   | `0`     | `111`             | `SEW`           | `SEW`                  | `64`           | `VLxEI64/YSxEI64` |
  | Reserved           | `1`     | `XXX`             | `-`             | `-`                    | `-`            | `-`               |

  : Width Encoding for Tensor Loads and Stores

### Complex Cryptography

`INSERT HERE`

#### Scalar Cryptography

`INSERT HERE`

#### Vector Cryptography

`INSERT HERE`

#### Matrix Cryptography

`INSERT HERE`

#### Tensor Cryptography

`INSERT HERE`

### Complex Parallelism

`INSERT HERE`

### Complex Privilege

`INSERT HERE`

#### User

* **User Mode Register**

  | **Register** | **Address** | **Description**                           |
  |:-------------|:------------|:------------------------------------------|
  | `USTATUS`    | `'h000`     | `User status`                             |
  | `UIE`        | `'h004`     | `User interrupt-enable register`          |
  | `UTVEC`      | `'h005`     | `User trap-handler base address`          |
  | `USCRATCH`   | `'h040`     | `Scratch register for user trap handlers` |
  | `UEPC`       | `'h041`     | `User exception program counter`          |
  | `UCAUSE`     | `'h042`     | `User trap cause`                         |
  | `UTVAL`      | `'h043`     | `User bad address or instruction`         |
  | `UIP`        | `'h044`     | `User interrupt pending`                  |

* **Unprivileged Floating-Point CSRs**

  | **Register** | **Address** | **Description**                                         |
  |:-------------|:------------|:--------------------------------------------------------|
  | `FFLAGS`     | `'h001`     | `Floating-Point Accrued Exceptions`                     |
  | `FRM`        | `'h002`     | `Floating-Point Dynamic Rounding Mode`                  |
  | `FCSR`       | `'h003`     | `Floating-Point Control/Status Register (FRM + FFLAGS)` |

* **Unprivileged Counter/Timers**

  | **Register**    | **Address** | **Description**                                          |
  |:----------------|:------------|:---------------------------------------------------------|
  | `CYCLE`         | `'hC00`     | `Cycle counter for RDCYCLE instruction`                  |
  | `TIME`          | `'hC01`     | `Timer for RDTIME instruction`                           |
  | `INSTRET`       | `'hC02`     | `Instructions-retired counter for RDINSTRET instruction` |
  | `HPMCOUNTER3`   | `'hC03`     | `Performance-monitoring counter`                         |
  | `HPMCOUNTER4`   | `'hC04`     | `Performance-monitoring counter`                         |
  | `HPMCOUNTER5`   | `'hC05`     | `Performance-monitoring counter`                         |
  | `HPMCOUNTER6`   | `'hC06`     | `Performance-monitoring counter`                         |
  | `HPMCOUNTER7`   | `'hC07`     | `Performance-monitoring counter`                         |
  | `HPMCOUNTER8`   | `'hC08`     | `Performance-monitoring counter`                         |
  | `HPMCOUNTER9`   | `'hC09`     | `Performance-monitoring counter`                         |
  | `HPMCOUNTER10`  | `'hC0A`     | `Performance-monitoring counter`                         |
  | `HPMCOUNTER11`  | `'hC0B`     | `Performance-monitoring counter`                         |
  | `HPMCOUNTER12`  | `'hC0C`     | `Performance-monitoring counter`                         |
  | `HPMCOUNTER13`  | `'hC0D`     | `Performance-monitoring counter`                         |
  | `HPMCOUNTER14`  | `'hC0E`     | `Performance-monitoring counter`                         |
  | `HPMCOUNTER15`  | `'hC0F`     | `Performance-monitoring counter`                         |
  | `HPMCOUNTER16`  | `'hC10`     | `Performance-monitoring counter`                         |
  | `HPMCOUNTER17`  | `'hC11`     | `Performance-monitoring counter`                         |
  | `HPMCOUNTER18`  | `'hC12`     | `Performance-monitoring counter`                         |
  | `HPMCOUNTER19`  | `'hC13`     | `Performance-monitoring counter`                         |
  | `HPMCOUNTER20`  | `'hC14`     | `Performance-monitoring counter`                         |
  | `HPMCOUNTER21`  | `'hC15`     | `Performance-monitoring counter`                         |
  | `HPMCOUNTER22`  | `'hC16`     | `Performance-monitoring counter`                         |
  | `HPMCOUNTER23`  | `'hC17`     | `Performance-monitoring counter`                         |
  | `HPMCOUNTER24`  | `'hC18`     | `Performance-monitoring counter`                         |
  | `HPMCOUNTER25`  | `'hC19`     | `Performance-monitoring counter`                         |
  | `HPMCOUNTER26`  | `'hC1A`     | `Performance-monitoring counter`                         |
  | `HPMCOUNTER27`  | `'hC1B`     | `Performance-monitoring counter`                         |
  | `HPMCOUNTER28`  | `'hC1C`     | `Performance-monitoring counter`                         |
  | `HPMCOUNTER29`  | `'hC1D`     | `Performance-monitoring counter`                         |
  | `HPMCOUNTER30`  | `'hC1E`     | `Performance-monitoring counter`                         |
  | `HPMCOUNTER31`  | `'hC1F`     | `Performance-monitoring counter`                         |
  | `CYCLEH`        | `'hC80`     | `Upper 32 bits of CYCLE, RV32I only`                     |
  | `TIMEH`         | `'hC81`     | `Upper 32 bits of TIME, RV32I only`                      |
  | `INSTRETH`      | `'hC82`     | `Upper 32 bits of INSTRET, RV32I only`                   |
  | `HPMCOUNTER3H`  | `'hC83`     | `Upper 32 bits of HPMCOUNTER3, RV32I only`               |
  | `HPMCOUNTER4H`  | `'hC84`     | `Upper 32 bits of HPMCOUNTER4, RV32I only`               |
  | `HPMCOUNTER5H`  | `'hC85`     | `Upper 32 bits of HPMCOUNTER5, RV32I only`               |
  | `HPMCOUNTER6H`  | `'hC86`     | `Upper 32 bits of HPMCOUNTER6, RV32I only`               |
  | `HPMCOUNTER7H`  | `'hC87`     | `Upper 32 bits of HPMCOUNTER7, RV32I only`               |
  | `HPMCOUNTER8H`  | `'hC88`     | `Upper 32 bits of HPMCOUNTER8, RV32I only`               |
  | `HPMCOUNTER9H`  | `'hC89`     | `Upper 32 bits of HPMCOUNTER9, RV32I only`               |
  | `HPMCOUNTER10H` | `'hC8A`     | `Upper 32 bits of HPMCOUNTER10, RV32I only`              |
  | `HPMCOUNTER11H` | `'hC8B`     | `Upper 32 bits of HPMCOUNTER11, RV32I only`              |
  | `HPMCOUNTER12H` | `'hC8C`     | `Upper 32 bits of HPMCOUNTER12, RV32I only`              |
  | `HPMCOUNTER13H` | `'hC8D`     | `Upper 32 bits of HPMCOUNTER13, RV32I only`              |
  | `HPMCOUNTER14H` | `'hC8E`     | `Upper 32 bits of HPMCOUNTER14, RV32I only`              |
  | `HPMCOUNTER15H` | `'hC8F`     | `Upper 32 bits of HPMCOUNTER15, RV32I only`              |
  | `HPMCOUNTER16H` | `'hC90`     | `Upper 32 bits of HPMCOUNTER16, RV32I only`              |
  | `HPMCOUNTER17H` | `'hC91`     | `Upper 32 bits of HPMCOUNTER17, RV32I only`              |
  | `HPMCOUNTER18H` | `'hC92`     | `Upper 32 bits of HPMCOUNTER18, RV32I only`              |
  | `HPMCOUNTER19H` | `'hC93`     | `Upper 32 bits of HPMCOUNTER19, RV32I only`              |
  | `HPMCOUNTER20H` | `'hC94`     | `Upper 32 bits of HPMCOUNTER20, RV32I only`              |
  | `HPMCOUNTER21H` | `'hC95`     | `Upper 32 bits of HPMCOUNTER21, RV32I only`              |
  | `HPMCOUNTER22H` | `'hC96`     | `Upper 32 bits of HPMCOUNTER22, RV32I only`              |
  | `HPMCOUNTER23H` | `'hC97`     | `Upper 32 bits of HPMCOUNTER23, RV32I only`              |
  | `HPMCOUNTER24H` | `'hC98`     | `Upper 32 bits of HPMCOUNTER24, RV32I only`              |
  | `HPMCOUNTER25H` | `'hC99`     | `Upper 32 bits of HPMCOUNTER25, RV32I only`              |
  | `HPMCOUNTER26H` | `'hC9A`     | `Upper 32 bits of HPMCOUNTER26, RV32I only`              |
  | `HPMCOUNTER27H` | `'hC9B`     | `Upper 32 bits of HPMCOUNTER27, RV32I only`              |
  | `HPMCOUNTER28H` | `'hC9C`     | `Upper 32 bits of HPMCOUNTER28, RV32I only`              |
  | `HPMCOUNTER29H` | `'hC9D`     | `Upper 32 bits of HPMCOUNTER29, RV32I only`              |
  | `HPMCOUNTER30H` | `'hC9E`     | `Upper 32 bits of HPMCOUNTER30, RV32I only`              |
  | `HPMCOUNTER31H` | `'hC9F`     | `Upper 32 bits of HPMCOUNTER31, RV32I only`              |

#### Supervisor

* **Supervisor Trap Setup**

  | **Register** | **Address** | **Description**                            |
  |:-------------|:------------|:-------------------------------------------|
  | `SSTATUS`    | `'h100`     | `Supervisor status`                        |
  | `SEDELEG`    | `'h102`     | `Supervisor exception delegation register` |
  | `SIDELEG`    | `'h103`     | `Supervisor interrupt delegation register` |
  | `SIE`        | `'h104`     | `Supervisor interrupt-enable register`     |
  | `STVEC`      | `'h105`     | `Supervisor trap-handler base address`     |
  | `SCOUNTEREN` | `'h106`     | `Supervisor counter enable`                |

* **Supervisor Configuration**

  | **Register** | **Address** | **Description**                                 |
  |:-------------|:------------|:------------------------------------------------|
  | `SENVCFG`    | `'h10A`     | `Supervisor environment configuration register` |

* **Supervisor Trap Handling**

  | **Register** | **Address** | **Description**                                 |
  |:-------------|:------------|:------------------------------------------------|
  | `SSCRATCH`   | `'h140`     | `Scratch register for supervisor trap handlers` |
  | `SEPC`       | `'h141`     | `Supervisor exception program counter`          |
  | `SCAUSE`     | `'h142`     | `Supervisor trap cause`                         |
  | `STVAL`      | `'h143`     | `Supervisor bad address or instruction`         |
  | `SIP`        | `'h144`     | `Supervisor interrupt pending`                  |

* **Supervisor Protection and Translation**

  | **Register** | **Address** | **Description**                                 |
  |:-------------|:------------|:------------------------------------------------|
  | `SATP`       | `'h180`     | `Supervisor address translation and protection` |

* **Supervisor Debug/Trace Register**

  | **Register** | **Address** | **Description**                                  |
  |:-------------|:------------|:-------------------------------------------------|
  | `SCONTEXT`   | `'h5A8`     | `Supervisor environment configuration register.` |

#### Hypervisor

* **Hypervisor Trap Setup register**

  | **Register** | **Address** | **Description**                                       |
  |:-------------|:------------|:------------------------------------------------------|
  | `HSTATUS`    | `'h600`     | `Hypervisor status register`                          |
  | `HEDELEG`    | `'h602`     | `Hypervisor exception delegation register`            |
  | `HIDELEG`    | `'h603`     | `Hypervisor interrupt delegation register`            |
  | `HIE`        | `'h604`     | `Hypervisor interrupt-enable register`                |
  | `HCOUNTEREN` | `'h606`     | `Hypervisor counter enable`                           |
  | `HGEIE`      | `'h607`     | `Hypervisor guest external interrupt-enable register` |

* **Hypervisor Trap Handling**

  | **Register** | **Address** | **Description**                               |
  |:-------------|:------------|:----------------------------------------------|
  | `HTVAL`      | `'h643`     | `Hypervisor bad guest physical address`       |
  | `HIP`        | `'h644`     | `Hypervisor interrupt pending`                |
  | `HVIP`       | `'h645`     | `Hypervisor virtual interrupt pending`        |
  | `HTINST`     | `'h64A`     | `Hypervisor trap instruction (transformed)`   |
  | `HGEIP`      | `'hE12`     | `Hypervisor guest external interrupt pending` |

* **Hypervisor configuration**

  | **Register** | **Address** | **Description**                                        |
  |:-------------|:------------|:-------------------------------------------------------|
  | `HENVCFG`    | `'h60A`     | `Hypervisor environment configuration register`        |
  | `HENVCFGH`   | `'h61A`     | `Additional hypervisor env. conf. register, RV32 only` |

* **Hypervisor guest address translation and protection**

  | **Register** | **Address** | **Description**                                       |
  |:-------------|:------------|:------------------------------------------------------|
  | `HGATP`      | `'h680`     | `Hypervisor guest address translation and protection` |

* **Hypervisor Debug/Trace registers**

  | **Register** | **Address** | **Description**                    |
  |:-------------|:------------|:-----------------------------------|
  | `HCONTEXT`   | `'h6A8`     | `Hypervisor-mode context register` |

* **Hypervisor Counter/Timer Virtualization Registers**

  | **Register**  | **Address** | **Description**                               |
  |:--------------|:------------|:----------------------------------------------|
  | `HTIMEDELTA`  | `'h605`     | `Delta for VS/VU-mode timer`                  |
  | `HTIMEDELTAH` | `'h615`     | `Upper 32 bits of htimedelta, HSXLEN=32 only` |

* **Virtual Supervisor Registers**

  | **Register** | **Address** | **Description**                                         |
  |:-------------|:------------|:--------------------------------------------------------|
  | `VSSTATUS`   | `'h200`     | `Virtual supervisor status register`                    |
  | `VSIE`       | `'h204`     | `Virtual supervisor interrupt-enable register`          |
  | `VSTVEC`     | `'h205`     | `Virtual supervisor trap handler base address`          |
  | `VSSCRATCH`  | `'h240`     | `Virtual supervisor scratch register`                   |
  | `VSEPC`      | `'h241`     | `Virtual supervisor exception program counter`          |
  | `VSCAUSE`    | `'h242`     | `Virtual supervisor trap cause`                         |
  | `VSTVAL`     | `'h243`     | `Virtual supervisor bad address or instruction`         |
  | `VSIP`       | `'h244`     | `Virtual supervisor interrupt pending`                  |
  | `VSATP`      | `'h280`     | `Virtual supervisor address translation and protection` |

#### Machine

* **Machine Information Registers**

  | **Register** | **Address** | **Description**                           |
  |:-------------|:------------|:------------------------------------------|
  | `MVENDORID`  | `'hF11`     | `Vendor ID`                               |
  | `MARCHID`    | `'hF12`     | `Architecture ID`                         |
  | `MIMPID`     | `'hF13`     | `Implementation ID`                       |
  | `MHARTID`    | `'hF14`     | `Hardware thread ID`                      |
  | `MCONFIGPTR` | `'hF15`     | `Pointer to configuration data structure` |

* **Machine Trap Setup**

  | **Register** | **Address** | **Description**                                 |
  |:-------------|:------------|:------------------------------------------------|
  | `MSTATUS`    | `'h300`     | `Machine status`                                |
  | `MISA`       | `'h301`     | `ISA and extensions`                            |
  | `MEDELEG`    | `'h302`     | `Machine exception delegation register`         |
  | `MIDELEG`    | `'h303`     | `Machine interrupt delegation register`         |
  | `MIE`        | `'h304`     | `Machine interrupt-enable register`             |
  | `MTVEC`      | `'h305`     | `Machine trap-handler base address`             |
  | `MCOUNTEREN` | `'h306`     | `Machine counter enable`                        |
  | `MSTATUSH`   | `'h310`     | `Additional machine status register, RV32 only` |

* **Machine Trap Handling**

  | **Register** | **Address** | **Description**                              |
  |:-------------|:------------|:---------------------------------------------|
  | `MSCRATCH`   | `'h340`     | `Scratch register for machine trap handlers` |
  | `MEPC`       | `'h341`     | `Machine exception program counter`          |
  | `MCAUSE`     | `'h342`     | `Machine trap cause`                         |
  | `MTVAL`      | `'h343`     | `Machine bad address or instruction`         |
  | `MIP`        | `'h344`     | `Machine interrupt pending`                  |

* **Machine Configuration**

  | **Register** | **Address** | **Description**                                         |
  |:-------------|:------------|:--------------------------------------------------------|
  | `MENVCFG`    | `'h30A`     | `Machine environment configuration register`            |
  | `MENVCFGH`   | `'h31A`     | `Additional machine env. conf. register, RV32 only`     |
  | `MSECCFG`    | `'h747`     | `Machine security configuration register`               |
  | `MSECCFGH`   | `'h757`     | `Additional machine security conf. register, RV32 only` |

* **Machine Memory Protection**

  | **Register**     | **Address** | **Description**                                       |
  |:-----------------|:------------|:------------------------------------------------------|
  | `PMPCFG0`        | `'h3A0`     | `Physical memory protection configuration`            |
  | `PMPCFG1`        | `'h3A1`     | `Physical memory protection configuration, RV32 only` |
  | `PMPCFG2`        | `'h3A2`     | `Physical memory protection configuration`            |
  | `PMPCFG3`        | `'h3A3`     | `Physical memory protection configuration, RV32 only` |
  | `PMPCFG4`        | `'h3A4`     | `Physical memory protection configuration`            |
  | `PMPCFG5`        | `'h3A5`     | `Physical memory protection configuration, RV32 only` |
  | `PMPCFG6`        | `'h3A6`     | `Physical memory protection configuration`            |
  | `PMPCFG7`        | `'h3A7`     | `Physical memory protection configuration, RV32 only` |
  | `PMPCFG8`        | `'h3A8`     | `Physical memory protection configuration`            |
  | `PMPCFG9`        | `'h3A9`     | `Physical memory protection configuration, RV32 only` |
  | `PMPCFG10`       | `'h3AA`     | `Physical memory protection configuration`            |
  | `PMPCFG11`       | `'h3AB`     | `Physical memory protection configuration, RV32 only` |
  | `PMPCFG12`       | `'h3AC`     | `Physical memory protection configuration`            |
  | `PMPCFG13`       | `'h3AD`     | `Physical memory protection configuration, RV32 only` |
  | `PMPCFG14`       | `'h3AE`     | `Physical memory protection configuration`            |
  | `PMPCFG15`       | `'h3AF`     | `Physical memory protection configuration, RV32 only` |
  | `PMPADDR0`       | `'h3B0`     | `Physical memory protection address register`         |
  | `PMPADDR1`       | `'h3B1`     | `Physical memory protection address register`         |
  | `PMPADDR2`       | `'h3B2`     | `Physical memory protection address register`         |
  | `PMPADDR3`       | `'h3B3`     | `Physical memory protection address register`         |
  | `PMPADDR4`       | `'h3B4`     | `Physical memory protection address register`         |
  | `PMPADDR5`       | `'h3B5`     | `Physical memory protection address register`         |
  | `PMPADDR6`       | `'h3B6`     | `Physical memory protection address register`         |
  | `PMPADDR7`       | `'h3B7`     | `Physical memory protection address register`         |
  | `PMPADDR8`       | `'h3B8`     | `Physical memory protection address register`         |
  | `PMPADDR9`       | `'h3B9`     | `Physical memory protection address register`         |
  | `PMPADDR10`      | `'h3BA`     | `Physical memory protection address register`         |
  | `PMPADDR11`      | `'h3BB`     | `Physical memory protection address register`         |
  | `PMPADDR12`      | `'h3BC`     | `Physical memory protection address register`         |
  | `PMPADDR13`      | `'h3BD`     | `Physical memory protection address register`         |
  | `PMPADDR14`      | `'h3BE`     | `Physical memory protection address register`         |
  | `PMPADDR15`      | `'h3BF`     | `Physical memory protection address register`         |
  | `PMPADDR16`      | `'h4C0`     | `Physical memory protection address register`         |
  | `PMPADDR17`      | `'h3C1`     | `Physical memory protection address register`         |
  | `PMPADDR18`      | `'h3C2`     | `Physical memory protection address register`         |
  | `PMPADDR19`      | `'h3C3`     | `Physical memory protection address register`         |
  | `PMPADDR20`      | `'h3C4`     | `Physical memory protection address register`         |
  | `PMPADDR21`      | `'h3C5`     | `Physical memory protection address register`         |
  | `PMPADDR22`      | `'h3C6`     | `Physical memory protection address register`         |
  | `PMPADDR23`      | `'h3C7`     | `Physical memory protection address register`         |
  | `PMPADDR24`      | `'h3C8`     | `Physical memory protection address register`         |
  | `PMPADDR25`      | `'h3C9`     | `Physical memory protection address register`         |
  | `PMPADDR26`      | `'h3CA`     | `Physical memory protection address register`         |
  | `PMPADDR27`      | `'h3CB`     | `Physical memory protection address register`         |
  | `PMPADDR28`      | `'h3CC`     | `Physical memory protection address register`         |
  | `PMPADDR29`      | `'h3CD`     | `Physical memory protection address register`         |
  | `PMPADDR30`      | `'h3CE`     | `Physical memory protection address register`         |
  | `PMPADDR31`      | `'h3CF`     | `Physical memory protection address register`         |
  | `PMPADDR32`      | `'h4D0`     | `Physical memory protection address register`         |
  | `PMPADDR33`      | `'h3D1`     | `Physical memory protection address register`         |
  | `PMPADDR34`      | `'h3D2`     | `Physical memory protection address register`         |
  | `PMPADDR35`      | `'h3D3`     | `Physical memory protection address register`         |
  | `PMPADDR36`      | `'h3D4`     | `Physical memory protection address register`         |
  | `PMPADDR37`      | `'h3D5`     | `Physical memory protection address register`         |
  | `PMPADDR38`      | `'h3D6`     | `Physical memory protection address register`         |
  | `PMPADDR39`      | `'h3D7`     | `Physical memory protection address register`         |
  | `PMPADDR40`      | `'h3D8`     | `Physical memory protection address register`         |
  | `PMPADDR41`      | `'h3D9`     | `Physical memory protection address register`         |
  | `PMPADDR42`      | `'h3DA`     | `Physical memory protection address register`         |
  | `PMPADDR43`      | `'h3DB`     | `Physical memory protection address register`         |
  | `PMPADDR44`      | `'h3DC`     | `Physical memory protection address register`         |
  | `PMPADDR45`      | `'h3DD`     | `Physical memory protection address register`         |
  | `PMPADDR46`      | `'h3DE`     | `Physical memory protection address register`         |
  | `PMPADDR47`      | `'h3DF`     | `Physical memory protection address register`         |
  | `PMPADDR48`      | `'h4E0`     | `Physical memory protection address register`         |
  | `PMPADDR49`      | `'h3E1`     | `Physical memory protection address register`         |
  | `PMPADDR50`      | `'h3E2`     | `Physical memory protection address register`         |
  | `PMPADDR51`      | `'h3E3`     | `Physical memory protection address register`         |
  | `PMPADDR52`      | `'h3E4`     | `Physical memory protection address register`         |
  | `PMPADDR53`      | `'h3E5`     | `Physical memory protection address register`         |
  | `PMPADDR54`      | `'h3E6`     | `Physical memory protection address register`         |
  | `PMPADDR55`      | `'h3E7`     | `Physical memory protection address register`         |
  | `PMPADDR56`      | `'h3E8`     | `Physical memory protection address register`         |
  | `PMPADDR57`      | `'h3E9`     | `Physical memory protection address register`         |
  | `PMPADDR58`      | `'h3EA`     | `Physical memory protection address register`         |
  | `PMPADDR59`      | `'h3EB`     | `Physical memory protection address register`         |
  | `PMPADDR60`      | `'h3EC`     | `Physical memory protection address register`         |
  | `PMPADDR61`      | `'h3ED`     | `Physical memory protection address register`         |
  | `PMPADDR62`      | `'h3EE`     | `Physical memory protection address register`         |
  | `PMPADDR63`      | `'h3EF`     | `Physical memory protection address register`         |
  | `MCYCLE`         | `'hB00`     | `Machine cycle counter`                               |
  | `MINSTRET`       | `'hB02`     | `Machine instructions-retired counter`                |
  | `MHPMCOUNTER3`   | `'hB03`     | `Machine performance-monitoring counter`              |
  | `MHPMCOUNTER4`   | `'hB04`     | `Machine performance-monitoring counter`              |
  | `MHPMCOUNTER5`   | `'hB05`     | `Machine performance-monitoring counter`              |
  | `MHPMCOUNTER6`   | `'hB06`     | `Machine performance-monitoring counter`              |
  | `MHPMCOUNTER7`   | `'hB07`     | `Machine performance-monitoring counter`              |
  | `MHPMCOUNTER8`   | `'hB08`     | `Machine performance-monitoring counter`              |
  | `MHPMCOUNTER9`   | `'hB09`     | `Machine performance-monitoring counter`              |
  | `MHPMCOUNTER10`  | `'hB0A`     | `Machine performance-monitoring counter`              |
  | `MHPMCOUNTER11`  | `'hB0B`     | `Machine performance-monitoring counter`              |
  | `MHPMCOUNTER12`  | `'hB0C`     | `Machine performance-monitoring counter`              |
  | `MHPMCOUNTER13`  | `'hB0D`     | `Machine performance-monitoring counter`              |
  | `MHPMCOUNTER14`  | `'hB0E`     | `Machine performance-monitoring counter`              |
  | `MHPMCOUNTER15`  | `'hB0F`     | `Machine performance-monitoring counter`              |
  | `MHPMCOUNTER16`  | `'hB10`     | `Machine performance-monitoring counter`              |
  | `MHPMCOUNTER17`  | `'hB11`     | `Machine performance-monitoring counter`              |
  | `MHPMCOUNTER18`  | `'hB12`     | `Machine performance-monitoring counter`              |
  | `MHPMCOUNTER19`  | `'hB13`     | `Machine performance-monitoring counter`              |
  | `MHPMCOUNTER20`  | `'hB14`     | `Machine performance-monitoring counter`              |
  | `MHPMCOUNTER21`  | `'hB15`     | `Machine performance-monitoring counter`              |
  | `MHPMCOUNTER22`  | `'hB16`     | `Machine performance-monitoring counter`              |
  | `MHPMCOUNTER23`  | `'hB17`     | `Machine performance-monitoring counter`              |
  | `MHPMCOUNTER24`  | `'hB18`     | `Machine performance-monitoring counter`              |
  | `MHPMCOUNTER25`  | `'hB19`     | `Machine performance-monitoring counter`              |
  | `MHPMCOUNTER26`  | `'hB1A`     | `Machine performance-monitoring counter`              |
  | `MHPMCOUNTER27`  | `'hB1B`     | `Machine performance-monitoring counter`              |
  | `MHPMCOUNTER28`  | `'hB1C`     | `Machine performance-monitoring counter`              |
  | `MHPMCOUNTER29`  | `'hB1D`     | `Machine performance-monitoring counter`              |
  | `MHPMCOUNTER30`  | `'hB1E`     | `Machine performance-monitoring counter`              |
  | `MHPMCOUNTER31`  | `'hB1F`     | `Machine performance-monitoring counter`              |
  | `MCYCLEH`        | `'hB80`     | `Upper 32 bits of MCYCLE, RV32I only`                 |
  | `MINSTRETH`      | `'hB82`     | `Upper 32 bits of MINSTRET, RV32I only`               |
  | `MHPMCOUNTER3H`  | `'hB83`     | `Upper 32 bits of HPMCOUNTER3, RV32I only`            |
  | `MHPMCOUNTER4H`  | `'hB84`     | `Upper 32 bits of HPMCOUNTER4, RV32I only`            |
  | `MHPMCOUNTER5H`  | `'hB85`     | `Upper 32 bits of HPMCOUNTER5, RV32I only`            |
  | `MHPMCOUNTER6H`  | `'hB86`     | `Upper 32 bits of HPMCOUNTER6, RV32I only`            |
  | `MHPMCOUNTER7H`  | `'hB87`     | `Upper 32 bits of HPMCOUNTER7, RV32I only`            |
  | `MHPMCOUNTER8H`  | `'hB88`     | `Upper 32 bits of HPMCOUNTER8, RV32I only`            |
  | `MHPMCOUNTER9H`  | `'hB89`     | `Upper 32 bits of HPMCOUNTER9, RV32I only`            |
  | `MHPMCOUNTER10H` | `'hB8A`     | `Upper 32 bits of HPMCOUNTER10, RV32I only`           |
  | `MHPMCOUNTER11H` | `'hB8B`     | `Upper 32 bits of HPMCOUNTER11, RV32I only`           |
  | `MHPMCOUNTER12H` | `'hB8C`     | `Upper 32 bits of HPMCOUNTER12, RV32I only`           |
  | `MHPMCOUNTER13H` | `'hB8D`     | `Upper 32 bits of HPMCOUNTER13, RV32I only`           |
  | `MHPMCOUNTER14H` | `'hB8E`     | `Upper 32 bits of HPMCOUNTER14, RV32I only`           |
  | `MHPMCOUNTER15H` | `'hB8F`     | `Upper 32 bits of HPMCOUNTER15, RV32I only`           |
  | `MHPMCOUNTER16H` | `'hB90`     | `Upper 32 bits of HPMCOUNTER16, RV32I only`           |
  | `MHPMCOUNTER17H` | `'hB91`     | `Upper 32 bits of HPMCOUNTER17, RV32I only`           |
  | `MHPMCOUNTER18H` | `'hB92`     | `Upper 32 bits of HPMCOUNTER18, RV32I only`           |
  | `MHPMCOUNTER19H` | `'hB93`     | `Upper 32 bits of HPMCOUNTER19, RV32I only`           |
  | `MHPMCOUNTER20H` | `'hB94`     | `Upper 32 bits of HPMCOUNTER20, RV32I only`           |
  | `MHPMCOUNTER21H` | `'hB95`     | `Upper 32 bits of HPMCOUNTER21, RV32I only`           |
  | `MHPMCOUNTER22H` | `'hB96`     | `Upper 32 bits of HPMCOUNTER22, RV32I only`           |
  | `MHPMCOUNTER23H` | `'hB97`     | `Upper 32 bits of HPMCOUNTER23, RV32I only`           |
  | `MHPMCOUNTER24H` | `'hB98`     | `Upper 32 bits of HPMCOUNTER24, RV32I only`           |
  | `MHPMCOUNTER25H` | `'hB99`     | `Upper 32 bits of HPMCOUNTER25, RV32I only`           |
  | `MHPMCOUNTER26H` | `'hB9A`     | `Upper 32 bits of HPMCOUNTER26, RV32I only`           |
  | `MHPMCOUNTER27H` | `'hB9B`     | `Upper 32 bits of HPMCOUNTER27, RV32I only`           |
  | `MHPMCOUNTER28H` | `'hB9C`     | `Upper 32 bits of HPMCOUNTER28, RV32I only`           |
  | `MHPMCOUNTER29H` | `'hB9D`     | `Upper 32 bits of HPMCOUNTER29, RV32I only`           |
  | `MHPMCOUNTER30H` | `'hB9E`     | `Upper 32 bits of HPMCOUNTER30, RV32I only`           |
  | `MHPMCOUNTER31H` | `'hB9F`     | `Upper 32 bits of HPMCOUNTER31, RV32I only`           |
  | `MCOUNTINHIBIT`  | `'h320`     | `Machine counter-inhibit register`                    |
  | `MHPMEVENT3`     | `'h323`     | `Machine performance-monitoring event selector`       |
  | `MHPMEVENT4`     | `'h324`     | `Machine performance-monitoring event selector`       |
  | `MHPMEVENT5`     | `'h325`     | `Machine performance-monitoring event selector`       |
  | `MHPMEVENT6`     | `'h326`     | `Machine performance-monitoring event selector`       |
  | `MHPMEVENT7`     | `'h327`     | `Machine performance-monitoring event selector`       |
  | `MHPMEVENT8`     | `'h328`     | `Machine performance-monitoring event selector`       |
  | `MHPMEVENT9`     | `'h329`     | `Machine performance-monitoring event selector`       |
  | `MHPMEVENT10`    | `'h32A`     | `Machine performance-monitoring event selector`       |
  | `MHPMEVENT11`    | `'h32B`     | `Machine performance-monitoring event selector`       |
  | `MHPMEVENT12`    | `'h32C`     | `Machine performance-monitoring event selector`       |
  | `MHPMEVENT13`    | `'h32D`     | `Machine performance-monitoring event selector`       |
  | `MHPMEVENT14`    | `'h32E`     | `Machine performance-monitoring event selector`       |
  | `MHPMEVENT15`    | `'h32F`     | `Machine performance-monitoring event selector`       |
  | `MHPMEVENT16`    | `'h330`     | `Machine performance-monitoring event selector`       |
  | `MHPMEVENT17`    | `'h331`     | `Machine performance-monitoring event selector`       |
  | `MHPMEVENT18`    | `'h332`     | `Machine performance-monitoring event selector`       |
  | `MHPMEVENT19`    | `'h333`     | `Machine performance-monitoring event selector`       |
  | `MHPMEVENT20`    | `'h334`     | `Machine performance-monitoring event selector`       |
  | `MHPMEVENT21`    | `'h335`     | `Machine performance-monitoring event selector`       |
  | `MHPMEVENT22`    | `'h336`     | `Machine performance-monitoring event selector`       |
  | `MHPMEVENT23`    | `'h337`     | `Machine performance-monitoring event selector`       |
  | `MHPMEVENT24`    | `'h338`     | `Machine performance-monitoring event selector`       |
  | `MHPMEVENT25`    | `'h339`     | `Machine performance-monitoring event selector`       |
  | `MHPMEVENT26`    | `'h33A`     | `Machine performance-monitoring event selector`       |
  | `MHPMEVENT27`    | `'h33B`     | `Machine performance-monitoring event selector`       |
  | `MHPMEVENT28`    | `'h33C`     | `Machine performance-monitoring event selector`       |
  | `MHPMEVENT29`    | `'h33D`     | `Machine performance-monitoring event selector`       |
  | `MHPMEVENT30`    | `'h33E`     | `Machine performance-monitoring event selector`       |
  | `MHPMEVENT31`    | `'h33F`     | `Machine performance-monitoring event selector`       |

* **Debug/Trace Registers (shared with Debug Mode)**

  | **Register** | **Address** | **Description**                            |
  |:-------------|:------------|:-------------------------------------------|
  | `TSELECT`    | `'h7A0`     | `Debug/Trace trigger register select`      |
  | `TDATA1`     | `'h7A1`     | `First Debug/Trace trigger data register`  |
  | `TDATA2`     | `'h7A2`     | `Second Debug/Trace trigger data register` |
  | `TDATA3`     | `'h7A3`     | `Third Debug/Trace trigger data register`  |
  | `TINFO`      | `'h7A4`     | `Debug trigger info register`              |
  | `TCONTROL`   | `'h7A5`     | `Debug trigger control register`           |
  | `MCONTEXT`   | `'h7A8`     | `Machine mode trigger context register`    |
  | `MSCONTEXT`  | `'h7AA`     | `Supervisor mode trigger context register` |

* **Debug Mode Registers**

  | **Register** | **Address** | **Description**                            |
  |:-------------|:------------|:-------------------------------------------|
  | `DCSR`       | `'h7B0`     | `Debug control and status register`        |
  | `DPC`        | `'h7B1`     | `Debug PC`                                 |
  | `DSCRATCH0`  | `'h7B2`     | `Debug scratch register`                   |
  | `DSCRATCH1`  | `'h7B3`     | `Debug scratch register (last one)`        |
