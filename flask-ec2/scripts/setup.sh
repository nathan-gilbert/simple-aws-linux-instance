#!/bin/bash
# Update the instance and install necessary packages
sudo apt update
sudo apt install -y python3 python3-pip git

# Install Flask
sudo pip3 install Flask

# Set up the Flask application
cat <<EOF > /home/ubuntu/app.py
import json
import logging
import time

from flask import Flask, request

logging.basicConfig(filename='/var/log/flask-app.log', level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)

@app.route('/')
def hello_world():
    logger.info("A request was received at the root URL")
    return {'message': 'Hello, World!'}, 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
EOF

# Set up systemd service for Flask app
cat <<EOF | sudo tee /etc/systemd/system/flask-app.service
[Unit]
Description=Flask Application

[Service]
ExecStart=/usr/bin/python3 /home/ubuntu/app.py
WorkingDirectory=/home/ubuntu
User=root
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable flask-app
sudo systemctl start flask-app
