# nim-sections


Provides `Section` macro and its `Given`, `When`, `Then` aliases. Nested `Section` blocks are converted into separate local branches of execution.
Inspired by [C++ Catch Test Framework sections](https://github.com/philsquared/Catch/blob/master/docs/tutorial.md#test-cases-and-sections)


## Installation

`nimble install sections`

## Example


Following

```
Section:
    var s = ""
    s &= "a"
    Section:
        s &= "b"
    Section:
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
    Given:
        var s:string = ""
        s &= "a"
        When:
            s &= "b"
            Then:
                echo s
                check s=="ab"
        When:
            s &= "c"
            Then:
                echo s
                check s=="ac"
```
## Tested with

  - nim v 0.12


## ToDo
  - allow optional string argument
  - current implementation works only when `Section` blocks are in direct parent/child structures, deep nesting support is planned in future

