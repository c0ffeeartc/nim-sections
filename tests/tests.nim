import ../sections
import unittest


suite "test Section macro":
    test "abc => ab, ac":
        Section:
            var s:string = ""
            s&="a"

            Section:
                s&="b"
                echo s
                check(s == "ab")

            Section:
                s&="c"
                echo s
                check(s == "ac")
            check( s == "ab" or s == "ac")

    test "Section in middle of ab, ac":
        Section:
            var s:string = ""
            s&="a"

            Section:
                Section:
                    s&="b"
                    echo s
                    check(s == "ab")

                Section:
                    s&="c"
                    echo s
                    check(s == "ac")
            check( s == "ab" or s == "ac")

    test "abc, ad branches":
        Section:
            var s:string = ""
            s&="a"

            Section:
                s&="b"
                check(s == "ab")

                Section:
                    s&="c"
                    echo s
                    check(s == "abc")
            Section:
                s&="d"
                echo s
                check(s == "ad")
            check (s=="abc" or s=="ad")

suite "test Section aliases : Given, When, Then":
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

    test "Given":
        Given:
            var s:string = ""
            s&="a"

            Given:
                s&="b"
                check(s == "ab")

                Given:
                    s&="c"
                    echo s
                    check(s == "abc")
            Given:
                s&="d"
                echo s
                check(s == "ad")
            check (s=="abc" or s=="ad")

    test "When":
        When:
            var s:string = ""
            s&="a"

            When:
                s&="b"
                check(s == "ab")

                When:
                    s&="c"
                    echo s
                    check(s == "abc")
            When:
                s&="d"
                echo s
                check(s == "ad")
            check (s=="abc" or s=="ad")

    test "Then":
        Then:
            var s:string = ""
            s&="a"

            Then:
                s&="b"
                check(s == "ab")

                Then:
                    s&="c"
                    echo s
                    check(s == "abc")
            Then:
                s&="d"
                echo s
                check(s == "ad")
            check (s=="abc" or s=="ad")

    test "Given, When, Then":
        Given:
            var s:string = ""
            s&="a"

            When:
                s&="b"
                check(s == "ab")

                Then:
                    s&="c"
                    echo s
                    check(s == "abc")

            When:
                s&="d"
                echo s
                check(s == "ad")
            check (s=="abc" or s=="ad")

