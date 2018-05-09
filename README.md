## AT-AT skeleton

[![Build Status](https://travis-ci.org/dod-ccpo/skel.svg?branch=master)](https://travis-ci.org/dod-ccpo/skel)

# Prerequisites

First install perlbrew (http://perlbrew.pl and a recent perl).

    curl -L https://install.perlbrew.pl | bash
    perlbrew available
    perlbrew install 5.26.2
    perlbrew switch 5.26.2
    # update ~/.profile as instructed

Then, install cpanminus:

    perlbrew install-cpanm

Install prerequisites:

    cpanm --installdeps .

# Run the tests

    ./ata test

# Run the server

    ./ata daemon

# Run the server in dev mode and auto-reload.

    morbo ./ata

# Run the server in production mode

    hypnotoad ./ata

# Save the data in a local file called ata-objects.frozen

    ATA_PERSIST=1 ./ata daemon

# Testing

Run all tests:

    prove -l t

Run an individual test:

    prove -l t/testname.t
    # or
    perl -Ilib t/testname.t

Critique an individual file, with verbose output:

    perlcritic -p t/perlcriticrc -verbose=10 lib/Atat/Objects.pm

Tidy an individual file automatically:

    perltidy -b lib/Atat/Objects.pm

