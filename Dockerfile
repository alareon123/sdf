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
