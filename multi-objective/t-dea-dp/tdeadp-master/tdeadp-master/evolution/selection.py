import random

import numpy as np

from evolution.dom import scalar_dominance
from evolution.ranking import non_dominated_ranking
from learning.prediction import nn_predict_dom_intra, nn_predict_dom_inter
from evolution.utils import get_pareto_rep_ind
from evolution.visualizer import visualize_preselection

# This file implements preselection and survival selection procedures


# The two-stage preselection procedure
def pareto_scalar_nn_filter(offsprings, rep_individuals, nd_rep_individuals,
                            p_net, s_net, max_size, device, ref_points, counter,
                            toolbox, visualization=False):
    cid = counter()
    s_rep_ind = rep_individuals.get(cid)
    ps_offs, s_offs, p_offs, distinct_offs = [], [], [], []

    if s_rep_ind is not None:
        p_rep_ind = get_pareto_rep_ind(s_rep_ind, nd_rep_individuals, ref_points)
        ps_offs, s_offs, p_offs = find_candidate_individuals(p_rep_ind, s_rep_ind,
                                                             offsprings, p_net, s_net, device, max_size)

        if ps_offs:
            best_ind = select_best_individual(ps_offs, p_net, s_net, device)
        elif s_offs:
            best_ind = select_best_individual(s_offs, p_net, s_net, device)
        elif p_offs:
            best_ind = select_best_individual(p_offs, p_net, s_net, device)
        else:
            best_ind = None
    else:
        rep_ind_list = list(rep_individuals.values())
        distinct_offs = find_distinct_individuals(rep_ind_list, offsprings, s_net, device, max_size)
        if distinct_offs:
            best_ind = select_best_individual(distinct_offs, p_net, s_net, device)
        else:
            best_ind = None

    if visualization:
        visualize_preselection(cid, ref_points, s_rep_ind, list(rep_individuals.values()),
                               ps_offs, s_offs, p_offs, distinct_offs,
                               best_ind, toolbox)

    return best_ind


# find the individuals (among the offsprings) that dominates the representative solutions
def find_candidates(rep_ind, offsprings, net, device, max_size):
    dom_labels, cfs = nn_predict_dom_inter(offsprings, [rep_ind], net, device)

    dom_labels = dom_labels.squeeze()
    cfs = cfs.squeeze()

    individuals = []
    cfs_list = []

    for i in range(len(offsprings)):
        label = dom_labels[i]
        ind = offsprings[i]

        if label == 1:
            individuals.append(ind)
            cfs_list.append(cfs[i])

    individuals = truncate(individuals, cfs_list, max_size)

    return individuals


# find three categories of solutions
# Category 1, saved in ps_list, Pareto dominates Pareto-rep, theta dominates theta-rep
# Category 2, saved in s_list, theta dominates theta-rep, Pareto-nondominated pareto-rep
# Category 3, saved in p_list, Pareto dominates Pareto-rep, theta-nondominated theta-rep
def find_candidate_individuals(p_rep_ind, s_rep_ind, offsprings, p_net, s_net, device, max_size):
    if p_net is None and s_net is None:
        return [random.choice(offsprings)], [], []
    elif p_net is not None and s_net is None:
        return [], [], find_candidates(p_rep_ind, offsprings, p_net, device, max_size)
    elif s_net is not None and p_net is None:
        return [], find_candidates(s_rep_ind, offsprings, s_net, device, max_size), []

    p_dom_labels, p_cfs = nn_predict_dom_inter(offsprings, [p_rep_ind], p_net, device)
    s_dom_labels, s_cfs = nn_predict_dom_inter(offsprings, [s_rep_ind], s_net, device)

    p_dom_labels = p_dom_labels.squeeze()
    s_dom_labels = s_dom_labels.squeeze()
    p_cfs = p_cfs.squeeze()
    s_cfs = s_cfs.squeeze()

    ps_individuals = []
    ps_cfs_list = []

    s_individuals = []
    s_cfs_list = []

    p_individuals = []
    p_cfs_list = []

    for i in range(len(offsprings)):
        p_label = p_dom_labels[i]
        s_label = s_dom_labels[i]
        ind = offsprings[i]

        scf = p_cfs[i] + s_cfs[i]

        if p_label == 1 and s_label == 1:
            ps_individuals.append(ind)
            ps_cfs_list.append(scf)
        elif s_label == 1 and p_label == 0:
            s_individuals.append(ind)
            s_cfs_list.append(scf)
        elif p_label == 1 and s_label == 0:
            p_individuals.append(ind)
            p_cfs_list.append(scf)

    ps_individuals = truncate(ps_individuals, ps_cfs_list, max_size)
    s_individuals = truncate(s_individuals, s_cfs_list, max_size)
    p_individuals = truncate(p_individuals, p_cfs_list, max_size)

    return ps_individuals, s_individuals, p_individuals


# restrict the maximum size of each category
def truncate(individuals, cf_list, size):
    if cf_list and len(cf_list) > size:
        indexes = sorted(range(len(cf_list)), key=lambda sub: cf_list[sub])[-size:]
        return [individuals[i] for i in indexes]
    else:
        return individuals


# select the best individual according to the expected dominant count
def select_best(individuals, net, device):
    label_matrix, conf_matrix = nn_predict_dom_intra(individuals, net, device)
    conf_matrix[label_matrix != 1] = 0
    dom_num = np.sum(conf_matrix, axis=1)

    index = np.argmax(dom_num)
    return individuals[index]


# the second stage of preselection
def select_best_individual(individuals, p_net, s_net, device):
    if len(individuals) == 1:
        return individuals[0]

    if p_net is None and s_net is None:
        return random.choice(individuals)
    elif p_net is not None and s_net is None:
        return select_best(individuals, p_net, device)
    elif s_net is not None and p_net is None:
        return select_best(individuals, s_net, device)

    p_label_matrix, p_conf_matrix = nn_predict_dom_intra(individuals, p_net, device)
    s_label_matrix, s_conf_matrix = nn_predict_dom_intra(individuals, s_net, device)

    p_conf_matrix[p_label_matrix != 1] = 0
    s_conf_matrix[s_label_matrix != 1] = 0

    p_dom_num = np.sum(p_conf_matrix, axis=1)
    s_dom_num = np.sum(s_conf_matrix, axis=1)
    total_num = p_dom_num + s_dom_num

    index = np.argmax(total_num)

    return individuals[index]


# find the individuals that are theta-non-dominated to all the current theta-reps
def find_distinct_individuals(rep_ind_list, offsprings, s_net, device, max_size):
    if s_net is None:
        return [random.choice(offsprings)]

    s_label_matrix, s_conf_matrix = nn_predict_dom_inter(offsprings, rep_ind_list, s_net, device)

    non_dom_num = np.sum(s_label_matrix == 0, axis=1)

    max_num = np.max(non_dom_num)

    if max_num < len(rep_ind_list):
        return []

    indexes, = np.where(non_dom_num == max_num)

    non_dom_conf = np.sum(s_conf_matrix, axis=1)

    dn_offs = [offsprings[index] for index in indexes]
    cfs = [non_dom_conf[index] for index in indexes]

    return truncate(dn_offs, cfs, max_size)


# survival selection based on scalar (theta) non-dominated ranking
def sel_scalar_dea(individuals, n):
    size = len(individuals)
    if size <= n:
        return individuals

    t_fronts = non_dominated_ranking(individuals, scalar_dominance)
    individuals = []
    for fr in t_fronts:
        li = len(individuals)
        lf = len(fr)
        if li + lf > n:
            k = n - li
            fr = random.sample(fr, k)
            individuals.extend(fr)
            break
        else:
            individuals.extend(fr)

    return individuals





