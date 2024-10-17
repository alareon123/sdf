# Используем официальный NVIDIA Python образ
FROM nvidia/cuda:11.7.1-cudnn8-runtime-ubuntu20.04

# Устанавливаем переменную окружения для подавления интерактивных запросов
ENV DEBIAN_FRONTEND=noninteractive

# Устанавливаем необходимые системные зависимости
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-dev \
    build-essential \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    && rm -rf /var/lib/apt/lists/*

# Настраиваем часовой пояс
RUN ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем скачанные пакеты Torch и его зависимости в контейнер
COPY ./torch-packages /app/torch-packages

# Вместо установки всех .whl файлов сразу, установим их по отдельности
RUN pip install --no-cache-dir /app/torch-packages/nvidia_curand_cu12-10.3.2.106-py3-none-manylinux1_x86_64.whl \
    && pip install --no-cache-dir /app/torch-packages/filelock-3.16.1-py3-none-any.whl \
    && pip install --no-cache-dir /app/torch-packages/fsspec-2024.9.0-py3-none-any.whl \
    && pip install --no-cache-dir /app/torch-packages/jinja2-3.1.4-py3-none-any.whl \
    && pip install --no-cache-dir /app/torch-packages/mpmath-1.3.0-py3-none-any.whl \
    && pip install --no-cache-dir /app/torch-packages/numpy-2.1.2-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl \
    && pip install --no-cache-dir /app/torch-packages/nvidia_cublas_cu12-12.1.3.1-py3-none-manylinux1_x86_64.whl \
    && pip install --no-cache-dir /app/torch-packages/nvidia_cuda_cupti_cu12-12.1.105-py3-none-manylinux1_x86_64.whl \
    && pip install --no-cache-dir /app/torch-packages/nvidia_cuda_nvrtc_cu12-12.1.105-py3-none-manylinux1_x86_64.whl \
    && pip install --no-cache-dir /app/torch-packages/nvidia_cuda_runtime_cu12-12.1.105-py3-none-manylinux1_x86_64.whl \
    && pip install --no-cache-dir /app/torch-packages/nvidia_cudnn_cu12-9.1.0.70-py3-none-manylinux2014_x86_64.whl \
    && pip install --no-cache-dir /app/torch-packages/nvidia_cufft_cu12-11.0.2.54-py3-none-manylinux1_x86_64.whl \
    && pip install --no-cache-dir /app/torch-packages/nvidia_cusolver_cu12-11.4.5.107-py3-none-manylinux1_x86_64.whl \
    && pip install --no-cache-dir /app/torch-packages/nvidia_cusparse_cu12-12.1.0.106-py3-none-manylinux1_x86_64.whl \
    && pip install --no-cache-dir /app/torch-packages/nvidia_nccl_cu12-2.20.5-py3-none-manylinux2014_x86_64.whl \
    && pip install --no-cache-dir /app/torch-packages/nvidia_nvjitlink_cu12-12.6.77-py3-none-manylinux2014_x86_64.whl \
    && pip install --no-cache-dir /app/torch-packages/nvidia_nvtx_cu12-12.1.105-py3-none-manylinux1_x86_64.whl \
    && pip install --no-cache-dir /app/torch-packages/pillow-11.0.0-cp310-cp310-manylinux_2_28_x86_64.whl \
    && pip install --no-cache-dir /app/torch-packages/sympy-1.13.3-py3-none-any.whl \
    && pip install --no-cache-dir /app/torch-packages/torch-2.4.1-cp310-cp310-manylinux1_x86_64.whl \
    && pip install --no-cache-dir /app/torch-packages/torchaudio-2.4.1-cp310-cp310-manylinux1_x86_64.whl \
    && pip install --no-cache-dir /app/torch-packages/torchvision-0.19.1-cp310-cp310-manylinux1_x86_64.whl \
    && pip install --no-cache-dir /app/torch-packages/triton-3.0.0-1-cp310-cp310-manylinux2014_x86_64.manylinux_2_17_x86_64.whl \
    && pip install --no-cache-dir /app/torch-packages/typing_extensions-4.12.2-py3-none-any.whl


# Копируем файл зависимостей requirements.txt
COPY requirements.txt .

# Устанавливаем остальные зависимости
RUN pip install --no-cache-dir -r requirements.txt

# Копируем все остальные файлы
COPY . .

# Открываем порт 7860
EXPOSE 7860

# Команда для запуска приложения
CMD ["python3", "launch.py", "--api", "--listen", "--port", "7860", "--ckpt-dir", "/app/models"]
