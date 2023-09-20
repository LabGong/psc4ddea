# <a href="https://www.codecogs.com/eqnedit.php?latex=\huge&space;\theta" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\huge&space;\theta" title="\huge \theta" /></a>-DEA-DP

This project implements a surrogate-assisted evolutionary algorithm, called <a href="https://www.codecogs.com/eqnedit.php?latex=\theta" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\theta" title="\theta" /></a>-DEA-DP, for expensive multi-obejctive optimziation. This algorithm maintains two deep neural networks as surrogates, one for Pareto dominance prediction and another for <a href="https://www.codecogs.com/eqnedit.php?latex=\theta" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\theta" title="\theta" /></a>-dominance prediction. 
Through a two-stage preselection strategy, the two classification-based surrogates interact with a multi-objective evolutionary optimization process in order to select promising solutions for function evaluation. 



## Dependencies

This project requires 
- Python (>= 3.6)
- NumPy (>= 1.13.3)
- Pytorch (>= 1.4.0)
- DEAP (>= 1.3.1)
- pymop (>= 0.2.4)
- optproblems (>= 1.3)
- matplotlib (>= 3.1.3)


## Example

An example is provided under the folder `examples/` which demonstrates how to run the algorithm on a specific multi-objective optimization problem. 




## Contact
For questions and feedback, please contact yyxhdy@gmail.com
