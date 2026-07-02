FROM continuumio/miniconda3:latest

SHELL ["/bin/bash", "-c"]

# -------------------------------------------------------
# 1. System dependencies (CRITICAL)
# -------------------------------------------------------
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    pkg-config \
    default-jdk \
    libopenblas-dev \
    liblapack-dev \
    gfortran \
    libjpeg-dev \
    zlib1g-dev \
    libtiff-dev \
    libpng-dev \
    libxml2-dev \
    libxslt1-dev \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    libgl1 \
    default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

# -------------------------------------------------------
# 2. Create conda env
# -------------------------------------------------------
RUN conda create -n cp python=3.9 -y
ENV PATH=/opt/conda/envs/cp/bin:$PATH

# -------------------------------------------------------
# 3. Upgrade pip toolchain (IMPORTANT for javabridge builds)
# -------------------------------------------------------
RUN pip install --upgrade pip setuptools wheel

# -------------------------------------------------------
# 4. PIN critical NumPy version (THIS FIXES YOUR ERROR)
# -------------------------------------------------------
RUN pip install "numpy<1.24"

# -------------------------------------------------------
# 5. Install CellProfiler dependencies (careful ordering)
# -------------------------------------------------------
RUN pip install \
    scipy==1.9.0 \
    scikit-image==0.18.3 \
    scikit-learn==0.24.2 \
    matplotlib==3.5.3 \
    h5py \
    pillow \
    mahotas \
    tifffile \
    requests \
    imageio \
    Jinja2 \
    joblib \
    inflect

# -------------------------------------------------------
# 6. Java bridge stack (order matters)
# -------------------------------------------------------
# -------------------------------------------------------
# Java (stable across Debian versions)
# -------------------------------------------------------
RUN apt-get update && apt-get install -y curl tar

ENV JAVA_VERSION=17

RUN curl -L -o /tmp/jdk.tar.gz \
    https://api.adoptium.net/v3/binary/latest/${JAVA_VERSION}/ga/linux/x64/jdk/hotspot/normal/eclipse

RUN mkdir -p /opt/java && \
    tar -xzf /tmp/jdk.tar.gz -C /opt/java --strip-components=1

ENV JAVA_HOME=/opt/java
ENV PATH="$JAVA_HOME/bin:$PATH"

RUN java -version
ENV PATH=$JAVA_HOME/bin:$PATH

RUN pip install "numpy<1.24"

RUN pip install --no-build-isolation \
    numpy \
    python-javabridge==4.0.3 \
    python-bioformats==4.0.7

# -------------------------------------------------------
# 7. MySQL client fix (no build from source)
# -------------------------------------------------------
RUN pip install mysqlclient==1.4.6

# -------------------------------------------------------
# 8. Finally CellProfiler
# -------------------------------------------------------
RUN pip install cellprofiler==4.2.8.1

# -------------------------------------------------------
# 9. Headless config (CI-safe)
# -------------------------------------------------------
ENV MPLBACKEND=Agg
ENV QT_QPA_PLATFORM=offscreen

CMD ["python", "-c", "import cellprofiler; print('CellProfiler OK')"]