
# SAN zoneshow parser

    SAN zoneshow log parser and utils
    Compilers Principles Practice

    flex/bison      C language
    rexical/racc    Ruby language
    nex/yacc        Go language
    ANTLR4 visitor/listener  Java/Python3 language



## run make create:

    c_zs
    zoneshow.tab.rb
    go_zs
    vantlr4/(python3,java)(visitor,listener)


## run parser syntax:

    ./c_zs < cfg4.txt
    ruby zoneshow.tab.rb cfg4.txt


## run lexical syntax:

    ./c_zs -l < cfg4.txt
    ruby zoneshow.rex.rb cfg4.txt


## diff c parser and ruby parser result

    make
    ruby run_diff.rb cfg4.txt
    make diff FILE=cfg4.txt

## other ruby util

    require 'sanuitl'
    puts SANUtil.singleton_methods

## other

    # copy or link antlr-4.10.1-complete.jar to project directory.

    other lexer/parser usage view run_diff.rb

    ./go_zs <cfg1.txt

    env PYTHONPATH=vantlr4/py3_vis python vantlr4/MainVisitor.py < cfg4.txt
    env PYTHONPATH=vantlr4/py3_vis python vantlr4/MainVisitor.py   cfg4.txt

    java -cp vantlr4:vantlr4/java_lis:antlr-4.10.1-complete.jar  ListenerMain < cfg4.txt
    java -cp vantlr4:vantlr4/java_lis:antlr-4.10.1-complete.jar  ListenerMain   cfg4.txt

    java -cp vantlr4:vantlr4/java_vis:antlr-4.10.1-complete.jar  VisitorMain < cfg4.txt
    java -cp vantlr4:vantlr4/java_vis:antlr-4.10.1-complete.jar  VisitorMain   cfg4.txt
