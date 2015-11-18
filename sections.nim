import macros


proc convert_branch_to_blocks (body:NimNode): NimNode {.compileTime.}=
    #
    # body must start with Section
    #
    # converts
    #
    #   Section:
    #       echo "A"
    #
    #       Section:
    #           echo "B"
    #
    #       Section:
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

    var bodyStmtList: NimNode = nil
    for c in body:
        if c.kind == nnkStmtList:
            bodyStmtList = c
            break
    #
    # add children, skip sections with index > 0
    #
    var sectionIdx = 0
    for c in bodyStmtList:
        if (c.kind == nnkCall or c.kind == nnkCallStrLit) and
            (toStrLit(c[0]) == newStrLitNode("Section") or
             toStrLit(c[0]) == newStrLitNode("Given")   or
             toStrLit(c[0]) == newStrLitNode("When")    or
             toStrLit(c[0]) == newStrLitNode("Then") ):
                if sectionIdx == 0:
                    blockStmt[1].add convert_branch_to_blocks(c)
                inc sectionIdx
        else:
            blockStmt[1].add(c)


proc get_left_branch_section_amts_indexes(body:NimNode): seq[(int,int)] =
    #
    # body must start with Section
    #

    var firstSectIdx:int = -1
    var sectAmt          = 0
    var curIdx           = 0

    var bodyStmtList: NimNode = nil
    for c in body:
        if c.kind == nnkStmtList:
            bodyStmtList = c
            break

    for c in bodyStmtList:
        if (c.kind == nnkCall or c.kind == nnkCallStrLit) and
            (toStrLit(c[0]) == newStrLitNode("Section") or
             toStrLit(c[0]) == newStrLitNode("Given")   or
             toStrLit(c[0]) == newStrLitNode("When")    or
             toStrLit(c[0]) == newStrLitNode("Then") ):
            if sectAmt == 0:
                firstSectIdx = curIdx
            inc sectAmt
        inc curIdx

    result = @[(sectAmt, firstSectIdx)]
    if firstSectIdx != -1:
        result.add get_left_branch_section_amts_indexes(bodyStmtList[firstSectIdx])


proc remove_sect_tail (body:NimNode): NimNode {.compileTime.}=
    #
    # body must start with Section
    #
    # converts
    #
    #   Section:
    #       echo "A"
    #
    #       Section:
    #           echo "B"
    #
    #           Section:
    #               echo "C"
    #
    #       Section:
    #           echo "D"
    #
    # to
    #
    #   Section:
    #       echo "A"
    #
    #       Section:
    #           echo "D"
    #
    result = newNimNode(nnkStmtList)

    var amtsIdxs = get_left_branch_section_amts_indexes(body)

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
    # remove Section branch
    #
    lastI = amtsIdxs.len - 1
    var curParent = body
    for i in 0..<lastI:
        curParent = curParent[1][amtsIdxs[i][1]]
    curParent[1].del(amtsIdxs[lastI][1])
    result = body


macro Section*(body: untyped): typed =
    result = newNimNode(nnkStmtList)

    #
    #  restore Section command which was removed by Section macro call
    #
    var sectStmt =  newNimNode (nnkCall)
    sectStmt.add ident("Section")
    sectStmt.add body

    #
    #
    #
    result.add convert_branch_to_blocks(sectStmt)
    result.add remove_sect_tail(sectStmt)


template Given*(body: untyped): untyped = Section(body)
template When* (body: untyped): untyped = Section(body)
template Then* (body: untyped): untyped = Section(body)


when isMainModule:
    Section:
        var s:string = ""
        echo "a"
        s&="a"

        Section:
            echo "b"
            s&="b"

        Section:
            echo "c"
            s&="c"
        echo s

