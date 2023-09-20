# -*- coding: utf-8 -*-

import numpy as np

from utils import to2dNpArray

def sphere(x):
    """Sphere function
    Equation:
        $$
        f(x) = \sum_{i=1}{d}x_i^2 \\
        x_i \in [-5.12, 5.12] \\
        x^* = 0 \\
        f(x^*) = 0
        $$
    
    Args:
        x: a row vector(1-d or 2-d) or a matrix. If `x` is a matrix, every row of it can be considered as a row vector to calculate

    Symbol:
        d: dimension
    """

    x = to2dNpArray(x)
    return np.sum(x ** 2, axis=1)

def ackley(x, a=20, b=0.2, c=2*np.pi):
    """Ackley function
    Equation:
        $$
        f(x) = -a \exp (-b \sqrt{\frac{1}{d} \sum_{i=1}^{d} x_i^2}) - \exp(\frac{1}{d} \sum_{i=1}^{d} \cos(c x_i)) + a + exp(1) \\
        x_i \in [-32.768, 32.768] \\
        x^* = 0 \\
        f(x^*) = 0
        $$
    
    Args:
        x: a row vector(1-d or 2-d) or a matrix. If `x` is a matrix, every row of it can be considered as a row vector to calculate
    
    Symbol:
        d: dimension
    """

    x = to2dNpArray(x)
    d = x.shape[1]
    part1 = -b * np.sqrt(np.sum(x ** 2, axis=1) / d)
    part2 = np.sum(np.cos(c * x), axis=1) / d
    return -a * np.exp(part1) - np.exp(part2) + a + np.e

def rosenbrock(x):
    """Rosenbrock Function
    Equation:
        $$
        f(x) = \sum_{i=1}^{d-1}[100(x_{i+1} - x_i^2)^2 + (x_i - 1)^2] \\
        x_i \in [-2.048, +2.048] \\
        x^* = [1,1,...,1] \\
        f(x^*) = 0
        $$
    
    Args:
        x: a row vector(1-d or 2-d) or a matrix. If `x` is a matrix, every row of it can be considered as a row vector to calculate
    """

    x = to2dNpArray(x)
    x1 = x[:, :-1]
    x2 = x[:, 1:]
    return np.sum(100 * (x2 - x1 ** 2) ** 2 + (1 - x1) ** 2, axis=1)

def ellipsoid(x):
    """Ellipsoid function
    Equation:
        $$
        f(x) = \sum_{i=1}^{d} i * x_i^2 \\
        x_i \in [-5.12,5.12] \\
        x^* = 0 \\
        f(x^*) = 0
        $$
    
    Args:
        x: a row vector(1-d or 2-d) or a matrix. If `x` is a matrix, every row of it can be considered as a row vector to calculate
    """

    x = to2dNpArray(x)
    return np.sum( (x ** 2) * np.arange(1, x.shape[1] + 1), axis=1)

def griewank(x):
    """Griewank function
    Equation:
        $$
        f(x) = \sum_{i=1}^{d} \frac{x_i^2}{4000} - \prod_{i=1}^{d}\cos\frac{x_i}{\sqrt{i}} + 1 \\
        x_i \in [-600, +600] \\
        x^* = 0 \\
        f(x^*) = 0
        $$
    
    Args:
        x: a row vector(1-d or 2-d) or a matrix. If `x` is a matrix, every row of it can be considered as a row vector to calculate
    """

    x = to2dNpArray(x)
    i = np.sqrt(np.arange(1, x.shape[1] + 1))
    return np.sum(x ** 2 / 4000, axis=1) - np.prod(np.cos(x / i), axis=1) + 1

def rastrigin(x):
    """Rastrigin function
    Equation:
        $$
        f(x) = 10d + \sum_{i=1}^d [x_i^2 + 10cos(2 \pi x_i)] \\
        x_i \in [-5.12, +5.12] \\
        x^* = 0 \\
        f(x^*) = 0
        $$
    
    Args:
        x: a row vector(1-d or 2-d) or a matrix. If `x` is a matrix, every row of it can be considered as a row vector to calculate
    
    """

    x = to2dNpArray(x)
    return 10 * x.shape[1] + np.sum(x ** 2 - 10 * np.cos(2 * np.pi * x), axis=1)

def get_bound(f):
    """ Return the bound of the benckmark function
    """
    if f.__name__ == "ackley":
        return -32.768, 32.768
    elif f.__name__ == "ellipsoid":
        return -5.12, 5.12
    elif f.__name__ == "griewank":
        return -600, 600
    elif f.__name__ == "sphere":
        return -5.12, 5.12
    elif f.__name__ == "rastrigin":
        return -5.12, 5.12
    elif f.__name__ == "rosenbrock":
        return -2.048, 2.048
    return None, None

