#!/bin/bash

docker run -it -dp 389:389 -e SLAPD_PASSWORD=Welcome123 -e SLAPD_DOMAIN=ad.smartcolumbusos.com dinkel/openldap
