#!/usr/bin/env python
# https://gist.github.com/graven/921334
# Ported to Python from http://www.vim.org/scripts/script.php?script_id=1349
from subprocess import check_output

try:
	reported_number_of_colors = int(check_output(['tput', 'colors']))
except:
	reported_number_of_colors = None
print "Number of colors allegedly available: %s" % reported_number_of_colors

print "Color indexes should be drawn in bold text of the same color."
print

colored = [0] + [0x5f + 40 * n for n in range(0, 5)]
colored_palette = [
	("%02x/%02x/%02x" % (r, g, b), (r+g+b)/3.)
	for r in colored
	for g in colored
	for b in colored
]

grayscale = [0x08 + 10 * n for n in range(0, 24)]
grayscale_palette = [
	("%02x/%02x/%02x" % (a, a, a), a)
	for a in grayscale 
]

foreground = "\033[38;5;%sm" 
bold_foreground = "\033[1;38;5;%sm"
background = "\033[48;5;%sm" 
bold_background = "\033[1;48;5;%sm"
#reset = "\033[0m"

reset = check_output(['tput', 'sgr0'])

for (i, (color, value)) in enumerate(sorted(colored_palette + grayscale_palette, key=lambda (c, v): v), 16):
	if 128 < value:
		index = (bold_foreground + "%4s" + reset) % (i, str(i) + ':')
		hex   = (foreground + "%s" + reset) % (i, color)
	else:
		index = (bold_background + "%4s" + reset) % (i, str(i) + ':')
		hex   = (background + "%s" + reset) % (i, color)
	newline = '\n' if i % 6 == 3 else ''
	print index, hex, newline, 
