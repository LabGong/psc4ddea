# REMO
Expensive Multiobjective Optimization by Relation Learning and Prediction

![REMO_framework](./figure/REMO_framework.png)

This is the official implementation of **REMO** on `PlatEMO v2.8`.

## Example
```matlab
main('-algorithm',@REMO,'-problem',@DTLZ1,'-N',50,'-D',10,'-evaluation',300,'-M',3,'-run',1);
```