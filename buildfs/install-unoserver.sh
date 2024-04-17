#!/usr/bin/env bash

# Activate Python virtual environment
# Install unoserver
# Prepare /etc/bash/bashrc
PYTHON_VIRTUALENV_PATH="${PYTHON_VIRTUALENV_PATH:-/venv}"
python3 -m venv "${PYTHON_VIRTUALENV_PATH}" && {
	source "${PYTHON_VIRTUALENV_PATH}/bin/activate"
	pip3 install --no-cache unoserver==1.6
	echo 'PYTHON_VIRTUALENV_PATH="${PYTHON_VIRTUALENV_PATH:-/venv}"' >> /etc/bash/bashrc
	echo 'source "${PYTHON_VIRTUALENV_PATH}/bin/activate"' >> /etc/bash/bashrc
}
