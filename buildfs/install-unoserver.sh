#!/usr/bin/env bash
BASHRC_FILE="/etc/bash/bashrc"

# Fallback to root's .bashrc if /etc/bash/bashrc does not exist
if [ ! -f "${BASHRC_FILE}" ]; then
	BASHRC_FILE="/root/.bashrc"
fi

# Activate Python virtual environment
PYTHON_VIRTUALENV_PATH="${PYTHON_VIRTUALENV_PATH:-/venv}"
python3 -m venv "${PYTHON_VIRTUALENV_PATH}"

# Install unoserver
source "${PYTHON_VIRTUALENV_PATH}/bin/activate"
pip3 install --no-cache unoserver==1.6

# Prepare BASHRC_FILE
echo 'PYTHON_VIRTUALENV_PATH="${PYTHON_VIRTUALENV_PATH:-/venv}"' >> ${BASHRC_FILE}
echo 'source "${PYTHON_VIRTUALENV_PATH}/bin/activate"' >> ${BASHRC_FILE}
