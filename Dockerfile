FROM continuumio/anaconda3
LABEL maintainer="Tanay Upadhyaya"

RUN apt update \
    && apt install -y --no-install-recommends build-essential vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY environment.yml .
RUN conda env create -f environment.yml
SHELL ["conda", "run", "-n", "autohighlight", "/bin/bash", "-c"]

RUN mkdir -p $CONDA_PREFIX/etc/conda/activate.d
RUN echo 'CUDNN_PATH=$(dirname $(python -c "import nvidia.cudnn;print(nvidia.cudnn.__file__)"))' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
RUN echo 'export LD_LIBRARY_PATH=$CONDA_PREFIX/lib/:$CUDNN_PATH/lib:$LD_LIBRARY_PATH' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

RUN echo "conda activate autohighlight" >> ~/.bashrc

CMD ["tail", "-f", "/dev/null"]
