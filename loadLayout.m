function [walls, antennas] = loadLayout(fileName)
load(fileName, "walls", "antennas");