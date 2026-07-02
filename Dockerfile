FROM continuumio/miniconda3

SHELL ["/bin/bash", "-c"]

# -------------------------------------------------------
# 1. Base system dependencies (minimal but required)
# -------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    wget \
    ca-certificates \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# -------------------------------------------------------
# 2. Create isolated conda environment
# -------------------------------------------------------
RUN conda create -n bioformats python=3.9 -y

ENV PATH="/opt/conda/envs/bioformats/bin:$PATH"

# -------------------------------------------------------
# 3. Use conda-forge for ALL scientific + Java stack
#    (THIS is the key stability fix)
# -------------------------------------------------------
RUN conda install -n bioformats -c conda-forge -y \
    openjdk \
    numpy=1.23 \
    scipy \
    pip \
    cython \
    setuptools \
    wheel

# -------------------------------------------------------
# 4. Install bioformats stack via conda-forge (critical)
# -------------------------------------------------------
RUN conda install -n bioformats -c conda-forge -y \
    python-javabridge \
    python-bioformats

# -------------------------------------------------------
# 5. Clean conda cache (reduces image size)
# -------------------------------------------------------
RUN conda clean -a -y

# -------------------------------------------------------
# 6. Verify installation
# -------------------------------------------------------
RUN python -c "import javabridge; import bioformats; print('BIOFORMATS STACK OK')"

# -------------------------------------------------------
# 7. Default command
# -------------------------------------------------------
CMD ["python"]