# Используем официальный Python образ
FROM python:3.10-slim

# Устанавливаем необходимые системные зависимости
RUN apt-get update && apt-get install -y \
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
COPY requirements.txt .

# Устанавливаем зависимости из requirements.txt (кэшируется)
RUN pip install --no-cache-dir -r requirements.txt

# Копируем всё остальное только после установки зависимостей
COPY . .

# Открываем порты и запускаем приложение
EXPOSE 7860
CMD ["python", "launch.py", "--api"]
