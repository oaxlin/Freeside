<% include('/elements/header-popup.html', "Change Package") %>

<% include('/elements/error.html') %>

<FORM ACTION="<% $p %>edit/process/change-cust_pkg.html" METHOD=POST>
<INPUT TYPE="hidden" NAME="pkgnum" VALUE="<% $pkgnum %>">

<% ntable('#cccccc') %>

  <TR>
    <TH ALIGN="right">Current package</TH>
    <TD COLSPAN=7>
      <% $curuser->option('show_pkgnum') ? $cust_pkg->pkgnum.': ' : '' %><B><% $part_pkg->pkg |h %></B> - <% $part_pkg->comment |h %>
    </TD>
  </TR>
  
  <TR>
    <TH ALIGN="right">New package</TH>
    <TD COLSPAN=7>
      <% include('/elements/select-cust-part_pkg.html',
                   'cust_main'    => $cust_main,
                   'element_name' => 'pkgpart',
                   #'extra_sql'    => ' AND pkgpart != '. $cust_pkg->pkgpart,
                   'curr_value'   => scalar($cgi->param('pkgpart')),
                )
      %>
    </TD>
  </TR>

  <% include('/elements/tr-select-cust_location.html',
               'cgi'       => $cgi,
               'cust_main' => $cust_main,
            )
  %>

</TABLE>

<BR>
<INPUT TYPE="submit" VALUE="Change package">

</FORM>
</BODY>
</HTML>

<%init>

my $conf = new FS::Conf;

my $curuser = $FS::CurrentUser::CurrentUser;

die "access denied"
  unless $curuser->access_right('Change customer package');

my $pkgnum = scalar($cgi->param('pkgnum'));
$pkgnum =~ /^(\d+)$/ or die "illegal pkgnum $pkgnum";
$pkgnum = $1;

my $cust_pkg =
  qsearchs({
    'table'     => 'cust_pkg',
    'addl_from' => 'LEFT JOIN cust_main USING ( custnum )',
    'hashref'   => { 'pkgnum' => $pkgnum },
    'extra_sql' => ' AND '. $curuser->agentnums_sql,
  }) or die "unknown pkgnum $pkgnum";

my $cust_main = $cust_pkg->cust_main
  or die "can't get cust_main record for custnum ". $cust_pkg->custnum.
         " ( pkgnum ". cust_pkg->pkgnum. ")";

my $part_pkg = $cust_pkg->part_pkg;

</%init>
