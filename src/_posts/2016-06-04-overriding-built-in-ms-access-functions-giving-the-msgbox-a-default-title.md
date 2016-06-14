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


Now you just need to set the app title like this:

    CurrentDb.Properties("AppTitle")= "New Title"
    
With the app title set, the message box will now look like this, without having to fill the `Title` parameter:

    MsgBox "Hello World"


![MsgBox with automatic title](/img/ms-access-msgbox4.png)


---

## This won't work when your app title is not set.

Without an app title set in Access, `CurrentDb.Properties("AppTitle")` doesn't even exist, and you can't catch that via `Nz`, `Is Nothing` etc. at runtime.

The only way I know of is looping `CurrentDb.Properties` and check each property whether its name is `AppTitle`, but I don't like the idea of doing this each and every time I'm displaying a `MsgBox`.

That's why I just left the code as shown above (without any checking) because I control the app and I *know* the app title is set.

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

