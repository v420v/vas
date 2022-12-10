module ast

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

pub struct IntExpr {
	pub:
		lit string
}

pub struct RegExpr {
	pub:
		name string
}

pub struct IdentExpr {
	pub:
		lit string
}

