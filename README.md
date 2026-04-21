# Задача
Написать bash-скрипт, который принимает в качестве входящего параметра город. Выводит температуру и влажность в текущий день в этом городе.
Установить nginx.
Скрипт запускать по крону раз в минуту, вывод сохранять в index.html дефолтного сайта.
Необходимо использовать:
https://github.com/chubin/wttr.in (json формат)
библиотека jq для работы с json
# ЭТАПЫ РАБОТЫ
# Подняли nginx
<img width="974" height="564" alt="image" src="https://github.com/user-attachments/assets/6814bca5-13eb-4ebb-8bde-dcc8becd607d" />
# Запрос погоды в формате JSON
<img width="624" height="335" alt="image" src="https://github.com/user-attachments/assets/3e589d18-f351-4088-ad97-89b017dbd0b4" />

# Устанавливаем утилиту парсинга json
<img width="974" height="206" alt="image" src="https://github.com/user-attachments/assets/80847fd2-0e38-4acd-8421-b863e6f17c25" />

# С парсингом оказались проблемы... Веб-сайт также не загружал температуру и влажность.
<img width="819" height="316" alt="image" src="https://github.com/user-attachments/assets/a740e1ef-6824-4dae-b35e-7d3222fb398d" />

# Настройка cron
<img width="805" height="629" alt="image" src="https://github.com/user-attachments/assets/85574e0d-e9ba-40ea-97da-a2b8fb2d626d" />

# Ничего не помогало решить эту проблему (одногруппники сказали, что работает только с впн :)). Было принято переехать на другой сайт (https://open-meteo.com/)
<img width="783" height="238" alt="image" src="https://github.com/user-attachments/assets/caaeebf2-7b49-4c36-9b0e-dd0eea525b27" />

<img width="667" height="58" alt="image" src="https://github.com/user-attachments/assets/eaf60338-5165-4240-a22f-11e19632d110" />

# Итоговый результат (с красивым оформлением помог дипсик)

<img width="783" height="238" alt="image" src="https://github.com/user-attachments/assets/b7bbb071-4f34-4c55-8378-5a9f6dbf0459" />

<img width="784" height="405" alt="image" src="https://github.com/user-attachments/assets/ad321f41-7ad9-4809-8ef5-cf6d6458c9a3" />
