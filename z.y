
%{
#include <stdio.h>
#include <stdlib.h>
#include "z.lex.c"
void yyerror(const char *e);
%}


%{
	struct list {
		char *pval;
		struct list *next;
	};
	struct list* list_append(struct list* head, char *pval) {
		struct list *node = (struct list *)malloc(sizeof(struct list));
		node->pval = pval;
		node->next = NULL;
		if(head==NULL) {
			return node;
		}
		struct list *c = head;
		while (c->next!=NULL) { c=c->next; }
		c->next = node;
		return head;
	}
	struct list *initlist(char *pval) {
		struct list *node = (struct list *)malloc(sizeof(struct list));
		node->pval = pval;
		node->next = NULL;
		return node;
	}
	
	struct hash {
		char *k;
		struct list *v;
		struct hash * next;
	};
	struct hash* hash_merge(struct hash *head, struct hash *hx) {
		if(head==NULL) {
			return hx;
		}
		struct hash *c = head;
		while (c->next!=NULL) { c=c->next; }
		c->next = hx;
		return head;
	}
	struct hash *inithash(char *k, struct list *v) {
		struct hash *node = (struct hash *)malloc(sizeof(struct hash));
		node->k = k;
		node->v = v;
		node->next = NULL;
		return node;
	}
	void print_s_h(char *name, struct hash *head) {
		if(SHOWTOKEN) return;
		printf("{\"%s\"=> {\n", name);
		struct hash *curr = head;
		while(curr!=NULL) {
			printf("  \"%s\" => [", curr->k);
			struct list *lh = curr->v;
			while(lh!=NULL) {
				printf("\"%s\", ", lh->pval);
				lh=lh->next;
			}
			printf("],\n");
			curr = curr->next;
		}
		printf("}} ,\n");
	}
	void print_h(struct hash* head) {
		if(SHOWTOKEN) return;
		print_s_h(head->k, head);
	}
	
%}


%union {
    char c;
    int intv;
    struct list *pl;
    struct hash *ph;
    char *pc;
}

%token<pc> EFFECTIVE DEFINED NODEFINED NOEFFECTIVE CFG ZONE ALIAS
%token<pc> PORT WWPN NAME

%type<intv> zoneshow defx effx
%type<pl> zns ans aps ports
%type<ph> cfgs cfg zones zone aliass alias ezones ezone
%type<pc> an ap

%%

zoneshow    : defx  effx            { $$=0 }
            | DEFINED NODEFINED EFFECTIVE NOEFFECTIVE { if(!SHOWTOKEN) printf(" !! not defined and effect\n"); $$ = 99; }
            ;

defx        : DEFINED cfgs zones aliass { print_s_h("cfgS", $<ph>2); print_s_h("zoneS", $<ph>3); print_s_h("aliasS", $<ph>4); $$ = 0 }
            ;

effx        : EFFECTIVE CFG NAME ezones { print_s_h($<pc>3, $<ph>4); $$ = 0 }
            ;

cfgs        : cfgs cfg              { $$ = hash_merge($1, $<ph>2) }
            | /* none */            { $$ = NULL }
            ;

cfg         : CFG NAME zns          { $$ = inithash($<pc>2, $<pl>3) }
            ;

zns         : zns ';' NAME          { $$ = list_append($1, $<pc>3) }
            | NAME                  { $$ = initlist($<pc>1) }
            ;


zones       : zones zone            { $$ = hash_merge($1, $<ph>2) }
            | /* none */            { $$ = NULL }
            ;

zone        : ZONE NAME ans         { $$ = inithash($<pc>2, $<pl>3) }
            ;

ans         : ans ';' an            { $$ = list_append($1, $<pc>3) }
            | an                    { $$ = initlist($1) }
            | /* none */            { $$ = NULL }
            ;

an          : NAME
            | PORT
            | WWPN
            ;

aliass      : aliass alias          { $$ = hash_merge($1, $<ph>2) }
            | /* none */            { $$ = NULL }
            ;

alias       : ALIAS NAME aps        { $$ = inithash($2, $<pl>3) }
            ;

aps         : aps ';' ap            { $$ = list_append($1, $<pc>3) }
            | ap                    { $$ = initlist($1) }
            | /* none */            { $$ = NULL }
            ;

ap          : PORT
            | WWPN
            ;

ezones      : ezones ezone          { $$ = hash_merge($1, $<ph>2) }
            | /* none */            { $$ = NULL }
            ;

ezone       : ZONE NAME ports       { $$ = inithash($<pc>2, $<pl>3) }
            ;

ports       : ports port            { $$ = list_append($1, $<pc>2) }
            | /* none */            { $$ = NULL }
            ;

port        : PORT
            | WWPN
            ;


%%


void yyerror(const char *e) {
	printf("ERROR: lineno: %d  msg: %s\n", yylineno, e);
}
int main (int argc, char const *argv[])
{
	for(int i = 0; i < argc; ++i)
	{
		if(strcmp(argv[i],"-h")==0)
		{
			printf("Syntax:\n  -h help\n  -l show lexical\n");
			return 0;
		}else if(strcmp(argv[i],"-l")==0)
		{
			SHOWTOKEN = 1;
		}
	}
	yyparse();
	return 0;
}
