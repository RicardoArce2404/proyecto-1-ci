import java.io.InputStreamReader;
import java.io.Reader;

public class Main {
    public static void main(String[] args) throws Exception {
        try {
          java.io.Reader r = new java.io.FileReader("entrada.txt");
          Lexer lexer = new Lexer(r);
          parser parser = new parser(lexer);
          parser.parse();
          System.out.println("✅ Análisis sintáctico completado correctamente");
        } catch (Throwable e) {
          System.err.println("Error en el parseo: " + e.getMessage());
          e.printStackTrace();
        }
    }
}
