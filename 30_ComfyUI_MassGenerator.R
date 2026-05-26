

source("ComfyUIfunctions.R")
 
prompts = readLines("./prompts/prompts.txt", encoding = "UTF-8")
workflow = "./workflows/zit.json"
workflow = "./workflows/nunchaku-zit.json"
workflow = "./workflows/flux.json"
# workflow = "./workflows/juggernaut-reborn.json" # old model
workflow = "./workflows/flux-2x.json"
workflow = "./workflows/zit-2x.json"

start = 1
end = length(prompts)
N = 1 # Number of images to generate per prompt

start = 1
end = 9
# N = 5 # Number of images to generate per prompt

i = 1
for ( i in start:end ) {
  prompt = prompts[i]
  cat("\nProcessing prompt",i,"/",end,":\n",prompt,"\n\n") 
  
  for ( j in 1:N ) {
    output_image = COMFYUI(workflow=workflow,prompt=prompt)
    rstudiotools::displaymedia( file.path(comfyui_output_folder,output_image) )
  }
  
}

shell.exec(comfyui_output_folder)



