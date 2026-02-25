///|
fn make_apply(f : Expr, es : @list.List[Expr]) -> Expr {
  match es {
    Empty => f
    More(e, tail~) => make_apply(App(f, e), tail)
  }
}

fn make_fun(xs : @list.List[String], e : Expr) -> Expr {
  match xs {
    Empty => e
    More(x, tail~) => Fun(x, make_fun(tail, e))
  }
}

///|
using @strconv {parse_int}

///|
priv suberror LexError {
  Unrecognized(String, Int)
} derive(Show)

///|
fn parse(s : String) -> Expr raise {
  let lexbuf = Lexbuf::from_string(s)
  let tokens = []
  while true {
    let tok = read(lexbuf)
    tokens.push(tok)
    match tok.0 {
      EOF => break
      _ => ()
    }
  }
  prog(tokens)
}
