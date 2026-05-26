

source("ComfyUIfunctions.R")

workflow = "./workflows/zit.json"

filename_prefix = tools::file_path_sans_ext(basename(workflow))

# create image zit_00000_.png

i = 0
for ( i in 0:3 ) {
  image = paste0(filename_prefix,"_",sprintf("%05d",i),"_.png")
  image_full_name = file.path(comfyui_output_folder,image)
  rstudiotools::displaymedia(image_full_name)
  
  system2("powershell", args = c("-File", paste0('./powershell/LMstudioStart.ps1')), stdout = T, stderr = F, wait = T)
  
  prompt = aitools::lmstudio(
    prompt = "Describe this image in no more than 100 words, suitable for the Z-Image-Turbo model",
    image = image_full_name
  )[1]
  
  system2("powershell", args = c("-File", paste0('./powershell/LMstudioEnd.ps1')), stdout = T, stderr = F, wait = T)
  
  # Remove newlines from the prompt
  prompt = stringr::str_squish(prompt)
  
  cat( cli::rule(left = image, col = "blue"),"\n",prompt,"\n\n" )
   
  # Call ComfyUI API to generate a new image based on the image Prompt
  new_image = COMFYUI(workflow,prompt)
}





