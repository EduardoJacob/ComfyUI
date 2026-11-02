

source("ComfyUIfunctions.R")
 
# Make an inventory of models used in workflows
# Using zeallot package for multiple assignment (unpacking) , aka destructuring assignment in other languages
# library("zeallot")
# c(workflows,models,nodes) %<-% COMFYUI_GET_MODELS()
 
# my_prompts = readLines("./prompts/Prompts20260423.txt", encoding = "UTF-8")
# my_prompts = data.frame(Prompt=my_prompts)

# https://huggingface.co/datasets/Gustavosta/Stable-Diffusion-Prompts
# gustavosta_train = arrow::read_parquet("./prompts/gustavosta_train.parquet")
# gustavosta_eval = arrow::read_parquet("./prompts/gustavosta_eval.parquet")

# https://huggingface.co/datasets/Falah/stable_diffusion_prompts?utm_source=chatgpt.com
falah = arrow::read_parquet("./prompts/train-00000-of-00001-b65f09e3944c2721.parquet")
table(falah$Label)

words = unlist(strsplit(tolower(falah$Prompt), "\\W+"))
# removes empty strings from the words vector:
words = words[nzchar(words)]
word_frequency = as.data.frame(sort(table(words), decreasing = TRUE))
names(word_frequency) = c("Word", "Frequency")





# get 10 random prompts from falah with Label=Surrealism
library(dplyr)

# filter dataframe "falah" where "Prompt" column contains subword "spaceship"
df = falah %>% filter(stringr::str_detect(Prompt, stringr::regex("succubus", ignore_case = TRUE)))
table(df$Label)

N = 2
prompts_1 = falah %>% filter(Label == "Surrealism") %>% slice_sample(n = N)%>% pull(Prompt)
prompts_2 = falah %>% filter(Label == "Realism") %>% slice_sample(n = N)%>% pull(Prompt)
prompts_3 = falah %>% filter(Label == "Impressionism") %>% slice_sample(n = N)%>% pull(Prompt)
prompts_4 = falah %>% filter(Label == "illustration") %>% slice_sample(n = N)%>% pull(Prompt)
prompts = c(prompts_1, prompts_2, prompts_3, prompts_4)

# workflow = "./workflows/krea2_text_image.json"
workflow = "./workflows/zit2x_text_image.json"
# workflow = "./workflows/flux2x_text_image.json"
# workflow = "./workflows/qwen21_text_image.json"

start = 1
end = length(prompts)
# end = 2

for ( i in start:end ) {
  prompt = prompts[i]
  cat("\nProcessing prompt",i,"/",end,":\n",prompt,"\n\n") 
  
  output_image = COMFYUI(workflow=workflow,prompt=prompt)
  
  # For speed, bypass the displaymedia function, which is slow for large images
  rstudiotools::displaymedia( file.path(comfyui_output_folder,output_image) )
  
}

shell.exec(comfyui_output_folder)


















