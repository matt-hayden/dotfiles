#! /usr/bin/gawk -f

BEGIN {
	# configurable:
	group_by=1; # Your group-by column number, starting with one
	FS=OFS=","; # Set input and output separators here
	num_header_rows=2;
	logfile="/dev/stderr";

	if (output_dir == "") output_dir=".";

	# These are all globals
	split("", files); # initialize to empty
	layer=FS; # a variable wouldn't take this value in data
	outfile="";

	print "# Started " strftime("%x %X") > logfile;

	# Crude filtering: set any keys to have value empty string in order to
	# skip file creation. These lines will hit stdout.
	#files["__NULL__"] = "" # see the substitution below
	if (length(files)) print "# Filtered lines will appear here";
}


# Transformation function on column values. This is called on every row.
function grouping(text) {
	if (!length(text)) return "__NULL__"; # insert your favorite substitution
	t = text;
	#gsub(/\s/, "_", t); # this line equates spaces with underscore
	return toupper(t); # toupper() makes this case-insensitive
}

# Sections begin and end when these functions are called.

# mode 1: seperate rows into their own files
# Filenames are determined by this function. This is cached into array `files`
# and called on every transition.
function begin_section(label) {
	filename = output_dir "/" label ".csv";
	if (label in files) outfile=files[label];
	else {
		outfile=files[label] = filename;
		for (i in headers) print headers[i] > filename;
	}
}

function end_section(label) {
}

# mode 2: mark each transition with some text
function begin_section2(label) {
	print "----- BEGIN " label " -----";
}

function end_section2(label) {
	print "----- END " label " -----";
	print "";
}


(NR <= num_header_rows) {
	if ($0) headers[NR] = $0;
	next;
}

{
	tl = grouping($group_by);
	if (layer != tl) {
		if (layer != FS) end_section(layer); # first row
		begin_section(layer=tl);
	}
	freq[layer]++;
	if (length(outfile)) print > outfile;
	else print;
}

END {
	if (layer != FS) end_section(layer); # no first row encountered

	# Summary:
	print "\nFiles:" > logfile;
	for (l in files) printf "%-20s -> %20s\n", l, files[l] > logfile;
	if (length(headers)) {
		print "\nHeaders:" > logfile;
		for (i in headers) print i ": " headers[i] > logfile;
	}
	print "\nFrequencies:" > logfile;
	for (v in freq) {
		f = freq[v];
		print v, f > logfile;
		t += f;
	}
	print "=total=", t > logfile;
	print "\n# Finished " strftime("%x %X") > logfile;
}
