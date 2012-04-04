######################################################################
#
# Binaries and scripts we call
#

PYBIB = pyBib.py

######################################################################
#
# Directories

# Bib source files
SRC=src/

# Templates
TEMPLATES=templates/

# Temporary build files
TMP=tmp/

######################################################################
#
# Our targets
#

default: html

.PHONY: default
.PHONY: html
.PHONY: clean

$(TMP):
	mkdir $(TMP)

######################################################################
#
# Build the master bibliography file.

# Generated master BIB file
MASTER_BIB = $(TMP)/master-bib.conf

master: $(MASTER_BIB)

# Inputs to master BIB file
BIB_FILES = $(SRC)/header.conf \
	$(SRC)/papers.conf \
	$(SRC)/reports.conf \
	$(SRC)/pres.conf \
	$(SRC)/workshops.conf

$(MASTER_BIB): $(TMP) $(BIB_FILES)
	cat $(BIB_FILES) > $(MASTER_BIB)

clean::
	rm -f $(MASTER_BIB)

######################################################################
#
# For my work page
#

WORK_HTML = bib.html
WORK_TEMPLATE = $(TEMPLATES)/$(WORK_HTML).template

html:: $(WORK_HTML)

$(WORK_HTML): $(WORK_TEMPLATE)

clean::
	rm -f $(WORK_HTML)

######################################################################
#
# Implicit rule for making html files from template and master bib.

%.html: $(TEMPLATES)/%.html.template $(MASTER_BIB)
	$(PYBIB) -H -t $< $(MASTER_BIB) > $@
