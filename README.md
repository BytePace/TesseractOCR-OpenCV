# Receipt Recognizer iOS

Text Recognizer from image via Tesseract OCR, Vision, Google MLKit

Language data - https://github.com/tesseract-ocr/tessdata

OpenCV framework - https://opencv.org/releases.html (Version 4.0.1)

# Описание

Данные проект дает возможность распознавания текста из выбранной картинки, фотографии.

Для начальной обработки изображения используется методы фильтрации изображения из фреймворка OpenCV

На вход подается обработанное изображение, на выходе получается распознанный текст

В проекте используется несколько методов распознавния:

    1. TesseractOCR
    
    2. Vision + Tesseract OCR (обработанное изображение делится на участки, используя фреймворк Vision. Далее, каждый в каждом участке отдельно распознается текст)
    
    3. Google MLKit
    
