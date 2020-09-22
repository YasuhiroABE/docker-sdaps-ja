
README - sdaps-ja
-----------------

This project contains the Dockerfile which runs the modified sdaps version based on the ubuntu-20.04 package.

With this docker image, you can easily try out the sdaps command under the Japanese environment.

## Copyright

The "files" directory contains the modified sdaps source code these files are destribued under the original copyright.

The original SDAPS COPYING file describes as following:
```
This program is free software. Different licenses apply to different parts
of the program.

Most of the files are distributed under the conditions of the GPLv3 or any
later versions (see COPYING.GPLv3)

Files in the "tex" directory are distributed under the conditions of the
LPPLv1.3c or any later version.

All files should have a corresponding copyright header, if one is missing
please write the authors to clarify the license.
```

* files/sdapsreport.cls is distributed as the LPPL v1.3c or any later versions.
* files/*.py files are distributed as the GPL v3 or any later versions.

## How to run the docker image

Please refer the GNUmakefile file which contains some tasks.
You can easily learn its usage.

First, please mount the working directory at /proj in the container.
The questionnaire tex file and project directory will be placed at the /proj directory.

Detailed instructions (in Japanese) on how to do this can be found on the following web page,

* https://qiita.com/YasuhiroABE/items/005da98fc6dc9b3070f2

