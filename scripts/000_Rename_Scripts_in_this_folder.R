
rstudiotools::setcwd()

path = "."

files = list.files(path, recursive = FALSE, full.names = F,ignore.case=T)

# Rename files
for (i in 2:length(files)) {
  
  filename = files[i]
  
  # Replace first 2 characters
  new_name = paste0(sprintf("%03d",(i-1)*10),substring(filename, 3)  )
  
  file.rename(file.path(path,filename), file.path(path, new_name))
   
}

