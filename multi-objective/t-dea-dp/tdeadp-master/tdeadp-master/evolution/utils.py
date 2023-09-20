import numpy as np
from evolution.norm import obj_normalization
from evolution.dom import pareto_dominance

# several Utility Functions


# evaluate the objective functions and then conduct clustering
def full_evaluate(individuals, toolbox, f_min, f_max):
    fitness_values = toolbox.evaluate(individuals)

    for ind, fv in zip(individuals, fitness_values):
        ind.fitness.values = fv

    obj_normalization(individuals, f_min, f_max)
    toolbox.cluster_scalarization(individuals)

    return f_min, f_max


# read estimated objective limits
def init_obj_limits(f_min, f_max):
    if f_min is None:
        f_min = 0
    else:
        f_min = np.array(f_min)

    if f_max is None:
        f_max = f_min + 1
    else:
        f_max = np.array(f_max)

    return f_min, f_max


def init_scalar_rep(pop):
    rep_individuals = {}

    for ind in pop:
        update_scalar_rep(rep_individuals, ind)

    return rep_individuals


def update_scalar_rep(rep_individuals, ind):
    cid = ind.cluster_id
    rep_ind = rep_individuals.get(cid)

    if rep_ind is None or ind.scalar_dist < rep_ind.scalar_dist:
        rep_individuals[cid] = ind
        print(f"Scalar rep in cluster {cid} is updated")
        return True
    return False


def get_non_dominated_scalar_rep(rep_individuals):
    keys = set()

    for i in rep_individuals:
        for j in rep_individuals:
            if j <= i:
                continue;

            ind1 = rep_individuals[i]
            ind2 = rep_individuals[j]

            r = pareto_dominance(ind1, ind2)
            if r == 1:
                keys.add(j)
            elif r == 2:
                keys.add(i)

    nd_rep_individuals = {}

    for i in rep_individuals:
        if i not in keys:
            nd_rep_individuals[i] = rep_individuals[i]

    return nd_rep_individuals


def get_pareto_rep_ind(s_rep_ind, nd_rep_individuals, ref_points):
    cid = s_rep_ind.cluster_id
    rp = ref_points[cid]

    p_rep_ind = None
    min_dist = float('inf')

    if cid in nd_rep_individuals:
        return s_rep_ind
    else:
        for i in nd_rep_individuals:
            ind = nd_rep_individuals.get(i)
            r = pareto_dominance(ind, s_rep_ind)
            if r == 1:
                dist = np.sum((ref_points[i] - rp)**2)
                if dist < min_dist:
                    min_dist = dist
                    p_rep_ind = ind

    return p_rep_ind


def init_dom_rel_map(size):
    pareto_rel = np.ones([size, size], dtype=np.int8) * (-1)
    scalar_rel = np.ones([size, size], dtype=np.int8) * (-1)
    return pareto_rel, scalar_rel


