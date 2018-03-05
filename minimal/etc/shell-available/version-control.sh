#! /usr/bin/env head
[ "$CVSIGNORE" ] || CVSIGNORE='*.bak *.o *.out *.pyc *.pyo *.swo *.swp *.tmp ~$* *~[1-9]~ __pycache__ .bzr .git'

FIGNORE='.bak:.o:.out:.pyc:.pyo:.swo:.swp:.tmp:~:__pycache__'
[ "$VERSION_CONTROL" ] || VERSION_CONTROL=numbered

export CVSIGNORE FIGNORE VERSION_CONTROL
