# TEMPORARY FILE - added only to verify the Trivy PR check catches issues.
# Safe to delete once the scan has been confirmed to fail.
# This Dockerfile intentionally contains a HIGH-severity misconfiguration
# (the container runs as root: no USER instruction) which Trivy flags as AVD-DS-0002.

FROM ubuntu:latest

RUN apt-get update && apt-get install -y curl

ADD https://example.com/app.tar.gz /app/

CMD ["/app/run.sh"]
