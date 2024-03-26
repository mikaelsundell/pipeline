# Script:
#   colour-science_plot_CE1931.py
# Description:
#   Utility to plot the CIE1913 chromacity diagram
# Requirements:
#   pip3 install colour-science

import numpy as np
import colour
from colour.plotting import *
import os

from colour.utilities import message_box

def main():
    os.system('clear')

    print("-----------------------------------------")
    print("Plot CIE gamuts")
    print("-----------------------------------------")

    RGB = np.random.random((32, 32, 3))
    plot_RGB_chromaticities_in_chromaticity_diagram_CIE1931(
        RGB,
        "ITU-R BT.709",
        colourspaces=["ACEScg", "S-Gamut", "Pointer Gamut"],
    )

if __name__ == "__main__":
    colour_style()
    main()