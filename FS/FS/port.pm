package FS::port;

use strict;
use vars qw( @ISA );
use FS::Record qw( qsearchs );
use FS::nas;
use FS::session;

@ISA = qw(FS::Record);

=head1 NAME

FS::port - Object methods for port records

=head1 SYNOPSIS

  use FS::port;

  $record = new FS::port \%hash;
  $record = new FS::port { 'column' => 'value' };

  $error = $record->insert;

  $error = $new_record->replace($old_record);

  $error = $record->delete;

  $error = $record->check;

  $session = $port->session;

=head1 DESCRIPTION

An FS::port object represents an individual port on a NAS.  FS::port inherits
from FS::Record.  The following fields are currently supported:

=over 4

=item portnum - primary key

=item ip - IP address of this port

=item nasport - port number on the NAS

=item nasnum - NAS this port is on - see L<FS::nas>

=back

=head1 METHODS

=over 4

=item new HASHREF

Creates a new port.  To add the example to the database, see L<"insert">.

Note that this stores the hash reference, not a distinct copy of the hash it
points to.  You can ask the object for a copy with the I<hash> method.

=cut

# the new method can be inherited from FS::Record, if a table method is defined

sub table { 'port'; }

=item insert

Adds this record to the database.  If there is an error, returns the error,
otherwise returns false.

=cut

# the insert method can be inherited from FS::Record

=item delete

Delete this record from the database.

=cut

# the delete method can be inherited from FS::Record

=item replace OLD_RECORD

Replaces the OLD_RECORD with this one in the database.  If there is an error,
returns the error, otherwise returns false.

=cut

# the replace method can be inherited from FS::Record

=item check

Checks all fields to make sure this is a valid example.  If there is
an error, returns the error, otherwise returns false.  Called by the insert
and replace methods.

=cut

# the check method should currently be supplied - FS::Record contains some
# data checking routines

sub check {
  my $self = shift;
  my $error =
    $self->ut_numbern('portnum')
    || $self->ut_ipn('ip')
    || $self->ut_numbern('nasport')
    || $self->ut_number('nasnum');
  ;
  return $error if $error;
  return "Either ip or nasport must be specified"
    unless $self->ip || $self->nasport;
  return "Unknown nasnum"
    unless qsearchs('nas', { 'nasnum' => $self->nasnum } );
  ''; #no error
}

=item session

Returns the currently open session on this port, or if no session is currently
open, the most recent session.  See L<FS::session>.

=cut

sub session {
  my $self = shift;
  qsearchs('session', { 'portnum' => $self->portnum }, '*',
                     'ORDER BY login DESC LIMIT 1' );
}

=back

=head1 VERSION

$Id: port.pm,v 1.4 2001-01-30 09:08:40 ivan Exp $

=head1 BUGS

The author forgot to customize this manpage.

The session method won't deal well if you have multiple open sessions on a
port, for example if your RADIUS server drops B<stop> records.  Suggestions for
how to deal with this sort of lossage welcome; should we close the session
when we get a new session on that port?  Tag it as invalid somehow?  Close it
one second after it was opened?  *sigh*  Maybe FS::session shouldn't let you
create overlapping sessions, at least folks will find out their logging is
dropping records.

If you think the above refers multiple user logins you need to read the
manpages again.

=head1 SEE ALSO

L<FS::Record>, schema.html from the base documentation.

=head1 HISTORY

ivan@voicenet.com 97-jul-1

added hfields
ivan@sisd.com 97-nov-13

$Log: port.pm,v $
Revision 1.4  2001-01-30 09:08:40  ivan
tyop, thanks to Mack Nagashima <mackn@moaner.org>

Revision 1.3  2000/12/03 20:25:20  ivan
session monitor updates

Revision 1.1  2000/10/27 20:18:32  ivan
oops, also necessary for session monitor

Revision 1.1  1999/08/04 08:03:03  ivan
move table subclass examples out of production directory

Revision 1.4  1998/12/29 11:59:57  ivan
mostly properly OO, some work still to be done with svc_ stuff

Revision 1.3  1998/11/15 04:33:00  ivan
updates for newest versoin

Revision 1.2  1998/11/15 03:48:49  ivan
update for current version


=cut

1;

