## DESCRIPTIONS

Data formats in the RISC-V ISA define how various types of data are represented and manipulated within the processor. The ISA supports several fundamental data formats to accommodate different data types and application requirements efficiently.

Integer data formats in RISC-V include:

- **8-bit (byte)**: Used for storing small integers and character data.

- **16-bit (half-word)**: Suitable for short integers and compact data storage.

- **32-bit (word)**: Standard size for integers and memory addresses in many applications.

- **64-bit (double-word)**: Used for larger integers and precise calculations, often in scientific and numerical computing.

These formats provide flexibility in handling different integer sizes while maintaining uniformity in data representation across RISC-V implementations.

RISC-V supports floating-point data formats to enable precise numerical computations:

- **Single-precision (32-bit)**: Uses IEEE 754 standard for representing floating-point numbers with a sign bit, exponent, and fraction field.

- **Double-precision (64-bit)**: Provides extended precision using the same IEEE 754 format but with increased range and precision.

Floating-point formats are essential for applications requiring high accuracy in mathematical calculations, such as scientific simulations, graphics rendering, and financial modeling.

Vector data formats in RISC-V facilitate SIMD (Single Instruction, Multiple Data) operations for parallel processing:

- **Vector length**: Varies depending on the specific extension (e.g., RVV for vector operations).

- **Element size**: Defines the size of each element within the vector (e.g., 8-bit, 16-bit, 32-bit, or 64-bit).

Vector data formats enhance performance by enabling simultaneous processing of multiple data elements, leveraging parallelism to accelerate tasks like multimedia processing, signal processing, and machine learning algorithms.

RISC-V also supports additional data formats tailored for specific applications and extensions:

- **Custom formats**: Defined by extensions such as cryptography (e.g., AES-NI) or specialized accelerators (e.g., tensor operations).

- **Bit-manipulation formats**: Used for bitwise operations and cryptographic algorithms requiring precise bit-level manipulation.

These specialized formats expand the versatility of RISC-V processors, accommodating diverse computing needs and optimizing performance for targeted workloads.

Overall, the design of data formats in the RISC-V ISA emphasizes flexibility, efficiency, and compatibility across different implementations and extensions. By supporting a range of integer, floating-point, vector, and specialized formats, RISC-V enables scalable and efficient processing in various computing environments, from embedded devices to high-performance computing systems.

Format of a line in the table:

`<symbol[,alias]> description>`

| symbol        | description                                             |
|---------------|:--------------------------------------------------------|
| `s8,b`        | `Signed 8-bit Byte`                                     |
| `u8,bu`       | `Unsigned 8-bit Byte`                                   |
| `s16,h`       | `Signed 16-bit Word`                                    |
| `u16,hu`      | `Unsigned 16-bit Half Word`                             |
| `s32,w`       | `Signed 32-bit Word`                                    |
| `u32,wu`      | `Unsigned 32-bit Word`                                  |
| `s64,l,d`     | `Signed 64-bit Word`                                    |
| `u64,lu`      | `Unsigned 64-bit Word`                                  |
| `s128,c,q`    | `Signed 128-bit Word` `c,cu are placeholders for fcvt`  |
| `u128,cu`     | `Unsigned 128-bit Word`                                 |
| `sx`          | `Signed Full Width Word (32, 64 or 128-bit)`            |
| `ux`          | `Unsigned Full width Word (32, 64 or 128-bit)`          |

:Word Type

| symbol        | description                                             |
|---------------|:--------------------------------------------------------|
| `f32,s`       | `Single Precision Floating-point`                       |
| `f64,d`       | `Double Precision Floating-point`                       |
| `f128,q`      | `Quadruple Precision Floating-point`                    |

:Precision Floating-point

| symbol        | description                                             |
|---------------|:--------------------------------------------------------|
| `XLEN`        | `Integer Register Width in Bits (32, 64 or 128)`        |
| `FLEN`        | `Floating-point Register Width in Bits (32, 64 or 128)` |

:Register Width in Bits

| symbol        | description                                             |
|---------------|:--------------------------------------------------------|
| `rd`          | `Integer Register Destination`                          |
| `rs[n]`       | `Integer Register Source [n]`                           |

:Integer Register

| symbol        | description                                             |
|---------------|:--------------------------------------------------------|
| `frd`         | `Floating-Point Register Destination`                   |
| `frs[n]`      | `Floating-Point Register Source [n]`                    |

:Floating-Point Register

| symbol        | description                                             |
|---------------|:--------------------------------------------------------|
| `hart`        | `hardware thread`                                       |
| `pc`          | `Program Counter`                                       |
| `imm`         | `Immediate Value encoded in an instruction`             |
| `offset`      | `Immediate Value decoded as a relative offset`          |
| `shamt`       | `Immediate Value decoded as a shift amount`             |

:Values

| symbol        | description                                             |
|---------------|:--------------------------------------------------------|
| `SP`          | `Single Precision`                                      |
| `DP`          | `Double Precision`                                      |
| `QP`          | `Quadruple Precision`                                   |

:Precision

| symbol        | description                                             |
|---------------|:--------------------------------------------------------|
| `M`           | `Machine`                                               |
| `U`           | `User`                                                  |
| `S`           | `Supervisor`                                            |
| `H`           | `Hypervisor`                                            |

:Privilege Modes I

| symbol        | description                                             |
|---------------|:--------------------------------------------------------|
| `ABI`         | `Application Binary Interface`                          |
| `AEE`         | `Application Execution Environment`                     |
| `SBI`         | `Supervisor Binary Interface`                           |
| `SEE`         | `Supervisor Execution Environment`                      |
| `HBI`         | `Hypervisor Binary Interface`                           |
| `HEE`         | `Hypervisor Execution Environment`                      |

:Privilege Modes II

| symbol        | description                                             |
|---------------|:--------------------------------------------------------|
| `CSR`         | `Control and Status Register`                           |

:Control and Status Register

| symbol        | description                                             |
|---------------|:--------------------------------------------------------|
| `PA`          | `Physical Address`                                      |
| `VA`          | `Virtual Address`                                       |
| `PPN`         | `Physical Page Number`                                  |

:Address & Page Number

| symbol        | description                                             |
|---------------|:--------------------------------------------------------|
| `ASID`        | `Address Space Identifier`                              |
| `PDID`        | `Protection Domain Identifier`                          |
| `PMA`         | `Physical Memory Attribute`                             |
| `PMP`         | `Physical Memory Protection`                            |
| `PPN`         | `Physical Page Number`                                  |
| `VPN`         | `Virtual Page Number`                                   |
| `VCLN`        | `Virtual Cache Line Number`                             |

:Physical & Virtual
