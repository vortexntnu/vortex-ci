# Workflows

## reusable-industrial-ci.yml
This reusable workflow uses [industrial-ci](https://github.com/ros-industrial/industrial_ci) to verify that your ROS packages build and install correctly, and runs unit/system tests if defined. You can pass in the following inputs:
- ```os```: Operating System for running the workflow (default: "ubuntu-22.04").
- ```ros_distro```: JSON array of ROS distributions (default: '["humble"]').
- ```ros_repo```: JSON array of ROS repositories (default: '["main"]').
- ```upstream_workspace```: URL or path to a .repos file containing the external repositories required for the build.
- ```skip_tests```: Boolean to skip running tests.
- ```before_install_target_dependencies```: Command or path to script to run before installing dependencies.
- ```additional_debs```: Additional Debian packages to install.

#### Additional setup:
- **.repos file**: If necessary, include a .repos file that specifies extra repositories required by packages in the repository. Provide the path to this file in the ```upstream_workspace``` input. Example of a .repos file:
```yml
repositories:
  vortex-msgs:
    type: git
    url: https://github.com/vortexntnu/vortex-msgs.git
```
### Here is an example of how to use the reusable workflow in your repository:
```yml
name: Industrial CI

on:
  push:
  workflow_dispatch:
  schedule:
    - cron: '0 1 * * *'  # Runs daily

jobs:
  call_reusable_workflow:
    uses: vortexntnu/vortex-ci/.github/workflows/reusable-industrial-ci.yml@main
```

## pre-commit-config.yaml
This file sets up the [pre-commit](https://pre-commit.com/) tool to automatically check and format code before every commit, ensuring consistent code quality. You can also integrate [pre-commit-ci](https://pre-commit.ci/) to run these checks on every push to a pull request and automatically fix issues.
#### Additional setup:
- ruff.toml: Configuration for the Python linter [ruff](https://docs.astral.sh/ruff/). (See an example in [ruff-toml](https://github.com/vortexntnu/vortex-ci/blob/main/ruff-toml))
- .clang-format: Configuration for formatting C/C++ code with [clang-format](https://clang.llvm.org/docs/ClangFormat.html).
(See an example in [.clang-format](https://github.com/vortexntnu/vortex-ci/blob/main/.clang-format))
- ***The ```pre-commit-config.yaml``` file should be placed in the root of the repository***.
### Here is an example configuration file with General, Python, C/C++, and Spellcheck Hooks:
```yaml
# To use:
#
#     pre-commit run -a
#
# Or:
#
#     pre-commit install  # (runs every time you commit in git)
#
# To update this file:
#
#     pre-commit autoupdate
#
# See https://github.com/pre-commit/pre-commit

repos:
  # Standard hooks
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: check-added-large-files
      - id: check-ast
      - id: check-case-conflict
      - id: check-docstring-first
      - id: check-merge-conflict
      - id: check-symlinks
      - id: check-xml
      - id: check-yaml
        args: ["--allow-multiple-documents"]
      - id: debug-statements
      - id: end-of-file-fixer
      - id: mixed-line-ending
      - id: trailing-whitespace
        exclude_types: [rst]
      - id: fix-byte-order-marker
      - id: requirements-txt-fixer
  # Python hooks
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.9.2
    hooks:
      - id: ruff-format
      - id: ruff
        name: ruff-isort
        args: [
            "--select=I",
            "--fix"
            ]
      - id: ruff
        name: ruff-pyupgrade
        args: [
            "--select=UP",
            "--fix"
            ]
      - id: ruff
        name: ruff-pydocstyle
        args: [
            "--select=D",
            "--ignore=D100,D101,D102,D103,D104,D105,D106,D107,D401",
            "--fix",
            ]
        stages: [pre-commit]
        pass_filenames: true
      - id: ruff
        name: ruff-check
        args: [
            "--select=F,PT,B,C4,T20,S,N",
            "--ignore=T201,N812,B006,S101,S311,S607,S603",
            "--fix"
            ]
        stages: [pre-commit]
        pass_filenames: true
  # C++ hooks
  - repo: https://github.com/pre-commit/mirrors-clang-format
    rev: v19.1.7
    hooks:
      - id: clang-format
        args: [--style=file]
  # Spellcheck in comments and docs
  - repo: https://github.com/codespell-project/codespell
    rev: v2.3.0
    hooks:
      - id: codespell
        args: ['--write-changes', '--ignore-words-list=theses,fom']

# For more information on pre-commit.ci and its configuration, visit:
# https://pre-commit.ci/
ci:
    autoupdate_schedule: quarterly
```

## reusable-semrel.yml
This reusable workflow uses [semantic-release](https://github.com/cycjimmy/semantic-release-action/tree/v4.1.1/) to automate semantic versioning. It generates version numbers based on your commit messages, creates Git tags, and publishes release notes. It uses the [.releaserc](/.releaserc) file in this repository to configure the release process. You can pass in the following inputs:
- ```os```: Operating System for running the workflow (default: "ubuntu-latest").
- ```central_repo_name```: Repo name containing this workflow (default: "vortexntnu/vortex-ci").
- ```central_repo_ref```: Branch or tag to checkout in the central repo (default: "main").
- ```default_branch```: Default branch of the repository (default: ${{ github.event.repository.default_branch }}).
- ```releaserc```: Path to a custom .releaserc file in your repository (by default, the workflow uses the one provided in this repo). - ***(TODO)***
#### Additional setup: N/A
### Here is an example of how to use the reusable workflow in your repository:
```yml
name: Semantic Release

on:
  push:
    branches:
      - main
jobs:
  call_reusable_workflow:
    uses: vortexntnu/vortex-ci/.github/workflows/reusable-semrel.yml@main
```

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
