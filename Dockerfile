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


RUN pip install \
    omero-py \
    ezomero \
    pandas \
    numpy

COPY scripts /workspace/scripts
COPY pipelines /workspace/pipelines


WORKDIR /workspace

CMD ["cellprofiler", "--help"]