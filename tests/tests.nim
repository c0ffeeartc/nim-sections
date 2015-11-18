import ../sections
import unittest


suite "test SECTION macro":
    test "abc => ab ac":
        SECTION:
            var s:string = ""
            s&="a"

            SECTION:
                s&="b"
                require(s == "ab")

            SECTION:
                s&="c"
                require(s == "ac")

    test "Nested SECTION in middle of abc":
        SECTION:
            var s:string = ""
            s&="a"

            SECTION:
                SECTION:
                    s&="b"
                    require(s == "ab")

                SECTION:
                    s&="c"
                    require(s == "ac")
