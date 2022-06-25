grammar Zoneshow;

zoneshow    : defx  effx                                # zoneshow1
            | DEFINED NODEFINED EFFECTIVE NOEFFECTIVE   # zoneshow2
            ;

defx        : DEFINED cfgs zones aliass
            ;

effx        : EFFECTIVE CFG NAME ezones
            ;

cfgs        : cfgs cfg                  # cfgs1
            | /* none */                # cfgs2
            ;

cfg         : CFG NAME zns
            ;

zns         : zns ';' NAME              # zns1
            | NAME                      # zns2
            ;


zones       : zones zone                # zones1
            | /* none */                # zones2
            ;

zone        : ZONE NAME ans
            ;

ans         : ans ';' an                # ans1
            | an                        # ans2
            | /* none */                # ans3
            ;

an          : NAME
            | PORT
            | WWPN
            ;

aliass      : aliass alias              # aliass1
            | /* none */                # aliass2
            ;

alias       : ALIAS NAME aps
            ;

aps         : aps ';' ap                # aps1
            | ap                        # aps2
            | /* none */                # aps3
            ;

ap          : PORT
            | WWPN
            ;

ezones      : ezones ezone              # ezones1
            | /* none */                # ezones2
            ;

ezone       : ZONE NAME ports
            ;

ports       : ports port                # port1
            | /* none */                # port2
            ;

port        : PORT
            | WWPN
            ;




BLANKS      :  [ \t\r\n]+  -> skip ;

DEFINED     :  'Defined configuration:' ;
EFFECTIVE   :  'Effective configuration:' ;
CFG         :  'cfg:' ;
ZONE        :  'zone:' ;
ALIAS       :  'alias:' ;

NODEFINED   :  'no configuration defined' ;
NOEFFECTIVE :  'no configuration in effect' ;

fragment Dig : [0-9] ;
fragment Wh  : [a-zA-Z_0-9] ;
fragment Wh2 : [a-zA-Z_0-9-] ;



PORT        : Dig+ ',' Dig+ ;
WWPN        : Wh Wh ':' Wh Wh ':' Wh Wh ':' Wh Wh ':' Wh Wh ':' Wh Wh ':' Wh Wh ':' Wh Wh ;

//NAME        : Wh+ ;
NAME        : Wh Wh2* ;

NO_USED     :  .|'\n' ;


