# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information
# pylint: skip-file

# import libs for concatenating path
import os
import sys

project = 'Vortex'
copyright = '2024, Vortex'
author = 'Vortex'
release = '1.0'

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = [
    "sphinx.ext.autodoc",  # Automatically document docstrings
    "sphinx.ext.napoleon",  # Support for Google-style and NumPy-style docstrings
    "sphinx.ext.viewcode",  # Link to source code in the docs
    "sphinx.ext.autosummary",  # Generate summaries of functions/classes
    "myst_parser",  # Support for Markdown files (optional)
]

# Automatic generation of autosummary pages
autosummary_generate = True

# Napoleon settings (optional)
napoleon_google_docstring = True
napoleon_numpy_docstring = True

# Templates and exclude patterns
templates_path = ["_templates"]
exclude_patterns = ["_build", "Thumbs.db", ".DS_Store"]

# Options for HTML output (theme and static paths)
html_theme = "sphinx_rtd_theme"  # Change to ReadTheDocs theme
html_static_path = ["_static"]

# Github actions adds the system path to this file upon creation/running the file
