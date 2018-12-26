# Credit Risk Analysis and Predictive Modeling

This report entails the analysis on German Credit dataset, which has 1000 past credit applicants, described by 30 variables. Each applicant is rated as ‘Good’ or ‘Bad’ credit (encoded as 1 and 0 respectively). It’s important to look at various characteristics of an applicant and develop a credit scoring rule that can help determine if a loan applicant can be a defaulter at a later stage so that they can go ahead and grant the loan or not. 

The models used for predictive modeling are: Decision Trees, AdaBoost and Random Forest.
The performance measures used to evaluate the models are: Confusion Matrix, ROC and Area under the curve (AUC).

The results of the model have been quantified for it to make sense for real businesses, hence it also contains the analysis on the cost incurred by financial institutions assuming:
- Cost incurred by financial institution if the good applicant gets classified as bad applicant = 100 DM
- Cost incurred by financial institution if the bad applicant gets classified as good applicant = 500 DM

Based on the best model, the important variables have been chosen after careful analysis. The model is then deployed using RShiny as an interactive application.

