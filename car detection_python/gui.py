import cv2
import tkinter as tk
from tkinter import ttk, messagebox, StringVar, IntVar
from tkinter.scrolledtext import ScrolledText
import threading
import serial
from datetime import datetime
from PIL import Image, ImageTk  # Make sure to install Pillow: pip install pillow
from ultralytics import YOLO  # Make sure YOLO is properly installed
import time
from sklearn.cluster import KMeans

# Global variables
camera_connected = False
serial_connected = False
cap = None
ser = None
model = YOLO("yolo-Weights/yolov8n.pt")

def get_colors(image, number_of_colors):
    modified_image = cv2.resize(image, (600, 400), interpolation=cv2.INTER_AREA)
    modified_image = modified_image.reshape(modified_image.shape[0]*modified_image.shape[1], 3)
    clf = KMeans(n_clusters=number_of_colors)
    labels = clf.fit_predict(modified_image)
    center_colors = clf.cluster_centers_
    most_common_color = center_colors[labels[0]]
    return list(map(int, most_common_color))

def connect_serial(port_name):
    global ser, serial_connected
    try:
        ser = serial.Serial(port=port_name, baudrate=115200, timeout=1)
        serial_connected = True
        log("Serial connected")
    except Exception as e:
        messagebox.showerror("Error", f"Could not connect to serial: {str(e)}")
        serial_connected = False

def disconnect_serial():
    global ser, serial_connected
    if ser:
        ser.close()
        serial_connected = False
        log("Serial disconnected")

def connect_camera(camera_index):
    global cap, camera_connected
    cap = cv2.VideoCapture(camera_index)
    if cap.isOpened():
        camera_connected = True
        log("Camera connected")
        threading.Thread(target=video_stream, daemon=True).start()
    else:
        messagebox.showerror("Error", "Could not connect to camera")
        camera_connected = False

def disconnect_camera():
    global cap, camera_connected
    if cap:
        cap.release()
        camera_connected = False
        log("Camera disconnected")

def video_stream():
    global cap, camera_connected, ser, serial_connected
    while camera_connected:
        ret, frame = cap.read()
        if ret:
            # Object Detection
            results = model(frame)
            for result in results.xyxy[0]:
                xmin, ymin, xmax, ymax, conf, cls = int(result[0]), int(result[1]), int(result[2]), int(result[3]), result[4], int(result[5])
                label = model.names[cls]
                cv2.rectangle(frame, (xmin, ymin), (xmax, ymax), (0, 255, 0), 2)
                cv2.putText(frame, f'{label} {conf:.2f}', (xmin, ymin - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 255, 0), 2)

            # Convert frame to display in Tkinter
            img = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
            img = Image.fromarray(img)
            img_tk = ImageTk.PhotoImage(image=img)
            video_label.imgtk = img_tk
            video_label.configure(image=img_tk)
        time.sleep(0.03)

def log(message):
    current_time = datetime.now().strftime("%H:%M:%S")
    log_text.insert(tk.END, f"[{current_time}] {message}\n")
    log_text.yview(tk.END)

# GUI setup
root = tk.Tk()
root.title("Parking Lot Monitoring System")

# Serial connection frame
serial_frame = ttk.LabelFrame(root, text="Serial Connection")
serial_frame.grid(row=0, column=0, padx=10, pady=10, sticky="ew")

com_port_var = tk.StringVar()
ttk.Label(serial_frame, text="COM Port:").grid(row=0, column=0)
com_port_entry = ttk.Entry(serial_frame, textvariable=com_port_var)
com_port_entry.grid(row=0, column=1)
connect_serial_button = ttk.Button(serial_frame, text="Connect", command=lambda: connect_serial(com_port_var.get()))
connect_serial_button.grid(row=0, column=2)
disconnect_serial_button = ttk.Button(serial_frame, text="Disconnect", command=disconnect_serial)
disconnect_serial_button.grid(row=0, column=3)

# Camera connection frame
camera_frame = ttk.LabelFrame(root, text="Camera Connection")
camera_frame.grid(row=1, column=0, padx=10, pady=10, sticky="ew")

camera_var = tk.IntVar()
ttk.Label(camera_frame, text="Camera Index:").grid(row=0, column=0)
camera_entry = ttk.Entry(camera_frame, textvariable=camera_var)
camera_entry.grid(row=0, column=1)
connect_camera_button = ttk.Button(camera_frame, text="Connect", command=lambda: connect_camera(camera_var.get()))
connect_camera_button.grid(row=0, column=2)
disconnect_camera_button = ttk.Button(camera_frame, text="Disconnect", command=disconnect_camera)
disconnect_camera_button.grid(row=0, column=3)

# Video frame
video_frame = ttk.LabelFrame(root, text="Video")
video_frame.grid(row=2, column=0, padx=10, pady=10, sticky="ew")
video_label = ttk.Label(video_frame)
video_label.pack()

# Log frame
log_frame = ttk.LabelFrame(root, text="Log")
log_frame.grid(row=3, column=0, padx=10, pady=10, sticky="ew")
log_text = ScrolledText(log_frame, wrap='word', height=10)
log_text.pack(fill='both', expand=True)

root.mainloop()