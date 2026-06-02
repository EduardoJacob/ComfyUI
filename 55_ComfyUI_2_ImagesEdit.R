



image1 = file.path(comfyui_input_folder,"Flowers.jpg")
rstudiotools::displaymedia(image1)

image2 = file.path(comfyui_input_folder,"TugaStone.jpg")
rstudiotools::displaymedia(image2)

# 2 Image Edit
prompt = "Put the second image, the image of a man, as it was a logo on the jar"
image = COMFYUI(workflow="./workflows/flux9b_2image_image.json",prompt=prompt,image=image1,second_image=image2)
rstudiotools::displaymedia( file.path(comfyui_output_folder,image) )



