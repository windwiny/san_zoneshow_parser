import java.util.HashMap;
import java.util.List;
import java.util.LinkedList;

class ValueUnion {
    int ii;
    String s1;
    List<String> sa1;
    HashMap<String, List<String>> map1;

    @Override
    public String toString() {
        return "  >>> " + (s1 == null) + (sa1 == null) + (map1 == null) + " .";
    }

    public static void print_s_h(String name, HashMap<String, List<String>> head) {
        System.out.printf("{\"%s\"=> {\n", name);
        var ks = head.keySet();
        ks.forEach(k -> {
            var v = head.get(k);
            System.out.printf("  \"%s\" => [", k);
            v.forEach(v2 -> {
                System.out.printf("\"%s\", ", v2);
            });
            System.out.printf("],\n");
        });
        System.out.printf("}} ,\n");
    }
}

public class VisitorMyImpl extends ZoneshowBaseVisitor<ValueUnion> {
    @Override
    public ValueUnion visitZoneshow1(ZoneshowParser.Zoneshow1Context ctx) {
        var r = new ValueUnion();
        r.ii = visit(ctx.defx()).ii;
        visit(ctx.effx()); // must do
        return r;
    }

    @Override
    public ValueUnion visitZoneshow2(ZoneshowParser.Zoneshow2Context ctx) {
        System.out.println(" !! not defined and effect\n");
        var r = new ValueUnion();
        r.ii = 99;
        r.map1 = new HashMap<>();
        ValueUnion.print_s_h("all config", r.map1);
        ValueUnion.print_s_h("all zone", r.map1);
        ValueUnion.print_s_h("all alias", r.map1);
        ValueUnion.print_s_h("", r.map1);

        return r;
    }

    @Override
    public ValueUnion visitDefx(ZoneshowParser.DefxContext ctx) {
        ValueUnion.print_s_h("all config", visit(ctx.cfgs()).map1);
        ValueUnion.print_s_h("all zone", visit(ctx.zones()).map1);
        ValueUnion.print_s_h("all alias", visit(ctx.aliass()).map1);
        var r = new ValueUnion();
        r.ii = 0;
        return r;
    }

    @Override
    public ValueUnion visitEffx(ZoneshowParser.EffxContext ctx) {
        ValueUnion.print_s_h(ctx.NAME().getText(), visit(ctx.ezones()).map1);
        var r = new ValueUnion();
        r.ii = 0;
        return r;
    }

    @Override
    public ValueUnion visitCfgs1(ZoneshowParser.Cfgs1Context ctx) {
        var r = visit(ctx.cfgs());
        var r2 = visit(ctx.cfg());
        r2.map1.keySet().forEach(x -> {
            r.map1.put(x, r2.map1.get(x));
        });
        return r;
    }

    @Override
    public ValueUnion visitCfgs2(ZoneshowParser.Cfgs2Context ctx) {
        var r = new ValueUnion();
        r.map1 = new HashMap<>();
        return r;
    }

    @Override
    public ValueUnion visitCfg(ZoneshowParser.CfgContext ctx) {
        var r = new ValueUnion();
        r.map1 = new HashMap<>();
        r.map1.put(ctx.NAME().getText(), visit(ctx.zns()).sa1);
        return r;
    }

    @Override
    public ValueUnion visitZns1(ZoneshowParser.Zns1Context ctx) {
        var r = visit(ctx.zns());
        r.sa1.add(ctx.NAME().getText());
        return r;
    }

    @Override
    public ValueUnion visitZns2(ZoneshowParser.Zns2Context ctx) {
        var r = new ValueUnion();
        r.sa1 = new LinkedList<>();
        r.sa1.add(ctx.NAME().getText());
        return r;
    }

    @Override
    public ValueUnion visitZones1(ZoneshowParser.Zones1Context ctx) {
        var r = visit(ctx.zones());
        var r2 = visit(ctx.zone());
        r2.map1.keySet().forEach(x -> {
            r.map1.put(x, r2.map1.get(x));
        });
        return r;
    }

    @Override
    public ValueUnion visitZones2(ZoneshowParser.Zones2Context ctx) {
        var r = new ValueUnion();
        r.map1 = new HashMap<>();
        return r;
    }

    @Override
    public ValueUnion visitZone(ZoneshowParser.ZoneContext ctx) {
        var r = new ValueUnion();
        r.map1 = new HashMap<>();
        r.map1.put(ctx.NAME().getText(), visit(ctx.ans()).sa1);
        return r;
    }

    @Override
    public ValueUnion visitAns1(ZoneshowParser.Ans1Context ctx) {
        var r = visit(ctx.ans());

        String s = visit(ctx.an()).s1;
        r.sa1.add(s);
        return r;

    }

    @Override
    public ValueUnion visitAns2(ZoneshowParser.Ans2Context ctx) {
        var r = new ValueUnion();
        r.sa1 = new LinkedList<>();
        r.sa1.add(visit(ctx.an()).s1);
        return r;
    }

    @Override
    public ValueUnion visitAns3(ZoneshowParser.Ans3Context ctx) {
        var r = new ValueUnion();
        r.sa1 = new LinkedList<>();
        return r;
    }

    @Override
    public ValueUnion visitAn(ZoneshowParser.AnContext ctx) {
        var res = new ValueUnion();
        var a = ctx.NAME();
        var b = ctx.PORT();
        if (a != null)
            res.s1 = a.getText();
        else if (b != null)
            res.s1 = b.getText();
        else
            res.s1 = ctx.WWPN().getText();
        return res;
    }

    @Override
    public ValueUnion visitAliass1(ZoneshowParser.Aliass1Context ctx) {
        var r = visit(ctx.aliass());
        var r2 = visit(ctx.alias());
        r2.map1.keySet().forEach(x -> {
            r.map1.put(x, r2.map1.get(x));
        });
        return r;
    }

    @Override
    public ValueUnion visitAliass2(ZoneshowParser.Aliass2Context ctx) {
        var r = new ValueUnion();
        r.map1 = new HashMap<>();
        return r;
    }

    @Override
    public ValueUnion visitAlias(ZoneshowParser.AliasContext ctx) {
        var r = new ValueUnion();
        r.map1 = new HashMap<>();
        r.map1.put(ctx.NAME().getText(), visit(ctx.aps()).sa1);
        return r;
    }

    @Override
    public ValueUnion visitAps1(ZoneshowParser.Aps1Context ctx) {
        var r = visit(ctx.aps());
        r.sa1.add(ctx.ap().getText());
        return r;
    }

    @Override
    public ValueUnion visitAps2(ZoneshowParser.Aps2Context ctx) {
        var r = new ValueUnion();
        r.sa1 = new LinkedList<>();
        r.sa1.add(ctx.ap().getText());
        return r;
    }

    @Override
    public ValueUnion visitAps3(ZoneshowParser.Aps3Context ctx) {
        var r = new ValueUnion();
        r.sa1 = new LinkedList<>();
        return r;
    }

    @Override
    public ValueUnion visitAp(ZoneshowParser.ApContext ctx) {
        var res = new ValueUnion();
        var a = ctx.PORT();
        if (a != null)
            res.s1 = a.getText();
        else
            res.s1 = ctx.WWPN().getText();
        return res;
    }

    @Override
    public ValueUnion visitEzones1(ZoneshowParser.Ezones1Context ctx) {
        var r = visit(ctx.ezones());
        var r2 = visit(ctx.ezone());
        r2.map1.keySet().forEach(x -> {
            r.map1.put(x, r2.map1.get(x));
        });
        return r;
    }

    @Override
    public ValueUnion visitEzones2(ZoneshowParser.Ezones2Context ctx) {
        var r = new ValueUnion();
        r.map1 = new HashMap<>();
        return r;
    }

    @Override
    public ValueUnion visitEzone(ZoneshowParser.EzoneContext ctx) {
        var r = new ValueUnion();
        r.map1 = new HashMap<>();
        r.map1.put(ctx.NAME().getText(), visit(ctx.ports()).sa1);
        return r;
    }

    @Override
    public ValueUnion visitPort1(ZoneshowParser.Port1Context ctx) {
        var a = visit(ctx.ports());
        var b = ctx.port();
        a.sa1.add(b.getText());
        return a;
    }

    @Override
    public ValueUnion visitPort2(ZoneshowParser.Port2Context ctx) {
        var r = new ValueUnion();
        r.sa1 = new LinkedList<>();
        return r;
    }

    @Override
    public ValueUnion visitPort(ZoneshowParser.PortContext ctx) {
        var pt = ctx.PORT();
        var wn = ctx.WWPN();

        var res = new ValueUnion();
        if (pt != null)
            res.s1 = pt.getText();
        else
            res.s1 = wn.getText();
        return res;
    }

}
