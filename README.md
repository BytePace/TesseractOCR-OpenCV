# Receipt Recognizer iOS

Text Recognizer from image via Tesseract OCR, Vision, Google MLKit

Language data - https://github.com/tesseract-ocr/tessdata

OpenCV framework - https://opencv.org/releases.html (Version 4.0.1)

# Описание

Данный проект дает возможность распознавания текста из выбранной картинки, фотографии.

Для начальной обработки изображения используются методы фильтрации изображения из фреймворка OpenCV

На вход подается обработанное изображение, на выходе получается распознанный текст

В проекте используется несколько методов распознавания:
    1. TesseractOCR
    2. Vision + Tesseract OCR (обработанное изображение делится на участки, используя фреймворк Vision. Далее в каждом участке отдельно распознается текст)
    3. Google MLKit
