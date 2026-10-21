# SOFTWARE DESIGN

`INSERT HERE`

## SOFTWARE DESIGN PROCESS

The software high-level requirements are refined through one or more iterations in the software design process to develop the software architecture and the low-level requirements that can be used to implement Source Code.

### Software Design Process Objectives

The objectives of the software design process are:

   1. The software architecture and low-level requirements are developed from the high-level requirements.

   2. Derived low-level requirements are provided to the system safety assessment process.

### Software Design Process Activities

The software design process inputs are the Software Requirements Data, the Software Development Plan and the Software Design Standards. When the planned transition criteria have been satisfied, the high-level requirements are used in the design process to develop software architecture and low-level requirements. This may involve one or more lower levels of requirements.

The primary output of the process is the Design Description (subsection I 1. 10) which includes the software architecture and the low-level requirements.

The software design process is complete when its objectives and the objectives of the integral processes associated with it are satisfied. Guidance for this process includes:

   1. Low-level requirements and software architecture developed during the software design process should conform to the Software Design Standards and be traceable, verifiable and consistent

   2. Derived requirements should be defined and analyzed to ensure that the higher level requirements are not compromised.

   3. Software design process activities could introduce possible modes of failure into the software or, conversely, preclude others. The use of partitioning or other architectural means in the software design may alter the software level assignment for some components of the software. In such cases, additional data should be defined as derived requirements and provided to the s ystem safety assessment process.

   4. Control flow and data flow should be monitored when safety-related requirements dictate, for example, watchdog timers, reasonableness-checks and cross-channel comparisons.

   5. Responses to failure conditions should be consistent with the safety-related requirements.

   6. Inadequate or incorrect inputs detected during the software design process should be provided to either the system life cycle process, the software requirements process, or the software planning process as feedback for clarification or correction.

   Note: The current state of software engineering does not permit a quantitative correlation between complexity and the attainment of safety objectives. While no objective guidelines can be provided, the software design process should avoid introducing complexity because as the complexity of software increases, it becomes re difficult to verify the design and to show that the safety objectives of the software are satisfied.

### Designing for User-Modifiable Software

Guidance follows concerning the development of software that is designed to be modifiable by its users. A modifiable component is that part of the software that is intended to be changed by the user and a non-modifiable component is that which is not intended to be changed by the user. User-modifiable software may vary in complexity. Examples include a single memory bit used to select one of two equipment options, a table of messages, or a memory area that can be programmed, compiled, and linked for aircraft maintenance functions. Software of any level can include a modifiable component.

Guidance for designing user-modifiable software includes:

   1. The non-modifiable component should be protected from the modifiable component to prevent interference in the safe operation of the non-modifiable component. This protection can be enforced by hardware, by software, by the tools used to make the change, or by a combination of the three.

   2. The applicant-provided means should be shown to be the only means by which the modifiable component can be changed.

## LANGUAGES

`INSERT HERE`

### C Language

`INSERT HERE`

### C++ Language

`INSERT HERE`

### Go Language

`INSERT HERE`

### Rust Language

`INSERT HERE`
