FROM mcr.microsoft.com/windows/servercore/iis

LABEL maintainer="chebishev@softuni.bg"

RUN powershell -NoProfile -Command Remove-Item -Recurse C:\inetpub\wwwroot\*

WORKDIR /inetpub/wwwroot

COPY web/ .