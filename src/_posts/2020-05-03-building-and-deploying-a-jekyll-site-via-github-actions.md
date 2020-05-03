---
layout: post
title: "Building and deploying a Jekyll site via GitHub Actions"
date: 2020/05/03 20:30:00
tags:
- ci
- jekyll
- ssh
codeproject: 1
---

Until now, the source code of my blog was on Bitbucket, and on each commit the site was build with Jekyll and then deployed via `rsync` over SSH to my webspace, all with Bitbucket Pipelines.

Recently, I moved the repo to GitHub...because it was in a Mercurial repository and Bitbucket will drop support for Mercurial in a few weeks. I decided to move the repo to GitHub, and learn how to set up the same build/deploy with GitHub Actions.

Like the previous post, [where I explained how I set this up with Bitbucket Pipelines]({% post_url 2020-02-26-setting-up-ci-for-this-site-with-bitbucket-pipelines-and-ssh %}), this is the tutorial I wish I had.

---

## What I already had

Most of the "logic" of building and deploying this site already was in two shell scripts. It goes like this:

- `ci-build.sh` ([source](https://github.com/christianspecht/blog/blob/51f41fbdcf5d5a5f12e10e539fce66745c644fae/ci-build.sh)):
    - runs on the CI server
    - executes Jekyll to build the site (and expects to run in an environment with a pre-existing working Jekyll installation!)
    - saves the result to a `.tar.gz` archive
- The CI server copies the archive via `rsync` over SSH to a temp folder on my webspace
- `ci-deploy.sh` ([source](https://github.com/christianspecht/blog/blob/51f41fbdcf5d5a5f12e10e539fce66745c644fae/ci-deploy.sh)):
    - is executed by the CI server **via SSH directly on my webspace (not on the CI server!)**
    - unpacks the archive into another temp folder and rsyncs this to the folder where my domain points to

For a more thorough explanation (and annotated versions of the scripts that explain what each line does), read [the first post]({% post_url 2020-02-26-setting-up-ci-for-this-site-with-bitbucket-pipelines-and-ssh %}).

The shell scripts exist so that I can re-use them when switching CI providers...so for the migration to GitHub Actions I didn't need to change them at all, I just needed to replace the provider-specific settings file which "calls" the scripts.

The existing [YAML file for Bitbucket](https://github.com/christianspecht/blog/blob/51f41fbdcf5d5a5f12e10e539fce66745c644fae/bitbucket-pipelines.yml) was pretty straightforward:

Step 1: Use the [`jekyll/builder` Docker image](https://hub.docker.com/r/jekyll/builder/) to run `ci-build.sh` and save the `build` directory as an artifact  

Step 2: rsync the artifact from step 1 to the webserver and execute `ci-deploy.sh` on the server

Both parts are quite short, because Bitbucket Pipelines does a lot of plumbing in the background:

- For Docker, I just need to provide the name of the image 
- For SSH, I don't need to set up anything at all, just save my key in Bitbucket's UI - everything else is handled automagically in the background.

---

## Creating the same with Github Actions

In the end I got it to work - but compared to Bitbucket Pipelines, doing the same steps in GitHub Actions feels "unpolished" (more on that later).

### a) Building the Jekyll site

This was pretty straightforward, except that GH Actions doesn't just let you specify the name of any Docker image which then executes the build...there are only "default" Windows/Linux/Mac virtual machines available.

I didn't want to script the installation of Jekyll on that machine manually, so I googled for examples with the `jekyll/builder` Docker image and found the solution in [GH Actions' starter workflows repository](https://github.com/actions/starter-workflows/blob/8beb802437927d71bbb91605d15491672edf222a/ci/jekyll.yml):

    steps:
    - uses: actions/checkout@v2
    - name: Build the site in the jekyll/builder container
      run: |
        docker run \
        -v ${{ github.workspace }}:/srv/jekyll -v ${{ github.workspace }}/_site:/srv/jekyll/_site \
        jekyll/builder:latest /bin/bash -c "chmod 777 /srv/jekyll && jekyll build --future"
        
I just needed to add the call to `ci-build.sh` and select the correct Jekyll version, so I changed the `docker run` lines like this:

      run: |
        docker run \
        -v ${{ github.workspace }}:/srv/jekyll -v ${{ github.workspace }}/_site:/srv/jekyll/_site \
        jekyll/builder:3.2.1 /bin/bash -c "chmod +x ci-build.sh && ./ci-build.sh"

*(note: 3.2.1 is the correct Jekyll version **for me**, because it matches the portable Jekyll version I'm using locally on my Windows machine, see the explanation in [the first post]({% post_url 2020-02-26-setting-up-ci-for-this-site-with-bitbucket-pipelines-and-ssh %}))*

This *looks* slightly more complex than its Bitbucket counterpart...but on the other hand, I didn't have to come up with this call by myself, I copied & pasted the result in both cases, Bitbucket and GitHub.
        
---
        
### b) Connecting via SSH to my server and deploy

This took me a long time and a lot of hair-pulling. I'm no SSH expert, and as mentioned above, Bitbucket Pipelines "protected" me from most of it, especially correctly setting up the key on the build machine.

For GH Actions, there are a lot of actions made by the community [that](https://github.com/marketplace/actions/ssh-remote-commands) [do](https://github.com/marketplace/actions/webfactory-ssh-agent) [SSH](https://github.com/marketplace/actions/install-ssh-key) [stuff](https://github.com/marketplace/actions/rsync-deployments).

I tried all of them, but couldn't get anything to work, I always got "Host key verification failed" errors.

Finally I [found this solution](https://github.com/symfony/cli/issues/227#issuecomment-601680974):

    - name: "Prepare SSH key and known hosts"
      run: |
        mkdir -p ~/.ssh
        echo "${{ secrets.SSH_KEY_PRIVATE }}" > ~/.ssh/id_rsa
        chmod 600 ~/.ssh/id_rsa
        ssh-keyscan github.com >> ~/.ssh/known_hosts
        ssh-keyscan git.eu.s5y.io >> ~/.ssh/known_hosts

I had tried other similar "manual" solutions that saved the key in a file and executed `ssh-keyscan`...but the syntax and/or the commands were always slightly different, and this one did finally work for me. Here are my modified steps based on this:

    - name: "Prepare SSH key and known hosts"
      run: |
        mkdir -p ~/.ssh
        echo "${{ secrets.KEY }}" > ~/.ssh/id_rsa
        chmod 600 ~/.ssh/id_rsa
        ssh-keyscan ${{ secrets.HOST }} >> ~/.ssh/known_hosts
    - name: Run deploy script
      run: |
        rsync -rSlh --stats build/ ${{ secrets.USERNAME }}@${{ secrets.HOST }}:${{ secrets.WEBPATH }}/tar
        ssh -o StrictHostKeyChecking=yes ${{ secrets.USERNAME }}@${{ secrets.HOST }} 'bash -s' -- < build/ci-deploy.sh ${{ secrets.WEBPATH }}
        
Of course, some variables must be saved in the repo's secrets (`https://github.com/USER/REPO/settings/secrets`):

![secrets](/img/gh-actions-secrets.png)

- `KEY` : my private SSH key
- `HOST` : `christianspecht.de` *(so actually it's not a secret...)*
- `USERNAME` : the SSH username on my webspace
- `WEBPATH` : the full path on the webspace, something like `/www/htdocs/MY_ACCOUNT_NAME/blog`

---

## Complete solution

So that was it - here's [the complete working `ci.yml`](https://github.com/christianspecht/blog/blob/51f41fbdcf5d5a5f12e10e539fce66745c644fae/.github/workflows/ci.yml):

    name: Jekyll site CI

    on:
      push:
        branches:    
          - master   

    jobs:
      build_job:
        runs-on: ubuntu-latest
        steps:
        - uses: actions/checkout@v2
        - name: Build site
          run: |
            docker run \
            -v ${{ github.workspace }}:/srv/jekyll -v ${{ github.workspace }}/_site:/srv/jekyll/_site \
            jekyll/builder:3.2.1 /bin/bash -c "chmod +x ci-build.sh && ./ci-build.sh"
        - name: Upload artifact
          uses: actions/upload-artifact@v1
          with:
            name: build
            path: build
            
      deploy:
        runs-on: ubuntu-latest
        needs: build_job
        steps:
        - uses: actions/download-artifact@v1
          with:
            name: build
        - name: "Prepare SSH key and known hosts"
          # https://github.com/symfony/cli/issues/227#issuecomment-601680974
          run: |
            mkdir -p ~/.ssh
            echo "${{ secrets.KEY }}" > ~/.ssh/id_rsa
            chmod 600 ~/.ssh/id_rsa
            ssh-keyscan ${{ secrets.HOST }} >> ~/.ssh/known_hosts
        - name: Run deploy script
          run: |
            rsync -rSlh --stats build/ ${{ secrets.USERNAME }}@${{ secrets.HOST }}:${{ secrets.WEBPATH }}/tar
            ssh -o StrictHostKeyChecking=yes ${{ secrets.USERNAME }}@${{ secrets.HOST }} 'bash -s' -- < build/ci-deploy.sh ${{ secrets.WEBPATH }}

---

## Bonus: Showing the commit ID / build number in the footer

After everything worked, I decided to add a "Built from commit xyz with build number 123" line in the site's footer.

From a Jekyll point of view, this is pretty easy. It's just:

- adding a new site variable for the commit id (with a dummy value) in the main `_config.yml`, and displaying its content somewhere on the site
- at build time, create an additional `_config-github.yml` with the actual commit ID on the fly, and pass it to the Jekyll call after the original config file (so the commit id overrides the one from the main config file)
- The actual commit ID comes from an environment variable which is set by the build runner, for GitHub Actions [it's `$GITHUB_SHA` which contains the commit ID](https://help.github.com/en/actions/configuring-and-managing-workflows/using-environment-variables#default-environment-variables).

[Here's the commit with those changes](https://github.com/christianspecht/blog/commit/faa3ab6ba46fe1c6c83034df750cab33ca510f3b) - but it didn't work as-is. The build was successful, but the commit ID in the finished site was empty.

Turns out that the culprit was the fact that I'm running the build inside a Docker container. The actual GitHub Actions "runner" *(the virtual Ubuntu machine that runs the whole action)* knows about the environment variables, but it doesn't automatically pass them to the Docker container I'm using *(which actually builds the Jekyll site)*.

The solution was [passing the variable directly to `ci-build.sh` in the line where I'm executing Docker](https://github.com/christianspecht/blog/commit/9d18f4799b61a1c4c0f0a4249c916fade352e66e).
