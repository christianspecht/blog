---
title: Batch File Cheat Sheet
date: 2013-05-12T23:45:00
tags: [command-line]
---

Recently, I had some tasks at work that required me to write a lot of batch files.  
Here are some things about batch files that I either learned or re-discovered in the process:


## Don't use blanks when assigning values to variables

This works:

	set foo=bar

This **does not work** *(no error message - `%foo%` is just empty afterwards)*:

	set foo = bar

This one took me some time to figure out. I'm used to Visual Studio and the Access VBA editor, which both automatically insert these blanks into my code if I don't do it myself. So when I wrote batch files with a simple text editor, I inserted these blanks too, without thinking.


## Execute .exe and save the output to a variable

This line saves the output of `foo.exe` to a variable named `%bar%`:

	for /f "tokens=*" %%i in ('path\to\foo.exe') do set bar=%%i 

*(Credits for this go to [user "lesmana" at Stack Overflow](http://stackoverflow.com/a/4695680/6884))*

Disclaimer: I don't try to understand it, I just copy/paste it every time I need it.   
*(The whole usage of the `for` command looks equally complicated - to see it in all its beauty, type `for /?` and read the help.)*


## Get the path and file name of the currently running batch file

There are other commands to get more file information, but to me the most important ones are these:

- `%~dp0` outputs the path of the current batch file
- `%~nx0` outputs the name of the current batch file

To see it in action, put this into a batch file:

	echo %~dp0
	echo %~nx0

When the batch file is `c:\test.bat`, it will output this:

	C:\
	test.bat

The number zero at the end of `%~dp0` and `%~nx0` refers to `%0`, which is the currently executing batch file.  
Likewise, if you pass a file as parameter `%1`, you can get the name of *that* file by using `%~nx1` instead of `%~nx0`.

`%~dp0` and `%~nx0` are actually combined commands *(you can also use `%~n0` to get just the file name without extension, and `%~x0` to get just the extension)*  
To see the complete list of commands, open the command line and type in `call /?`.


## Temporarily add a folder to the `%PATH%` variable

When you need to refer files from a certain folder in a batch file several times and you don't want to copy/paste the complete path every time, you can just add the folder to the `%PATH%` variable.  
When you don't want to *(or aren't allowed to)* do this permanently on the machine, you can set the `%PATH%` variable in the batch file, which lasts only for the execution time of the batch file.

The following line **appends** `c:\foo` to the existing content of the `%PATH%` variable:

	path=%path%;c:\foo

Afterwards, the `%PATH%` variable contains everything it contained before **plus** `c:\foo`, which is probably what you want.

A second *(but inferior)* way would be:

	path=c:\foo

This is probably **not** what you want, because it **replaces the whole content of the `%PATH%` variable** by `c:\foo` !  
In other words, `%PATH%` will **only** contain `c:\foo` afterwards.

Beware: you won't notice the difference as long as you only need files from `c:\foo`.  
But as soon as you need some other command-line tool like `git` or `hg` *(or some Windows helper like `regsvr32.exe`)*, your batch file won't find them anymore because you just deleted their locations from the `%PATH%`.


## Variables are global in nested batch file calls

Take a look at these two batch files:

**batch1.bat**:

	set var=foo
	call batch2.bat
	echo %var%

**batch2.bat**:

	set var=bar

The first batch file calls the second one, so variables with the same name are shared between the two.

This means that the last line in the first batch file (`echo %var%`) will output `bar` and not `foo` !

