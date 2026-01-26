#!/bin/bash
# Run Flutter with filtered logs to remove Android frame noise

flutter run 2>&1 | grep -v "updateAcquireFence"
