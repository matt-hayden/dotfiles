#! /usr/bin/env python3
'''
Form a Google Cloud-style TSV for file transfers
'''
import hashlib
import logging
import os, os.path
#import sys
import urllib.parse

import tqdm


debug, info, warning, error, panic = logging.debug, logging.info, logging.warning, logging.error, logging.critical


def get_checksum(p, factory=hashlib.md5, progress=None, cache_size=2*1024*2048):
	s = factory()
	if progress:
		def update(c):
			s.update(c)
			progress(len(c))
	else:
		update = s.update
	with open(p, 'rb') as fi:
		c = fi.read(cache_size)
		while len(c):
			update(c)
			c = fi.read(cache_size)
	return s.hexdigest()

def parse_url(arg):
	u = urllib.parse.urlparse(arg, scheme='http')
	if u.scheme.endswith('tp'):
		if ':' in u.netloc:
			server, port = u.netloc.rsplit(':', 1)
		else:
			server, port = u.netloc, ''
	_, fn = os.path.split(u.path)
	return fn, u

def make_checksums(urls, **kwargs):
	urls = dict(parse_url(u) for u in urls)
	q, found = dict(urls), []
	for root, dirs, filenames in os.walk('.'):
		dirs = [ d for d in dirs if not d.startswith('.') ]
		filenames = [ f for f in filenames if not f.startswith('.') ]
		for f in filenames:
			if f in q:
				p = os.path.join(root, f)
				stat = os.stat(p)
				found.append( (q.pop(f).geturl(), p, stat.st_size) )
	files_not_found = q
	for fn in files_not_found:
		error("{} not found".format(fn))
	if found:
		total_size = sum(s for u, p, s in found)
		if 'progress_bar_factory' in kwargs:
			bar = kwargs.pop('progress_bar_factory')(total=sum(s for u, p, s in found))
		else:
			bar = None
		for u, p, s in found:
			yield u, s, get_checksum(p, progress=bar.update)

###
import sys

import tqdm

def progress_bar(**kwargs):
	return tqdm.tqdm(unit='B', unit_scale=True, disable=not sys.stderr.isatty(), **kwargs)

if sys.stdin.isatty():
	warning("Taking URLs from stdin...")
with sys.stdin as fi:
	urls = [ line.rstrip() for line in fi if line.strip() ]
if urls:
	print('TsvHttpTransfer-1.0')
	for row in make_checksums(urls, progress_bar_factory=progress_bar):
		print('{}\t{}\t{}'.format(*row))
