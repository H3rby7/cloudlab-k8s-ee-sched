# Cloudlab EE Scheduler Benchmarking Profile

Based on:  https://gitlab.flux.utah.edu/johnsond/k8s-profile

See ['kubeInstructions' of profile.py](profile.py).

# TODOs

1. Deploy and run muBench with default scheduler
2. Prometheus target that exposes pod metrics
   1. to get proper requests/limits values for the mubench cell
3. Export data from prometheus for analysis in Matlab

# Cheatsheet

adding +x permissions on windows git (for sh files)

    git update-index --chmod=+x setup-file.sh
