#! /usr/bin/gawk -f
### http://unix.stackexchange.com/questions/44040/a-standard-tool-to-convert-a-byte-count-into-human-kib-mib-etc-like-du-ls1

#
# du -h sizes, units of 1024
# 
function human_2(x) {
	s="   B KiB MiB GiB TiB EiB PiB YiB ZiB"
	while (x>=1024 && length(s)>1) 
		{ x/=1024; s=substr(s,5) }
	s=substr(s,1,4)
	xf=(s=="   B")?"%4d  ":"%6.1f"
	return sprintf( xf"%s", x, s)
}

#
# du --si sizes, units of 1000
#
function human_si(x) {
	s="   B KB MB GB TB EB PB YB ZB"
	while (x>=1000 && length(s)>1) 
		{ x/=1000; s=substr(s,4) }
	s=substr(s,1,3)
	xf=(s=="   B")?"%4d  ":"%6.1f"
	return sprintf( xf"%s", x, s)
}

{
	gsub(/^[0-9]+/, human_2($1))
	print
}
