
# Generate video from image - Optimized to 1280 x 720

image = file.path(comfyui_input_folder,"TugaStone.jpg")
rstudiotools::displaymedia(image)

prompt = "The man takes off his glasses with his hand"
  
video = COMFYUI("./workflows/wan_image_video.json",prompt=prompt,image=image,duration = 2)
video = file.path(comfyui_output_folder,video)
rstudiotools::displaymedia(video)

# shell.exec(comfyui_output_folder)
 

image = file.path(comfyui_output_folder,"zit_text_image_00005_.png")
rstudiotools::displaymedia(image)

prompt = "The little monkey gets up and jumps, the camera follows the head of the monkey"

video = COMFYUI("./workflows/wan_image_video.json",prompt=prompt,image=image,duration = 3)  
video = file.path(comfyui_output_folder,video)
rstudiotools::displaymedia(video)




 