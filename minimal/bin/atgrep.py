#! /usr/bin/env python2
from datetime import datetime
import subprocess
import sys

import at

if sys.platform.startswith('win'):
	GREP='GREP.EXE'
else:
	GREP='grep'

#def atgrep(*args, now=datetime.now(), jobs=at.jobs, quiet=False):
def atgrep(*args):
	now=datetime.now()
	jobs=at.jobs
	quiet=False
	label_format="{jid}\t{timestamp:<8} {queue:>2} {owner}"
	#output=io.StringIO()
	#
	r = []
	for job in jobs:
		jid, started, queue, owner = job
		if not quiet:
			try:
				timestamp, _ = str(now-started).rsplit('.', 1)
			except:
				timestamp = started
			label = label_format.format(**locals())
		else:
			label = str(jid)
		myargs = list(args)+['--label='+label, '-H']
		#with redirect_stdout(output) as out: ...
		grep_proc = subprocess.Popen([GREP]+myargs, stdin=subprocess.PIPE, stdout=subprocess.PIPE)
		contents = '\n'.join(job.get_script())
		out, _ = grep_proc.communicate(contents.encode('UTF-8'))
		if out:
			r.extend(out.decode('UTF-8').splitlines())
	return r
		
if __name__ == '__main__':
	import sys
	for line in atgrep(*sys.argv[1:]):
		print(line)
