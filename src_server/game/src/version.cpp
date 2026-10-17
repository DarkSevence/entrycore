#include <stdio.h>
void WriteVersion()
{
#ifndef __WIN32__
	FILE* fp = fopen("version.txt", "w");

	if (fp)
	{
		fprintf(fp, "entrycore game server revision: v1.0\n");
		fclose(fp);
	}
#endif
}

