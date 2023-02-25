
## default target, build all source verion

.PHONY: all
all: ruby_zs c_zs go_zs   java_vis java_lis   py3_vis py3_lis   ts_vis ts_lis


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





ANTLRJAR:=antlr-latest-complete.jar
#antlr4:=java -Xmx500M -cp .:${ANTLRJAR} org.antlr.v4.Tool
#antlr4:=java -jar ${ANTLRJAR}

.PHONY: clean_antlr clean_antlr_go clean_antlr_java clean_antlr_py3 clean_antlr_ts

clean_antlr: clean_antlr_go clean_antlr_java clean_antlr_py3 clean_antlr_ts
clean_antlr_go:
	rm -fr vantlr4/go_lis vantlr4/go_vis
clean_antlr_java:
	rm -fr vantlr4/java_lis vantlr4/java_vis vantlr4/*.class
clean_antlr_py3:
	rm -fr vantlr4/py3_lis vantlr4/py3_vis
clean_antlr_ts:
	rm -fr vantlr4/ts_lis webgui-lis-release vantlr4/ts_vis webgui-vis-release vantlr4/ts2js



### java source ANTLR4 version
.PHONY: java_lis
java_lis:          java_lis_genfiles java_lis_userfiles
java_lis_genfiles: vantlr4/java_lis/ZoneshowListener.class vantlr4/java_lis/ZoneshowBaseListener.class vantlr4/java_lis/ZoneshowLexer.class vantlr4/java_lis/ZoneshowParser.class
java_lis_userfiles:vantlr4/ListenerMain.class vantlr4/ListenerMyImpl.class

vantlr4/Listener%.class : vantlr4/Listener%.java
	javac -cp .:vantlr4:${ANTLRJAR} vantlr4/Listener*.java

vantlr4/java_lis/Zoneshow%.class: Zoneshow.g4
	java -jar ${ANTLRJAR} -listener -no-visitor -o vantlr4/java_lis -package java_lis  $<
	javac -cp vantlr4:${ANTLRJAR} vantlr4/java_lis/*.java


.PHONY: java_vis
java_vis:          java_vis_genfiles java_vis_userfiles
java_vis_genfiles: vantlr4/java_vis/ZoneshowVisitor.class vantlr4/java_vis/ZoneshowBaseVisitor.class vantlr4/java_vis/ZoneshowLexer.class vantlr4/java_vis/ZoneshowParser.class
java_vis_userfiles:vantlr4/VisitorMain.class vantlr4/VisitorMyImpl.class

vantlr4/Visitor%.class : vantlr4/Visitor%.java
	javac -cp .:vantlr4:${ANTLRJAR} vantlr4/Visitor*.java

vantlr4/java_vis/Zoneshow%.class: Zoneshow.g4
	java -jar ${ANTLRJAR} -no-listener -visitor -o vantlr4/java_vis -package java_vis  $<
	javac -cp vantlr4:${ANTLRJAR} vantlr4/java_vis/*.java



### python source ANTLR4 version
.PHONY: py3_lis
py3_lis:          py3_lis_genfiles py3_lis_userfiles
py3_lis_genfiles: vantlr4/py3_lis/ZoneshowListener.py vantlr4/py3_lis/ZoneshowLexer.py vantlr4/py3_lis/ZoneshowParser.py
py3_lis_userfiles:vantlr4/MainListener.py vantlr4/MyListenerImpl.py

vantlr4/py3_lis/Zoneshow%.py:  Zoneshow.g4
	java -jar ${ANTLRJAR} -listener -no-visitor -Dlanguage=Python3 -o vantlr4/py3_lis  $<


.PHONY: py3_vis
py3_vis:          py3_vis_genfiles py3_vis_userfiles
py3_vis_genfiles: vantlr4/py3_vis/ZoneshowVisitor.py vantlr4/py3_vis/ZoneshowLexer.py vantlr4/py3_vis/ZoneshowParser.py
py3_vis_userfiles:vantlr4/MainVisitor.py vantlr4/MyVisitorImpl.py

vantlr4/py3_vis/Zoneshow%.py:  Zoneshow.g4
	java -jar ${ANTLRJAR} -no-listener -visitor -Dlanguage=Python3 -o vantlr4/py3_vis  $<



### JavaScript/TypeScript source ANTLR4 version
.PHONY: ts_lis
ts_lis:                ts_lis_genfiles_comm vantlr4/ts2js/TsMainListener-node.js webgui-lis-release/index-lis.html
ts_lis_genfiles_comm:  vantlr4/ts_lis/ZoneshowListener.ts vantlr4/ts_lis/ZoneshowLexer.ts vantlr4/ts_lis/ZoneshowParser.ts
ts_lis_userfiles_comm: vantlr4/TsMyListenerImpl.ts

vantlr4/ts_lis/Zoneshow%.ts:  Zoneshow.g4
	java -jar ${ANTLRJAR} -listener -no-visitor -Dlanguage=TypeScript -o vantlr4/ts_lis  $<
vantlr4/ts2js/TsMainListener-node.js: Zoneshow.g4 vantlr4/TsMyListenerImpl.ts vantlr4/TsMainListener-node.ts
	-tsc -t es2020 -m es2020 --moduleResolution node --esModuleInterop --outDir vantlr4/ts2js  vantlr4/TsMainListener-node.ts
	ruby util-add-js-suffix.rb --Listener
webgui-lis-release/index-lis.html:    Zoneshow.g4 vantlr4/TsMyListenerImpl.ts vantlr4/TsMainListener-web.ts vantlr4/TsMain-comm-web.ts index-lis.html
	vite build -c vite.config-weblis.js
	ruby util-html-ch-nomodule.rb --Listener


.PHONY: ts_vis
ts_vis:                ts_vis_genfiles_comm vantlr4/ts2js/TsMainVisitor-node.js webgui-vis-release/index-vis.html
ts_vis_genfiles_comm:  vantlr4/ts_vis/ZoneshowVisitor.ts vantlr4/ts_vis/ZoneshowLexer.ts vantlr4/ts_vis/ZoneshowParser.ts
ts_vis_userfiles_comm: vantlr4/TsMyVisitorImpl.ts

vantlr4/ts_vis/Zoneshow%.ts:  Zoneshow.g4
	java -jar ${ANTLRJAR} -no-listener -visitor -Dlanguage=TypeScript -o vantlr4/ts_vis  $<
vantlr4/ts2js/TsMainVisitor-node.js: Zoneshow.g4 vantlr4/TsMyVisitorImpl.ts vantlr4/TsMainVisitor-node.ts
	-tsc -t es2020 -m es2020 --moduleResolution node --esModuleInterop --outDir vantlr4/ts2js  vantlr4/TsMainVisitor-node.ts
	ruby util-add-js-suffix.rb --Visitor
webgui-vis-release/index-vis.html:   Zoneshow.g4 vantlr4/TsMyVisitorImpl.ts vantlr4/TsMainVisitor-web.ts vantlr4/TsMain-comm-web.ts index-vis.html
	vite build -c vite.config-webvis.js
	ruby util-html-ch-nomodule.rb --Visitor

