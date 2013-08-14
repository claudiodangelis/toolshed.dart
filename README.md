toolshed.dart
=============

Some tools based on [hop](https://github.com/kevmoo/hop.dart).

Tasks:

cla - Create a Command Line App project.

cpa - Create a Chrome Packaged App project.

pa - Create a Polymer Web App project.

wa - Create a Web App project.

xsla - Create a StageXL App project.

[![Build Status](https://drone.io/github.com/damondouglas/toolshed.dart/status.png)](https://drone.io/github.com/damondouglas/toolshed.dart/latest)

##Install:

1.  Replace `[Path to toolshed.dart]` in [hop](https://github.com/damondouglas/toolshed.dart/blob/master/hop).
2.  Make [hop](https://github.com/damondouglas/toolshed.dart/blob/master/hop) executible as described in the [hop wiki](https://github.com/kevmoo/hop.dart/wiki/Using-Hop,-Part-3:-Transform-Your-Hop-Task-Application-Into-an-Executable-to-Run-Anywhere).

##Use:

`hop [Task] [name]`

##Example:

_I want to create a Polymer Web App project called counter:_

`hop pa counter`

_All necessary files are built in the contextual directory from the command-line._

_Acknowledgements to the Polymer project example from [Dartwatch](http://blog.dartwatch.com/2013/08/translating-web-ui-x-click-counter-to.html)._
