import java.util.*;
import java.io.*;

public class TablaSimbolos {
    private Map<String, EntradaSimbolo> tabla;
    
    public TablaSimbolos() {
        this.tabla = new HashMap<>();
    }
    
    public void agregarSimbolo(String nombre, String tipo, String categoria, int linea) {
        // Evitar duplicados
        if (!tabla.containsKey(nombre)) {
            tabla.put(nombre, new EntradaSimbolo(nombre, tipo, categoria, linea));
        }
    }
    
    public void agregarSimbolo(String nombre, String tipo, String categoria, int linea, String valor) {
        if (!tabla.containsKey(nombre)) {
            tabla.put(nombre, new EntradaSimbolo(nombre, tipo, categoria, linea, valor));
        }
    }
    
    public boolean existeSimbolo(String nombre) {
        return tabla.containsKey(nombre);
    }
    
    public void actualizarTipo(String nombre, String tipo) {
        if (tabla.containsKey(nombre)) {
            tabla.get(nombre).tipo = tipo;
        }
    }
    
    public void escribirTablaArchivo(String nombreArchivo) {
        try (PrintWriter writer = new PrintWriter(new FileWriter(nombreArchivo))) {
            writer.println("=== TABLA DE SÍMBOLOS ===");
            writer.println("Nombre\t\tTipo\t\tCategoría\t\tLínea\tValor");
            writer.println("------------------------------------------------------------");
            
            List<EntradaSimbolo> entradas = new ArrayList<>(tabla.values());
            entradas.sort(Comparator.comparing(entrada -> entrada.nombre));
            
            for (EntradaSimbolo entrada : entradas) {
                writer.printf("%-12s\t%-10s\t%-12s\t\t%d\t%s%n",
                    entrada.nombre, 
                    entrada.tipo, 
                    entrada.categoria, 
                    entrada.linea,
                    entrada.valor != null ? entrada.valor : "-");
            }
            
            writer.println("\nTotal de símbolos: " + tabla.size());
        } catch (Exception e) {
            System.err.println("Error escribiendo tabla de símbolos: " + e.getMessage());
        }
    }
    
    // Clase interna para representar una entrada en la tabla
    public static class EntradaSimbolo {
        String nombre;
        String tipo;
        String categoria; // "variable", "función", "parámetro", "arreglo"
        int linea;
        String valor;
        
        public EntradaSimbolo(String nombre, String tipo, String categoria, int linea) {
            this.nombre = nombre;
            this.tipo = tipo;
            this.categoria = categoria;
            this.linea = linea;
            this.valor = null;
        }
        
        public EntradaSimbolo(String nombre, String tipo, String categoria, int linea, String valor) {
            this.nombre = nombre;
            this.tipo = tipo;
            this.categoria = categoria;
            this.linea = linea;
            this.valor = valor;
        }
    }
}