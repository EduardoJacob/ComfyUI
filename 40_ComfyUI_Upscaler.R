

source("ComfyUIfunctions.R")

input_folder = "P:/temp"
workflow = "./workflows/upscaler.json"
files = list.files(input_folder,full.names=T)

start = 1
end = length(files)
end = 2

i = 1
for ( i in start:end ) {
  f = files[i] 
  cat("\nProcessing file",i,"/",end,":",f,"\n")
  
  output_image = COMFYUI(workflow,image=f)
  rstudiotools::displaymedia( file.path(comfyui_output_folder,output_image) )
}


