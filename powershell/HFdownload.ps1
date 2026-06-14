
$env:HF_HUB_DISABLE_SSL_VERIFY="1"

# Set debug mode to see exactly where the handshake is breaking
$env:HF_DEBUG="1"

# Attempt download with increased timeout
hf download fishaudio/s2-pro --local-dir "S:/ComfyUI/ComfyUI-Easy-Install/ComfyUI/models/fishaudioS2/s2-pro" --max-workers 1


