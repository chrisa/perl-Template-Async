use ExtUtils::MakeMaker;

WriteMakefile(
    NAME => 'Template::Async',
    VERSION_FROM => 'lib/Template/Async.pm',
    ABSTRACT_FROM => 'lib/Template/Async.pm',
    AUTHOR => 'Chris Andrews <chris@nodnol.org>',
    PREREQ_PM => {
        'Template' => '2.00',
        'AnyEvent' => '0',
        'AnyEvent::HTTP' => '0',
        'JSON::Any' => '0',
    }
);
