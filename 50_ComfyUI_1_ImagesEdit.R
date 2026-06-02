

prompt = COMFYUI(workflow="./workflows/QwenVL3_text_text.json")
prompt = COMFYUI(workflow="./workflows/QwenVL3_text_text.json",prompt="Qual a capital da China ?")

prompt = COMFYUI(workflow="./workflows/QwenVL3_text_text.json",prompt="generate a prompt for a cute westie puppy")

prompt = minifunctions::editvariable(prompt)


image = COMFYUI(workflow="./workflows/flux_text_image.json",prompt=prompt)
rstudiotools::displaymedia( file.path(comfyui_output_folder,image) )

image = COMFYUI(workflow="./workflows/flux9b_text_image.json",prompt=prompt)
rstudiotools::displaymedia( file.path(comfyui_output_folder,image) )

image = COMFYUI(workflow="./workflows/zit_text_image.json",prompt=prompt)
rstudiotools::displaymedia( file.path(comfyui_output_folder,image) )

# Image Edit 1
full_image = file.path(comfyui_output_folder,image)
prompt = "Remove all the balls from the background"
image = COMFYUI(workflow="./workflows/flux9b_image_image.json",prompt=prompt,image=full_image)
rstudiotools::displaymedia( file.path(comfyui_output_folder,image) )

# Image Edit 2
full_image = file.path(comfyui_output_folder,image)
prompt = "Change the style of the picture to a water color illustration"
image = COMFYUI(workflow="./workflows/flux9b_image_image.json",prompt=prompt,image=full_image)
rstudiotools::displaymedia( file.path(comfyui_output_folder,image) )

# Image Edit 3
image = file.path(comfyui_input_folder,"Man1.jpg")
rstudiotools::displaymedia(image) 
prompt = "Make the man crying"
image = COMFYUI(workflow="./workflows/flux9b_image_image.json",prompt=prompt,image=image)
rstudiotools::displaymedia( file.path(comfyui_output_folder,image) )


# Analyze a video and generate a prompt describing its content
# Video must reside in the ComfyUI input folder and be in a compatible format (e.g., MP4)
# prompt = COMFYUI(workflow="./workflows/QwenVL3_video_text.json",video="DanceVideo.mp4")






