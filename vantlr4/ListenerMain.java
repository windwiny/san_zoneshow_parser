import java.io.*;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;
public class ListenerMain {
    public static void main(String[] args) throws IOException {
        InputStream is = args.length > 0 ? new FileInputStream(args[0]) : System.in;

        ANTLRInputStream input = new ANTLRInputStream(is);
        ZoneshowLexer lexer = new ZoneshowLexer(input);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        ZoneshowParser parser = new ZoneshowParser(tokens);
        ParseTree tree = parser.zoneshow();

        ParseTreeWalker walker = new ParseTreeWalker();
        walker.walk(new ListenerMyImpl(), tree);

        // System.out.println(tree.toStringTree(parser));
    }
}

