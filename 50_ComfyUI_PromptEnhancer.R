

source("ComfyUIfunctions.R")

workflow1 = "./workflows/QwenVL3_text_text.json"
workflow2 = "./workflows/flux_text_image.json"

prompt = COMFYUI(workflow= workflow1,prompt="generate a prompt for a cute westie puppy")
image = COMFYUI(workflow= workflow2,prompt=prompt)
rstudiotools::displaymedia( file.path(comfyui_output_folder,image) )

prompt = COMFYUI(workflow= workflow1,prompt="generate a prompt for a cute cat, only give me the prompt")
image = COMFYUI(workflow= workflow2,prompt=prompt)
rstudiotools::displaymedia( file.path(comfyui_output_folder,image) )

prompt = COMFYUI(workflow= workflow1,prompt="Qual a capital da China ?")



