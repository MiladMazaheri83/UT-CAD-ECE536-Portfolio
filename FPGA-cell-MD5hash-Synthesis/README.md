# FPGA Cell-Based MD5 Hash Generator Synthesis

A structural RTL implementation and manual technology mapping of a simplified **MD5 Hash Generator** targeting Actel-like fine-grained FPGA logic cells (`c1`, `c2`, `s1`, `s2`).

All primitive operators (Boolean expressions, arithmetic operators, behavioral primitives) are strictly prohibited; every single datapath block, round function, arithmetic adder, multiplier, and FSM controller is composed exclusively from the four provided cell primitives under an area budget constraint of **4800 gates**.

---

## Architectural & Synthesis Highlights

- **Target Cell Library:**
  - **Combinational (`c1`, `c2`):** Configurable multiplexer/logic trees representing function-generator cells.
  - **Sequential (`s1`, `s2`):** Flip-flop and latch cells with integrated multiplexed control.
- **Strict Structural Design:** No Verilog operators (`+`, `*`, `&`, `|`, `^`) or behavioral continuous assignments are used. Everything is structurally mapped down to base cell instances.
- **Area Budget Optimization:**
  - Hard constraint: $\le 4800$ gates.
  - **Achieved synthesis result: 2982 gates** (recorded in `syn/numbers.txt`), well within the limit (~38% under budget).
- **Controller Architecture:**
  - Controllers (Hash Engine & Pseudo-Random Generator) are designed using **One-Hot Encoding** structural state blocks composed of MUXes, basic gate logic mapped to cells, and D-Flip-Flops with synchronous initialization.
- **Hardware Architecture Details:**
  - Scaled down to 4 words of 8-bit values ($32$-bit datapath).
  - Four MD5 non-linear functions ($F, G, H, I$) minimized via Karnaugh maps and mapped to multiplexer-based cells.
  - Custom structural array multipliers ($4 \times 4$) and multibit adders assembled from single-bit half/full adder sub-circuits.

---

## Directory Structure

```plaintext
.
├── c1.cpp                         # Golden functional simulation model for combinational cell C1
├── c2.cpp                         # Golden functional simulation model for combinational cell C2
├── s2-s1.cpp                      # Golden functional simulation model for sequential cells S1/S2
├── data/
│   └── k.mem                      # Constant memory initialization vector for MD5 round constants
├── project_overview/
│   └── CAD-CA3-persian.pdf        # Project specification and assignment requirements
├── syn/
│   ├── numbers.txt                # Post-synthesis gate count report (2982 gates)
│   └── Diagrams/                  # Module schematic diagrams (viewable via draw.io)
├── src/                           # Structural Verilog source files (mapped onto c1, c2, s1, s2)
│   ├── base_cells/                # Primitives: c1.v, c2.v, s1.v, s2.v
│   ├── arithmetic/                # Adder, Multiplier (Mult4to4), Shift registers, Counters
│   ├── datapath/                  # Round logic (F, G, H, I), registers, memory interfaces
│   ├── controller/                # One-hot structural FSMs for Hash Generator & PRNG
│   └── TopHash.v                  # Top-level synthesized MD5 engine
└── tb/
    ├── tb_TopHash.v               # Top-level functional verification testbench
    └── unit_tests/                # Unit testbenches for sub-blocks (adders, multipliers, etc.)
```

> **Note on Schematics:** Comprehensive block-level and gate-level schematics for all datapath units and FSM controllers are provided inside `syn/Diagrams/`. These diagrams can be opened and inspected directly using [draw.io](https://app.diagrams.net/).

---

## Cell Simulation Models (C++ Verification Flow)

The provided C++ reference models are standalone functional simulators for the base cells:

```bash
# Compile golden cell models
g++ c1.cpp -o c1.exe
g++ c2.cpp -o c2.exe
g++ s2-s1.cpp -o s2-s1.exe

# Execute unit verification for cells
./c1.exe
./c2.exe
./s2-s1.exe
```

---

## Simulation & Verification Guide (ModelSim / QuestaSim)

### 1. Compile & Simulate Top-Level System

The ROM/memory block reads initial round constants from `data/k.mem`. Ensure this file is accessible in your simulator's working directory.

#### Via CLI (Batch Mode)
From the repository root:

```bash
# 1. Initialize ModelSim work library
vlib work

# 2. Compile structural source files and testbench
vlog src/base_cells/*.v src/arithmetic/*.v src/datapath/*.v src/controller/*.v src/*.v tb/tb_TopHash.v

# 3. Ensure memory file is in the execution directory
cp data/k.mem .

# 4. Run simulation in batch mode
vsim -c -do "run -all; quit -f" work.tb_TopHash
```

---

#### Via ModelSim GUI

1. Open **ModelSim** and select `File` $\rightarrow$ `New` $\rightarrow$ `Project...`.
2. Set the project location to the repository root.
3. Add all Verilog files from `src/` (including sub-folders) and `tb/tb_TopHash.v`.
4. Copy `data/k.mem` into the project directory (or load it as an existing project file).
5. Compile all files: `Compile` $\rightarrow$ `Compile All`.
6. Start the simulation: `Simulate` $\rightarrow$ `Start Simulation...` $\rightarrow$ select `work.tb_TopHash`.
7. Add relevant signals to waveform: `clk`, `rst`, `start`, `done`, `data_in`, `hash_out`, controller states.
8. Execute:
   ```tcl
   run -all
   ```

---

## Verification Results

The structural implementation was functionally verified against the sample vectors specified in the assignment:

| Test Vector | Input State (`aInit`, `bInit`, `cInit`, `dInit`) & `inp` | Expected Hash Output (`out`) | Status |
| :--- | :--- | :--- | :---: |
| **Case 1** | `aInit=01, bInit=89, cInit=FE, dInit=76`, `inp=3761EDED` | `306749D9` | **Passed** |
| **Case 2** | `aInit=01, bInit=89, cInit=FE, dInit=76`, `inp=0AC78EF7` | `6233A418` | **Passed** |

Sub-modules (including 4-bit array multipliers, 6-bit shift registers, LFSR pseudo-random engines, and 1-bit full adders) were individually validated via dedicated testbenches located in `tb/unit_tests/`.