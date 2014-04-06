#!/bin/bash

uptime | sed -e "s/.*load average: //" | tr -d " " | tr "," " "
#uptime | awk '{print $10,$11,$12}'
