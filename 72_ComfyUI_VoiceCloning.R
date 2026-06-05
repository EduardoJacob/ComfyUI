


prompt = "Sejam bem vindos ao meu novo tutorial R com RStudio, desta feita dedicado a controlar o ComfyUI a partir do RStudio"

workflow = "./workflows/qwen3tts_voice_cloning.json"
audio = COMFYUI(workflow=workflow,prompt=prompt)
audio = file.path(comfyui_output_folder,audio)
rstudiotools::displaymedia(audio)

workflow = "./workflows/qwen3tts_voice_cloning_with_profile.json"
audio = COMFYUI(workflow=workflow,prompt=prompt)
audio = file.path(comfyui_output_folder,audio)
rstudiotools::displaymedia(audio)



# shell.exec(comfyui_output_folder)
 
 