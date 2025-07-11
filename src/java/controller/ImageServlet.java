/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

/**
 *
 * @author vient
 */
@WebServlet(name = "ImageServlet", urlPatterns = {"/images/*"})
public class ImageServlet extends HttpServlet {

     private static final String IMAGE_DIR = "D:/MyUploads/ProductImages";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy tên file từ URL
        String requestedImage = request.getPathInfo(); // ví dụ: /12345_image.jpg

        if (requestedImage == null || requestedImage.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND); // 404
            return;
        }

        File imageFile = new File(IMAGE_DIR, requestedImage);

        if (!imageFile.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND); // 404
            return;
        }

        String contentType = getServletContext().getMimeType(imageFile.getName());
        if (contentType == null) {
            contentType = "application/octet-stream";
        }

        response.setContentType(contentType);
        response.setContentLengthLong(imageFile.length());

        try ( InputStream in = new FileInputStream(imageFile);  OutputStream out = response.getOutputStream()) {

            byte[] buffer = new byte[4096];
            int bytesRead;

            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
}

