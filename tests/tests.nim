import ../sections
import unittest


suite "test SECTION macro":
    test "abc => ab, ac":
        SECTION:
            var s:string = ""
            s&="a"

            SECTION:
                s&="b"
                echo s
                check(s == "ab")

            SECTION:
                s&="c"
                echo s
                check(s == "ac")
            check( s == "ab" or s == "ac")

    test "SECTION in middle of ab, ac":
        SECTION:
            var s:string = ""
            s&="a"

            SECTION:
                SECTION:
                    s&="b"
                    echo s
                    check(s == "ab")

                SECTION:
                    s&="c"
                    echo s
                check(s == "ac")
            check( s == "ab" or s == "ac")

    test "abc, ad branches":
        SECTION:
            var s:string = ""
            s&="a"

            SECTION:
                s&="b"
                check(s == "ab")

                SECTION:
                    s&="c"
                    echo s
                    check(s == "abc")
            SECTION:
                s&="d"
                echo s
                check(s == "ad")
            check (s=="abc" or s=="ad")

suite "test SECTION aliases : GIVEN, WHEN, THEN":
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

    test "GIVEN":
        GIVEN:
            var s:string = ""
            s&="a"

            GIVEN:
                s&="b"
                check(s == "ab")

                GIVEN:
                    s&="c"
                    echo s
                    check(s == "abc")
            GIVEN:
                s&="d"
                echo s
                check(s == "ad")
            check (s=="abc" or s=="ad")

    test "WHEN":
        WHEN:
            var s:string = ""
            s&="a"

            WHEN:
                s&="b"
                check(s == "ab")

                WHEN:
                    s&="c"
                    echo s
                    check(s == "abc")
            WHEN:
                s&="d"
                echo s
                check(s == "ad")
            check (s=="abc" or s=="ad")

    test "THEN":
        THEN:
            var s:string = ""
            s&="a"

            THEN:
                s&="b"
                check(s == "ab")

                THEN:
                    s&="c"
                    echo s
                    check(s == "abc")
            THEN:
                s&="d"
                echo s
                check(s == "ad")
            check (s=="abc" or s=="ad")

    test "GIVEN, WHEN, THEN":
        GIVEN:
            var s:string = ""
            s&="a"

            WHEN:
                s&="b"
                check(s == "ab")

                THEN:
                    s&="c"
                    echo s
                    check(s == "abc")

            WHEN:
                s&="d"
                echo s
                check(s == "ad")
            check (s=="abc" or s=="ad")

