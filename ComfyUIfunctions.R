

COMFYUI = function(image_prompt) {
#  library(jsonlite)
#  library(httr2)
#  library(uuid)
#  library(magrittr)
  
  comfy_url <- "http://127.0.0.1:8188"
  # image_prompt <- "A beautiful cinematic landscape, digital art"
  workflow_path <- "workflow_for_r.json"
  
  # 1. Load and modify workflow
  workflow <- jsonlite::read_json(workflow_path, simplifyVector = FALSE)
  workflow[["57:27"]][["inputs"]][["text"]] <- image_prompt
  
  payload <- list(prompt = workflow, client_id = uuid::UUIDgenerate())
  payload_json <- jsonlite::toJSON(payload, auto_unbox = TRUE, digits = NA)
  
  # 2. Submit the Prompt
  response <- httr2::request(paste0(comfy_url, "/prompt")) %>%
    httr2::req_body_raw(payload_json, type = "application/json") %>%
    httr2::req_error(is_error = function(resp) FALSE) %>% 
    httr2::req_perform()
  
  if (httr2::resp_status(response) != 200) {
    stop("Failed to submit workflow: ", httr2::resp_body_string(response))
  }
  
  result <- httr2::resp_body_json(response)
  prompt_id <- result$prompt_id
  cat("Workflow submitted! Prompt ID:", prompt_id, "\n")
  cat("Waiting for generation to complete...\n")
  
  # 3. Poll the /history endpoint until the prompt_id shows up
  is_done <- FALSE
  start_time <- Sys.time()
  
  while(!is_done) {
    # Request the history log
    history_resp <- httr2::request(paste0(comfy_url, "/history")) %>%
      httr2::req_perform()
    
    history_data <- httr2::resp_body_json(history_resp)
    
    # Check if our specific prompt_id exists in the history list
    if (prompt_id %in% names(history_data)) {
      is_done <- TRUE
      cat("\nExecution finished successfully!\n")
      
      # Optional: Extract filename metadata from the history object
      node_outputs <- history_data[[prompt_id]][["outputs"]]
      # Node "9" is your SaveImage node
      if ("9" %in% names(node_outputs)) {
        saved_images <- node_outputs[["9"]][["images"]]
        for (img in saved_images) {
          cat("Saved Image Name:", img$filename, "\n")
        }
      }
      
    } else {
      # Still running or in queue; print a visual heartbeat
      elapsed <- round(difftime(Sys.time(), start_time, units = "secs"), 1)
      cat("\rProcessing... (", elapsed, "s elapsed)", sep = "")
      utils::flush.console()
      Sys.sleep(1) # Wait 1 seconds before checking again
    }
  }
}














