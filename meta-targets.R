library(targets)

# visualize flow ----------------------------------------------------------
tar_visnetwork(label = "time", targets_only = TRUE)


# manifests ---------------------------------------------------------------
tar_manifest()

# results dataframe -------------------------------------------------------
meta <- tar_meta(
  targets_only = TRUE,
  fields = c("name", "time", "bytes", "seconds", "warnings", "error")
)
tar_meta(fields = error, complete_only = TRUE)


# Check specific object ---------------------------------------------------
tar_read(chart)
