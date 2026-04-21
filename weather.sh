#!/bin/bash

# --- Проверка параметра ---
if [ -z "$1" ]; then
    echo "Ошибка: не указан город."
    echo "Использование: $0 <город>"
    exit 1
fi
CITY="$1"
OUTPUT_FILE="/var/www/html/index.html"

# --- Геокодинг (город → координаты) ---
GEO_URL="https://nominatim.openstreetmap.org/search?q=${CITY}&format=json&limit=1"
USER_AGENT="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

GEO_DATA=$(curl -s -H "User-Agent: $USER_AGENT" "$GEO_URL")
LAT=$(echo "$GEO_DATA" | jq -r '.[0].lat // empty')
LON=$(echo "$GEO_DATA" | jq -r '.[0].lon // empty')

if [ -z "$LAT" ] || [ -z "$LON" ]; then
    echo "Ошибка: Город '$CITY' не найден." >&2
    exit 1
fi

# --- Получение погоды и часового пояса от Open-Meteo ---
WEATHER_URL="https://api.open-meteo.com/v1/forecast?latitude=${LAT}&longitude=${LON}&current_weather=true&hourly=temperature_2m,relative_humidity_2m&timezone=auto"
WEATHER_JSON=$(curl -s "$WEATHER_URL")

TEMP_C=$(echo "$WEATHER_JSON" | jq -r '.current_weather.temperature // empty')
HUMIDITY=$(echo "$WEATHER_JSON" | jq -r '.hourly.relative_humidity_2m[0] // empty')
TIMEZONE=$(echo "$WEATHER_JSON" | jq -r '.timezone // empty')   # например "Europe/London"

if [ -z "$TEMP_C" ] || [ -z "$HUMIDITY" ]; then
    echo "Ошибка: не удалось извлечь данные о погоде." >&2
    exit 1
fi

# --- Формирование правильного локального времени города ---
if [ -n "$TIMEZONE" ] && [ "$TIMEZONE" != "null" ]; then
    # Используем временную зону из API
    LOCAL_DATETIME=$(TZ="$TIMEZONE" date '+%Y-%m-%d %H:%M:%S')
else
    # fallback — системное время сервера
    LOCAL_DATETIME=$(date '+%Y-%m-%d %H:%M:%S')
    TIMEZONE="(время сервера)"
fi

# --- Генерация HTML ---
cat > "$OUTPUT_FILE" << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Погода в городе $CITY</title>
    <meta charset="UTF-8">
    <meta http-equiv="refresh" content="60">
    <style>
        body { font-family: Arial, sans-serif; text-align: center; padding: 50px; background-color: #f0f0f0; }
        .weather-card { background-color: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); display: inline-block; }
        .city { font-size: 2em; margin-bottom: 20px; color: #333; }
        .temp { font-size: 3em; margin-bottom: 10px; color: #e74c3c; }
        .humidity { font-size: 1.5em; margin-bottom: 10px; color: #3498db; }
        .timezone { font-size: 0.9em; color: #555; margin-top: 10px; }
        .update-time { font-size: 0.8em; color: #777; }
    </style>
</head>
<body>
    <div class="weather-card">
        <div class="city">🌍 Погода в городе: ${CITY}</div>
        <div class="temp">🌡️ Температура: ${TEMP_C}°C</div>
        <div class="humidity">💧 Влажность: ${HUMIDITY}%</div>
        <div class="timezone">🕒 Часовой пояс: ${TIMEZONE}</div>
        <div class="update-time">📅 Местное время: ${LOCAL_DATETIME}</div>
        <div class="update-time">🔄 Обновляется каждую минуту</div>
    </div>
</body>
</html>
EOF

echo "✅ Страница обновлена: $OUTPUT_FILE (локальное время города: $LOCAL_DATETIME)"