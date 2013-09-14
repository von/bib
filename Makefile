######################################################################
#
# Binaries and scripts we call
#

PYBIB = ~/develop/pyBib/scripts/pyBib.py

######################################################################
#
# Installation paths
#

DEV_ROOT=$(HOME)/develop/www/
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

WORK_HTML = bib.html
WORK_TEMPLATE = $(TEMPLATES)/$(WORK_HTML).template

html:: $(WORK_HTML)

$(WORK_HTML): $(WORK_TEMPLATE)

clean::
	rm -f $(WORK_HTML)

# htaccess file for redirect service
HTACCESS = htaccess.txt
HTACESSS_TEMPLATE = $(TEMPLATES)/$(HTACCESS).template

$(HTACCESS): $(HTACCESS_TEMPLATE) $(MASTER_BIB)

######################################################################
#
# Installation into development directory

install: $(WEBSITE_HTML)

$(WEBSITE_HTML): $(WORK_HTML) $(HTACCESS)
	@echo "Copying $(WORK_HTML) to $(WEBSITE_HTML)"
	cp $(WORK_HTML) $(WEBSITE_HTML)
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

%.html: $(TEMPLATES)/%.html.template $(MASTER_BIB)
	$(PYBIB) -d -t $< $(MASTER_BIB) > $@

%.txt: $(TEMPLATES)/%.txt.template $(MASTER_BIB)
	$(PYBIB) -t $< $(MASTER_BIB) > $@

