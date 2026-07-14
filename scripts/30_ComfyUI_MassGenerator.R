

source("ComfyUIfunctions.R")

input_folder = "P:/DISKD/WallpapersToLearn"
prompts = "./prompts/wallpapers.txt"


# Check Wallpapers to Learn folder - Rename and Validate Extension ----
minifunctions::imagerenamer(folder=input_folder,image_prefix = "img")

# Analyze images to generate Prompts ----
workflow = "./workflows/QwenVL3_image_text.json"
files = list.files(input_folder,full.names=T)

start = 1
end = length(files)

i = 1
for ( i in start:end ) {
  f = files[i] 
  cat("\nProcessing file",i,"/",end,":",f,"\n")
  rstudiotools::displaymedia(f)
  prompt = COMFYUI(workflow,image=f)
  prompt = stringr::str_squish(prompt)
  # print(prompt)
  write(prompt,file=prompts,append=TRUE)
}


# Generate New images based on recently generated Prompts ----
prompts = readLines(prompts, encoding = "UTF-8")

workflow = "./workflows/zit2x_text_image.json"
# workflow = "./workflows/flux2x_text_image.json"

start = 1
end = length(prompts)

i = 1
for ( i in start:end ) {
  prompt = prompts[i]
  cat("\nProcessing prompt",i,"/",end,":\n",prompt,"\n\n") 
  
  output_image = COMFYUI(workflow=workflow,prompt=prompt)
  rstudiotools::displaymedia( file.path(comfyui_output_folder,output_image) )
  
}

shell.exec(comfyui_output_folder)



