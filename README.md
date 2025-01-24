# Cloudlab EE Scheduler Benchmarking Profile

Based on:  https://gitlab.flux.utah.edu/johnsond/k8s-profile

See ['kubeInstructions' of profile.py](profile.py).

# TODOs

1. Deploy and run muBench with default scheduler
   1. manually - CHECK
   2. automated (via dataset maybe?)
2. Export data from prometheus for analysis in Matlab

# Cheatsheet

adding +x permissions on windows git (for sh files)

   git update-index --chmod=+x setup-file.sh

## Grafana Dashboards

Export JSON from Web-GUI and minify using two regexp replacements onto the string:

`^\s+` with `<nothing>` and `\n` with `<nothing>`
