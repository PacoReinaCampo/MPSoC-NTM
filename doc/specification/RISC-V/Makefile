###################################################################################
##                                            __ _      _     _                  ##
##                                           / _(_)    | |   | |                 ##
##                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |                 ##
##               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |                 ##
##              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |                 ##
##               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|                 ##
##                  | |                                                          ##
##                  |_|                                                          ##
##                                                                               ##
##                                                                               ##
##              Template                                                         ##
##              QueenField                                                       ##
##                                                                               ##
###################################################################################

###################################################################################
##                                                                               ##
## Copyright (c) 2022-2023 by the author(s)                                      ##
##                                                                               ##
## Permission is hereby granted, free of charge, to any person obtaining a copy  ##
## of this software and associated documentation files (the "Software"), to deal ##
## in the Software without restriction, including without limitation the rights  ##
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell     ##
## copies of the Software, and to permit persons to whom the Software is         ##
## furnished to do so, subject to the following conditions:                      ##
##                                                                               ##
## The above copyright notice and this permission notice shall be included in    ##
## all copies or substantial portions of the Software.                           ##
##                                                                               ##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    ##
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,      ##
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   ##
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        ##
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, ##
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN     ##
## THE SOFTWARE.                                                                 ##
##                                                                               ##
## ============================================================================= ##
## Author(s):                                                                    ##
##   Paco Reina Campo <pacoreinacampo@queenfield.tech>                           ##
##                                                                               ##
###################################################################################

SOURCE_QHW_DOCS := $(wildcard *-special-hardware.md)
SOURCE_QHW_DOCS := $(filter-out metadata.md, $(SOURCE_QHW_DOCS))

SOURCE_THW_DOCS := $(wildcard *-general-hardware.md)
SOURCE_THW_DOCS := $(filter-out metadata.md, $(SOURCE_THW_DOCS))

SOURCE_QSW_DOCS := $(wildcard *-special-software.md)
SOURCE_QSW_DOCS := $(filter-out metadata.md, $(SOURCE_QSW_DOCS))

SOURCE_TSW_DOCS := $(wildcard *-general-software.md)
SOURCE_TSW_DOCS := $(filter-out metadata.md, $(SOURCE_TSW_DOCS))

EXPORTED_QHW_DOCS=\
 $(SOURCE_QHW_DOCS:.md=.pdf)  \
 $(SOURCE_QHW_DOCS:.md=.docx)

EXPORTED_QSW_DOCS=\
 $(SOURCE_QSW_DOCS:.md=.pdf)  \
 $(SOURCE_QSW_DOCS:.md=.docx)

EXPORTED_THW_DOCS=\
 $(SOURCE_THW_DOCS:.md=.pdf)  \
 $(SOURCE_THW_DOCS:.md=.docx)

EXPORTED_TSW_DOCS=\
 $(SOURCE_TSW_DOCS:.md=.pdf)  \
 $(SOURCE_TSW_DOCS:.md=.docx)

PANDOC_OPTIONS=-f markdown       \
    --table-of-contents          \
    --toc-depth=6                \
    --number-sections            \
    --pdf-engine=xelatex         \
    -V lof=yes                   \
    -V lot=yes                   \
    -V fontsize="10pt"           \
    -V documentclass=report      \
    -V papersize=A4              \
    -V linestretch='1'           \
    -V geometry:margin=2cm       \
    -V links-as-notes=true       \
    --highlight-style=tango      \
    --metadata-file=metadata.md

PANDOC_PDF_OPTIONS=
PANDOC_DOCX_OPTIONS=

# Pattern-Matching Rules

%.pdf : %.md
	pandoc -s $(shell cat $<) $(PANDOC_OPTIONS) $(PANDOC_PDF_OPTIONS) -o $@

%.docx : %.md
	pandoc -s $(shell cat $<) $(PANDOC_OPTIONS) $(PANDOC_DOCX_OPTIONS) -o $@

all : $(EXPORTED_QHW_DOCS) $(EXPORTED_QSW_DOCS) $(EXPORTED_THW_DOCS) $(EXPORTED_TSW_DOCS)

merge:
	pdftk cover.pdf book-special-hardware.pdf cat output thesis-special-hardware.pdf
	pdftk cover.pdf book-special-software.pdf cat output thesis-special-software.pdf
	pdftk cover.pdf book-general-hardware.pdf cat output thesis-general-hardware.pdf
	pdftk cover.pdf book-general-software.pdf cat output thesis-general-software.pdf

clean:
	-rm -f $(EXPORTED_QHW_DOCS) $(EXPORTED_QSW_DOCS) $(EXPORTED_THW_DOCS) $(EXPORTED_TSW_DOCS) thesis-*

.PHONY: clean
