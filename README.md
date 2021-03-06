# TOuNN
Implementation of TOuNN paper [TOuNN: Topology Optimization using Neural Networks](https://link.springer.com/article/10.1007/s00158-020-02748-4) in MATLAB

The original repository for the python implementation of the paper [https://github.com/UW-ERSL/TOuNN](https://github.com/UW-ERSL/TOuNN)

by the authors

[Aaditya Chandrasekhar](https://aadityacs.github.io/), [Krishnan Suresh, Engineering Representations and Simulation Lab](https://ersl.wisc.edu), University of Wisconsin-Madison

There are some changes in this implementation namely:
+ FEA is based on 3D Hexahedral elements
+ Has 3 types of gradient thresholding to choose from
+ Heavily inspired from [top3D125](https://arxiv.org/pdf/2005.05436.pdf) and [top3d](https://www.top3d.app/)
+ The number of trainable parameters of the Neural Network is dependent on the number of elements but with 5 hidden layers.
+ Multiple simultaneous loads

# Example
Cantilever with point load.

```MATLAB
TOuNN(70, 30, 2, 0.5);
```
Will display only the final design.

```MATLAB
TOuNN(70, 30, 2, 0.5, true);
```
Will produce the following gif but will take lot of time. Not Recommeneded.

For any changes in loads and/or boundary conditions, 
make appropriate changes in the problem_def.m file before calling the TOuNN function

![CantileverLarge](https://user-images.githubusercontent.com/54637647/164000610-e0f5cdb6-b57f-4262-8c58-b7d8046fe93c.gif)
