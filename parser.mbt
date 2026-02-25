
pub(all) enum Token {
  INT(Int)
  ID(String)
  TRUE
  FALSE
  LEQ
  TIMES
  PLUS
  SUB
  LPAREN
  RPAREN
  LET
  LETREC
  EQUALS
  ASSIGN
  IN
  IF
  THEN
  ELSE
  FUN
  ARROW
  SEMI
  REF
  DEREF
  DO
  EOF
} derive(Show)

pub fn Token::kind(self : Token) -> TokenKind {
  match self {
    INT(_) => TK_INT
    ID(_) => TK_ID
    TRUE => TK_TRUE
    FALSE => TK_FALSE
    LEQ => TK_LEQ
    TIMES => TK_TIMES
    PLUS => TK_PLUS
    SUB => TK_SUB
    LPAREN => TK_LPAREN
    RPAREN => TK_RPAREN
    LET => TK_LET
    LETREC => TK_LETREC
    EQUALS => TK_EQUALS
    ASSIGN => TK_ASSIGN
    IN => TK_IN
    IF => TK_IF
    THEN => TK_THEN
    ELSE => TK_ELSE
    FUN => TK_FUN
    ARROW => TK_ARROW
    SEMI => TK_SEMI
    REF => TK_REF
    DEREF => TK_DEREF
    DO => TK_DO
    EOF => TK_EOF
  }
}

pub(all) enum TokenKind {
  TK_INT
  TK_ID
  TK_TRUE
  TK_FALSE
  TK_LEQ
  TK_TIMES
  TK_PLUS
  TK_SUB
  TK_LPAREN
  TK_RPAREN
  TK_LET
  TK_LETREC
  TK_EQUALS
  TK_ASSIGN
  TK_IN
  TK_IF
  TK_THEN
  TK_ELSE
  TK_FUN
  TK_ARROW
  TK_SEMI
  TK_REF
  TK_DEREF
  TK_DO
  TK_EOF
}

pub impl Show for TokenKind with output(self, logger) {
  logger.write_string(
    match self {
      TK_INT => "INT"
      TK_ID => "ID"
      TK_TRUE => "TRUE"
      TK_FALSE => "FALSE"
      TK_LEQ => "\"<=\""
      TK_TIMES => "\"*\""
      TK_PLUS => "\"+\""
      TK_SUB => "\"-\""
      TK_LPAREN => "\"(\""
      TK_RPAREN => "\")\""
      TK_LET => "LET"
      TK_LETREC => "LETREC"
      TK_EQUALS => "\"=\""
      TK_ASSIGN => "\":=\""
      TK_IN => "IN"
      TK_IF => "IF"
      TK_THEN => "THEN"
      TK_ELSE => "ELSE"
      TK_FUN => "FUN"
      TK_ARROW => "\"->\""
      TK_SEMI => "\";\""
      TK_REF => "REF"
      TK_DEREF => "\"!\""
      TK_DO => "DO"
      TK_EOF => "EOF"
    }
  )
}

pub suberror ParseError {
  UnexpectedToken(Token, (Int, Int), Array[TokenKind])
  UnexpectedEndOfInput(Int, Array[TokenKind])
} derive(Show)

type YYObj = Error

priv suberror YYObj_Void

priv suberror YYObj_Int {
  YYObj_Int(Int)
}

priv suberror YYObj_Expr {
  YYObj_Expr(Expr)
}

priv suberror YYObj_String {
  YYObj_String(String)
}

priv suberror YYObj__list_List_Expr_ {
  YYObj__list_List_Expr_(@list.List[Expr])
}

priv suberror YYObj__list_List_String_ {
  YYObj__list_List_String_(@list.List[String])
}

type YYState = (YYSymbol) -> YYDecision

type YYAction = (Int, ArrayView[(YYObj, Int, Int)]) -> YYObj

priv enum YYDecision {
  Accept
  Shift(YYState)
  Reduce(Int, YYSymbol, YYAction)
  ReduceNoLookahead(Int, YYSymbol, YYAction)
  Error
}

priv enum YYSymbol {
  T_INT
  T_ID
  T_TRUE
  T_FALSE
  T_LEQ
  T_TIMES
  T_PLUS
  T_SUB
  T_LPAREN
  T_RPAREN
  T_LET
  T_LETREC
  T_EQUALS
  T_ASSIGN
  T_IN
  T_IF
  T_THEN
  T_ELSE
  T_FUN
  T_ARROW
  T_SEMI
  T_REF
  T_DEREF
  T_DO
  T_EOF
  NT_prog
  NT_expr
  NT_simpl_expr
  NT_params
  NT_args
  EOI
}

// Workaround for EOI unused warning
fn init {
  match (EOI : YYSymbol) {
    EOI => ()
    _ => ()
  }
}

// file:///./parser.mbty
// 45|   e = expr EOF { e }
fn yy_action_0(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[0].0 is YYObj_Expr(e)
  YYObj_Expr({();  e })
}

// file:///./parser.mbty
// 71|   "(" e = expr ")"		{ e }
fn yy_action_1(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[1].0 is YYObj_Expr(e)
  YYObj_Expr({();  e })
}

// file:///./parser.mbty
// 63|   DO e = expr											{ Fun("_", e) }
fn yy_action_2(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[1].0 is YYObj_Expr(e)
  YYObj_Expr({();  Fun("_", e) })
}

// file:///./parser.mbty
// 60|   FUN xs = params "->" e = expr							{ make_fun(xs, e) }
fn yy_action_3(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[1].0 is YYObj__list_List_String_(xs)
  guard _args[3].0 is YYObj_Expr(e)
  YYObj_Expr({();  make_fun(xs, e) })
}

// file:///./parser.mbty
// 58|   IF e1 = expr THEN e2 = expr ELSE e3 = expr 			{ If(e1, e2, e3) }
fn yy_action_4(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[1].0 is YYObj_Expr(e1)
  guard _args[3].0 is YYObj_Expr(e2)
  guard _args[5].0 is YYObj_Expr(e3)
  YYObj_Expr({();  If(e1, e2, e3) })
}

// file:///./parser.mbty
// 56|   LETREC x = ID "=" e1 = expr IN e2 = expr 				{ LetRec(x, e1, e2) }
fn yy_action_5(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[1].0 is YYObj_String(x)
  guard _args[3].0 is YYObj_Expr(e1)
  guard _args[5].0 is YYObj_Expr(e2)
  YYObj_Expr({();  LetRec(x, e1, e2) })
}

// file:///./parser.mbty
// 57|   LETREC f = ID xs = params "=" e1 = expr IN e2 = expr 	{ LetRec(f, make_fun(xs, e1), e2) }
fn yy_action_6(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[1].0 is YYObj_String(f)
  guard _args[2].0 is YYObj__list_List_String_(xs)
  guard _args[4].0 is YYObj_Expr(e1)
  guard _args[6].0 is YYObj_Expr(e2)
  YYObj_Expr({();  LetRec(f, make_fun(xs, e1), e2) })
}

// file:///./parser.mbty
// 54|   LET x = ID "=" e1 = expr IN e2 = expr 				{ Let(x, e1, e2) }
fn yy_action_7(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[1].0 is YYObj_String(x)
  guard _args[3].0 is YYObj_Expr(e1)
  guard _args[5].0 is YYObj_Expr(e2)
  YYObj_Expr({();  Let(x, e1, e2) })
}

// file:///./parser.mbty
// 55|   LET f = ID xs = params "=" e1 = expr IN e2 = expr 	{ Let(f, make_fun(xs, e1), e2) }
fn yy_action_8(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[1].0 is YYObj_String(f)
  guard _args[2].0 is YYObj__list_List_String_(xs)
  guard _args[4].0 is YYObj_Expr(e1)
  guard _args[6].0 is YYObj_Expr(e2)
  YYObj_Expr({();  Let(f, make_fun(xs, e1), e2) })
}

// file:///./parser.mbty
// 59|   f = simpl_expr es = args								{ make_apply(f, es) }
fn yy_action_9(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[0].0 is YYObj_Expr(f)
  guard _args[1].0 is YYObj__list_List_Expr_(es)
  YYObj_Expr({();  make_apply(f, es) })
}

// file:///./parser.mbty
// 79|   e = simpl_expr es = args	{ @list.cons(e, es) }
fn yy_action_10(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[0].0 is YYObj_Expr(e)
  guard _args[1].0 is YYObj__list_List_Expr_(es)
  YYObj__list_List_Expr_({();  @list.cons(e, es) })
}

// file:///./parser.mbty
// 80|   e = simpl_expr			{ @list.singleton(e) }
fn yy_action_11(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[0].0 is YYObj_Expr(e)
  YYObj__list_List_Expr_({();  @list.singleton(e) })
}

// file:///./parser.mbty
// 48|   e = simpl_expr										{ e }
fn yy_action_12(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[0].0 is YYObj_Expr(e)
  YYObj_Expr({();  e })
}

// file:///./parser.mbty
// 49|   e1 = expr "<=" e2 = expr 								{ Binop(Leq, e1, e2) }
fn yy_action_13(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[0].0 is YYObj_Expr(e1)
  guard _args[2].0 is YYObj_Expr(e2)
  YYObj_Expr({();  Binop(Leq, e1, e2) })
}

// file:///./parser.mbty
// 50|   e1 = expr "*" e2 = expr 								{ Binop(Mult, e1, e2) }
fn yy_action_14(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[0].0 is YYObj_Expr(e1)
  guard _args[2].0 is YYObj_Expr(e2)
  YYObj_Expr({();  Binop(Mult, e1, e2) })
}

// file:///./parser.mbty
// 51|   e1 = expr "+" e2 = expr 								{ Binop(Add, e1, e2) }
fn yy_action_15(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[0].0 is YYObj_Expr(e1)
  guard _args[2].0 is YYObj_Expr(e2)
  YYObj_Expr({();  Binop(Add, e1, e2) })
}

// file:///./parser.mbty
// 52|   e1 = expr "-" e2 = expr 								{ Binop(Sub, e1, e2) }
fn yy_action_16(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[0].0 is YYObj_Expr(e1)
  guard _args[2].0 is YYObj_Expr(e2)
  YYObj_Expr({();  Binop(Sub, e1, e2) })
}

// file:///./parser.mbty
// 53|   e1 = expr ":=" e2 = expr 								{ Binop(Assign, e1, e2) }
fn yy_action_17(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[0].0 is YYObj_Expr(e1)
  guard _args[2].0 is YYObj_Expr(e2)
  YYObj_Expr({();  Binop(Assign, e1, e2) })
}

// file:///./parser.mbty
// 61|   e1 = expr ";" e2 = expr								{ Let("_", e1, e2) }
fn yy_action_18(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[0].0 is YYObj_Expr(e1)
  guard _args[2].0 is YYObj_Expr(e2)
  YYObj_Expr({();  Let("_", e1, e2) })
}

// file:///./parser.mbty
// 75|   x = ID xs = params	{ @list.cons(x, xs) }
fn yy_action_19(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[0].0 is YYObj_String(x)
  guard _args[1].0 is YYObj__list_List_String_(xs)
  YYObj__list_List_String_({();  @list.cons(x, xs) })
}

// file:///./parser.mbty
// 76|   x = ID				{ @list.singleton(x) }
fn yy_action_20(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[0].0 is YYObj_String(x)
  YYObj__list_List_String_({();  @list.singleton(x) })
}

// file:///./parser.mbty
// 62|   REF e = simpl_expr									{ UniOp(Ref, e) }
fn yy_action_21(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[1].0 is YYObj_Expr(e)
  YYObj_Expr({();  UniOp(Ref, e) })
}

// file:///./parser.mbty
// 66|   i = INT 				{ Int(i) }
fn yy_action_22(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[0].0 is YYObj_Int(i)
  YYObj_Expr({();  Int(i) })
}

// file:///./parser.mbty
// 67|   x = ID 				{ Var(x) }
fn yy_action_23(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[0].0 is YYObj_String(x)
  YYObj_Expr({();  Var(x) })
}

// file:///./parser.mbty
// 68|   TRUE 					{ Bool(true) }
fn yy_action_24(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  YYObj_Expr({();  Bool(true) })
}

// file:///./parser.mbty
// 69|   FALSE 				{ Bool(false) }
fn yy_action_25(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  YYObj_Expr({();  Bool(false) })
}

// file:///./parser.mbty
// 70|   "(" ")" 				{ Unit }
fn yy_action_26(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  YYObj_Expr({();  Unit })
}

// file:///./parser.mbty
// 72|   "!" e = simpl_expr	{ UniOp(DeRef, e) }
fn yy_action_27(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[1].0 is YYObj_Expr(e)
  YYObj_Expr({();  UniOp(DeRef, e) })
}

fn yy_input(token : Token, _start_pos : Int, _end_pos : Int) -> (YYSymbol, YYObj) {
  match token {
    INT(data) => (T_INT, YYObj_Int(data))
    ID(data) => (T_ID, YYObj_String(data))
    TRUE => (T_TRUE, YYObj_Void)
    FALSE => (T_FALSE, YYObj_Void)
    LEQ => (T_LEQ, YYObj_Void)
    TIMES => (T_TIMES, YYObj_Void)
    PLUS => (T_PLUS, YYObj_Void)
    SUB => (T_SUB, YYObj_Void)
    LPAREN => (T_LPAREN, YYObj_Void)
    RPAREN => (T_RPAREN, YYObj_Void)
    LET => (T_LET, YYObj_Void)
    LETREC => (T_LETREC, YYObj_Void)
    EQUALS => (T_EQUALS, YYObj_Void)
    ASSIGN => (T_ASSIGN, YYObj_Void)
    IN => (T_IN, YYObj_Void)
    IF => (T_IF, YYObj_Void)
    THEN => (T_THEN, YYObj_Void)
    ELSE => (T_ELSE, YYObj_Void)
    FUN => (T_FUN, YYObj_Void)
    ARROW => (T_ARROW, YYObj_Void)
    SEMI => (T_SEMI, YYObj_Void)
    REF => (T_REF, YYObj_Void)
    DEREF => (T_DEREF, YYObj_Void)
    DO => (T_DO, YYObj_Void)
    EOF => (T_EOF, YYObj_Void)
  }
}

// [0, prog → • expr EOF, $]
// [1, expr → • simpl_expr, LEQ / TIMES / PLUS / SUB / ASSIGN / SEMI / EOF]
// [2, expr → • expr LEQ expr, LEQ / TIMES / PLUS / SUB / ASSIGN / SEMI / EOF]
// [3, expr → • expr TIMES expr, LEQ / TIMES / PLUS / SUB / ASSIGN / SEMI / EOF]
// [4, expr → • expr PLUS expr, LEQ / TIMES / PLUS / SUB / ASSIGN / SEMI / EOF]
// [5, expr → • expr SUB expr, LEQ / TIMES / PLUS / SUB / ASSIGN / SEMI / EOF]
// [6, expr → • expr ASSIGN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / SEMI / EOF]
// [7, expr → • LET ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / SEMI / EOF]
// [8, expr → • LET ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / SEMI / EOF]
// [9, expr → • LETREC ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / SEMI / EOF]
// [10, expr → • LETREC ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / SEMI / EOF]
// [11, expr → • IF expr THEN expr ELSE expr, LEQ / TIMES / PLUS / SUB / ASSIGN / SEMI / EOF]
// [12, expr → • simpl_expr args, LEQ / TIMES / PLUS / SUB / ASSIGN / SEMI / EOF]
// [13, expr → • FUN params ARROW expr, LEQ / TIMES / PLUS / SUB / ASSIGN / SEMI / EOF]
// [14, expr → • expr SEMI expr, LEQ / TIMES / PLUS / SUB / ASSIGN / SEMI / EOF]
// [15, expr → • REF simpl_expr, LEQ / TIMES / PLUS / SUB / ASSIGN / SEMI / EOF]
// [16, expr → • DO expr, LEQ / TIMES / PLUS / SUB / ASSIGN / SEMI / EOF]
// [17, simpl_expr → • INT, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / SEMI / DEREF / EOF]
// [18, simpl_expr → • ID, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / SEMI / DEREF / EOF]
// [19, simpl_expr → • TRUE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / SEMI / DEREF / EOF]
// [20, simpl_expr → • FALSE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / SEMI / DEREF / EOF]
// [21, simpl_expr → • LPAREN RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / SEMI / DEREF / EOF]
// [22, simpl_expr → • LPAREN expr RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / SEMI / DEREF / EOF]
// [23, simpl_expr → • DEREF simpl_expr, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / SEMI / DEREF / EOF]
// [28, prog_prime → • prog, $]
fn yy_state_0(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    NT_prog => Shift(yy_state_1)
    T_DEREF => Shift(yy_state_2)
    T_LPAREN => Shift(yy_state_4)
    T_FALSE => Shift(yy_state_6)
    T_TRUE => Shift(yy_state_7)
    T_ID => Shift(yy_state_8)
    T_INT => Shift(yy_state_9)
    T_DO => Shift(yy_state_10)
    T_REF => Shift(yy_state_11)
    T_FUN => Shift(yy_state_13)
    T_IF => Shift(yy_state_18)
    T_LETREC => Shift(yy_state_19)
    T_LET => Shift(yy_state_23)
    NT_simpl_expr => Shift(yy_state_40)
    NT_expr => Shift(yy_state_66)
    _ => Error
  }
}

// [28, prog_prime → prog •, $]
fn yy_state_1(_lookahead : YYSymbol) -> YYDecision {
  Accept
}

// [17, simpl_expr → • INT, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [18, simpl_expr → • ID, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [19, simpl_expr → • TRUE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [20, simpl_expr → • FALSE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [21, simpl_expr → • LPAREN RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [22, simpl_expr → • LPAREN expr RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [23, simpl_expr → • DEREF simpl_expr, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [23, simpl_expr → DEREF • simpl_expr, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
fn yy_state_2(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_DEREF => Shift(yy_state_2)
    NT_simpl_expr => Shift(yy_state_3)
    T_LPAREN => Shift(yy_state_4)
    T_FALSE => Shift(yy_state_6)
    T_TRUE => Shift(yy_state_7)
    T_ID => Shift(yy_state_8)
    T_INT => Shift(yy_state_9)
    _ => Error
  }
}

// [23, simpl_expr → DEREF simpl_expr •, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
fn yy_state_3(_lookahead : YYSymbol) -> YYDecision {
  ReduceNoLookahead(2, NT_simpl_expr, yy_action_27)
}

// [1, expr → • simpl_expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / SEMI]
// [2, expr → • expr LEQ expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / SEMI]
// [3, expr → • expr TIMES expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / SEMI]
// [4, expr → • expr PLUS expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / SEMI]
// [5, expr → • expr SUB expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / SEMI]
// [6, expr → • expr ASSIGN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / SEMI]
// [7, expr → • LET ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / SEMI]
// [8, expr → • LET ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / SEMI]
// [9, expr → • LETREC ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / SEMI]
// [10, expr → • LETREC ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / SEMI]
// [11, expr → • IF expr THEN expr ELSE expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / SEMI]
// [12, expr → • simpl_expr args, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / SEMI]
// [13, expr → • FUN params ARROW expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / SEMI]
// [14, expr → • expr SEMI expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / SEMI]
// [15, expr → • REF simpl_expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / SEMI]
// [16, expr → • DO expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / SEMI]
// [17, simpl_expr → • INT, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / SEMI / DEREF]
// [18, simpl_expr → • ID, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / SEMI / DEREF]
// [19, simpl_expr → • TRUE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / SEMI / DEREF]
// [20, simpl_expr → • FALSE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / SEMI / DEREF]
// [21, simpl_expr → • LPAREN RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / SEMI / DEREF]
// [21, simpl_expr → LPAREN • RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [22, simpl_expr → • LPAREN expr RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / SEMI / DEREF]
// [22, simpl_expr → LPAREN • expr RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [23, simpl_expr → • DEREF simpl_expr, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / SEMI / DEREF]
fn yy_state_4(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_DEREF => Shift(yy_state_2)
    T_LPAREN => Shift(yy_state_4)
    T_RPAREN => Shift(yy_state_5)
    T_FALSE => Shift(yy_state_6)
    T_TRUE => Shift(yy_state_7)
    T_ID => Shift(yy_state_8)
    T_INT => Shift(yy_state_9)
    T_DO => Shift(yy_state_10)
    T_REF => Shift(yy_state_11)
    T_FUN => Shift(yy_state_13)
    T_IF => Shift(yy_state_18)
    T_LETREC => Shift(yy_state_19)
    T_LET => Shift(yy_state_23)
    NT_simpl_expr => Shift(yy_state_40)
    NT_expr => Shift(yy_state_64)
    _ => Error
  }
}

// [21, simpl_expr → LPAREN RPAREN •, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
fn yy_state_5(_lookahead : YYSymbol) -> YYDecision {
  ReduceNoLookahead(2, NT_simpl_expr, yy_action_26)
}

// [20, simpl_expr → FALSE •, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
fn yy_state_6(_lookahead : YYSymbol) -> YYDecision {
  ReduceNoLookahead(1, NT_simpl_expr, yy_action_25)
}

// [19, simpl_expr → TRUE •, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
fn yy_state_7(_lookahead : YYSymbol) -> YYDecision {
  ReduceNoLookahead(1, NT_simpl_expr, yy_action_24)
}

// [18, simpl_expr → ID •, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
fn yy_state_8(_lookahead : YYSymbol) -> YYDecision {
  ReduceNoLookahead(1, NT_simpl_expr, yy_action_23)
}

// [17, simpl_expr → INT •, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
fn yy_state_9(_lookahead : YYSymbol) -> YYDecision {
  ReduceNoLookahead(1, NT_simpl_expr, yy_action_22)
}

// [1, expr → • simpl_expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [2, expr → • expr LEQ expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [3, expr → • expr TIMES expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [4, expr → • expr PLUS expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [5, expr → • expr SUB expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [6, expr → • expr ASSIGN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [7, expr → • LET ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [8, expr → • LET ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [9, expr → • LETREC ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [10, expr → • LETREC ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [11, expr → • IF expr THEN expr ELSE expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [12, expr → • simpl_expr args, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [13, expr → • FUN params ARROW expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → • expr SEMI expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [15, expr → • REF simpl_expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [16, expr → • DO expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [16, expr → DO • expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [17, simpl_expr → • INT, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [18, simpl_expr → • ID, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [19, simpl_expr → • TRUE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [20, simpl_expr → • FALSE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [21, simpl_expr → • LPAREN RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [22, simpl_expr → • LPAREN expr RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [23, simpl_expr → • DEREF simpl_expr, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
fn yy_state_10(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_DEREF => Shift(yy_state_2)
    T_LPAREN => Shift(yy_state_4)
    T_FALSE => Shift(yy_state_6)
    T_TRUE => Shift(yy_state_7)
    T_ID => Shift(yy_state_8)
    T_INT => Shift(yy_state_9)
    T_DO => Shift(yy_state_10)
    T_REF => Shift(yy_state_11)
    T_FUN => Shift(yy_state_13)
    T_IF => Shift(yy_state_18)
    T_LETREC => Shift(yy_state_19)
    T_LET => Shift(yy_state_23)
    NT_simpl_expr => Shift(yy_state_40)
    NT_expr => Shift(yy_state_63)
    _ => Error
  }
}

// [15, expr → REF • simpl_expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [17, simpl_expr → • INT, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [18, simpl_expr → • ID, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [19, simpl_expr → • TRUE, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [20, simpl_expr → • FALSE, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [21, simpl_expr → • LPAREN RPAREN, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [22, simpl_expr → • LPAREN expr RPAREN, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [23, simpl_expr → • DEREF simpl_expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
fn yy_state_11(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_DEREF => Shift(yy_state_2)
    T_LPAREN => Shift(yy_state_4)
    T_FALSE => Shift(yy_state_6)
    T_TRUE => Shift(yy_state_7)
    T_ID => Shift(yy_state_8)
    T_INT => Shift(yy_state_9)
    NT_simpl_expr => Shift(yy_state_12)
    _ => Error
  }
}

// [15, expr → REF simpl_expr •, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
fn yy_state_12(_lookahead : YYSymbol) -> YYDecision {
  ReduceNoLookahead(2, NT_expr, yy_action_21)
}

// [13, expr → FUN • params ARROW expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [24, params → • ID params, ARROW]
// [25, params → • ID, ARROW]
fn yy_state_13(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_ID => Shift(yy_state_14)
    NT_params => Shift(yy_state_16)
    _ => Error
  }
}

// [24, params → • ID params, EQUALS / ARROW]
// [24, params → ID • params, EQUALS / ARROW]
// [25, params → • ID, EQUALS / ARROW]
// [25, params → ID •, EQUALS / ARROW]
fn yy_state_14(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_ID => Shift(yy_state_14)
    NT_params => Shift(yy_state_15)
    T_EQUALS | T_ARROW => Reduce(1, NT_params, yy_action_20)
    _ => Error
  }
}

// [24, params → ID params •, EQUALS / ARROW]
fn yy_state_15(_lookahead : YYSymbol) -> YYDecision {
  ReduceNoLookahead(2, NT_params, yy_action_19)
}

// [13, expr → FUN params • ARROW expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
fn yy_state_16(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_ARROW => Shift(yy_state_17)
    _ => Error
  }
}

// [1, expr → • simpl_expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [2, expr → • expr LEQ expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [3, expr → • expr TIMES expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [4, expr → • expr PLUS expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [5, expr → • expr SUB expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [6, expr → • expr ASSIGN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [7, expr → • LET ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [8, expr → • LET ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [9, expr → • LETREC ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [10, expr → • LETREC ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [11, expr → • IF expr THEN expr ELSE expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [12, expr → • simpl_expr args, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [13, expr → • FUN params ARROW expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [13, expr → FUN params ARROW • expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → • expr SEMI expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [15, expr → • REF simpl_expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [16, expr → • DO expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [17, simpl_expr → • INT, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [18, simpl_expr → • ID, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [19, simpl_expr → • TRUE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [20, simpl_expr → • FALSE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [21, simpl_expr → • LPAREN RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [22, simpl_expr → • LPAREN expr RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [23, simpl_expr → • DEREF simpl_expr, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
fn yy_state_17(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_DEREF => Shift(yy_state_2)
    T_LPAREN => Shift(yy_state_4)
    T_FALSE => Shift(yy_state_6)
    T_TRUE => Shift(yy_state_7)
    T_ID => Shift(yy_state_8)
    T_INT => Shift(yy_state_9)
    T_DO => Shift(yy_state_10)
    T_REF => Shift(yy_state_11)
    T_FUN => Shift(yy_state_13)
    T_IF => Shift(yy_state_18)
    T_LETREC => Shift(yy_state_19)
    T_LET => Shift(yy_state_23)
    NT_simpl_expr => Shift(yy_state_40)
    NT_expr => Shift(yy_state_62)
    _ => Error
  }
}

// [1, expr → • simpl_expr, LEQ / TIMES / PLUS / SUB / ASSIGN / THEN / SEMI]
// [2, expr → • expr LEQ expr, LEQ / TIMES / PLUS / SUB / ASSIGN / THEN / SEMI]
// [3, expr → • expr TIMES expr, LEQ / TIMES / PLUS / SUB / ASSIGN / THEN / SEMI]
// [4, expr → • expr PLUS expr, LEQ / TIMES / PLUS / SUB / ASSIGN / THEN / SEMI]
// [5, expr → • expr SUB expr, LEQ / TIMES / PLUS / SUB / ASSIGN / THEN / SEMI]
// [6, expr → • expr ASSIGN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / THEN / SEMI]
// [7, expr → • LET ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / THEN / SEMI]
// [8, expr → • LET ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / THEN / SEMI]
// [9, expr → • LETREC ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / THEN / SEMI]
// [10, expr → • LETREC ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / THEN / SEMI]
// [11, expr → • IF expr THEN expr ELSE expr, LEQ / TIMES / PLUS / SUB / ASSIGN / THEN / SEMI]
// [11, expr → IF • expr THEN expr ELSE expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [12, expr → • simpl_expr args, LEQ / TIMES / PLUS / SUB / ASSIGN / THEN / SEMI]
// [13, expr → • FUN params ARROW expr, LEQ / TIMES / PLUS / SUB / ASSIGN / THEN / SEMI]
// [14, expr → • expr SEMI expr, LEQ / TIMES / PLUS / SUB / ASSIGN / THEN / SEMI]
// [15, expr → • REF simpl_expr, LEQ / TIMES / PLUS / SUB / ASSIGN / THEN / SEMI]
// [16, expr → • DO expr, LEQ / TIMES / PLUS / SUB / ASSIGN / THEN / SEMI]
// [17, simpl_expr → • INT, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / THEN / SEMI / DEREF]
// [18, simpl_expr → • ID, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / THEN / SEMI / DEREF]
// [19, simpl_expr → • TRUE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / THEN / SEMI / DEREF]
// [20, simpl_expr → • FALSE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / THEN / SEMI / DEREF]
// [21, simpl_expr → • LPAREN RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / THEN / SEMI / DEREF]
// [22, simpl_expr → • LPAREN expr RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / THEN / SEMI / DEREF]
// [23, simpl_expr → • DEREF simpl_expr, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / THEN / SEMI / DEREF]
fn yy_state_18(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_DEREF => Shift(yy_state_2)
    T_LPAREN => Shift(yy_state_4)
    T_FALSE => Shift(yy_state_6)
    T_TRUE => Shift(yy_state_7)
    T_ID => Shift(yy_state_8)
    T_INT => Shift(yy_state_9)
    T_DO => Shift(yy_state_10)
    T_REF => Shift(yy_state_11)
    T_FUN => Shift(yy_state_13)
    T_IF => Shift(yy_state_18)
    T_LETREC => Shift(yy_state_19)
    T_LET => Shift(yy_state_23)
    NT_simpl_expr => Shift(yy_state_40)
    NT_expr => Shift(yy_state_57)
    _ => Error
  }
}

// [9, expr → LETREC • ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [10, expr → LETREC • ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
fn yy_state_19(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_ID => Shift(yy_state_20)
    _ => Error
  }
}

// [9, expr → LETREC ID • EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [10, expr → LETREC ID • params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [24, params → • ID params, EQUALS]
// [25, params → • ID, EQUALS]
fn yy_state_20(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_ID => Shift(yy_state_14)
    NT_params => Shift(yy_state_21)
    T_EQUALS => Shift(yy_state_53)
    _ => Error
  }
}

// [10, expr → LETREC ID params • EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
fn yy_state_21(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_EQUALS => Shift(yy_state_22)
    _ => Error
  }
}

// [1, expr → • simpl_expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [2, expr → • expr LEQ expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [3, expr → • expr TIMES expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [4, expr → • expr PLUS expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [5, expr → • expr SUB expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [6, expr → • expr ASSIGN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [7, expr → • LET ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [8, expr → • LET ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [9, expr → • LETREC ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [10, expr → • LETREC ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [10, expr → LETREC ID params EQUALS • expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [11, expr → • IF expr THEN expr ELSE expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [12, expr → • simpl_expr args, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [13, expr → • FUN params ARROW expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [14, expr → • expr SEMI expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [15, expr → • REF simpl_expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [16, expr → • DO expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [17, simpl_expr → • INT, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / IN / SEMI / DEREF]
// [18, simpl_expr → • ID, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / IN / SEMI / DEREF]
// [19, simpl_expr → • TRUE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / IN / SEMI / DEREF]
// [20, simpl_expr → • FALSE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / IN / SEMI / DEREF]
// [21, simpl_expr → • LPAREN RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / IN / SEMI / DEREF]
// [22, simpl_expr → • LPAREN expr RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / IN / SEMI / DEREF]
// [23, simpl_expr → • DEREF simpl_expr, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / IN / SEMI / DEREF]
fn yy_state_22(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_DEREF => Shift(yy_state_2)
    T_LPAREN => Shift(yy_state_4)
    T_FALSE => Shift(yy_state_6)
    T_TRUE => Shift(yy_state_7)
    T_ID => Shift(yy_state_8)
    T_INT => Shift(yy_state_9)
    T_DO => Shift(yy_state_10)
    T_REF => Shift(yy_state_11)
    T_FUN => Shift(yy_state_13)
    T_IF => Shift(yy_state_18)
    T_LETREC => Shift(yy_state_19)
    T_LET => Shift(yy_state_23)
    NT_simpl_expr => Shift(yy_state_40)
    NT_expr => Shift(yy_state_50)
    _ => Error
  }
}

// [7, expr → LET • ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [8, expr → LET • ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
fn yy_state_23(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_ID => Shift(yy_state_24)
    _ => Error
  }
}

// [7, expr → LET ID • EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [8, expr → LET ID • params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [24, params → • ID params, EQUALS]
// [25, params → • ID, EQUALS]
fn yy_state_24(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_ID => Shift(yy_state_14)
    NT_params => Shift(yy_state_25)
    T_EQUALS => Shift(yy_state_46)
    _ => Error
  }
}

// [8, expr → LET ID params • EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
fn yy_state_25(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_EQUALS => Shift(yy_state_26)
    _ => Error
  }
}

// [1, expr → • simpl_expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [2, expr → • expr LEQ expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [3, expr → • expr TIMES expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [4, expr → • expr PLUS expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [5, expr → • expr SUB expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [6, expr → • expr ASSIGN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [7, expr → • LET ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [8, expr → • LET ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [8, expr → LET ID params EQUALS • expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [9, expr → • LETREC ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [10, expr → • LETREC ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [11, expr → • IF expr THEN expr ELSE expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [12, expr → • simpl_expr args, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [13, expr → • FUN params ARROW expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [14, expr → • expr SEMI expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [15, expr → • REF simpl_expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [16, expr → • DO expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [17, simpl_expr → • INT, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / IN / SEMI / DEREF]
// [18, simpl_expr → • ID, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / IN / SEMI / DEREF]
// [19, simpl_expr → • TRUE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / IN / SEMI / DEREF]
// [20, simpl_expr → • FALSE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / IN / SEMI / DEREF]
// [21, simpl_expr → • LPAREN RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / IN / SEMI / DEREF]
// [22, simpl_expr → • LPAREN expr RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / IN / SEMI / DEREF]
// [23, simpl_expr → • DEREF simpl_expr, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / IN / SEMI / DEREF]
fn yy_state_26(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_DEREF => Shift(yy_state_2)
    T_LPAREN => Shift(yy_state_4)
    T_FALSE => Shift(yy_state_6)
    T_TRUE => Shift(yy_state_7)
    T_ID => Shift(yy_state_8)
    T_INT => Shift(yy_state_9)
    T_DO => Shift(yy_state_10)
    T_REF => Shift(yy_state_11)
    T_FUN => Shift(yy_state_13)
    T_IF => Shift(yy_state_18)
    T_LETREC => Shift(yy_state_19)
    T_LET => Shift(yy_state_23)
    NT_expr => Shift(yy_state_27)
    NT_simpl_expr => Shift(yy_state_40)
    _ => Error
  }
}

// [2, expr → expr • LEQ expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [3, expr → expr • TIMES expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [4, expr → expr • PLUS expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [5, expr → expr • SUB expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [6, expr → expr • ASSIGN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [8, expr → LET ID params EQUALS expr • IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → expr • SEMI expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
fn yy_state_27(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_SEMI => Shift(yy_state_28)
    T_ASSIGN => Shift(yy_state_30)
    T_SUB => Shift(yy_state_32)
    T_PLUS => Shift(yy_state_34)
    T_TIMES => Shift(yy_state_36)
    T_LEQ => Shift(yy_state_38)
    T_IN => Shift(yy_state_44)
    _ => Error
  }
}

// [1, expr → • simpl_expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [2, expr → • expr LEQ expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [3, expr → • expr TIMES expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [4, expr → • expr PLUS expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [5, expr → • expr SUB expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [6, expr → • expr ASSIGN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [7, expr → • LET ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [8, expr → • LET ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [9, expr → • LETREC ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [10, expr → • LETREC ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [11, expr → • IF expr THEN expr ELSE expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [12, expr → • simpl_expr args, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [13, expr → • FUN params ARROW expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → • expr SEMI expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → expr SEMI • expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [15, expr → • REF simpl_expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [16, expr → • DO expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [17, simpl_expr → • INT, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [18, simpl_expr → • ID, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [19, simpl_expr → • TRUE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [20, simpl_expr → • FALSE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [21, simpl_expr → • LPAREN RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [22, simpl_expr → • LPAREN expr RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [23, simpl_expr → • DEREF simpl_expr, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
fn yy_state_28(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_DEREF => Shift(yy_state_2)
    T_LPAREN => Shift(yy_state_4)
    T_FALSE => Shift(yy_state_6)
    T_TRUE => Shift(yy_state_7)
    T_ID => Shift(yy_state_8)
    T_INT => Shift(yy_state_9)
    T_DO => Shift(yy_state_10)
    T_REF => Shift(yy_state_11)
    T_FUN => Shift(yy_state_13)
    T_IF => Shift(yy_state_18)
    T_LETREC => Shift(yy_state_19)
    T_LET => Shift(yy_state_23)
    NT_expr => Shift(yy_state_29)
    NT_simpl_expr => Shift(yy_state_40)
    _ => Error
  }
}

// [2, expr → expr • LEQ expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [3, expr → expr • TIMES expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [4, expr → expr • PLUS expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [5, expr → expr • SUB expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [6, expr → expr • ASSIGN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → expr • SEMI expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → expr SEMI expr •, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
fn yy_state_29(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_SEMI => Shift(yy_state_28)
    T_ASSIGN => Shift(yy_state_30)
    T_SUB => Shift(yy_state_32)
    T_PLUS => Shift(yy_state_34)
    T_TIMES => Shift(yy_state_36)
    T_LEQ => Shift(yy_state_38)
    T_RPAREN | T_IN | T_THEN | T_ELSE | T_EOF => Reduce(3, NT_expr, yy_action_18)
    _ => Error
  }
}

// [1, expr → • simpl_expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [2, expr → • expr LEQ expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [3, expr → • expr TIMES expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [4, expr → • expr PLUS expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [5, expr → • expr SUB expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [6, expr → • expr ASSIGN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [6, expr → expr ASSIGN • expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [7, expr → • LET ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [8, expr → • LET ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [9, expr → • LETREC ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [10, expr → • LETREC ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [11, expr → • IF expr THEN expr ELSE expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [12, expr → • simpl_expr args, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [13, expr → • FUN params ARROW expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → • expr SEMI expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [15, expr → • REF simpl_expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [16, expr → • DO expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [17, simpl_expr → • INT, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [18, simpl_expr → • ID, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [19, simpl_expr → • TRUE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [20, simpl_expr → • FALSE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [21, simpl_expr → • LPAREN RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [22, simpl_expr → • LPAREN expr RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [23, simpl_expr → • DEREF simpl_expr, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
fn yy_state_30(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_DEREF => Shift(yy_state_2)
    T_LPAREN => Shift(yy_state_4)
    T_FALSE => Shift(yy_state_6)
    T_TRUE => Shift(yy_state_7)
    T_ID => Shift(yy_state_8)
    T_INT => Shift(yy_state_9)
    T_DO => Shift(yy_state_10)
    T_REF => Shift(yy_state_11)
    T_FUN => Shift(yy_state_13)
    T_IF => Shift(yy_state_18)
    T_LETREC => Shift(yy_state_19)
    T_LET => Shift(yy_state_23)
    NT_expr => Shift(yy_state_31)
    NT_simpl_expr => Shift(yy_state_40)
    _ => Error
  }
}

// [2, expr → expr • LEQ expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [3, expr → expr • TIMES expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [4, expr → expr • PLUS expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [5, expr → expr • SUB expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [6, expr → expr • ASSIGN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [6, expr → expr ASSIGN expr •, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → expr • SEMI expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
fn yy_state_31(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_ASSIGN => Shift(yy_state_30)
    T_SUB => Shift(yy_state_32)
    T_PLUS => Shift(yy_state_34)
    T_TIMES => Shift(yy_state_36)
    T_LEQ => Shift(yy_state_38)
    T_RPAREN | T_IN | T_THEN | T_ELSE | T_SEMI | T_EOF => Reduce(3, NT_expr, yy_action_17)
    _ => Error
  }
}

// [1, expr → • simpl_expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [2, expr → • expr LEQ expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [3, expr → • expr TIMES expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [4, expr → • expr PLUS expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [5, expr → • expr SUB expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [5, expr → expr SUB • expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [6, expr → • expr ASSIGN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [7, expr → • LET ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [8, expr → • LET ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [9, expr → • LETREC ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [10, expr → • LETREC ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [11, expr → • IF expr THEN expr ELSE expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [12, expr → • simpl_expr args, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [13, expr → • FUN params ARROW expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → • expr SEMI expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [15, expr → • REF simpl_expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [16, expr → • DO expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [17, simpl_expr → • INT, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [18, simpl_expr → • ID, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [19, simpl_expr → • TRUE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [20, simpl_expr → • FALSE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [21, simpl_expr → • LPAREN RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [22, simpl_expr → • LPAREN expr RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [23, simpl_expr → • DEREF simpl_expr, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
fn yy_state_32(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_DEREF => Shift(yy_state_2)
    T_LPAREN => Shift(yy_state_4)
    T_FALSE => Shift(yy_state_6)
    T_TRUE => Shift(yy_state_7)
    T_ID => Shift(yy_state_8)
    T_INT => Shift(yy_state_9)
    T_DO => Shift(yy_state_10)
    T_REF => Shift(yy_state_11)
    T_FUN => Shift(yy_state_13)
    T_IF => Shift(yy_state_18)
    T_LETREC => Shift(yy_state_19)
    T_LET => Shift(yy_state_23)
    NT_expr => Shift(yy_state_33)
    NT_simpl_expr => Shift(yy_state_40)
    _ => Error
  }
}

// [2, expr → expr • LEQ expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [3, expr → expr • TIMES expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [4, expr → expr • PLUS expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [5, expr → expr • SUB expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [5, expr → expr SUB expr •, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [6, expr → expr • ASSIGN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → expr • SEMI expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
fn yy_state_33(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_TIMES => Shift(yy_state_36)
    T_LEQ | T_PLUS | T_SUB | T_RPAREN | T_ASSIGN | T_IN | T_THEN | T_ELSE | T_SEMI | T_EOF => Reduce(3, NT_expr, yy_action_16)
    _ => Error
  }
}

// [1, expr → • simpl_expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [2, expr → • expr LEQ expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [3, expr → • expr TIMES expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [4, expr → • expr PLUS expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [4, expr → expr PLUS • expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [5, expr → • expr SUB expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [6, expr → • expr ASSIGN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [7, expr → • LET ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [8, expr → • LET ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [9, expr → • LETREC ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [10, expr → • LETREC ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [11, expr → • IF expr THEN expr ELSE expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [12, expr → • simpl_expr args, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [13, expr → • FUN params ARROW expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → • expr SEMI expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [15, expr → • REF simpl_expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [16, expr → • DO expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [17, simpl_expr → • INT, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [18, simpl_expr → • ID, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [19, simpl_expr → • TRUE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [20, simpl_expr → • FALSE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [21, simpl_expr → • LPAREN RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [22, simpl_expr → • LPAREN expr RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [23, simpl_expr → • DEREF simpl_expr, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
fn yy_state_34(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_DEREF => Shift(yy_state_2)
    T_LPAREN => Shift(yy_state_4)
    T_FALSE => Shift(yy_state_6)
    T_TRUE => Shift(yy_state_7)
    T_ID => Shift(yy_state_8)
    T_INT => Shift(yy_state_9)
    T_DO => Shift(yy_state_10)
    T_REF => Shift(yy_state_11)
    T_FUN => Shift(yy_state_13)
    T_IF => Shift(yy_state_18)
    T_LETREC => Shift(yy_state_19)
    T_LET => Shift(yy_state_23)
    NT_expr => Shift(yy_state_35)
    NT_simpl_expr => Shift(yy_state_40)
    _ => Error
  }
}

// [2, expr → expr • LEQ expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [3, expr → expr • TIMES expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [4, expr → expr • PLUS expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [4, expr → expr PLUS expr •, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [5, expr → expr • SUB expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [6, expr → expr • ASSIGN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → expr • SEMI expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
fn yy_state_35(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_TIMES => Shift(yy_state_36)
    T_LEQ | T_PLUS | T_SUB | T_RPAREN | T_ASSIGN | T_IN | T_THEN | T_ELSE | T_SEMI | T_EOF => Reduce(3, NT_expr, yy_action_15)
    _ => Error
  }
}

// [1, expr → • simpl_expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [2, expr → • expr LEQ expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [3, expr → • expr TIMES expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [3, expr → expr TIMES • expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [4, expr → • expr PLUS expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [5, expr → • expr SUB expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [6, expr → • expr ASSIGN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [7, expr → • LET ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [8, expr → • LET ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [9, expr → • LETREC ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [10, expr → • LETREC ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [11, expr → • IF expr THEN expr ELSE expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [12, expr → • simpl_expr args, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [13, expr → • FUN params ARROW expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → • expr SEMI expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [15, expr → • REF simpl_expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [16, expr → • DO expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [17, simpl_expr → • INT, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [18, simpl_expr → • ID, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [19, simpl_expr → • TRUE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [20, simpl_expr → • FALSE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [21, simpl_expr → • LPAREN RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [22, simpl_expr → • LPAREN expr RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [23, simpl_expr → • DEREF simpl_expr, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
fn yy_state_36(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_DEREF => Shift(yy_state_2)
    T_LPAREN => Shift(yy_state_4)
    T_FALSE => Shift(yy_state_6)
    T_TRUE => Shift(yy_state_7)
    T_ID => Shift(yy_state_8)
    T_INT => Shift(yy_state_9)
    T_DO => Shift(yy_state_10)
    T_REF => Shift(yy_state_11)
    T_FUN => Shift(yy_state_13)
    T_IF => Shift(yy_state_18)
    T_LETREC => Shift(yy_state_19)
    T_LET => Shift(yy_state_23)
    NT_expr => Shift(yy_state_37)
    NT_simpl_expr => Shift(yy_state_40)
    _ => Error
  }
}

// [2, expr → expr • LEQ expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [3, expr → expr • TIMES expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [3, expr → expr TIMES expr •, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [4, expr → expr • PLUS expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [5, expr → expr • SUB expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [6, expr → expr • ASSIGN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → expr • SEMI expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
fn yy_state_37(_lookahead : YYSymbol) -> YYDecision {
  ReduceNoLookahead(3, NT_expr, yy_action_14)
}

// [1, expr → • simpl_expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [2, expr → • expr LEQ expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [2, expr → expr LEQ • expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [3, expr → • expr TIMES expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [4, expr → • expr PLUS expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [5, expr → • expr SUB expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [6, expr → • expr ASSIGN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [7, expr → • LET ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [8, expr → • LET ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [9, expr → • LETREC ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [10, expr → • LETREC ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [11, expr → • IF expr THEN expr ELSE expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [12, expr → • simpl_expr args, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [13, expr → • FUN params ARROW expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → • expr SEMI expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [15, expr → • REF simpl_expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [16, expr → • DO expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [17, simpl_expr → • INT, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [18, simpl_expr → • ID, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [19, simpl_expr → • TRUE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [20, simpl_expr → • FALSE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [21, simpl_expr → • LPAREN RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [22, simpl_expr → • LPAREN expr RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [23, simpl_expr → • DEREF simpl_expr, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
fn yy_state_38(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_DEREF => Shift(yy_state_2)
    T_LPAREN => Shift(yy_state_4)
    T_FALSE => Shift(yy_state_6)
    T_TRUE => Shift(yy_state_7)
    T_ID => Shift(yy_state_8)
    T_INT => Shift(yy_state_9)
    T_DO => Shift(yy_state_10)
    T_REF => Shift(yy_state_11)
    T_FUN => Shift(yy_state_13)
    T_IF => Shift(yy_state_18)
    T_LETREC => Shift(yy_state_19)
    T_LET => Shift(yy_state_23)
    NT_expr => Shift(yy_state_39)
    NT_simpl_expr => Shift(yy_state_40)
    _ => Error
  }
}

// [2, expr → expr • LEQ expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [2, expr → expr LEQ expr •, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [3, expr → expr • TIMES expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [4, expr → expr • PLUS expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [5, expr → expr • SUB expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [6, expr → expr • ASSIGN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → expr • SEMI expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
fn yy_state_39(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_SUB => Shift(yy_state_32)
    T_PLUS => Shift(yy_state_34)
    T_TIMES => Shift(yy_state_36)
    T_LEQ | T_RPAREN | T_ASSIGN | T_IN | T_THEN | T_ELSE | T_SEMI | T_EOF => Reduce(3, NT_expr, yy_action_13)
    _ => Error
  }
}

// [1, expr → simpl_expr •, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [12, expr → simpl_expr • args, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [17, simpl_expr → • INT, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [18, simpl_expr → • ID, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [19, simpl_expr → • TRUE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [20, simpl_expr → • FALSE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [21, simpl_expr → • LPAREN RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [22, simpl_expr → • LPAREN expr RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [23, simpl_expr → • DEREF simpl_expr, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [26, args → • simpl_expr args, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [27, args → • simpl_expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
fn yy_state_40(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_DEREF => Shift(yy_state_2)
    T_LPAREN => Shift(yy_state_4)
    T_FALSE => Shift(yy_state_6)
    T_TRUE => Shift(yy_state_7)
    T_ID => Shift(yy_state_8)
    T_INT => Shift(yy_state_9)
    NT_simpl_expr => Shift(yy_state_41)
    NT_args => Shift(yy_state_43)
    T_LEQ | T_TIMES | T_PLUS | T_SUB | T_RPAREN | T_ASSIGN | T_IN | T_THEN | T_ELSE | T_SEMI | T_EOF => Reduce(1, NT_expr, yy_action_12)
    _ => Error
  }
}

// [17, simpl_expr → • INT, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [18, simpl_expr → • ID, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [19, simpl_expr → • TRUE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [20, simpl_expr → • FALSE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [21, simpl_expr → • LPAREN RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [22, simpl_expr → • LPAREN expr RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [23, simpl_expr → • DEREF simpl_expr, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [26, args → • simpl_expr args, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [26, args → simpl_expr • args, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [27, args → • simpl_expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [27, args → simpl_expr •, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
fn yy_state_41(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_DEREF => Shift(yy_state_2)
    T_LPAREN => Shift(yy_state_4)
    T_FALSE => Shift(yy_state_6)
    T_TRUE => Shift(yy_state_7)
    T_ID => Shift(yy_state_8)
    T_INT => Shift(yy_state_9)
    NT_simpl_expr => Shift(yy_state_41)
    NT_args => Shift(yy_state_42)
    T_LEQ | T_TIMES | T_PLUS | T_SUB | T_RPAREN | T_ASSIGN | T_IN | T_THEN | T_ELSE | T_SEMI | T_EOF => Reduce(1, NT_args, yy_action_11)
    _ => Error
  }
}

// [26, args → simpl_expr args •, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
fn yy_state_42(_lookahead : YYSymbol) -> YYDecision {
  ReduceNoLookahead(2, NT_args, yy_action_10)
}

// [12, expr → simpl_expr args •, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
fn yy_state_43(_lookahead : YYSymbol) -> YYDecision {
  ReduceNoLookahead(2, NT_expr, yy_action_9)
}

// [1, expr → • simpl_expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [2, expr → • expr LEQ expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [3, expr → • expr TIMES expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [4, expr → • expr PLUS expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [5, expr → • expr SUB expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [6, expr → • expr ASSIGN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [7, expr → • LET ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [8, expr → • LET ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [8, expr → LET ID params EQUALS expr IN • expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [9, expr → • LETREC ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [10, expr → • LETREC ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [11, expr → • IF expr THEN expr ELSE expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [12, expr → • simpl_expr args, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [13, expr → • FUN params ARROW expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → • expr SEMI expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [15, expr → • REF simpl_expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [16, expr → • DO expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [17, simpl_expr → • INT, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [18, simpl_expr → • ID, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [19, simpl_expr → • TRUE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [20, simpl_expr → • FALSE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [21, simpl_expr → • LPAREN RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [22, simpl_expr → • LPAREN expr RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [23, simpl_expr → • DEREF simpl_expr, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
fn yy_state_44(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_DEREF => Shift(yy_state_2)
    T_LPAREN => Shift(yy_state_4)
    T_FALSE => Shift(yy_state_6)
    T_TRUE => Shift(yy_state_7)
    T_ID => Shift(yy_state_8)
    T_INT => Shift(yy_state_9)
    T_DO => Shift(yy_state_10)
    T_REF => Shift(yy_state_11)
    T_FUN => Shift(yy_state_13)
    T_IF => Shift(yy_state_18)
    T_LETREC => Shift(yy_state_19)
    T_LET => Shift(yy_state_23)
    NT_simpl_expr => Shift(yy_state_40)
    NT_expr => Shift(yy_state_45)
    _ => Error
  }
}

// [2, expr → expr • LEQ expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [3, expr → expr • TIMES expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [4, expr → expr • PLUS expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [5, expr → expr • SUB expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [6, expr → expr • ASSIGN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [8, expr → LET ID params EQUALS expr IN expr •, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → expr • SEMI expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
fn yy_state_45(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_SEMI => Shift(yy_state_28)
    T_ASSIGN => Shift(yy_state_30)
    T_SUB => Shift(yy_state_32)
    T_PLUS => Shift(yy_state_34)
    T_TIMES => Shift(yy_state_36)
    T_LEQ => Shift(yy_state_38)
    T_RPAREN | T_IN | T_THEN | T_ELSE | T_EOF => Reduce(7, NT_expr, yy_action_8)
    _ => Error
  }
}

// [1, expr → • simpl_expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [2, expr → • expr LEQ expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [3, expr → • expr TIMES expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [4, expr → • expr PLUS expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [5, expr → • expr SUB expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [6, expr → • expr ASSIGN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [7, expr → • LET ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [7, expr → LET ID EQUALS • expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [8, expr → • LET ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [9, expr → • LETREC ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [10, expr → • LETREC ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [11, expr → • IF expr THEN expr ELSE expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [12, expr → • simpl_expr args, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [13, expr → • FUN params ARROW expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [14, expr → • expr SEMI expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [15, expr → • REF simpl_expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [16, expr → • DO expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [17, simpl_expr → • INT, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / IN / SEMI / DEREF]
// [18, simpl_expr → • ID, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / IN / SEMI / DEREF]
// [19, simpl_expr → • TRUE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / IN / SEMI / DEREF]
// [20, simpl_expr → • FALSE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / IN / SEMI / DEREF]
// [21, simpl_expr → • LPAREN RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / IN / SEMI / DEREF]
// [22, simpl_expr → • LPAREN expr RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / IN / SEMI / DEREF]
// [23, simpl_expr → • DEREF simpl_expr, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / IN / SEMI / DEREF]
fn yy_state_46(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_DEREF => Shift(yy_state_2)
    T_LPAREN => Shift(yy_state_4)
    T_FALSE => Shift(yy_state_6)
    T_TRUE => Shift(yy_state_7)
    T_ID => Shift(yy_state_8)
    T_INT => Shift(yy_state_9)
    T_DO => Shift(yy_state_10)
    T_REF => Shift(yy_state_11)
    T_FUN => Shift(yy_state_13)
    T_IF => Shift(yy_state_18)
    T_LETREC => Shift(yy_state_19)
    T_LET => Shift(yy_state_23)
    NT_simpl_expr => Shift(yy_state_40)
    NT_expr => Shift(yy_state_47)
    _ => Error
  }
}

// [2, expr → expr • LEQ expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [3, expr → expr • TIMES expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [4, expr → expr • PLUS expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [5, expr → expr • SUB expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [6, expr → expr • ASSIGN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [7, expr → LET ID EQUALS expr • IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → expr • SEMI expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
fn yy_state_47(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_SEMI => Shift(yy_state_28)
    T_ASSIGN => Shift(yy_state_30)
    T_SUB => Shift(yy_state_32)
    T_PLUS => Shift(yy_state_34)
    T_TIMES => Shift(yy_state_36)
    T_LEQ => Shift(yy_state_38)
    T_IN => Shift(yy_state_48)
    _ => Error
  }
}

// [1, expr → • simpl_expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [2, expr → • expr LEQ expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [3, expr → • expr TIMES expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [4, expr → • expr PLUS expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [5, expr → • expr SUB expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [6, expr → • expr ASSIGN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [7, expr → • LET ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [7, expr → LET ID EQUALS expr IN • expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [8, expr → • LET ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [9, expr → • LETREC ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [10, expr → • LETREC ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [11, expr → • IF expr THEN expr ELSE expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [12, expr → • simpl_expr args, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [13, expr → • FUN params ARROW expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → • expr SEMI expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [15, expr → • REF simpl_expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [16, expr → • DO expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [17, simpl_expr → • INT, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [18, simpl_expr → • ID, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [19, simpl_expr → • TRUE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [20, simpl_expr → • FALSE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [21, simpl_expr → • LPAREN RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [22, simpl_expr → • LPAREN expr RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [23, simpl_expr → • DEREF simpl_expr, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
fn yy_state_48(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_DEREF => Shift(yy_state_2)
    T_LPAREN => Shift(yy_state_4)
    T_FALSE => Shift(yy_state_6)
    T_TRUE => Shift(yy_state_7)
    T_ID => Shift(yy_state_8)
    T_INT => Shift(yy_state_9)
    T_DO => Shift(yy_state_10)
    T_REF => Shift(yy_state_11)
    T_FUN => Shift(yy_state_13)
    T_IF => Shift(yy_state_18)
    T_LETREC => Shift(yy_state_19)
    T_LET => Shift(yy_state_23)
    NT_simpl_expr => Shift(yy_state_40)
    NT_expr => Shift(yy_state_49)
    _ => Error
  }
}

// [2, expr → expr • LEQ expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [3, expr → expr • TIMES expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [4, expr → expr • PLUS expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [5, expr → expr • SUB expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [6, expr → expr • ASSIGN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [7, expr → LET ID EQUALS expr IN expr •, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → expr • SEMI expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
fn yy_state_49(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_SEMI => Shift(yy_state_28)
    T_ASSIGN => Shift(yy_state_30)
    T_SUB => Shift(yy_state_32)
    T_PLUS => Shift(yy_state_34)
    T_TIMES => Shift(yy_state_36)
    T_LEQ => Shift(yy_state_38)
    T_RPAREN | T_IN | T_THEN | T_ELSE | T_EOF => Reduce(6, NT_expr, yy_action_7)
    _ => Error
  }
}

// [2, expr → expr • LEQ expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [3, expr → expr • TIMES expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [4, expr → expr • PLUS expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [5, expr → expr • SUB expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [6, expr → expr • ASSIGN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [10, expr → LETREC ID params EQUALS expr • IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → expr • SEMI expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
fn yy_state_50(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_SEMI => Shift(yy_state_28)
    T_ASSIGN => Shift(yy_state_30)
    T_SUB => Shift(yy_state_32)
    T_PLUS => Shift(yy_state_34)
    T_TIMES => Shift(yy_state_36)
    T_LEQ => Shift(yy_state_38)
    T_IN => Shift(yy_state_51)
    _ => Error
  }
}

// [1, expr → • simpl_expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [2, expr → • expr LEQ expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [3, expr → • expr TIMES expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [4, expr → • expr PLUS expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [5, expr → • expr SUB expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [6, expr → • expr ASSIGN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [7, expr → • LET ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [8, expr → • LET ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [9, expr → • LETREC ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [10, expr → • LETREC ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [10, expr → LETREC ID params EQUALS expr IN • expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [11, expr → • IF expr THEN expr ELSE expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [12, expr → • simpl_expr args, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [13, expr → • FUN params ARROW expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → • expr SEMI expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [15, expr → • REF simpl_expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [16, expr → • DO expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [17, simpl_expr → • INT, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [18, simpl_expr → • ID, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [19, simpl_expr → • TRUE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [20, simpl_expr → • FALSE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [21, simpl_expr → • LPAREN RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [22, simpl_expr → • LPAREN expr RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [23, simpl_expr → • DEREF simpl_expr, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
fn yy_state_51(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_DEREF => Shift(yy_state_2)
    T_LPAREN => Shift(yy_state_4)
    T_FALSE => Shift(yy_state_6)
    T_TRUE => Shift(yy_state_7)
    T_ID => Shift(yy_state_8)
    T_INT => Shift(yy_state_9)
    T_DO => Shift(yy_state_10)
    T_REF => Shift(yy_state_11)
    T_FUN => Shift(yy_state_13)
    T_IF => Shift(yy_state_18)
    T_LETREC => Shift(yy_state_19)
    T_LET => Shift(yy_state_23)
    NT_simpl_expr => Shift(yy_state_40)
    NT_expr => Shift(yy_state_52)
    _ => Error
  }
}

// [2, expr → expr • LEQ expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [3, expr → expr • TIMES expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [4, expr → expr • PLUS expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [5, expr → expr • SUB expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [6, expr → expr • ASSIGN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [10, expr → LETREC ID params EQUALS expr IN expr •, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → expr • SEMI expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
fn yy_state_52(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_SEMI => Shift(yy_state_28)
    T_ASSIGN => Shift(yy_state_30)
    T_SUB => Shift(yy_state_32)
    T_PLUS => Shift(yy_state_34)
    T_TIMES => Shift(yy_state_36)
    T_LEQ => Shift(yy_state_38)
    T_RPAREN | T_IN | T_THEN | T_ELSE | T_EOF => Reduce(7, NT_expr, yy_action_6)
    _ => Error
  }
}

// [1, expr → • simpl_expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [2, expr → • expr LEQ expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [3, expr → • expr TIMES expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [4, expr → • expr PLUS expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [5, expr → • expr SUB expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [6, expr → • expr ASSIGN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [7, expr → • LET ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [8, expr → • LET ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [9, expr → • LETREC ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [9, expr → LETREC ID EQUALS • expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [10, expr → • LETREC ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [11, expr → • IF expr THEN expr ELSE expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [12, expr → • simpl_expr args, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [13, expr → • FUN params ARROW expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [14, expr → • expr SEMI expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [15, expr → • REF simpl_expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [16, expr → • DO expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [17, simpl_expr → • INT, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / IN / SEMI / DEREF]
// [18, simpl_expr → • ID, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / IN / SEMI / DEREF]
// [19, simpl_expr → • TRUE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / IN / SEMI / DEREF]
// [20, simpl_expr → • FALSE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / IN / SEMI / DEREF]
// [21, simpl_expr → • LPAREN RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / IN / SEMI / DEREF]
// [22, simpl_expr → • LPAREN expr RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / IN / SEMI / DEREF]
// [23, simpl_expr → • DEREF simpl_expr, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / IN / SEMI / DEREF]
fn yy_state_53(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_DEREF => Shift(yy_state_2)
    T_LPAREN => Shift(yy_state_4)
    T_FALSE => Shift(yy_state_6)
    T_TRUE => Shift(yy_state_7)
    T_ID => Shift(yy_state_8)
    T_INT => Shift(yy_state_9)
    T_DO => Shift(yy_state_10)
    T_REF => Shift(yy_state_11)
    T_FUN => Shift(yy_state_13)
    T_IF => Shift(yy_state_18)
    T_LETREC => Shift(yy_state_19)
    T_LET => Shift(yy_state_23)
    NT_simpl_expr => Shift(yy_state_40)
    NT_expr => Shift(yy_state_54)
    _ => Error
  }
}

// [2, expr → expr • LEQ expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [3, expr → expr • TIMES expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [4, expr → expr • PLUS expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [5, expr → expr • SUB expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [6, expr → expr • ASSIGN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
// [9, expr → LETREC ID EQUALS expr • IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → expr • SEMI expr, LEQ / TIMES / PLUS / SUB / ASSIGN / IN / SEMI]
fn yy_state_54(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_SEMI => Shift(yy_state_28)
    T_ASSIGN => Shift(yy_state_30)
    T_SUB => Shift(yy_state_32)
    T_PLUS => Shift(yy_state_34)
    T_TIMES => Shift(yy_state_36)
    T_LEQ => Shift(yy_state_38)
    T_IN => Shift(yy_state_55)
    _ => Error
  }
}

// [1, expr → • simpl_expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [2, expr → • expr LEQ expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [3, expr → • expr TIMES expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [4, expr → • expr PLUS expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [5, expr → • expr SUB expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [6, expr → • expr ASSIGN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [7, expr → • LET ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [8, expr → • LET ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [9, expr → • LETREC ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [9, expr → LETREC ID EQUALS expr IN • expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [10, expr → • LETREC ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [11, expr → • IF expr THEN expr ELSE expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [12, expr → • simpl_expr args, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [13, expr → • FUN params ARROW expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → • expr SEMI expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [15, expr → • REF simpl_expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [16, expr → • DO expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [17, simpl_expr → • INT, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [18, simpl_expr → • ID, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [19, simpl_expr → • TRUE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [20, simpl_expr → • FALSE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [21, simpl_expr → • LPAREN RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [22, simpl_expr → • LPAREN expr RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [23, simpl_expr → • DEREF simpl_expr, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
fn yy_state_55(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_DEREF => Shift(yy_state_2)
    T_LPAREN => Shift(yy_state_4)
    T_FALSE => Shift(yy_state_6)
    T_TRUE => Shift(yy_state_7)
    T_ID => Shift(yy_state_8)
    T_INT => Shift(yy_state_9)
    T_DO => Shift(yy_state_10)
    T_REF => Shift(yy_state_11)
    T_FUN => Shift(yy_state_13)
    T_IF => Shift(yy_state_18)
    T_LETREC => Shift(yy_state_19)
    T_LET => Shift(yy_state_23)
    NT_simpl_expr => Shift(yy_state_40)
    NT_expr => Shift(yy_state_56)
    _ => Error
  }
}

// [2, expr → expr • LEQ expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [3, expr → expr • TIMES expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [4, expr → expr • PLUS expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [5, expr → expr • SUB expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [6, expr → expr • ASSIGN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [9, expr → LETREC ID EQUALS expr IN expr •, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → expr • SEMI expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
fn yy_state_56(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_SEMI => Shift(yy_state_28)
    T_ASSIGN => Shift(yy_state_30)
    T_SUB => Shift(yy_state_32)
    T_PLUS => Shift(yy_state_34)
    T_TIMES => Shift(yy_state_36)
    T_LEQ => Shift(yy_state_38)
    T_RPAREN | T_IN | T_THEN | T_ELSE | T_EOF => Reduce(6, NT_expr, yy_action_5)
    _ => Error
  }
}

// [2, expr → expr • LEQ expr, LEQ / TIMES / PLUS / SUB / ASSIGN / THEN / SEMI]
// [3, expr → expr • TIMES expr, LEQ / TIMES / PLUS / SUB / ASSIGN / THEN / SEMI]
// [4, expr → expr • PLUS expr, LEQ / TIMES / PLUS / SUB / ASSIGN / THEN / SEMI]
// [5, expr → expr • SUB expr, LEQ / TIMES / PLUS / SUB / ASSIGN / THEN / SEMI]
// [6, expr → expr • ASSIGN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / THEN / SEMI]
// [11, expr → IF expr • THEN expr ELSE expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → expr • SEMI expr, LEQ / TIMES / PLUS / SUB / ASSIGN / THEN / SEMI]
fn yy_state_57(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_SEMI => Shift(yy_state_28)
    T_ASSIGN => Shift(yy_state_30)
    T_SUB => Shift(yy_state_32)
    T_PLUS => Shift(yy_state_34)
    T_TIMES => Shift(yy_state_36)
    T_LEQ => Shift(yy_state_38)
    T_THEN => Shift(yy_state_58)
    _ => Error
  }
}

// [1, expr → • simpl_expr, LEQ / TIMES / PLUS / SUB / ASSIGN / ELSE / SEMI]
// [2, expr → • expr LEQ expr, LEQ / TIMES / PLUS / SUB / ASSIGN / ELSE / SEMI]
// [3, expr → • expr TIMES expr, LEQ / TIMES / PLUS / SUB / ASSIGN / ELSE / SEMI]
// [4, expr → • expr PLUS expr, LEQ / TIMES / PLUS / SUB / ASSIGN / ELSE / SEMI]
// [5, expr → • expr SUB expr, LEQ / TIMES / PLUS / SUB / ASSIGN / ELSE / SEMI]
// [6, expr → • expr ASSIGN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / ELSE / SEMI]
// [7, expr → • LET ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / ELSE / SEMI]
// [8, expr → • LET ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / ELSE / SEMI]
// [9, expr → • LETREC ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / ELSE / SEMI]
// [10, expr → • LETREC ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / ELSE / SEMI]
// [11, expr → • IF expr THEN expr ELSE expr, LEQ / TIMES / PLUS / SUB / ASSIGN / ELSE / SEMI]
// [11, expr → IF expr THEN • expr ELSE expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [12, expr → • simpl_expr args, LEQ / TIMES / PLUS / SUB / ASSIGN / ELSE / SEMI]
// [13, expr → • FUN params ARROW expr, LEQ / TIMES / PLUS / SUB / ASSIGN / ELSE / SEMI]
// [14, expr → • expr SEMI expr, LEQ / TIMES / PLUS / SUB / ASSIGN / ELSE / SEMI]
// [15, expr → • REF simpl_expr, LEQ / TIMES / PLUS / SUB / ASSIGN / ELSE / SEMI]
// [16, expr → • DO expr, LEQ / TIMES / PLUS / SUB / ASSIGN / ELSE / SEMI]
// [17, simpl_expr → • INT, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / ELSE / SEMI / DEREF]
// [18, simpl_expr → • ID, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / ELSE / SEMI / DEREF]
// [19, simpl_expr → • TRUE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / ELSE / SEMI / DEREF]
// [20, simpl_expr → • FALSE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / ELSE / SEMI / DEREF]
// [21, simpl_expr → • LPAREN RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / ELSE / SEMI / DEREF]
// [22, simpl_expr → • LPAREN expr RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / ELSE / SEMI / DEREF]
// [23, simpl_expr → • DEREF simpl_expr, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / ASSIGN / ELSE / SEMI / DEREF]
fn yy_state_58(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_DEREF => Shift(yy_state_2)
    T_LPAREN => Shift(yy_state_4)
    T_FALSE => Shift(yy_state_6)
    T_TRUE => Shift(yy_state_7)
    T_ID => Shift(yy_state_8)
    T_INT => Shift(yy_state_9)
    T_DO => Shift(yy_state_10)
    T_REF => Shift(yy_state_11)
    T_FUN => Shift(yy_state_13)
    T_IF => Shift(yy_state_18)
    T_LETREC => Shift(yy_state_19)
    T_LET => Shift(yy_state_23)
    NT_simpl_expr => Shift(yy_state_40)
    NT_expr => Shift(yy_state_59)
    _ => Error
  }
}

// [2, expr → expr • LEQ expr, LEQ / TIMES / PLUS / SUB / ASSIGN / ELSE / SEMI]
// [3, expr → expr • TIMES expr, LEQ / TIMES / PLUS / SUB / ASSIGN / ELSE / SEMI]
// [4, expr → expr • PLUS expr, LEQ / TIMES / PLUS / SUB / ASSIGN / ELSE / SEMI]
// [5, expr → expr • SUB expr, LEQ / TIMES / PLUS / SUB / ASSIGN / ELSE / SEMI]
// [6, expr → expr • ASSIGN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / ELSE / SEMI]
// [11, expr → IF expr THEN expr • ELSE expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → expr • SEMI expr, LEQ / TIMES / PLUS / SUB / ASSIGN / ELSE / SEMI]
fn yy_state_59(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_SEMI => Shift(yy_state_28)
    T_ASSIGN => Shift(yy_state_30)
    T_SUB => Shift(yy_state_32)
    T_PLUS => Shift(yy_state_34)
    T_TIMES => Shift(yy_state_36)
    T_LEQ => Shift(yy_state_38)
    T_ELSE => Shift(yy_state_60)
    _ => Error
  }
}

// [1, expr → • simpl_expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [2, expr → • expr LEQ expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [3, expr → • expr TIMES expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [4, expr → • expr PLUS expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [5, expr → • expr SUB expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [6, expr → • expr ASSIGN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [7, expr → • LET ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [8, expr → • LET ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [9, expr → • LETREC ID EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [10, expr → • LETREC ID params EQUALS expr IN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [11, expr → • IF expr THEN expr ELSE expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [11, expr → IF expr THEN expr ELSE • expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [12, expr → • simpl_expr args, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [13, expr → • FUN params ARROW expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → • expr SEMI expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [15, expr → • REF simpl_expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [16, expr → • DO expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [17, simpl_expr → • INT, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [18, simpl_expr → • ID, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [19, simpl_expr → • TRUE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [20, simpl_expr → • FALSE, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [21, simpl_expr → • LPAREN RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [22, simpl_expr → • LPAREN expr RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
// [23, simpl_expr → • DEREF simpl_expr, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
fn yy_state_60(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_DEREF => Shift(yy_state_2)
    T_LPAREN => Shift(yy_state_4)
    T_FALSE => Shift(yy_state_6)
    T_TRUE => Shift(yy_state_7)
    T_ID => Shift(yy_state_8)
    T_INT => Shift(yy_state_9)
    T_DO => Shift(yy_state_10)
    T_REF => Shift(yy_state_11)
    T_FUN => Shift(yy_state_13)
    T_IF => Shift(yy_state_18)
    T_LETREC => Shift(yy_state_19)
    T_LET => Shift(yy_state_23)
    NT_simpl_expr => Shift(yy_state_40)
    NT_expr => Shift(yy_state_61)
    _ => Error
  }
}

// [2, expr → expr • LEQ expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [3, expr → expr • TIMES expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [4, expr → expr • PLUS expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [5, expr → expr • SUB expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [6, expr → expr • ASSIGN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [11, expr → IF expr THEN expr ELSE expr •, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → expr • SEMI expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
fn yy_state_61(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_ASSIGN => Shift(yy_state_30)
    T_SUB => Shift(yy_state_32)
    T_PLUS => Shift(yy_state_34)
    T_TIMES => Shift(yy_state_36)
    T_LEQ => Shift(yy_state_38)
    T_RPAREN | T_IN | T_THEN | T_ELSE | T_SEMI | T_EOF => Reduce(6, NT_expr, yy_action_4)
    _ => Error
  }
}

// [2, expr → expr • LEQ expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [3, expr → expr • TIMES expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [4, expr → expr • PLUS expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [5, expr → expr • SUB expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [6, expr → expr • ASSIGN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [13, expr → FUN params ARROW expr •, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → expr • SEMI expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
fn yy_state_62(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_SEMI => Shift(yy_state_28)
    T_ASSIGN => Shift(yy_state_30)
    T_SUB => Shift(yy_state_32)
    T_PLUS => Shift(yy_state_34)
    T_TIMES => Shift(yy_state_36)
    T_LEQ => Shift(yy_state_38)
    T_RPAREN | T_IN | T_THEN | T_ELSE | T_EOF => Reduce(4, NT_expr, yy_action_3)
    _ => Error
  }
}

// [2, expr → expr • LEQ expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [3, expr → expr • TIMES expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [4, expr → expr • PLUS expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [5, expr → expr • SUB expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [6, expr → expr • ASSIGN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [14, expr → expr • SEMI expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
// [16, expr → DO expr •, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / EOF]
fn yy_state_63(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_SEMI => Shift(yy_state_28)
    T_ASSIGN => Shift(yy_state_30)
    T_SUB => Shift(yy_state_32)
    T_PLUS => Shift(yy_state_34)
    T_TIMES => Shift(yy_state_36)
    T_LEQ => Shift(yy_state_38)
    T_RPAREN | T_IN | T_THEN | T_ELSE | T_EOF => Reduce(2, NT_expr, yy_action_2)
    _ => Error
  }
}

// [2, expr → expr • LEQ expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / SEMI]
// [3, expr → expr • TIMES expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / SEMI]
// [4, expr → expr • PLUS expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / SEMI]
// [5, expr → expr • SUB expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / SEMI]
// [6, expr → expr • ASSIGN expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / SEMI]
// [14, expr → expr • SEMI expr, LEQ / TIMES / PLUS / SUB / RPAREN / ASSIGN / SEMI]
// [22, simpl_expr → LPAREN expr • RPAREN, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
fn yy_state_64(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_SEMI => Shift(yy_state_28)
    T_ASSIGN => Shift(yy_state_30)
    T_SUB => Shift(yy_state_32)
    T_PLUS => Shift(yy_state_34)
    T_TIMES => Shift(yy_state_36)
    T_LEQ => Shift(yy_state_38)
    T_RPAREN => Shift(yy_state_65)
    _ => Error
  }
}

// [22, simpl_expr → LPAREN expr RPAREN •, INT / ID / TRUE / FALSE / LEQ / TIMES / PLUS / SUB / LPAREN / RPAREN / ASSIGN / IN / THEN / ELSE / SEMI / DEREF / EOF]
fn yy_state_65(_lookahead : YYSymbol) -> YYDecision {
  ReduceNoLookahead(3, NT_simpl_expr, yy_action_1)
}

// [0, prog → expr • EOF, $]
// [2, expr → expr • LEQ expr, LEQ / TIMES / PLUS / SUB / ASSIGN / SEMI / EOF]
// [3, expr → expr • TIMES expr, LEQ / TIMES / PLUS / SUB / ASSIGN / SEMI / EOF]
// [4, expr → expr • PLUS expr, LEQ / TIMES / PLUS / SUB / ASSIGN / SEMI / EOF]
// [5, expr → expr • SUB expr, LEQ / TIMES / PLUS / SUB / ASSIGN / SEMI / EOF]
// [6, expr → expr • ASSIGN expr, LEQ / TIMES / PLUS / SUB / ASSIGN / SEMI / EOF]
// [14, expr → expr • SEMI expr, LEQ / TIMES / PLUS / SUB / ASSIGN / SEMI / EOF]
fn yy_state_66(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_SEMI => Shift(yy_state_28)
    T_ASSIGN => Shift(yy_state_30)
    T_SUB => Shift(yy_state_32)
    T_PLUS => Shift(yy_state_34)
    T_TIMES => Shift(yy_state_36)
    T_LEQ => Shift(yy_state_38)
    T_EOF => Shift(yy_state_67)
    _ => Error
  }
}

// [0, prog → expr EOF •, $]
fn yy_state_67(_lookahead : YYSymbol) -> YYDecision {
  ReduceNoLookahead(2, NT_prog, yy_action_0)
}

fn[T] yy_parse(
  tokens : Array[(Token, Int, Int)],
  start : YYState,
  return_ : (YYObj) -> T,
  initial_pos? : Int,
) -> T raise ParseError {
  let mut cursor = 0
  let mut state_stack : @list.List[YYState] = @list.cons(start, @list.empty())
  let data_stack : Array[(YYObj, Int, Int)] = []
  let mut last_pos = initial_pos.unwrap_or(tokens[0].1)
  let mut state = start
  let mut lookahead : Option[(YYSymbol, (YYObj, Int, Int), Token?)] = None
  let mut last_shifted_state_stack = state_stack
  while true {
    let decision = match state(EOI) {
      ReduceNoLookahead(_) | Accept as t => t
      _ => {
        match lookahead {
          Some(la) => state(la.0)
          None => {
            if cursor < tokens.length() {
              let (token, start_pos, end_pos) = tokens[cursor]
              cursor += 1
              let (symbol, data) = yy_input(token, start_pos, end_pos)
              lookahead = Some((symbol, (data, start_pos, end_pos), Some(token)))
              state(symbol)
            } else {
              lookahead = Some((EOI, (YYObj_Void, last_pos, last_pos), None))
              state(EOI)
            }
          }
        }
      }
    }
    match decision {
      Accept => return return_(data_stack.unsafe_pop().0)
      Shift(next_state) => {
        guard lookahead is Some(la)
        data_stack.push(la.1)
        state_stack = @list.cons(next_state, state_stack)
        last_shifted_state_stack = state_stack
        state = next_state
        last_pos = la.1.2
        lookahead = None
      }
      Reduce(count, symbol, action)
      | ReduceNoLookahead(count, symbol, action) => {
        loop (count, symbol, action) {
          _ => {
            let args = data_stack[data_stack.length() - count:]
            let data = action(last_pos, args)
            let (start_pos, end_pos) = if args.length() == 0 {
              (last_pos, last_pos)
            } else {
              (args[0].1, args[args.length() - 1].2)
            }
            for i in 0..<count {
              ignore(data_stack.unsafe_pop())
              state_stack = state_stack.unsafe_tail()
            }
            state = state_stack.unsafe_head()
            data_stack.push((data, start_pos, end_pos))
            match state(symbol) {
              Accept => return return_(data_stack.unsafe_pop().0)
              Shift(next_state) => {
                state_stack = @list.cons(next_state, state_stack)
                state = next_state
              }
              Reduce(count, symbol, action)
              | ReduceNoLookahead(count, symbol, action) => continue (count, symbol, action)
              _ => panic()
            }
          }
        }
      }
      Error => {
        let (_, (_, start_pos, end_pos), token) = lookahead.unwrap()
        error(last_shifted_state_stack, token, (start_pos, end_pos))
      }
    }
  }
  panic()
}

fn error(stack : @list.List[YYState], token : Token?, loc : (Int, Int)) -> Unit raise ParseError {
  let expected = []
  fn try_add(symbol : YYSymbol, kind : TokenKind) {
    fn go(stack : @list.List[YYState]) {
      match stack {
        Empty => ()
        More(state, ..) => {
          match state(symbol) {
            Accept | Shift(_) => expected.push(kind)
            Reduce(count, symbol, _) | ReduceNoLookahead(count, symbol, _) => {
              fn inner_go(stack : @list.List[YYState], count, symbol) {
                let stack = stack.drop(count)
                guard stack is More(state, ..)
                match state(symbol) {
                  Shift(state) => go(@list.cons(state, stack))
                  Reduce(count, symbol, _) | ReduceNoLookahead(count, symbol, _) => inner_go(stack, count, symbol)
                  _ => panic()
                }
              }
              inner_go(stack, count, symbol)
            }
            Error => ()
          }
        }
      }
    }
    go(stack)
  }
  for term in ([(T_INT, TK_INT), (T_ID, TK_ID), (T_TRUE, TK_TRUE), (T_FALSE, TK_FALSE), (T_LEQ, TK_LEQ), (T_TIMES, TK_TIMES), (T_PLUS, TK_PLUS), (T_SUB, TK_SUB), (T_LPAREN, TK_LPAREN), (T_RPAREN, TK_RPAREN), (T_LET, TK_LET), (T_LETREC, TK_LETREC), (T_EQUALS, TK_EQUALS), (T_ASSIGN, TK_ASSIGN), (T_IN, TK_IN), (T_IF, TK_IF), (T_THEN, TK_THEN), (T_ELSE, TK_ELSE), (T_FUN, TK_FUN), (T_ARROW, TK_ARROW), (T_SEMI, TK_SEMI), (T_REF, TK_REF), (T_DEREF, TK_DEREF), (T_DO, TK_DO), (T_EOF, TK_EOF)] : Array[(YYSymbol, TokenKind)]) {
    try_add(term.0, term.1)
  }
  match token {
    None => raise UnexpectedEndOfInput(loc.1, expected)
    Some(token) => raise UnexpectedToken(token, loc, expected)
  }
}

pub fn prog(tokens : Array[(Token, Int, Int)], initial_pos? : Int) -> Expr raise ParseError {
  yy_parse(
    tokens,
    yy_state_0,
    (it) => {
      guard it is YYObj_Expr(result)
      result
    },
    initial_pos?,
  )
}
