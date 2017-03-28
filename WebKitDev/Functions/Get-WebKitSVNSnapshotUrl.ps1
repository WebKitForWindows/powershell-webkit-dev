# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Retrieves the location of WebKit's SVN snapshot.
#>
Function Get-WebKitSVNSnapshotUrl {
  return 'http://nightly.webkit.org/files/WebKit-SVN-source.tar.bz2';
}
