#!/bin/bash
sed 's/\/dat\//\//;s/$/\/matlab\/conv.M1.union.mat/' fileList | xargs ls 2>/dev/null
