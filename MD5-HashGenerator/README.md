# MD5 Hash Generator — RTL Design & Verification

An RTL-level implementation of a hardware-accelerated **MD5 Hash Generator** designed using a strictly decoupled Datapath/Controller methodology (Huffman model). The design processes a 128-bit block message through 64 transformation rounds utilizing an integrated LFSR-based pseudo-random word selector, non-linear bitwise round functions ($F, G, H, I$), left-rotation units, and a memory-mapped constants ROM (`constant.mem`).

Designed and verified using ModelSim / QuestaSim.

---

## Architectural Overview

The design consists of two main synchronous subsystems communicating via handshaking flags:
1. **Hash Engine (`HashGenerator`):**
   - **Controller (`HG_ctl`):** A 10-state FSM that handles module initialization, coordinates message latching, ROM access, arithmetic step scheduling, and final hash digest generation.
   - **Datapath (`HG_dp`):** Contains four 32-bit message registers ($M_0$ to $M_3$), four 32-bit state registers ($A, B, C, D$), non-linear boolean round function selection logic, 32-bit left rotators, step/round counters, and constants ROM interface.
2. **Pseudo-Random Generator (`RandomGenerator`):**
   - Implements an LFSR with polynomial feedback $fb = bit_5 \oplus bit_3 \oplus bit_1$ driven by its own dedicated 5-state controller and datapath to generate 2-bit pseudo-random indices selecting the active message word for each round.

---

## Directory Structure

```plaintext
.
├── src/
│   ├── HashGenerator.v             # Top-level integration module
│   ├── HashGeneratorController.v   # FSM controller for the hash engine
│   ├── HashGeneratorDatapath.v     # Datapath (ALU, registers, rotators)
│   ├── RandomGenerator.v           # LFSR random subsystem top
│   ├── RandomGeneratorController.v # LFSR controller FSM
│   └── RandomGeneratorDatapath.v   # LFSR registers and feedback logic
├── tb/
│   └── TopTestBench.v              # Verification testbench
├── data/
│   └── constant.mem                # 64 x 32-bit MD5 constant values
└── README.md
```

---

## Specifications & Interfaces

### Top-Level Port Definitions (`HashGenerator`)

| Port Name | Direction | Bit-Width | Description |
| :--- | :---: | :---: | :--- |
| `clk` | Input | 1 | Master clock signal |
| `rst` | Input | 1 | Active-high synchronous reset |
| `start` | Input | 1 | Single-cycle pulse initiating hash execution |
| `inp` | Input | 128 | Input message block ($4 \times 32$-bit words) |
| `aInit` | Input | 32 | Initial state vector $A$ (`0x67452301`) |
| `bInit` | Input | 32 | Initial state vector $B$ (`0xEFCDAB89`) |
| `cInit` | Input | 32 | Initial state vector $C$ (`0x98BADCFE`) |
| `dInit` | Input | 32 | Initial state vector $D$ (`0x10325476`) |
| `done` | Output | 1 | High assertion flag signaling completion |
| `out` | Output | 128 | Computed 128-bit MD5 digest $\{A, B, C, D\}$ |

---

## Simulation & Verification Guide

### Option 1: GUI-Based (ModelSim / QuestaSim)

1. **Launch ModelSim** and create a new project:
   - `File` $\rightarrow$ `New` $\rightarrow$ `Project...`
   - Set project location and name (e.g., `MD5_Project`).
2. **Add Source Files:**
   - Add all Verilog design files from `src/` and testbench from `tb/`.
3. **Configure Memory Path:**
   - Copy `data/constant.mem` to the root working directory of your ModelSim project (where simulation runs, usually next to the `.mpf` file) so `$readmemh` can locate it.
4. **Compile:**
   - Click `Compile` $\rightarrow$ `Compile All`. Ensure zero errors.
5. **Simulate:**
   - Go to `Simulate` $\rightarrow$ `Start Simulation...`.
   - Expand the `work` library and select `TopTestBench`.
   - Add necessary wave signals: `clk`, `rst`, `start`, `inp`, `out`, `done`.
   - Run simulation: `run -all` (or run for at least `15000 ns`).

---

### Option 2: CLI-Based Execution (vsim / ModelSim)

You can run the full automated verification pipeline directly from the command line:

```bash
# 1. Create work library
vlib work

# 2. Compile design and testbench files
vlog src/*.v tb/TopTestBench.v

# 3. Ensure memory file is accessible in current working directory
cp data/constant.mem .

# 4. Run testbench in console mode
vsim -c -do "run -all; quit -f" work.TopTestBench
```

---

## Expected Verification Results

When driven with default IVs and the project test vector, the engine completes all 64 steps and asserts `done` at approximately **12,415 ns**:

```plaintext
============================================================
              MD5 HASH ENGINE VERIFICATION RESULT           
============================================================
Input Data Block : 128-bit block data
Computed Digest  : c6f6c75d2bbbb9a586cf3291347acdce
Expected Digest  : c6f6c75d2bbbb9a586cf3291347acdce
Simulation Time  : 12415 ns
Status           : >> TEST PASSED <<
============================================================
```