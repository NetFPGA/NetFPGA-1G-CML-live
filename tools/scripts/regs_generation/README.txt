Registers Generation - v1
--------------------------

1. Introduction
The registers generation code is intended to generate registers per module (pcore).
It provides an infrastructure for the generation using a spreadsheet and has the following advantages:
- Ease of use
- Additional (and flexible) registers access functionality
- Documentation of module's registers 
- Unified registers coding methodology
- Support of legacy registers coding methodology
- Synchronization between a module and the AXIS bus

2. Files and dependancies
Four files are currently included in the registers generation scheme:
   a) module_generation.xlsm - A spreadsheet used to define the per module registers
   b) regs_template.txt - A text file used as the base for the python code
   c) cpu_sync.v - Synchronization module, static, instantiated by the generated registers module, can be later placed under a pcore
   d) small_async_fifo.v - Asynchronous FIFO, static, instantiated by cpu_sync.v, can be later placed under a pcore

3. Generating Registers
The registers generation is conducted using 2 files: the module generation spreadsheet and the regs_templpate file.
Once a user defined in the spreadsheet the required registers, he presses a button that runs a VBA script (macro).
The script creates a python file: it takes the registers parameters from the spreadsheet and writes them into
a file in python format, and following concatenates regs_template.txt to this file. regs_template contains most of the 
python coding. The result is a python script that can generate the required verilog modules and output files.
Next, the python script is executed, generating several files:
   a) cpu_regs - an instantiation of the registers code, without dedicated logic (somewhat like ipif_regs.v)
      This file also instantiates the axis related modules and cpu_sync.v.
   b) cpu_regs_defines.v - a registers definitions file including parameters such as address, number of bits, etc.
      Used both by the user's logic and cpu_regs.
   c) module_cpu_template.v - This file contains the lines that need to be copied to the user's module, including
      instantiation of cpu_regs and a template for using the registers
   d) module_name.mpd - This file contains lines that need to be copied to the core's mpd file for the generation 
      of the software include (h) file
   e) module_name.tcl - A generated tcl script that is used for for the generation of the software include (h) file.
      It includes the names and addresses (offset only) of all registers.
All the files are created in the local run directory

4. Working with the spreadsheet
   a) open the spreadsheet and make sure in the LibreOffice/Excel that macros are enabled and security settings
      do not block running the VBA code
   b) Select your operating system in F2 dropdown box 
   c) For each register, fill in the following fields:
      - Block name (Col A) - the name of the module/pcore (where the registers are instantiated)
      - Register name (Col B) - must be a single word. For multiple words, concatenate them and use a capital
        letter at the begining of every word.
      - Address offset (Col C) - offset within the block. Use the formula in the example to set the address (Hex,
        typically in gaps of 0x4). Global registers have no offset.
      - Description (Col D) - Register description. Needs to be informative (for documentation purposes).
      - Type (Col E) - Type of the line: Global (register), Reg (Register) or Field (within a register)
      - Bits (Col F) - which bits are used by the register (by default can set to 31:0)
      - Access mode (Col G) - Supported options are: RO - Read Only / ROC - Read Only Clear / WO - Write Only
        WOE - Write Only Event / RWS - Read/Write by SW / RWA - Read/Write by HW and SW / RWCR - Read/Write clear 
        on read / RWCW - Read/Write clear on write
      - Valid for submodules (Col H) - currently RFU, intended to be used where multiple submodules are included
        within the same top module (e.g. Rx queue, Tx queue)
      - Default (Col I) - Default value, the value to be set to the register upon reset
      - Constraints and remarks (Col J) - Open text for general purpose (currenly documentation only)
   d) Each register may have multiple fields, for example for a counter and its overflow bit.
      Registers are marked in blue and fields in white. 
      Fields are referred the same way as for registers, but there is no need to set the address offset.
      Fields are not generated as seperate busses to the user's logic, rather they are part of their register's
      bus.
   e) Last: Press "Generate Registers" (B2)


5. Limitations and unsupported features

Limitations:
   a) The spreadsheet supports MSOffice (Excel) and LibreOffice. Open office is not supported (different macro format).
      Altering the macro code under LibreOffice may cause it to stop working.
      Future versions may (or may not) be migrated to google docs code.
   b) On some OS, the generated python script is not executed by the spreadsheet macro and needs to be executed manually.
   c) Not all fields in the spreadsheet are currently used, some as RFU
   d) The environment is mostly ambivalent to the block name (RFU) and does not generate or support infrastructure modules
      (e.g. mhs, base address usage etc.). Most of this is intentional and not RFU, as the same code may be
      used by multiple blocks / instances within the same desgin.
   e) Only software reset (to a complete block) is currently supported as a global register. Must be the first register.
   f) etc.
   
Unsupported features:
   a) Indirect access and tables are currently not supported
   b) Only a single BAR is currently supported
   c) Synchronization is currently added by default. Future version may choose to allow the user to eliminate it where
      unnecessary.
   d) Generation of RTF/documentation file is currently unsupported
   e) Generation of simulation-friendly output is currently not supported (but easy to add)
   f) Configurable file names and folders are not supported
   g) Fields are currenly not written to the (.v) definition file.
   h) etc.
      

