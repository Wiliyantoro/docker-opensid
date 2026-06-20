#!/bin/bash
set -e

# Render template to actual config
envsubst < /etc/apache2/sites-available/opensid.conf.template > /etc/apache2/sites-available/opensid.conf

# Execute passed command (apache2-foreground)
exec "$@"
