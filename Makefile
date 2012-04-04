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

default: html txt

.PHONY: default
.PHONY: html
.PHONY: txt
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
# Text version for easy copy and paste
#

TXT = bib.txt
TXT_TEMPLATE = $(TEMPLATES)/$(TXT).template

txt:: $(TXT)

$(TXT): $(TXT_TEMPLATE)

clean::
	rm -f $(TXT)

######################################################################
#
# Implicit rules

%.html: $(TEMPLATES)/%.html.template $(MASTER_BIB)
	$(PYBIB) -H -t $< $(MASTER_BIB) > $@

%.txt: $(TEMPLATES)/%.txt.template $(MASTER_BIB)
	$(PYBIB) -t $< $(MASTER_BIB) > $@

