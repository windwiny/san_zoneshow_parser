
## default target, build all source verion

.PHONY: all
all: ruby_zs c_zs go_zs   java_vis java_lis   py3_vis py3_lis


## ruby all verion , show output is equal
## make FILE=xxx.log diff
.PHONY: diff
diff: all
	ruby run_diff.rb ${FILE}




### c source flex/bison version
c_zs: z.tab.c z.lex.c
	gcc -o c_zs $<

z.tab.c: z.y
	bison -v -d $<

z.lex.c: z.l
	flex -o $@ $<



### ruby source rexical/racc version
.PHONY: ruby_zs
ruby_zs: zoneshow.tab.rb zoneshow.rex.rb reformat-san-script.rb reformat-san-script.rex.rb


reformat-san-script.rb: reformat-san-script.racc
	racc $< -o $@

reformat-san-script.rex.rb: reformat-san-script.rex
	rex $< --stub

zoneshow.tab.rb: zoneshow.racc
	racc -v $<

zoneshow.rex.rb: zoneshow.rex
	rex $< --stub



### go source nex/goracc version
go_zs: main.go go.y.go go.nn.go
	go build -o $@  main.go go.y.go go.nn.go

go.y.go: go.y
	goyacc -p zonesh -o $@ $<

go.nn.go: go.nex
	nex -p zonesh -o $@ $<





ANTLRJAR:=antlr-4.10.1-complete.jar
#antlr4:=java -Xmx500M -cp .:${ANTLRJAR} org.antlr.v4.Tool
#antlr4:=java -jar ${ANTLRJAR}

.PHONY: clean_antlr

clean_antlr:
	rm -fr vantlr4/go_vis vantlr4/java_vis vantlr4/py3_vis
	rm -fr vantlr4/go_lis vantlr4/java_lis vantlr4/py3_lis
	rm -f vantlr4/*.class


### python source ANTLR4 version
.PHONY: py3_vis
py3_vis:          py3_vis_genfiles py3_vis_userfiles
py3_vis_genfiles: vantlr4/py3_vis/ZoneshowVisitor.py vantlr4/py3_vis/ZoneshowLexer.py vantlr4/py3_vis/ZoneshowParser.py
py3_vis_userfiles:vantlr4/MainVisitor.py vantlr4/MyVisitorImpl.py

vantlr4/py3_vis/Zoneshow%.py:  Zoneshow.g4
	java -jar ${ANTLRJAR} -no-listener -visitor -Dlanguage=Python3 -o vantlr4/py3_vis  $<


.PHONY: py3_lis
py3_lis:          py3_lis_genfiles py3_lis_userfiles
py3_lis_genfiles: vantlr4/py3_lis/ZoneshowListener.py vantlr4/py3_lis/ZoneshowLexer.py vantlr4/py3_lis/ZoneshowParser.py
py3_lis_userfiles:vantlr4/MainListener.py vantlr4/MyListenerImpl.py

vantlr4/py3_lis/Zoneshow%.py:  Zoneshow.g4
	java -jar ${ANTLRJAR} -listener -no-visitor -Dlanguage=Python3 -o vantlr4/py3_lis  $<


### java source ANTLR4 version
.PHONY: java_vis
java_vis:          java_vis_genfiles java_vis_userfiles
java_vis_genfiles: vantlr4/java_vis/ZoneshowVisitor.class vantlr4/java_vis/ZoneshowBaseVisitor.class vantlr4/java_vis/ZoneshowLexer.class vantlr4/java_vis/ZoneshowParser.class
java_vis_userfiles:vantlr4/VisitorMain.class vantlr4/VisitorMyImpl.class

vantlr4/Visitor%.class : vantlr4/Visitor%.java
	javac -cp .:vantlr4:vantlr4/java_vis:${ANTLRJAR} $<

vantlr4/java_vis/Zoneshow%.class: Zoneshow.g4
	java -jar ${ANTLRJAR} -no-listener -visitor -o vantlr4/java_vis  $<
	javac -cp .:vantlr4:vantlr4/java_vis:${ANTLRJAR} vantlr4/java_vis/*.java


.PHONY: java_lis
java_lis:          java_lis_genfiles java_lis_userfiles
java_lis_genfiles: vantlr4/java_lis/ZoneshowListener.class vantlr4/java_lis/ZoneshowBaseListener.class vantlr4/java_lis/ZoneshowLexer.class vantlr4/java_lis/ZoneshowParser.class
java_lis_userfiles:vantlr4/ListenerMain.class vantlr4/ListenerMyImpl.class

vantlr4/Listener%.class : vantlr4/Listener%.java
	javac -cp .:vantlr4:vantlr4/java_lis:${ANTLRJAR} $<

vantlr4/java_lis/Zoneshow%.class: Zoneshow.g4
	java -jar ${ANTLRJAR} -listener -no-visitor -o vantlr4/java_lis  $<
	javac -cp .:vantlr4:vantlr4/java_lis:${ANTLRJAR} vantlr4/java_lis/*.java



