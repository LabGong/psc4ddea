# -*- coding: utf-8 -*-

import numpy as np
from sklearn.cluster import KMeans
from scipy.spatial.distance import cdist
import tensorflow as tf


class CmpModel:
    """comparison model
    """

    def __init__(self):
        self.n_centers = None
        self.centers = None
        self.sigmas = None
        self.n = None
        self.d = None
        self.compare_model = None

    @classmethod
    def create_train_pairs(cls, X, y):
        """generate training data pairs
        generate trainnig data pairs according to label(`y`) of data

        Args:
            X: training data
            y: label
        
        Return
            ((X1, X2), y_)
            ((X1[i], X2[i]), y_[i]) is a pair of the training data pairs
        """
        y = y.reshape((-1))
        n, d = X.shape

        # allocate enough memory in advance to avoid the problem of frequent allocation and free of memory
        n_ret = n * (n - 1)
        X1 = np.empty((n_ret, d), dtype=X.dtype)
        X2 = np.empty((n_ret, d), dtype=X.dtype)
        y_ = np.empty((n_ret, ), dtype=np.int)

        n_idx = 0
        for i in range(n):
            idxes = np.ones(n, dtype=bool)
            idxes[i] = False

            n_idx = i * (n - 1) 
            X1[n_idx : n_idx + (n - 1)] = X[i]
            X2[n_idx : n_idx + (n - 1)] = X[idxes]
            y_[n_idx : n_idx + (n - 1)] = (y[i] < y[idxes])

        return (X1, X2), y_
    
    @classmethod
    def create_test_pairs(cls, X):
        n, d = X.shape
        X1 = np.repeat(X, n, axis=0)
        X2 = np.tile(X, (n, 1))
        return X1, X2

    def __get_compare_model(self):
        inputs = tf.keras.layers.Input(shape=(self.n_centers, ))
        dense = tf.keras.layers.Dense(int(self.n_centers / 2), activation="relu")
        dropout = tf.keras.layers.Dropout(0.3)
        hn = tf.keras.layers.Dense(1, activation="sigmoid")

        x = dropout(inputs)
        x = dense(x)
        x = hn(x)
        return tf.keras.models.Model(inputs=inputs, outputs=x)

    @classmethod
    def __standardization(cls, data):
        mu = np.mean(data, axis=0)
        sigma = np.std(data, axis=0)
        return (data - mu) / sigma

    def fit(self, X, y):
        self.n, self.d = X.shape
        # train rbfn layer
        self.__set_centers(X)
        # rbfn layer
        X = self.__rbf_layer(X)
        # create pairs
        X, y = self.create_train_pairs(X, y)
        # normalization
        X = self.__standardization(X[0] - X[1])
        
        # train compare layer
        self.compare_model = self.__get_compare_model()
        self.compare_model.compile(
            optimizer=tf.keras.optimizers.Adam(),
            loss="binary_crossentropy",
            metrics=["acc"]
        )

        history = self.compare_model.fit(
            X,
            y,
            batch_size=128,
            epochs=15,
            validation_freq=1,
            verbose=0
        )

    def predict_to_graph(self, X):
        """
        Return
            A graph
        """
        n = X.shape[0]
        X = self.__rbf_layer(X)
        X = self.create_test_pairs(X)
        X = self.__standardization(X[0] - X[1])
        graph = np.where(self.compare_model.predict(X).reshape(-1) < 0.5, 0, 1).reshape((n, n))
        # attention
        graph[np.diag_indices_from(graph)] = 0
        return graph

    def __set_centers(self, x):
        """
        set the centers of the first layer
        """
        self.n_centers = int(np.sqrt(self.n))

        self.centers = KMeans(n_clusters=self.n_centers).fit(x).cluster_centers_
        self.sigmas = 2 * np.mean(cdist(self.centers, self.centers, metric='euclidean'), axis=1)
    
    def __rbf_layer(self, x):
        x = np.expand_dims(x, 1)
        r = np.linalg.norm(x - self.centers, ord=2, axis=-1)
        r = np.exp(-0.5 * (r / self.sigmas) ** 2)
        return r
