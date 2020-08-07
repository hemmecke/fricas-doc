# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Path setup --------------------------------------------------------------

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
import os
import sys
sys.path.insert(0, os.path.abspath('_ext'))

# Add "Edit on github link".
# See https://gist.github.com/mgedmin/6052926
edit_on_github_project = 'fricas/fricas-doc'
edit_on_github_branch = 'master'


# -- Project information -----------------------------------------------------

project = 'FriCAS'
copyright = '2007-2020, FriCAS Team'
author = 'FriCAS Team'

# The full version, including alpha/beta/rc tags
release = '1.3.6'

# -- General configuration ---------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = [
    'sphinx.ext.mathjax',
    'sphinx.ext.extlinks',
    'edit_on_github',
]

# Here are the official links. Do not change them unless, the official
# places change.
OFFICIAL_FRICAS_GIT_REPO ='https://github.com/fricas/fricas'
# Base source URL in the git repo.
OFFICIAL_SOURCE_URL = OFFICIAL_FRICAS_GIT_REPO + '/blob/master'
# The place where the documentation should officially live.
OFFICIAL_DOC_URL='https://fricas.github.io'

# See http://docs.readthedocs.org/en/latest/faq.html for this on_rtd stuff.
import os

FRICAS_REPO = os.environ.get('FRICAS_REPO', OFFICIAL_FRICAS_GIT_REPO)
SOURCE_URL = os.environ.get('SOURCE_URL', 'https://github.com/fricas/fricas/blob/master')
DOC_URL = os.environ.get('DOC_URL', 'https://fricas.github.io')
SPAD_SOURCE_URL = SOURCE_URL + '/src/algebra'
project_book = DOC_URL + '/book.pdf'


# This is used to refer to .spad source files.
# %s will be substituted by filename and line number looking like this:
# "aggcat#L1675", i.e. the String that appears in the .rst file as
# :spadsource:`aggcat#L1675`.
extlinks = {'spadsource':('%s/%%s' % SPAD_SOURCE_URL, '')}

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = []

# The master toctree document.
master_doc = 'index'

# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = 'fricas-theme'

# Add any paths that contain custom themes here, relative to this directory.
html_theme_path = ['_theme']

# The name for this set of Sphinx documents.  If None, it defaults to
# "<project> v<release> documentation".
html_title = '%s %s' % (project, release)

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']

# -- Private FriCAS additions --------------------------------------------
rst_prolog = """
.. role:: spadop
.. role:: spadfun
.. role:: spadtype

"""

rst_epilog = """
.. |PACKAGE_TARNAME| replace:: %s
.. |PACKAGE_NAME| replace:: %s

.. |PACKAGE_HOME| replace:: `%s Homepage`_
.. _%s Homepage: %s/index.html

.. |PACKAGE_CODE| replace:: `%s Repository`_
.. _%s Repository: %s

.. |PACKAGE_BOOK| replace:: `Book (pdf)`_
.. _Book (pdf): %s


----

* |PACKAGE_HOME|
* |PACKAGE_CODE|

.. toctree::
   :maxdepth: 2

   api/index

""" % (project.lower(), project,
       project, project, DOC_URL,
       project, project, FRICAS_REPO,
       project_book)
