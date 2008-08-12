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
# Our targets
#

default: html

######################################################################
#
# Build the master bibliography file.

MASTER_BIB = master.bib

BIB_FILES = header.bib \
	papers.bib \
	reports.bib \
	pres.bib \
	workshops.bib \
	gridshib.bib

$(MASTER_BIB): $(BIB_FILES)
	cat $^ > $(MASTER_BIB)

clean::
	rm -f $(MASTER_BIB)

######################################################################
#
# My personal bibliography
#

PERSONAL_HTML = bib.html
html:: $(PERSONAL_HTML)

$(PERSONAL_HTML): bib.late

clean::
	rm -f $(PERSONAL_HTML)

######################################################################
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

$(GS_SPECS_HTML): gridshib-specs-bib.late

$(GS_PRES_HTML): gridshib-pres-bib.late

$(GS_PAPERS_HTML): gridshib-papers-bib.late

clean::
	rm -f $(GS_HTML)

######################################################################
#
# Implicit rule for making html files from template and master bib.

%.html: %.late $(MASTER_BIB)
	$(BIB2X) -t $< -f $(MASTER_BIB) > $@

######################################################################
#
# Synching

# Files we touch to indicate we've rsync'ed to the web site

GRIDSHIB = update.gridshib
NCSA_HOMEPAGE = update.ncsa
PERSONAL_HOMEPAGE = update.personal
LOCAL_HOMEPAGE = update.local

SYNC_TARGETS = \
	$(NCSA_HOMEPAGE) \
	$(GRIDSHIB) \
	$(PERSONAL_HOMEPAGE) \
	$(LOCAL_HOMEPAGE)

sync: $(SYNC_TARGETS)

$(NCSA_HOMEPAGE): $(PERSONAL_HTML) $(PAPERS_BIB)
	$(RSYNC) $? public-linux.ncsa.uiuc.edu:~/public_html && touch $@

# Don have rsync on vwelch.com
$(PERSONAL_HOMEPAGE): $(PERSONAL_HTML) $(PAPERS_BIB)
	scp $? vwelch.com:~/www.vwelch.com/data && touch $@

$(GRIDSHIB): $(PERSONAL_HTML)
	$(RSYNC) $? cvs.globus.org:~/gridshib.globus.org && touch $@

$(LOCAL_HOMEPAGE): $(PERSONAL_HTML) $(PAPERS_BIB)
	$(RSYNC) $? ../home-page && touch $@

clean::
	rm -f $(SYNC_TARGETS)

