#!/usr/bin/env python3

import sys
from antlr4 import *
from py3_lis.ZoneshowLexer import ZoneshowLexer
from py3_lis.ZoneshowParser import ZoneshowParser

from MyListenerImpl import MyListenerImpl


deep = 2000
def main(infile=''):
    if infile:
        input_stream = FileStream(infile)
    else:
        input_stream = InputStream(sys.stdin.read())
    lexer = ZoneshowLexer(input_stream)
    stream = CommonTokenStream(lexer)
    parser = ZoneshowParser(stream)
    tree = parser.zoneshow()

    ppp = MyListenerImpl()
    w = ParseTreeWalker()

    while True: # break when walk finished
        try:
            w.walk(ppp, tree)
            break
        except RecursionError:
            global deep
            deep += 1000
            print(f'''\tRecursionError, set to {deep} , retry ...''', file=sys.stderr)
            sys.setrecursionlimit(deep)

    pass

if __name__ == '__main__':
    if len(sys.argv) > 1:
        main(sys.argv[1])
    else:
        main()

