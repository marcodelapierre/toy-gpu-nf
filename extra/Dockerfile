FROM ubuntu:18.04

LABEL maintainer="marco.delapierre@pawsey.org.au"

RUN mkdir /apps
COPY hello_* /apps/
ENV PATH="/apps:$PATH"

CMD [ "/bin/bash" ]

