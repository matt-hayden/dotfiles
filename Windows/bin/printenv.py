#! /usr/bin/env python2
"""
Emulate BSD printenv, except that variables with escaped characters are quoted.
"""
from collections import defaultdict
import os
import pipes

categories = { '+common': 'ENV HOME OSTYPE LANG LOGNAME PATH SHELL TERM TMP TMPDIR USER'.split(),
			   'common': '_ DISPLAY PWD STY SHLVL TERMCAP'.split(),
			   '+bash2': 'HISTCONTROL HISTFILE HISTIGNORE INPUTRC'.split(),
			   'bash2': 'OLDPWD'.split(),
			   '+RevisionControl': 'BZR_SSH CVS_RSH GIT_SSH SVN_SSH'.split(),
			   'Windows': 'ALLUSERSPROFILE APPDATA COMMONPROGRAMFILES(X86) COMMONPROGRAMFILES'
						  'COMMONPROGRAMW6432 COMPUTERNAME COMSPEC HOMEDRIVE HOMEPATH LOCALAPPDATA'
						  'LOGNAME LOGONSERVER NUMBER_OF_PROCESSORS OS PATHEXT PROCESSOR_ARCHITECTURE'
						  'PROCESSOR_IDENTIFIER PROCESSOR_LEVEL PROCESSOR_REVISION PROGRAMDATA'
						  'PROGRAMFILES(X86) PROGRAMFILES PROGRAMW6432 PSMODULEPATH PUBLIC SYSTEMDRIVE'
						  'SYSTEMROOT USERNAME USERDOMAIN USERDOMAIN_ROA USERPROFILE VS110COMNTOOLS WINDIR'.split(),
			   'Darwin': 'COMMAND_MODE TERM_PROGRAM'.split(),
			   'ssh': 'SSH_AUTH_SOCKET'.split()
			 }
# invert categories
lookup = defaultdict(list)
for cn, vl in categories.items():
	for vn in vl: lookup[vn] = cn
def get_category(key, lookup=lookup, subcategory='.'):
	default = '+'+key
	category = lookup.get(key, default)
	return '{}{}{}'.format(category, subcategory, key) if subcategory else category

def printenv(arg=None, quoter=pipes.quote):
	# emulate printenv, which takes only one arg
	if arg:
		value = os.environ.get(arg, None)
		if value:
			print quoter(value)
		else:
			return False
	else:
		for k, v in sorted(os.environ.iteritems(), key=lambda (k,v): get_category(k)):
			print k+"="+quoter(v)
	return True
if __name__ == '__main__':
	import sys
	sys.exit(not printenv(sys.argv[1]))
