package utils;

import java.util.concurrent.ThreadLocalRandom;

public class PasswordUtils {
    private static final String letras = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    private static final String numeros = "0123456789";

    /* Valida si 2 cararteres son consecutivos */
    private static boolean esConsecutivo(char a, char b){
        boolean AesLetra = Character.isLetter(a);
        boolean BesLetra = Character.isLetter(b);
        boolean AesNumero = Character.isDigit(a);
        boolean BesNumero = Character.isDigit(b);

        if (AesLetra && BesLetra) {
            char primeraLetra = Character.toLowerCase(a);
            char segundaLetra = Character.toLowerCase(b);
            return Math.abs(primeraLetra - segundaLetra) == 1;
        }

        if (AesNumero && BesNumero) {
            return Math.abs(a - b) == 1;
        }
        return false;
    }

    /*Genera la clave sin caracteres repetidos*/
    private static String generaNoConsecutivo(String letra, int numero) {
        StringBuilder out = new StringBuilder();
        for (int i = 0; i < numero; i++){
            char c;
            int guardar = 0;
            do {
                int index = ThreadLocalRandom.current().nextInt(letra.length());
                c = letra.charAt(index);
                guardar++;
                if (guardar > 1000){
                    break;
                }
            } while (i > 0 && (out.charAt(i - 1) == c || esConsecutivo(out.charAt(i - 1), c)));
            out.append(c);
        }
        return out.toString();
    }

    /*Generador de clave random*/
    public static String generarClaveRandom(Integer cuantasLetras, Integer cuantosNumeros) {
        String clavePorDefecto = "bice01";
        try {
            if (cuantasLetras == null || cuantosNumeros == null || cuantasLetras <= 0 || cuantosNumeros <= 0) {
                //System.err.println("Se asigna clave por defecto: " + clavePorDefecto);
                return clavePorDefecto;
            } else {
                String letrasClave = generaNoConsecutivo(letras, cuantasLetras);
                String numerosClave = generaNoConsecutivo(numeros, cuantosNumeros);
                String claveRandom = letrasClave + numerosClave;
                //System.err.println("Se asigna clave provisoria: " + claveRandom);
                return claveRandom;
            }
        } catch (Exception e) {
            //System.err.println("Error generando clave, usando valor por defecto: " + clavePorDefecto);
            System.err.println(e.getMessage());
            return clavePorDefecto;
        }
    }
    public static String generarClaveRandom() {
        return generarClaveRandom(null, null);
    }
    public static String generarClaveRandom(String clave) {
        //System.err.println("Se asigna clave: " + clave);
        return clave;
    }
}
