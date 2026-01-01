import os
import ast
from .scheduler import ScheduledNodeInfo
from .dfg_creator import IdentifierNode, OperatorNode

class VerilogGenerator:
    def __init__(self, schedule_info: list[ScheduledNodeInfo]):
        self.schedule_info = schedule_info
        self.max_time = max((item.scheduled_time for item in schedule_info), default=0)
        self.inputs = self._extract_inputs()
        self.resources = self._group_by_resource()
        self.output_node_id = self._find_output_node()
        
        self.op_str_map = {
            ast.Add: "+", ast.Sub: "-",
            ast.Mult: "*", ast.Div: "/", ast.Mod: "%",
            ast.BitAnd: "&", ast.BitOr: "|", ast.BitXor: "^"
        }

    def _extract_inputs(self):
        inputs = set()
        for info in self.schedule_info:
            for operand in info.node.operands:
                if isinstance(operand, IdentifierNode):
                    inputs.add(operand.name)
        return sorted(list(inputs))

    def _group_by_resource(self):
        resources = {}
        for info in self.schedule_info:
            key = (info.node.op_type, info.resource_num)
            if key not in resources:
                resources[key] = []
            resources[key].append(info)
        return resources

    def _find_output_node(self):
        sorted_nodes = sorted(self.schedule_info, key=lambda x: (x.scheduled_time, x.node.id), reverse=True)
        if sorted_nodes:
            return sorted_nodes[0].node.id
        return -1

    def _get_operand_wire(self, operand):
        if isinstance(operand, IdentifierNode):
            return operand.name
        elif isinstance(operand, OperatorNode):
            return f"r_{operand.id}"
        return "0"

    def generate_controller(self):
        width = (self.max_time).bit_length()
        if width == 0: width = 1
        
        lines = []
        lines.append(f"module controller(")
        lines.append(f"    input clk,")
        lines.append(f"    input rst,")
        lines.append(f"    input start,")
        lines.append(f"    output reg [{width-1}:0] state,")
        lines.append(f"    output reg done")
        lines.append(f");")
        lines.append(f"    parameter IDLE = 0;")
        lines.append(f"")
        lines.append(f"    always @(posedge clk or posedge rst) begin")
        lines.append(f"        if (rst) begin")
        lines.append(f"            state <= IDLE;")
        lines.append(f"            done <= 0;")
        lines.append(f"        end else begin")
        lines.append(f"            case (state)")
        lines.append(f"                IDLE: begin")
        lines.append(f"                    done <= 0;")
        lines.append(f"                    if (start) state <= 1;")
        lines.append(f"                end")
        lines.append(f"                {self.max_time}: begin")
        lines.append(f"                    state <= IDLE;")
        lines.append(f"                    done <= 1;")
        lines.append(f"                end")
        lines.append(f"                default: state <= state + 1;")
        lines.append(f"            endcase")
        lines.append(f"        end")
        lines.append(f"    end")
        lines.append(f"endmodule")
        return "\n".join(lines)

    def generate_datapath(self):
        state_width = (self.max_time).bit_length()
        if state_width == 0: state_width = 1

        lines = []
        input_ports = ", ".join([f"input [31:0] {name}" for name in self.inputs])
        
        lines.append(f"module datapath(")
        lines.append(f"    input clk,")
        lines.append(f"    input rst,")
        lines.append(f"    input [{state_width-1}:0] state,")
        lines.append(f"    {input_ports},")
        lines.append(f"    output [31:0] result")
        lines.append(f");")
        lines.append(f"")

        for info in self.schedule_info:
            lines.append(f"    reg [31:0] r_{info.node.id};")
        
        lines.append(f"")

        for (res_type, res_num), nodes in self.resources.items():
            res_name = f"{res_type}_{res_num}"
            
            lines.append(f"    wire [31:0] {res_name}_left;")
            lines.append(f"    wire [31:0] {res_name}_right;")
            lines.append(f"    wire [31:0] {res_name}_res;")
            
            left_mux_logic = []
            for node_info in nodes:
                op_val = self._get_operand_wire(node_info.node.operands[0])
                left_mux_logic.append(f"(state == {node_info.scheduled_time}) ? {op_val}")
            
            lines.append(f"    assign {res_name}_left = {' : '.join(left_mux_logic)} : 32'd0;")

            right_mux_logic = []
            for node_info in nodes:
                op_val = self._get_operand_wire(node_info.node.operands[1])
                right_mux_logic.append(f"(state == {node_info.scheduled_time}) ? {op_val}")
            
            lines.append(f"    assign {res_name}_right = {' : '.join(right_mux_logic)} : 32'd0;")

            op_logic = []
            for node_info in nodes:
                verilog_op = self.op_str_map.get(type(node_info.node.op), "+")
                logic_expr = f"{res_name}_left {verilog_op} {res_name}_right"
                op_logic.append(f"(state == {node_info.scheduled_time}) ? ({logic_expr})")
            
            lines.append(f"    assign {res_name}_res = {' : '.join(op_logic)} : 32'd0;")
            lines.append(f"")

        lines.append(f"    always @(posedge clk or posedge rst) begin")
        lines.append(f"        if (rst) begin")
        for info in self.schedule_info:
            lines.append(f"            r_{info.node.id} <= 0;")
        lines.append(f"        end else begin")
        
        for info in self.schedule_info:
            res_name = f"{info.node.op_type}_{info.resource_num}"
            lines.append(f"            if (state == {info.scheduled_time}) r_{info.node.id} <= {res_name}_res;")
            
        lines.append(f"        end")
        lines.append(f"    end")
        lines.append(f"")
        
        if self.output_node_id != -1:
            lines.append(f"    assign result = r_{self.output_node_id};")
        else:
            lines.append(f"    assign result = 0;")

        lines.append(f"endmodule")
        return "\n".join(lines)

    def write_files(self, folder_path):
        codes_path = os.path.join(folder_path, "codes")
        os.makedirs(codes_path, exist_ok=True)
        
        with open(os.path.join(codes_path, "controller.v"), "w") as f:
            f.write(self.generate_controller())
            
        with open(os.path.join(codes_path, "datapath.v"), "w") as f:
            f.write(self.generate_datapath())
