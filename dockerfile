# Use an official Python image with version 3.8
FROM python:3.8

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

RUN python -m pip install --upgrade pip setuptools

# Install required Python packages
RUN pip install --no-cache-dir -r requirements.txt --verbose

# Create a virtual environment
RUN python -m venv venv

# Activate the virtual environment
SHELL ["venv/bin/activate"]

# Expose port 8000 for Django app
EXPOSE 8000

# Set environment variables
ENV ENVIRONMENT 'DEVELOPMENT'
ENV DJANGO_SECRET_KEY 'dont-tell-eve'
ENV DJANGO_DEBUG 'yes'

# Command to run the Django app
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
