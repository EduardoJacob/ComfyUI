


audio = "C:/MEGA/Music/Marillion - Misplaced Childhood/Marillion - Misplaced Childhood - 08 - Blind Curve.mp3"
rstudiotools::displaymedia(audio)

prompt = "Sejam bem vindos ao meu novo tutorial R com RStudio, desta feita dedicado a controlar o ComfyUI a partir do RStudio"
workflow = "./workflows/qwen3tts_text_speech.json"
  
audio = COMFYUI(workflow=workflow)
audio = COMFYUI(workflow=workflow,prompt=prompt)
audio = file.path(comfyui_output_folder,audio)
rstudiotools::displaymedia(audio)

# shell.exec(comfyui_output_folder)

 