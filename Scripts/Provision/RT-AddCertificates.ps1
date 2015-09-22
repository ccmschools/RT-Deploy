# Author: Scott Willett
# Version: 2015-09-22
#
# Add some trusted root certificates to the device

certutil -addstore "Root" "..\..\Resources\Certificates\dc-01-01.cer"
certutil -addstore "Root" "..\..\Resources\Certificates\dc-01-02.cer"
certutil -addstore "Root" "..\..\Resources\Certificates\app-01-01.cer"
certutil -addstore "Root" "..\..\Resources\Certificates\app-01-02.cer"