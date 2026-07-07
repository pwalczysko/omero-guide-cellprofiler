FROM cellprofiler/cellprofiler:4.2.8

USER root

# System packages (only if you need them)
RUN apt-get update && apt-get install -y \
    git \
    wget \
    curl \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Extra Python packages
RUN pip install --no-cache-dir \
    pandas \
    scikit-image \
    tifffile \
    opencv-python-headless \
    imageio \
    pyarrow


COPY scripts /workspace/scripts
COPY scripts/cp /workspace/scripts/cp


WORKDIR /workspace

CMD ["cellprofiler", "--help"]