import io
import pprint
import sys

from ZoneshowParser import ZoneshowParser
from ZoneshowListener import ZoneshowListener

def print_result(result):
    defx, effx = result
    cfgs, zones, aliass = defx

    a = { "all config" : cfgs }
    b = { "all zone" : zones }
    c = { "all alias" :  aliass }

    for res in [ a, b, c, effx ] :
        sss = io.StringIO()
        pp = pprint.PrettyPrinter(stream=sss)
        pp.pprint(res)

        sss = sss.getvalue()
        # python dict string to ruby Hash string
        sss = sss.replace("': {", "' => {").replace("': [", "' => [").replace("': '", "' => '")
        print(sss.rstrip(), ",")
    pass


def print_s_h(name, head):
    print('{"%s"=> {\n' % name, end='')
    for k in head:
        v = head[k]
        print('  "%s" => [' % k, end='')
        for v2 in v:
            print('"%s", ' % v2, end='')
        print('],\n', end='')
    print('}} ,\n', end='')

def print_result2(result):
    defx, effx = result
    cfgs, zones, aliass = defx

    a = { "all config" : cfgs }
    b = { "all zone" : zones }
    c = { "all alias" :  aliass }

    for res in [ a, b, c, effx ] :
        for k in res:
            print_s_h(k, res[k])
    pass


class MyListenerImpl(ZoneshowListener):

    def enterZoneshow1(self, ctx:ZoneshowParser.Zoneshow1Context):
        pass

    def exitZoneshow1(self, ctx:ZoneshowParser.Zoneshow1Context):
        self.result = [ [ self.defx[0], self.defx[1], self.defx[2] ], self.effx ]
        print_result2(self.result)
        pass


    def enterZoneshow2(self, ctx:ZoneshowParser.Zoneshow2Context):
        pass

    def exitZoneshow2(self, ctx:ZoneshowParser.Zoneshow2Context):
        print(" !! not defined and effect\n", file=sys.stderr)
        self.result = [ [ {}, {}, {} ], {} ]
        print_result2(self.result)
        return 99


    def enterDefx(self, ctx:ZoneshowParser.DefxContext):
        pass

    def exitDefx(self, ctx:ZoneshowParser.DefxContext):
        self.defx = [ self.cfgs, self.zones, self.aliass ]
        pass


    def enterEffx(self, ctx:ZoneshowParser.EffxContext):
        pass

    def exitEffx(self, ctx:ZoneshowParser.EffxContext):
        self.effx = { ctx.NAME().getText() : self.ezones }
        pass


    def enterCfgs2(self, ctx:ZoneshowParser.Cfgs2Context):
        pass

    def exitCfgs2(self, ctx:ZoneshowParser.Cfgs2Context):
        self.cfgs = {}
        pass


    def enterCfgs1(self, ctx:ZoneshowParser.Cfgs1Context):
        pass

    def exitCfgs1(self, ctx:ZoneshowParser.Cfgs1Context):
        self.cfgs.update(self.cfg)
        pass


    def enterCfg(self, ctx:ZoneshowParser.CfgContext):
        pass

    def exitCfg(self, ctx:ZoneshowParser.CfgContext):
        self.cfg = { ctx.NAME().getText() : self.zns }
        pass


    def enterZns2(self, ctx:ZoneshowParser.Zns2Context):
        pass

    def exitZns2(self, ctx:ZoneshowParser.Zns2Context):
        self.zns = [ ctx.NAME().getText() ]
        pass


    def enterZns1(self, ctx:ZoneshowParser.Zns1Context):
        pass

    def exitZns1(self, ctx:ZoneshowParser.Zns1Context):
        self.zns.append(ctx.NAME().getText())
        pass


    def enterZones1(self, ctx:ZoneshowParser.Zones1Context):
        pass

    def exitZones1(self, ctx:ZoneshowParser.Zones1Context):
        self.zones.update(self.zone)
        pass


    def enterZones2(self, ctx:ZoneshowParser.Zones2Context):
        pass

    def exitZones2(self, ctx:ZoneshowParser.Zones2Context):
        self.zones = {}
        pass


    def enterZone(self, ctx:ZoneshowParser.ZoneContext):
        pass

    def exitZone(self, ctx:ZoneshowParser.ZoneContext):
        self.zone = { ctx.NAME().getText() : self.ans }
        pass


    def enterAns3(self, ctx:ZoneshowParser.Ans3Context):
        pass

    def exitAns3(self, ctx:ZoneshowParser.Ans3Context):
        self.ans = []
        pass


    def enterAns2(self, ctx:ZoneshowParser.Ans2Context):
        pass

    def exitAns2(self, ctx:ZoneshowParser.Ans2Context):
        v = ctx.an().NAME()
        if not v: v = ctx.an().PORT()
        if not v: v = ctx.an().WWPN()
        self.ans = [ v.getText() ]
        pass


    def enterAns1(self, ctx:ZoneshowParser.Ans1Context):
        pass

    def exitAns1(self, ctx:ZoneshowParser.Ans1Context):
        v = ctx.an().NAME()
        if not v: v = ctx.an().PORT()
        if not v: v = ctx.an().WWPN()
        self.ans.append(v.getText())
        pass


    def enterAn(self, ctx:ZoneshowParser.AnContext):
        pass

    def exitAn(self, ctx:ZoneshowParser.AnContext):
        pass


    def enterAliass2(self, ctx:ZoneshowParser.Aliass2Context):
        pass

    def exitAliass2(self, ctx:ZoneshowParser.Aliass2Context):
        self.aliass = {}
        pass


    def enterAliass1(self, ctx:ZoneshowParser.Aliass1Context):
        pass

    def exitAliass1(self, ctx:ZoneshowParser.Aliass1Context):
        self.aliass.update(self.alias)
        pass


    def enterAlias(self, ctx:ZoneshowParser.AliasContext):
        pass

    def exitAlias(self, ctx:ZoneshowParser.AliasContext):
        self.alias = { ctx.NAME().getText(): self.aps }
        pass


    def enterAps1(self, ctx:ZoneshowParser.Aps1Context):
        pass

    def exitAps1(self, ctx:ZoneshowParser.Aps1Context):
        self.aps.append(self.ap)
        pass


    def enterAps3(self, ctx:ZoneshowParser.Aps3Context):
        pass

    def exitAps3(self, ctx:ZoneshowParser.Aps3Context):
        self.aps = []
        pass


    def enterAps2(self, ctx:ZoneshowParser.Aps2Context):
        pass

    def exitAps2(self, ctx:ZoneshowParser.Aps2Context):
        v = ctx.ap().PORT()
        if not v: v = ctx.ap().WWPN()
        self.aps = [ v.getText() ]
        pass


    def enterAp(self, ctx:ZoneshowParser.ApContext):
        pass

    def exitAp(self, ctx:ZoneshowParser.ApContext):
        v = ctx.PORT()
        if not v: v = ctx.WWPN()
        self.ap = v.getText()
        pass


    def enterEzones2(self, ctx:ZoneshowParser.Ezones2Context):
        pass

    def exitEzones2(self, ctx:ZoneshowParser.Ezones2Context):
        self.ezones = {}
        pass


    def enterEzones1(self, ctx:ZoneshowParser.Ezones1Context):
        pass

    def exitEzones1(self, ctx:ZoneshowParser.Ezones1Context):
        self.ezones.update(self.ezone)
        pass


    def enterEzone(self, ctx:ZoneshowParser.EzoneContext):
        pass

    def exitEzone(self, ctx:ZoneshowParser.EzoneContext):
        self.ezone = { ctx.NAME().getText() : self.ports }
        pass


    def enterPort1(self, ctx:ZoneshowParser.Port1Context):
        pass

    def exitPort1(self, ctx:ZoneshowParser.Port1Context):
        v = ctx.port().PORT()
        if not v: v = ctx.port().WWPN()
        self.ports.append(v.getText())
        pass


    def enterPort2(self, ctx:ZoneshowParser.Port2Context):
        pass

    def exitPort2(self, ctx:ZoneshowParser.Port2Context):
        self.ports = []
        pass


    def enterPort(self, ctx:ZoneshowParser.PortContext):
        pass

    def exitPort(self, ctx:ZoneshowParser.PortContext):
        pass



del ZoneshowParser
