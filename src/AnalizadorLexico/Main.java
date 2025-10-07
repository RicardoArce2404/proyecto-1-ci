import java.io.*;
import java_cup.runtime.Symbol;

public class Main {
    private static TablaSimbolos tablaSimbolos;
    private static ManejadorErrores manejadorErrores;
    
    public static void main(String[] args) throws Exception {
        // Inicializar componentes
        tablaSimbolos = new TablaSimbolos();
        manejadorErrores = new ManejadorErrores();
        
        try {
            // Configurar archivos de salida
            PrintWriter tokenWriter = new PrintWriter(new FileWriter("tokens.txt"));
            PrintWriter resultadoWriter = new PrintWriter(new FileWriter("resultado_analisis.txt"));
            
            FileReader r = new FileReader("entrada.txt");
            
            // ========== ANÁLISIS LÉXICO ==========
            System.out.println("=== ANÁLISIS LÉXICO ===");
            tokenWriter.println("=== TOKENS ENCONTRADOS ===");
            tokenWriter.println("Token\t\t\tLexema\t\t\tLínea\tColumna");
            tokenWriter.println("------------------------------------------------");
            
            Lexer lexer = new Lexer(r);
            lexer.setTablaSimbolos(tablaSimbolos);
            lexer.setManejadorErrores(manejadorErrores);
            
            Symbol token;
            int totalTokens = 0;
            
            do {
                token = lexer.next_token();
                if (token.sym != sym.EOF) {
                    String tokenName = sym.terminalNames[token.sym];
                    String lexeme = token.value != null ? token.value.toString() : "";
                    
                    // Mostrar en consola
                    System.out.printf("Token: %-15s -> '%s' [Línea %d, Columna %d]%n", 
                        tokenName, lexeme, token.left + 1, token.right + 1);
                    
                    // Escribir en archivo
                    tokenWriter.printf("%-18s\t%-18s\t%d\t%d%n", 
                        tokenName, lexeme, token.left + 1, token.right + 1);
                    
                    totalTokens++;
                }
            } while (token.sym != sym.EOF);
            
            tokenWriter.println("\nTotal de tokens: " + totalTokens);
            tokenWriter.close();
            
            System.out.println("\n✓ Análisis léxico completado. Tokens encontrados: " + totalTokens);
            
            // ========== ANÁLISIS SINTÁCTICO ==========
            System.out.println("\n=== ANÁLISIS SINTÁCTICO ===");
            r = new FileReader("entrada.txt");
            lexer = new Lexer(r);
            lexer.setTablaSimbolos(tablaSimbolos);
            lexer.setManejadorErrores(manejadorErrores);
            
            parser p = new parser(lexer);
            
            boolean sintaxisCorrecta = false;
            String mensajeResultado = "";
            
            try {
                p.debug_parse();
                sintaxisCorrecta = true;
                mensajeResultado = "El archivo SÍ puede ser generado por la gramática";
                System.out.println("CORRECTO: " + mensajeResultado);
                
            } catch (Exception e) {
                sintaxisCorrecta = false;
                mensajeResultado = "El archivo NO puede ser generado por la gramática";
                System.out.println("ERROR: " + mensajeResultado);
                manejadorErrores.agregarErrorSintactico("Error de parsing: " + e.getMessage(), 0, 0);
            }
            
            // ========== ESCRIBIR RESULTADOS FINALES ==========
            escribirResultadoFinal(resultadoWriter, sintaxisCorrecta, mensajeResultado);
            resultadoWriter.close();
            
            // Escribir tabla de símbolos
            tablaSimbolos.escribirTablaArchivo("tabla_simbolos.txt");
            
            // ========== REPORTE FINAL ==========
            System.out.println("\n=== REPORTE FINAL ===");
            System.out.println("Tokens guardados en: tokens.txt");
            System.out.println("Tabla de símbolos guardada en: tabla_simbolos.txt");
            System.out.println("Resultado del análisis en: resultado_analisis.txt");
            System.out.println("Errores guardados en: errores.txt");
            System.out.println("Total de errores: " + manejadorErrores.getTotalErrores());
            
            if (sintaxisCorrecta && !manejadorErrores.hayErrores()) {
                System.out.println("¡ANÁLISIS COMPLETADO EXITOSAMENTE!");
            } else {
                System.out.println("Análisis completado con errores. Revise los archivos de reporte.");
            }
            
        } catch (FileNotFoundException e) {
            System.err.println("ERROR: No se encontró el archivo 'entrada.txt'");
            System.err.println("Asegúrese de que el archivo existe en el directorio actual.");
        } catch (Exception e) {
            System.err.println("ERROR CRÍTICO: " + e.getMessage());
            e.printStackTrace();
        } finally {
            manejadorErrores.cerrar();
        }
    }
    
    private static void escribirResultadoFinal(PrintWriter writer, boolean sintaxisCorrecta, String mensaje) {
        writer.println("=== RESULTADO DEL ANÁLISIS ===");
        writer.println();
        writer.println("ESTADO: " + (sintaxisCorrecta ? "CORRECTO" : "ERROR"));
        writer.println("MENSAJE: " + mensaje);
        writer.println();
        writer.println("=== ESTADÍSTICAS ===");
        writer.println("Errores léxicos/sintácticos: " + manejadorErrores.getTotalErrores());
        writer.println("Archivos generados:");
        writer.println("  - tokens.txt: Lista de todos los tokens encontrados");
        writer.println("  - tabla_simbolos.txt: Tabla de símbolos identificados");
        writer.println("  - errores.txt: Reporte detallado de errores");
        writer.println("  - resultado_analisis.txt: Este archivo de resultados");
        
        if (sintaxisCorrecta && !manejadorErrores.hayErrores()) {
            writer.println("El programa es sintácticamente correcto y puede ser procesado.");
        } else {
            writer.println("El programa contiene errores que deben ser corregidos.");
        }
    }
}