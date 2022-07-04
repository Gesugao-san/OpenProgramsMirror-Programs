#!/usr/bin/env bash

oppm register Proxima-Project/OpenProgramsMirror-Programs
#oppm list
oppm install proxima-gesu-progs
oppm update proxima-gesu-progs

which hello_world
which auto_mount
which affiche

echo 'this is custom text from the file' > '/home/affiche.txt'
