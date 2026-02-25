# amistozy/simpl

示例见 `simpl_wbtest.mbt`

**man or boy test:**

```ocaml
letrec a k x1 x2 x3 x4 x5 =
  if k <= 0 then
    x4 () + x5 ()
  else
    let m = ref k in
    letrec b = do
      m := !m - 1;
      a !m b x1 x2 x3 x4
    in b ()
in a 10 (do 1) (do -1) (do -1) (do 1) (do 0)
```

