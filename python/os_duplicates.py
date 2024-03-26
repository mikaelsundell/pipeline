# Script:
#   os_duplicates.py
# Description:
#   Utility to find duplicate files in a diretory

import os
import hashlib
import sys

def hash_file(filepath):
    """ Generate MD5 hash for a file. """
    hasher = hashlib.md5()
    with open(filepath, 'rb') as file:
        buf = file.read(65536)  # read file in chunks
        while len(buf) > 0:
            hasher.update(buf)
            buf = file.read(65536)
    return hasher.hexdigest()

def find_duplicate_files(directory):
    hashes = {}
    duplicates = []

    for root, dirs, files in os.walk(directory):
        for file in files:
            filepath = os.path.join(root, file)
            file_hash = hash_file(filepath)
            if file_hash in hashes:
                hashes[file_hash].append(filepath)
            else:
                hashes[file_hash] = [filepath]

    for hash, files in hashes.items():
        if len(files) > 1:
            duplicates.append((hash, files))

    return duplicates

def main():
    if len(sys.argv) != 2:
        print("Usage: python script.py <directory>")
        sys.exit(1)

    directory_path = sys.argv[1]
    duplicates = find_duplicate_files(directory_path)

    if duplicates:
        print("Duplicate files found:")
        for hash, files in duplicates:
            print(f"Hash: {hash}, Files: {', '.join(files)}")
    else:
        print("No duplicate files found.")

if __name__ == "__main__":
    main()
