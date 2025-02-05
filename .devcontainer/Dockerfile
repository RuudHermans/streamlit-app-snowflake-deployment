# Dockerfile for Streamlit Application Development

# Use an official Python runtime as the base image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the application files into the container
COPY app/ ./app
COPY mock_data/ ./mock_data
COPY run_mock.sh ./run_mock.sh

# Install dependencies
RUN pip install --no-cache-dir -r app/requirements.txt

# Grant execute permission to run_mock.sh
RUN chmod +x /app/run_mock.sh

# Default command to run the app
CMD ["./run_mock.sh"]
