module preprocessor

import token
import error

struct Preprocess {
pub mut:
	tok    token.Token
	tokens []token.Token
	idx    int
	macros map[string][]token.Token
}

fn (mut p Preprocess) next() {
	p.idx++
	p.tok = p.tokens[p.idx]
}

fn (mut p Preprocess) add_macro() {
	start := p.idx
	p.next()
	name := p.tok.lit

	if name in p.macros {
		error.print(p.tok.pos, 'macro $name is already defined')
		exit(1)
	}

	p.next()
	for p.tok.lit != '.end' {
		if p.tok.kind == .eof {
			error.print(p.tok.pos, 'end of file while still defining macro `$name`')
		} else if p.tok.lit == '.macro' {
			p.add_macro()
		} else {
			p.macros[name] << p.tok
			p.next()
		}
	}
	p.next()
	count := p.idx - start
	p.tokens.delete_many(start, count)
	p.idx -= count
}

pub fn new(tokens []token.Token) &Preprocess {
	return &Preprocess{
		tokens: tokens
	}
}

pub fn (mut p Preprocess) init() {
	p.tok = p.tokens[0]
	p.idx = 0
}

pub fn (mut p Preprocess) preprocess() {
	for {
		if p.tok.lit == '.macro' {
			p.add_macro()
		} else if p.tok.lit in p.macros {
			name := p.tok.lit
			idx := p.idx
			p.tokens.delete(idx)

			mut new := p.tokens[..idx]
			new << p.macros[name]
			new << p.tokens[idx..]

			p.tokens = new
			p.init()
			p.preprocess()
			return
		} else if p.tok.kind == .eof {
			break
		} else {
			p.next()
		}
	}
}

