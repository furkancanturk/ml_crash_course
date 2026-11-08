# Homework Assignment: Taming the Imbalanced Dataset

## Objective

A model can achieve high accuracy while missing many risky credit applicants. This can happen when the classes are imbalanced: the dataset contains fewer **Risk** examples than **Safe** examples. Accuracy alone does not show how well the model identifies the minority class.

Your goal is to improve **recall** and **F1-score** for the Risk class (class 1) using logistic regression. Compare the baseline model with three imbalance-handling approaches. You may also try SMOTE as an optional advanced exercise.

## Dataset and baseline

- Use the German Credit Risk dataset with the following target encoding: **0 = Safe**, **1 = Risk**. Check the encoding before training.
- Split the data into training and test sets using a stratified split and `random_state=42`. Keep the same test set for every approach.
- Use `LogisticRegression(max_iter=1000, random_state=42)` as the baseline model.
- Report accuracy and the precision, recall, and F1-score for **class 1**. Use the same evaluation procedure for all approaches.

Encode categorical features, handle missing values, and scale numerical features as appropriate for logistic regression. Fit preprocessing on training data only; when using cross-validation, fit it separately within each training fold, for example with a pipeline. Keep preprocessing consistent across the approaches.

Keep the test set untouched while developing your models. If you need to choose a threshold or tune a model, use a validation split or cross-validation within the training data. Evaluate the selected approach on the test set afterwards. Check for convergence warnings and adjust `max_iter` if needed, documenting any changes.

## Techniques to implement and compare

### 1. Cost-sensitive learning: class weights

**Task:** Train a logistic regression model with `class_weight='balanced'`, keeping the other baseline settings unchanged.

**Theory:** Class weights give more importance to errors involving the minority class during training. This may improve recall, although the result is not guaranteed.

### 2. Threshold moving

**Task:** Use the baseline model's `predict_proba()` output for class 1 instead of relying on `predict()`. Compare thresholds such as 0.2, 0.3, and 0.4 on validation data, and select one using validation F1-score. Then apply the selected threshold to test-set probabilities. For example, with a threshold of 0.3, predict Risk when the class 1 probability is **at least 0.3**.

**Theory:** The default binary decision threshold is generally 0.5. Lowering it typically increases recall, but can reduce precision because more safe applicants may be classified as risky. The best threshold depends on the goal and the relative costs of mistakes.

### 3. Random oversampling

**Task:** Randomly duplicate Risk examples in the training data until the two classes have approximately the same number of examples. You may use `sklearn.utils.resample` or a suitable tool from `imbalanced-learn`. Set a random seed for reproducibility, then train a new logistic regression model on the resampled training data.

**Important:** Split the data first. Oversample only the data used to fit the model—never the validation or test set. When using cross-validation, oversample separately inside each training fold.

### 4. SMOTE (optional / advanced)

**Task:** Use `imblearn.over_sampling.SMOTE` to generate synthetic minority-class examples from the training data, then train a new logistic regression model. Apply resampling inside each training fold when using cross-validation.

**Theory:** SMOTE creates synthetic examples by interpolating between minority-class neighbors. Unlike random oversampling, it does not merely duplicate rows. It can help in some settings, but it does not guarantee better generalization. Ordinary SMOTE may produce invalid combinations for categorical features; use an appropriate categorical-aware method and preprocessing where needed.

## Deliverable: comparison table

Create a table using your own test-set results. The baseline row below contains **illustrative values only**, not expected results. Include the selected threshold and add a SMOTE row if you complete the optional exercise.

| Technique | Accuracy | Precision (class 1) | Recall (class 1) | F1-score (class 1) |
|---|---:|---:|---:|---:|
| Baseline: logistic regression | 0.76 | 0.60 | 0.45 | 0.51 |
| Class weights | ? | ? | ? | ? |
| Threshold moving (selected threshold: ___) | ? | ? | ? | ? |
| Random oversampling | ? | ? | ? | ? |
| SMOTE (optional) | ? | ? | ? | ? |

Briefly describe your validation procedure, selected threshold, and any preprocessing or resampling you used. Include enough code to reproduce your results.

## Reflection questions

1. Which technique achieved the highest recall for the Risk class? What happened to its precision compared with the baseline?
2. Why is it dangerous to oversample before splitting the data into training and test sets?
3. If you were the bank manager, how would you balance precision and recall? Consider the cost of approving a bad loan and the cost of incorrectly rejecting a safe applicant.
