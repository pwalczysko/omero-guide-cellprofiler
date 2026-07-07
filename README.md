# Guide on how to integrate CellProfiler and OMERO
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/ome/omero-guide-cellprofiler/master?filepath=notebooks/idr0002.ipynb)
[![Documentation Status](https://readthedocs.org/projects/omero-guide-cellprofiler/badge/?version=latest)](https://omero-guides.readthedocs.io/en/latest/cellprofiler/docs/index.html)
[![Actions Status](https://github.com/ome/omero-guide-cellprofiler/workflows/repo2docker/badge.svg)](https://github.com/ome/omero-guide-cellprofiler/actions)


The documentation is deployed at [Using CellProfiler](https://omero-guides.readthedocs.io/en/latest/cellprofiler/docs/index.html)

This guide demonstrates how to use the CellProfiler Python API to analyze data stored in [IDR](https://idr.openmicroscopy.org/) or in another OMERO server.

This repository contains documentation and notebooks.

## Run the notebooks

### Running on cloud resources

[![Binder](https://mybinder.org/v2/gh/ome/omero-guide-cellprofiler/master?filepath=notebooks)

The OMERO server used will need to have [websockets support](https://docs.openmicroscopy.org/omero/latest/sysadmins/websockets.html) enabled.

### Running in Docker

Alternatively, if you have Docker installed, you can use the [repo2docker](https://repo2docker.readthedocs.io/en/latest/)
tool to run this repository as a local Docker instance:


    $ git clone https://github.com/ome/omero-guide-cellprofiler
    $ cd omero-guide-cellprofiler
    $ repo2docker .

### Running locally

Finally, if you would like to install the necessary requirements locally,
we suggest using conda.

Then, create the omero-py with pandas and tifffile environment:

    $ conda create -n cp-p312 python=3.12
    $ conda activate cp-p312
    $ pip install https://github.com/glencoesoftware/zeroc-ice-py-macos-universal2/releases/download/20240131/zeroc_ice-3.6.5-cp312-cp312-macosx_11_0_universal2.whl # example for Mac OS M1
    $ pip install https://github.com/glencoesoftware/zeroc-ice-py-macos-universal2/releases/download/20240131/zeroc_ice-3.6.5-cp312-cp312-macosx_11_0_universal2.whl # example for Mac OS M1
    $ pip install omero-py pandas tifffile
    $ git clone https://github.com/ome/omero-guide-cellprofiler
    $ cd omero-guide-cellprofiler/scripts
    $ python idr0002_download_save.py

The following steps are only required if you want to run the notebooks

* If you have Anaconda installed:
  * Start Jupyter from the Anaconda-navigator
  * In the conda environment, run ``conda install ipykernel``
  * To register the environment, run ``python -m ipykernel install --user --name omero-guide-cellprofiler``
  * Select the notebook you wish to run and select the ``Kernel>Change kernel>Python [conda env:omero-guide-cellprofiler]`` or ``Kernel>Change kernel>omero-guide-cellprofiler``
* If Anaconda is not installed:
  * In the environment, install ``jupyter`` e.g. ``pip install jupyter``
  * Add the virtualenv as a jupyter kernel i.e. ``ipython kernel install --name "omero-guide-cellprofiler" --user``
  * Open jupyter notebook i.e. ``jupyter notebook`` and select the ``omero-guide-cellprofiler`` kernel or ``[conda env:omero-guide-cellprofiler]`` according to what is available


An additional benefit of installing the requirements locally is that you
can then use the tools without needing to launch Jupyter itself.

See also [setup.rst](https://github.com/ome/omero-guide-cellprofiler/blob/master/docs/setup.rst)


This is a Sphinx based documentation. 
If you are unfamiliar with Sphinx, we recommend that you first read 
[Getting Started with Sphinx](https://docs.readthedocs.io/en/stable/intro/getting-started-with-sphinx.html).
