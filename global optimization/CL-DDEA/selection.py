# -*- coding: utf-8 -*-

import numpy as np
import queue
from reg import RegModel

def get_graph_indegrees(graph):
    # compute the in-degree: indegrees[i] = np.sum(graph[:, i])
    return np.count_nonzero(graph, axis=0) # equal to indegrees = np.sum(graph, axis=0)

def build_regression_model(pop, config):
    """
    Args:
        pop: population
        pop_y: the evaluation of `pop`, the smallest the better
        config: configuration
    
    Todo:
        pop_y is unused
    """

    x, y = config["samples"]
    
    config["reg_model"] = RegModel()
    config["reg_model"].set_pop(pop)
    config["reg_model"].fit(x, y)


def select(pop, config):
    """
    Args:
        pop: population
        config: configuration
    Return
        The top n solutions in the `pop` predicted by model_class and model_reg
    """

    graph = config["cmp_model"].predict_to_graph(pop)

    build_regression_model(pop, config)
    y_reg = config["reg_model"].predict(pop).reshape(-1)


    # fix the grap
    for i in range(len(pop)):
        for j in range(i + 1, len(pop)):
            if graph[i][j] == graph[j][i]:
                tmp = (y_reg[i] < y_reg[j])
                graph[i][j] = tmp
                graph[j][i] = not tmp

    return topological_sort(graph, y_reg, config)

def topological_sort(graph, y_reg, config):
    """topological sort variant
    To get the rank of the solutions by pairwise relation. The basic idea is topological sort and greedy algorithm
    
    Args:
        graph: a adjacency matrix, graph[i, j] = 1 means as follow
            1. solution i is better than solution j
            2. there is a edge from i to j
        y_reg: regression model prediction

    Return:
        The solution id of top `top_n` solutions
    
    Note:
        This method will modify the value of graph
    """
    # compute the in-degree
    indegrees = get_graph_indegrees(graph)

    # REMOVED is a tag.
    # If the in-degree of a vertex is REMOVED, it means that this vertex has been removed
    # Setting REMOVED to an infinite number is to make it easier to find the vertex with a smaller in-degree when topological sorting encounter conflict in the later steps.
    REMOVED = np.iinfo(graph.dtype).max

    # init the queue
    q = queue.Queue()

    # topological sort
    ret = []
    while(len(ret) < config["pop_size"]):
        if q.empty():
            # When to use y_reg:
            #     1. When the minimum in-degree of remaining vertices is relatively large, it indicates that there is a large error in the classification model
            #     2. There are multiple minimum in-degree vertices

            min_indegree = np.min(indegrees)
            # n_remain_vertices is the number of remaining vertices
            n_remain_vertices = np.sum(indegrees != REMOVED)

            # threshold is hyperparameter, it is used to indicate when to use the second indicator
            threshold = int(n_remain_vertices * 0.3)

            candidate_vertices = np.argwhere(indegrees == min_indegree).reshape(-1)

            if min_indegree >= threshold or candidate_vertices.size > 1:
                # Select the vertex with the smallest y_reg value among the remaining vertices.
                # If there are more than two vertices, the vertex with smallest id will be selected
                y_mask = np.ma.array(y_reg, mask=(indegrees == REMOVED))
                v = np.argmin(y_mask)

            else:
                v = candidate_vertices[0]

            # remove all edge to v
            graph[:, v] = 0
            # update the in-degree of v
            indegrees[v] = REMOVED
            q.put(v)

        v = q.get()
        ret.append(v)

        # v_neighbors is a vector that contains id of all neighboring vertices of v
        v_neigbors = np.argwhere(graph[v] != 0).reshape(-1)
        # remove all edge from v
        graph[v] = 0
        # update the in-degree of the neighbors of v
        indegrees[v_neigbors] -= 1
        for u in v_neigbors[indegrees[v_neigbors] == 0]:
            # u is a neighbor of v, and its indegree is 0 (there is no vertices are better than it among the remaining vertices)
            q.put(u)
            # update the in-degree
            indegrees[u] = REMOVED

    return np.array(ret)
