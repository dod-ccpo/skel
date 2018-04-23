# AT-AT skeleton

[![Build Status](https://travis-ci.org/dod-ccpo/skel.svg?branch=master)](https://travis-ci.org/dod-ccpo/skel)

# Prerequisites

First install perlbrew (http://perlbrew.pl and a recent perl).

Then, `perlbrew install-cpanm` to install cpanminus.

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

