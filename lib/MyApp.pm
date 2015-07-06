package MyApp;
use strict; use warnings;

use Template;
use MyApp::I18N;
use HTTP::Server::Simple::CGI;
use base qw(HTTP::Server::Simple::CGI);

=head1 NAME

MyApp - A very simple web application to demonstrate Locale::TextDomain

=head1 SYNOPSIS

my $app = MyApp->new( $port )->run();

=cut

my %dispatch = (
    '/' => \&index
);

sub index {
    my ( $self, $cgi ) = @_;

    # Must print content type header and then two new lines to begin html content
    print "Content-Type: text/html\r\n\r\n";

    # before we render the template, lets set the enviroment language to fit the current user.
    # Normally you would store the users language preference in a cookie or session
    $self->translations()->set_language( $self->get_current_users_language() );

    # template->process prints the output unless you pass a var ref as the third param
    return $self->template()->process(
        'index.html.tt',
        {
            # passing in a method to the template, this allows us to set the language so the template
            # doesn't need to know about it
            translate => sub {
                $self->translations()->__( @_ );
            }
            # Use this method for translating strings which contain placeholders
            # e.g. [% translate_x("Hello {name}", name="David") %]
            translate_x => sub {
                my ( $key, $variable_ref ) = @_);
                $self->translations()->__x( $key, %$variable_ref );
            }
        }
    ) || $self->template_error();
}

=head2 Template Methods

Methods can be passed as variables into template toolkit for use inside the template

=over 1

=item C<capitalise_text>

Turns given string into upper case

Usage:

    my $str = 'sausages';
    my $out = capitalise_text( $str );

Out:

    SAUSAGES

=cut

sub capitalise_text {
    my ( $text ) = @_;
    return uc( $text );
}

sub get_current_users_language { 'fr'; }

sub handle_request {
    my $self = shift;
    my $cgi  = shift;

    my $path = $cgi->path_info();
    my $handler = $dispatch{$path};

    if (ref($handler) eq "CODE") {
        print "HTTP/1.0 200 OK\r\n";
        $handler->($self,$cgi);
    }
    else {
        print "HTTP/1.0 404 Not found\r\n";
        print $cgi->header,
              $cgi->start_html('Not found'),
              $cgi->h1('Not found'),
              $cgi->end_html;
    }
}

sub template_error {
    my ( $self ) = @_;
    my $error = $self->template()->error();
    warn "error type: ", $error->type(), "\n";
    warn "error info: ", $error->info(), "\n";
    warn $error, "\n";
}

sub template {
    my ( $self ) = @_;

    unless ( $self->{template} ){
        $self->{template} = Template->new({
            INCLUDE_PATH => 'templates',  # or list ref
            VARIABLES => {
                capitalise => \&capitalise_text
            }
        });
    }

    return $self->{template};
}

sub translations {
    my ( $self ) =@_;

    unless ( $self->{translations} ){
        $self->{translations} = MyApp::I18N->new();
    }

    return $self->{translations};
}

1;
