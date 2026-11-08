# Introduction to ML Crash Course

## Environment Setup

The project uses Python 3.14 and [uv](https://docs.astral.sh/uv/). Dependencies are declared in `pyproject.toml`; uv maintains a local `uv.lock` file. Run the following commands from the repository root in PowerShell:

```powershell
uv sync --python 3.14
.\.venv\Scripts\Activate.ps1
```

`uv sync` creates `.venv` and installs the locked dependencies. To launch JupyterLab without activating the environment, run `uv run jupyter lab`.

## Running MLflow Server

From the repository root, start the MLflow UI using the uv environment:

```powershell
uv run mlflow ui --backend-store-uri sqlite:///mlflow.db --host 127.0.0.1
```

The existing `mlflow_server_start.bat` instead activates the Conda environment; it does not use `.venv`.

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
```powershell
.\.venv\Scripts\Activate.ps1
python -c "import mlflow; print(mlflow.__version__)"
```

### Issue: Port 5000 Already in Use

If port 5000 is busy, specify a different port:
```powershell
uv run mlflow ui --backend-store-uri sqlite:///mlflow.db --port 5001
```

Then access at `http://127.0.0.1:5001`


## Attribution

The [`Interactive Decision Tree`](Interactive%20Decision%20Tree/) folder contains third-party material from Avi Chawla's [“Interactively Prune a Decision Tree”](https://blog.dailydoseofds.com/p/interactively-prune-a-decision-tree) (Daily Dose of Data Science, April 7, 2024). See the folder's [attribution](Interactive%20Decision%20Tree/ATTRIBUTION.md) for details.
