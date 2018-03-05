#! /usr/bin/env python2
### Find Equivalent Calendar -- fe_cal.py
### probably inaccurate for calendars before 1100

import calendar
from datetime import date
import itertools
import random
import subprocess
import sys

if sys.platform.startswith('win'):
	CAL='CAL.EXE'
else:
	CAL='cal'

class CalendarError(Exception):
	pass

def get_similar_month(year, month, years=range(1959, 2017+1)):
	if not isinstance(year, int): year = int(year)
	if not isinstance(month, int): month = int(month)
	actual = calendar.monthrange(year, month)
	if month == 2: months = [2]
	else: months = [1]+range(3,12+1)
	random.shuffle(years)
	random.shuffle(months)
	for (m, y) in itertools.product(months, years):
		if calendar.monthrange(y, m) == actual: return y, m
	else:
		raise CalendarError('No matching calendar found!')
#
def get_similar_year(year, **kwargs):
	y, m = get_similar_month(year, 2, **kwargs)
	assert m == 2
	return y
#
def main(*args):
	try:
		if len(args) == 0:
			today = date.today()
			y, m = get_similar_month(today.year, today.month)
			return subprocess.check_call([CAL, str(m), str(y)], shell=False)
		elif len(args) == 1:
			y = get_similar_year(args[0])
			return subprocess.check_call([CAL, str(y)], shell=False)
		elif len(args) == 2:
			y, m = get_similar_month(args[1], args[0])
			return subprocess.check_call([CAL, str(m), str(y)], shell=True)
	except:
		return subprocess.check_call([CAL]+args, shell=True)

if __name__ == '__main__':
	import sys
	sys.exit(main(*sys.argv[1:]))
