//go:generate nex -p zonesh -o go.nn.go go.nex
//go:generate goyacc -p zonesh -o go.y.go go.y

package main

import (
	"flag"
	"os"
)

var SHOWTOKEN bool

func init() {
	flag.BoolVar(&SHOWTOKEN, "s", false, "show TOKEN?")
}

func main() {
	lex := NewLexer(os.Stdin)
	zoneshParse(lex)
	// fmt.Printf("ret=%d\n", ret)
}
