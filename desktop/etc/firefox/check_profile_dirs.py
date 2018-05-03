#! /usr/bin/env python3

import configparser
import os
from pathlib import Path
import sys

PROFILES_INI = Path('~/.mozilla/firefox/profiles.ini').expanduser()
if not PROFILES_INI.exists():
    sys.exit(3)
PROFILES_DIR = PROFILES_INI.parent

cf = configparser.ConfigParser()
cf.read([str(PROFILES_INI)])
for key in cf:
    if key not in 'DEFAULT General'.split():
        pp = Path(cf[key]['Path'])
        if not (PROFILES_DIR / pp).exists():
            os.makedirs(str(pp))
