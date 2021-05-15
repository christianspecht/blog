---
layout: post
title: "Bitbucket Pipelines: Fixing 'The ECDSA host key has changed'"
date: 2021/04/07 22:30:00
tags:
- ci
- ssh
- wtf
externalfeeds: 1
---

I recently pushed to a Bitbucket repository and expected Bitbucket Pipelines [to deploy the site via SSH/rsync to my webserver]({% post_url 2020-02-26-setting-up-ci-for-this-site-with-bitbucket-pipelines-and-ssh %}).

But rsync failed with this wall of text:  
*(the project is private, so I have redacted a few details)*

    + rsync -rSlh --stats buildtar/ $user_host:$webpath/myproject
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @       WARNING: POSSIBLE DNS SPOOFING DETECTED!          @
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    The ECDSA host key for mydomain.com has changed,
    and the key for the corresponding IP address xx.xx.xx.xx
    is unknown. This could either mean that
    DNS SPOOFING is happening or the IP address for the host
    and its host key have changed at the same time.
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
    Someone could be eavesdropping on you right now (man-in-the-middle attack)!
    It is also possible that a host key has just been changed.
    The fingerprint for the ECDSA key sent by the remote host is
    SHA256:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.
    Please contact your system administrator.
    Add correct host key in /root/.ssh/known_hosts to get rid of this message.
    Offending ECDSA key in /root/.ssh/known_hosts:3
    ECDSA host key for mydomain.com has changed and you have requested strict checking.
    Host key verification failed.
    rsync: connection unexpectedly closed (0 bytes received so far) [sender]
    rsync error: unexplained error (code 255) at io.c(228) [sender=v3.13.0_rc2-264-g725ac7fb]



This sounded scary at first, but made sense after some thinking.

This project isn't deployed to *The Cloud™*, but to some old-fashioned webspace on shared hosting.  
And it isn't changed often, so the last push (with successful pipeline run!) was about a year ago.  

I vaguely remember that in the meantime, I received a maintenance info mail by my provider, announcing that they will move my account *(and probably others on the same server)* to a newer, faster server.  
That would explain why the key **and** the IP address changed at the same time.

---

## How to fix

The domain and the key's fingerprint are saved here in the repository's settings:  
`https://bitbucket.org/YOUR_WORKSPACE/YOUR_REPOSITORY/admin/addon/admin/pipelines/ssh-keys`

Below the SSH keys, there's this:

![settings](/img/bb-pipelines-ecdsa-settings.png)

In my web hoster's admin UI, where I can see the SSH keys, the current fingerprints are shown as well and the value there is indeed different than the one in the Bitbucket settings.

To "update" the Bitbucket settings, just delete the whole host address with the `X` button on the right and add it again. Bitbucket will connect to the server, determine the correct fingerprint and after that, the deploy will work again.
