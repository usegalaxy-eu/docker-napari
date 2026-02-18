FROM jlesage/baseimage-gui:ubuntu-22.04-v4.9.0

ENV DEBIAN_FRONTEND=noninteractive \
    TZ="Europe/Berlin" \
    NVIDIA_VISIBLE_DEVICES="all" \
    NVIDIA_DRIVER_CAPABILITIES="compute,utility" \
    APP_NAME="Napari" \
    KEEP_APP_RUNNING=0 \
    TAKE_CONFIG_OWNERSHIP=1

RUN apt-get update -y && apt-get install -qqy build-essential \
    wget mesa-utils \
    unzip \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libfontconfig1 \
    libxrender1 \
    libdbus-1-3 \
    libxkbcommon-x11-0 \
    libxi6 \
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-randr0 \
    libxcb-render-util0 \
    libxcb-xinerama0 \
    libxcb-xinput0 \
    libxcb-xfixes0 \
    libxcb-shape0 \
    qt5dxcb-plugin \
    libxcb-cursor0 \
    fonts-dejavu \
    libarchive-dev \
    fontconfig \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh \
    && bash Miniforge3-Linux-x86_64.sh -b -p /opt/conda \
    && rm -f Miniforge3-Linux-x86_64.sh

ENV PATH="/opt/conda/bin:$PATH"

RUN /opt/conda/bin/mamba create --name napari -c conda-forge python=3.12 napari=0.6.6 pyqt napari-omero napari-skimage napari-ome-zarr \
    && /opt/conda/bin/mamba run -n napari pip install napari-trackastra

EXPOSE 5800

COPY startapp.sh /startapp.sh
COPY rc.xml.template /opt/base/etc/openbox/rc.xml.template
RUN chmod +x /startapp.sh

WORKDIR /config
