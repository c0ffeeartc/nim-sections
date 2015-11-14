import macros

# macro debug(c: varargs[expr]): stmt =
#   result = newNimNode(nnkStmtList, c)
#   for i in 0..c.len-1:
#     # add a call to the statement list that writes the expression;
#     # `toStrLit` converts an AST to its string representation:
#     result.add(newCall("write", newIdentNode("stdout"), toStrLit(c[i])))
#     # add a call to the statement list that writes ": "
#     result.add(newCall("write", newIdentNode("stdout"), newStrLitNode(": ")))
#     # add a call to the statement list that writes the expressions value:
#     result.add(newCall("writeLine", newIdentNode("stdout"), c[i]))

# var
#   a: array[0..10, int]
#   x = "some string"
# a[0] = 42
# a[1] = 45

#block A:
#    discard
#    block B:
#        block A:
#            discard
# var c =0
# debug(a[0], a[1], x)
#macro SECT(body:stmt): stmt =
#    result = newNimNode(nnkStmtList)
#    for i in 0..<body.len:
#        if body[i].kind == nnkCommand:
#            result.add body[i]
#        elif body[i].kind == nnkBlockStmt:
#            result_inner )
#        discard

#proc preorder(node)
#    if node == null then return
#    visit(node)
#    preorder(node.left)
#    preorder(node.right)



macro some(str:string; body: untyped): stmt =
    result = newNimNode(nnkStmtList)
    #dumpTree(body)
    #treeRepr(body) -> str
    ##echo treeRepr(body)
    #echo str
    for i in 0..<body.len:
        #echo "body ", body[i].kind, " ", toStrLit body[i]
        #if body[i].kind == nnkVarSection:
        #   let myVar = newLetStmt(body[i].name, body[i].value)
        if body[i].kind == nnkVarSection:
            for c in body[i]:
                #echo "VAR: ", treeRepr(c)
                result.add(
                    newNimNode(nnkLetSection).add(
                        newNimNode(nnkIdentDefs).add(c[0], newEmptyNode(), c[2])))
        else:
            result.add body[i]
            #echo toStrLit(body[i])
            #for j in 0..<body[i].len:
            #    if body[i][j].kind == nnkBlockStmt:
            #        #echo "inner block", body[i][j].kind
            #        result.add body[i]
    echo "RESULT: ", treeRepr(result)
    #echo counter
    #echo "myVar ",  myVar

when isMainModule:
    some("test addition"):
        var a = 0
        block TEST_CASE:
            echo a
#            block TEST_CASE:
#                a += 5
#        block TEST_CASE:
#            a += 10
#            block TEST_CASE:
#                a += 10
