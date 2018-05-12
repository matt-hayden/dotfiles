/* All headers, ever */

#include <glib.h>
#include <locale.h>
#define _GNU_SOURCE // asks stdio.h to provide asprintf
#include <stdio.h>
#include <stdlib.h> // free
#include <string.h>

// For stat
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

/* Ben Klemens' Sasprintf
 * Simple usage:
 * 	char * t = strdup("select");
 * 	Sasprintf(t, "* from tbl");
 * 	Sasprintf(t, "%s where col%d is not null", name, coln);
 */
#define Sasprintf(dest, ...) {		\
	char *tmp = (dest);		\
	asprintf(&(dest), __VA_ARGS__);	\
	free(tmp);			\
}

char
*read_file(char const *filename) {
	char *r;
	GError *e = NULL;
	GIOChannel *f = g_io_channel_new_file(filename, "r", &e);
	if (!f) {
		perror("Unable to open file");
		return NULL;
	}
	if (g_io_channel_read_to_end(f, &r, NULL, &e) != G_IO_STATUS_NORMAL) {
		perror("Unable to read file");
		return NULL;
	}
	return r;
}

off_t
get_size(char const *filename) {
	struct stat buf;
	stat(filename, &buf);
	off_t size = buf.st_size;
	return size;
}

char
*localstring_to_utf8(char * bytes) { // argument is modified, and free'd after
	GError *e = NULL;
	setlocale(LC_ALL, "");
	char *r = g_locale_to_utf8(bytes, -1, NULL, NULL, &e);
	if (e) {
		perror("Locale to UTF8 fail");
		return NULL;
	}
	free(bytes);
	if (!g_utf8_validate(r, -1, NULL)) {
		perror("UTF8 fail");
		free(r);
		return NULL;
	}
	return r;
}
