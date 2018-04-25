# AT-AT skeleton

[![Build Status](https://travis-ci.org/dod-ccpo/skel.svg?branch=master)](https://travis-ci.org/dod-ccpo/skel)

[![Coverage Status](https://coveralls.io/repos/github/dod-ccpo/skel/badge.svg)](https://coveralls.io/github/dod-ccpo/skel)

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

# Run the server in dev mode and auto-reload if assets are changed

    morbo -w assets ./ata

# Run the server in production mode

    hypnotoad ./ata

# Testing

Run all tests:

    prove t

Run an individual test:

    prove t/testname.t
    # or
    perl -Ilib t/testname.t


