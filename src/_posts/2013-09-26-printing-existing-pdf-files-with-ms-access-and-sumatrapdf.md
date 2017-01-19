---
layout: post
title: Printing existing PDF files with MS Access and SumatraPDF
date: 2013/09/26 18:03:00
tags: [ms-office, vba]
---

**To make things clear from the beginning:  
This is about using VBA/MS Access to send existing PDF files to a printer, NOT about creating new PDF files from reports!**

When you have existing PDF files that you need to send to a printer, the usual solution that you can find on the Internet is somehow calling Adobe Reader to print the file...but then Adobe Reader stays open and you need to close it again somehow.  
Plus, Adobe Reader is not the fastest...on my machine, it takes several seconds until it has opened and sent the PDF to the printer.

Fortunately, there are other PDF readers that do a better job.  
In this post, I'll show you how to use the free & open source [SumatraPDF](http://blog.kowalczyk.info/software/sumatrapdf/) to print PDF files with VBA in MS Access.  
*(this will probably work in other VBA flavors like Excel as well, but I tested it in MS Access only)*

Why SumatraPDF? Because it was the smallest and fastest PDF viewer that I could find.

---

## Calling SumatraPDF from VBA

According to the [manual](http://blog.kowalczyk.info/software/sumatrapdf/manual.html), SumatraPDF has the following command-line parameters for printing:
	
	-print-to-default $file.pdf	         prints a PDF file on a default printer
	-print-to $printer_name $file.pdf	 prints a PDF on a given printer

So all we have to do is call SumatraPDF and supply the path to the PDF file, plus (optional) a printer name.

***Note that the example code below uses several functions that are *NOT* part of the default VBA library:***  
*`Path_Combine`, `Path_GetCurrentDirectory`, `File_Exists`, `String_Format` and `Process_Start` are all from my open source "toolbox" [VBA Helpers](/vba-helpers/).  
Of course, you can do it as well using only vanilla VBA, but that would make the example code quite a bit longer and definitely less readable.*

*If you don't want to use the functions from VBA Helpers, you can read [the source code](https://bitbucket.org/christianspecht/vba-helpers/src/tip/vba-helpers.bas?at=default) to see how they are implemented, and then implement them in your own code yourself.*

Anyway, here's the example code:

	Public Sub PrintPdfFile( _
	                    ByVal PathToPdf As String, _
	                    Optional ByVal Printer As String, _
	                    Optional ByVal NumberOfPrints As Byte = 1 _
	                    )
	    
	    Dim PathToExe As String
	    Dim Parameters As String
	    Dim i As Byte
	    
	    'we'll assume that the exe is in the same folder as the current MDB
	    PathToExe = Path_Combine(Path_GetCurrentDirectory, "sumatrapdf.exe")
	    
	    If File_Exists(PathToPdf) And File_Exists(PathToExe) Then
	    
	        If Printer > "" Then
	            'use specified printer
	            Parameters = String_Format("-print-to ""{0}"" ""{1}""", Printer, PathToPdf)
	        Else
	            'use default printer
	            Parameters = String_Format("-print-to-default ""{0}""", PathToPdf)
	        End If
	        
	        For i = 1 To NumberOfPrints
	            Process_Start PathToExe, Parameters, True
	        Next
	    
	    End If
	    
	End Sub


Usage:

	'print to the default printer
	PrintPdfFile "c:\test.pdf"
	
	'print to the printer "MyPrinter"
	PrintPdfFile "c:\test.pdf", "MyPrinter"
	
	'print twice to the default printer
	PrintPdfFile "c:\test.pdf", , 2


The code isn't 100% error proof, though. For example, it doesn't check whether the passed printer really exists.  
I omitted that on purpose because as far as I know, there isn't a single way to check this that works in newer **and** older Access versions alike *(let alone other Office products like Excel)*.  
If you want to check this, you need to find a way that works in *your* Office/VBA version.

---

## Getting SumatraPDF on your machine(s)

This depends on the kind of app you're making. Most VBA apps are probably internal apps *(mine are)*, so I suppose you have a certain level of control about what software gets pre-installed on the machines that your app needs to work on.

If you don't want to run an installer on each machine, then there's also a portable version of SumatraPDF [on the download page](http://blog.kowalczyk.info/software/sumatrapdf/download-free-pdf-viewer.html), that consists of a single 5 MB exe.

Note that you might not be allowed to distribute SumatraPDF together **with** your app, unless your app is licensed under the [GPL](http://www.gnu.org/licenses/gpl-3.0.en.html) (SumatraPDF is!).

*TL/DR: if you use a GPL-licensed component, your actual project must be under the GPL as well.  
But as I understand it, calling a GPL executable from a non-GPL program via command line [is allowed](https://www.gnu.org/licenses/gpl-faq.html#MereAggregation).  
Quote from the link:*

> An “aggregate” consists of a number of separate programs, distributed together on the same CD-ROM or other media. The GPL permits you to create and distribute an aggregate, even when the licenses of the other software are non-free or GPL-incompatible.  
> [...]  
> Where's the line between two separate programs, and one program with two parts?  
> [...]  
> By contrast, pipes, sockets and command-line arguments are communication mechanisms normally used between two separate programs. So when they are used for communication, the modules normally are separate programs.

*So my interpretation is that even distributing SumatraPDF with your app is legal, as long as you just call it via command line as shown above.  
But as I said, this is **my** interpretation - if you're in doubt, you might want to consult a lawyer.*

---

## Alternatives

Of course, you can do the same with other PDF viewers as well, not just SumatraPDF.  
Every PDF viewer worth its salt has similar command-line options, for example the popular [Foxit Reader](http://en.wikipedia.org/wiki/Foxit_Reader):

If it's installed on your machine, open it and go to the menu **Help** &rarr; **Commandline Help**, and you will see this:

	-p <PDF filename>		      Print this file with default printer.  
	-t <PDF filename> <Printer>	  Print this file with specific printer.

Changing the example code from above to use Foxit Reader instead of SumatraPDF should be easy to do.

Concerning distribution:  
Foxit Reader has a [portable version](http://portableapps.com/apps/office/foxit_reader_portable) as well, but SumatraPDF is much more lightweighter *(one single 5 MB file, compared to Foxit Reader's approximately 500 files/90 MB)*. That's why I went with SumatraPDF at the end.  
Foxit Reader can probably do a lot more, but if you just need to print PDFs, it doesn't matter.