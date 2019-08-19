# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Gets a remote file therough a web request.

  .Parameter Url
  The path to the file.

  .Parameter DestinationPath
  The path download to.

  .Example
    Invoke-WebFileRequest -Url https://bootstrap.pypa.io/get-pip.py -DestinationPath C:\get-pip.py.
#>
Function Invoke-WebFileRequest {
    Param(
        [Parameter(Mandatory)]
        [string] $url,
        [Parameter(Mandatory)]
        [string] $destinationPath
    )

    # See if security protocol needs to be checked
    $secure = 1;
    if ($url.StartsWith("http://")) {
        $secure = 0;
    }

    # Setup a proxy if needed
    $proxy = [System.Net.WebProxy]::GetDefaultProxy();
    $proxyServer = $proxy.Address;

    if ($proxy.Address -eq $null) {
        if ($secure) {
            if (Test-Path env:HTTPS_PROXY) {
                $proxy = New-Object System.Net.WebProxy($env:HTTPS_PROXY, $true);
            }
        } else {
            if (Test-Path env:HTTP_PROXY) {
                $proxy = New-Object System.Net.WebProxy($env:HTTP_PROXY, $true);
            }
        }
    }

    if ($secure) {
        # Store off the security protocol
        $oldSecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol;

        # Determine the security protocol required
        $securityProtocol = 0;
        $testEndpoint = [System.Uri]$url;

        if ($proxy.Address -eq $null) {
            $testEndpoint = $proxy.Address;
        }

        foreach ($protocol in 'tls12', 'tls11', 'tls') {
            $tcpClient = New-Object Net.Sockets.TcpClient;
            $tcpClient.Connect($testEndpoint.Host, $testEndpoint.Port)
    
            $sslStream = New-Object Net.Security.SslStream $tcpClient.GetStream();
            $sslStream.ReadTimeout = 15000;
            $sslStream.WriteTimeout = 15000;

            try {
                $sslStream.AuthenticateAsClient($testEndpoint.Host, $null, $protocol, $false);
                $supports = $true;
            }
            catch {
                $supports = $false;
            }

            $sslStream.Dispose();
            $tcpClient.Dispose();

            if ($supports) {
                switch ($protocol) {
                    'tls12' { $securityProtocol = ($securityProtocol -bor [System.Net.SecurityProtocolType]::Tls12) }
                    'tls11' { $securityProtocol = ($securityProtocol -bor [System.Net.SecurityProtocolType]::Tls11) }
                    'tls' { $securityProtocol = ($securityProtocol -bor [System.Net.SecurityProtocolType]::Tls) }
                }
            }
        }

        [System.Net.ServicePointManager]::SecurityProtocol = $securityProtocol;
    }

    # Download the file
    $tcpClient = New-Object System.Net.WebClient;
    $tcpClient.Proxy = $proxy;
    $tcpClient.DownloadFile($url, $destinationPath);

    if ($secure -and $oldSecurityProtocol) {
        # Restore the security protocol
        [System.Net.ServicePointManager]::SecurityProtocol = $oldSecurityProtocol;
    }
}
