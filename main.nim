#template SECTION(body:stmt):stmt =
#    body

macro SECTION(body: stmt): stmt = 
    body

block:
    var s:string = ""
    SECTION:
        s&="a"
        SECTION:
            s&="b"
        SECTION:
            s&="c"
    echo s
# assert(s=="abac")

