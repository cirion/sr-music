import os
import contextlib

#
# Usage: python concat.py
# Working directory must contain songs.txt, which must contain a list of paths to .ogg files
# On completion, the working directory will contain the following files.
# resources.assets.resS: Concatenation of all ogg files. Can be dropped into SRHK Contents/Data/resources.assets.resS
#   or placed into SuperShadowrun as the conversion file.
# indices.txt: Index into the new resources.assets.resS for each track. Can be placed into newPositionValues.
# lengths.txt: Size of each track. Can be placed into newSizeValues.
# mapping.txt: Describes what new track will be played for each original track. Very useful for work within the editor.

def remove(filename):
    try:
        os.remove(filename)
    except OSError:
        pass

FILE_ASSETS ="resources.assets.resS"
FILE_INDICES = "indices.txt"
FILE_LENGTHS = "lengths.txt"
FILE_MAPPING = "mapping.txt"
FILE_SONGS = "songs.txt"

ORIGINAL_NAMES=[
        "Hub-TeaHouse", 
        "Hub-Exterior", 
        "Combat-Generic-Int2", 
        "Legwork-SLinterior", 
        "TitleTheme-UI", 
        "Combat-Matrix2", 
        "Combat-Kowloon-Int2", 
        "Combat-Gobbet-Int1", 
        "Combat-Kowloon-WrapUp", 
        "Hub-SafeHouse", 
        "Combat-Is0bel-Int2", 
        "Legwork-Generic", 
        "Combat-Kowloon-Int1", 
        "Combat-Gobbet-WrapUp", 
        "Legwork-Is0bel", 
        "Legwork-Erhu", 
        "Legwork-Grendel", 
        "Legwork-ExitStageLeft", 
        "TESTSTINGER", 
        "Hub-Club88-ThroughWalls", 
        "Legwork-News", 
        "Combat-Boss", 
        "loudmusic", 
        "Legwork-Whistleblower", 
        "Combat-Is0bel-Int1", 
        "Combat-Generic-WrapUp", 
        "Combat-Generic-Int1", 
        "Hub-Club88-InStreet", 
        "Legwork-Kowloon", 
        "Combat-stinger-end", 
        "Combat-VictoriaHarbor-WrapUp", 
        "Combat-Grendel-Int1", 
        "Legwork-Museum", 
        "Sewer", 
        "Stealth-Matrix1", 
        "Legwork-Gobbet", 
        "Legwork-Hacking", 
        "Combat-Grendel-WrapUp", 
        "KnightKingsElevator", 
        "Legwork-VictoriaHarbor", 
        "Combat-Grendel-Int2", 
        "Combat-Is0bel-WrapUp", 
        "Combat-VictoriaHarbor-Int1", 
        "Combat-stinger-start", 
        "Combat-Gobbet-Int2",
        "Club88-MainRoom",
        "Combat-VictoriaHarbor-Int2"
        ]

remove(FILE_ASSETS)
remove(FILE_LENGTHS)
remove(FILE_INDICES)
remove(FILE_MAPPING)

totalSize = 0
index = 0
with open(FILE_LENGTHS, "a") as lengths, open(FILE_INDICES, "a") as indices, open (FILE_SONGS) as fp, open(FILE_ASSETS, "ab") as assets, open (FILE_MAPPING, "a") as mapping:
    for line in fp:
        line = line.strip()
        size = os.path.getsize(line)
        lengths.write(str(size) + ",\n")
        indices.write(str(totalSize) + ",\n")
        mapping.write(ORIGINAL_NAMES[index].ljust(25) + " -> " + line + "\n")
        index += 1
        totalSize += size
        with open(line, "rb") as music:
            assets.write(music.read())
