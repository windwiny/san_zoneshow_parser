%option yylineno noyywrap

%{
int SHOWTOKEN=0;
#include "z.tab.h"
%}

BLANKS        [\ \t\r\n]+

defined       Defined\ configuration:
effective     Effective\ configuration:
cfg           cfg:
zone          zone:
alia          alias:

nodefined     no\ configuration\ defined
noeffective   no\ configuration\ in\ effect

dig           [0-9]
wh            [a-zA-Z_0-9]
wh2           [a-zA-Z_0-9-]

%%

{BLANKS}                { }
{defined}               { yylval.pc=strdup(yytext); if(SHOWTOKEN) printf("[:%s, \"%s\"]\n", "DEFINED",     yytext); return DEFINED; }
{effective}             { yylval.pc=strdup(yytext); if(SHOWTOKEN) printf("[:%s, \"%s\"]\n", "EFFECTIVE",   yytext); return EFFECTIVE; }
{nodefined}             { yylval.pc=strdup(yytext); if(SHOWTOKEN) printf("[:%s, \"%s\"]\n", "NODEFINED",   yytext); return NODEFINED; }
{noeffective}           { yylval.pc=strdup(yytext); if(SHOWTOKEN) printf("[:%s, \"%s\"]\n", "NOEFFECTIVE", yytext); return NOEFFECTIVE; }
{cfg}                   { yylval.pc=strdup(yytext); if(SHOWTOKEN) printf("[:%s, \"%s\"]\n", "CFG",         yytext); return CFG; }
{zone}                  { yylval.pc=strdup(yytext); if(SHOWTOKEN) printf("[:%s, \"%s\"]\n", "ZONE",        yytext); return ZONE; }
{alia}                  { yylval.pc=strdup(yytext); if(SHOWTOKEN) printf("[:%s, \"%s\"]\n", "ALIAS",       yytext); return ALIAS; }


{dig}+,{dig}+           { yylval.pc=strdup(yytext); if(SHOWTOKEN) printf("[:%s, \"%s\"]\n", "PORT",        yytext); return PORT; }
{wh}{2}(:{wh}{2}){7}    { yylval.pc=strdup(yytext); if(SHOWTOKEN) printf("[:%s, \"%s\"]\n", "WWPN",        yytext); return WWPN; }

{wh}{wh2}*              { yylval.pc=strdup(yytext); if(SHOWTOKEN) printf("[:%s, \"%s\"]\n", "NAME",        yytext); return NAME; }
.|\n                    { yylval.c=yytext[0];       if(SHOWTOKEN) printf("[\"%c\", \"%s\"]\n", yylval.c,   yytext); return yylval.c; }

%%
