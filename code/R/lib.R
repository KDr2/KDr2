library(stringr)

project_root <- Sys.getenv("PROJECT_ROOT") # end with slash

autogen_path <- function(subdir, file) {
  paste0(project_root, "static/autogen/", subdir, "/", file)
}

rel_path <- function(abs_path) {
  ## abs_path: root/static/autogen/subdir/img.png
  ## cwd: root/content, root/content/books/, ...
  cwd <- normalizePath(getwd())
  file_rel_path <- str_replace(abs_path, project_root, "")
  cwd_rel_path <- str_replace(cwd, project_root, "")
  components = str_split(cwd_rel_path, "/")[[1]]
  prefix <- strrep("../", length(components) - 1)
  return(paste0(prefix, file_rel_path))
}

inline_html <- function(abs_path) {
  path <- rel_path(abs_path)
  return(paste0("<img src=\"", path ,"\"/>"))
}
