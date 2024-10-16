# Используем официальный NVIDIA Python образ с поддержкой GPU
FROM nvidia/cuda:11.7.1-cudnn8-runtime-ubuntu20.04

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

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем только файл зависимостей
COPY sdf/requirements.txt .

# Обновляем pip и устанавливаем PyTorch с поддержкой CUDA (вместо CPU-версии)
RUN pip install --upgrade pip setuptools
RUN pip install --no-cache-dir torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu117

# Устанавливаем остальные зависимости из requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Копируем всё остальное после установки зависимостей
COPY sdf/ .

# Открываем порт 7860
EXPOSE 7860

# Команда для запуска приложения с GPU, API, и внешней папкой для моделей
CMD ["python3", "launch.py", "--api", "--listen", "--port", "7860", "--ckpt-dir", "/app/models"]
