import java.util.*;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.ErrorNode;
import org.antlr.v4.runtime.tree.TerminalNode;
import java_lis.*;

public class ListenerMyImpl extends ZoneshowBaseListener {
    List<String> ports, aps, ans, zns;
    Map<String, List<String>> ezone, ezones, alias, aliass, zone, zones, cfg, cfgs;
    String ap;

    List<Map<String, List<String>>> defx;
    Map<String, Map<String, List<String>>> effx;

    void print_s_h(String name, Map<String, List<String>> head){
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


	@Override public void enterZoneshow1(ZoneshowParser.Zoneshow1Context ctx) {
    }
	@Override public void exitZoneshow1(ZoneshowParser.Zoneshow1Context ctx) {
        Map<String, List<String>> v;

        v = this.defx.get(0);
        print_s_h("all config", v);

        v = this.defx.get(1);
        print_s_h("all zone", v);

        v = this.defx.get(2);
        print_s_h("all alias", v);

        for (Map.Entry<String, Map<String, List<String>>> entry : effx.entrySet()) {
            print_s_h(entry.getKey(), entry.getValue());
        }
    }
	@Override public void enterZoneshow2(ZoneshowParser.Zoneshow2Context ctx) {
    }
	@Override public void exitZoneshow2(ZoneshowParser.Zoneshow2Context ctx) {
        System.err.println(" !! not defined and effect");
        //TOOD
        Map<String, List<String>> v;
        v = new HashMap<>();
        print_s_h("all config", v);
        print_s_h("all zone", v);
        print_s_h("all alias", v);
        print_s_h("", v);
    }
	@Override public void enterDefx(ZoneshowParser.DefxContext ctx) {
    }
	@Override public void exitDefx(ZoneshowParser.DefxContext ctx) {
        this.defx = new ArrayList<>();
        this.defx.add(this.cfgs);
        this.defx.add(this.zones);
        this.defx.add(this.aliass);
    }
	@Override public void enterEffx(ZoneshowParser.EffxContext ctx) {
    }
	@Override public void exitEffx(ZoneshowParser.EffxContext ctx) {
        this.effx = new HashMap<>();
        this.effx.put(ctx.NAME().getText(), this.ezones);
    }
	@Override public void enterCfgs2(ZoneshowParser.Cfgs2Context ctx) {
    }
	@Override public void exitCfgs2(ZoneshowParser.Cfgs2Context ctx) {
        this.cfgs = new HashMap<>();
    }
	@Override public void enterCfgs1(ZoneshowParser.Cfgs1Context ctx) {
    }
	@Override public void exitCfgs1(ZoneshowParser.Cfgs1Context ctx) {
        this.cfgs.putAll(this.cfg);
    }
	@Override public void enterCfg(ZoneshowParser.CfgContext ctx) {
    }
	@Override public void exitCfg(ZoneshowParser.CfgContext ctx) {
        this.cfg = new HashMap<>();
        this.cfg.put(ctx.NAME().getText(), this.zns );
    }
	@Override public void enterZns2(ZoneshowParser.Zns2Context ctx) {
    }
	@Override public void exitZns2(ZoneshowParser.Zns2Context ctx) {
        this.zns = new ArrayList<>();
        this.zns.add(ctx.NAME().getText());
    }
	@Override public void enterZns1(ZoneshowParser.Zns1Context ctx) {
    }
	@Override public void exitZns1(ZoneshowParser.Zns1Context ctx) {
        this.zns.add(ctx.NAME().getText());
    }
	@Override public void enterZones1(ZoneshowParser.Zones1Context ctx) {
    }
	@Override public void exitZones1(ZoneshowParser.Zones1Context ctx) {
        this.zones.putAll(this.zone);
    }
	@Override public void enterZones2(ZoneshowParser.Zones2Context ctx) {
    }
	@Override public void exitZones2(ZoneshowParser.Zones2Context ctx) {
        this.zones = new HashMap<String, List<String>>();
    }
	@Override public void enterZone(ZoneshowParser.ZoneContext ctx) {
    }
	@Override public void exitZone(ZoneshowParser.ZoneContext ctx) {
        this.zone = new HashMap<>();
        this.zone.put(ctx.NAME().getText(), this.ans);
    }
	@Override public void enterAns3(ZoneshowParser.Ans3Context ctx) {
    }
	@Override public void exitAns3(ZoneshowParser.Ans3Context ctx) {
        this.ans = new ArrayList<>();
    }
	@Override public void enterAns2(ZoneshowParser.Ans2Context ctx) {
    }
	@Override public void exitAns2(ZoneshowParser.Ans2Context ctx) {
        var v = ctx.an().NAME();
        if (v==null) v = ctx.an().PORT();
        if (v==null) v = ctx.an().WWPN();
        this.ans = new ArrayList<>();
        this.ans.add(v.getText());
    }
	@Override public void enterAns1(ZoneshowParser.Ans1Context ctx) {
    }
	@Override public void exitAns1(ZoneshowParser.Ans1Context ctx) {
        var v = ctx.an().NAME();
        if (v==null) v = ctx.an().PORT();
        if (v==null) v = ctx.an().WWPN();
        this.ans.add(v.getText());
    }
	@Override public void enterAn(ZoneshowParser.AnContext ctx) {
    }
	@Override public void exitAn(ZoneshowParser.AnContext ctx) {
    }
	@Override public void enterAliass2(ZoneshowParser.Aliass2Context ctx) {
    }
	@Override public void exitAliass2(ZoneshowParser.Aliass2Context ctx) {
        this.aliass = new HashMap<>();
    }
	@Override public void enterAliass1(ZoneshowParser.Aliass1Context ctx) {
    }
	@Override public void exitAliass1(ZoneshowParser.Aliass1Context ctx) {
        this.aliass.putAll(this.alias);
    }
	@Override public void enterAlias(ZoneshowParser.AliasContext ctx) {
    }
	@Override public void exitAlias(ZoneshowParser.AliasContext ctx) {
        this.alias = new HashMap<>();
        this.alias.put(ctx.NAME().getText(), this.aps);
    }
	@Override public void enterAps1(ZoneshowParser.Aps1Context ctx) {
    }
	@Override public void exitAps1(ZoneshowParser.Aps1Context ctx) {
        this.aps.add(this.ap);
    }
	@Override public void enterAps3(ZoneshowParser.Aps3Context ctx) {
    }
	@Override public void exitAps3(ZoneshowParser.Aps3Context ctx) {
        this.aps = new ArrayList<>();
    }
	@Override public void enterAps2(ZoneshowParser.Aps2Context ctx) {
    }
	@Override public void exitAps2(ZoneshowParser.Aps2Context ctx) {
        var v = ctx.ap().PORT();
        if(v==null) v = ctx.ap().WWPN();
        this.aps = new ArrayList<>();
        this.aps.add(v.getText());
    }
	@Override public void enterAp(ZoneshowParser.ApContext ctx) {
    }
	@Override public void exitAp(ZoneshowParser.ApContext ctx) {
        var v = ctx.PORT();
        if(v==null) v = ctx.WWPN();
        this.ap = v.getText();
    }
	@Override public void enterEzones2(ZoneshowParser.Ezones2Context ctx) {
    }
	@Override public void exitEzones2(ZoneshowParser.Ezones2Context ctx) {
        this.ezones = new HashMap<>();
    }
	@Override public void enterEzones1(ZoneshowParser.Ezones1Context ctx) {
    }
	@Override public void exitEzones1(ZoneshowParser.Ezones1Context ctx) {
    this.ezones.putAll(this.ezone);
    }
	@Override public void enterEzone(ZoneshowParser.EzoneContext ctx) {
    }
	@Override public void exitEzone(ZoneshowParser.EzoneContext ctx) {
        ezone = new HashMap<>();
        this.ezone.put(ctx.NAME().getText(), this.ports);
    }
	@Override public void enterPort1(ZoneshowParser.Port1Context ctx) {
    }
	@Override public void exitPort1(ZoneshowParser.Port1Context ctx) {
        var v  = ctx.port().PORT();
        if(v==null) v = ctx.port().WWPN();

        this.ports.add(v.getText()) ;
    }
	@Override public void enterPort2(ZoneshowParser.Port2Context ctx) {
    }
	@Override public void exitPort2(ZoneshowParser.Port2Context ctx) {

        this.ports = new ArrayList<>();
    }
	@Override public void enterPort(ZoneshowParser.PortContext ctx) {
    }
	@Override public void exitPort(ZoneshowParser.PortContext ctx) {
    }

	@Override public void enterEveryRule(ParserRuleContext ctx) {
    }
	@Override public void exitEveryRule(ParserRuleContext ctx) {
    }
	@Override public void visitTerminal(TerminalNode node) {
    }
	@Override public void visitErrorNode(ErrorNode node) {
    }
}

