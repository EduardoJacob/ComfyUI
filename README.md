
# YouTube Data Analysis with R

<!-- README.md is generated from README.Rmd. Please edit that file  -->

take a look at my youtube playlist with R Tutorials:

------------------------------------------------------------------------

<https://www.youtube.com/playlist?list=PLRbCt61PaxX2d0_QXh6Qi6_jAQd66fmcI>

------------------------------------------------------------------------

## Project Overview

# ComfyUI R Integration Project

This project provides an R-based interface to automate image processing
and generation workflows using ComfyUI. The main script, `ComfyUI.R`,
orchestrates a loop that iterates through local images, utilizes the
Gemini API via `aitools` to generate descriptive prompts for each image,
and then feeds those prompts back into a ComfyUI instance via a REST API
to generate new variations. It integrates seamlessly with RStudio tools
for media display and console management, making it an efficient bridge
between local image management and AI-driven generative workflows.

### Functions

**COMFYUI(image_prompt)** This function serves as the primary interface
between R and the ComfyUI API. It loads a predefined JSON workflow from
`workflow_for_r.json`, injects a specific text prompt into the
workflow’s input nodes, and submits the request to a local ComfyUI
server. The function handles the entire execution lifecycle, including
generating a unique client ID, polling the server’s history endpoint to
monitor progress, providing real-time status updates to the R console,
and finally confirming the filenames of the generated images once the
process is complete.
