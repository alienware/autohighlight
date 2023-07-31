FROM python:3.10-slim
LABEL maintainer="Tanay Upadhyaya"

RUN apt update \
    && apt install -y --no-install-recommends build-essential vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

CMD ["tail", "-f", "/dev/null"]



