

# Upscale image using 4x_NMKD-Siax_200k.pth model

utils::browseURL("https://twinlens.app")

image1 = file.path(comfyui_input_folder,"Man1.jpg")
rstudiotools::displaymedia(image1)
  
image2 = COMFYUI("./workflows/upscaler4x_NMKD_image_image.json",image=image1,scale=1)
image2 = file.path(comfyui_output_folder,image2)
rstudiotools::displaymedia( image2 )

# shell.exec(comfyui_output_folder)

# COMFYUI_IMAGE_COMPARER(image=image1,second_image=image2) It doesn't work
 