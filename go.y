
%{
package main
import "fmt"
%}


%union {
    vRune rune
    vInt int
    vSlice []string
    vMap map[string][]string
    vString string
}

%token<vString> EFFECTIVE DEFINED NODEFINED NOEFFECTIVE CFG ZONE ALIAS
%token<vString> PORT WWPN NAME

%type<vInt> zoneshow defx effx
%type<vSlice> zns ans aps ports
%type<vMap> cfgs cfg zones zone aliass alias ezones ezone
%type<vString> an ap port

%%

zoneshow    : defx  effx            { $$=$1 }
            | DEFINED NODEFINED EFFECTIVE NOEFFECTIVE { if(!SHOWTOKEN) {fmt.Printf(" !! not defined and effect\n")}; $$ = 99 }
            ;

defx        : DEFINED cfgs zones aliass { print_s_h("all config", $<vMap>2); print_s_h("all zone", $<vMap>3); print_s_h("all alias", $<vMap>4); $$ = 0 }
            ;

effx        : EFFECTIVE CFG NAME ezones { print_s_h($<vString>3, $<vMap>4); $$ = 0 }
            ;

cfgs        : cfgs cfg              { $$ = hash_merge($<vMap>1, $<vMap>2) }
            | /* none */            { $$ = make(map[string][]string) }
            ;

cfg         : CFG NAME zns          { $$ = make(map[string][]string); $$[$<vString>2] = $<vSlice>3 }
            ;

zns         : zns ';' NAME          { $$ = append($1, $<vString>3) }
            | NAME                  { $$ = make([]string, 0); $$ = append($$,$<vString>1) }
            ;


zones       : zones zone            { $$ = hash_merge($<vMap>1, $<vMap>2) }
            | /* none */            { $$ = make(map[string][]string) }
            ;

zone        : ZONE NAME ans         { $$ = make(map[string][]string); $$[$<vString>2] = $<vSlice>3 }
            ;

ans         : ans ';' an            { $$ = append($1, $<vString>3) }
            | an                    { $$ = make([]string, 0); $$ = append($$,$<vString>1) }
            | /* none */            { $$ = make([]string, 0) }
            ;

an          : NAME
            | PORT
            | WWPN
            ;

aliass      : aliass alias          { $$ = hash_merge($<vMap>1, $<vMap>2) }
            | /* none */            { $$ = make(map[string][]string) }
            ;

alias       : ALIAS NAME aps        { $$ = make(map[string][]string); $$[$<vString>2] = $<vSlice>3 }
            ;

aps         : aps ';' ap            { $$ = append($1, $<vString>3) }
            | ap                    { $$ = make([]string, 0); $$ = append($$, $<vString>1) }
            | /* none */            { $$ = make([]string, 0) }
            ;

ap          : PORT
            | WWPN
            ;

ezones      : ezones ezone          { $$ = hash_merge($<vMap>1, $<vMap>2) }
            | /* none */            { $$ = make(map[string][]string) }
            ;

ezone       : ZONE NAME ports       { $$ = make(map[string][]string); $$[$<vString>2] = $<vSlice>3 }
            ;

ports       : ports port            { $$ = append($1, $<vString>2) }
            | /* none */            { $$ = make([]string, 0) }
            ;

port        : PORT
            | WWPN
            ;


%%


func print_s_h(name string, head map[string][]string){
	if(SHOWTOKEN) { return }
	fmt.Printf("{\"%s\"=> {\n", name);
	for k, v := range head {
		fmt.Printf("  \"%s\" => [",  k)
		for _, v := range v {
			fmt.Printf("\"%s\", ", v)
		}
		fmt.Printf("],\n");
	}
	fmt.Printf("}} ,\n");
}

func hash_merge(dst, src map[string][]string)  map[string][]string {
	for k,v := range src {
		dst[k] = v
	}
	return dst
}

