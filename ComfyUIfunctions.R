
comfyui_input_folder = "S:/ComfyUI/ComfyUI-Easy-Install/ComfyUI/input"
comfyui_output_folder = "S:/ComfyUI/ComfyUI-Easy-Install/ComfyUI/output"

COMFYUI = function(workflow,      # .json workflow file path
                   prompt=NULL,   # text prompt to inject into the workflow (optional)
                   image=NULL     # input image file path to inject into the workflow (optional)
) {
  
  # Load and modify workflow ----
  comfy_url = "http://127.0.0.1:8188"
  filename_prefix = tools::file_path_sans_ext(basename(workflow))
  workflow = jsonlite::read_json(workflow, simplifyVector = FALSE)
 
  # Generic modifications for all workflows
  workflow = purrr::modify_depth(workflow, 1, function(node) {
    if (!is.null(node$inputs$text)) node$inputs$text = prompt
    if (!is.null(node$inputs$value)) node$inputs$value = prompt
    if (!is.null(node$inputs$filename_prefix)) node$inputs$filename_prefix = filename_prefix
    if (!is.null(node$inputs$seed)) node$inputs$seed = sample(1000000,1)
    return(node)
  })
  
  # Specific modifications for certain workflows
  if ( filename_prefix == "upscaler" ) workflow[["94"]][["inputs"]][["image"]] = image
  
  
  
  
  
  # Submit the prompt ----
  payload = list(prompt = workflow, client_id = uuid::UUIDgenerate())
  payload_json = jsonlite::toJSON(payload, auto_unbox = TRUE, digits = NA)
  
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
      
      output_image = node_outputs |>
        purrr::map(~purrr::pluck(.x, "images", .default = list())) |> 
        purrr::flatten() |>                                    
        purrr::map_chr("filename")                              
       
      cat("Saved Image Name:", output_image, "\n")
      
    } else {
      # Still running or in queue; print a visual heartbeat
      elapsed = round(difftime(Sys.time(), start_time, units = "secs"), 1)
      cat("\rProcessing... (", elapsed, "s elapsed)", sep = "")
      utils::flush.console()
      Sys.sleep(1) # Wait 1 seconds before checking again
    }
  }
  
  # Return new image filename ----
  return(output_image)
}














