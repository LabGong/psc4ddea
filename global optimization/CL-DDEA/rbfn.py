# -*- coding: utf-8 -*-
import functools
import numpy as np
from sklearn.cluster import KMeans

class RBFN:
    """radial basis function neural network
    Metric:
        2-Norm

    How it train:
        Use k-means to get the centers points, and use the pseudoinverse to do interpolation
    """
    
    def __init__(
        self,
        hidden_shape,
        norm_func=functools.partial(np.linalg.norm, ord=2, axis=-1),
        basis_func=lambda r: np.exp(-(r**2))
    ):
        """
        Args:
            hidden_shape: a postive integer, stands for the number of center point of the hidden layer
        """
        self.hidden_shape = hidden_shape
        self.norm_func = norm_func
        self.basis_func = basis_func
        self.w = None
        # sigmas is a vector, sigmas[i] is the sigma of centers, it is the spread radius
        self.sigmas = None
        self.centers = None

    def _calc_sigmas(self):
        """
        compute the hyperparameter `sigma` of kernel function
        """
        c_ = np.expand_dims(self.centers, 1)
        ds = self.norm_func(c_ - self.centers)
        sigma = 2 * np.mean(ds, axis=1)
        sigma = np.sqrt(0.5) / sigma
        return sigma

    def _calc_interpolation_mat(self, X):
        """
        This is the first layer of the radial basis function neural network
        """
        x = np.expand_dims(X, 1)
        r = self.norm_func(x - self.centers)
        r =  r * self.sigmas
        return self.basis_func(r)

    def fit(self, X, y):
        """
        Principle:
            1. kmeans: compute the first layer
            2. least squares method by pseudoinverse: compute the second layer
        """
        self.centers = KMeans(n_clusters=self.hidden_shape).fit(X).cluster_centers_
        self.sigmas = self._calc_sigmas()
        tmp = self._calc_interpolation_mat(X)
        X_ = np.c_[np.ones(len(tmp)), tmp]
        y = y.reshape((-1, 1))
        self.w = np.linalg.pinv(X_) @ y

    def predict(self, X):
        """
        Return:
            a column vector(2-d)
        """
        if X.ndim == 1:
           X = X.reshape((1, -1)) 
        tmp = self._calc_interpolation_mat(X)
        X_ = np.c_[np.ones(len(tmp)), tmp]
        return X_ @ self.w

