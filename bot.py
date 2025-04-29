import asyncio
import base64
import requests
import os
from aiogram import Bot, Dispatcher, types
from aiogram.filters import Command  # <-- ВАЖНО
import config

# Константы
BOT_TOKEN = config.TELEGRAM_TOKEN
GPT_API_KEY = config.GPT_API_KEY

# Инициализация бота
bot = Bot(token=BOT_TOKEN)
dp = Dispatcher()

# Функция кодирования изображения
def encode_image(image_path):
    with open(image_path, "rb") as image_file:
        return base64.b64encode(image_file.read()).decode('utf-8')

# Функция отправки фото в OpenAI
def identify_bird(image_path):
    if not os.path.exists(image_path):
        raise FileNotFoundError(f"Файл {image_path} не найден.")

    base64_image = encode_image(image_path)

    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {GPT_API_KEY}"
    }

    payload = {
        "model": "gpt-4o",
        "messages": [
            {
                "role": "user",
                "content": [
                    {
                        "type": "text",
                        "text": "Ты орнитолог. Определи, пожалуйста, вид птицы на этом фото. Укажи научное название и кратко опиши особенности этой птицы."
                    },
                    {
                        "type": "image_url",
                        "image_url": {
                            "url": f"data:image/jpeg;base64,{base64_image}"
                        }
                    }
                ]
            }
        ],
        "max_tokens": 500
    }

    response = requests.post("https://api.openai.com/v1/chat/completions", headers=headers, json=payload)

    if response.status_code == 200:
        result = response.json()
        bird_info = result.get("choices", [{}])[0].get("message", {}).get("content", "Не удалось определить птицу.")
        return bird_info
    else:
        raise Exception(f"Ошибка при запросе к OpenAI API: {response.status_code}, {response.text}")

# Команда /start
@dp.message(Command("start"))  # <-- правильный синтаксис!
async def cmd_start(message: types.Message):
    await message.answer("👋 Привет! Пришли мне фото птицы, и я попробую определить её вид. 📷🦜")


import re

def clean_text(text):
    # Убираем символы Markdown: *, # и лишние пробелы
    cleaned = re.sub(r"[*#]", "", text)
    return cleaned.strip()

# Приём фото
@dp.message(lambda message: message.photo)
async def handle_photo(message: types.Message):
    try:
        photo = message.photo[-1]
        photo_path = f"temp_{message.from_user.id}.jpg"

        # Показываем "печатает..."
        await bot.send_chat_action(chat_id=message.chat.id, action="upload_photo")

        # Получаем файл и скачиваем
        file = await bot.get_file(photo.file_id)
        await bot.download_file(file.file_path, destination=photo_path)

        # Показываем "печатает..." (ещё раз, перед анализом)
        await bot.send_chat_action(chat_id=message.chat.id, action="typing")

        bird_info = identify_bird(photo_path)

        bird_info = clean_text(bird_info)  # <-- очистка


        await message.answer(f"🦜 Результат:\n\n{bird_info}")
        os.remove(photo_path)

    except Exception as e:
        await message.answer(f"❌ Ошибка: {str(e)}")
# Запуск бота
async def main():
    await dp.start_polling(bot)

if __name__ == "__main__":
    asyncio.run(main())
