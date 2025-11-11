# ARM_LEGv8_pipeline
This is an implementation of LEGv8 architecture pipeline, support data forwarding, hazard control using verilog

## Table of contents
+ [**Introduction**](#introduction)
+ [**Architecture**](#Architecture)
+ [**Pipelining with Forwarding and Hazard Detection Unit**](#pipelining-with-forwarding-and-hazard-detection-unit)
+ [**Final Overview**](#final-overview)
+ [**Testing with Instructions**](#testing-with-instructions)
+ [**Expected Results**](#expected-results)
+ [**Instruction Pipeline**](#instruction-pipeline)
+ [**Compilation and Elaboration**](#compilation-and-elaboration)
+ [**Results**](#results)

## Introduction
The ARMv8 architecture is a 64-bit architecture with native support for 32 bit instructions. It has 31 general purpose registers, each 64-bits wide. Compared to this, the 32-bit ARMv7 architecture had 15 general purpose registers, each 32-bits wide. The ARMv8 follows some key design principles:
	
	- Simplicity favours regularity
	- Regularity makes implementation simpler
	- Simplicity enables higher performance at lower cost
	- Smaller is faster
	- Different formats complicate decoding, therefore keep formats as similar as possible
Registers are faster to access than memory. Operating on Data memory requires loads
and stores. This means more instructions need to be executed when data is fetched from Data memory. Therefore more frequent use of registers for variables speeds up execution time.  

The project implementation includes a subset of the core LEGv8 instruction set:

* The memory-reference instructions load register unscaled ( LDUR ) and store register unscaled ( STUR )
* The arithmetic-logical instructions ADD, SUB, AND and ORR
* The instructions compare and branch on zero ( CBZ ) and branch ( B )

## Architecture

Let's start with an abstract view of the CPU. The CPU comprises of a ***Program Counter*** [*PC*], ***Instruction Memory***, ***Register module*** [*Registers*], ***Arithmetic Logic Unit*** [*ALU*] and ***Data Memory***.

The Program Counter or PC reads the instructions from the instruction memory, then modifies the Register module to hold the current instruction. The Registers pass the values in instruction memory to the ALU to perform operations. Depending on the type of operation performed, the result may need to be loaded from or stored to the data memory. If the result needs to be loaded from the data memory, it can be written back to the Register module to perform any further operations.
![](images/Architecture.png)
