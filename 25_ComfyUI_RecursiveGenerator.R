

source("ComfyUIfunctions.R")

workflow1 = "./workflows/QwenVL3_image_text.json"
workflow2 = "./workflows/zit_text_image.json"

# Initialize Root image
image = "zit_text_image_00001_.png"

N = 10
for ( i in 1:N ) {
  cat("\nRecursive Process",i,"/",N,":\n")
  image = file.path(comfyui_output_folder,image)
  rstudiotools::displaymedia(image)
  prompt = COMFYUI(workflow=workflow1,image=image)
  
  prompt = minifunctions::editvariable(prompt)
  
  image  = COMFYUI(workflow=workflow2,prompt=prompt)
}


