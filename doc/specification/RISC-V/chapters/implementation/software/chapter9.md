# REQUIREMENTS

Software requirements define the expected behavior, features, capabilities, and constraints of a software system. They encompass functional requirements describing what the software must do, non-functional requirements specifying qualities like performance, security, and usability, and interface requirements detailing interactions with users, hardware, or other software systems. Clearly defined requirements are crucial for guiding the design, implementation, testing, and validation phases, ensuring the final software product meets user needs and system objectives.

## SOFTWARE REQUIREMENTS PROCESS

The software requirements process uses the outputs of the system life cycle process to develop the software high-level requirements. These high-level requirements include functional, performance, interface and safety-related requirements.

### Software Requirements Process Objectives

The objectives of the software requirements process are:

   1. High-level requirements are developed.

   2. Derived high-level requirements are indicated to the system safety assessment process.

### Software Requirements Process Activities

Inputs to the software requirements process include the system requirements, the hardware interface and system architecture (if not included in the requirements) from the system life cycle process, and the Software Development Plan and the Software Requirements Standards from the software planning process. When the planned transition criteria have been satisfied, these inputs are used to develop the software high-level requirements.

The primary output of this process is the Software Requirements Data (subsection 11.9).

The software requirements process is complete when its objectives and the objectives of the integral processes associated with it are satisfied. Guidance for this process includes:

   1. The system functional and interface requirements that are allocated to software should be analyze for ambiguities, inconsistencies and undefined conditions.

   2. Inputs to the software requirements process detected as inadequate or incorrect should be reported as feedback to the input source processes for clarification or correction.

   3. Each system requirement that is allocated to software should be specified in the high-level requirements.

   4. High-level requirements that address system requirements allocated to software to preclude system hazards should be defined.

   5. The high-level requirements should conform to the Software Requirements Standards, and be verifiable and consistent.

   6. The high-level requirements should be stated in quantitative terms with tolerances where applicable.

   7. The high-level requirements should not describe design or verification detail except for specified and justified design constraints.

   8. Each system requirement allocated to software should be traceable to one or more software high-level requirements.

   9. Each high-level requirement should be traceable to one or more system requirements, except for derived requirements.

   10. Derived high-level requirements should be provided to the system safety assessment process.

## LANGUAGES

The Software Project WorkFlow outlines the sequence of phases involved in creating and maintaining software. Common workflows like Waterfall, Agile (Scrum, Kanban), or Spiral models typically include stages such as requirements gathering and analysis, system design, implementation (coding), testing (unit, integration, system), deployment, and maintenance. The choice of workflow depends on project complexity, team size, and the need for flexibility or rigorous control.

* Software Project WorkFlow

  ![Software Project WorkFlow](assets/chapter9/software-project.svg){height=7cm}

DevOps, often represented in a similar structure to the Hardware DevOps table shown, integrates software development (Dev) and IT operations (Ops) to shorten the systems development life cycle and provide continuous delivery with high software quality. It emphasizes automation, collaboration, and monitoring throughout all software lifecycle phases, from initial coding and testing through deployment and infrastructure management, aiming for faster, more reliable software releases.

| CONTROL       | DEVELOP       | OPERATION   |
|:--------------|:--------------|:------------|
| certification | model         | sim         |
| doc           | rtl/src       | compilation |
| quality       | configuration | synthesis   |
| requirements  | validation    |             |
|               | verification  |             |

:Hardware DevOps

The Front-End CoDesign Project WorkFlow, when applied to systems involving both hardware and software, focuses on the initial design stages where decisions about partitioning functionality between hardware and software are critical. For the software aspect, this involves defining high-level software architecture, specifying interfaces with hardware components, developing behavioral models, and performing early simulations or analysis to ensure the software components will meet system-level requirements in conjunction with the hardware.

![Front-End CoDesign Project WorkFlow](assets/chapter9/front-codesign-project.svg){height=7cm}

The Back-End CoDesign Project WorkFlow pertains to the detailed implementation and integration phases following the initial architectural decisions. For software, this involves writing the source code based on the defined architecture and requirements, compiling the code for the target hardware platform, performing unit and integration testing, debugging, and optimizing performance. Close coordination with hardware development is necessary to ensure correct interaction across the hardware-software interface.

![Back-End CoDesign Project WorkFlow](assets/chapter9/back-codesign-project.svg){height=7cm}

The progression from requirements to final compiled code represents a continuous refinement and increase in detail. Abstract requirements defining user needs and system functions are translated into architectural models, then into specific source code implementing the logic, followed by configuration settings for the compiler and build environment, ultimately resulting in executable machine code or bytecode after compilation. Each step adds concrete implementation details to the preceding abstract description.

   * details(**requirements**) < details(**model**) < details(**rtl**) < details(**configuration**) < details(**synthesis**)
   * details(**requirements**) < details(**model**) < details(**src**) < details(**configuration**) < details(**compilation**)
   * details(**validation**) < details(**verification**) < details(**sim**)

In software development, validation ensures that the software meets the user's needs and requirements (building the right product), often involving user acceptance testing. Verification confirms that the software is built according to its specifications and design (building the product right), typically through activities like code reviews, static analysis, and various levels of testing. Simulation, while less common in general software than in hardware or embedded systems, can be used in specific domains (e.g., network protocols, complex algorithms) as part of verification to model and test behavior under controlled conditions.

### Unified Modeling Language

The Unified Modeling Language (UML) is a widely adopted standard in software engineering for creating visual models of software systems. It provides a rich set of diagram types to represent different aspects of the software, including its structure, behavior, interactions, and deployment, facilitating communication among stakeholders, aiding in design decisions, and serving as documentation for the system.

   * **Structural UML diagrams** (for Architecture and Interface)
      - Class diagram
      - Component diagram
      - Composite diagram
      - Deployment diagram
      - Object diagram
      - Package diagram
      - Profile diagram

Structural UML diagrams focus on the static organization of a software system. Class diagrams model the classes, attributes, operations, and relationships between them. Component diagrams show the modular parts of the system and their dependencies. Deployment diagrams illustrate the physical deployment of software artifacts onto hardware nodes. These diagrams are essential for defining the software architecture and interfaces between different parts of the system.

   * **Behavioral UML diagrams** (for Functionality and Registers and Interruptions)
      - Activity diagram
      - Communication diagram
      - Interaction diagram
      - Sequence diagram
      - State diagram
      - Timing diagram
      - Use diagram

Behavioral UML diagrams describe the dynamic aspects of a software system. Use Case diagrams capture functional requirements from a user's perspective. Sequence and Communication diagrams illustrate interactions between objects over time. State Machine diagrams model the lifecycle of objects and their responses to events. Activity diagrams represent workflows and operational logic. These diagrams help specify and understand the software's functionality and runtime behavior, including how it handles events or interacts with low-level elements like registers if applicable in embedded contexts.

![UML Diagrams Overview](assets/chapter9/uml_diagrams_overview.svg){height=5cm}

The UML Diagrams Overview provides a conceptual map of the various diagram types available within the UML standard, grouping them into structural and behavioral categories. This helps software engineers select the appropriate modeling tool for the task at hand, whether it's defining the static architecture, detailing object interactions, specifying system functionality, or modeling dynamic behavior, thereby promoting clarity and consistency in software design and documentation.

### Property Specification Language

While Property Specification Language (PSL) is primarily used in hardware verification, the concept of formally specifying properties is also relevant in software. Similar goals are achieved using techniques like Design by Contract, assertion libraries available in many programming languages (e.g., Java's `assert`, Python's `assert`), or formal specification languages like Object Constraint Language (OCL) used with UML models, or dedicated formal methods tools (e.g., using Z notation, VDM, TLA+). These allow developers to precisely state invariants, pre-conditions, and post-conditions to improve software correctness and enable more rigorous verification.

### Python Language

Python is a highly versatile and widely used programming language in software development across various domains. Its clear syntax, extensive standard library, and vast ecosystem of third-party packages make it suitable for web development, data science, artificial intelligence, scripting, automation, scientific computing, and more. In the context of software engineering processes, it's frequently used for build automation, testing frameworks, utility scripts, rapid prototyping, and increasingly as the primary language for application development.

### Matlab Language

Matlab and its graphical environment Simulink are predominantly used in engineering and scientific domains for algorithm development, data analysis, visualization, and numerical computation. In software development, they are particularly valuable for model-based design, especially in areas like control systems, signal processing, and embedded systems. Engineers can model complex system behavior, simulate it, automatically generate C/C++ or HDL code for implementation, and create test harnesses, bridging the gap between system modeling and software/hardware implementation.
