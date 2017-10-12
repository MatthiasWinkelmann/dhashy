#!/usr/bin/env python3
import sys
import dhash
from PIL import Image

# we use the python implementation as a reference

image = Image.open(sys.argv[1])
grays = dhash.get_grays(image, 3, 3)
row, col = dhash.dhash_row_col(grays, size=2)
print(row)
print(col)

print("hex:%s" % dhash.format_hex(row, col))
print("int:%s" % dhash.dhash_int(image))
print("bytes:%s" % dhash.format_bytes(row, col))
print("<matrix>%s\n\n%s</matrix>" % (dhash.format_matrix(row, bits='* '),dhash.format_matrix(col)))
