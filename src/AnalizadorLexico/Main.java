import java.io.FileReader;
import java_cup.runtime.Symbol;

public class Main {
    public static void main(String[] args) throws Exception {
        try {
            FileReader r = new FileReader("entrada.txt");
            
            // Análisis léxico primero
            System.out.println("=== ANÁLISIS LÉXICO ===");
            Lexer lexer = new Lexer(r);
            Symbol token;
            do {
                token = lexer.next_token();
                if (token.sym != sym.EOF) {
                    System.out.println("Token: " + sym.terminalNames[token.sym] + " -> '" + token.value + "'");
                }
            } while (token.sym != sym.EOF);
            
            // Análisis sintáctico con debug
            System.out.println("\n=== ANÁLISIS SINTÁCTICO ===");
            r = new FileReader("entrada.txt");
            lexer = new Lexer(r);
            parser p = new parser(lexer);
            
            
            p.parse();
            System.out.println("CORRECTO: Análisis completado");
            
        } catch (Exception e) {
            System.err.println("ERROR: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
