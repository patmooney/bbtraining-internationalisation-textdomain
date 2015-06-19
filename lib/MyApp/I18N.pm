package MyApp::I18N;
use strict; use warnings;

use Encode;
use Locale::Messages qw (:libintl_h nl_putenv);

=head1 NAME

MyApp::I18N  - a class wrapped around Locale::TextDomain

=head1 SYNOPSIS

    my $translations = MyApp::Translations->new();
    $translations->set_language( 'de' );
    print $translations->__('Hello World');

=cut

sub new {
    my ( $class, $conf ) = @_;
    my $self = bless {}, $class;

    # Default values
    $conf->{domain}         ||= 'app-myapp';
    $conf->{codeset}        ||= 'utf-8';
    $conf->{search_dirs}    ||= [ './i18n' ];

    # use the pure perl implementation of gettext instead of the c lib binding
    Locale::Messages->select_package('gettext_pp');

    # require Locale::TextDomain after we have switched the gettext implementation
    require Locale::TextDomain;
    # install the lexicons
    Locale::TextDomain->import( $conf->{domain}, @{ $conf->{search_dirs} } );

    # By default, Locale::TextDomain imports all of its functions as below, but we are going to monkey patch
    # them to turn them into class methods
    {
        no strict 'refs';
        no warnings;
        # we are effectively overwriting all of the methods imported, this spits out a lot
        # of errors, so lets supress them and then we can pretend nothing is wrong
        for my $method ( qw( __ __x __n __nx __xn __p __px __np __npx) ) {
            *{"${class}::$method"} = sub {
                my $self = shift;
                # return perl-strings
                decode($conf->{codeset}, &{'Locale::TextDomain::'.$method}(@_));
            };
        }
    }

    return $self;
}

=head2 set_language

sets the environment variable to dictate language

Usage:

    $translations->set_language('fr');

=cut

sub set_language {
    my ($self, $lang) = @_;
    nl_putenv('LANGUAGE='.$lang);
    nl_putenv('LANG='.$lang);
}

1;
