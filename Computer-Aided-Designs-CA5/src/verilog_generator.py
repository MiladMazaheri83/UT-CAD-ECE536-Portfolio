import os
import math
from .dfg_creator import IdentifierNode, OperatorNode, OP_TYPES
from .scheduler import ScheduledNodeInfo

class VerilogGenerator:
    def __init__(self, schedule_info: list[ScheduledNodeInfo], dfg_root):
        self.schedule_info = schedule_info
        self.root = dfg_root
        self.max_time = max(node.scheduled_time for node in schedule_info) if schedule_info else 0
        self.state_width = math.ceil(math.log2(self.max_time + 2)) if self.max_time > 0 else 1
        self.inputs = self._extract_inputs()

    def _extract_inputs(self):
        inputs = set()
        for info in self.schedule_info:
            for operand in info.node.operands:
                if isinstance(operand, IdentifierNode):
                    inputs.add(operand.name)
        return sorted(list(inputs))

    def _get_operand_wire(self, operand):
        if isinstance(operand, IdentifierNode):
            return operand.name
        elif isinstance(operand, OperatorNode):
            return f"w{operand.id}"
        return "0"

    def generate_controller(self):
        width = self.state_width
        verilog = f"""module Controller (
                        input clk,
                        input rst,
                        input start,
                        output reg [{width-1}:0] state,
                        output reg done
                    );

                        parameter IDLE = 0;
                        
                        always @(posedge clk or posedge rst) begin
                            if (rst) begin
                                state <= IDLE;
                                done <= 0;
                            end else begin
                                if (state == IDLE) begin
                                    if (start) begin
                                        state <= 1;
                                        done <= 0;
                                    end
                                end else if (state < {self.max_time}) begin
                                    state <= state + 1;
                                    done <= 0;
                                end else begin
                                    state <= IDLE;
                                    done <= 1;
                                end
                            end
                        end
                    endmodule
                    """
        return verilog

    def generate_datapath(self):
        resource_map = {} 
        for info in self.schedule_info:
            key = (info.node.op_type, info.resource_num)
            if key not in resource_map:
                resource_map[key] = []
            resource_map[key].append(info)

        input_decl = ",\n    ".join([f"input [31:0] {name}" for name in self.inputs])
        
        wire_decls = ""
        reg_decls = ""
        for info in self.schedule_info:
            reg_decls += f"    reg [31:0] w{info.node.id};\n"

        verilog = f"""module Datapath (
                        input clk,
                        input rst,
                        input [{self.state_width-1}:0] state,
                        {input_decl},
                        output [31:0] result
                    );

                    {reg_decls}
                        assign result = w{self.root.id};

                    """
        for (op_type, res_id), users in resource_map.items():
            res_name = f"{op_type}_{res_id}"
            
            verilog += f"    reg [31:0] {res_name}_in1;\n"
            verilog += f"    reg [31:0] {res_name}_in2;\n"
            verilog += f"    wire [31:0] {res_name}_out;\n"

            op_symbol = "+"
            if op_type == "ALU":
                pass 
            
            verilog += f"    always @(*) begin\n"
            verilog += f"        case (state)\n"
            
            for user in users:
                op1 = self._get_operand_wire(user.node.operands[0])
                op2 = self._get_operand_wire(user.node.operands[1])
                verilog += f"            {user.scheduled_time}: begin {res_name}_in1 = {op1}; {res_name}_in2 = {op2}; end\n"
            
            verilog += f"            default: begin {res_name}_in1 = 0; {res_name}_in2 = 0; end\n"
            verilog += f"        endcase\n"
            verilog += f"    end\n"

            verilog += f"    assign {res_name}_out = \n"
            conditions = []
            for user in users:
                import ast
                symbol = "+"
                if isinstance(user.node.op, ast.Sub): symbol = "-"
                elif isinstance(user.node.op, ast.Mult): symbol = "*"
                elif isinstance(user.node.op, ast.Div): symbol = "/"
                elif isinstance(user.node.op, ast.BitAnd): symbol = "&"
                elif isinstance(user.node.op, ast.BitOr): symbol = "|"
                
                conditions.append(f"(state == {user.scheduled_time}) ? ({res_name}_in1 {symbol} {res_name}_in2)")
            
            verilog += " : \n".join(conditions) + " : 0;\n"

            verilog += f"    always @(posedge clk) begin\n"
            for user in users:
                verilog += f"        if (state == {user.scheduled_time}) w{user.node.id} <= {res_name}_out;\n"
            verilog += f"    end\n\n"

        verilog += "endmodule\n"
        return verilog

    def generate_top_module(self):
        input_ports = ",\n        ".join([f".{name}({name})" for name in self.inputs])
        input_decls = ",\n    ".join([f"input [31:0] {name}" for name in self.inputs])

        verilog = f"""module TopModule (
                        input clk,
                        input rst,
                        input start,
                        {input_decls},
                        output [31:0] result,
                        output done
                    );

                        wire [{self.state_width-1}:0] state;

                        Controller ctrl_inst (
                            .clk(clk),
                            .rst(rst),
                            .start(start),
                            .state(state),
                            .done(done)
                        );

                        Datapath dp_inst (
                            .clk(clk),
                            .rst(rst),
                            .state(state),
                            {input_ports},
                            .result(result)
                        );

                    endmodule
                    """
        return verilog

    def write_files(self, folder_path):
        output_dir = os.path.join(folder_path, "codes")
        os.makedirs(output_dir, exist_ok=True)

        with open(os.path.join(output_dir, "controller.v"), "w") as f:
            f.write(self.generate_controller())

        with open(os.path.join(output_dir, "datapath.v"), "w") as f:
            f.write(self.generate_datapath())
            
        with open(os.path.join(output_dir, "top.v"), "w") as f:
            f.write(self.generate_top_module())
