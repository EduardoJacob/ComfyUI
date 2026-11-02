
# Implementar DURATION
 
source("ComfyUIfunctions.R")

# Load Root Prompt
prompt = file.path("prompts","MiniMaxPrompt.txt")
prompt = paste(readLines(prompt), collapse = " ")
prompt

# Load ComfyUI Workflow
workflow = file.path("workflows","minimax_image_video.json")

# Define Number of sequential clips for each root image
N = 2

# Load Root Images
root_images = list.files(file.path(comfyui_input_folder,"MiniMaxRootImages"),full.names = TRUE)

# Define first_image 
first_image = file.path(comfyui_input_folder,"minimax_first_image.png")
# rstudiotools::displaymedia(first_image)


# Loop through each root image and generate bunch of clips for each
clip = 1
for ( image in root_images ) {
  # Copy and rename root image to input folder
  file.copy(from=image,to=first_image,overwrite=TRUE)
  
  for ( i in 1:N ) {
    message("Generating Clip ",clip,"/",length(root_images)*N)
    clip = clip + 1
    
    # Submit image to LLM in order to ask for a MiniMax Video Prompt
    LLMprompt = aitools::gemini(prompt,model="3.5-flash-lite",image=first_image)
    LLMprompt = LLMprompt[1]
    print(LLMprompt)
    
    # Generate new clip
    video = COMFYUI(workflow=workflow,prompt=LLMprompt,image=first_image,duration=10) 
    
    # Extract last frame from recently created new clip
    video = file.path(comfyui_output_folder,video)
    video_info = av::av_media_info(video)
    last_frame = video_info[["video"]][["frames"]]
    trim_info = paste0("start_frame=",last_frame-1,":end_frame=",last_frame)
    last_image = av::av_video_images(video, destdir = comfyui_input_folder, trim=trim_info)
    
    # Rename last frame to first frame for next iteration
    file.rename(last_image,first_image)
  }
}

# Get-ChildItem -Filter "minimax_image_video_*.mp4" | Sort-Object Name | ForEach-Object { "file '$($_.FullName)'" } | Set-Content -Encoding utf8 files.txt
# ffmpeg -f concat -safe 0 -i files.txt -c copy minimax.mp4









