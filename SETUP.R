
# set snippet ----
# Use Ctrl+Shift+k to Compile Report from R Script
# usethis::edit_rstudio_snippets()
# Ctrl+Shift-P - Show Command Palette
# Ctrl+Alt-T - execute Section
rstudiotools::setcwd()
rm(list=ls()) # Clear Workspace
try( dev.off(dev.list()["RStudioGD"]),silent=T) # Clear Plots
gc()
cat("\014") # Clear Console ctrl+L
# source("../Functions/XLibrary.R")
library("xfunctions")
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

minifunctions::imagegrid("P:/DISKD/Youtube R Programming/AppLogos")

usethis::use_git()
#usethis::use_git_remote("origin", url = NULL, overwrite = TRUE)

usethis::use_github()

usethis::use_readme_rmd()

usethis::browse_github()


# Start LM Studio if needed (if terminal already in use, close terminal panel and run again)
# terminal_id = rstudiotools::terminal(".\\StartLMstudio.ps1",caption="Claude")
# Start Claude Code if needed
# terminal_id = rstudiotools::terminal("claude --model qwen/qwen3.5-9b",terminal_id = terminal_id)

# prompt = "Review the project and update claude.md to reflect the current architecture and recent changes."
# terminal_id = rstudiotools::terminal(prompt, terminal_id = terminal_id)
# terminal_id = rstudiotools::terminal("qual a capital de El Salvador ?", terminal_id = terminal_id)

# Make an inventory of models used in workflows

workflows = list.files("./workflows",pattern = "\\.json$",full.names = TRUE)

models = data.frame(
  workflow = character(),
  model_type    = character(),
  model_name    = character()
)

for (f in workflows) {
  txt = readLines(f, warn = FALSE)
   
  txt = txt[stringr::str_detect(txt, "\\.(safetensors|gguf)")]
  if (length(txt) == 0) next
  
  for (line in txt) {
    model_type = stringr::str_match(line,'"([^"]+)"\\s*:')[,2]
    model_name = stringr::str_match(line,'"([^"]+\\.(?:safetensors|gguf))"')[,2]
    
    models = rbind(models,
      data.frame(
        workflow = tools::file_path_sans_ext(basename(f)),
        model_type    = model_type,
        model_name    = model_name
      )
    )
  }
}









