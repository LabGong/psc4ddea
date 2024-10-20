# Useful Papers and Source Codes for Data-Driven Evolutionary Algorithms （DDEAs)

This respository aims to maintain a list of useful relevant papers and open source codes for Data-Driven Evolutionary Algorithms (DDEAs).

*Maintained by members in SCUT-Ailab: Yuanting Zhong, Xianrong Zhang, Xincan Wang, Ke Zhu, Haogan Huang and Yuejiao Gong.*

- [Useful Papers and Source Codes for Data-Driven Evolutionary Algorithms （DDEAs)](#useful-papers-and-source-codes-for-data-driven-evolutionary-algorithms-ddeas)
  - [1. Survey Papers](#1-survey-papers)
  - [2. Global Optimization](#2-global-optimization)
  - [3. Multi-Objective Optimization](#3-multi-objective-optimization)
  - [4. Large-Scale Optimization](#4-large-scale-optimization)
  - [5. Dynamic Optimization](#5-dynamic-optimization)
  - [6. Federated Data-Driven Optimization](#6-federated-data-driven-optimization)
  - [7. Multi-Task Optimization](#7-multi-task-optimization)
  - [8. Others](#8-others)
  - [9. Benchmarks \& Applications](#9-benchmarks--applications)

## 1. Survey Papers

**Data-Driven Evolutionary Optimization: Integrating Evolutionary Computation, Machine Learning and Data Science** 2021 [book](https://link.springer.com/10.1007/978-3-030-74640-7)

*Yaochu Jin, Handing Wang, Chaoli Sun*

**Open Issues in Surrogate-Assisted Optimization** 2020 [book chapter](http://link.springer.com/10.1007/978-3-030-18764-4_10)

*Jörg Stork, Martina Friese, Martin Zaefferer, Thomas Bartz-Beielstein, Andreas Fischbach, Beate Breiderhoff, Boris Naujoks and Tea Tušar*

**Data-Driven Evolutionary Optimization: An Overview and Case Studies** 2019 [paper](https://ieeexplore.ieee.org/document/8456559/)

*Yaochu Jin, Handing Wang, Tinkle Chugh, Dan Guo and Kaisa Miettinen*

**A survey on handling computationally expensive multiobjective optimization problems with evolutionary algorithms** 2019 [paper](https://link.springer.com/article/10.1007/s00500-017-2965-0)

*Tinkle Chugh, Karthik Sindhya, Jussi Hakanen and Kaisa Miettinen*

## 2. Global Optimization

|      Algorithm      |                            Paper                             |                     Original Repository                      |
| :-----------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
|  SR-DDEA [offline]  | Symbolic Regression-Assisted Offline Data-Driven Evolutionary Computation *2024* [paper](https://ieeexplore.ieee.org/document/10720865) |                              -                               |
|  CL-DDEA [offline]  | Contrastive Learning: An Alternative Surrogate for Offline Data-Driven Evolutionary Computation *2023* [paper](https://ieeexplore.ieee.org/document/9763851) | [YuejiaoGong/CL-DDEA](https://github.com/YuejiaoGong/CL-DDEA) |
|  MS-DDEO [offline]  | Offline data‐driven evolutionary optimization based on model selection *2022* [paper](https://linkinghub.elsevier.com/retrieve/pii/S2210650222000487) |                              -                               |
|      SDH-Jaya       | A surrogate-assisted Jaya algorithm based on optimal directional guidance and historical learning mechanism *2022* [paper](https://www.sciencedirect.com/science/article/abs/pii/S0952197622000628) | [zzzhhh-320/SDHJAYA](https://github.com/zzzhhh-320/SDHJAYA)  |
|         ESA         | Evolutionary Sampling Agent for Expensive Problems *2022* [paper](https://ieeexplore.ieee.org/document/9780561) | [zhenhuixiang/EAS code.zip](https://zhenhuixiang.github.io/code/ESA%20code.zip) |
|       CA-LLSO       | A Classifier-Assisted Level-Based Learning Swarm Optimizer for Expensive Optimization *2021* [paper](https://ieeexplore.ieee.org/document/9171272) | [CarrieWei/CA-LLSO_Code](https://github.com/CarrieWei/CA-LLSO_Code) |
|  TT-DDEA [offline]  | Offine Data-Driven Evolutionary Optimization Based on Tri-Training, Swarm and Evolutionary Computation *2021* [paper](https://www.sciencedirect.com/science/article/abs/pii/S2210650220304533) |  [Mikasa210/TT-DDEA](https://github.com/Mikasa210/TT-DDEA)   |
|        DESO         | Data-driven evolutionary sampling optimization for expensive problems *2021* [paper](https://ieeexplore.ieee.org/document/9430108) | [zhenhuixiang/DESO](https://zhenhuixiang.github.io/code/DESO%20code.zip) |
|      BiS-SAHA       | A bi-stage surrogate assisted hybrid algorithm for expensive optimization problems *2021* [paper](https://link.springer.com/article/10.1007/s40747-021-00277-1) | [IIS-tyust/BiS-SAHA](https://github.com/IIS-tyust/BiS-SAHA)  |
|      SAEA-RFS       | A Surrogate-Assisted Evolutionary Algorithm with Random Feature Selection for Large-Scale Expensive Problems *2020* [paper](http://link.springer.com/10.1007/978-3-030-58112-1_9) |  [GuoxiaFu/SAEA_RFS](https://github.com/GuoxiaFu/SAEA-RFS)   |
| BDDEA-LDG [offline] | Boosting Data-Driven Evolutionary Algorithm With Localized Data Generation *2020* [paper](https://ieeexplore.ieee.org/document/9039758) |                              -                               |
|      TL-SSLPSO      | Truncation-learning-driven surrogate assisted social learning particle swarm optimization for computationally expensive problem *2020* [paper](https://www.sciencedirect.com/science/article/abs/pii/S156849462030750Xs) | [yuhaibo2017/TL-SSLPSO](https://github.com/yuhaibo2017/TL-SSLPSO) |
|      TSA-BFEA       | Transfer stacking from low-to high-fidelity: A surrogate-assisted bi-fidelity evolutionary algorithm *2020* [paper](https://www.sciencedirect.com/science/article/abs/pii/S1568494620302167) | [HandingWang/TSA-BFEA](https://github.com/HandingWang/TSA-BFEA) |
|  DDEA-SE [offline]  | Offline Data-Driven Evolutionary Optimization Using Selective Surrogate Ensembles *2019* [paper](https://ieeexplore.ieee.org/document/8357456/) | [HandingWang/DDEA-SE](https://github.com/HandingWang/DDEA-SE) |
|     GORS-SSLPSO     | A generation-based optimal restart strategy for surrogate-assisted social learning particle swarm optimization *2019* [paper](https://www.sciencedirect.com/science/article/abs/pii/S0950705118304064) | [yuhaibo2017/GORS-SSLPSO](https://github.com/yuhaibo2017/GORS-SSLPSO_code) |
|      SRK-DDEA       | Ranking for Offline Data-Driven Evolutionary Optimization Using Radial Basis Function Networks with Multiple Kernels *2019* [paper](https://ieeexplore.ieee.org/document/9002961) | [Mikasa210/SRK-DDEA](https://github.com/Mikasa210/SRK-DDEA)  |
|  SSL-assisted-PSO   | Semi-supervised learning assisted particle swarm optimization of computationally expensive problems *2018* [paper](https://dl.acm.org/doi/10.1145/3205455.3205596) | [IIS-tyust/SSL-assisted-PSO](https://github.com/IIS-tyust/SSL-assisted-PSO) |
|        SHPSO        | Surrogate-assisted hierarchical particle swarm optimization *2018* [paper](https://www.sciencedirect.com/science/article/abs/pii/S0020025518303293) | [yuhaibo2017/SHPSO_code](https://github.com/yuhaibo2017/SHPSO_code) |
|      CALSAPSO       | Committee-based Active Learning for Surrogate-Assisted Particle Swarm Optimization of Expensive Problems *2017* [paper](https://ieeexplore.ieee.org/document/7955012) | [HandingWang/CALSAPSO](https://github.com/HandingWang/CALSAPSO) |
|       TLSAPSO       | A two-layer surrogate-assisted particle swarm optimization algorithm *2015* [paper](https://link.springer.com/article/10.1007/s00500-014-1283-z) |  [IIS-tyust/TLSAPSO](https://github.com/IIS-tyust/TLSAPSO)   |

## 3. Multi-Objective Optimization

|      Algorithm      |                            Paper                             |                     Original Repository                      |
| :-----------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
|       HES-EA        | A Hierarchical and Ensemble Surrogate-Assisted Evolutionary Algorithm With Model Reduction for Expensive Many-Objective Optimization *2024* [paper](https://ieeexplore.ieee.org/document/10630664) |                              -                               |
|       EMMOEA        | Performance Indicator-Based Infill Criterion for Expensive Multi-/Many-Objective Optimization *2023* [paper](https://ieeexplore.ieee.org/abstract/document/10018528) |                              -                               |
|       TS-SAEA       | A Two-stage Surrogate-Assisted Evolutionary Algorithm (TS-SAEA) for Expensive Multi/Many-objective Optimization *2022* [paper](https://linkinghub.elsevier.com/retrieve/pii/S2210650222000773) |                              -                               |
|        REMO         | Expensive Multiobjective Optimization by Relation Learning and Prediction *2022* [paper](https://ieeexplore.ieee.org/document/9716917/) |     [ilog-ecnu/REMO](https://github.com/ilog-ecnu/REMO)      |
|   $\theta$-dea-dp   | Expensive Multiobjective Evolutionary Optimization Assisted by Dominance Prediction *2022* [paper](https://ieeexplore.ieee.org/document/9490636) |      [yyxhdy/tdeadp](https://github.com/yyxhdy/tdeadp)       |
| prob-RVEA [offline] | Probabilistic Selection Approaches in Decomposition-Based Evolutionary Algorithms for Offline Data-Driven Multiobjective Optimization *2022* | [prob-RVEA](https://github.com/industrial-optimization-group/offline_data_driven_moea) |
|  IBEA-MS [offline]  | Performance Indicator-Based Adaptive Model Selection for Offline Data-Driven Multiobjective Evolutionary Optimization *2022* [paper](https://ieeexplore.ieee.org/document/9774966/) |   [IBEA-MS](https://github.com/HandingWangXDGroup/IBEA-MS)   |
|      ESF-EMOO       | An Ensemble Surrogate-Based Framework for Expensive Multiobjective Evolutionary Optimization *2022* [paper](https://ieeexplore.ieee.org/document/9509584/) | [Xunfeng-Wu/ESF-EMOO/](https://github.com/Xunfeng-Wu/ESF-EMOO/) |
|       MS-MOEA       | An Adaptive Model Switch-based Surrogate-Assisted Evolutionary Algorithm for Noisy Expensive Multi-Objective Optimization *2022* [paper](https://link.springer.com/article/10.1007/s40747-022-00717-6) | [HandingWangXDGroup/MS-MOEA](https://github.com/HandingWangXDGroup/MS-MOEA) |
|       EAHVFA        | A Surrogate-Assisted Evolutionary Algorithm with Hypervolume Triggered Fidelity Adjustment for Noisy Multiobjective Integer Programming *2022* [paper](https://www.sciencedirect.com/science/article/abs/pii/S1568494622004690) | [HandingWangXDGroup/EAHVFA](https://github.com/HandingWangXDGroup/EAHVFA) |
|         PBF         | A Framework for Expensive Many-Objective Optimization with Pareto-based Bi-indicator Infill Sampling Criterion *2021* [paper](https://link.springer.com/article/10.1007/s12293-021-00351-8) | [HandingWangXDGroup/PBF](https://github.com/HandingWangXDGroup/PBF) |
|        IKAEA        | A Fast Kriging-Assisted Evolutionary Algorithm Based on Incremental Learning *2021* [paper](https://ieeexplore.ieee.org/document/9381509) | [IKAEA](https://github.com/zhandawei/Incremental_Kriging_Assisted_Evolutionary_Algorithm) |
|      MDR-SAEA       | Multi-Stage Dimension Reduction for Expensive Sparse Multi-Objective Optimization Problems *2021* [paper](https://www.sciencedirect.com/science/article/abs/pii/S0925231221002162) | [HandingWangXDGroup/MDR-SAEA](https://github.com/HandingWangXDGroup/MDR-SAEA) |
|        KTA2         | A Kriging-Assisted Two-Archive Evolutionary Algorithm for Expensive Many-Objective Optimization *2021* [paper](https://ieeexplore.ieee.org/abstract/document/9406113) | [HandingWangXDGroup/KTA2](https://github.com/HandingWangXDGroup/KTA2) |
|   MS-RV [offline]   | Off-line Data-driven Multi-objective Optimization: Knowledge Transfer between Surrogates and Generation of Final Solutions *2020* [paper](https://ieeexplore.ieee.org/document/8752044/) | [Peacefulyang/MS-RV](https://github.com/Peacefulyang/MS-RV)  |
|        CSEA         | A Classification-Based Surrogate-Assisted Evolutionary Algorithm for Expensive Many-Objective Optimization *2019* [paper](https://ieeexplore.ieee.org/document/8281523/) | [Cheng He/CSEA](https://www.researchgate.net/publication/324721301_The_source_code_of_CSEA) |
|       HK-RVEA       | Surrogate-assisted evolutionary biobjective optimization for objectives with non-uniform latencies *2018* [paper](https://dl.acm.org/doi/10.1145/3205455.3205514) |    [tichugh/HK-RVEA](https://github.com/tichugh/HK-RVEA)     |
|      MGPSLPSO       | Multiobjective Infill Criterion Driven Gaussian Process-Assisted Particle Swarm Optimization of High-Dimensional Expensive Problems *2018* [paper](https://ieeexplore.ieee.org/document/8457296) |    [Jetina/MGPSLPSO](https://github.com/Jetina/MGPSLPSO)     |
|      RF-CMOCO       | A Random Forest-Assisted Evolutionary Algorithm for Data-Driven Constrained Multiobjective Combinatorial Optimization of Trauma Systems *2018* [paper](https://ieeexplore.ieee.org/document/8472353) | [HandingWang/RF-CMOCO](https://github.com/HandingWang/RF-CMOCO) |
| NSGA2_GP [offline]  | Small data driven evolutionary multi-objective optimization of fused magnesium furnaces *2016* [paper](http://ieeexplore.ieee.org/document/7850211/) | [guoxishu/small-data-driven](https://github.com/guoxishu/small-data-driven) |
|       K-RVEA        | A surrogate-assisted reference vector guided evolutionary algorithm for computationally expensive many-objective optimization *2016* [paper](https://ieeexplore.ieee.org/document/7723883) |     [tichugh/K-RVEA](https://github.com/tichugh/K-RVEA)      |

## 4. Large-Scale Optimization

|     Algorithm     |                            Paper                             |                     Original Repository                      |
| :---------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
|     DSKT-DDEA     | Island-Based Evolutionary Computation with Diverse Surrogates and Adaptive Knowledge Transfer for High-Dimensional Data-Driven Optimization *2024* |  [LabGong/DSKT-DDEA](https://github.com/LabGong/DSKT-DDEA)   |
| CC-DDEA [offline] | Offline Data-Driven Optimization at Scale: A Cooperative Coevolutionary Approach *2023* [paper](https://ieeexplore.ieee.org/document/10339654) |    [LabGong/CC-DDEA](https://github.com/LabGong/cc-ddea)     |
|      L2SMEA       | Linear Subspace Surrogate Modeling for Large-Scale Expensive Single/Multi-Objective Optimization *2023* [paper](https://ieeexplore.ieee.org/document/10265195) |                              -                               |
|      TS-DDEO      | Two-Stage Data-Driven Evolutionary Optimization for High-Dimensional Expensive Problems *2023* [paper](https://ieeexplore.ieee.org/document/9580489) | [zhenhuixiang/TS-DDEO](https://zhenhuixiang.github.io/code/TS-DDEO%20code.zip) |
|     SAEA-PRG      | A Surrogate-Assisted Evolutionary Feature Selection Algorithm With Parallel Random Grouping for High-Dimensional Classification *2022* [paper](https://ieeexplore.ieee.org/document/9706363) |   [SAEAPRG](https://github.com/HandingWangXDGroup/SAEAPRG)   |
|       ESCO        | An Ensemble Surrogate-Based Coevolutionary Algorithm for Solving Large-Scale Expensive Optimization Problems *2022* [paper](https://ieeexplore.ieee.org/document/9894365) |    [Xunfeng-Wu/ESCO](https://github.com/Xunfeng-Wu/ESCO)     |
|       SAMSO       | A Surrogate-Assisted Multiswarm Optimization Algorithm for High-Dimensional Computationally Expensive Problems *2021* [paper](https://ieeexplore.ieee.org/document/8994184) |     [fanli525/SAMSO](https://github.com/fanli525/SAMSO)      |
|      CCJADE       | Investigating surrogate-assisted cooperative coevolution for large-scale global optimization *2019* [paper](https://www.sciencedirect.com/science/article/abs/pii/S002002551930009X) |  [SACCJADE](https://github.com/lsgo-metaheuristics/saccde)   |
|      SA-COSO      | Surrogate-assisted cooperative swarm optimization of high-dimensional expensive problems *2017* [paper](https://ieeexplore.ieee.org/document/7865982) |  [IIS-tyust/SA-COSO](https://github.com/IIS-tyust/SA-COSO)   |

## 5. Dynamic Optimization

|      Algorithm      |                            Paper                             |                     Original Repository                      |
| :-----------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
|    MLDDEO & MLBO    | Solving Expensive Optimization Problems in Dynamic Environments With Meta-Learning *2024* [paper](https://ieeexplore.ieee.org/document/10644136) |                              -                               |
|       SADE-KT       | A Surrogate-Assisted Differential Evolution with Knowledge Transfer for Expensive Incremental Optimization Problems *2023* [paper](https://ieeexplore.ieee.org/document/10172303) |                              -                               |
|  DSE-MFS [offline]  | A Data Stream Ensemble Assisted Multifactorial Evolutionary Algorithm for Offline Data-driven Dynamic Optimization *2023* [paper](https://direct.mit.edu/evco/article-abstract/doi/10.1162/evco_a_00332/115655/A-Data-Stream-Ensemble-Assisted-Multifactorial?redirectedFrom=fulltext) |    [DSE_MFS](https://github.com/Peacefulyang/DSE_MFS.git)    |
|        DETO         | A Data-Driven Evolutionary Transfer Optimization for Expensive Problems in Dynamic Environments *2022* [paper](http://arxiv.org/abs/2211.02879) | [COLA-Laboratory/DETO](https://github.com/COLA-Laboratory/DETO) |
|       MBO-DOP       | Model-based optimization with concept drifts *2020* [paper](https://dl.acm.org/doi/10.1145/3377930.3390175) |                              -                               |
|    TL-MOEA/D-EGO    | Surrogate Assisted Evolutionary Algorithm Based on Transfer Learning for Dynamic Expensive Multi-Objective Optimisation Problems *2020* [paper](https://www.sciencedirect.com/science/article/abs/pii/S0950705120304536) |                              -                               |
| 1SGP, 1S_RBF, *etc* | Surrogate-Assisted Evolutionary Framework for Data-Driven Dynamic Optimization *2019* [paper](https://ieeexplore.ieee.org/document/8502789/) | [MiLab-HITSZ](https://huggingface.co/datasets/MiLab-HITSZ/SurrogateAssistedFramework/tree/main) |
|         EGO         | Tracking global optima in dynamic environments with efficient global optimization *2015* [paper](https://linkinghub.elsevier.com/retrieve/pii/S0377221714009515) |                              -                               |

## 6. Federated Data-Driven Optimization

| Algorithm |                            Paper                             |                     Original Repository                      |
| :-------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
|   PEGA    | PEGA: A Privacy-Preserving Genetic Algorithm for Combinatorial Optimization *2024* [paper](https://ieeexplore.ieee.org/abstract/document/10398448) |                              -                               |
| DP-FSAEA  | DP-FSAEA: Differential Privacy for Federated Surrogate-Assisted Evolutionary Algorithms *2024* [paper](https://ieeexplore.ieee.org/abstract/document/10520272) |                              -                               |
|   FMTBO   | Federated Many-Task Bayesian Optimization *2023* [paper](https://ieeexplore.ieee.org/document/10141991) | [FMTBO](https://github.com/hangyuzhu/Federated-Many-task-Bayesian-Optimization) |
| FDD-EA-DH | A Secure Federated Data-Driven Evolutionary Multi-objective Optimization Algorithm *2022* [paper](http://arxiv.org/abs/2210.08295) |                              -                               |
|  FDD-EA   | A federated data-driven evolutionary algorithm *2021* [paper](https://linkinghub.elsevier.com/retrieve/pii/S0950705121007942) |                              -                               |

## 7. Multi-Task Optimization

| Algorithm |                            Paper                             |                   Original Repository                   |
| :-------: | :----------------------------------------------------------: | :-----------------------------------------------------: |
|  GL-LERC  | Global and Local Search Experience-Based Evolutionary Sequential Transfer Optimization *2024* [paper](https://ieeexplore.ieee.org/abstract/document/10565847) |     [GL-LERC](https://github.com/ccm831143/GL-LERC)     |
|  SADMPSO  | Surrogate and Autoencoder-Assisted Multitask Particle Swarm Optimization for High-Dimensional Expensive Multimodal Problems *2023* [paper](https://ieeexplore.ieee.org/document/10155293) |                            -                            |
|  MaMPSO   | Multisurrogate-Assisted Multitasking Particle Swarm Optimization for Expensive Multimodal Problems *2023* [paper](https://ieeexplore.ieee.org/document/9615147) |                            -                            |
|  MS-MTO   | Multi-surrogate multi-tasking optimization of expensive problems *2020* [paper](https://www.sciencedirect.com/science/article/abs/pii/S0950705120304536) | [IIS-tyust/MS-MTO](https://github.com/IIS-tyust/MS-MTO) |

## 8. Others

| Algorithm |                            Paper                             |                     Original Repository                      |
| :-------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
| AutoSAEA  | Surrogate-Assisted Evolutionary Algorithm With Model and Infill Criterion Auto-Configuration *2024* [paper](https://ieeexplore.ieee.org/document/1071212) |                              -                               |
|  CESAEA   | A Classifier-Ensemble-Based Surrogate-Assisted Evolutionary Algorithm for Distributed Data-Driven Optimization *2024* [paper](https://ieeexplore.ieee.org/abstract/document/10418547) |                              -                               |
|   KCCMO   | Balancing Objective Optimization and Constraint Satisfaction in Expensive Constrained Evolutionary Multiobjective Optimization *2023* [paper](https://ieeexplore.ieee.org/abstract/document/10197630) |                              -                               |
|   HRCEA   | A Hybrid Regressor and Classifier-Assisted Evolutionary Algorithm for Expensive Optimization With Incomplete Constraint Information *2023* [paper](https://ieeexplore.ieee.org/abstract/document/10093887) |       [HRCEA](https://github.com/CarrieWei/HRCEA_Code)       |
|  RF-CNS   | A random forest assisted evolutionary algorithm using competitive neighborhood search for expensive constrained combinatorial optimization *2021* [paper](https://link.springer.com/article/10.1007/s12293-021-00326-9) | [HandingWangXDGroup/RF-CNS](https://github.com/HandingWangXDGroup/RF-CNS) |


## 9. Benchmarks & Applications

| Algorithm |                            Paper                             |                    Original Repository                    |
| :-------: | :----------------------------------------------------------: | :-------------------------------------------------------: |
| SDDObench | SDDObench: A Benchmark for Streaming Data-Driven Optimization with Concept Drift *2024* [paper](https://dl.acm.org/doi/10.1145/3638529.3654063) | [LabGong/SDDObench](https://github.com/LabGong/SDDObench) |
| DDEA-DLS  | Automated Team Assembly in Mobile Games: A Data-Driven Evolutionary Approach using a Deep Learning Surrogate *2022* [paper](https://ieeexplore.ieee.org/document/9693290/) |                             -                             |

*The annotation [offline] indicates the offline DDEAs that are purely data-driven without any new funtion evalutions during the optimization.*
