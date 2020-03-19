## -*- coding: utf-8 -*-
## Base template for bib files

## Create redirection URLS based on htaccess
##   Do not need to escape ${base_url} since it is inserted literally
##   and then processed later by pyderweb in publish.sh
##   Escape newlines so we return script with no newlines.
<%!
from urlparse import urlparse

def permanent_url(e):
  components = urlparse(e["url"])
  if "handle.net" in components.netloc:
      return e["url"]
  if "doi.org" in components.netloc:
      return e["url"]
  return "${base_url}pubs/" + e["key"]
%>

<%def name="url(e)">\
${permanent_url(e)}\
</%def>

## This inherit will actually be used when we generate the actual website
## later.
<%text>
<%inherit file="base.mako" />
</%text>

<div class="main" id="bib">
  <center>
    <%block name="bibhead"/>
  </center>
  <%block name="bibmenu">
    <div class="menubar" id="bibmenu">
      <ul class="menubar">
        <li><a href="index.html">Publications</a></li>
        <li><a href="standards.html">Standards</a></li>
        <li><a href="reports.html">Technical Reports</a></li>
        <li><a href="pres.html">Presentations</a></li>
        <li><a href="workshops.html">Workshops</a></li>
      </ul>
    </div>
  </%block>
  <hr/>
  ${self.body()}
</div>
