import cv2
import numpy as np
from sklearn.cluster import KMeans
import os
print("Current directory:", os.getcwd())

def load_yolo():
    net = cv2.dnn.readNet("yolov3.weights" , "yolov3.cfg")
    classes = []
    with open("coco.names", "r") as f:
        classes = [line.strip() for line in f.readlines()]
    
    # Getting layer names and connecting output layers
    layer_names = net.getLayerNames()
    output_layers = [layer_names[i[0] - 1] if isinstance(i, np.ndarray) else layer_names[i - 1] for i in net.getUnconnectedOutLayers()]

    return net, classes, output_layers


def detect_objects(img, net, outputLayers):
    blob = cv2.dnn.blobFromImage(img, scalefactor=0.00392, size=(320, 320), mean=(0, 0, 0), swapRB=True, crop=False)
    net.setInput(blob)
    outputs = net.forward(outputLayers)
    return blob, outputs

def get_box_dimensions(outputs, height, width):
    boxes = []
    confs = []
    class_ids = []
    for output in outputs:
        for detect in output:
            scores = detect[5:]
            class_id = np.argmax(scores)
            conf = scores[class_id]
            if conf > 0.5:
                center_x = int(detect[0] * width)
                center_y = int(detect[1] * height)
                w = int(detect[2] * width)
                h = int(detect[3] * height)
                x = center_x - w // 2
                y = center_y - h // 2
                boxes.append([x, y, w, h])
                confs.append(float(conf))
                class_ids.append(class_id)
    return boxes, confs, class_ids

def find_dominant_color(image, k=1):
    # Reshape the image to be a list of pixels
    pixels = image.reshape((image.shape[0] * image.shape[1], 3))

    # Perform k-means clustering to find the most common color
    kmeans = KMeans(n_clusters=k)
    kmeans.fit(pixels)

    # The most dominant color
    dominant_color = kmeans.cluster_centers_[0].astype(int)
    return tuple(dominant_color)

def draw_labels(boxes, confs, colors, class_ids, classes, img):
    indexes = cv2.dnn.NMSBoxes(boxes, confs, 0.5, 0.4)
    font = cv2.FONT_HERSHEY_PLAIN
    for i in range(len(boxes)):
        if i in indexes:
            x, y, w, h = boxes[i]
            label = str(classes[class_ids[i]])
            if label == "car":
                color = colors[i]
                cv2.rectangle(img, (x, y), (x + w, y + h), color, 2)
                cv2.putText(img, label, (x, y - 5), font, 1, color, 1)

                # Extract the region of the image that contains the car
                car_region = img[y:y+h, x:x+w]
                dominant_color = find_dominant_color(car_region, k=1)
                
                print(f"Detected car dominant color: RGB={dominant_color}")
                cv2.putText(img, f"Color: {dominant_color}", (x, y + h + 15), font, 1, (255,255,255), 2)
    return img


def webcam_detect():
    model, classes, output_layers = load_yolo()
    cap = cv2.VideoCapture(0)
    colors = np.random.uniform(0, 255, size=(len(classes), 3))

    while True:
        _, frame = cap.read()
        height, width, channels = frame.shape
        boxes, confs, class_ids = get_box_dimensions(detect_objects(frame, model, output_layers)[1], height, width)
        frame = draw_labels(boxes, confs, colors, class_ids, classes, frame)
        cv2.imshow("Car Detection", frame)
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()

if __name__ == '__main__':
    webcam_detect()
