#!/usr/bin/env python3
"""Remplacement minimal de `icotool -c` (icoutils) pour ECMAddAppIcon.

Usage : icotool.py -c -o sortie.ico [-r] image1.png [-r] image2.png ...
Chaque PNG est embarqué tel quel dans le fichier .ico (format accepté par
Windows depuis Vista pour toutes les tailles).
"""
import struct
import sys


def png_size(data: bytes):
    if data[:8] != b"\x89PNG\r\n\x1a\n" or data[12:16] != b"IHDR":
        raise ValueError("fichier PNG invalide")
    return struct.unpack(">II", data[16:24])


def main(argv):
    output, images = None, []
    it = iter(argv)
    for arg in it:
        if arg == "-o":
            output = next(it)
        elif arg.startswith("--output="):
            output = arg.split("=", 1)[1]
        elif arg in ("-c", "--create", "-r", "--raw"):
            continue
        else:
            images.append(arg)
    if not output or not images:
        sys.exit("usage: icotool.py -c -o out.ico [-r] img.png ...")

    entries = []
    for path in images:
        with open(path, "rb") as f:
            data = f.read()
        w, h = png_size(data)
        entries.append((w, h, data))
    entries.sort(key=lambda e: e[0])

    header = struct.pack("<HHH", 0, 1, len(entries))
    offset = 6 + 16 * len(entries)
    directory, blobs = b"", b""
    for w, h, data in entries:
        directory += struct.pack("<BBBBHHII", w if w < 256 else 0, h if h < 256 else 0,
                                 0, 0, 1, 32, len(data), offset)
        blobs += data
        offset += len(data)
    with open(output, "wb") as f:
        f.write(header + directory + blobs)


if __name__ == "__main__":
    main(sys.argv[1:])
