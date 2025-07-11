/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import dao.ProductDAO;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Product;

@WebServlet("/admin-product")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AdminProductServlet extends HttpServlet {
//    private ProductDAO productDAO;
//
//    @Override
//    public void init() throws ServletException {
//        productDAO = new ProductDAO();
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
//            throws ServletException, IOException {
//        String action = request.getParameter("action");
//        
//        if (action == null) {
//            action = "list";
//        }
//        
//        switch (action) {
//            case "list":
//                listProducts(request, response);
//                break;
//            case "edit":
//                showEditForm(request, response);
//                break;
//            case "view":
//            {
//                try {
//                    viewProduct(request, response);
//                } catch (SQLException ex) {
//                    Logger.getLogger(AdminProductServlet.class.getName()).log(Level.SEVERE, null, ex);
//                } catch (ClassNotFoundException ex) {
//                    Logger.getLogger(AdminProductServlet.class.getName()).log(Level.SEVERE, null, ex);
//                }
//            }
//                break;
//
//            default:
//                listProducts(request, response);
//                break;
//        }
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
//            throws ServletException, IOException {
//        String action = request.getParameter("action");
//        
//        if (action == null) {
//            response.sendRedirect("admin-products.jsp");
//            return;
//        }
//        
//        switch (action) {
//            case "add":
//                addProduct(request, response);
//                break;
//            case "edit":
//                updateProduct(request, response);
//                break;
//            case "delete":
//                deleteProduct(request, response);
//                break;
//            default:
//                response.sendRedirect("admin-products.jsp");
//                break;
//        }
//    }
//
//    private void listProducts(HttpServletRequest request, HttpServletResponse response) 
//            throws ServletException, IOException {
//        List<Product> products = productDAO.getAllProducts();
//        request.setAttribute("products", products);
//        request.getRequestDispatcher("admin-products.jsp").forward(request, response);
//    }
//
//    private void addProduct(HttpServletRequest request, HttpServletResponse response) 
//            throws ServletException, IOException {
//        try {
//            // Get form parameters
//            String name = request.getParameter("name");
//            double price = Double.parseDouble(request.getParameter("price"));
//            int quantity = Integer.parseInt(request.getParameter("quantity"));
//            String description = request.getParameter("description");
//            String category = request.getParameter("category");
//            
//            // Handle file upload
//            String imageName = "default-balo.jpg";
//            Part imagePart = request.getPart("image");
//            
//            if (imagePart != null && imagePart.getSize() > 0) {
//                String fileName = getFileName(imagePart);
//                if (fileName != null && !fileName.isEmpty()) {
//                    imageName = System.currentTimeMillis() + "_" + fileName;
//                    String uploadPath = getServletContext().getRealPath("/images");
//                    imagePart.write(uploadPath + "/" + imageName);
//                }
//            }
//            
//            // Create product object
//            Product product = new Product();
//            product.setName(name);
//            product.setPrice(price);
//            product.setQuantity(quantity);
//            product.setDescription(description);
//            product.setCategory(category);
//            product.setImage(imageName);
//            
//            // Save to database
//            boolean success = productDAO.addProduct(product);
//            
//            if (success) {
//                request.setAttribute("successMessage", "Thêm sản phẩm thành công!");
//            } else {
//                request.setAttribute("errorMessage", "Có lỗi xảy ra khi thêm sản phẩm!");
//            }
//            
//        } catch (Exception e) {
//            e.printStackTrace();
//            request.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
//        }
//        
//        response.sendRedirect("admin-products.jsp");
//    }
//
//    private void updateProduct(HttpServletRequest request, HttpServletResponse response) 
//            throws ServletException, IOException {
//        try {
//            // Get form parameters
//            int productId = Integer.parseInt(request.getParameter("productId"));
//            String name = request.getParameter("name");
//            double price = Double.parseDouble(request.getParameter("price"));
//            int quantity = Integer.parseInt(request.getParameter("quantity"));
//            String description = request.getParameter("description");
//            String category = request.getParameter("category");
//            
//            // Get existing product
//            Product product = productDAO.getProductById(productId);
//            if (product == null) {
//                request.setAttribute("errorMessage", "Không tìm thấy sản phẩm!");
//                response.sendRedirect("admin-products.jsp");
//                return;
//            }
//            
//            // Handle file upload
//            Part imagePart = request.getPart("image");
//            String imageName = product.getImage(); // Keep existing image by default
//            
//            if (imagePart != null && imagePart.getSize() > 0) {
//                String fileName = getFileName(imagePart);
//                if (fileName != null && !fileName.isEmpty()) {
//                    imageName = System.currentTimeMillis() + "_" + fileName;
//                    String uploadPath = getServletContext().getRealPath("/images");
//                    imagePart.write(uploadPath + "/" + imageName);
//                }
//            }
//            
//            // Update product object
//            product.setName(name);
//            product.setPrice(price);
//            product.setQuantity(quantity);
//            product.setDescription(description);
//            product.setCategory(category);
//            product.setImage(imageName);
//            
//            // Update in database
//            boolean success = productDAO.updateProduct(product);
//            
//            if (success) {
//                request.setAttribute("successMessage", "Cập nhật sản phẩm thành công!");
//            } else {
//                request.setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật sản phẩm!");
//            }
//            
//        } catch (Exception e) {
//            e.printStackTrace();
//            request.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
//        }
//        
//        response.sendRedirect("admin-products.jsp");
//    }
//
//    private void deleteProduct(HttpServletRequest request, HttpServletResponse response) 
//            throws ServletException, IOException {
//        try {
//            int productId = Integer.parseInt(request.getParameter("productId"));
//            
//            boolean success = productDAO.deleteProduct(productId);
//            
//            if (success) {
//                request.setAttribute("successMessage", "Xóa sản phẩm thành công!");
//            } else {
//                request.setAttribute("errorMessage", "Có lỗi xảy ra khi xóa sản phẩm!");
//            }
//            
//        } catch (Exception e) {
//            e.printStackTrace();
//            request.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
//        }
//        
//        response.sendRedirect("admin-products.jsp");
//    }
//
//    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
//            throws ServletException, IOException {
//        try {
//            int productId = Integer.parseInt(request.getParameter("id"));
//            Product product = productDAO.getProductById(productId);
//            
//            if (product != null) {
//                request.setAttribute("product", product);
//                request.getRequestDispatcher("admin-edit-product.jsp").forward(request, response);
//            } else {
//                request.setAttribute("errorMessage", "Không tìm thấy sản phẩm!");
//                response.sendRedirect("admin-products.jsp");
//            }
//            
//        } catch (Exception e) {
//            e.printStackTrace();
//            request.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
//            response.sendRedirect("admin-products.jsp");
//        }
//    }
//    
//    private void viewProduct(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException, SQLException, ClassNotFoundException {
//
//        List<Product> products = productDAO.getAllProducts(); // Lấy tất cả sản phẩm
//
//        request.setAttribute("products", products);
//
//        request.getRequestDispatcher("/products.jsp").forward(request, response);
//    }
}