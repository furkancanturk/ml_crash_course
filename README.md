# Introduction to ML Crash Course

## Environment Setup

### 1. Create Conda Environment

First, create the conda environment from the `environment.yml` file:

```bash
conda env create -f environment.yml
```

This command will:
- Create a new environment named `ml_crash_course`
- Install Python 3.12
- Install all required dependencies (pandas, numpy, scikit-learn, xgboost, lightgbm, catboost, mlflow, etc.)

### 2. Activate the Environment

After the environment is created, activate it:

```bash
conda activate ml_crash_course
```

## Running MLflow Server

The MLflow server tracks all your model experiments and provides a web UI for visualization.

### Option 1: Using the Batch Script (Windows)

Use the provided `mlflow_server_start.bat` file:

```batch
mlflow_server_start.bat
```

This automatically:
- Activates the `ml_crash_course` environment
- Starts the MLflow UI server
- Configures the SQLite backend at `mlruns/mlflow.db`
- Opens the browser at `http://127.0.0.1:5000`

### Option 2: After Activating Environment

Once your environment is activated, you can run MLflow directly:

```bash
# First activate the environment
conda activate ml_crash_course

# Then run MLflow
mlflow ui --backend-store-uri sqlite:///mlruns/mlflow.db
```

## Accessing MLflow UI

Once the server is running, open your browser and navigate to:

```
http://127.0.0.1:5000
```

You'll see:
- **Experiments:** List of all tracked experiments
- **Runs:** Individual model training runs with hyperparameters and metrics
- **Line Charts:** Visualization of HPO iterations showing how metrics improve across parameter combinations
- **Leaderboard:** Model comparison sorted by performance metrics

![MLflow Dashboard](mlflow_dashboard.png)

*MLflow UI showing experiments, metrics, and model comparison*

## Running Experiments

### Step 1: Prepare Data and Models

Execute cells 1-6 in `block2.ipynb` to:
- Load the Ames Housing dataset
- Preprocess data with appropriate encoders
- Define the pipeline factory
- Setup MLflow experiment tracking

### Step 2: Run Hyperparameter Optimization

Execute cell 7 (Execution Loop) to:
- Setup MLflow experiment (handles deleted experiments automatically)
- Run grid search for each model:
  - Linear Regression
  - Decision Tree
  - XGBoost
  - LightGBM
  - CatBoost
- Log all HPO iterations with model-specific metric names
- Display a leaderboard of results

### Step 3: View Results in MLflow UI

The metrics are logged with model-namespaced names:
- `xgboost/cv_rmse_mean`
- `lightgbm/cv_rmse_mean`
- `decision_tree/cv_rmse_mean`
- etc.

Each model gets a **consistent color** across all visualizations for easy comparison.

## Understanding the Output

### Line Charts

Each model's line chart shows:
- **X-axis:** HPO iteration steps (0 to N)
- **Y-axis:** Metric values (CV RMSE, Training RMSE, etc.)
- **Color:** Consistent per model name
- **Dots:** Each HPO iteration

### Final Leaderboard

After all experiments complete, you'll see:
- **Model:** Name of the model
- **Test RMSE:** Error on held-out test set
- **Test R²:** R-squared score on test set
- **Best Params:** Optimal hyperparameters found by grid search

## Troubleshooting

### Issue: "Cannot set a deleted experiment"

If you manually deleted an experiment in MLflow:
1. The code automatically detects this
2. It either restores the experiment or creates a new one with a timestamp suffix
3. No manual intervention needed - just re-run the cells

### Issue: "ModuleNotFoundError: No module named 'mlflow'"

Ensure the environment is properly activated:
```bash
conda activate ml_crash_course
python -c "import mlflow; print(mlflow.__version__)"
```

### Issue: Port 5000 Already in Use

If port 5000 is busy, specify a different port:
```bash
C:/Users/Asus/miniconda3/envs/ml_crash_course/python.exe -m mlflow ui --backend-store-uri sqlite:///mlruns/mlflow.db --port 5001
```

Then access at `http://127.0.0.1:5001`

## Key Learnings

### Overfitting vs Underfitting

- **Linear Regression:** Often underfits (high bias, stable performance)
- **Decision Tree (no limits):** Often overfits (low bias, high variance)
- **Gradient Boosting (XGB/LGBM/Cat):** Balances bias-variance through ensemble methods

### Model-Specific Preprocessing

- **CatBoost:** Special handling for categorical features with Ordinal Encoding
- **Other Models:** Standard One-Hot Encoding for categorical features
- **All Models:** Standardized numerical features

### Hyperparameter Optimization

Grid search evaluates all parameter combinations:
- Cross-validation RMSE: Average error across CV folds
- Train RMSE: Error on training set (detects overfitting if much lower than CV)
- Test RMSE: Final evaluation on held-out test set
