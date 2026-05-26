
comfyui_input_folder = "S:/ComfyUI/ComfyUI-Easy-Install/ComfyUI/input"
comfyui_output_folder = "S:/ComfyUI/ComfyUI-Easy-Install/ComfyUI/output"

COMFYUI = function(workflow,    # .json workflow file path
                   prompt="",   # text prompt to inject into the workflow (optional)
                   image=""     # input image file path to inject into the workflow (optional)
) {
  
  # Load and modify workflow ----
  comfy_url = "http://127.0.0.1:8188"
  filename_prefix = tools::file_path_sans_ext(basename(workflow))
  
  workflow = readLines(workflow, encoding = "UTF-8", warn = FALSE)  
  
  for ( i in 1:length(workflow) ) {
    workflow[i] = stringr::str_replace(workflow[i],"PROMPT",prompt)
    workflow[i] = stringr::str_replace(workflow[i],"IMAGE",image)
    
    workflow[i] = stringr::str_replace(workflow[i],"FILENAME_PREFIX",filename_prefix) 
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
  cat("Workflow",filename_prefix,"submitted! Prompt ID:", prompt_id, "\n")
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
      
      output_text = node_outputs |>
        purrr::map(~purrr::pluck(.x, "text", .default = character())) |>
        unlist(use.names = FALSE)                           
      
      if ( length(output_image) > 0 ) {
        output_data = output_image
        cat("Saved Image Name:", output_data, "\n")
      } else {
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


 

