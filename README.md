# nim-sections


Provides `SECTION` macro and its `GIVEN`, `WHEN`, `THEN` aliases. Nested `SECTION` blocks are converted into separate local branches of execution.
Inspired by [C++ Catch Test Framework sections](https://github.com/philsquared/Catch/blob/master/docs/tutorial.md#test-cases-and-sections)


## Example


Following

```
SECTION:
    var s = ""
    s &= "a"
    SECTION:
        s &= "b"
    SECTION:
        s &= "c"
    echo s
```
Will be converted to
```
block:
    var s = ""
    s &= "a"
    block:
        s &= "b"
    echo s

block:
    var s = ""
    s &= "a"
    block:
        s &= "c"
    echo s
```

BDD style example
```
import unittest
import sections

test "For README.md":
    GIVEN:
        var s:string = ""
        s &= "a"
        WHEN:
            s &= "b"
            THEN:
                echo s
                check s=="ab"
        WHEN:
            s &= "c"
            THEN:
                echo s
                check s=="ac"
```
## Tested with

  - nim v 0.12


## ToDo
  - provide `GIVEN`, `WHEN`, `THEN` aliases
  - allow optional string argument
  - current implementation works only when `SECTIONS` are in direct parent/child structures, deep nesting support is planned in future

