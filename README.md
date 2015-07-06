##Locale::Maketext Workshop

### How to setup your enviroment

From the base directory you should be able to see

    bin/
    lib/
    templates/
    README.md
    cpanfile

Follow these steps in order to get your application running using local dependencies...

    cpanm --installdeps . # install the app's dependencies into a local directory
    perl ./bin/app.pl # Run the app

You should see this output, try going to the URL given to see a hello world message!

    MyApp: You can connect to your server at http://localhost:5005/

### Task

Using [Locale::TextDomain](http://search.cpan.org/dist/libintl-perl/lib/Locale/TextDomain.pm), translate your application by extracting keys and producing a PO file.

Tips:

    1. Look at fr.po
    2. Look at the first gettext comman below

### gettext commands

Your translation file needs to be in a format which TextDomain understands so we need to compile it...

#### Compile the translated PO file into a binary format, ready to be used by your application

This will compile the fr.po file and move it into the correct directory

    msgfmt fr.po -o "i18n/fr/LC_MESSAGES/app-myapp.mo"

#### Extract keys from your code base and compile a .pot file

    xgettext -L Perl -k__ -k\$__ -k%__ -k__x -k__n:1,2 -k__nx:1,2 -k__xn:1,2 -kN__ -k__p:1c,2 -k -o ./translate-app.pot --from-code=UTF-8 <name of file>

#### Build a language specific file ready to be exported and translated

    msginit -i ./translate-app.pot --locale=fr --no-translator
