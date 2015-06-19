##Locale::Maketext Workshop

### How to setup your enviroment

I always try to keep all of my application dependencies as local as possible, it is my oppinion 
that this allows for a better understanding of the requirements which saves you from any nasty 
deployment issues later on ( missing dependencies / wrong version etc ect )

From the base directory you should be able to see

    bin/
    lib/
    templates/
    README.md
    cpanfile

Follow these steps in order to get your application running using local dependencies...

    cpanm local::lib # required to use local dependencies
    cpanm -L local --installdeps . # install the app's dependencies into a local directory
    perl -Mlocal::lib=local ./bin/app.pl # Run the app

You should see this output, try going to the URL given to see a hello world message!

    MyApp: You can connect to your server at http://localhost:5005/

### Task

Using [Locale::TextDomain](http://search.cpan.org/dist/libintl-perl/lib/Locale/TextDomain.pm), translate your application by extracting keys and producing a PO file.

### gettext commands

#### Extract keys from your code base and compile a .pot file

    find lib/ -name "*.pm" -follow > /tmp/appfilelist #get a list of files from which to extract keys
    xgettext --files-from=/tmp/appfilelist -L Perl -k__ -k\$__ -k%__ -k__x -k__n:1,2 -k__nx:1,2 -k__xn:1,2 -kN__ -k__p:1c,2 -k -o /tmp/translate-app.pot --from-code=UTF-8

#### Build a language specific file ready to be exported and translated

    msginit -i /tmp/translate-app.pot --locale=fr --no-translator

#### Compile the translated PO file into a binary format, ready to be used by your application

    msgfmt fr.po -o "i18n/fr/LC_MESSAGES/app-myapp.mo"
