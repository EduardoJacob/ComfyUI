
 
workflow = "./workflows/QwenVL3_image_text.json"
files = list.files(comfyui_input_folder,full.names=T)

start = 1
end = length(files)
# end = 1

i = 1
for ( i in start:end ) {
  f = files[i] 
  cat("\nProcessing file",i,"/",end,":",f,"\n")
  rstudiotools::displaymedia(f)
  
  output_text = COMFYUI(workflow,image=f)
  
}

shell.exec(comfyui_output_folder)

