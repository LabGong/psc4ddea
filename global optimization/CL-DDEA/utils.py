# -*- coding: utf-8 -*-

import numpy as np

def to2dNpArray(x):
    # type conversion
    if not isinstance(x, np.ndarray):
        x = np.array(x)
    # convert to matrix
    if x.ndim == 1:
        x = x[np.newaxis, :]
    return x

def to2dColVec(x):
    """convert to column vector
    convert a number or 1-d vector to column vector
    """
    if np.size(x) == 1:
        return x
    # convert to 2-d column vector of type numpy.array
    return np.reshape(x, (np.size(x), -1))
