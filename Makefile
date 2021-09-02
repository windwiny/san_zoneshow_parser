

.PHONY: all ruby diff

all: c_zs ruby go_zs


c_zs: z.tab.c z.lex.c
	gcc -o c_zs $<

z.tab.c: z.y
	bison -v -d $<

z.lex.c: z.l
	flex -o $@ $<


ruby: zoneshow.tab.rb zoneshow.rex.rb reformat-san-script.rb reformat-san-script.rex.rb



reformat-san-script.rb: reformat-san-script.racc
	racc $< -o $@

reformat-san-script.rex.rb: reformat-san-script.rex
	rex $< --stub

zoneshow.tab.rb: zoneshow.racc
	racc -v $<

zoneshow.rex.rb: zoneshow.rex
	rex $< --stub


go_zs: main.go go.y.go go.nn.go
	go build -o $@  main.go go.y.go go.nn.go

go.y.go: go.y
	goyacc -p zonesh -o $@ $<

go.nn.go: go.nex
	nex -p zonesh -o $@ $<


diff: all
	ruby run_diff.rb ${FILE}

