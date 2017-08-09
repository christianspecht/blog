---
order: 3
name: Recordset.Net
site: /recordset-net/
logo: /php/cache/img/recordset.net-logo128x128.png
desc: Converts .NET POCOs to ADODB.Recordsets
sidebar: 1
featured: 0
---

#### What I needed:

Convert .NET POCOs into `ADODB.Recordsets`, in order to gradually migrate existing MS Access applications to .NET *(Access client needs to read data coming from .NET)*.

#### What I learned:

- Reflection basics
- Writing unit tests with [xUnit.net](https://xunit.github.io/)
- Creating a [NuGet package](https://nuget.org/packages/Recordset.Net) ([and testing it on the preview site]({% post_url 2012-05-28-how-to-test-nuget-packages-without-polluting-the-nuget-package-listings %}))
