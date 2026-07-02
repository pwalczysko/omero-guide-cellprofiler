FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# -------------------------------------------------------
# 1. System dependencies (ALL native build + runtime deps)
# -------------------------------------------------------
RUN apt-get update && apt-get install -y \
    software-properties-common \
    build-essential \
    gcc g++ \
    git curl wget \
    pkg-config \
    default-jdk \
    libopenblas-dev \
    liblapack-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    zlib1g-dev \
    libxml2-dev \
    libxslt1-dev \
    libgtk-3-dev \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    libgl1-mesa-glx \
    libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

# -------------------------------------------------------
# 2. Python 3.9 (stable for CellProfiler 4.2.x)
# -------------------------------------------------------
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && apt-get install -y \
    python3.9 \
    python3.9-dev \
    python3.9-distutils

# make python3.9 default python3
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1

# -------------------------------------------------------
# 3. Pip bootstrap (FIXED for Python 3.9)
# -------------------------------------------------------
RUN curl -sS https://bootstrap.pypa.io/pip/3.9/get-pip.py | python3.9

# -------------------------------------------------------
# 4. Upgrade packaging tools
# -------------------------------------------------------
RUN python3.9 -m pip install --upgrade pip setuptools wheel

# -------------------------------------------------------
# 5. Scientific stack (PINNED for CellProfiler 4.2.8.1)
# -------------------------------------------------------
RUN pip install --no-cache-dir \
    numpy==1.23.5 \
    scipy==1.9.0 \
    scikit-image==0.18.3 \
    scikit-learn==0.24.2 \
    matplotlib==3.5.3 \
    pillow==9.5.0 \
    tifffile==2021.11.2 \
    h5py==3.6.0 \
    imageio \
    mahotas \
    Jinja2 \
    joblib \
    inflect \
    pyzmq \
    requests

# -------------------------------------------------------
# 6. CellProfiler dependencies (JVM + bioformats)
# -------------------------------------------------------
RUN pip install --no-cache-dir \
    python-bioformats \
    python-javabridge

# -------------------------------------------------------
# 7. CellProfiler itself
# -------------------------------------------------------
RUN pip install --no-cache-dir \
    cellprofiler==4.2.8.1

# -------------------------------------------------------
# 8. Working directory
# -------------------------------------------------------
WORKDIR /workspace

CMD ["/bin/bash"]