This is the source code of [christianspecht.de](http://christianspecht.de), built with [Jekyll](http://jekyllrb.com/).

---

#### How to build

Prerequisites *(on Windows)*:

- Ruby >= 1.9.3 and Bundler *(both via [RailsInstaller](http://railsinstaller.org/en))*
- `bundle update`

Run `build.bat`.  
This will build the site and run the local server *(the site is at [http://localhost:4000/](http://localhost:4000/))*

---

#### How to upload

Prerequisites:

- WinSCP, portable version ([download](http://winscp.net/eng/download.php))

Run `build-upload.bat`.  
This will build the site and upload it to the server via FTP.

The script expects the `WinSCP.com` in the parent folder.  
WinSCP needs to be [pre-configured with a session/site](http://winscp.net/eng/docs/session_configuration#site) named `blog` with the correct server/user/password.
