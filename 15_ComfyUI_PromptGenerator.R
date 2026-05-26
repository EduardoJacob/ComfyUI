

source("ComfyUIfunctions.R")

input_folder = "P:/temp"
workflow = "./workflows/QwenVL3.json"
files = list.files(input_folder,full.names=T)

start = 1
end = length(files)
# end = 1

i = 1
for ( i in start:end ) {
  f = files[i] 
  cat("\nProcessing file",i,"/",end,":",f,"\n")
  
  output_text = COMFYUI(workflow,image=f)
  
}

shell.exec(comfyui_output_folder)

