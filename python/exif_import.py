# Script:
#   exif_import.py
# Description:
#   Utility to import camera images to directories created from original date time
# Requirements:
#   pip3 install exifread

import os
import shutil
import exifread
import sys
from datetime import datetime

def get_creation_time(file_path):
    try:
        with open(file_path, 'rb') as f:
            tags = exifread.process_file(f, details=False)
            if 'EXIF DateTimeOriginal' in tags:
                date_str = str(tags['EXIF DateTimeOriginal'])
                return datetime.strptime(date_str, '%Y:%m:%d %H:%M:%S')
    except Exception as e:
        pass
    return None

def create_directories(files, target_dir):
    prev_time = None
    current_dir = None

    for file in files:
        file_path = os.path.join(source_dir, file)
        creation_time = get_creation_time(file_path)

        if creation_time:
            if prev_time is None or (creation_time - prev_time).total_seconds() > 5:
                current_dir = os.path.join(target_dir, creation_time.strftime('%Y%m%d_%H%M%S'))
                os.makedirs(current_dir, exist_ok=True)
            shutil.copy2(file_path, current_dir)
            prev_time = creation_time

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: ./exif_import.py /path/source /path/target")
        sys.exit(1)

    source_dir = sys.argv[1]
    target_dir = sys.argv[2]

    if not os.path.exists(source_dir) or not os.path.exists(target_dir):
        print("Source or target directory does not exist.")
        sys.exit(1)

    files = sorted(os.listdir(source_dir), key=lambda x: os.path.getctime(os.path.join(source_dir, x)))
    create_directories(files, target_dir)
