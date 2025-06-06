# Workflows

## reusable-industrial-ci.yml
This reusable workflow uses [industrial-ci](https://github.com/ros-industrial/industrial_ci) to verify that your ROS packages build and install correctly, and runs unit/system tests if defined.
#### Inputs:
- ```os```: Operating System for running the workflow (default: "ubuntu-22.04").
- ```ros_distro```: JSON array of ROS distributions (default: '["humble"]').
- ```ros_repo```: JSON array of ROS repositories (default: '["main"]').
- ```upstream_workspace```: URL or path to a .repos file containing the external repositories required for the build.
- ```skip_tests```: Boolean to skip running tests.
- ```before_install_target_dependencies```: Command or path to script to run before installing dependencies. Used for installing dependencies that are not supported by rosdep, allowing custom scripts or commands to handle those cases before the main dependency installation process.
- ```additional_debs```: Additional Debian packages to install.
- ```cmake_args```: Additional CMake arguments to pass during the build.

#### Additional setup:
- **.repos file**: If necessary, include a .repos file that specifies extra repositories required by packages in the repository. Provide the path to this file in the ```upstream_workspace``` input. Example of a .repos file:
```yml
repositories:
  vortex-msgs:
    type: git
    url: https://github.com/vortexntnu/vortex-msgs.git
```
### Here is an example of how to use the workflow in a repository:
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

## reusable-pre-commit.yml
This reusable workflow runs pre-commit using ROS2-specific hooks such as ament_cppcheck, ament_cpplint, and ament_lint_cmake. It is designed to run in a containerized ROS environment and supports custom configuration files.
You can pass in the following inputs:
- ```ros_distro```: The ROS 2 distribution name to use (e.g. "humble").
- ```config_path```: (Required) Path to the pre-commit config file (e.g. .pre-commit-config-local.yaml).
This workflow is typically used to run local ROS-specific hooks, while letting [pre-commit.ci](https://pre-commit.ci/) handle general formatting, linting, or spellchecking from a .pre-commit-config.yaml file in the root. NOTE: This workflow does not commit any changes to the repository.
#### Additional setup:
- The config file provided via config_path should be placed inside the repository and include only the local hooks, such as ament_cppcheck, ament_cpplint, and ament_lint_cmake.
- The repository must be configured with a .pre-commit-config-local.yaml or similar.
#### Example .pre-commit-config-local.yaml:
```yaml
# To use:
#
#     pre-commit run --all-files -c .pre-commit-config-local.yaml
#
# Or to install it for automatic checks on commit:
#
#     pre-commit install -c .pre-commit-config-local.yaml
#
# To update this file:
#
#     pre-commit autoupdate -c .pre-commit-config-local.yaml
#
# See https://pre-commit.com/ for documentation
#
# NOTE: This configuration uses local hooks specific to ROS2 (ament_* linters)

repos:
  - repo: local
    hooks:
      - id: ament_cppcheck
        name: ament_cppcheck
        description: Static code analysis of C/C++ files.
        entry: env AMENT_CPPCHECK_ALLOW_SLOW_VERSIONS=1 ament_cppcheck
        language: system
        files: \.(h\+\+|h|hh|hxx|hpp|cuh|c|cc|cpp|cu|c\+\+|cxx|tpp|txx)$
  - repo: local
    hooks:
      - id: ament_cpplint
        name: ament_cpplint
        description: Static code analysis of C/C++ files.
        entry: ament_cpplint
        language: system
        files: \.(h\+\+|h|hh|hxx|hpp|cuh|c|cc|cpp|cu|c\+\+|cxx|tpp|txx)$
        args: ["--linelength=100", "--filter=-whitespace/newline,-legal/copyright"]
  # CMake hooks
  - repo: local
    hooks:
      - id: ament_lint_cmake
        name: ament_lint_cmake
        description: Check format of CMakeLists.txt files.
        entry: ament_lint_cmake
        language: system
        files: CMakeLists\.txt$
```
#### Here is an example of how to use the workflow in your repository:
```yaml
name: pre-commit

on:
  push:
  workflow_dispatch:
  schedule:
    - cron: '0 1 * * *' # Runs daily to check for dependency issues or flaking tests
jobs:
  call_reusable_workflow:
    uses: vortexntnu/vortex-ci/.github/workflows/reusable-pre-commit.yml@main
    with:
        ros_distro: 'humble'
        config_path: '.pre-commit-config-local.yaml'
```

## reusable-semantic-release.yml
This reusable workflow uses [semantic-release](https://github.com/cycjimmy/semantic-release-action/tree/v4.1.1/) to automate semantic versioning. It generates version numbers based on your commit messages, creates Git tags, and publishes release notes. It uses the [.releaserc](/.releaserc) file in this repository to configure the release process. You can pass in the following inputs:
- ```os```: Operating System for running the workflow (default: "ubuntu-latest").
- ```central_repo_name```: Repo name containing this workflow (default: "vortexntnu/vortex-ci").
- ```central_repo_ref```: Branch or tag to checkout in the central repo (default: "main").
- ```default_branch```: Default branch of the repository (default: ${{ github.event.repository.default_branch }}).
- ```releaserc```: Path to a custom .releaserc file in your repository (by default, the workflow uses the one provided in this repo). - ***(TODO)***
#### Additional setup: N/A
### Here is an example of how to use the workflow in a repository:
```yml
name: Semantic Release

on:
  push:
    branches:
      - main
jobs:
  call_reusable_workflow:
    uses: vortexntnu/vortex-ci/.github/workflows/reusable-semantic-release.yml@main
```

## reusable-code-coverage.yml
This reusable workflow is designed to run code coverage analysis on a ROS-based repository. It sets up the necessary environment, installs coverage tools, builds the project, and uploads the coverage report to [Codecov](https://app.codecov.io/github/vortexntnu).
#### Inputs:
- ```os```: Operating System for running the workflow (default: "ubuntu-22.04").
- ```ros_distro```: The ROS2 distribution name. (default: "humble").
- ```debug```: Enable debug output for troubleshooting. (default: false).
- ```vcs-repo-file-url```: URL or path to a .repos file containing the external repositories required for the build.
- ```before_install_target_dependencies```: Command or path to script to run before installing dependencies. Used for installing dependencies that are not supported by rosdep, allowing custom scripts or commands to handle those cases before the main dependency installation process.
#### Secrets:
- ```CODECOV_TOKEN```: *(Required)* - Token for uploading coverage reports to Codecov. ([Guide](https://docs.codecov.com/docs/adding-the-codecov-token))
#### Additional setup:
- **codecov.yml**: Place this Codecov configuration file at the root of your repository. ([Guide](https://docs.codecov.com/docs/codecov-yaml)). Codecov primarily detects C++ packages for coverage reporting. Also you need to update the repository name in the ```fixes``` section to match your repository:
```yml
fixes:
  - "ros_ws/src/INSERT-YOUR-REPOSITORY-NAME/::"
```
Example of a codecov.yml file (in this case for a repository called vortex-auv):
```yml
coverage:
  precision: 2
  round: down
  status:
    project:
      default:
        informational: true
        flags:
          - unittests
    patch: off
fixes:
  - "ros_ws/src/vortex_auv/::"
comment:
  layout: "diff, flags, files"
  behavior: default
flags:
  unittests:
    paths:
      - "**"
```
- **.repos file**: See additional setup in [reusable-industrial-ci.yml](#reusable-industrial-ciyml).

### Here is an example of how to use the workflow in your repository:
```yml
name: Code Coverage

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  coverage_build:
    uses: vortexntnu/vortex-ci/.github/workflows/reusable-code-coverag.yml@main
    secrets:
      CODECOV_TOKEN: ${{ secrets.CODECOV_TOKEN }}
```

## sphinx-build-and-deploy.yml
This reusable workflow deploys sphinx documentation files present in the `docs/` folder in a repository onto github pages. If this folder does not exist, the workflow will skip this step.

### Additional setup:
In order to properly deploy the pages, manual creation of sphinx docs folder and respective files is needed to fully utilize the workflow. [This guide](https://www.sphinx-doc.org/en/master/tutorial/automatic-doc-generation.html) on automatic sphinx documentation deployment should be followed in order to create the relevant files for Sphinx.

### Example of how to use in other repositories:

```yml
name: Sphinx build & deploy

on:
  push:

jobs:
  call_reusable_workflow:
    uses: vortexntnu/vortex-ci/.github/workflows/sphinx-build-and-deploy.yml@main
    permissions:
      pages: write
      id-token: write
```

# Scripts
## .pre-commit-config.yaml
This file sets up the [pre-commit](https://pre-commit.com/) tool to automatically check and format code before every commit, ensuring consistent code quality. You can also integrate [pre-commit-ci](https://pre-commit.ci/) to run these checks on every push to a pull request and automatically fix issues. To configure this you need to go [here](https://github.com/organizations/vortexntnu/settings/installations) and click on ```pre-commit ci``` and add the repository you want to use it on. **NOTE**: pre-commit-ci is only available for public repositories.
#### Additional setup:
- ruff.toml: Configuration for the Python linter [ruff](https://docs.astral.sh/ruff/). (See an example in [ruff.toml](https://github.com/vortexntnu/vortex-ci/blob/main/ruff.toml))
- .clang-format: Configuration for formatting C/C++ code with [clang-format](https://clang.llvm.org/docs/ClangFormat.html).
(See an example in [.clang-format](https://github.com/vortexntnu/vortex-ci/blob/main/.clang-format))
- ***The ```.pre-commit-config.yaml``` file must be placed in the root of the repository***.
- Sometimes the spellchecker confuses words with abbreviations, causing it to incorrectly assert the there are grammatical errors. Words to ignore can be added in the config file:
```yaml
# Spellcheck in comments and docs
  - repo: https://github.com/codespell-project/codespell
    rev: v2.3.0
    hooks:
      - id: codespell
        args: ['--write-changes', '--ignore-words-list=theses,fom'] <=== Add words your want to ignore here
```
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
