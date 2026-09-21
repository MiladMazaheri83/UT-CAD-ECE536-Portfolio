# High-Level Synthesis (HLS) Tool: DFG Scheduling & RTL Verilog Generator

A Python-based High-Level Synthesis (HLS) framework that compiles high-level arithmetic expressions into Data Flow Graphs (DFGs), performs resource- or latency-constrained scheduling, and automatically generates cycle-accurate synthesizable Verilog HDL (Datapath and Controller).

---

## Architectural Workflow

The compilation pipeline translates raw behavioral expressions into hardware descriptions across four distinct stages:

```
Arithmetic Expression
        │
        ▼
[ DFG Creator ]           ──> Generates DAG Nodes (ALU, MUL, LOG, ID)
        │
        ▼
[ DFG Scheduler ]         ──> Applies MLRC or MRLC Scheduling Algorithms
        │
        ▼
[ Graph Visualizer ]      ──> Renders Initial & Scheduled DFG Diagrams
        │
        ▼
[ Verilog Generator ]     ──> Generates Synthesizable Top, Datapath & FSM Controller
```

1. **DFG Construction (`dfg_creator.py`):**
   - Parses arithmetic expressions containing 32-bit operands.
   - Categorizes operations into hardware resource classes:
     - **ALU:** Addition (`+`), Subtraction (`-`)
     - **MUL:** Multiplication (`*`), Division (`/`)
     - **LOG:** Bitwise AND (`&`), Bitwise OR (`|`)
   - Distinguishes input variable nodes (`id`) from operational nodes (`op`) and constructs dependency edges.

2. **Scheduling Engine (`scheduler.py`):**
   - **MLRC (Minimum-Latency, Resource-Constrained):** Minimizes total execution latency given strict caps on available physical functional units (ALU, MUL, LOG).
   - **MRLC (Minimum-Resource, Latency-Constrained):** Minimizes functional unit allocation while satisfying a hard deadline on clock cycles.
   - Binds each operator node to a discrete cycle timestamp (`clk`) and a specific functional unit instance (`res`).

3. **Graph Visualization (`graph_visualizer.py`):**
   - Emits visual graph representations for both the unconstrained DFG and the cycle-annotated scheduled DFG.

4. **Verilog RTL Synthesis (`verilog_generator.py`):**
   - **Datapath Unit:** Allocates 32-bit registers, multiplexer routing networks, and functional execution units based on scheduled resource sharing. Produces the final computation output (`result`) and execution termination flag (`done`).
   - **Controller Unit:** Implements a state machine where each state corresponds directly to an active execution cycle in the schedule.
   - **Top-Level Wrapper:** Connects Datapath and Controller, exposing standard interface signals: `clk`, `rst`, `start`, arithmetic inputs, `result`, and `done`.

---

## Repository Structure

```plaintext
.
├── main.py                     # Primary pipeline entry point
├── project_overview/
│   └── CAD-CA5-persian.pdf     # Tool specifications and assignment reference
├── src/
│   ├── dfg_creator.py          # AST parser and DFG construction
│   ├── graph_visualizer.py     # Graph rendering utilities
│   ├── scheduler.py            # MLRC and MRLC scheduling implementations
│   └── verilog_generator.py    # RTL Verilog generator (Datapath, Controller, Top)
└── samples/
    ├── sample1/
    │   ├── input.json          # Input expression, algorithm selection, and constraints
    │   ├── initial_dfg.png     # Unscheduled DFG visualization (generated)
    │   ├── scheduled_dfg.png   # Resource- and cycle-bound DFG (generated)
    │   ├── output.json         # Scheduling metadata export (generated)
    │   └── *.v                 # Synthesizable RTL Verilog outputs (generated)
    ├── sample2/
    └── ...
```

---

## Configuration (`input.json`)

Each sample test case requires an `input.json` defining the expression and optimization constraints:

### Example: Resource-Constrained Scheduling (MLRC)

```json
{
  "expression": "(i1 + i2) * (i3 - i4) + (i5 & i6)",
  "algorithm": "MLRC",
  "constraints": {
    "alu": 1,
    "mul": 1,
    "log": 1
  }
}
```

### Example: Latency-Constrained Scheduling (MRLC)

```json
{
  "expression": "(i1 + i2) * (i3 - i4) + (i5 & i6)",
  "algorithm": "MRLC",
  "constraints": {
    "latency": 4
  }
}
```

---

## Execution Instructions

Run `main.py` by providing the directory path of the desired target sample:

```bash
# General usage
python main.py <path_to_sample_directory>

# Example: Run sample1
python main.py ./samples/sample1/
```

### Pipeline Artifacts Generated

Running the tool populates the target sample folder with:
- **`initial_dfg.*`**: Topological representation of data dependencies.
- **`scheduled_dfg.*`**: DFG annotated with node assignments (`clk:<cycle>, res:<unit_id>`).
- **`output.json`**: Machine-readable scheduling schedule containing cycle/resource allocations.
- **Synthesizable Verilog Files:** RTL implementation of Datapath, Controller, and Top module.

---

## Hardware Interface Specification

The generated Top-Level Verilog module adheres to the following structural interface:

| Port Name | Direction | Width | Description |
| :--- | :---: | :---: | :--- |
| `clk` | Input | 1 | Global clock signal |
| `rst` | Input | 1 | Synchronous/asynchronous active-high reset |
| `start` | Input | 1 | Asserted to initiate the scheduled computation |
| `i1`, `i2`, ... | Input | 32 | Expression input operands |
| `result` | Output | 32 | Calculated 32-bit final output |
| `done` | Output | 1 | Asserted high when the calculation finishes |

---

## Verification (ModelSim / QuestaSim)

To functionally verify generated RTL against input expressions:

```bash
# 1. Initialize working library
vlib work

# 2. Compile generated Verilog modules and testbench
vlog ./samples/sample1/*.v path/to/tb_top.v

# 3. Execute functional simulation in batch mode
vsim -c -do "run -all; quit -f" work.tb_top
```