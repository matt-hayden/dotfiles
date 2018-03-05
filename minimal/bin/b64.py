#! /usr/bin/env python3
"""
Extract base64 parts of a text file
"""

import argparse
import logging
import os, os.path
import subprocess
import sys

import base64_reader # custom


logger = logging.getLogger(__name__)
debug, info, warning, error, fatal = logger.debug, logger.info, logger.warning, logger.error, logger.critical


def export_files(lines, folder=None, text_format=None):
    files_out = {}
    bins, ntext = base64_reader.split(lines)
    for b in bins:
        fn = b.sha256()
        if folder:
            fn = os.path.join(folder, fn)
        b.save(fn)
        files_out[repr(b)] = fn
    for _, member in ntext:
        if (member in files_out):
            if '.md' == text_format:
                #label = member.begin.label
                print("![payload]({})".format(files_out[member]))
            else:
                print(member)
        else:
            print(member)
    return files_out
def apply_command(lines, command=None, number_lines=False, flush=sys.stdout.flush):
    bins, ntext = base64_reader.split(lines)
    if number_lines:
        spaces = len(str(len(ntext)))
        for lineno, text in ntext:
            print("{:{}d}".format(lineno, spaces), text)
    else:
        for _, text in ntext:
            print(text)
    #flush()
    if bins:
        print()
        info("{} valid {}".format(len(bins), "binary" if len(bins) == 1 else "binaries") )
        if command:
            for b in bins:
                print()
                print(repr(b))
                debug("Running '{}'".format(' '.join(command)))
                flush()
                p = subprocess.Popen(command, stdin=subprocess.PIPE)
                p.communicate(b.decode())


def get_argparser(*args, **kwargs):
    ap = argparse.ArgumentParser(description='Extract base64 parts of a text file')
    newarg = ap.add_mutually_exclusive_group().add_argument
    newarg('--command',     '-e', metavar='(command)', help='run this command on each base-64 encoded section')
    newarg('--save',        '-s', help='save all valid binaries into a folder', \
            dest='mode', action='store_const', const='save')
    newarg = ap.add_mutually_exclusive_group().add_argument
    newarg('--quiet',       '-q', action='store_const', dest='logging_level', const=logging.ERROR)
    newarg('--verbose',     '-v', action='store_const', dest='logging_level', const=logging.INFO)
    newarg = ap.add_argument_group('general options').add_argument
    newarg('--folder',      '-d', metavar='(folder)', help='output folder')
    newarg('--number',      '-n', help='number lines', action='store_true')
    newarg('--text-out',    '-t', help='.md for markdown')
    newarg('files', nargs='*', type=argparse.FileType('r'), default=[sys.stdin],
           help='files to parse, or standard input. "-" can be used for standard input')
    return ap


if __name__ == '__main__':
    import shlex

    args = get_argparser().parse_args()
    logging_level = logging.DEBUG if __debug__ else args.logging_level
    if logging_level is not None:
        logging.basicConfig(level=logging_level)
    mode = args.mode or 'scan'
    if 'save' == args.mode:
        if args.folder and not os.path.exists(args.folder):
            os.makedirs(args.folder)
        for fi in args.files:
            if fi.closed: continue
            with fi:
                lines = [ line.rstrip() for line in fi ]
            print()
            files_out_by_bin = export_files(lines, args.folder or None, text_format=args.text_out)
            print("Created {:,} files:".format(len(files_out_by_bin)) )
            for _, fn in files_out_by_bin.items():
                print("\t{}".format(fn))
    elif 'scan' == mode:
        for fi in args.files:
            if fi.closed: continue
            with fi:
                lines = [ line.rstrip() for line in fi ]
            print()
            apply_command(lines, shlex.split(args.command) if args.command else None, number_lines=args.number)
