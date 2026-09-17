import sys
from abc import ABC, abstractmethod
from .dfg_creator import BaseNode, OperatorNode, OP_TYPES, IdentifierNode
from typing import List, Set

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
        self.latest_times = self.find_latest_times()
        self.current_time_step = 1

    def find_latest_times(self) -> dict:
        """ Calculates ALAP (As Late As Possible) times for all nodes """
        latest_times = {}
        
        sorted_ops = sorted(self.all_operators, key=lambda x: x.depth, reverse=True)
        
        for node in sorted_ops:
            latest_times[node.id] = self.max_time

        used_by = {node.id: [] for node in self.all_operators}
        for node in self.all_operators:
            for op in node.operands:
                if isinstance(op, OperatorNode):
                    used_by[op.id].append(node)
        
        for node in sorted_ops:
            users = used_by[node.id]
            if not users:
                latest_times[node.id] = self.max_time
            else:
                min_successor_start = float('inf')
                for user in users:
                    min_successor_start = min(min_successor_start, latest_times[user.id])
                latest_times[node.id] = min_successor_start - 1
                
        return latest_times

    def find_candidate_nodes(self) -> List[OperatorNode]:
        candidates = []
        for node in self.all_operators:
            if node.id not in self.scheduled_ids:
                if self.is_node_ready(node):
                    candidates.append(node)
        return candidates

    def select_from_frontier(self, frontier : List[OperatorNode]) -> List[OperatorNode]:
        
        def get_slack(node):
            return self.latest_times[node.id] - self.current_time_step
            
        return sorted(frontier, key=lambda x: (get_slack(x), x.id))

    def _run_scheduling_pass(self, resource_config):
        """ Runs one pass of list scheduling with fixed resources """
        self.scheduled_ids = set()
        self.scheduled_nodes_info = []
        self.current_time_step = 1
        
        ops_count = len(self.all_operators)
        
        while len(self.scheduled_ids) < ops_count:
            if self.current_time_step > self.max_time:
                return False, self.current_time_step 
            
            candidates = self.find_candidate_nodes()
            if not candidates and len(self.scheduled_ids) < ops_count:
                return False, self.current_time_step

            sorted_candidates = self.select_from_frontier(candidates)
            
            available = resource_config.copy()
            res_usage = {op: 1 for op in OP_TYPES}
            
            for node in sorted_candidates:
                op = node.op_type
                if available.get(op, 0) > 0:
                    self.record_scheduled_node(node, self.current_time_step, res_usage[op])
                    available[op] -= 1
                    res_usage[op] += 1
            
            self.current_time_step += 1
            
        return True, self.current_time_step - 1

    def schedule(self) -> None:
        present_ops = set(n.op_type for n in self.all_operators)
        
        current_resources = {}
        for op in OP_TYPES:
            user_val = self.numof_resources.get(op, 0)
            if op in present_ops and user_val == 0:
                current_resources[op] = 1
            else:
                current_resources[op] = user_val
        
        while True:
            success, final_latency = self._run_scheduling_pass(current_resources)
            
            if success:
                self.numof_resources = current_resources
                break
            else:
                for op in present_ops:
                    current_resources[op] += 1
                
                if any(v > 50 for v in current_resources.values()):
                    print("Warning: Resource search diverging. Stopping.")
                    break
