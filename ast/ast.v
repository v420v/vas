module ast

import token

pub enum OpKind {
	mov
	nop
	syscall
}

pub struct Op {
	pub mut:
		kind OpKind
		left Expr
		right Expr
		pos  token.Position
}

pub type Expr = IntExpr | RegExpr

pub struct RegExpr {
	pub:
	    bit int
	    lit  string
	    pos  token.Position
}

pub struct IntExpr {
	pub:
	    lit  string
	    pos  token.Position
}


