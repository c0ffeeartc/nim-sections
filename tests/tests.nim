import ../sections
import unittest


suite "test SECTION macro":
    test "abc => ab ac":
        SECTION:
            var s:string = ""
            s&="a"

            SECTION:
                s&="b"
                check(s == "ab")

            SECTION:
                s&="c"
                check(s == "ac")

    test "Nested SECTION in middle of abc":
        SECTION:
            var s:string = ""
            s&="a"

            SECTION:
                SECTION:
                    s&="b"
                    check(s == "ab")

                SECTION:
                    s&="c"
                    check(s == "ac")


suite "test SECTION aliases : GIVEN, WHEN, THEN":
    test "For README.md":
        GIVEN:
            var s:string = ""
            s &= "a"
            WHEN:
                s &= "b"
                THEN:
                    check s=="ab"
            WHEN:
                s &= "c"
                THEN:
                    check s=="ac"

    test "GIVEN":
        var s:string = ""
        GIVEN:
            s&="a"

            GIVEN:
                s&="b"
                check(s == "ab")

                GIVEN:
                    s&="c"
                    check(s == "abc")
            GIVEN:
                s&="d"
                check(s == "ad")
        check (s=="abc" or s=="ad")

    test "WHEN":
        var s:string = ""
        WHEN:
            s&="a"

            WHEN:
                s&="b"
                check(s == "ab")

                WHEN:
                    s&="c"
                    check(s == "abc")
            WHEN:
                s&="d"
                check(s == "ad")
        check (s=="abc" or s=="ad")

    test "THEN":
        var s:string = ""
        THEN:
            s&="a"

            THEN:
                s&="b"
                check(s == "ab")

                THEN:
                    s&="c"
                    check(s == "abc")
            THEN:
                s&="d"
                check(s == "ad")
        check (s=="abc" or s=="ad")

    test "GIVEN, WHEN, THEN":
        var s:string = ""
        GIVEN:
            s&="a"

            WHEN:
                s&="b"
                check(s == "ab")

                THEN:
                    s&="c"
                    check(s == "abc")

            WHEN:
                s&="d"
                check(s == "ad")
        check (s=="abc" or s=="ad")

