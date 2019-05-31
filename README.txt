Title:   Prefronto-cortical dopamine D1 receptor sensitivity can critically influence working memory maintenance during delayed response tasks

Authors: Melissa Reneaux and Rahul Gupta

Journal: PLoS ONE 

Article: Reneaux M, Gupta R (2018) Prefronto-cortical dopamine D1 receptor sensitivity can critically influence working memory maintenance during delayed response tasks. 
PLoS ONE 13(5): e0198136. https://doi.org/10.1371/journal.pone.0198136

-------------------------------------------------------------------------------------------------------------------------------------------------------------
MATLAB Scripts for computing the nullcline plots as well as the bifurcation profiles and for the numerical simulation of the stochastic mesocortical dynamics 
-------------------------------------------------------------------------------------------------------------------------------------------------------------

1.There are two free parameters in the model: DA-releasability (R_DA) and D1R-sensitivity (D1Rsens).

2.There are five dynamical variables: aPN (pyramidal population activity), aIN (interneuron population activity), aDN (dopamine neuron population activity),
 DA (extracellular cortical dopamine concentration) and D1Ract (level of cortical D1R stimulation or activation).
 
3.To compute the aPN-D1Ract nullcline plot for given values of R_DA and D1Rsens (see Supplementary Figure): Fix the desired values of R_DA and D1Rsens in the script 
  "Nullcline.m" and run. Currently, it is set for the control R_DA = 0.0058 nM.ms^-1 and D1Rsens = 3.

4.To compute the bifurcation profiles of the dynamical variables with respect to the bifurcation parameter R_DA for a given value of D1Rsens (see Figure 2 in the
  main text): Fix the desired value of D1Rsens in the script "Bifurcation.m" and run. Currently, it is set for the control D1Rsens=3.

5.The numerical simulation of the stochastic mesocortical dynamics can be performed using the script "Stochastic.m". It requires declaration:
  (a) of the desired values of R_DA and D1Rsens. Currently, it is set for the control values of R_DA = 0.0058 nM.ms^-1 and D1Rsens=3.
  (b) of the intial values of the aPN, aIN, aDN, DA, D1Ract. The initial values are the unstable fixed points of the respective variables in their bifurcation
      profiles for a particular R_DA and D1Rsens. Currently, it is set for the control values of R_DA and D1Rsens.
  (c) of the Tf, final time-point in seconds, sufficient for attaining the stationary state or equilibration of the dynamics. Currently, it is set at Tf=300sec.

  The output of running the Stochastic.m script is an ensemble of 10^6 equilibrium-associated random values of each dynamical variable. The output is further
  used to create the global potential landscape for the given values of the free parameters by following the procedure described in the Methods of the main text. 

#################In every script, the values needed to be changed according to the change in free parameter are specially mentioned as "FIX THIS VALUE"###############  