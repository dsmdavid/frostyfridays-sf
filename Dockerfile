FROM python:3.8.2-buster

RUN apt-get update -yqq \
  && apt-get install -yqq \
    postgresql \
    libssl-dev \
    less \
    vim \
    libffi-dev \
    libpq-dev

# upgrade pip
RUN pip install --upgrade pip

RUN echo 'alias ll="ls -lari"' >> ~/.bashrc

# Install dependencies:
COPY requirements.txt .
RUN pip install -r requirements.txt

ENV DBT_PROFILES_DIR=/app/profiles
RUN mkdir -p /app
COPY ./ /app/
RUN chmod 777 -R /app
WORKDIR /app/
RUN dbt deps
RUN pre-commit install
EXPOSE 8501
