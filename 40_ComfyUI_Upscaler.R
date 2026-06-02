

input_folder = "P:/temp/images"
files = list.files(input_folder,full.names=T)

start = 1
end = length(files)
end = 2

i = 1
for ( i in start:end ) {
  f = files[i] 
  cat("\nProcessing file",i,"/",end,":",f,"\n")
  
  output_image = COMFYUI("./workflows/upscaler_image_image.json",image=f,scale=0.5)
  rstudiotools::displaymedia( file.path(comfyui_output_folder,output_image) )
}

shell.exec(comfyui_output_folder)

