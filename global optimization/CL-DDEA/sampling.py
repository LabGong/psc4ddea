# -*- coding: utf-8 -*-

import numpy as np
from utils import to2dColVec

def lhs(n, d, lower_bound, upper_bound):
    """Latin hypercude sampling
    
    Args:
        n: The number of the sample data
        d: The number of the decision variables
        lower_bound: A number or a vector, the lower bound of the decision variables
        upper_bound: A number or a vector, the upper_bound of the decision variables
    """
    if np.any(lower_bound > upper_bound):
        return None
    lower_bound, upper_bound = to2dColVec(lower_bound), to2dColVec(upper_bound)
    intervalSize = 1.0 / n
    # samplePoints[i] is the point that sampled from demension i
    samplePoints = np.empty([d, n])
    for i in range(n):
        samplePoints[:, i] = np.random.uniform(low=i * intervalSize, high=(i + 1) * intervalSize, size=d)
    # offset
    samplePoints = lower_bound +  samplePoints * (upper_bound - lower_bound)
    for i in range(d):
        np.random.shuffle(samplePoints[i])
    return samplePoints.T

def rs(n, d, lower_bound, upper_bound):
    """random sampling
    
    Args:
        n: The number of the sample data
        d: The number of the decision variables
        lower_bound: A number or a vector, the lower bound of the decision variables
        upper_bound: A number or a vector, the upper_bound of the decision variables
    """
    if np.any(lower_bound > upper_bound) :
        return None
    lower_bound, upper_bound = to2dColVec(lower_bound), to2dColVec(upper_bound)
    samplePoints = np.random.random([d, n])
    samplePoints = lower_bound +  samplePoints * (upper_bound - lower_bound)
    return samplePoints.T
