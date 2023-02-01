import { CharStream, CommonTokenStream, ParseTreeWalker } from 'antlr4';
import ZoneshowLexer from './ts_lis/ZoneshowLexer';
import ZoneshowParser, { AliasContext, Aliass1Context, Aliass2Context, AnContext, Ans1Context, Ans2Context, Ans3Context, ApContext, Aps1Context, Aps2Context, Aps3Context, CfgContext, Cfgs1Context, Cfgs2Context, DefxContext, EffxContext, EzoneContext, Ezones1Context, Ezones2Context, Port1Context, Port2Context, PortContext, Zns1Context, Zns2Context, ZoneContext, Zones1Context, Zones2Context, Zoneshow1Context, Zoneshow2Context } from './ts_lis/ZoneshowParser';
import ZoneshowListener from './ts_lis/ZoneshowListener';

const ALL_CONFIG = "all config"
const ALL_ZONE = "all zone"
const ALL_ALIAS = "all alias"
type As = Array<string>
type MsAs = Map<string, As>
type AMsAs = Array<MsAs>
type MsMsAs = Map<string, MsAs>
type FMsMsAs = (zs: MsMsAs) => any

declare global {
    interface Map<K, V> {
        mergeAll?(other: MsAs): void
    }
}

Map.prototype.mergeAll = function (other: MsAs) {
    other.forEach((value: As, key: string) => {
        this.set(key, value)
    })
}

function getstr_s_h(name: string, head: MsAs): string {
    const ass: Array<string> = []
    ass.push(`{"${name}"=> {\n`)
    head.forEach((v: As, ks: string) => {
        ass.push(`  "${ks}" => [`)
        v.forEach((v2: string) => {
            ass.push(`"${v2}", `)
        })
        ass.push("],\n")
    })
    ass.push("}} ,\n")
    const sss = ass.join("")
    return sss
}

function print_s_h(name: string, head: MsAs): void {
    console.log(getstr_s_h(name, head))
}

class TsMyListenerImpl extends ZoneshowListener {
    ports: As = []
    aps: As = []
    ans: As = []
    zns: As = []

    ezone: MsAs = new Map()
    ezones: MsAs = new Map()
    alias: MsAs = new Map()
    aliass: MsAs = new Map()
    zone: MsAs = new Map()
    zones: MsAs = new Map()
    cfg: MsAs = new Map()
    cfgs: MsAs = new Map()

    ap: string = ''
    defx: AMsAs = []
    effx: MsMsAs = new Map()

    recvzsfn?: FMsMsAs
    constructor(recvzsfn?: FMsMsAs) {
        super()
        if (recvzsfn)
            this.recvzsfn = recvzsfn
    }

    override exitZoneshow1 = (ctx: Zoneshow1Context) => {
        let v: MsAs
        let result: MsMsAs = new Map()
        v = this.defx[0]
        print_s_h(ALL_CONFIG, v)
        result.set(ALL_CONFIG, v)

        v = this.defx[1]
        print_s_h(ALL_ZONE, v)
        result.set(ALL_ZONE, v)

        v = this.defx[2]
        print_s_h(ALL_ALIAS, v)
        result.set(ALL_ALIAS, v)

        this.effx.forEach((value: MsAs, key: string) => {
            print_s_h(key, value)
            result.set(key, value)
        })
        if (this.recvzsfn) {
            this.recvzsfn(result)
        }
        result = new Map()
    };
    override exitZoneshow2 = (ctx: Zoneshow2Context) => {
        console.error(" !! not defined and effect")
        let v: MsAs = new Map()
        print_s_h(ALL_CONFIG, v)
        print_s_h(ALL_ZONE, v)
        print_s_h(ALL_ALIAS, v)
        print_s_h("", v)

        if (this.recvzsfn) {
            let result: MsMsAs = new Map()
            result.set(ALL_CONFIG, v)
            result.set(ALL_ZONE, v)
            result.set(ALL_ALIAS, v)
            result.set("", v)
            this.recvzsfn(result)
        }
    };
    override exitDefx = (ctx: DefxContext) => {
        this.defx = [this.cfgs, this.zones, this.aliass]
    };
    override exitEffx = (ctx: EffxContext) => {
        this.effx = new Map()
        this.effx.set(ctx.NAME().getText(), this.ezones)
    };
    override exitCfgs2 = (ctx: Cfgs2Context) => {
        this.cfgs = new Map()
    };
    override exitCfgs1 = (ctx: Cfgs1Context) => {
        this.cfgs.mergeAll!(this.cfg)
    };
    override exitCfg = (ctx: CfgContext) => {
        this.cfg = new Map()
        this.cfg.set(ctx.NAME().getText(), this.zns)
    };
    override exitZns2 = (ctx: Zns2Context) => {
        this.zns = [ctx.NAME().getText()]
    };
    override exitZns1 = (ctx: Zns1Context) => {
        this.zns.push(ctx.NAME().getText())
    };
    override exitZones1 = (ctx: Zones1Context) => {
        this.zones.mergeAll!(this.zone)
    };
    override exitZones2 = (ctx: Zones2Context) => {
        this.zones = new Map()
    };
    override exitZone = (ctx: ZoneContext) => {
        this.zone = new Map()
        this.zone.set(ctx.NAME().getText(), this.ans)
    };
    override exitAns3 = (ctx: Ans3Context) => {
        // empty
    };
    override exitAns2 = (ctx: Ans2Context) => {
        let v = ctx.an().NAME() || ctx.an().PORT() || ctx.an().WWPN()
        this.ans = [v.getText()]
    };
    override exitAns1 = (ctx: Ans1Context) => {
        let v = ctx.an().NAME() || ctx.an().PORT() || ctx.an().WWPN()
        this.ans.push(v.getText())
    };
    override exitAn = (ctx: AnContext) => {
        // empty
    };
    override exitAliass2 = (ctx: Aliass2Context) => {
        this.aliass = new Map()
    };
    override exitAliass1 = (ctx: Aliass1Context) => {
        this.aliass.mergeAll!(this.alias)
    };
    override exitAlias = (ctx: AliasContext) => {
        this.alias = new Map()
        this.alias.set(ctx.NAME().getText(), this.aps)
    };
    override exitAps1 = (ctx: Aps1Context) => {
        this.aps.push(this.ap)
    };
    override exitAps3 = (ctx: Aps3Context) => {
        // empty
    };
    override exitAps2 = (ctx: Aps2Context) => {
        let v = ctx.ap().PORT() || ctx.ap().WWPN()
        this.aps = [v.getText()]
    };
    override exitAp = (ctx: ApContext) => {
        let v = ctx.PORT() || ctx.WWPN()
        this.ap = v.getText()
    };
    override exitEzones2 = (ctx: Ezones2Context) => {
        this.ezones = new Map()
    };
    override exitEzones1 = (ctx: Ezones1Context) => {
        this.ezones.mergeAll!(this.ezone)
    };
    override exitEzone = (ctx: EzoneContext) => {
        this.ezone = new Map()
        this.ezone.set(ctx.NAME().getText(), this.ports)
    };
    override exitPort1 = (ctx: Port1Context) => {
        let v = ctx.port().PORT() || ctx.port().WWPN()
        this.ports.push(v.getText())
    };
    override exitPort2 = (ctx: Port2Context) => {
        this.ports = []
    };
    override exitPort = (ctx: PortContext) => {
        // empty
    };
}


function lis_parser(input: string, recvzsfn?: FMsMsAs) {
    const chars = new CharStream(input);
    const lexer = new ZoneshowLexer(chars);
    const tokens = new CommonTokenStream(lexer);
    const parser = new ZoneshowParser(tokens);
    const tree = parser.zoneshow();

    const custlis = new TsMyListenerImpl(recvzsfn);
    ParseTreeWalker.DEFAULT.walk(custlis, tree);
}

export {
    ALL_CONFIG, ALL_ZONE, ALL_ALIAS,
    As, MsAs, AMsAs, MsMsAs, FMsMsAs,
    TsMyListenerImpl, lis_parser, getstr_s_h, print_s_h
}
