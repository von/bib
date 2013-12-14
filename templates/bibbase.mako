## Base template for bib files

## Create redirection URLS based on htaccess
##   Do not need to escape ${base_url} since it is inserted literally
##   and then processed later by pyderweb in publish.sh
<%def name="url(e)">
  ${context.get("base_url") or ""}pubs/${e["key"]}
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
