/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import java.util.Base64;

public class PasswordUtil {
       // Mã hóa chuỗi thành Base64
    public static String encodeString(String input) {
        return Base64.getEncoder().encodeToString(input.getBytes());
    }

    // Giải mã chuỗi Base64 thành chuỗi gốc
    public static String decodeString(String base64Input) {
        byte[] decodedBytes = Base64.getDecoder().decode(base64Input);
        return new String(decodedBytes);
    }

}
