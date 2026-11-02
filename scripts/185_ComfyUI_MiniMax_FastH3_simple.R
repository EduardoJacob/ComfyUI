
# Implementar DURATION
 
source("ComfyUIfunctions.R")

# Load Root Prompt
prompt = file.path("prompts","MiniMaxPrompt.txt")
prompt = paste(readLines(prompt), collapse = " ")
prompt

# Load ComfyUI Workflow
workflow = file.path("workflows","minimax_image_video.json")

# Load Root Images
root_images = list.files(file.path(comfyui_input_folder,"MiniMaxRootImages"),full.names = TRUE)

# Define first_image name
first_image = file.path(comfyui_input_folder,"minimax_first_image.png")
# rstudiotools::displaymedia(first_image)


# Loop through each root image and generate 1 clip for each
for ( image in root_images ) {
  # Copy and rename root image to input folder
  file.copy(from=image,to=first_image,overwrite=TRUE)

  # Submit image to LLM in order to ask for a MiniMax Video Prompt
  LLMprompt = aitools::gemini(prompt,model="3.5-flash-lite",image=first_image)
  LLMprompt = LLMprompt[1]
   
  # Generate new clip
  video = COMFYUI(workflow=workflow,prompt=LLMprompt,image=first_image,duration=10) 
}

# Get-ChildItem -Filter "minimax_image_video_*.mp4" | Sort-Object Name | ForEach-Object { "file '$($_.FullName)'" } | Set-Content -Encoding utf8 files.txt
# ffmpeg -f concat -safe 0 -i files.txt -c copy minimax.mp4









