module ast

import lexer

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
}

pub type Expr = IntExpr | RegExpr

pub struct RegExpr {
	pub:
	    bit int
	    lit  string
	    pos  lexer.Position
}

pub struct IntExpr {
	pub:
	    lit  string
	    pos  lexer.Position
}


