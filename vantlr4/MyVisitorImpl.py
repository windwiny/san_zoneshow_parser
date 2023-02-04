import sys
from antlr4 import *

from py3_vis.ZoneshowParser import ZoneshowParser
from py3_vis.ZoneshowVisitor import ZoneshowVisitor

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


class MyVisitorImpl(ZoneshowVisitor):

    def visitZoneshow1(self, ctx:ZoneshowParser.Zoneshow1Context):
        defx = self.visit(ctx.defx())
        effx = self.visit(ctx.effx())
        self.result = [ defx, effx ]
        print_result2(self.result)

        return 0

    def visitZoneshow2(self, ctx:ZoneshowParser.Zoneshow2Context):
        print(" !! not defined and effect\n", file=sys.stderr)
        self.result = [ [ {}, {}, {} ], {} ]
        print_result2(self.result)
        return 99

    def visitDefx(self, ctx:ZoneshowParser.DefxContext):
        a = self.visit(ctx.cfgs())
        b = self.visit(ctx.zones())
        c = self.visit(ctx.aliass())
        defx = [a, b, c]

        return defx

    def visitEffx(self, ctx:ZoneshowParser.EffxContext):
        effx = { ctx.NAME(): self.visit(ctx.ezones()) }
        return effx

    def visitCfgs1(self, ctx:ZoneshowParser.Cfgs1Context):
        r = self.visit(ctx.cfgs())
        r2 = self.visit(ctx.cfg())
        r.update(r2)
        return r

    def visitCfgs2(self, ctx:ZoneshowParser.Cfgs2Context):
        return {}

    def visitCfg(self, ctx:ZoneshowParser.CfgContext):
        r = {}
        r[ctx.NAME()] = self.visit(ctx.zns())
        return r

    def visitZns1(self, ctx:ZoneshowParser.Zns1Context):
        r = self.visit(ctx.zns())
        r.append(ctx.NAME())
        return r

    def visitZns2(self, ctx:ZoneshowParser.Zns2Context):
        a = []
        a.append(ctx.NAME())
        return a

    def visitZones1(self, ctx:ZoneshowParser.Zones1Context):
        a = self.visit(ctx.zones())
        b = self.visit(ctx.zone())
        a.update(b)
        return a

    def visitZones2(self, ctx:ZoneshowParser.Zones2Context):
        return {}

    def visitZone(self, ctx:ZoneshowParser.ZoneContext):
        a = {}
        a[ctx.NAME()] = self.visit(ctx.ans())
        return a

    def visitAns1(self, ctx:ZoneshowParser.Ans1Context):
        r = self.visit(ctx.ans())
        r.append(self.visit(ctx.an()))
        return r

    def visitAns2(self, ctx:ZoneshowParser.Ans2Context):
        a = []
        a.append(self.visit(ctx.an()))
        return a

    def visitAns3(self, ctx:ZoneshowParser.Ans3Context):
        return []

    def visitAn(self, ctx:ZoneshowParser.AnContext):
        a = ctx.NAME()
        if not a:
            a = ctx.PORT()
        if not a:
            a = ctx.WWPN()
        return a

    def visitAliass1(self, ctx:ZoneshowParser.Aliass1Context):
        r = self.visit(ctx.aliass())
        r2 = self.visit(ctx.alias())
        r.update(r2)
        return r

    def visitAliass2(self, ctx:ZoneshowParser.Aliass2Context):
        return {}

    def visitAlias(self, ctx:ZoneshowParser.AliasContext):
        a = {}
        a[ctx.NAME()] = self.visit(ctx.aps())
        return a

    def visitAps1(self, ctx:ZoneshowParser.Aps1Context):
        a = self.visit(ctx.aps())
        a.append(self.visit(ctx.ap()))
        return a

    def visitAps2(self, ctx:ZoneshowParser.Aps2Context):
        a = []
        a.append(self.visit(ctx.ap()))
        return a

    def visitAps3(self, ctx:ZoneshowParser.Aps3Context):
        return []

    def visitAp(self, ctx:ZoneshowParser.ApContext):
        a = ctx.PORT()
        if not a:
            a = ctx.WWPN()
        return a

    def visitEzones1(self, ctx:ZoneshowParser.Ezones1Context):
        r = self.visit(ctx.ezones())
        r2 = self.visit(ctx.ezone())
        r.update(r2)
        return r

    def visitEzones2(self, ctx:ZoneshowParser.Ezones2Context):
        return {}

    def visitEzone(self, ctx:ZoneshowParser.EzoneContext):
        a = {}
        a[ctx.NAME()] = self.visit(ctx.ports())
        return a

    def visitPort1(self, ctx:ZoneshowParser.Port1Context):
        a = self.visit(ctx.ports())
        a.append(self.visit(ctx.port()))
        return a

    def visitPort2(self, ctx:ZoneshowParser.Port2Context):
        return []

    def visitPort(self, ctx:ZoneshowParser.PortContext):
        a = ctx.PORT()
        if not a:
            a = ctx.WWPN()
        return a
