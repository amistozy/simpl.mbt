///|
test {
  let prog =
    #|letrec a k x1 x2 x3 x4 x5 =
    #|  if k <= 0 then
    #|    x4 () + x5 ()
    #|  else
    #|    let m = ref k in
    #|    letrec b = do
    #|      m := !m - 1;
    #|      a !m b x1 x2 x3 x4
    #|    in b ()
    #|in a 10 (do 1) (do -1) (do -1) (do 1) (do 0)

  let expr = parse(prog)
  let res = expr.eval(@hashmap.new())

  inspect(res, content="Int(-67)")
  inspect(expr, content=(
    #|LetRec("a", Fun("k", Fun("x1", Fun("x2", Fun("x3", Fun("x4", Fun("x5", If(Binop(Leq, Var("k"), Int(0)), Binop(Add, App(Var("x4"), Unit), App(Var("x5"), Unit)), Let("m", UniOp(Ref, Var("k")), LetRec("b", Fun("_", Let("_", Binop(Assign, Var("m"), Binop(Sub, UniOp(DeRef, Var("m")), Int(1))), App(App(App(App(App(App(Var("a"), UniOp(DeRef, Var("m"))), Var("b")), Var("x1")), Var("x2")), Var("x3")), Var("x4")))), App(Var("b"), Unit)))))))))), App(App(App(App(App(App(Var("a"), Int(10)), Fun("_", Int(1))), Fun("_", Int(-1))), Fun("_", Int(-1))), Fun("_", Int(1))), Fun("_", Int(0))))
  ))
}

