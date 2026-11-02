
# Extract Object from Complex Image

# Using traditional Image Editing:
image = file.path(comfyui_input_folder,"GameItems.png")
rstudiotools::displaymedia(image) 
prompt = "Extract the bottle from the image and give me only the bottle"
image = COMFYUI(workflow="./workflows/flux9b_image_image.json",prompt=prompt,image=image)
rstudiotools::displaymedia( file.path(comfyui_output_folder,image) )


# Using specialized model: SAM3 Segmentation model
image = file.path(comfyui_input_folder,"GameItems.png")
rstudiotools::displaymedia(image) 
prompt = "the bottle"
image = COMFYUI(workflow="./workflows/extract_object.json",prompt=prompt,image=image)
rstudiotools::displaymedia( file.path(comfyui_output_folder,image) )


