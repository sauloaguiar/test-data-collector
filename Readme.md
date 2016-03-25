# Test Data Collector

## Objective

  This project aims to collect test data of open source repos.
  Right now, the focus is to track Scala based projects that can be covered using [Scoverage](https://github.com/scoverage/sbt-scoverage).


## Projects Being Tracked

  This initial list was compiled using [CodeTriage](http://www.codetriage.com/) as the main source.

| Project               |            Build ok?             | Scoverage?  |
| :----------------------------------------------------------: |:--:|:--:|
| [Scalariform](https://github.com/scala-ide/scalariform)      | ok | ok |
| [GitBucket](https://github.com/gitbucket/gitbucket)          | ok | ok |
| [Breeze](https://github.com/scalanlp/breeze)                 | ok | ok |
| [Cats](https://github.com/typelevel/cats)                    | ok | no |
| [Eventuate](https://github.com/RBMHTechnology/eventuate)     | ok | no |
| [Algebird](https://github.com/twitter/algebird)              | ok | no |


## Known Issues

  + Check if the plugins.sbt file already has the scoverage dependency
  + Append the scoverage dependency to the plugins.sbt file (the >> shell operator is not displaying the expected behavior in some cases)
  + As the coverage plugin is being added on the fly, the coverage might be affected as non testable classes are not removed from the report.
  + The repo must be at it's most recent sha1 before the script execution 
  + Whenever some test execution halt, the whole process halts. Need a workaround - a timer or something to overcome this
