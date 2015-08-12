# san_zoneshow_parser
SAN zoneshow bison/racc parser

flex / rexical / bison / racc tool example.




## run make create:
    c_zs                flex + bison    C language version
    zoneshow.tab.rb     rex + racc      Ruby language version


## run parser syntax:
    ./c_zs < cfg4.txt                   C version
    ruby zoneshow.tab.rb cfg4.txt       Ruby version


## run lexical syntax:
    ./c_zs -l < cfg4.txt                C version
    ruby zoneshow.rex.rb cfg4.txt       Ruby version


## diff c parser and ruby parser result
    make
    ruby run_diff.rb
