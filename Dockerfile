# Используем официальный Python образ с нужной версией
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

# Копируем файл зависимостей и устанавливаем их
COPY requirements.txt .
RUN pip install --upgrade pip
RUN time pip install --no-cache-dir -r requirements.txt --progress-bar on --log /app/pip-log.txt

# Копируем весь проект в рабочую директорию
COPY . .

# Открываем порт, который потребуется для веб-интерфейса (например, 7860 для WebUI)
EXPOSE 7860

# Команда для запуска приложения (например, запуск веб-интерфейса)
CMD ["python", "launch.py --api"]
