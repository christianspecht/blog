---
layout: post
title: "Overriding built-in MS Access functions: giving the MsgBox a default title" 
date: 2016/06/14 19:43:00
tags:
- ms-access
- vba
codeproject: 1
---

If you ever used a `MsgBox` in a Microsoft Access application, you probably noticed that it always says "Microsoft Access" in the title bar by default:

    MsgBox "Hello World"
    
![Hello World](/img/ms-access-msgbox1.png)

If you want to hide the fact that your app was built with MS Access, and show your app title instead, you can use the `Title` parameter:

    MsgBox "Hello World", , "My App"
    
![Hello World with custom title](/img/ms-access-msgbox2.png)

But that's not the ideal solution.  
Even when you put the app title into a constant and pass this, you still have to remember to do this **every time** you're using a `MsgBox`.

Fortunately, there's a better way: It's possible to "override" default Access functions.  
You can provide your own implementation with the same name and the same parameters, which calls the actual built-in function under the hood.

Here's an example how to override `MsgBox`:


    Public Function MsgBox( _
                            Prompt, _
                            Optional Buttons As VbMsgBoxStyle = vbOKOnly, _
                            Optional Title, _
                            Optional HelpFile, _
                            Optional Context _
                            ) _
                            As VbMsgBoxResult

        If IsMissing(Title) Then
            Title = CurrentDb.Properties("AppTitle")
        End If

        MsgBox = VBA.Interaction.MsgBox(Prompt, Buttons, Title, HelpFile, Context)

    End Function

This function doesn't do much more than passing all parameters to `VBA.Interaction.MsgBox`, which is what you would call the *fully qualified name* in .NET for `MsgBox`.

You can see it when you right-click `MsgBox` somewhere in your code and click on "Go to definition":

![MsgBox definition](/img/ms-access-msgbox3.png)


---

## Setting the title

Now you just need to set the app title once, if your application doesn't have one yet.  
The [MSDN page about the `AppTitle` property](https://msdn.microsoft.com/en-us/library/office/ff821127.aspx) describes multiple ways how to do this (manually or by code).

In case the `AppTitle` property already exists in your app, you can just overwrite it with a one-liner:

    CurrentDb.Properties("AppTitle")= "New Title"

If it doesn't, there's also example code on the bottom of [this MSDN page](https://msdn.microsoft.com/en-us/library/office/ff197957.aspx) which creates the property if it's missing.

    
With the app title set, the message box will now look like this, without having to fill the `Title` parameter:

    MsgBox "Hello World"


![MsgBox with automatic title](/img/ms-access-msgbox4.png)


Note that there's no error handling in the `MsgBox` function shown above, i.e. it will crash when your app title is not set.

It would be possible to avoid this by catching error number 3270 or by looping `CurrentDb.Properties` and checking each property whether its name is `AppTitle`, but for me that's not necessary, because I control the app and I *know* the title is set.

---

This approach works for other built-in Access functions as well.  
Another good candidate for this is the `InputBox`:

	Public Function InputBox( _
	                        Prompt, _
	                        Optional Title, _
	                        Optional Default, _
	                        Optional XPos, _
	                        Optional YPos, _
	                        Optional HelpFile, _
	                        Optional Context _
	                        ) _
	                        As String
	                        
	    If IsMissing(Title) Then
	        Title = CurrentDb.Properties("AppTitle")
	    End If
	    
	    InputBox = VBA.Interaction.InputBox(Prompt, Title, Default, XPos, YPos, HelpFile, Context)
	    
	End Function

You can even add this in an existing app without having to change anything else, as long as you make sure that your "overridden" function's signature is *exactly* the same as the original MS Access function.

