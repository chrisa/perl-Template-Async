use ExtUtils::MakeMaker;

WriteMakefile(
    NAME => 'Template::Async',
    VERSION_FROM => 'lib/Template/Async.pm',
    ABSTRACT_FROM => 'lib/Template/Async.pm',
    AUTHOR => 'Chris Andrews <chris@nodnol.org>',
    PREREQ_PM => {
        'Template' => '2.24',
        'AnyEvent' => '0',
        'AnyEvent::HTTP' => '0',
        'JSON::Any' => '0',
        'Try::Tiny' => '0',
    }
);
