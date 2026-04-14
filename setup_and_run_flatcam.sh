#!/bin/bash

set -e

# -------- CONFIG --------
ENV_DIR="$HOME/flatcam-env"
REPO_DIR="$HOME/flatcam_beta"
PYTHON_VERSION="3.10.16"
PYTHON_BIN=""

echo "🔧 FlatCAM Full Auto Setup + Interactive Shell Starting..."

# =========================================================
# 1. CHECK / INSTALL PYTHON 3.10
# =========================================================
PYTHON_BIN=$(command -v python3.10 || true)
if [ -z "$PYTHON_BIN" ]; then
    echo "❌ python3.10 not found. Installing Python 3.10..."

    if command -v brew >/dev/null 2>&1; then
        echo "🍺 Homebrew found. Installing python@3.10..."
        brew install python@3.10
        export PATH="$(brew --prefix python@3.10)/bin:$PATH"
    elif command -v pyenv >/dev/null 2>&1; then
        echo "🐍 pyenv found. Installing Python $PYTHON_VERSION..."
        pyenv install -s "$PYTHON_VERSION"
        export PATH="$(pyenv root)/versions/$PYTHON_VERSION/bin:$PATH"
    else
        echo "❌ Homebrew or pyenv is required to install Python 3.10 on macOS."
        echo "   Install Homebrew (https://brew.sh) or pyenv and re-run this script."
        exit 1
    fi

    PYTHON_BIN=$(command -v python3.10 || true)
    if [ -z "$PYTHON_BIN" ]; then
        echo "❌ Failed to locate python3.10 after install."
        exit 1
    fi
fi

python_version=$("$PYTHON_BIN" --version 2>&1 || true)
if [[ "$python_version" != "Python 3.10"* ]]; then
    echo "❌ python3.10 was found but is not Python 3.10: $python_version"
    exit 1
fi

echo "✅ Python 3.10 ready: $PYTHON_BIN"

# =========================================================
# 2. CLONE REPO IF MISSING
# =========================================================
if [ -d "$REPO_DIR" ]; then
    echo "✅ FlatCAM repo exists"
else
    echo "📥 Cloning FlatCAM repo..."
    git clone https://bitbucket.org/marius_stanciu/flatcam_beta.git "$REPO_DIR"
fi

# =========================================================
# 3. CREATE VENV IF MISSING
# =========================================================
if [ -d "$ENV_DIR" ]; then
    if [ -x "$ENV_DIR/bin/python" ]; then
        env_version=$("$ENV_DIR/bin/python" --version 2>&1 || true)
        if [[ "$env_version" != "Python 3.10"* ]]; then
            echo "⚠️ Existing virtualenv uses $env_version, recreating with Python 3.10..."
            rm -rf "$ENV_DIR"
            echo "🧪 Creating virtual environment with Python 3.10..."
            "$PYTHON_BIN" -m venv "$ENV_DIR"
        else
            echo "✅ Virtual environment exists and uses Python 3.10"
        fi
    else
        echo "⚠️ Existing virtualenv is invalid, recreating..."
        rm -rf "$ENV_DIR"
        echo "🧪 Creating virtual environment with Python 3.10..."
        "$PYTHON_BIN" -m venv "$ENV_DIR"
    fi
else
    echo "🧪 Creating virtual environment with Python 3.10..."
    "$PYTHON_BIN" -m venv "$ENV_DIR"
fi

echo "🧪 Activating virtual environment..."
source "$ENV_DIR/bin/activate"

echo "✅ Venv activated"
echo "Python path: $(which python)"
python_version=$(python --version 2>&1 || true)
echo "$python_version"
if [[ "$python_version" != "Python 3.10"* ]]; then
    echo "❌ Activated virtual environment does not use Python 3.10."
    exit 1
fi

# =========================================================
# 4. INSTALL FLATCAM REQUIREMENTS
# =========================================================
if [ -d "$REPO_DIR" ]; then
    if [ -f "$REPO_DIR/requirements.txt" ]; then
        echo "📦 Installing FlatCAM Python requirements from $REPO_DIR/requirements.txt..."
        pushd "$REPO_DIR" >/dev/null
        pip3 install -r requirements.txt
        popd >/dev/null
    else
        echo "❌ $REPO_DIR/requirements.txt not found."
        exit 1
    fi
else
    echo "❌ FlatCAM repo directory $REPO_DIR not found."
    exit 1
fi


pip install --force-reinstall numpy==1.23.5

echo $PWD
# =========================================================
# 5. LAUNCH FLATCAM
# =========================================================
if [ -f "$REPO_DIR/FlatCAM.py" ]; then
    echo "🚀 Launching FlatCAM..."
    python "$REPO_DIR/FlatCAM.py"
fi