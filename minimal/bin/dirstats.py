#! /usr/bin/env python2
from collections import defaultdict
import os
import os.path

def get_dirstats(root):
	dstats, fstats = [], []
	for root, dirs, files in os.walk(root):
		dsize = 0
		these_fstats = []
		for f in files:
			fn = os.path.join(root, f)
			fsize = os.path.getsize(fn)
			if fsize:
				these_fstats += [ (fn, fsize) ]
				dsize += fsize
		fstats.extend(these_fstats)
		dstats += [ (root, len(dirs), len(these_fstats), dsize) ]
	return dstats, fstats
#

import sys
exit, args = sys.exit, sys.argv[1:]

unique_args = {os.path.abspath(a): a for a in args}

dstats, fstats = [], []
for arg in unique_args.values():
	d, f =  get_dirstats(arg)
	dstats.extend(d)
	fstats.extend(f)
print
print 'Directories with the largest number of immediate subdirs:'
dstats.sort(key=lambda (dn, nd, nf, fs): nd, reverse=True)
for d in dstats[:5]: print d
print
print 'Directories with the largest immediate file size:'
dstats.sort(key=lambda (dn, nd, nf, fs): fs, reverse=True)
for d in dstats[:5]: print d
print
print 'Largest files:'
fstats.sort(key=lambda (fn, fs): fs, reverse=True)
for f in fstats[:5]: print f

fbs = defaultdict(list)
for fn, fs in fstats:
	fbs[fs] += [fn]
fbs = [ (size, files) for (size, files) in fbs.iteritems() if len(files) > 1 ]
if fbs:
	td = len(fbs)
	print
	print 'Possible duplicates:'
	fbs.sort(key=lambda (size, files): size, reverse=True)
	fbs = [ (size, files) for (size, files) in fbs if size > 1E6 ]
	fd = len(fbs)
	for (size, files) in fbs:
		exts = []
		for f in files:
			_, ext = os.path.splitext(f)
			exts.append(ext)
		exts = set(ext.upper() for ext in exts)
		if len(exts) == 1:
			for (size, files) in fbs:
				for f in files: print size, f
	if fd != td: print td-fd, 'sets skipped'
