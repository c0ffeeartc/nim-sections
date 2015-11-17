import macros


proc CONVERT_BRANCH_TO_BLOCKS (body:NimNode): NimNode {.compileTime.}=
    #
    # body must start with SECTION
    # body[1] must be stmtList
    #
    # converts
    #
    #   SECTION:
    #       echo "A"
    #
    #       SECTION:
    #           echo "B"
    #
    #       SECTION:
    #           echo "C"
    #
    # to
    #
    #   block:
    #       echo "A"
    #       block:
    #           echo "B"
    #

    var blockStmt =  newNimNode (nnkBlockStmt)
    blockStmt.add ident("NIM__SECTION")
    blockStmt.add newNimNode(nnkStmtList)
    result = blockStmt

    #
    # add children, skip sections with index > 0
    #
    var sectionIdx = 0
    for c in body[1]:
        case c.kind
        of nnkCall:
            if toStrLit(c[0]) == newStrLitNode("SECTION"):
                if sectionIdx == 0:
                    blockStmt[1].add CONVERT_BRANCH_TO_BLOCKS(c)
                inc sectionIdx
        else:
            blockStmt[1].add(c)


proc GET_LEFT_BRANCH_SECTION_AMTS_INDEXES(body:NimNode): seq[(int,int)] =
    #
    # body must start with SECTION
    # body[1] must be stmtList
    #

    var firstSectIdx:int = -1
    var sectAmt          = 0
    var curIdx           = 0

    for c in body[1]:
        if c.kind == nnkCall and toStrLit(c[0]) == newStrLitNode("SECTION"):
            if sectAmt == 0:
                firstSectIdx = curIdx
            inc sectAmt
        inc curIdx

    result = @[(sectAmt, firstSectIdx)]
    if firstSectIdx != -1:
        result.add GET_LEFT_BRANCH_SECTION_AMTS_INDEXES(body[1][firstSectIdx])


proc REMOVE_SECT_TAIL (body:NimNode): NimNode {.compileTime.}=
    #
    # body must start with SECTION
    # body[1] must be stmtList
    #
    # converts
    #
    #   SECTION:
    #       echo "A"
    #
    #       SECTION:
    #           echo "B"
    #
    #           SECTION:
    #               echo "C"
    #
    #       SECTION:
    #           echo "D"
    #
    # to
    #
    #   SECTION:
    #       echo "A"
    #
    #       SECTION:
    #           echo "D"
    #
    result = newNimNode(nnkStmtList)

    var amtsIdxs = GET_LEFT_BRANCH_SECTION_AMTS_INDEXES(body)

    if amtsIdxs.len == 0:
        return
    #
    # remove tail indexes
    #
    var lastI = amtsIdxs.len - 1
    for i in 0..lastI:
        var j = lastI - i
        if amtsIdxs[j][0] == 0 or amtsIdxs[j][0] == 1:
            amtsIdxs.del (j)
        else:
            break

    if amtsIdxs.len == 0:
        return

    #
    # remove SECTION branch
    #
    lastI = amtsIdxs.len - 1
    var curParent = body[1]
    for i in 0..<lastI:
        curParent = body[amtsIdxs[i][1]]
    curParent.del(amtsIdxs[lastI][1])
    result = body


macro SECTION*(body: untyped): typed =
    result = newNimNode(nnkStmtList)

    #
    #  restore SECTION command which was removed by SECTION macro call
    #
    var sectStmt =  newNimNode (nnkCall)
    sectStmt.add ident("SECTION")
    sectStmt.add body

    #
    #
    #
    result.add CONVERT_BRANCH_TO_BLOCKS(sectStmt)
    result.add REMOVE_SECT_TAIL(sectStmt)


when isMainModule:
    SECTION:
        var s:string = ""
        echo "a"
        s&="a"

        SECTION:
            echo "b"
            s&="b"

        SECTION:
            echo "c"
            s&="c"
        echo s

