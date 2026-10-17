#include <stdio.h>
#include <stdlib.h>

#define DB_VERSION "300"

void WriteVersion()
{
#ifndef __WIN32__
	FILE* fp = fopen("VERSION.txt", "w");
	if (!fp)
	{
		fprintf(stderr, "cannot open VERSION.txt\n");
		return;
	}

	fprintf(fp, "db server version: %s\n", DB_VERSION);
	fprintf(fp, "build: static\n");

	fclose(fp);
#endif
}
