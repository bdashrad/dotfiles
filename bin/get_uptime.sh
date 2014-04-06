#!/bin/bash

uptime | sed -e "s/.* up *\(.*\), *.* users, .*/\1/"
