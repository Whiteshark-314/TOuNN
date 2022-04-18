# TOuNN
Implementation of TOuNN paper [TOuNN: Topology Optimization using Neural Networks](https://link.springer.com/article/10.1007/s00158-020-02748-4) in MATLAB and Julia

The original repository for the python implementation of the paper [https://github.com/UW-ERSL/TOuNN](https://github.com/UW-ERSL/TOuNN)

by the authors

[Aaditya Chandrasekhar](https://aadityacs.github.io/), [Krishnan Suresh, Engineering Representations and Simulation Lab](https://ersl.wisc.edu), University of Wisconsin-Madison

There are some changes in this implementation namely:
+ FEA is based on 3D Hexahedral elements
+ Has 3 types of gradient thresholding to choose from
+ Heavily inspired from [top3D125](https://arxiv.org/pdf/2005.05436.pdf) and [top3d](https://www.top3d.app/)
+ The number of trainable parameters of the Neural Network is dependent on the number of elements but with 5 hidden layers.

# Example
Cantilever with point load. Each update is visualised after 10 iterations/epochs.

![Cantilever2](https://user-images.githubusercontent.com/54637647/163804538-060d40b8-b86e-4a1c-b784-0cd9b2cbf83e.gif)
