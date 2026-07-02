FROM mambaorg/micromamba:latest

# -------------------------------------------------------
# Create env with stable JVM + numpy stack
# -------------------------------------------------------
RUN micromamba create -y -n bioformats -c conda-forge \
    python=3.10 \
    numpy=1.26 \
    cython \
    openjdk=8 \
    pip \
    setuptools \
    wheel \
    && micromamba clean -a -y

# Activate env automatically
ENV ENV_NAME=bioformats
ENV PATH=/opt/conda/envs/bioformats/bin:$PATH

# -------------------------------------------------------
# Install Java bridge stack via conda (IMPORTANT)
# -------------------------------------------------------
RUN micromamba install -y -n bioformats -c conda-forge \
    python-javabridge \
    && micromamba clean -a -y

# bioformats is pip-only
RUN pip install --no-cache-dir python-bioformats==4.1.0

# -------------------------------------------------------
# Fix JVM runtime linking (CRITICAL)
# -------------------------------------------------------
ENV JAVA_HOME=/opt/conda/envs/bioformats
ENV LD_LIBRARY_PATH=$JAVA_HOME/lib/server:$LD_LIBRARY_PATH

# -------------------------------------------------------
# Verify
# -------------------------------------------------------
RUN python -c "import javabridge; import bioformats; print('BIOFORMATS OK')"