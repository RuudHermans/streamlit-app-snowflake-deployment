# Base image
FROM python:3.9-slim

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Snowflake CLI
RUN pip install --upgrade pip \
    && pip install snowflake-cli streamlit PyYAML

# Set working directory
WORKDIR /workspace

# Copy project files
COPY . /workspace

# Expose Streamlit port
EXPOSE 8501

# Default command
CMD ["streamlit", "run", "app/app.py"]
