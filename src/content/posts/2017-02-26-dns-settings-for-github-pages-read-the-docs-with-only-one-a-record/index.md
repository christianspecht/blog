---
title: "DNS settings for GitHub Pages/Read the Docs, with only one A record"
slug: dns-settings-for-github-pages-read-the-docs-with-only-one-a-record
date: 2017-02-26T18:09:00
tags:
- web
externalfeeds: 1
---

Recently I set up a new website for [a new project of mine](http://scm-backup.org). I wanted to use [GitHub Pages](https://pages.github.com/) for the website and [Read the Docs](https://readthedocs.org/) for the documentation, both with the same custom domain *(and a subdomain of that custom domain)*:

[scm-backup.org](http://scm-backup.org) ⇒ GitHub Pages  
[docs.scm-backup.org](http://docs.scm-backup.org) ⇒ Read the Docs

If you are an experienced DNS record creator, you probably know exactly how to do this and don't need the information in this post at all.  
But I never messed with DNS settings before, and apparently some things are varying depending on your provider, so I got stuck in the middle and had to resolve to Google and my provider's support.

My provider is [all-inkl.com](https://all-inkl.com/), and here are the default DNS settings in their admin panel:

![default DNS settings](/img/all-inkl-dns-default.png)

---

## Read the Docs

The Read the Docs part was easy and straightforward. 

I followed [the documentation](http://docs.readthedocs.io/en/latest/alternate_domains.html#cname-support) and created a CNAME record named `docs` which points to `readthedocs.io`.

This *(and adding the domain in the RTD admin page)* was already enough to make 
[docs.scm-backup.org](http://docs.scm-backup.org) resolve to [scm-backup-docs.readthedocs.io](http://scm-backup-docs.readthedocs.io).

---

## GitHub Pages

The GitHub Pages [documentation about custom domains](https://help.github.com/articles/setting-up-an-apex-domain-and-www-subdomain/) tells me to:

- [either create an `ALIAS`/`ANAME` record](https://help.github.com/articles/setting-up-an-apex-domain/#configuring-an-alias-or-aname-record-with-your-dns-provider) or, if that's not possible, [**two** `A` records](https://help.github.com/articles/setting-up-an-apex-domain/#configuring-a-records-with-your-dns-provider) for the actual domain
- [create a `CNAME` record](https://help.github.com/articles/setting-up-a-www-subdomain/) for the `www` subdomain

This is where I got stuck - my provider doesn't support `ALIAS`/`ANAME` records, so I had to fall back to the second option - creating two `A` records.

If you take a look at the default DNS settings on the screenshot at the top, you can see that there are already two `A` records pointing to the same IP: one without name, and one named `*`.

The one named `*` is a wildcard record, which is in sync with the first record: it's not possible to change the wildcard record itself, and changing the first record automtically changes the wildcard record as well.

So after changing the existing `A` record (and the wildcard record) to the first IP provided by GitHub, the domain already resolved to the GitHub Pages site.

But the GitHub help provides **two** IPs, so I tried to create a second `A` record without a name for the second IP. This failed because according to the error message, "this record already exists".

At this point *(and after reading the docs of both GitHub Pages and my provider, and some Googling)* I emailed my provider's support and Github support, and now I know:

1. My provider supports only one `A` record.

1. For a custom domain to successfully resolve to GitHub Pages, it's sufficient to create an `A` record for **one** of GitHub Pages' two IPs.  
  A second `A` record for the second IP isn't strictly necessary, GitHub provides the second IP just for availability.

1. The [`CNAME` record for the `www` subdomain](https://help.github.com/articles/setting-up-a-www-subdomain/) needs to point to `christianspecht.github.io` *(`christianspecht` is my GitHub username)*, even though [the repo with my site](https://github.com/christianspecht/scm-backup-site) is not a user page repo.  
  I was confused at first because according to [this chart](https://help.github.com/articles/custom-domain-redirects-for-github-pages-sites/) I thought I needed to point to `christianspecht.github.io/scm-backup-site`, but the guy from GitHub support told me:

    > Our Pages servers automatically handle routing requests to the correct repository based on your custom domain, so you'll just have to use `christianspecht.github.io`.

---

## The finished settings

Here are my current DNS settings:

![finished DNS settings](/img/all-inkl-dns-finished.png)

I understand that setting only one `A` record is not the ideal solution and may result in my site being offline, should `192.30.252.153` be ever unavailable (and `192.30.252.154` still be available).  

But this is for a new project, I don't know if it will ever take off, and the plan that I'm paying my provider anyway for includes five domains...so this domain is actually free for me.  
So right now I won't move it to a different provider *(and pay for it)* just for the ability to set a second `A` record.
