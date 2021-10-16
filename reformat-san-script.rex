class SCC
rule
  \s+               {  } #nothing
  \#.+              {  } #nothing
  ^--.+             {  } #nothing

  ","|dominID|alicreate|zonecreate|cfgcreate|cfgadd|cfgsave|cfgenable|aliadd|aliremove|zoneadd|zoneremove|cfgremove {
                   [text, text] }

  \d+,\d+           { [:PORT, text] }
  \w{2}(:\w{2}){7}  { [:WWPN, text] }

  \d+               { [:NUMBER, text] }
  \w(\w|-)*         { [:NAME, text] }

  .|\n              { [text, text] }


end
