#! /usr/bin/env bash
# Nuke the configs for perishable browser and email profiles

for profile_d in ~/.mozilla/firefox/*.vanilla
do
  [[ -d "$profile_d" ]] || continue
  trash "$profile_d" && mkdir -p "$profile_d"
done
