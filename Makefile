######################################################################
#
# Binaries and scripts we call
#

#BIB2X From http://www.xandi.eu/bib2x/
BIB2X = /usr/local/bin/bib2x

# -a Archive mode
# -u Update mode: newer files only
# -v Verbose
RSYNC=rsync -auv

######################################################################
#
# Directories

# Bib source files
SRC=src/

# Templates
TEMPLATES=late/

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
MASTER_BIB = $(TMP)/master.bib

# Inputs to master BIB file
BIB_FILES = $(SRC)/header.bib \
	$(SRC)/papers.bib \
	$(SRC)/reports.bib \
	$(SRC)/pres.bib \
	$(SRC)/workshops.bib \
	$(SRC)/gridshib.bib

$(MASTER_BIB): $(TMP) $(BIB_FILES)
	cat $(BIB_FILES) > $(MASTER_BIB)

clean::
	rm -f $(MASTER_BIB)

######################################################################
#
# For my work page
#

WORK_HTML = bib.html
html:: $(WORK_HTML)

$(WORK_HTML): $(TEMPLATES)/bib.late

clean::
	rm -f $(WORK_HTML)

#
# For vwelch.com
#

PERSONAL_HTML = pubs.html
#html:: $(PERSONAL_HTML)

$(PERSONAL_HTML): $(TEMPLATES)/pubs.late

clean::
	rm -f $(PERSONAL_HTML)

#
# The gridshib bibliography
#

GS_PAPERS_HTML = gridshib-papers-bib.html
GS_PRES_HTML = gridshib-pres-bib.html
GS_SPECS_HTML = gridshib-specs-bib.html
GS_HTML = \
	$(GS_PAPERS_HTML) \
	$(GS_PRES_HTML) \
	$(GS_SPECS_HTML)

html:: $(GS_HTML)

$(GS_SPECS_HTML): $(TEMPLATES)/gridshib-specs-bib.late

$(GS_PRES_HTML): $(TEMPLATES)/gridshib-pres-bib.late

$(GS_PAPERS_HTML): $(TEMPLATES)/gridshib-papers-bib.late

clean::
	rm -f $(GS_HTML)

######################################################################
#
# Implicit rule for making html files from template and master bib.

%.html: $(TEMPLATES)/%.late $(MASTER_BIB)
	$(BIB2X) -t $< -f $(MASTER_BIB) > $@

%.php: %.late $(MASTER_BIB)
	$(BIB2X) -t $< -f $(MASTER_BIB) > $@


######################################################################
#
# Synching

# Files we touch to indicate we've rsync'ed to the web site

GRIDSHIB = $(TMP)/update.gridshib
NCSA_HOMEPAGE = $(TMP)/update.ncsa
PERSONAL_HOMEPAGE = $(TMP)/update.personal
LOCAL_HOMEPAGE = $(TMP)/update.local

SYNC_TARGETS = \
	$(NCSA_HOMEPAGE) \
	$(GRIDSHIB) \
	$(PERSONAL_HOMEPAGE) \
	$(LOCAL_HOMEPAGE)

sync: $(SYNC_TARGETS)

$(NCSA_HOMEPAGE): $(WORK_HTML) $(PAPERS_BIB) $(TMP)
	$(RSYNC) $? public-linux.ncsa.uiuc.edu:~/public_html && touch $@

# Don have rsync on vwelch.com
$(PERSONAL_HOMEPAGE): $(PERSONAL_HTML) $(PAPERS_BIB) $(TMP)
	scp $? vwelch.com:~/www.vwelch.com/data/professional && touch $@

$(GRIDSHIB): $(GS_HTML) $(TMP)
	$(RSYNC) $? cvs.globus.org:~/gridshib.globus.org && touch $@

$(LOCAL_HOMEPAGE): $(WORK_HTML) $(PAPERS_BIB) $(TMP)
	$(RSYNC) $? ../home-page && touch $@

clean::
	rm -f $(SYNC_TARGETS)

