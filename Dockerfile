FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# -------------------------------------------------------
# 1. System dependencies (must come first)
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
# 2. Python 3.9 (required for CellProfiler 4.2.x)
# -------------------------------------------------------
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && apt-get install -y \
    python3.9 \
    python3.9-dev \
    python3.9-distutils

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1

# -------------------------------------------------------
# 3. Pip bootstrap (correct for Python 3.9)
# -------------------------------------------------------
RUN curl -sS https://bootstrap.pypa.io/pip/3.9/get-pip.py | python3.9

# -------------------------------------------------------
# 4. Upgrade packaging tools
# -------------------------------------------------------
RUN python3.9 -m pip install --upgrade pip setuptools wheel

# -------------------------------------------------------
# 5. CRITICAL FIX: prevent pip build isolation issues
# -------------------------------------------------------
ENV PIP_NO_BUILD_ISOLATION=1
ENV PIP_NO_CACHE_DIR=1

# -------------------------------------------------------
# 6. CRITICAL FIX: pin NumPy FIRST (this fixes javabridge crash)
# -------------------------------------------------------
RUN pip install numpy==1.19.5

# -------------------------------------------------------
# 7. Scientific stack (must stay compatible with NumPy 1.19)
# -------------------------------------------------------
RUN pip install \
    scipy==1.5.4 \
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
# 8. Java bridge (NOW SAFE because NumPy is pinned)
# -------------------------------------------------------
RUN pip install python-bioformats python-javabridge

# -------------------------------------------------------
# 9. CellProfiler itself
# -------------------------------------------------------
RUN pip install cellprofiler==4.2.8.1

# -------------------------------------------------------
# 10. Working directory
# -------------------------------------------------------
WORKDIR /workspace

CMD ["/bin/bash"]