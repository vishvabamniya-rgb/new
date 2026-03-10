# Use Python 3.12 Alpine
FROM python:3.12-alpine3.20

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Install system dependencies
RUN apk add --no-cache \
    gcc \
    g++ \
    make \
    cmake \
    musl-dev \
    libffi-dev \
    openssl-dev \
    linux-headers \
    ffmpeg \
    aria2 \
    wget \
    unzip \
    bash

# Install Bento4 mp4decrypt
RUN wget -q https://github.com/axiomatic-systems/Bento4/archive/v1.6.0-639.zip && \
    unzip v1.6.0-639.zip && \
    cd Bento4-1.6.0-639 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(nproc) && \
    cp mp4decrypt /usr/local/bin/ && \
    cd /app && \
    rm -rf Bento4-1.6.0-639 v1.6.0-639.zip

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip setuptools wheel && \
    pip install --no-cache-dir -r sainibots.txt && \
    pip install --no-cache-dir -U yt-dlp

# Run bot
CMD ["python3", "modules/main.py"]
