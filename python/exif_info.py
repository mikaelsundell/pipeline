# Script:
#   exif_import.py
# Description:
#   Utility to show info from camera image tags
# Requirements:
#   pip3 install exifread

import os
import exifread
import sys

def print_exif_info(file_path):
    try:
        with open(file_path, 'rb') as f:
            tags = exifread.process_file(f)
            print(f"File: {file_path}")
            for tag, value in tags.items():
                print(f"{tag}: {value}")
    except Exception as e:
        print(f"Error processing {file_path}: {e}")

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print("Usage: ./nikon_info.py /path/source")
        sys.exit(1)

    source_path = sys.argv[1]

    if os.path.exists(source_path):
        if os.path.isdir(source_path):
            for root, dirs, files in os.walk(source_path):
                for file in files:
                    if file.lower().endswith(('.jpg', '.jpeg', '.nef')):
                        file_path = os.path.join(root, file)
                        print_exif_info(file_path)
        elif os.path.isfile(source_path) and source_path.lower().endswith(('.jpg', '.jpeg', '.nef', '.dng')):
            print_exif_info(source_path)
        else:
            print("Invalid file or directory.")
    else:
        print("File or directory does not exist.")
