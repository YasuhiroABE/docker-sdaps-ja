
README - sdaps-ja
-----------------

This project contains the Dockerfile which runs the modified sdaps version based on the ubuntu-20.04 package.

With this docker image, you can easily try out the sdaps command with the Japanese questionnaire.

## How to run the docker image

Please refer the GNUmakefile file which contains some tasks.
You can easily learn its usage.

First, please mount the working directory at /proj in the container.
The questionnaire tex file and project directory will be placed at the /proj directory.

Detailed instructions (in Japanese) on how to do this can be found on the following web page,

* https://qiita.com/YasuhiroABE/items/005da98fc6dc9b3070f2

## Copyright

The "files" directory contains the modified sdaps source code these files are distributed under the original copyright.

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

### Diffs of source code

```
--- /usr/lib/python3/dist-packages/sdaps/defs.py.20200925	2018-11-06 05:23:27.000000000 +0900
+++ /usr/lib/python3/dist-packages/sdaps/defs.py	2020-09-25 10:53:18.604513503 +0900
@@ -194,7 +194,7 @@
 
 # External commands =======================================
 #: The binary used to compile latex documents.
-latex_engine = "pdflatex"
+latex_engine = "xelatex"
 
 #: A function that is called after fork and before exec of the latex engine.
 #: This is useful when e.g. the LateX environment should be secured.
--- /usr/lib/python3/dist-packages/sdaps/template.py.20200925	2018-11-03 20:13:21.000000000 +0900
+++ /usr/lib/python3/dist-packages/sdaps/template.py	2020-09-25 10:53:18.604513503 +0900
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
--- /usr/lib/python3/dist-packages/sdaps/report/answers.py.20200925	2018-11-03 20:13:21.000000000 +0900
+++ /usr/lib/python3/dist-packages/sdaps/report/answers.py	2020-09-25 10:53:18.608517502 +0900
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
--- /usr/lib/python3/dist-packages/sdaps/report/buddies.py.20200925	2018-11-21 06:26:40.000000000 +0900
+++ /usr/lib/python3/dist-packages/sdaps/report/buddies.py	2020-09-25 10:53:18.612521500 +0900
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
 
 
--- /usr/lib/python3/dist-packages/sdaps/reporttex/__init__.py.20200925	2019-01-26 21:54:01.000000000 +0900
+++ /usr/lib/python3/dist-packages/sdaps/reporttex/__init__.py	2020-09-25 10:53:18.616525499 +0900
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
--- /usr/share/sdaps/tex/sdapsreport.cls.20200925	2018-11-03 20:13:21.000000000 +0900
+++ /usr/share/sdaps/tex/sdapsreport.cls	2020-09-25 10:53:18.616525499 +0900
@@ -38,7 +38,7 @@
 %-------------------------------------------------------------------------------
 % load base-class
 %-------------------------------------------------------------------------------
-\LoadClass[twoside,headings=small]{scrreprt}
+\LoadClass[oneside,headings=small]{scrreprt}
 
 
 %-------------------------------------------------------------------------------
--- /usr/lib/python3/dist-packages/sdaps/utils/latex.py.20200925	2019-01-26 21:51:48.000000000 +0900
+++ /usr/lib/python3/dist-packages/sdaps/utils/latex.py	2020-09-25 10:53:18.620529498 +0900
@@ -64,7 +64,7 @@
     # needed anyway.
     # However, it could also mean that the mapping needs to be updated.
     try:
-        string.encode('ascii')
+        string.encode('utf-8')
     except UnicodeEncodeError:
         log.warn(_("Generated string for LaTeX contains unicode characters. This may not work correctly and could mean the LaTeX character map needs to be updated."))
     return string
```

