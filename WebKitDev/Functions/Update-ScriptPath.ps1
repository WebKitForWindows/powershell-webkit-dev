# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Updates the `env:PATH` variable to the current machine's value.

  .Description
  Updates the environment path for the script's execution. This is useful to
  run after any installers complete so any new system paths are present.
#>
function Update-ScriptPath {
    $env:PATH = [Environment]::GetEnvironmentVariable('PATH',[EnvironmentVariableTarget]::Machine);
}
