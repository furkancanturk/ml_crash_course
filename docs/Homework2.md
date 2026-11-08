# Homework: Hyperparameter Optimization with Optuna

## Objective

Grid search evaluates a predefined set of hyperparameter combinations. Grid search is straightforward, but a large grid can be expensive and only evaluates the specified values.

In this assignment, use **Optuna** and its **Tree-structured Parzen Estimator (TPE)** sampler to search richer hyperparameter spaces for XGBoost, LightGBM, and CatBoost models on the Ames Housing dataset. Your goal is to minimize cross-validation RMSE and compare your results with grid search.

TPE uses results from previous trials to guide its search. It does **not** guarantee finding the global minimum or outperforming grid search within a limited number of trials.

## Prerequisites

Install Optuna in the environment used for the notebook or script. For example, use `uv add optuna` in a uv-managed project, or `conda install optuna -c conda-forge` in a Conda environment. You also need scikit-learn, XGBoost, LightGBM, and CatBoost.

## Tasks

1. **Load the data.** Use the Ames Housing dataset and prepare a train/test split and preprocessing approach for the regression task. Preserve the test set for final evaluation.
2. **Define objective functions.** Write an Optuna objective for each of XGBoost, LightGBM, and CatBoost. Each trial should return the mean validation RMSE across the same cross-validation folds. Minimize this value.
3. **Optimize.** Run 50–100 trials for each model using `TPESampler(seed=42)`. Record the number of trials, best parameters, best cross-validation RMSE, and elapsed time.
4. **Evaluate and compare.** Refit each model with its selected parameters on the full training set, then report its RMSE on the held-out test set. Compare with grid search using the same data split, preprocessing, metric scale, and evaluation protocol.

Use the same cross-validation splits for all trials and, where possible, for the grid search comparison. Fit preprocessing separately within each training fold—for example, using a pipeline—to avoid data leakage. If the target was transformed, state whether RMSE is measured on the transformed or original scale; compare scores only when their scales match. Do not use the test set to select hyperparameters. If you use early stopping, its validation data must also come from within the training folds.

Set model random seeds where supported. A fixed seed improves reproducibility, although hardware and parallel execution can still affect results.

## Hyperparameter search spaces

Use `trial.suggest_int()` for integer ranges, `trial.suggest_float(..., log=True)` for log-uniform ranges, and `trial.suggest_float()` for uniform ranges. Not every parameter below is continuous: tree counts, depths, and leaf counts are integers.

### A. XGBoost

| Parameter | Search range | Purpose |
|---|---|---|
| `n_estimators` | Integer: 100–1,000 | Number of boosting trees |
| `learning_rate` | Log-uniform: 0.001–0.3 | Learning rate |
| `max_depth` | Integer: 3–10 | Maximum tree depth |
| `subsample` | Uniform: 0.5–1.0 | Fraction of training rows sampled |
| `colsample_bytree` | Uniform: 0.5–1.0 | Fraction of features sampled per tree |
| `reg_alpha` | Log-uniform: 1e-8–10.0 | L1 regularization |
| `reg_lambda` | Log-uniform: 1e-8–10.0 | L2 regularization |

### B. LightGBM

| Parameter | Search range | Purpose |
|---|---|---|
| `n_estimators` | Integer: 100–1,000 | Number of boosting trees |
| `learning_rate` | Log-uniform: 0.001–0.3 | Learning rate |
| `num_leaves` | Integer: 20–150 | Maximum number of leaves per tree |
| `min_child_samples` | Integer: 5–100 | Minimum number of observations in a leaf |
| `subsample` | Uniform: 0.5–1.0 | Fraction of training rows sampled |
| `colsample_bytree` | Uniform: 0.5–1.0 | Fraction of features sampled per tree |

Set `subsample_freq=1` so that the sampled `subsample` values actually enable row sampling. `num_leaves` and `max_depth` both affect tree complexity; keep the latter consistent across trials unless you explicitly add it to the search.

### C. CatBoost

| Parameter | Search range | Purpose |
|---|---|---|
| `iterations` | Integer: 100–1,000 | Number of boosting iterations |
| `learning_rate` | Log-uniform: 0.001–0.3 | Learning rate |
| `depth` | Integer: 4–10 | Tree depth |
| `l2_leaf_reg` | Log-uniform: 1e-8–10.0 | L2 regularization coefficient |
| `random_strength` | Uniform: 1e-9–10.0 | Randomness added when scoring splits |
| `bagging_temperature` | Uniform: 0.0–1.0 | Controls the randomness of Bayesian bootstrap weights |

Set `bootstrap_type='Bayesian'` when tuning `bagging_temperature`. If you use CatBoost's native categorical feature handling, apply it consistently across folds and explain how it compares with the preprocessing used for grid search.

## Deliverables

Submit your reproducible Python script or notebook and fill in the table below. Use the **held-out test RMSE** for both columns; report cross-validation scores separately. Calculate improvement as `Grid Search test RMSE − Optuna test RMSE`: a positive value means Optuna performed better on the test set.

| Model | Grid Search test RMSE | Optuna test RMSE | Improvement |
|---|---:|---:|---:|
| XGBoost | [Fill] | [Fill] | [Calculate] |
| LightGBM | [Fill] | [Fill] | [Calculate] |
| CatBoost | [Fill] | [Fill] | [Calculate] |

Include the best parameters and cross-validation RMSE for each model, the number of folds and trials, the random seeds, elapsed optimization times, and relevant preprocessing details. If the grid search results used a different split, metric scale, preprocessing, or evaluation method, explain the limitation instead of treating the numbers as a controlled comparison.

## Reflection questions

1. **Speed:** Was Optuna faster or slower than grid search? Compare measured elapsed time, the number of configurations, and the approximate number of fits (`configurations × CV folds`), excluding any final refits. Why can fit times differ between configurations?
2. **Regularization:** What `reg_alpha` and `reg_lambda` values did the best XGBoost trial select? How do they compare with the defaults and the search ranges? Can those values alone establish whether the default model overfits or underfits? What additional training and validation evidence would help?
3. **Evaluation:** Did a lower cross-validation RMSE also produce a lower test RMSE? What might explain a difference?

## References

- [Optuna TPE sampler](https://optuna.readthedocs.io/en/stable/reference/samplers/generated/optuna.samplers.TPESampler.html)
- [LightGBM regressor parameters](https://lightgbm.readthedocs.io/en/stable/pythonapi/lightgbm.LGBMRegressor.html)
- [CatBoost common training parameters](https://catboost.ai/docs/en/references/training-parameters/common)
