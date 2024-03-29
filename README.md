# SAN zoneshow parser

    SAN zoneshow log parser and utils
    Compilers Principles Practice

    flex/bison      C language
    rexical/racc    Ruby language
    nex/yacc        Go language
    ANTLR4 visitor/listener  Java/Python3/TypeScript language

## prepare

    show Makefile    , generate code, compile and run
    show run_diff.rb , lexer/parser usage

    ruby
      gem install rexical racc

    c flex/bison

    go
      github.com/blynn/nex
      golang.org/x/tools/cmd/goyacc

    antlr4
     copy or link antlr-latest-complete.jar(>=4.12 for TypeScript target) to project directory.
     install antlr4 runtime
      java         CLASSPATH=.:$(pwd)/antlr-latest-complete.jar
      python       pip3 install antlr4-python3-runtime
      node js/ts   pnpm i -D antlr4 vite typescript

## run make create:

    c_zs
    zoneshow.tab.rb
    go_zs
    vantlr4/(java,py3,ts)(visitor,listener)

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

    # from logfile generate create scripts
    ruby zoneshow.tab.rb cfg4.txt --keeporder
    # or
    $keeporder = true
    SANUtil.parse_file(fn)

    # from logfile generate Hash
    SANUtil.sanlog2kvs(fn)

## other antlr

    ./go_zs < cfg4.txt

    python vantlr4/MainListener.py < cfg4.txt
    python vantlr4/MainVisitor.py  < cfg4.txt

    java -cp vantlr4:antlr-latest-complete.jar  ListenerMain < cfg4.txt
    java -cp vantlr4:antlr-latest-complete.jar  ListenerMain   cfg4.txt

    java -cp vantlr4:antlr-latest-complete.jar  VisitorMain < cfg4.txt
    java -cp vantlr4:antlr-latest-complete.jar  VisitorMain   cfg4.txt

## other antlr javascript/typescript node/web env

    #   Refer to the Makefile
    # npmjs package  antlr4 >= 4.12.0
    # add `"targets": {"chrome": "58","node":"16"}` to .babelrc, run npx webpack rebuild dist/ generate ES6 js

    make ts_vis ts_lis

    tsc xxx
    ruby util-add-js-suffix.rb

    node vantlr4/ts2js/TsMainListener-node.js < cfg4.txt
    node vantlr4/ts2js/TsMainVisitor-node.js  < cfg4.txt

    # work on web
    vite                 # dev open web browser show html
    vite build -c xxx    # build, and/or can change`<script>` in html,
    ruby util-html-ch-nomodule.rb
