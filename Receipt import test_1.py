from PIL import Image
import pytesseract
import cv2
import csv

img = cv2.imread('/Users/mattgorka/test3.tiff')

##img = cv2.resize(img, None, fx=2, fy=2)

##img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
##config = '--oem 3 --psm %d'

file_2 = open("ocr_result.csv", "w")
writer = csv.writer(file_2, delimiter=' ')
##writer.writerow(["Result"])

txt = pytesseract.image_to_string(img, config=" --psm 6")
txt2 = txt.split('\n')

for item in txt2:
    writer.writerow([item])

print(txt2)

##print(txt)
file_2.close()

print('Hello world!')

##print(pytesseract.image_to_string(Image.open('/Users/mattgorka/TEST.png')))

## psm 4 is a very good option as is 6, 11 is okay.