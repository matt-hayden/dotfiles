#! /usr/bin/env python3
"""Base-85

Usage:
    base85 [options] [--] [FILE...]

Options:
    -d, --decode            Decode (instead of encode)
    -w COLS, --width=COLS   Wrap after COLS characters [default: 76]
"""

import base64
import sys
import textwrap


def b85encode(data, width=None, wrap=textwrap.wrap, end=None):
    if end is None:
        end = '\n' # Windows might have an opinion?
    text = base64.b85encode(data).decode()
    return end.join(wrap(text, width)) if width else text

def b85decode(text, **kwargs):
    return base64.b85decode(''.join(s for s in text.split() if s))


if __name__ == '__main__':
    from docopt import docopt

    options = docopt(__doc__, version='0')
    if options.pop('--decode'):
        input_files = options.pop('FILE') or [sys.stdin]
        write = sys.stdout.buffer.write
        for fi in input_files:
            text = open(fi).read() if isinstance(fi, str) else fi.read()
            write(b85decode(text))
    else: # encode
        input_files = options.pop('FILE') or [sys.stdin.buffer]
        width = int(options.pop('--width')) or None
        for fi in input_files:
            data = open(fi, 'rb').read() if isinstance(fi, str) else fi.read()
            assert isinstance(data, bytes)
            print(b85encode(data, width=width))
            print()
