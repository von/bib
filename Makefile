######################################################################
#
# Binaries and scripts we call
#

PYBIB = pyBib.py -T templates/

######################################################################
#
# Installation paths
#

DEV_ROOT=$(HOME)/develop/
WEBSITE_BASE=$(DEV_ROOT)/www.vonwelch.com/
WEBSITE_PUBS=$(WEBSITE_BASE)/pubs/
WEBSITE_HTML=$(WEBSITE_PUBS)/index.html

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

default: html txt htaccess.txt

.PHONY: default
.PHONY: html
.PHONY: txt
.PHONY: clean
.PHONY: install

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

BIB_HTML = index.html pres.html standards.html workshops.html reports.html

html:: $(BIB_HTML)

clean::
	rm -f $(BIB_HTML)

# htaccess file for redirect service
HTACCESS = htaccess.txt
HTACESSS_TEMPLATE = $(TEMPLATES)/$(HTACCESS).template

$(HTACCESS): $(HTACCESS_TEMPLATE) $(MASTER_BIB)

######################################################################
#
# Installation into development directory

install: $(BIB_HTML) $(HTACCESS)
	@echo "Copying $(BIB_HTML) to $(WEBSITE_PUBS)"
	cp $(BIB_HTML) $(WEBSITE_PUBS)
	@echo "Copying $(HTACCESS) to $(WEBSITE_PUBS)"
	cp $(HTACCESS) $(WEBSITE_PUBS)/.htaccess

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

%.html: $(TEMPLATES)/%.html.template $(TEMPLATES)/bibbase.mako $(MASTER_BIB)
	$(PYBIB) -d -t $< $(MASTER_BIB) > $@

%.txt: $(TEMPLATES)/%.txt.template $(MASTER_BIB)
	$(PYBIB) -t $< $(MASTER_BIB) > $@

