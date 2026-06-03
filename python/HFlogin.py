
# Hugging Face Hub Login
# git --version
# python --version
# py -0
# python -m pip install huggingface_hub


# py -3.11 -m venv hf_env
# hf_env\Scripts\activate
# python -m pip install --upgrade pip
# pip install huggingface_hub
# python -c "import sys; print(sys.executable)"
# python -c "import httpx; print(httpx.get('https://huggingface.co').status_code)"
# python -c "from huggingface_hub import login; login()"


# python -m pip install --upgrade pip
# python -m pip install --upgrade huggingface_hub httpx requests certifi

# python HFlogin.py

from huggingface_hub import login
login()

