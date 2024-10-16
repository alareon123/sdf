# stable_diffusion/Dockerfile (для GPU)

# Используем официальный NVIDIA Python образ
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
COPY stable_diffusion/requirements.txt .

# Устанавливаем зависимости из requirements.txt (кэшируется)
# Обновляем pip и setuptools
RUN pip install --upgrade pip setuptools
RUN pip install --no-cache-dir torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cpu
RUN pip install --no-cache-dir -r requirements.txt

# Копируем всё остальное только после установки зависимостей
COPY stable_diffusion/ .

# Открываем порт 7860
EXPOSE 7860

# Команда для запуска приложения
CMD ["python3", "launch.py", "--api", "--listen", "--port", "7860"]
