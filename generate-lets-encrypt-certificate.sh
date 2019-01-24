#!/usr/bin/env bash
export $(grep -v '^#' .env | xargs -d '\n')

[[ "$ONEZONE_DOMAIN" == "" ]] && echo "ERROR: Set \$ONEZONE_DOMAIN in .env" && exit 1
[[ "$YOUR_EMAIL_ADDRESS" == "" ]] && echo "ERROR: Set \$YOUR_EMAIL_ADDRESS in .env" && exit 1

echo "Generating Let's Encrypt Certificate"
docker run -ti --rm  --net=host -v /etc/letsencrypt:/etc/letsencrypt webdevops/certbot \
  /usr/bin/certbot certonly --standalone --agree-tos -m "$YOUR_EMAIL_ADDRESS" -d "$ONEZONE_DOMAIN"

