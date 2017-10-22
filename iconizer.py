# Iconizer Python script by Stefan Herold

# Simple tool to generate all necessary icon sizes for an iOS app from one 
# pdf vector file.
#
# IMPORTANT: This file is work in progress and not yet complete!
#
from __future__ import print_function # import Python 3 print function
from . import _PythonMagick
import json
import os.path
import sys

assert len(sys.argv) == 3, 'Usage: python sys.argv[0] <vector>.pdf <asset_path>'
assert os.path.isfile(sys.argv[1]), 'Did not find file %s, expected path to a vector image file.' % sys.argv[1]
assert os.path.isdir(sys.argv[2]), 'Did not find path to asset directory %s' % sys.argv[2]

vectorImage = sys.argv[1]
assetDir = sys.argv[2]
contentsFile = 'Contents.json'
contentsPath = os.path.join(assetDir, contentsFile)

with open(contentsPath, 'r') as jsonFile:
  jsonData = json.load(jsonFile)

for idx, image in enumerate(jsonData['images']):
  scale = image['scale'].split('x')[0]
  sizePT = image['size'].split('x')[0]
  sizePX = float(sizePT) * float(scale)
  imageName = "appicon_" + str(sizePX) + ".png"

  jsonData['images'][idx]['filename'] = imageName

  with open(contentsPath, 'w+') as jsonFile:
    jsonFile.write(json.dumps(jsonData, sort_keys=True, indent=4, separators=(',', ': ')))

  if os.path.isfile(os.path.join(assetDir, imageName)):
    print('File %s already created... Continue' % imageName)
  else:
    print('Creating %s and update %s...' % (imageName, contentsFile), end='')
    print(' %s' % u'\u2705')
