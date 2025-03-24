# Copywrite: automate copyright headers and license files at scale
# https://github.com/hashicorp/copywrite

schema_version = 1

project {
  license        = "MIT"
  copyright_year = 2024
  copyright_holder = "Mark Lewis"

  # (OPTIONAL) A list of globs that should not have copyright/license headers.
  # Supports doublestar glob patterns for more flexibility in defining which
  # files or folders should be ignored
  header_ignore = [
    # "vendor/**",
    # "**autogen**",
    ".**"
  ]
}
