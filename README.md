
README - sdaps-ja
-----------------

This project contains a Dockerfile that runs a modified version of the PPA SDAPS package based on Ubuntu 22.04.

This Docker image allows you to easily use the SDAPS command with a Japanese questionnaire.

## How to Run the Docker Image

For real tasks examples, refer to the Makefile.

### Overview

* Mount a working directory at ``/proj`` in the container.
* Place your questionnaire TeX file in the working directory.
* Detailed instructions in Japanese are available in [my Qiita article](https://qiita.com/YasuhiroABE/items/005da98fc6dc9b3070f2).

### Generate Questionnaire PDF

If you need root privileges to run the Docker commands, please replace the ``docker`` with ``sudo docker``.

```bash
    $ docker pull yasuhiroabe/sdaps-ja:latest
    $ docker tag yasuhiroabe/sdaps-ja:latest sdaps-ja:latest
    $ mkdir proj
    $ wget -O proj/example.tex https://gist.githubusercontent.com/YasuhiroABE/db17793accd37b5bbe787597bd503190/raw/sdaps-example-ja.tex
    $ docker run --rm -v `pwd`/proj:/proj sdaps-ja:latest setup tex work/ example.tex

```

Print out the "proj/work/questionnaire.pdf" file, fill it in, and scan it.

### Process the Scanned File

Place the scanned TIFF file as ``proj/01.tiff``.

```bash
    $ docker run --rm -v `pwd`/proj:/proj sdaps-ja:latest add work/ 01.tiff
    $ docker run --rm -v `pwd`/proj:/proj sdaps-ja:latest recognize work/
    $ docker run --rm -v `pwd`/proj:/proj sdaps-ja:latest report tex work/        ## report_1.pdf
    $ docker run --rm -v `pwd`/proj:/proj sdaps-ja:latest report reportlab work/  ## report_2.pdf
    $ docker run --rm -v `pwd`/proj:/proj sdaps-ja:latest export csv work/        ## data_1.csv
```

Finally, you will obtain ``proj/work/report_1.pdf``, ``proj/work/report_2.pdf``, and ``proj/work/data_1.csv``.

## Copyright

The "files" directory contains the modified source code, these files are distributed under the original copyright.

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
* The other files created by YasuhiroABE are distributed under the GPL v3 or any later versions as well as the original sdaps code.

### Patch

The following shows the diff output of source code.

```
--- /usr/lib/python3/dist-packages/sdaps/defs.py.20231003	2023-10-03 15:31:19.832496753 +0900
+++ /usr/lib/python3/dist-packages/sdaps/defs.py	2023-10-03 16:47:58.047769679 +0900
@@ -197,7 +197,7 @@
 
 # External commands =======================================
 #: The binary used to compile latex documents.
-latex_engine = "pdflatex"
+latex_engine = "xelatex"
 
 #: A function that is called after fork and before exec of the latex engine.
 #: This is useful when e.g. the LateX environment should be secured.
--- /usr/lib/python3/dist-packages/sdaps/template.py.20231003	2023-07-23 21:35:38.000000000 +0900
+++ /usr/lib/python3/dist-packages/sdaps/template.py	2023-10-03 16:47:58.059769628 +0900
@@ -25,6 +25,8 @@
 """
 
 from reportlab import platypus
+from reportlab.pdfbase import pdfmetrics
+from reportlab.pdfbase.cidfonts import UnicodeCIDFont
 from reportlab.lib import styles
 from reportlab.lib import units
 from reportlab.lib import pagesizes
@@ -32,6 +34,8 @@
 mm = units.mm
 PADDING = 15 * mm
 
+pdfmetrics.registerFont(UnicodeCIDFont("HeiseiKakuGo-W5"))
+
 class DocTemplate(platypus.BaseDocTemplate):
 
     def __init__(self, filename, title, metainfo={}, papersize=pagesizes.A4):
@@ -78,7 +82,7 @@
 
     def beforeDrawPage(self, canvas, document):
         canvas.saveState()
-        canvas.setFont('Times-Bold', 24)
+        canvas.setFont('HeiseiKakuGo-W5', 24)
         canvas.drawCentredString(
             document.width / 2.0,
             document.height - 50 * mm,
@@ -118,7 +122,7 @@
 
 stylesheet['Normal'] = styles.ParagraphStyle(
     'Normal',
-    fontName='Times-Roman',
+    fontName='HeiseiKakuGo-W5',
     fontSize=10,
     leading=14,
 )
--- /usr/lib/python3/dist-packages/sdaps/report/answers.py.20231003	2023-07-23 21:35:38.000000000 +0900
+++ /usr/lib/python3/dist-packages/sdaps/report/answers.py	2023-10-03 16:47:58.071769578 +0900
@@ -21,6 +21,8 @@
 
 from reportlab import pdfgen
 from reportlab import platypus
+from reportlab.pdfbase import pdfmetrics
+from reportlab.pdfbase.cidfonts import UnicodeCIDFont
 from reportlab.lib import styles
 from reportlab.lib import units
 from reportlab.lib import pagesizes
@@ -46,18 +48,21 @@
     'Right',
     parent=stylesheet['Normal'],
     alignment=enums.TA_RIGHT,
+    fontName='HeiseiKakuGo-W5',
 )
 
 stylesheet['Right_Highlight'] = styles.ParagraphStyle(
     'Right_Highlight',
     parent=stylesheet['Right'],
-    textColor=colors.Color(255, 0, 0)
+    textColor=colors.Color(255, 0, 0),
+    fontName='HeiseiKakuGo-W5',
 )
 
 stylesheet['Normal_Highlight'] = styles.ParagraphStyle(
     'Normal_Highlight',
     parent=stylesheet['Normal'],
-    textColor=colors.Color(255, 0, 0)
+    textColor=colors.Color(255, 0, 0),
+    fontName='HeiseiKakuGo-W5'
 )
 
 
@@ -205,7 +210,7 @@
     def draw(self):
         if 0:
             assert isinstance(self.canv, pdfgen.canvas.Canvas)
-        self.canv.setFont("Times-Roman", 10)
+        self.canv.setFont("HeiseiKakuGo-W5", 10)
         # mean
         mean = flowables.Box(self.mean_width, self.mean_height, self.box_depth)
         mean.transparent = 0
--- /usr/lib/python3/dist-packages/sdaps/report/buddies.py.20231003	2023-07-23 21:35:38.000000000 +0900
+++ /usr/lib/python3/dist-packages/sdaps/report/buddies.py	2023-10-03 16:47:58.083769529 +0900
@@ -19,6 +19,8 @@
 import math
 
 from reportlab import platypus
+from reportlab.pdfbase import pdfmetrics
+from reportlab.pdfbase.cidfonts import UnicodeCIDFont
 from reportlab.lib import styles
 from reportlab.lib import colors
 from reportlab.lib import units
@@ -47,13 +49,14 @@
     leading=17,
     backColor=colors.lightgrey,
     spaceBefore=5 * mm,
+    fontName='HeiseiKakuGo-W5',
 )
 
 stylesheet['Question'] = styles.ParagraphStyle(
     'Question',
     stylesheet['Normal'],
     spaceBefore=3 * mm,
-    fontName='Times-Bold',
+    fontName='HeiseiKakuGo-W5',
 )
 
 stylesheet['Text'] = styles.ParagraphStyle(
@@ -64,6 +67,7 @@
     rightIndent=5 * mm,
     bulletIndent=2 * mm,
     leftIndent=5 * mm,
+    fontName='HeiseiKakuGo-W5',
 )
 
 
--- /usr/lib/python3/dist-packages/sdaps/reporttex/__init__.py.20231003	2023-07-23 21:35:38.000000000 +0900
+++ /usr/lib/python3/dist-packages/sdaps/reporttex/__init__.py	2023-10-03 16:47:58.091769494 +0900
@@ -124,6 +124,12 @@
     \fi
     \usepackage[%(language)s]{babel}
 
+    \usepackage{xltxtra}
+    \setmainfont{IPAPMincho}
+    \setsansfont{IPAPGothic}
+    \setmonofont{IPAGothic}
+    \XeTeXlinebreaklocale "ja"
+
     \title{%(title)s}
     \subject{%(title)s}
     \author{%(author)s}
--- /usr/lib/python3/dist-packages/sdaps/utils/latex.py.20231003	2023-07-23 21:35:38.000000000 +0900
+++ /usr/lib/python3/dist-packages/sdaps/utils/latex.py	2023-10-03 16:47:58.103769444 +0900
@@ -68,7 +68,7 @@
     # needed anyway.
     # However, it could also mean that the mapping needs to be updated.
     try:
-        string.encode('ascii')
+        string.encode('utf-8')
     except UnicodeEncodeError:
         global warned_mapping
         if not warned_mapping:

```
