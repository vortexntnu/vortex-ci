# vortex-ci
This repository holds reusable workflows for CI.
Supported workflows are documented [here](/.github/workflows/README.md)!

## Tests & Simulation
Every day, automated tests run on our simulated drones to verify system stability, navigation performance, and controller behavior. These tests ensure that our autonomous systems are working as expected.
### **Test Status**
[![orca](https://github.com/vortexntnu/vortex-ci/actions/workflows/orca.yml/badge.svg)](https://github.com/vortexntnu/vortex-ci/actions/workflows/orca.yml)

[![freya](https://github.com/vortexntnu/vortex-ci/actions/workflows/freya.yml/badge.svg)](https://github.com/vortexntnu/vortex-ci/actions/workflows/freya.yml)

## Goal
Our goal is to centralize and simplify the management of CI/CD workflows. By placing all reusable workflows in one central repository, we ensure consistency across projects and reduce maintenance overhead.

### How to add a workflow to a repo
1. Pick a template from [here](/.github/workflows/README.md)
2. Copy the template into your repositories `.github/workflows` directory.
3. Modify the template to fit your project's requirements.
4. Commit and push the changes to your repository.