# SOFTWARE VALIDATION

`INSERT HERE`

## VALIDATION PROCESS

The validation process discussed here is intended to ensure that the derived requirements are correct and complete with respect to the system requirements allocated to the hardware item through the use of a combination of objective and subjective processes. Validation may be conducted before or after the hardware item is available, however, validation is typically conducted throughout the design life cycle.

Note 1: Experience indicates that attention to the development and validation of requirements can identify subtle errors or omissions early in the development cycle and reduce exposure to subsequent redesign or inadequate hardware performance.

The validation process discussed here is not intended to validate the requirements allocated from system requirements since validation of these requirements is assumed to occur as part of the system process. In addition, not all hardware item derived requirements need to be validated.

Design decisions that affect the system safety or functional requirements allocated to other portions of the system should be classified as derived requirements and should be validated. Additionally, design decisions and assumptions that constrain subsequent design tasks should be validated as derived requirements.

Derived requirements that need to be validated should be validated against the system requirements allocated to the hardware item. Derived requirements that are not traceable to a higher level requirement should be validated against the design decision from which they are derived.

Note 2: A design decision to include a separate power supply for circuitry performing a specific function could result in the derivation of requirements to guide the design of that power supply. These derived requirements could include safety requirements based on the failure condition that could result from the fault or failure of the function supported by the circuit that receives power from the power supply. These requirements should be validated.

Another example of a design decision that becomes a derived requirement is the memory address assignments for peripheral devices. There is often no requirements basis for the assignments, however, once made they constrain subsequent design tasks to comply with those assignments in order for the design to function correctly. This derived requirement may not need to be validated.

### Validation Process Objectives

The objectives of the validation process for derived hardware requirements are:

1. Derived hardware requirements against which the hardware item is to be verified are correct and complete.

2. Derived requirements are evaluated for impact on safety.

3. Omissions and errors are fed back to the appropriate processes for resolution.

### Validation Process Activities

The hardware validation objective may be satisfied through a combination of activities, such as reviews, simulation, prototyping, modeling, analysis, service experience, engineering assessment, or the development and execution of tests.

Guidance for validation process activities includes:

1. The derived hardware requirements that need to be validated should be identified.

2. For each requirement that was identified in item 1, the validation completion criteria should be identified and satisfied as shown below:

   1. Each requirement has been validated at some hierarchical level by review, analysis or test.

   2. The review, analysis or test of each requirement is appropriate for validating the requirement, especially with respect to safety.

   3. The review, analysis or test results associated with the validation of each requirement are correct and that discrepancies between actual and expected results are explained. When expected results are not pre-defined as may be the case for reviews and analyses, the results of the validation activity should be consistent with the requirement, especially with respect to safety requirements.

   Note: Validation completion criteria may be based on requirements, safety considerations, operational mode or implementation.

3. The derived requirements should be evaluated for their impact on safety. 

4. The derived hardware requirements should be evaluated for completeness with respect to the system requirements allocated to the hardware item. For the purposes of this process, a set of requirements is complete when all the attributes that have been defined are necessary and all the necessary attributes have been defined.

5. The derived hardware requirements should be evaluated for correctness with respect to the system requirements allocated to the hardware item. For the purposes of this document, a requirement is correct when the requirement is defined without ambiguity and there are no errors in the defined attributes.

6. Traceability between the derived hardware requirements and the validation activities and results should be established.

7. Requirement omissions and errors should be fed back to the appropriate process for resolution.

`INSERT HERE`

## TESTS

`INSERT HERE`

### C Language

`INSERT HERE`

### C++ Language

`INSERT HERE`

### Go Language

`INSERT HERE`

### Rust Language

`INSERT HERE`

## BAREMETAL

`INSERT HERE`

### C Language

`INSERT HERE`

### C++ Language

`INSERT HERE`

### Go Language

`INSERT HERE`

### Rust Language

`INSERT HERE`

## OPERATING SYSTEM

`INSERT HERE`

### C Language

`INSERT HERE`

### C++ Language

`INSERT HERE`

### Go Language

`INSERT HERE`

### Rust Language

`INSERT HERE`

## DISTRIBUTION

`INSERT HERE`

### C Language

`INSERT HERE`

### C++ Language

`INSERT HERE`

### Go Language

`INSERT HERE`

### Rust Language

`INSERT HERE`
