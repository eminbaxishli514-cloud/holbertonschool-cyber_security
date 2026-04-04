#!/usr/bin/python3
"""Documentation :
Module docs.
"""


import sys
import os


def usage():
    """Documentation :
    usage function docs.
    """

    print("Usage: read_write_heap.py pid search_string replace_string")
    sys.exit(1)


def main():
    """Documentation :
    main function docs.
    """
    if len(sys.argv) != 4:
        usage()
    pid = int(sys.argv[1])
    search_string = sys.argv[2].encode()
    replace_string = sys.argv[3].encode()
    mem_path = f"/proc/{pid}/mem"
    maps_path = f"/proc/{pid}/maps"
    try:
        with open(maps_path, 'r') as maps_file:
            for line in maps_file.readlines():
                parts = line.split()
                start = int(parts[0].split('-')[0], 16)
                end = int(parts[0].split('-')[1], 16)
                permissions = parts[1]
                if 'heap' in line and 'rw-p' in permissions:
                    with open(mem_path, 'r+b') as mem_file:
                        mem_file.seek(start)
                        data = mem_file.read(end - start)
                        index = data.find(search_string)
                        if index != -1:
                            new_1 = data[:index] + replace_string
                            new_2 = data[index + len(search_string):]
                            new_data = new_1 + new_2
                            mem_file.seek(start)
                            mem_file.write(new_data)
                            sys.exit(0)
        print("Error: String not found in heap")
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
