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

    make ts_vis ts_lis   # generate ts target

    tsc -t es2020 -m es2020 --moduleResolution node --esModuleInterop --outDir vantlr4/ts2js vantlr4/TsMainListener-node.ts vantlr4/TsMainVisitor-node.ts

    # TODO FIXME js/ts

    grep -E "import.*TsMy[^']*|import.*ts_.is[^']*" vantlr4/ts2js/*
    ruby util-add-js-suffix.rb
      # 8 position add .js suffix

    node vantlr4/ts2js/TsMainListener-node.js < cfg4.txt
    node vantlr4/ts2js/TsMainVisitor-node.js  < cfg4.txt

    # work on web
    pnpm run vite      # dev open web browser show html
    pnpm run build     # build, and/or can change`<script>` in html,
    ruby util-html-ch-nomodule.rb
      # remove type-module crossorigin, use ./assets relative path , for offline use
