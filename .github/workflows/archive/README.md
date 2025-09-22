# Archived Workflows

This directory contains GitHub Actions workflows that are no longer actively used. They have been archived for historical reference or for potential future reactivation.

## Formatters - DEPRECATED
### format-check-cpp.yml
- Checks format of C and C++ files in the repo
- Workflow fails if format is wrong
- Uses Clang formatter

### format-cpp.yml
- Formats C and C++ files in the repo
- Changes the files and pushes a new commit
- Uses Clang formatter

### format-check-python.yml
- Checks format of python files in the repo
- Workflow fails if format is wrong
- Uses black-format-check

### format-python.yml
- Formats python files in the repo
- Changes the files and pushes a new commit
- Uses black-format-check
