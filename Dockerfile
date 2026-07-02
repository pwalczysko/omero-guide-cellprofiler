FROM continuumio/miniconda3

SHELL ["/bin/bash", "-c"]

# -------------------------------------------------------
# 1. System dependencies (IMPORTANT: correct Java package)
# -------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    g++ \
    make \
    git \
    wget \
    curl \
    ca-certificates \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    libice6 \
    && rm -rf /var/lib/apt/lists/*

# Debian trixie FIX: use default-jdk (NOT openjdk-11-jdk or 17-jdk)
RUN apt-get update && apt-get install -y default-jdk && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/default-java
ENV PATH="$JAVA_HOME/bin:$PATH"

# -------------------------------------------------------
# 2. Create conda env (IMPORTANT for numpy compatibility)
# -------------------------------------------------------
RUN conda create -n cp python=3.9 -y
ENV PATH="/opt/conda/envs/cp/bin:$PATH"

# -------------------------------------------------------
# 3. Core Python build tooling (CRITICAL ORDER)
# -------------------------------------------------------
RUN pip install --upgrade pip setuptools wheel

# VERY IMPORTANT: install numpy BEFORE anything else
RUN pip install "numpy<2"

# -------------------------------------------------------
# 4. Prevent build isolation from breaking numpy detection
# -------------------------------------------------------
ENV PIP_NO_BUILD_ISOLATION=1
ENV PIP_NO_CACHE_DIR=1

# -------------------------------------------------------
# 5. Install javabridge FIRST (isolated, controlled)
# -------------------------------------------------------
RUN pip install --no-build-isolation \
    python-javabridge==4.0.3

# -------------------------------------------------------
# 6. Install bioformats AFTER javabridge
# -------------------------------------------------------
RUN pip install python-bioformats==4.0.7

# -------------------------------------------------------
# 7. Verify installation
# -------------------------------------------------------
RUN python -c "import javabridge; print('javabridge OK')"