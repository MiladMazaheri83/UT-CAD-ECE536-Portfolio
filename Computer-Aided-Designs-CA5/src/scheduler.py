from abc import ABC, abstractmethod
from .dfg_creator import BaseNode, OperatorNode, IdentifierNode, OP_TYPES
from typing import List, Dict, Set

class ScheduledNodeInfo:
    def __init__(self, node : OperatorNode, scheduled_time : int, resource_num : int):
        self.node = node
        self.scheduled_time = scheduled_time
        self.resource_num = resource_num

class ListScheduler(ABC):
    def __init__(self, dfg_root : BaseNode, numof_reources : dict):
        self.root = dfg_root
        if numof_reources is None:
            self.numof_resources = {op: 1 for op in OP_TYPES}
        else:
            self.numof_resources = numof_reources

        self.scheduled_nodes_info : List[ScheduledNodeInfo] = []
        
        # Shared state for tracking scheduled nodes
        self.scheduled_ids : Set[int] = set()
        
        # Shared helper to get all nodes (useful for both algorithms)
        self.all_operators : List[OperatorNode] = self._get_all_operators(self.root)

    '''
        For a node, records its execution cycle and index of the resource to be executed on.
    '''
    def record_scheduled_node(self, node : OperatorNode, scheduled_time : int, resource_num : int):
        recorded_info = ScheduledNodeInfo(node=node, scheduled_time=scheduled_time, resource_num=resource_num)
        self.scheduled_nodes_info.append(recorded_info)

    '''
        Returns the list of all ScheduledNodeInfos sorted by their node id.
    '''
    def get_scheduling_info(self) -> List[ScheduledNodeInfo]:
        return sorted(self.scheduled_nodes_info, key = lambda node_info: node_info.node.id)

    '''
        Returns a list of nodes that are ready to execute at the time.
        Operands of these nodes are either an IdentifierNode or the result of an already executed OperatorNode.
    '''
    @abstractmethod
    def find_candidate_nodes(self) -> List[OperatorNode]:
        pass

    '''
        Based on the algorithm, it selects nodes from frontier to be executed on the currently available resources.
        Frontier is the output of find_candidate_nodes.
    '''
    @abstractmethod
    def select_from_frontier(self, frontier : dict) -> List[OperatorNode]:
        pass

    '''
        Performes the process of scheduling.
        It repeatedly selects some nodes from frontier to be executed at the time and records their scheduling information until there are no more nodes.
    '''
    @abstractmethod
    def schedule(self) -> None:
        pass

class MinLatencyScheduler(ListScheduler):
    def __init__(self, dfg_root : BaseNode, numof_resources : dict):
        super().__init__(dfg_root=dfg_root, numof_reources=numof_resources)
        self.all_operators = self._get_all_operators(self.root)
        self.scheduled_ids = set()

    '''
        Helper to retrieve all unique OperatorNodes in the graph. 
    '''
    def _get_all_operators(self, node: BaseNode) -> List[OperatorNode]:
        ops = []
        visited = set()
        
        def dfs(n):
            if n is None or n.id in visited:
                return
            visited.add(n.id)
            
            for op in n.operands:
                dfs(op)
                
            if isinstance(n, OperatorNode):
                ops.append(n)
        
        dfs(node)
        return ops

    def find_candidate_nodes(self) -> List[OperatorNode]:
        candidates = []
        for node in self.all_operators:
            if node.id in self.scheduled_ids:
                continue
            
            is_ready = True
            for operand in node.operands:
                if isinstance(operand, IdentifierNode):
                    continue
                elif isinstance(operand, OperatorNode):
                    if operand.id not in self.scheduled_ids:
                        is_ready = False
                        break
            
            if is_ready:
                candidates.append(node)
        return candidates

    def select_from_frontier(self, frontier : dict) -> List[OperatorNode]:
        selected_nodes = []
        
        for res_type, nodes in frontier.items():
            limit = self.numof_resources.get(res_type, 0)
            
            if len(nodes) <= limit:
                selected_nodes.extend(nodes)
            else:
                nodes.sort(key=lambda x: (x.depth, x.id), reverse=True)
                selected_nodes.extend(nodes[:limit])
                
        return selected_nodes

    def schedule(self) -> None:
        current_time = 1
        
        while len(self.scheduled_ids) < len(self.all_operators):
            candidates = self.find_candidate_nodes()
            
            frontier = {op: [] for op in OP_TYPES}
            for node in candidates:
                if node.op_type in frontier:
                    frontier[node.op_type].append(node)
            
            selected = self.select_from_frontier(frontier)
            
            resource_counters = {op: 1 for op in OP_TYPES}
            
            for node in selected:
                res_id = resource_counters[node.op_type]
                resource_counters[node.op_type] += 1
                
                self.record_scheduled_node(node, current_time, res_id)
                self.scheduled_ids.add(node.id)
                
            current_time += 1

class MinResourceScheduler(ListScheduler):
    def __init__(self, dfg_root : BaseNode, numof_resources : dict, max_time : int):
        super().__init__(dfg_root=dfg_root, numof_reources=numof_resources)
        self.max_time = max_time
        self.latest_times = self.find_latest_times()
        self.current_time = 0 

    '''
        Assigns the latest possible time for each node to be executed (ALAP).
    '''
    def find_latest_times(self) -> dict:
        latest = {node.id: float('inf') for node in self.all_operators}
        
        sorted_ops = sorted(self.all_operators, key=lambda x: x.depth)
        
        latest[self.root.id] = self.max_time
        
        for node in sorted_ops:
            parent_deadline = latest[node.id]
            
            for operand in node.operands:
                if isinstance(operand, OperatorNode):
                    current_child_deadline = latest.get(operand.id, float('inf'))
                    latest[operand.id] = min(current_child_deadline, parent_deadline - 1)
                    
        return latest

    def find_candidate_nodes(self) -> List[OperatorNode]:
        candidates = []
        for node in self.all_operators:
            if node.id in self.scheduled_ids:
                continue
            
            if self.is_node_ready(node):
                candidates.append(node)
        return candidates

    def select_from_frontier(self, frontier : dict) -> List[OperatorNode]:
        selected_nodes = []
        
        for res_type, nodes in frontier.items():
            limit = self.numof_resources.get(res_type, 0)
            
            node_slacks = []
            for node in nodes:
                slack = self.latest_times.get(node.id, self.max_time) - self.current_time
                node_slacks.append((slack, node))
            
            node_slacks.sort(key=lambda x: (x[0], x[1].id))
            
            top_nodes = [x[1] for x in node_slacks[:limit]]
            selected_nodes.extend(top_nodes)
            
        return selected_nodes

    def schedule(self) -> None:
        self.current_time = 1
        
        while len(self.scheduled_ids) < len(self.all_operators):
            candidates = self.find_candidate_nodes()
            
            frontier = {op: [] for op in OP_TYPES}
            for node in candidates:
                if node.op_type in frontier:
                    frontier[node.op_type].append(node)
            
            selected = self.select_from_frontier(frontier)
            
            resource_counters = {op: 1 for op in OP_TYPES}
            for node in selected:
                res_id = resource_counters[node.op_type]
                resource_counters[node.op_type] += 1
                
                self.record_scheduled_node(node, self.current_time, res_id)
                
            self.current_time += 1
            
            if self.current_time > self.max_time + 10: 
                print("Warning: Schedule exceeded max_time significantly. Possible deadlock or impossible constraint.")
                break
