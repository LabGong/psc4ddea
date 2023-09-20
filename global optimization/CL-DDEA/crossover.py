# -*- coding: utf-8 -*-

import numpy as np
import random

import warnings
# for the code: beta_vec = 1 + 2 * np.minimum(p1_vec - lower_bound, upper_bound - p2_vec) / (p2_vec - p1_vec)
# ignore message: divided by zero
warnings.filterwarnings("ignore")

def sbx(pop, lower_bound, upper_bound, pc=1, eta_c=15):
    """simulated binary crossover

    Reference
        Formulation: A Niched-Penalty Approach for Constraint Handling in Genetic Algorithms
        Code: https://github.com/HandingWangXDGroup/TT-DDEA/blob/19af3b6b760060949747d721297add8f84eeba85/TT-DDEA-PythonCode/GA.py

    Args:
        lower_bound: a vector or a number, determine the lower bound of the value
        upper_bound: a vector or a number, determine the upper bound of the value
        pc: probability of crossover
        eta_c: distribution index, a non-negative real number. A large value of eta_c gives a higher probability for creating 'near-parent' solutions

    Return:
        The new population

    """
    n, d = pop.shape
    ret = np.empty((0, d), pop.dtype)
    for i in range(n):
        if random.random() < pc:
            # get index of another parent
            idx = np.random.choice(np.hstack((np.arange(0, i), np.arange(i + 1, n))))
            # get the element
            p1_vec = np.minimum(pop[i], pop[idx])
            p2_vec = np.maximum(pop[i], pop[idx])

            # calc
            beta_vec = 1 + 2 * np.minimum(p1_vec - lower_bound, upper_bound - p2_vec) / (p2_vec - p1_vec)
            alpha_vec = 2 - beta_vec ** (- (eta_c + 1))

            # avoid error number
            alpha_vec = np.where(np.isnan(alpha_vec), 1, alpha_vec)

            u_vec = np.random.random(d)
            beta_q_vec = np.where(u_vec <= (1 / alpha_vec),
                                  (u_vec * alpha_vec) ** (1 / (eta_c + 1)),
                                  (1 / (2 - u_vec * alpha_vec)) ** (1 / (eta_c + 1))
                                  )
            beta_q_vec = np.array(beta_q_vec, dtype=np.int)

            child1 = 0.5 * (p1_vec + p2_vec) - 0.5 * beta_q_vec * (p2_vec - p1_vec)
            child2 = 0.5 * (p1_vec + p2_vec) + 0.5 * beta_q_vec * (p2_vec - p1_vec)
            # set the bound
            child1 = child1.clip(lower_bound, upper_bound)
            child2 = child2.clip(lower_bound, upper_bound)
            # add the return population
            ret = np.vstack((ret, child1, child2))

    return ret
