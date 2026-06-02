
from huggingface_hub import snapshot_download

snapshot_download(
    repo_id="Qwen/Qwen3-TTS-12Hz-1.7B-CustomVoice",
    local_dir=r"S:\ComfyUI\ComfyUI-Easy-Install\ComfyUI\models\qwen-tts\Qwen3-TTS-12Hz-1.7B-CustomVoice",
    max_workers=1
)
