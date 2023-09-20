# -*- coding: utf-8 -*-

import numpy as np
import rbfn

class RegModel:
    def __init__(self, duplicated_rate=0.1):
        self.duplicated_rate = duplicated_rate
        self.pop = None
        self.models = [None] * 3

    @classmethod
    def get_close_subset(cls, src_set, dest_set, n=None):
        """get a subset of `src_set` which is closed to the `dest_set`
        Args:
            src_set: source set
            dest_set: destination set
            n: the size of subset
        
        Return:
            The index of the subset in set `src_set`
        """
        
        from scipy.spatial.distance import cdist
        if n is None:
            n = len(src_set)
        if n == 0:
            return np.array([], dtype=np.int)
        # d[i, j] is the distance between src_set[i] and dest_set[j]
        d = cdist(src_set, dest_set, metric='euclidean')

        metrics = np.min(d, axis=1)
        # metrics = np.mean(d, axis=1)

        idx = np.argsort(metrics).reshape((-1))
        return idx[:n]

    def set_pop(self, pop):
        self.pop = pop

    def fit(self, x, y):
        idx = self.get_close_subset(x, self.pop, int(len(x) * self.duplicated_rate))
        x_ = np.vstack((x, x[idx]))
        y_ = np.append(y, y[idx])

        idx = np.arange(x_.shape[0])
        np.random.shuffle(idx)

        rate = int(x_.shape[0] / 3)
        xtmp = x_[idx[:rate]]
        ytmp = y_[idx[:rate]]
        self.models[0] = rbfn.RBFN(hidden_shape=int(np.sqrt(xtmp.shape[0])))
        self.models[0].fit(xtmp, ytmp)

        xtmp = x_[idx[rate:rate * 2]]
        ytmp = y_[idx[rate:rate * 2]]
        self.models[1] = rbfn.RBFN(hidden_shape=int(np.sqrt(xtmp.shape[0])))
        self.models[1].fit(xtmp, ytmp)

        xtmp = x_[idx[rate * 2: ]]
        ytmp = y_[idx[rate * 2: ]]
        self.models[2] = rbfn.RBFN(hidden_shape=int(np.sqrt(xtmp.shape[0])))
        self.models[2].fit(xtmp, ytmp)

    def predict(self, x):
        return (self.models[0].predict(x) + self.models[1].predict(x) + self.models[2].predict(x)) / 3
