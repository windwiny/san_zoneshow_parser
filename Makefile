

.PHONY: all ruby diff

all: c_zs ruby


c_zs: z.tab.c z.lex.c
	gcc -o c_zs $<

z.tab.c: z.y
	bison -v -d $<

z.lex.c: z.l
	flex -o $@ $<

ruby: zoneshow.tab.rb zoneshow.rex.rb


zoneshow.tab.rb: zoneshow.racc
	racc -v $<

zoneshow.rex.rb: zoneshow.rex
	rex $< --stub

diff: all
	ruby run_diff.rb
