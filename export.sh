#!/bin/bash

# This script automates the export process using GIMP.
# It defines the GIMP executable to be used and pipes the contents of the export.scm script to GIMP for execution.
# The script runs GIMP in non-interactive mode to execute the batch commands defined in export.scm.

# GIMP: The GIMP executable to be used for the export process.
# The script reads the export.scm file and executes it using GIMP in non-interactive mode.

GIMP="gimp-2.10"

cat export.scm | $GIMP -i -b -
