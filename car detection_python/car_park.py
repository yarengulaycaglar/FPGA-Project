import cv2
from ultralytics import YOLO
import time
from sklearn.cluster import KMeans
import serial

def open_serial(port_name):
    ser = serial.Serial(port=port_name, baudrate=115200, bytesize=8, parity='N', stopbits=1, timeout=2, xonxoff=False, rtscts=False, dsrdtr=False)
    ser.close()
    ser.open()
    return ser

def get_colors(image, number_of_colors):
    modified_image = cv2.resize(image, (600, 400), interpolation=cv2.INTER_AREA)
    modified_image = modified_image.reshape(modified_image.shape[0]*modified_image.shape[1], 3)
    clf = KMeans(n_clusters=number_of_colors)
    labels = clf.fit_predict(modified_image)
    center_colors = clf.cluster_centers_
    most_common_color = center_colors[labels[0]]
    return list(map(int, most_common_color))

# Size thresholds
SMALL_SIZE_THRESHOLD = 18000  # Adjust this value based on your application
MEDIUM_SIZE_THRESHOLD = 30000  # Adjust this value based on your application

serial_port = open_serial("COM5")   
model = YOLO("yolo-Weights/yolov8n.pt")
cap = cv2.VideoCapture(1)

paused = False
pause_time = 0

while True:
    _, img = cap.read()
    if not paused:
        results = model(img, stream=True)
        object_detected = False

        for r in results:
            boxes = r.boxes
            for box in boxes:
                cls = int(box.cls[0])
                if model.names[cls] == 'person' or model.names[cls] == 'dog' or model.names[cls] == 'cat':
                    continue  # Skip 'person' class
                x1, y1, x2, y2 = [int(x) for x in box.xyxy[0]]
                cv2.rectangle(img, (x1, y1), (x2, y2), (255, 0, 255), 3)
                last_roi = img[y1:y2, x1:x2]
                paused = True
                pause_time = time.time()
                object_detected = True
                break
            if object_detected:
                break

    cv2.imshow('Webcam', img)

    if paused and (time.time() - pause_time > 10):
        if object_detected:
            color = get_colors(last_roi, 1)
            size = (x2 - x1) * (y2 - y1)
            if size < SMALL_SIZE_THRESHOLD:
                size_code = 0b10
            elif size < MEDIUM_SIZE_THRESHOLD:
                size_code = 0b01
            else:
                size_code = 0b00
            
            transmit_bytes_to_fpga = bytearray(4)
            transmit_bytes_to_fpga[0] = (color[0]) #blue 
            transmit_bytes_to_fpga[1] = (color[1]) #green
            transmit_bytes_to_fpga[2] = (color[2]) #red
            transmit_bytes_to_fpga[3] = size_code                    
            serial_port.write(transmit_bytes_to_fpga)
            time.sleep(2)
        paused = False

    if cv2.waitKey(1) == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
