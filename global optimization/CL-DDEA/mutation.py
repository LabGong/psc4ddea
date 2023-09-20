# -*- coding: utf-8 -*-

import numpy as np

def poly_mutation(pop, lower_bound, upper_bound, pm, eta_m=15):
    """polynomial mutation

    Reference
        Formulation: A Niched-Penalty Approach for Constraint Handling in Genetic Algorithms
        Code: https://github.com/HandingWangXDGroup/TT-DDEA/blob/19af3b6b760060949747d721297add8f84eeba85/TT-DDEA-PythonCode/GA.py

    Args:
        lower_bound: a vector or a number, determine the lower bound of the value
        upper_bound: a vector or a number, determine the upper bound of the value
        pm: probability of mutation
        eta_m: distribution index

    Return:
        The new population

    """
    n, d = pop.shape
    ret = np.empty_like(pop)
    for i in range(n):
        x_vec = pop[i]

        delta_vec = np.minimum(x_vec - lower_bound, upper_bound - x_vec) / (upper_bound - lower_bound)
        u_vec = np.random.random(d)
        delta_q_vec = np.where(u_vec <= 0.5,
                                (2 * u_vec + (1 - 2 * u_vec) * ((1 - delta_vec) ** (eta_m + 1))) ** (1 / (eta_m + 1)) - 1,
                                1 - (2 * (1 - u_vec) + 2 * (u_vec - 0.5) * ((1 - delta_vec) ** (eta_m + 1))) ** (1 / (eta_m + 1))
                                )
        # x_vec_new is the vector of x_vec after mutation
        x_vec_new = x_vec + delta_q_vec * (upper_bound - lower_bound)
        x_vec_new = x_vec_new.clip(lower_bound, upper_bound)

        ret[i] = np.where(np.random.random(d) < pm, x_vec_new, x_vec)

    return ret
