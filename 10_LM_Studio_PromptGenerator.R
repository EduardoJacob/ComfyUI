

source("ComfyUIfunctions.R")


prompt = "Give me a text Prompt, optimized for z-image-turbo model, in order to generate an image like the one attached. Give me only the text, not the image. Summarize the text with no more then 100 words"
input_folder = "P:/DISKD/Wallpapers"
output_file = "./prompts/Prompts.txt"

# Mass rename my images to make sure the extensions are correct
# minifunctions::imagerenamer(input_folder,"img")

files = list.files(input_folder,pattern = "\\.jpeg$",full.names=T)

# Delete the output_file if it already exists
# if (file.exists(output_file)) file.remove(output_file)

system2("powershell", args = c("-File", paste0('./powershell/LMstudioStart.ps1')), stdout = T, stderr = F, wait = T) 

# Select the PLOTS Pane in RStudio to see the images being processed.
start = 1
end = length(files)

start = 10
end = 12

for (i in start:end ) {
  f = files[i] 
  cat("\nProcessing file",i,"/",end,":",f,"\n")
  rstudiotools::displaymedia(f)
  
  answer = aitools::lmstudio(prompt,image=f)
  answer = stringr::str_squish(answer)
  print(answer)
  # Count the words in the answer
  # word_count = stringr::str_count(answer, "\\w+") 
  # cat("Word count:", word_count, "\n")
  # Append the answer to a text file
  write(answer, file = output_file, append = TRUE)
}

# Unload LM Studio Model
system2("powershell", args = c("-File", paste0('./powershell/LMstudioEnd.ps1')), stdout = T, stderr = F, wait = T) 






