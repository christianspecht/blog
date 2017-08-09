---
order: 5
name: MissileSharp
site: /missilesharp/
logo: /php/cache/img/missilesharp-logo128x128.png
desc: .NET library to control an USB Missile Launcher
sidebar: 1
featured: 1
---

#### What I needed:

Send commands to an [USB Missile Launcher](http://www.dreamcheeky.com/thunder-missile-launcher) from my own code, without using the control software that came with it.

#### What I learned:

- Communicating with an USB device with [Hid Library](https://github.com/mikeobrien/HidLibrary)
- Building a WPF app *(the [MissileSharp Launcher](/missilesharp/#launcher))* with MVVM and [MahApps.Metro](http://mahapps.com/MahApps.Metro/)
- More Dependency Injection, this time with [Autofac](http://autofac.org)
- More unit testing, this time with [NUnit](http://nunit.org/) and [Moq](https://github.com/moq/moq4)
- Building a [ClickOnce](http://msdn.microsoft.com/en-us/library/t71a733d.aspx) installer