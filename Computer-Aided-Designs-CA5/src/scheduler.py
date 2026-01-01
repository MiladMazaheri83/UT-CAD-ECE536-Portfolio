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

    def _get_all_operators(self, node: BaseNode) -> List[OperatorNode]:
        """ Helper to retrieve all unique OperatorNodes in the graph. """
        ops = []
        visited = set()
        
        def dfs(n):
            if n is None or n.id in visited:
                return
            visited.add(n.id)
            
            # Recurse on children first
            for op in n.operands:
                dfs(op)
                
            if isinstance(n, OperatorNode):
                ops.append(n)
        
        dfs(node)
        return ops

    def is_node_ready(self, node: OperatorNode) -> bool:
        """ Check if a node's operands are all ready. """
        for operand in node.operands:
            if isinstance(operand, IdentifierNode):
                continue # Inputs are always ready
            elif isinstance(operand, OperatorNode):
                if operand.id not in self.scheduled_ids:
                    return False
        return True

    '''
        For a node, records its execution cycle and index of the resource to be executed on.
    '''
    def record_scheduled_node(self, node : OperatorNode, scheduled_time : int, resource_num : int):
        recorded_info = ScheduledNodeInfo(node=node, scheduled_time=scheduled_time, resource_num=resource_num)
        self.scheduled_nodes_info.append(recorded_info)
        self.scheduled_ids.add(node.id)

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

    # TODO
    def find_candidate_nodes(self) -> List[OperatorNode]:
        pass

    # TODO
    def select_from_frontier(self, frontier : dict) -> List[OperatorNode]:
        pass

    # TODO
    def schedule(self) -> None:
        pass


    

    
class MinResourceScheduler(ListScheduler):
    def __init__(self, dfg_root : BaseNode, numof_resources : dict, max_time : int):
        super().__init__(dfg_root=dfg_root, numof_reources=numof_resources)
        self.max_time = max_time
        self.latest_time = self.find_latest_times()


    '''
        Assigns the latest possible time for each node to be executed.
        It's used on Minimum-Resource, Latency-Constrained algorithm.
    '''
    # TODO
    def find_latest_times(self) -> dict:
        latest_time = dict()
        # ...
        return latest_time
   
    # TODO
    def find_candidate_nodes(self) -> List[OperatorNode]:
        pass

    # TODO
    def select_from_frontier(self, frontier : dict) -> List[OperatorNode]:
        pass

    # TODO
    def schedule(self) -> None:
        pass