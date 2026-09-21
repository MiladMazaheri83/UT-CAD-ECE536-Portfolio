# Bit-Serial Matrix-Vector Accelerator (Stripes Architecture)

A modular hardware accelerator implemented in RTL Verilog that performs **$8 \times 8$ Matrix by $8 \times 1$ Vector Multiplication** using a bit-serial processing scheme inspired by the **Stripes DNN accelerator**. 

By feeding vector inputs serially (MSB-to-LSB) against parallel matrix elements, this architecture optimizes silicon area and routing complexity compared to traditional parallel multiply-accumulate (MAC) arrays.

---

## Architectural Highlights

- **Stripes Processing Elements (PEs):** Two 4-element PEs compute vector-vector inner products over serial bit-streams using an adder tree, two's-complement sign correction logic on MSB, and a 34-bit accumulator.
- **Resource-Constrained Vector-Matrix Multiplier:** An $8 \times 8 \times 8 \times 1$ matrix-vector multiplication is partitioned across only **two PEs** ($N = 4$ inputs each) scheduled iteratively across matrix rows.
- **Memory Subsystem:** Synchronous memory array ($128 \times 34$-bit) storing 16-bit sign-extended weights, inputs, and final output dot products.
- **Hierarchical Datapath & FSM:** Automatic address generation, register shift chains for serial bit streaming, and a dedicated multi-cycle sequencing controller.

---

## Directory Structure

```plaintext
.
├── src/
│   ├── StripesPE.v             # Bit-serial dot product processing element
│   ├── MmpuDatapath.v          # Datapath (registers, counters, PEs, address gen)
│   ├── MatrixAccelerator.v     # Accelerator controller and datapath integration
│   ├── MmpuTop.v               # Top-level module (Accelerator + Memory)
│   └── test.mem                # Active test memory file (loaded via $readmemh)
├── tb/
│   └── TopTestBench.v          # System verification testbench
├── samples/
│   ├── input_memory_1.mem             # Sample test vector 1
│   ├── sample2.mem             # Sample test vector 2
│   └── sample3.mem             # Sample test vector 3
└── README.md
```

---

## Hardware Interface (`MmpuTop`)

| Port Name | Direction | Width | Description |
| :--- | :---: | :---: | :--- |
| `clk` | Input | 1 | Master clock signal |
| `rst` | Input | 1 | Active-high synchronous system reset |
| `start` | Input | 1 | Initiates the matrix-vector multiplication sequence |
| `done` | Output | 1 | Asserted high when all matrix rows are computed and written |

---

## Setup & Simulation Guide

### 1. Prepare Test Memory File
The simulation memory module reads input vectors and matrix weights from `src/test.mem`.

1. Choose a test input from the `samples/` directory (e.g., `samples/input_memory_1.mem`).
2. Copy its content into a new file named `test.mem` inside the `src/` directory:
   ```bash
   cp samples/input_memory_1.mem src/test.mem
   ```

---

### 2. Run via GUI (ModelSim / QuestaSim)

1. Open **ModelSim** and create a new project:
   - `File` $\rightarrow$ `New` $\rightarrow$ `Project...`
   - Set the working directory to your repository root.
2. **Add Files to Project:**
   - Add all `.v` files from `src/`.
   - Add the testbench from `tb/TopTestBench.v`.
   - Add `src/test.mem` (or ensure `test.mem` resides in the ModelSim working directory where the simulator executes).
3. **Compile:**
   - `Compile` $\rightarrow$ `Compile All`.
4. **Simulate:**
   - `Simulate` $\rightarrow$ `Start Simulation...`
   - Select `work.TopTestBench`.
   - Add waves for: `clk`, `rst`, `start`, `done`, and internal memory signals (`/TopTestBench/dut/Mem/mem`).
   - Run simulation:
     ```tcl
     run -all
     ```

---

### 3. Run via CLI (Automated Script)

You can also run the complete build and verification pipeline directly from your terminal:

```bash
# 1. Prepare memory input
cp samples/input_memory_1.txt src/test.mem

# 2. Initialize ModelSim work library
vlib work

# 3. Compile all source and testbench files
vlog src/*.v tb/*.v

# 4. Copy memory file to working runtime path if needed
cp src/test.mem .

# 5. Run simulation in batch mode
vsim -c -do "run -all; quit -f" work.TopTestBench
```

---

## Verification & Output Inspection

- When execution completes, `done` is asserted high.
- The resulting vector dot products are written back into the high memory region of the internal RAM block (`Mem`).
- In ModelSim, open the **Memory List** (`View` $\rightarrow$ `Memory Data` $\rightarrow$ `/TopTestBench/dut/Mem/mem`) to inspect written output values against expected sample outputs.