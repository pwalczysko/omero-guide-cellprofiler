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
RUN conda install -n bioformats -c conda-forge -y \
    openjdk \
    numpy=1.23 \
    cython \
    pip \
    setuptools \
    wheel \
    python-javabridge

# -------------------------------------------------------
# 4. IMPORTANT CLEANUP
# -------------------------------------------------------
RUN conda clean -a -y

# -------------------------------------------------------
# 5. Install bioformats (pip ONLY — not conda!)
# -------------------------------------------------------
RUN pip install --no-cache-dir python-bioformats

# -------------------------------------------------------
# 6. Prevent build isolation issues
# -------------------------------------------------------
ENV PIP_NO_BUILD_ISOLATION=1

# -------------------------------------------------------
# 7. Verify
# -------------------------------------------------------
RUN python -c "import javabridge; import bioformats; print('OK: bioformats stack ready')"

CMD ["python"]