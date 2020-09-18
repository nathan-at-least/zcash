# nix-builder

## current status

completely unusable exploratory work-in-progress

## next step

Current problem is the "hashbang" issue.

Two approaches:

- monkey patching tar (yikes!)
- "sandbox paths":

```
zecnate 16:21:50
I think that means I need to do open-source ticket penance and close at least two other open tickets. ;-)
clever: Ok. That sounds like something to look into!
Gotta run for now, but I'll make a note of that. (I'm totally unfamiliar with `nix.conf` or how the sandbox works.)
Graypup_: Thanks!
clever 16:22:51
zecnate: you can use `--option sandbox-paths "paths"` to set it manually on a per-build basis
zecnate 16:23:13
Thanks!
```
