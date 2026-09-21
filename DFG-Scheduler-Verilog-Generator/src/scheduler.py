import sys
from abc import ABC, abstractmethod
from .dfg_creator import BaseNode, OperatorNode, OP_TYPES, IdentifierNode
from typing import List, Set, Dict

class ScheduledNodeInfo:
    def __init__(self, node : OperatorNode, scheduled_time : int, resource_num : int):
        self.node = node
        self.scheduled_time = scheduled_time
        self.resource_num = resource_num

class ListScheduler(ABC):
    def __init__(self, dfg_root : BaseNode, numof_resources : dict):
        self.root = dfg_root
        if numof_resources is None:
            self.numof_resources = {op: 1 for op in OP_TYPES}
        else:
            self.numof_resources = numof_resources.copy()

        self.scheduled_nodes_info : List[ScheduledNodeInfo] = []
        self.scheduled_ids : Set[int] = set()

    def record_scheduled_node(self, node : OperatorNode, scheduled_time : int, resource_num : int):
        recorded_info = ScheduledNodeInfo(node=node, scheduled_time=scheduled_time, resource_num=resource_num)
        self.scheduled_nodes_info.append(recorded_info)
        self.scheduled_ids.add(node.id)

    def get_scheduling_info(self) -> List[ScheduledNodeInfo]:
        return sorted(self.scheduled_nodes_info, key = lambda node_info: node_info.node.id)

    def _get_all_operators(self) -> List[OperatorNode]:
        """ Helper: Returns a list of all OperatorNodes in the graph (DFS) """
        operators = []
        visited = set()
        
        def dfs(node):
            if node is None or node.id in visited:
                return
            visited.add(node.id)
            
            if isinstance(node, OperatorNode):
                for op in node.operands:
                    dfs(op)
                operators.append(node)
            elif isinstance(node, BaseNode):
                 pass

        dfs(self.root)
        return sorted(operators, key=lambda x: x.id)

    def is_node_ready(self, node: OperatorNode) -> bool:
        """ Helper: Checks if all operands of a node are scheduled or are inputs """
        for operand in node.operands:
            if isinstance(operand, OperatorNode):
                if operand.id not in self.scheduled_ids:
                    return False
        return True

    @abstractmethod
    def find_candidate_nodes(self) -> List[OperatorNode]:
        pass

    @abstractmethod
    def select_from_frontier(self, frontier : List[OperatorNode]) -> List[OperatorNode]:
        pass

    @abstractmethod
    def schedule(self) -> None:
        pass


class MinLatencyScheduler(ListScheduler):
    def __init__(self, dfg_root : BaseNode, numof_resources : dict):
        super().__init__(dfg_root=dfg_root, numof_resources=numof_resources)

    def find_candidate_nodes(self) -> List[OperatorNode]:
        all_ops = self._get_all_operators()
        candidates = []
        for node in all_ops:
            if node.id not in self.scheduled_ids:
                if self.is_node_ready(node):
                    candidates.append(node)
        return candidates

    def select_from_frontier(self, frontier : List[OperatorNode]) -> List[OperatorNode]:
        return sorted(frontier, key=lambda x: (-x.depth, x.id))

    def schedule(self) -> None:
        current_time = 1
        all_ops_count = len(self._get_all_operators())

        while len(self.scheduled_ids) < all_ops_count:
            candidates = self.find_candidate_nodes()
            
            sorted_candidates = self.select_from_frontier(candidates)
            available_resources = self.numof_resources.copy()
            
            resource_usage_counter = {op: 1 for op in OP_TYPES}
            scheduled_this_cycle = []

            for node in sorted_candidates:
                op_type = node.op_type
                if available_resources.get(op_type, 0) > 0:
                    res_id = resource_usage_counter[op_type]
                    self.record_scheduled_node(node, current_time, res_id)
                    
                    available_resources[op_type] -= 1
                    resource_usage_counter[op_type] += 1
                    scheduled_this_cycle.append(node)
            
            if not scheduled_this_cycle and not candidates and len(self.scheduled_ids) < all_ops_count:
                print("Error: Deadlock detected or disconnected graph.")
                break
                
            current_time += 1


class MinResourceScheduler(ListScheduler):
    def __init__(self, dfg_root : BaseNode, numof_resources : dict, max_time : int):
        super().__init__(dfg_root=dfg_root, numof_resources=numof_resources)
        self.max_time = max_time
        self.all_operators = self._get_all_operators()

    def find_candidate_nodes(self) -> List[OperatorNode]: return []
    def select_from_frontier(self, frontier : List[OperatorNode]) -> List[OperatorNode]: return []

    def schedule(self) -> None:
        node_map = {n.id: n for n in self.all_operators}
        
        users_map = {n.id: [] for n in self.all_operators}
        unscheduled_users_count = {n.id: 0 for n in self.all_operators}
        
        for node in self.all_operators:
            for op in node.operands:
                if isinstance(op, OperatorNode):
                    users_map[op.id].append(node)
                    unscheduled_users_count[op.id] += 1
        
        ready_list = [n for n in self.all_operators if unscheduled_users_count[n.id] == 0]
        
        current_time = self.max_time
        scheduled_ids = set()
        temp_schedule = {} 
        
        while len(scheduled_ids) < len(self.all_operators):
            ready_list.sort(key=lambda x: x.depth, reverse=True)
            
            selected_nodes = []
            deferred_nodes = [] 
            
            resources_checked = {op: 0 for op in OP_TYPES}
            
            for node in ready_list:
                op_type = node.op_type
                limit = self.numof_resources.get(op_type, 0)
                
                if limit == 0 or resources_checked[op_type] < limit:
                    resources_checked[op_type] += 1
                    selected_nodes.append(node)
                else:
                    deferred_nodes.append(node)
            
            resources_assigned_indices = {op: 0 for op in OP_TYPES}
            
            next_ready_from_dependencies = []

            for node in selected_nodes:
                scheduled_ids.add(node.id)
                op_type = node.op_type
                
                resources_assigned_indices[op_type] += 1
                temp_schedule[node.id] = (current_time, resources_assigned_indices[op_type])
                
                for operand in node.operands:
                    if isinstance(operand, OperatorNode):
                        unscheduled_users_count[operand.id] -= 1
                        if unscheduled_users_count[operand.id] == 0:
                            next_ready_from_dependencies.append(operand)
            
            ready_list = deferred_nodes + next_ready_from_dependencies
            current_time -= 1
            
            if current_time < -10000:
                print("Error: Reverse scheduling loop runaway.")
                break

        if not temp_schedule:
            return

        min_sched_time = min(t for t, _ in temp_schedule.values())
        shift_amount = 1 - min_sched_time
        
        for node_id, (t, r_num) in temp_schedule.items():
            node = node_map[node_id]
            final_time = t + shift_amount
            self.record_scheduled_node(node, final_time, r_num)
