import { CharStream, CommonTokenStream } from 'antlr4';
import ZoneshowLexer from './ts_vis/ZoneshowLexer';
import ZoneshowParser, { Zoneshow1Context, Zoneshow2Context, DefxContext, EffxContext, Cfgs2Context, Cfgs1Context, CfgContext, Zns2Context, Zns1Context, Zones1Context, Zones2Context, ZoneContext, Ans3Context, Ans2Context, Ans1Context, AnContext, Aliass2Context, Aliass1Context, AliasContext, Aps1Context, Aps3Context, Aps2Context, ApContext, Ezones2Context, Ezones1Context, EzoneContext, Port1Context, Port2Context, PortContext } from './ts_vis/ZoneshowParser';
import ZoneshowVisitor from './ts_vis/ZoneshowVisitor'

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

class ValueUnion extends Object {
    ii: number = 0
    s1: string = ''
    sa1: As = []
    map1: MsAs = new Map()

    override toString(): string {
        return "  >>> " + (this.s1 == null) + (this.sa1 == null) + (this.map1 == null) + " .";
    }
}

class TsMyVisitorImpl extends ZoneshowVisitor<ValueUnion> {
    result: MsMsAs = new Map()

    recvzsfn?: FMsMsAs
    constructor(recvzsfn?: FMsMsAs) {
        super()
        if (recvzsfn)
            this.recvzsfn = recvzsfn
    }

    override visitZoneshow1 = (ctx: Zoneshow1Context) => {
        let r = new ValueUnion();
        r.ii = this.visit(ctx.defx()).ii;
        this.visit(ctx.effx()); // must do
        if (this.recvzsfn) {
            this.recvzsfn(this.result)
            this.result = new Map()
        }
        return r;
    };
    override visitZoneshow2 = (ctx: Zoneshow2Context) => {
        console.error(" !! not defined and effect");
        let r = new ValueUnion();
        let v: MsAs = new Map()
        print_s_h(ALL_CONFIG, v)
        print_s_h(ALL_ZONE, v)
        print_s_h(ALL_ALIAS, v)
        print_s_h("", v)

        r.ii = 99;
        if (this.recvzsfn) {
            this.result.set(ALL_CONFIG, v)
            this.result.set(ALL_ZONE, v)
            this.result.set(ALL_ALIAS, v)
            this.result.set("", v)
            this.recvzsfn(this.result)
        }
        return r;
    };
    override visitDefx = (ctx: DefxContext) => {
        let r = new ValueUnion();
        let v: MsAs

        v = this.visit(ctx.cfgs()).map1
        print_s_h(ALL_CONFIG, v);
        this.result.set(ALL_CONFIG, v)

        v = this.visit(ctx.zones()).map1
        print_s_h(ALL_ZONE, v);
        this.result.set(ALL_ZONE, v)

        v = this.visit(ctx.aliass()).map1
        print_s_h(ALL_ALIAS, v);
        this.result.set(ALL_ALIAS, v)

        r.ii = 0;
        return r;
    };
    override visitEffx = (ctx: EffxContext) => {
        let name: string = ctx.NAME().getText()
        let v: MsAs = this.visit(ctx.ezones()).map1
        print_s_h(name, v);
        this.result.set(name, v)
        let r = new ValueUnion();
        r.ii = 0;
        return r;
    };
    override visitCfgs2 = (ctx: Cfgs2Context) => {
        let r = new ValueUnion();
        r.map1 = new Map();
        return r;
    };
    override visitCfgs1 = (ctx: Cfgs1Context) => {
        let r = this.visit(ctx.cfgs());
        let r2 = this.visit(ctx.cfg());
        r.map1.mergeAll!(r2.map1)
        return r;

    };
    override visitCfg = (ctx: CfgContext) => {
        let r = new ValueUnion();
        r.map1 = new Map();
        r.map1.set(ctx.NAME().getText(), this.visit(ctx.zns()).sa1);
        return r;

    };
    override visitZns2 = (ctx: Zns2Context) => {
        let r = new ValueUnion();
        r.sa1 = []
        r.sa1.push(ctx.NAME().getText());
        return r;

    };
    override visitZns1 = (ctx: Zns1Context) => {
        let r = this.visit(ctx.zns());
        r.sa1.push(ctx.NAME().getText());
        return r;

    };
    override visitZones1 = (ctx: Zones1Context) => {
        let r = this.visit(ctx.zones());
        let r2 = this.visit(ctx.zone());
        r.map1.mergeAll!(r2.map1)
        return r;
    };
    override visitZones2 = (ctx: Zones2Context) => {
        let r = new ValueUnion();
        r.map1 = new Map();
        return r;
    };
    override visitZone = (ctx: ZoneContext) => {
        let r = new ValueUnion();
        r.map1 = new Map();
        r.map1.set(ctx.NAME().getText(), this.visit(ctx.ans()).sa1);
        return r;
    };
    override visitAns3 = (ctx: Ans3Context) => {
        let r = new ValueUnion();
        r.sa1 = []
        return r;
    };
    override visitAns2 = (ctx: Ans2Context) => {
        let r = new ValueUnion();
        r.sa1 = []
        r.sa1.push(this.visit(ctx.an()).s1);
        return r;
    };
    override visitAns1 = (ctx: Ans1Context) => {
        let r = this.visit(ctx.ans());
        let s = this.visit(ctx.an()).s1;
        r.sa1.push(s);
        return r;
    };
    override visitAn = (ctx: AnContext) => {
        let res = new ValueUnion();
        let a = ctx.NAME();
        let b = ctx.PORT();
        if (a != null)
            res.s1 = a.getText();
        else if (b != null)
            res.s1 = b.getText();
        else
            res.s1 = ctx.WWPN().getText();
        return res;
    };
    override visitAliass2 = (ctx: Aliass2Context) => {
        let r = new ValueUnion();
        r.map1 = new Map();
        return r;
    };
    override visitAliass1 = (ctx: Aliass1Context) => {
        let r = this.visit(ctx.aliass());
        let r2 = this.visit(ctx.alias());
        r.map1.mergeAll!(r2.map1)
        return r;

    };
    override visitAlias = (ctx: AliasContext) => {
        let r = new ValueUnion();
        r.map1 = new Map();
        r.map1.set(ctx.NAME().getText(), this.visit(ctx.aps()).sa1);
        return r;
    };
    override visitAps1 = (ctx: Aps1Context) => {
        let r = this.visit(ctx.aps());
        r.sa1.push(ctx.ap().getText());
        return r;
    };
    override visitAps3 = (ctx: Aps3Context) => {
        let r = new ValueUnion();
        r.sa1 = []
        return r;
    };
    override visitAps2 = (ctx: Aps2Context) => {
        let r = new ValueUnion();
        r.sa1 = []
        r.sa1.push(ctx.ap().getText());
        return r;
    };
    override visitAp = (ctx: ApContext) => {
        let res = new ValueUnion();
        let a = ctx.PORT();
        if (a != null)
            res.s1 = a.getText();
        else
            res.s1 = ctx.WWPN().getText();
        return res;
    };
    override visitEzones2 = (ctx: Ezones2Context) => {
        let r = new ValueUnion();
        r.map1 = new Map();
        return r;
    };
    override visitEzones1 = (ctx: Ezones1Context) => {
        let r = this.visit(ctx.ezones());
        let r2 = this.visit(ctx.ezone());
        r.map1.mergeAll!(r2.map1)
        return r;
    };
    override visitEzone = (ctx: EzoneContext) => {
        let r = new ValueUnion();
        r.map1 = new Map();
        r.map1.set(ctx.NAME().getText(), this.visit(ctx.ports()).sa1);
        return r;
    };
    override visitPort1 = (ctx: Port1Context) => {
        let a = this.visit(ctx.ports());
        let b = ctx.port();
        a.sa1.push(b.getText());
        return a;
    };
    override visitPort2 = (ctx: Port2Context) => {
        let r = new ValueUnion();
        r.sa1 = []
        return r;
    };
    override visitPort = (ctx: PortContext) => {
        let pt = ctx.PORT();
        let wn = ctx.WWPN();

        let res = new ValueUnion();
        if (pt != null)
            res.s1 = pt.getText();
        else
            res.s1 = wn.getText();
        return res;
    };
}

function vis_parser(input: string, recvzsfn?: FMsMsAs) {
    const chars = new CharStream(input);
    const lexer = new ZoneshowLexer(chars);
    const tokens = new CommonTokenStream(lexer);
    const parser = new ZoneshowParser(tokens);
    const tree = parser.zoneshow();

    const custvis = new TsMyVisitorImpl(recvzsfn);
    custvis.visit(tree)
    // tree.accept(custvis);
}

export {
    ALL_CONFIG, ALL_ZONE, ALL_ALIAS,
    As, MsAs, AMsAs, MsMsAs, FMsMsAs,
    TsMyVisitorImpl, vis_parser, getstr_s_h, print_s_h
}
