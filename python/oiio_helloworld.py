# Script:
#   oiio_helloworld.py
# Description:
#   Utility to create an image with hello, world! text
# Requirements:
#   export PYTHONPATH=$PYTHONPATH:<3rdparty>/lib/python3.8/site-packages

import OpenImageIO as oiio

def create_hello_world(output_file):
    image = oiio.ImageBuf()

    width = 512
    height = 256

    black_color = oiio.Color(0, 0, 0, 1)
    image.reset(oiio.ImageSpec(width, height, 4, oiio.UINT8))

    text = "Hello, world!"
    text_writer = oiio.ImageBufAlgo.TextWriter(image)
    text_writer.text(text, x=20, y=100, fontsize=30, color=oiio.Color4(1, 1, 1, 1))
    image.write(output_file)

if __name__ == "__main__":
    output_file = "helloworld.png"
    create_hello_world(output_file)
    print(f"Image saved to {output_file}")