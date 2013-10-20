This is the source code of [christianspecht.de](http://christianspecht.de), built with [Blogofile](http://www.blogofile.com/).

---

#### How to build

Prerequisites:

- Python 2.7.x ([download](http://www.python.org/download/releases/2.7.3/))
- Setuptools ([download](http://pypi.python.org/pypi/setuptools#downloads))
- lxml (*needed for excerpts*, [installation notes](http://lxml.de/installation.html#installation), [Windows binary downloads](http://www.lfd.uci.edu/~gohlke/pythonlibs/#lxml))

Run `build.bat`.  
This will build the site and run the local server *(the site is at [http://localhost:8080/](http://localhost:8080/))*

---

#### How to upload

Prerequisites:

- WinSCP, portable version ([download](http://winscp.net/eng/download.php))

Run `build-upload.bat`.  
This will build the site and upload it to the server via FTP.

The script expects the `WinSCP.com` in the parent folder.  
WinSCP needs to be [pre-configured with a session/site](http://winscp.net/eng/docs/session_configuration#site) named `blog` with the correct server/user/password.
