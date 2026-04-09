package utils;

public class EncryptUtils {
    private static final String stfKey = "                                @h\n?y5V*a7QDqU-^2I%f4{8s6HZlNCT/PXBju1m;t[\"+L(Kw|=egYS<&~!d_Mxb9v:}Wp]0,R#)GOA.$J3>ioE`kcz'r";

    public static String encryptTeloV2(String password){
        StringBuilder stringBuilder = new StringBuilder();
        for (int i = 0; i < password.length(); i++){
            char c = password.toUpperCase().charAt(i);
            int pos = stfKey.indexOf(c) + 2;
            stringBuilder.append((char) pos);
        }
        //System.err.println("Clave encriptada: " + stringBuilder.toString());
        return stringBuilder.toString();
    }
}