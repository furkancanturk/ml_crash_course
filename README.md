# Introduction to ML Crash Course

## Environment Setup

The project uses Python 3.14 and [uv](https://docs.astral.sh/uv/). Dependencies are declared in `pyproject.toml` and locked in `uv.lock`.

### Install uv

On Linux or macOS, run in a terminal:

```sh
curl -LsSf https://astral.sh/uv/install.sh | sh
```

On Windows, run in PowerShell:

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

Restart your terminal if needed, then verify the installation with `uv --version`. See the [official installation guide](https://docs.astral.sh/uv/getting-started/installation/) for alternative installation methods.

### Set up the project

From the repository root, run:

```sh
uv sync --python 3.14
```

`uv sync` creates `.venv` and installs the locked dependencies. If Python 3.14 is not available locally, uv can download it. Optionally activate the environment:

Linux and macOS (bash/zsh):

```sh
source .venv/bin/activate
```

Windows (PowerShell):

```powershell
.\.venv\Scripts\Activate.ps1
```

To launch JupyterLab without activating the environment, run `uv run jupyter lab`.

## Exercises

See the [exercise guide](exercises/README.md) for notebooks, experiment tracking, and troubleshooting.

## Attribution

The [`Interactive Decision Tree`](Interactive%20Decision%20Tree/) folder contains third-party material from Avi Chawla's [“Interactively Prune a Decision Tree”](https://blog.dailydoseofds.com/p/interactively-prune-a-decision-tree) (Daily Dose of Data Science, April 7, 2024). See the folder's [attribution](Interactive%20Decision%20Tree/ATTRIBUTION.md) for details.
