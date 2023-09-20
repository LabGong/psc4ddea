from problems.dtlz1 import *
from problems.wfg import *
import pymop.factory

WFG_SET = {
    'wfg1': WFG1,
    'wfg2': WFG2,
    'wfg3': WFG3,
    'wfg4': WFG4,
    'wfg5': WFG5,
    'wfg6': WFG6,
    'wfg7': WFG7,
    'wfg8': WFG8,
    'wfg9': WFG9
}


# extend the problem factor in pymop library
def get_problem(name, *args, **kwargs):
    name = name.lower()

    if name == "dtlz1":
        problem = DTLZ1a(*args, **kwargs)
    elif name in WFG_SET:
        problem = WFG_SET[name](*args, **kwargs)
    else:
        problem = pymop.factory.get_problem(name, *args, **kwargs)

    problem.name = name
    return problem


def get_min_max_obj_values(name, n_obj):
    name = name.lower()
    if name == "zdt3":
        return [0, -0.8], [0.9, 1.0]
    elif name.startswith('wfg'):
        return [0] * n_obj, [2 * (i + 1) for i in range(n_obj)]
    elif name.startswith('dtlz7'):
        return [0] * n_obj, [1] * (n_obj - 1) + [2 * n_obj]
    else:
        return [0] * n_obj, [1] * n_obj



