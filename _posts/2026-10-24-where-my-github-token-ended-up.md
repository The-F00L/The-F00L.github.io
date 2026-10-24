---
title: "Where my GitHub token ended up"
date: 2026-10-24
categories: [ai]
tags: [claude, github, cloudflare, security]
excerpt: "A late-night GitHub stars app, a backend I said I didn't want, and a token I almost left lying around."
---

I have a couple hundred starred repos on GitHub, and GitHub's view of them is basically a flat pile. You can sort it and filter it a bit, but if I want to find that one CLI tool I starred months ago, or see which of my stars are already dead, it's digging. Lists help a little, but there's no place for my own notes, no proper overview, and no nice way to share a list. You can copy the URL and send it over, but that doesn't look that nice.

So it was a late night, I wanted to send one of my lists to a friend, and that was the last straw. I was like: "Hm... let's burn some tokens and build a better way to catalog my stars, with a share link on top!" I opened [Stitch](https://stitch.withgoogle.com/), gave it a short prompt, and voila, I had a design. Funny enough, it looks AI-generated, but for a small tool like this I'm fine with that. I'm not a huge fan of frontend development or UI/UX design, so that's a huge help for me, especially because I try to stay in the terminal as long as possible. In a terminal there are no distractions, you just do your job.

I gave Opus the design and one rule: frontend only, no backend. It built the app, StarVault, in like 30-35 minutes, with a few rounds of back and forth to fix things. But it also added a feature I never asked for: support for a GitHub personal access token, in an app that was supposed to be frontend only. I removed it, so now you only need your GitHub username.

Okay, I have to admit, there's a small backend after all. Without a token, GitHub only lets you make 60 requests per hour, and syncing stars plus opening READMEs and releases eats through that fast. I hit that limit myself while testing. And Lists are only available through GitHub's GraphQL API, which always needs a token. So there's a tiny read-only proxy on Cloudflare, with a token that has no permissions, six fixed routes, and some caching. And to be honest, this wasn't my idea. Opus ran into these limits, made the call, and explained it to me. So much for my "no backend" rule.

At first I was fine with that explanation. No permissions, worst case someone reads public data. Then it hit me: "Wait. If that's my token, can't someone just abuse it with too many requests?" And yes, they can. Not to steal anything, but to burn through the request limit, and that limit belongs to my whole GitHub account, not just this tool. Someone spamming the proxy could rate-limit my own scripts and CLI for an hour. So we added three safeguards. The token now belongs to a separate machine account, so abuse can only drain that one. Every IP gets a request limit. And the proxy watches GitHub's rate-limit headers and stops using the token before it runs out, so visitors fall back to their own limit instead. The per-IP limit even made me move from Cloudflare Pages to a Worker, because on Pages it needed a custom domain, and I don't have one.

However, one thing was missing. The public site only sees my public stars and public Lists, because it runs on that separate machine account. For my private ones I need my own token, so I would have to put my token up on Cloudflare, and anyone else who wanted to use it would need to put their token into a browser session, which sounds like a very, very bad idea. So what now? Dump the idea and flush it down the toilet?

Well, no. It just needed splitting: one app with two versions, one for Cloudflare and one self-hosted. The self-hosted version uses a simple SQLite file to store stuff, and with my fine-grained token I can use it normally, but the Cloudflare one has none of these. On Cloudflare you simply enter your username, and your public stars and public Lists appear. The downside is that your own collections live only in your browser, but you can still share any collection with a snapshot link. The self-hosted version syncs between devices because of the database, so I can freely use it as is.

Now, this raises a question... How can I share a collection I created locally with someone through StarVault? This is the easy part: simply set an environment variable to the Cloudflare instance's URL, so when you copy a snapshot link, it uses that address, and you can easily share it with anyone.

Everything else works the same, the only differences are the capabilities and the data stored. You can download a backup from the public site anytime and move it to the self-hosted one.

Looking back, the token feature touches something outside of development: security. Would it be a good idea to store a PAT in the browser? Definitely not, and this leads to my observation about the age of AI. You need broader knowledge, because now you're making decisions that in the past were out of your scope, so you need at least basic knowledge outside of your expertise. But what if you just ask AI about them? Well, it might get it right, or not. Without knowing the basic concepts of that field, you could easily miss something.

If you want a better way to look at your own stars, it's available here: [StarVault](https://starvault.thezero-thef00l.workers.dev/)
