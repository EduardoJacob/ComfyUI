

source("ComfyUIfunctions.R")

rstudiotools::displaymedia("./screenshots/TextToImageModels.png")

# Make an inventory of models used in workflows
# Using zeallot package for multiple assignment (unpacking) , aka destructuring assignment in other languages
# library("zeallot")
# c(workflows,models,nodes) %<-% COMFYUI_GET_MODELS()

prompts = "./prompts/Prompts20260423.txt"

# Generate New images based on Prompts File ----
prompts = readLines(prompts, encoding = "UTF-8")

# workflow = "./workflows/krea2_text_image.json"
# workflow = "./workflows/zit2x_text_image.json"
# workflow = "./workflows/flux2x_text_image.json"
workflow = "./workflows/qwen21_text_image.json"

start = 1
end = length(prompts)
# end = 1

for ( i in start:end ) {
  prompt = prompts[i]
  cat("\nProcessing prompt",i,"/",end,":\n",prompt,"\n\n") 
  
  output_image = COMFYUI(workflow=workflow,prompt=prompt)
  
  # For speed, bypass the displaymedia function, which is slow for large images
  # rstudiotools::displaymedia( file.path(comfyui_output_folder,output_image) )
  
}

shell.exec(comfyui_output_folder)



# Get the list of images
krea2 = list.files("P:/DISKD/Wallpapers", pattern = "^krea2.*\\.png$", full.names = TRUE)
zit = list.files("P:/DISKD/Wallpapers", pattern = "^zit2x.*\\.png$", full.names = TRUE)
flux2 = list.files("P:/DISKD/Wallpapers", pattern = "^flux2x.*\\.png$", full.names = TRUE)
qwen21 = list.files("P:/DISKD/Wallpapers", pattern = "^qwen21.*\\.png$", full.names = TRUE)

for ( i in 21:50 ) {
  file_paths = c(krea2[i], zit[i], flux2[i], qwen21[i])
  file_names = basename(file_paths)
  images = lapply(file_paths, magick::image_read)
  
  images = Map(
    function(img,label) {
      magick::image_annotate(
        img,
        text = label,
        gravity = "SouthWest",
        size = 100,
        color = "white",
        boxcolor = "black"
      )
    },
    images,
    file_names
  )
 
  # Combine the images into a grid
  ncol = 2
  nrow = 2
  grid_image = magick::image_montage(
    do.call(c, images),
    tile = paste(ncol, nrow, sep = "x"),
    geometry = "800x450+10+10",
    bg = "#505050"
  )
  
  print(grid_image)  
  
  answer = readline("Press Enter to continue, or type 'q' to quit: ")
  if (tolower(answer) == "q") break
}

















