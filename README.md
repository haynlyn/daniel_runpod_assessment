I made this on my laptop running EndeavourOS. I am assuming that git, make, and other
Linux utilities are installed, such as bash.

Inspect the Makefile and run `make all` to set up the venv, SnowSQL, and database.

Insure that you have SnowSQL installed. I installed v.1.3.1 from the AUR.

Call `python extract.py` to download data from HubSpot into a local directory.
Call `python load.py` to load the recently acquired data into a stage and upsert into Snowflake.
Call `python make_views.py` to run through a manually-created DAG of views and build them.

`Documentation` contains some files that can be opened in Draw.io (available on the website) that
explain some of the data modeling, although I didn't get to finish everything due to trying to fix bugs.'
