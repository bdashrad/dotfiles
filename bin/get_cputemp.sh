#!/bin/bash
sensors | grep $1 | awk '{print $3}' | tr -d +
