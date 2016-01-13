---
layout: post
title: Excel found unreadable content (when exporting a Reporting Services report)
date: 2014/01/14 00:16:00
tags: [sql-server, excel, wtf]
---

A few days ago, I ran into a strange bug in SQL Server Reporting Services 2012.  
It started with a helpdesk ticket, someone wasn't able to export a certain report to Excel.

The report itself was an older one, last changed a few years ago.
I guess this kind of report is quite standard for Reporting Services:  
The data source is a stored procedure which gets data from various tables and in the end, it does `select * from #HugeTempTable`.

Loading the report worked fine, as well as exporting it to Excel.  
But we weren't able to open the Excel file, because Excel 2010 said it was corrupted:  
*(the screenshots are in German, so I will provide English translations below)*

![first error message](/img/reporting-services-excel01.png)

Translation:

> Excel found unreadable content in 'file.xlsx'. Do you want to recover the contents of this workbook? If you trust the source of this workbook, click Yes.

![second error message](/img/reporting-services-excel02.png)

Translation:

> Excel was able to open the file by repairing or removing the unreadable content.  
> Removed content: /xl/worksheets/sheet1.xml-Part with XML error. Invalid XML character. Row 1, column 414666.

Apparently [others had](http://www.sqlservercentral.com/Forums/Topic1478697-150-1.aspx#bm1480237) [the same](http://social.msdn.microsoft.com/Forums/sqlserver/en-US/5c4fc104-5d69-409d-9a6e-a6354922729a/exporting-ssrs-report-to-excel-2007-excel-found-unreadable-content-in-file-xlsx) [problem](http://sqlblog.com/blogs/jamie_thomson/archive/2010/01/22/excel-found-unreadable-content-when-exporting-a-reporting-services-report.aspx), but I found that their problems all seemed to be caused by something else - none of the solutions in the links worked for me.

---

## How to find the root cause

I remembered that under the hood, [MS Office files are just ZIP files containing XML](http://en.wikipedia.org/wiki/Office_Open_XML).  
So I renamed the `.xlsx` file to `.zip` and found the actual data inside, in the XML file indicated by the second error message: `\xl\worksheets\sheet1.xml`  
As all the XML in this file was in one single line, I searched for the 414666th character in that line *(because the error message said something about column 414666)* and found this:

![non-printing character](/img/reporting-services-excel03.png)

That's a [Unit Separator](http://en.wikipedia.org/wiki/Unit_separator), a [non-printing character](http://en.wikipedia.org/wiki/Control_character).  
And there were more non-printable characters in the data, for example line breaks.

At least I knew where those characters came from:  
Two of the columns in the data source are `nvarchar(max)` columns, containing comments and notes written by users...and of course, there are things like line breaks in their notes.  
*(and the other non-printing characters were probably introduced by copying and pasting text from somewhere else)*

**So that's what caused the problem: [non-printing characters](http://en.wikipedia.org/wiki/Control_character) in the data source.**  
Since SQL Server Reporting Services offers the *possibility* to export to Excel, I had expected that it would also make sure that the exported file would contain only data that Excel can actually deal with. Apparently I was wrong...

*Side note:  
We just recently upgraded to SQL Server 2012. Before that upgrade, the report worked for years unchanged on SQL Server 2005, but of course Reporting Services 2005 exported to the **old** Excel format. This bug was probably caused by the switch to the [new Excel format](http://en.wikipedia.org/wiki/Office_Open_XML).*

---

## The solution

I had other work to do, so I needed a quick solution to make the damn thing work again - the people needed their Excel files.  
All I wanted was to make sure control characters were stripped from the data that goes into Reporting Services.

In the end, I created a new function that just replaced all control characters *(ASCII code < 32)*:

    CREATE FUNCTION [dbo].[FormatTextForReportingServices]
    (
        @inputtext nvarchar(max) 
    )
    RETURNS nvarchar(max)
    AS
    BEGIN
            set @inputtext = replace(@inputtext, char(1), '')
            set @inputtext = replace(@inputtext, char(2), '')
            set @inputtext = replace(@inputtext, char(3), '')
            set @inputtext = replace(@inputtext, char(4), '')
            set @inputtext = replace(@inputtext, char(5), '')
            set @inputtext = replace(@inputtext, char(6), '')
            set @inputtext = replace(@inputtext, char(7), '')
            set @inputtext = replace(@inputtext, char(8), '')
            set @inputtext = replace(@inputtext, char(9), '')
            set @inputtext = replace(@inputtext, char(10), '')
            set @inputtext = replace(@inputtext, char(11), '')
            set @inputtext = replace(@inputtext, char(12), '')
            
            -- replace line break by blank, so words that were in different lines before are still separated
            set @inputtext = replace(@inputtext, char(13), ' ')

            set @inputtext = replace(@inputtext, char(14), '')
            set @inputtext = replace(@inputtext, char(15), '')
            set @inputtext = replace(@inputtext, char(16), '')
            set @inputtext = replace(@inputtext, char(17), '')
            set @inputtext = replace(@inputtext, char(18), '')
            set @inputtext = replace(@inputtext, char(19), '')
            set @inputtext = replace(@inputtext, char(20), '')
            set @inputtext = replace(@inputtext, char(21), '')
            set @inputtext = replace(@inputtext, char(22), '')
            set @inputtext = replace(@inputtext, char(23), '')
            set @inputtext = replace(@inputtext, char(24), '')
            set @inputtext = replace(@inputtext, char(25), '')
            set @inputtext = replace(@inputtext, char(26), '')
            set @inputtext = replace(@inputtext, char(27), '')
            set @inputtext = replace(@inputtext, char(28), '')
            set @inputtext = replace(@inputtext, char(29), '')
            set @inputtext = replace(@inputtext, char(30), '')
            set @inputtext = replace(@inputtext, char(31), '')
            
            return @inputtext       
    END

...and called it at the end of the SP that generates the data source for the report:

    update #HugeTempTable
    set FirstMemoField = dbo.FormatTextForReportingServices(FirstMemoField),
        SecondMemoField = dbo.FormatTextForReportingServices(SecondMemoField)

---

## Wrap up
        
It's not pretty, and of course we need to make sure that it's called in every report which contains some fields that *might* contain non-printing characters.

But for now, it's good enough.
