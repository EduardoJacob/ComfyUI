

source("ComfyUIfunctions.R")

audio = "Video.mp4"
output = paste0(tools::file_path_sans_ext(audio), ".txt")

audio = file.path(comfyui_input_folder,audio)
rstudiotools::displaymedia(audio)


# Calling Whisper to transcribe Audio
transcription = ""
transcription = COMFYUI(workflow="./workflows/whisper_speech_text.json",speech=audio)

# transcription = minifunctions::editvariable(transcription)

transcription = gsub(",", ",\n", transcription, fixed = TRUE)
transcription = gsub(".", ".\n", transcription, fixed = TRUE)
transcription = gsub("\n ", "\n", transcription, fixed = TRUE)

# Save transcription
writeLines(transcription,file.path("transcriptions",output))
 

