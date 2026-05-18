
# set snippet ----
# usethis::edit_rstudio_snippets()
# Ctrl+Shift-P - Show Command Palette
rstudiotools::setcwd()
try( dev.off(dev.list()["RStudioGD"]),silent=T) # Clear Plots
rm(list=ls()) # Clear Workspace
gc()
cat("\014") # Clear Console ctrl+L
xfunctions::XLibrary("xfunctions")
# xfunctions::XFunctions("xfunctions")
help(package="xfunctions")
packageDescription("xfunctions")
# devtools::install_github("author_name/xfunctions", build_vignettes = TRUE, dependencies = TRUE)
# browseVignettes(package="xfunctions")
# vignette(package="xfunctions")
# vignette("vignette-name",package="xfunctions")
# https://cranlogs.r-pkg.org/badges/last-month/xfunctions
rstudiotools::showinfo()

source("ComfyUIfunctions.R")

image_folder = "S:/ComfyUI/ComfyUI-Easy-Install/ComfyUI/output"
image_prefix = "img"
image_index  = 0 
# terminal_id = rstudiotools::terminal(".\\LMstudioStart.ps1")

for ( image_index in 0:100 ) {
  image = paste0(image_prefix,"_",sprintf("%05d",image_index),"_.png")
  image_full_name = file.path(image_folder,image)
  rstudiotools::displaymedia(image_full_name)
  
  # Using Gemini depletes available credits.
  # image_prompt = aitools::gemini(
  #   prompt = "Describe this image in no more than 50 words, suitable for the Z-Image-Turbo model",
  #   model = "3-flash-preview",
  #   image = image_full_name
  # )[1]
  
  # Better use a Local Model
  system2("powershell", args = c("-File", paste0('LMstudioStart.ps1')), stdout = T, stderr = F, wait = T)
  
  image_prompt = aitools::lmstudio(
    prompt = "Describe this image in no more than 50 words, suitable for the Z-Image-Turbo model",
    image = image_full_name
  )[1]
  
  system2("powershell", args = c("-File", paste0('LMstudioEnd.ps1')), stdout = T, stderr = F, wait = T)
  
  
  # Remove newlines from the prompt
  image_prompt = trimws( gsub("\n", "", image_prompt) )
  
  cat( cli::rule(left = image, col = "blue"),"\n",image_prompt,"\n" )
   
  # Call ComfyUI API to generate a new image based on the image Prompt
  COMFYUI(image_prompt)
}





