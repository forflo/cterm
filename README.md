cterm
=====

An applescript script that uses the special capabilities of iTerm to create a multiplexed ssh-terminal session.

Usage
-----
Add the script's directory to your PATH and just type in the following

    $ cterm.scpt -u root -p 22 -c 4 -w 170 -h 40 your.pc.one your.pc.two your.pc.three

Enjoy...

Useful optional dependencies
----------------------------
Try out my admintools package available here:
https://github.com/forflo/admintools

With admintools, something like that will be possible

    $ cterm.scpt -u root -p 22 -c 4 -w 170 -h 40 $(dnames -g PC-Group1 -c -d " ")

Video?
------
Yes, there is a little shitty screencast on the internet.
https://www.youtube.com/watch?v=-4AZ5M6YlXk
