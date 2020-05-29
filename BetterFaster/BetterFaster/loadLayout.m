function [walls, antennas,reflection, border] = loadLayout(fileName)
load(fileName, "walls", "antennas","reflection","border");