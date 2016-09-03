class SANZoneRaccParser
macro
  BLANKS        \s+

  defined       Defined\ configuration:
  effective     Effective\ configuration:
  cfg           cfg:
  zone          zone:
  alia          alias:

  nodefined     no\ configuration\ defined
  noeffective   no\ configuration\ in\ effect

rule

  {BLANKS}          #nothing
  {defined}         { [:DEFINED, text] }
  {effective}       { [:EFFECTIVE, text] }
  {nodefined}       { [:NODEFINED, text] }
  {noeffective}     { [:NOEFFECTIVE, text] }
  {cfg}             { [:CFG, text] }
  {zone}            { [:ZONE, text] }
  {alia}            { [:ALIAS, text] }


  \d+,\d+           { [:PORT, text] }
  \w{2}(:\w{2}){7}  { [:WWPN, text] }

  \w+               { [:NAME, text] }
  .|\n              { [text, text] }

inner

end

