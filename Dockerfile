FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    gcc \
    g++ \
    make \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip (important for wheel builds)
RUN pip install --no-cache-dir --upgrade pip

# Install Python dependencies
RUN pip install --no-cache-dir resemblyzer numpy scipy

WORKDIR /app

# Copy script
COPY find_most_similar_voice.py /app/find_most_similar_voice.py

ENTRYPOINT ["python", "find_most_similar_voice.py"]
