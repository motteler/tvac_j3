#!/bin/sh
#
# copy figfiles from tvac_j3 on asl
#
# slightly dangerous as it works by explicitly excluding 
# everything but fig files.  add "-n" for a dry run.
#

rsync -av $* ../tvac_j3/ \
  --exclude .git \
  --exclude focal_fit \
  --exclude gas_calcs \
  --exclude inst_data \
  --exclude sergio \
  --exclude source \
  --exclude *.mat \
  --exclude *.m \
  --exclude *.m~ \
  --exclude *.png \
  --exclude *.tar \
  --exclude *.dat \
  --exclude *.sh \
  --exclude *.sh~ \
  --exclude *.txt \
  --exclude *.txt~ \
   motteler.dyndns.org:asl/tvac_j3

