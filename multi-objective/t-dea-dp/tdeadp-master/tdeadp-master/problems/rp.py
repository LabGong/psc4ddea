import numpy as np
from deap import tools

# This file implements the method to generate a set of structured weight vectors (reference points)


def get_reference_points(n_obj):
    div1, div2 = None, None

    if n_obj == 2:
        div1 = 10
    elif n_obj == 3:
        div1 = 4
    elif n_obj == 4:
        div1 = 3
    elif n_obj == 5:
        div1, div2 = 2, 2
    else:
        div1, div2 = 2, 1

    return structured_reference_points(n_obj, div1, div2)


def structured_reference_points(n_obj, div1, div2=None):
    ref_points = tools.uniform_reference_points(n_obj, div1)
    if div2 is not None:
        in_ref_points = tools.uniform_reference_points(n_obj, div2) / 2. + 0.5 / n_obj
        ref_points = np.vstack((ref_points, in_ref_points))

    return ref_points

