
comfyui_input_folder = "S:/ComfyUI/ComfyUI-Easy-Install/ComfyUI/input"
comfyui_output_folder = "S:/ComfyUI/ComfyUI-Easy-Install/ComfyUI/output"


COMFYUI = function(workflow,prompt="",image="",video="",second_image="",scale="",duration="") {
 
  # Check the workflow signature and required inputs ----
  library("zeallot")
  c(workflows,models) %<-% COMFYUI_GET_MODELS()
  
  if ( workflow == "" ) stop("Please provide a workflow file path.")
  workflow_name = tools::file_path_sans_ext(basename(workflow))
  workflow_signature = workflows[workflows$workflow == workflow_name, ]
  if ( nrow(workflow_signature) == 0 ) stop("Workflow not found.")
  workflow_signature = workflow_signature[ , -1] # Remove workflow column for signature display
  
  valid_signature = TRUE
  for ( parameter_name in names(workflow_signature) ) {
    parameter_is_required = workflow_signature[[parameter_name]]
    parameter_value = get(parameter_name)
    valid_signature = COMFYUI_CHECK_SIGNATURE(workflow_name,parameter_name,
      parameter_is_required,parameter_value,valid_signature)
  }
  
  if ( !valid_signature ) {
    signature = paste(names(workflow_signature)[unlist(workflow_signature)],collapse = ",")
    signature = paste0("(", signature, ")")
    cat("Workflow",workflow_name,"signature:",signature,"\n")
    return()
  }
  
  # Load and modify workflow ----
  comfy_url = "http://127.0.0.1:8188"
  
  workflow = readLines(workflow, encoding = "UTF-8", warn = FALSE)  
  
  for ( i in 1:length(workflow) ) {
    workflow[i] = stringr::str_replace(workflow[i],"SECOND_IMAGE",second_image)
    workflow[i] = stringr::str_replace(workflow[i],"PROMPT",prompt)
    workflow[i] = stringr::str_replace(workflow[i],"IMAGE",image)
    workflow[i] = stringr::str_replace(workflow[i],"VIDEO",video)
    workflow[i] = stringr::str_replace(workflow[i],"SCALE",as.character(scale) )
    workflow[i] = stringr::str_replace(workflow[i],"DURATION",as.character(duration) )
    
    workflow[i] = stringr::str_replace(workflow[i],"FILENAME_PREFIX",workflow_name) 
    workflow[i] = stringr::str_replace(workflow[i],"SEED",as.character( sample(1000000,1)) )
  }
  
  
  
  # Submit the prompt ----
  payload = list(
    prompt = jsonlite::fromJSON(paste(workflow, collapse = "\n"), simplifyVector = FALSE),
    client_id = uuid::UUIDgenerate()
  )
  
  payload_json = jsonlite::toJSON(payload,auto_unbox = TRUE,digits = NA)
  
  response = httr2::request(paste0(comfy_url, "/prompt")) |>
    httr2::req_body_raw(payload_json, type = "application/json") |>
    httr2::req_error(is_error = function(resp) FALSE) |>
    httr2::req_perform()
  
  if (httr2::resp_status(response) != 200) {
    stop("Failed to submit workflow: ", httr2::resp_body_string(response))
  }
  
  result = httr2::resp_body_json(response)
  prompt_id = result$prompt_id
  cat("Workflow",workflow_name,"submitted! Prompt ID:", prompt_id, "\n")
  cat("Waiting for generation to complete...\n")
  
  is_done = FALSE
  start_time = Sys.time()
  
  
  
  
  # Wait for completion ----
  # by polling the history endpoint every second until our prompt_id appears in the history log, 
  # indicating that processing is complete and results are available. 
  # This is a simple polling mechanism; in a production environment, you might want to implement exponential backoff 
  # or a more robust event-driven approach if supported by the API.
  while(!is_done) {
    # Request the history log
    history_resp = httr2::request(paste0(comfy_url, "/history")) |>
      httr2::req_perform()
    
    history_data = httr2::resp_body_json(history_resp)
    
    # Check if our specific prompt_id exists in the history list
    if (prompt_id %in% names(history_data)) {
      is_done = TRUE
      cat("\nExecution finished successfully!\n")
      
      # Optional: Extract filename metadata from the history object
      node_outputs = history_data[[prompt_id]][["outputs"]]
      
      # Get the response ----
      output_image = node_outputs |>
        purrr::map(~purrr::pluck(.x, "images", .default = list())) |> 
        purrr::flatten() |>                                    
        purrr::map_chr("filename")                              
      
      output_video = node_outputs |>
        purrr::map(~purrr::pluck(.x, "gifs", .default = list())) |> 
        purrr::flatten() |>                                    
        purrr::map_chr("filename")                              
      
      output_audio = node_outputs |>
        purrr::map(~purrr::pluck(.x, "audio", .default = list())) |> 
        purrr::flatten() |>                                    
        purrr::map_chr("filename")                              
      
      output_text = node_outputs |>
        purrr::map(~purrr::pluck(.x, "text", .default = character())) |>
        unlist(use.names = FALSE)                           
      
      if ( length(output_image) > 0 ) {
        cat("Saved Image File:", output_image, "\n")
        output_data = output_image
      } 
      if ( length(output_video) > 0 ) {
        cat("Saved Video File:", output_video, "\n")
        output_data = output_video
      } 
      if ( length(output_audio) > 0 ) {
        cat("Saved Audio File:", output_audio, "\n")
        output_data = output_audio
      } 
      if ( length(output_text) > 0 ) {
        cat("Output Text:\n", output_text, "\n")
        output_data = sub("\n.*", "",output_text)
      }
      
      
    } else {
      # Still running or in queue; print a visual heartbeat
      elapsed = round(difftime(Sys.time(), start_time, units = "secs"), 1)
      cat("\rProcessing... (", elapsed, "s elapsed)", sep = "")
      utils::flush.console()
      Sys.sleep(1) # Wait 1 seconds before checking again
    }
  }
  
  # Return output data ----
  return(output_data)
}


COMFYUI_CHECK_SIGNATURE = function(workflow_name,parameter_name,parameter_is_required,parameter_value,valid_signature) {
  if ( parameter_is_required && parameter_value == "" ) {
    cat("Workflow",workflow_name,"requires",parameter_name,"parameter.\n")
    return(FALSE)
  }
  if ( !parameter_is_required && parameter_value != "" ) {
    cat("Workflow",workflow_name,"doesn't requires",parameter_name,"parameter \n")
    return(FALSE)
  }
  return(valid_signature)
}


COMFYUI_GET_MODELS = function() {
  workflows.list = list.files("./workflows",pattern = "\\.json$",full.names = TRUE)
   
  workflows = data.frame(
    workflow = character(),
    prompt = logical(),
    image = logical(),
    video = logical(),
    second_image = logical(),
    scale = logical(),
    duration = logical()
  )
  
  models = data.frame(
    workflow = character(),
    model_type = character(),
    model_name = character()
  )
  
  for (f in workflows.list) {
    txt = readLines(f, warn = FALSE)
    
    # Compute Workflows
    workflow = tools::file_path_sans_ext(basename(f))
    prompt = any(stringr::str_detect(txt, "PROMPT"))
    image = any(stringr::str_detect(txt, "IMAGE"))
    video = any(stringr::str_detect(txt, "VIDEO"))
    second_image = any(stringr::str_detect(txt, "SECOND_IMAGE"))
    scale = any(stringr::str_detect(txt, "SCALE"))
    duration = any(stringr::str_detect(txt, "DURATION"))
    
    workflows = rbind(workflows,data.frame(workflow=workflow,
                                           prompt=prompt,
                                           image=image,
                                           video=video,
                                           second_image=second_image,
                                           scale=scale,
                                           duration=duration)) 
    
    # Compute Models
    txt = txt[stringr::str_detect(txt, "\\.(safetensors|gguf|pth)")]
    
    if ( length(txt) == 0 ) txt = " dummy string to avoid empty loop and preserve prompt/image/video info"
      
    for (line in txt) {
      model_type = stringr::str_match(line,'"([^"]+)"\\s*:')[,2]
      model_name = stringr::str_match(line,'"([^"]+\\.(?:safetensors|gguf|pth))"')[,2]
      
      models = rbind(models,data.frame(workflow=workflow,model_type=model_type,model_name=model_name))
    }
  }
  
  return(list(workflows,models))
  
}


COMFYUI_IMAGE_COMPARER = function(image="", second_image="") { 
  
  wf = jsonlite::fromJSON("./workflows/ImageComparer.json", simplifyVector = FALSE)
  
  wf[["nodes"]][[1]][["widgets_values"]][[1]] = image
  wf[["nodes"]][[2]][["widgets_values"]][[1]] = second_image
  
  # json = jsonlite::toJSON(wf, auto_unbox = TRUE, pretty = FALSE)
  json = jsonlite::toJSON(wf)
  
  utils::writeClipboard(json)
  
  utils::browseURL("http://127.0.0.1:8188")
  
  cat("Workflow copied to clipboard.\n")
  cat("NOW click inside ComfyUI and press Ctrl+V (important).\n")
}








