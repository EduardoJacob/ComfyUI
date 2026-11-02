
# Remove Background

image = file.path(comfyui_input_folder,"Brilliant.png")
rstudiotools::displaymedia(image)
image = COMFYUI("./workflows/remove_background.json",image=image)
rstudiotools::displaymedia( file.path(comfyui_output_folder,image) )




image = file.path(comfyui_input_folder,"greenBottle.jpeg")
rstudiotools::displaymedia(image)
image = COMFYUI("./workflows/remove_background.json",image=image)
rstudiotools::displaymedia( file.path(comfyui_output_folder,image) )



