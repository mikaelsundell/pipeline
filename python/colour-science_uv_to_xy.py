# Script:
#   colour-science_uv_to_xy.py
# Description:
#   Utility to convert from CCT Δuv measures to xy coordinates
# Requirements:
#   pip3 install colour-science

import numpy as np
import colour
import os

from colour.utilities import message_box

def main():
    os.system('clear')

    print("-----------------------------------------")
    print("CCT Δuv to XY")
    print("-----------------------------------------")

    cmfs = colour.MSDS_CMFS["CIE 1931 2 Degree Standard Observer"]
    CCT = float(input("Enter CCT (Correlated Color Temperature): "))
    uv = float(input("Enter Δuv value: ").replace(',', '.'))
    CCT_D_uv = [CCT, uv]

    u, v = colour.temperature.CCT_to_uv_Ohno2013(CCT_D_uv, cmfs=cmfs)
    xy = colour.UCS_uv_to_xy(np.array([u, v]))
    print(f"xy Coordinates: {xy}")

if __name__ == "__main__":
    main()