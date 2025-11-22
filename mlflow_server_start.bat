@echo off
REM Activate the ml_crash_course conda environment and start MLflow UI server

REM Activate the conda environment
call conda activate ml_crash_course

REM Start MLflow UI with SQLite backend
REM Open browser in background after brief delay
timeout /t 2 /nobreak >nul
start "" http://localhost:5000/

REM Start MLflow server (runs in foreground)
mlflow ui --backend-store-uri sqlite:///mlflow.db --host 127.0.0.1

REM Keep the window open if there's an error
pause