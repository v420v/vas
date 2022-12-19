module ast

import token

pub type Instr = Mov | Label | Call | Ret | Nop | Syscall | BadInst

pub struct Mov {
	pub mut:
		left  Expr
		right Expr
		pos   token.Position
		code  []u8
}

pub struct Label {
	pub mut:
		name string
		pos   token.Position
}

pub struct Call {
	pub mut:
		expr   Expr
		offset int
		pos    token.Position
		code   []u8
}

pub struct Ret {
	pub mut:
		pos token.Position
		code []u8
}

pub struct Nop {
	pub mut:
		pos   token.Position
		code  []u8
}

pub struct Syscall {
	pub mut:
		pos   token.Position
		code  []u8
}

pub struct BadInst {}

pub type Expr = IntExpr | RegExpr | IdentExpr

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

pub struct IdentExpr {
	pub:
		name string
		pos  token.Position
}


