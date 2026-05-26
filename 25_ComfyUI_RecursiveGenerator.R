

source("ComfyUIfunctions.R")

workflow1 = "./workflows/QwenVL3.json"
workflow2 = "./workflows/flux.json"

# Initialize Root image
image = "nunchaku_00005_.png"

N = 10
for ( i in 1:N ) {
  cat("\nRecursive Process",i,"/",N,":\n")
  image = file.path(comfyui_output_folder,image)
  rstudiotools::displaymedia(image)
  prompt = COMFYUI(workflow=workflow1,image=image)
  image  = COMFYUI(workflow=workflow2,prompt=prompt)
}





