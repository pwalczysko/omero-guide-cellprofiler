FROM --platform=linux/amd64 continuumio/miniconda3

SHELL ["/bin/bash", "-c"]

# -------------------------------------------------------
# 1. System deps
# -------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# -------------------------------------------------------
# 2. Create env
# -------------------------------------------------------
RUN conda create -n bioformats python=3.9 -y
ENV PATH="/opt/conda/envs/bioformats/bin:$PATH"

# -------------------------------------------------------
# 3. Core scientific + JVM stack (conda-forge ONLY)
# -------------------------------------------------------
# Install Java + javabridge stack
RUN conda install -n bioformats -c conda-forge -y \
    openjdk \
    numpy=1.23 \
    cython \
    pip \
    setuptools \
    wheel \
    python-javabridge

RUN conda clean -a -y

# -------------------------------------------------------
# CRITICAL FIX: expose libjvm.so
# -------------------------------------------------------
ENV JAVA_HOME=/opt/conda/envs/bioformats
ENV LD_LIBRARY_PATH=/opt/conda/envs/bioformats/lib/server:/opt/conda/envs/bioformats/lib:$LD_LIBRARY_PATH

# -------------------------------------------------------
# Install bioformats wrapper
# -------------------------------------------------------
RUN pip install --no-cache-dir python-bioformats

# -------------------------------------------------------
# Verify
# -------------------------------------------------------
RUN python -c "import javabridge; import bioformats; print('BIOFORMATS OK')"

CMD ["python"]