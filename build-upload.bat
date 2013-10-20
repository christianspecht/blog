blogofile build -s src

echo If the build succeeded, press RETURN to upload!

pause

set uploadpath=%~dp0\src\_site
%~dp0\..\winscp.com /script=build-upload.txt /xmllog=build-upload.log

pause