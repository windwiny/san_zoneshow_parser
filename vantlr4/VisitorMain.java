import java.io.*;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;
import java_vis.*;

public class VisitorMain {
    public static void main(String[] args) throws IOException {
        InputStream is = args.length > 0 ? new FileInputStream(args[0]) : System.in;

        CharStream input = CharStreams.fromStream(is);
        ZoneshowLexer lexer = new ZoneshowLexer(input);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        ZoneshowParser parser = new ZoneshowParser(tokens);
        ParseTree tree = parser.zoneshow();

        VisitorMyImpl mv = new VisitorMyImpl();
        // var r = mv.visit(tree);
        var r = tree.accept(mv);
        System.exit(r.ii);
    }
}
