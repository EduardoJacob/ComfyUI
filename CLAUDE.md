# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Controlling ComfyUI from R and RStudio** - A suite of R scripts that automates AI image generation workflows by integrating ComfyUI and LM Studio. Users can programmatically chain complex AI pipelines through R for task management, prompt engineering, and recursive generation.

## Architecture

### Core Files

- **`ComfyUIfunctions.R`** - The core utility script defining all communication protocols with the ComfyUI API. Contains:
  - `COMFYUI()` - Main function that submits workflows to ComfyUI via HTTP API
  - `COMFYUI_CHECK_SIGNATURE()` - Validates workflow parameters
  - `COMFYUI_GET_MODELS()` - Scans workflows folder and extracts model metadata
  - `COMFYUI_IMAGE_COMPARER()` - Helper for image comparison workflows

- **`SETUP.R`** - Initialization script that:
  - Installs required packages (`howler`, `minifunctions`, `rstudiotools`, `aitools`, `xfunctions`)
  - Starts LM Studio and Claude Code terminals via PowerShell
  - Sources `ComfyUIfunctions.R` to load functions
  - Calls `COMFYUI_GET_MODELS()` to build workflow/model inventory

### Workflow Execution Scripts (numbered by execution order)

| Script | Purpose |
|--------|---------|
| `10_LM_Studio_PromptGenerator.R` | Generates text prompts from images via LM Studio |
| `15_ComfyUI_PromptGenerator.R` | Image captioning/analysis using ComfyUI (QwenVL3 workflow) |
| `20_LM_Studio_RecursiveGenerator.R` | Alternates LM Studio description → ComfyUI generation iteratively |
| `25_ComfyUI_RecursiveGenerator.R` | Pure image-to-image recursive ComfyUI workflow |
| `30_ComfyUI_MassGenerator.R` | Batch generation from prompt list file |
| `40_ComfyUI_Upscaler.R` | Batch upscaling via dedicated ComfyUI workflow |
| `50_ComfyUI_PromptEnhancer.R` | Text-to-text prompt refinement → text-to-image generation |
| `60_ComfyUI_Wan_Video.R` | Video generation using Wan model |
| `70_ComfyUI_TTS.R` | Text-to-speech using Qwen3-TTS |
| `72_ComfyUI_VoiceCloning.R` | Voice cloning workflow |
| `80_ComfyUI_RemoveBackground.R` | Background removal (new) |
| `82_ComfyUI_ExtractObject.R` | Object extraction (new) |

### Workflows Directory

Contains JSON workflow definitions for ComfyUI:
- Text-to-image: `flux_text_image.json`, `zit_text_image.json`, `nunchakuZIT_text_image.json`
- Image-to-image/upscaling: `flux2x_text_image.json`, `upscaler_image_image.json`, `upscaler4x_NMKD_image_image.json`
- Vision models: `QwenVL3_*` variants (image/text/video)
- TTS/Voice: `qwen3tts_*` variants
- Video: `wan_image_video.json`
- Utilities: `ImageComparer.json`, `remove_background.json`, `extract_object.json`

## Development Workflow

### Running Scripts

```r
# Source setup (first time or after package changes)
source("SETUP.R")

# Run a specific workflow script
source("30_ComfyUI_MassGenerator.R")
```

### COMFYUI Function Usage

```r
# Basic text-to-image
COMFYUI(workflow = "workflows/flux_text_image.json", prompt = "a cat")

# Image-to-image with input image
COMFYUI(workflow = "workflows/flux2x_text_image.json", 
        image = "S:/ComfyUI/input/image.png", 
        prompt = "enhanced version")

# Video generation
COMFYUI(workflow = "workflows/wan_image_video.json", 
        video = "", duration = "5s")

# TTS
COMFYUI(workflow = "workflows/qwen3tts_text_speech.json", 
        prompt = "Hello world")
```

### Workflow Signature Validation

Each workflow has a defined signature (required parameters). The `COMFYUI()` function validates:
- Required parameters are provided
- Optional parameters aren't passed when not needed
- Returns informative error messages with expected signature

## Key Packages

Core packages used:
- `zeallot` - Multiple assignment (destructuring)
- `stringr` / `stringr::str_replace` - String manipulation
- `jsonlite` - JSON parsing/generation for API payloads
- `httr2` - HTTP requests to ComfyUI API
- `tools` - File path utilities
- `uuid` - UUID generation for prompt IDs
- `purrr` / `magrittr` (`%>%`) - Functional programming
- `rstudiotools` - RStudio terminal management
- `aitools` / `xfunctions` / `minifunctions` - Custom utility packages

## Configuration

Paths defined in `ComfyUIfunctions.R`:
```r
comfyui_input_folder = "S:/ComfyUI/ComfyUI-Easy-Install/ComfyUI/input"
comfyui_output_folder = "S:/ComfyUI/ComfyUI-Easy-Install/ComfyUI/output"
```

ComfyUI server URL (default): `http://127.0.0.1:8188`

## Git Status

Modified files indicate recent changes to workflow scripts. Untracked files in `workflows/` are new workflows added to the system.
