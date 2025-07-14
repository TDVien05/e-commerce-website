/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import dao.ProductDAO;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.sql.SQLException;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Product;

/**
 *
 * @author vient
 */
@MultipartConfig
@WebServlet(name = "Productservlet", urlPatterns = {"/product"})
public class Productservlet extends HttpServlet {

    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            action = "add";
        }

        switch (action) {

            case "add": {
                addProduct(request, response);
                break;
            }
            case "edit": {
                updateProduct(request, response);
                break;
            }

            case "delete": {
                try {
                    deleteProduct(request, response);
                } catch (SQLException ex) {
                    Logger.getLogger(Productservlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (ClassNotFoundException ex) {
                    Logger.getLogger(Productservlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                break;
            }

        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list": {
                try {
                    listProducts(request, response);
                } catch (SQLException ex) {
                    Logger.getLogger(Productservlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (ClassNotFoundException ex) {
                    Logger.getLogger(Productservlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            break;

            case "detail": {
                try {
                    showProductDetail(request, response);
                } catch (SQLException ex) {
                    Logger.getLogger(Productservlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (ClassNotFoundException ex) {
                    Logger.getLogger(Productservlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            break;

            case "category": {
                try {
                    listProductsByCategory(request, response);
                } catch (SQLException ex) {
                    Logger.getLogger(Productservlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (ClassNotFoundException ex) {
                    Logger.getLogger(Productservlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            break;

            case "search": {
                try {
                    searchProducts(request, response);
                } catch (SQLException ex) {
                    Logger.getLogger(Productservlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (ClassNotFoundException ex) {
                    Logger.getLogger(Productservlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            break;

            default:
                try {
                listProducts(request, response);
            } catch (SQLException ex) {
                Logger.getLogger(Productservlet.class.getName()).log(Level.SEVERE, null, ex);
            } catch (ClassNotFoundException ex) {
                Logger.getLogger(Productservlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            break;
        }
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException, ClassNotFoundException {
        String id = request.getParameter("productId");
        boolean check = productDAO.delete(id, "inactive");
        if (check) {
            request.getSession().setAttribute("successMessage", "Xoá sản phẩm thành công!");
        } else {
            request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi xóa sản phẩm!");
        }
        response.sendRedirect("admin-product.jsp");
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy dữ liệu form
            int productId = Integer.parseInt(request.getParameter("productId"));
            String name = request.getParameter("name");
            double price = Double.parseDouble(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            String description = request.getParameter("description");
            String category = request.getParameter("category");
            String brand = request.getParameter("brand");

            // Lấy sản phẩm từ DB
            Product product = productDAO.getProductById(productId);
            if (product == null) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy sản phẩm!");
                response.sendRedirect("admin-products.jsp");
                return;
            }

            // Xử lý file ảnh (nếu có upload mới)
            Part imagePart = request.getPart("image");
            if (imagePart != null && imagePart.getSize() > 0) {
                String fileName = getFileName(imagePart);
                if (fileName != null && !fileName.isEmpty()) {
                    String imageName = generateImageUrl(fileName);

                    // Thư mục lưu ngoài project
                    String targetPath = "D:/MyUploads/ProductImages";
                    File targetDir = new File(targetPath);
                    if (!targetDir.exists()) {
                        targetDir.mkdirs();
                    }

                    // Ghi file ra thư mục ngoài
                    try ( InputStream input = imagePart.getInputStream()) {
                        Files.copy(input,
                                new File(targetDir, imageName).toPath(),
                                StandardCopyOption.REPLACE_EXISTING);
                    }

                    // Cập nhật tên ảnh mới
                    product.setImage(imageName);
                }
            }

            // Luôn cập nhật các field khác (dù có upload file mới hay không)
            product.setName(name);
            product.setPrice(price);
            product.setStock(stock);
            product.setDescription(description);
            product.setCategory(category);
            product.setBrand(brand);

            // Update DB
            boolean success = productDAO.updateProduct(product);

            if (success) {
                request.setAttribute("successMessage", "Cập nhật sản phẩm thành công!");
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật sản phẩm!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Lỗi: " + e.getMessage());
        }

        // Redirect
        response.sendRedirect("admin-product.jsp");
    }

    private String generateImageUrl(String url) {
        String uuid = UUID.randomUUID().toString();

        // Lấy đuôi file (.jpg, .png, ...)
        String extension = "";
        int dotIndex = url.lastIndexOf('.');
        if (dotIndex >= 0 && dotIndex < url.length() - 1) {
            extension = url.substring(dotIndex);
        }

        return uuid + extension;
    }

    private void addProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String name = request.getParameter("name");
            double price = Double.parseDouble(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            String description = request.getParameter("description");
            String category = request.getParameter("category");
            String brand = request.getParameter("brand");

            String imageName = "default-balo.jpg";
            Part imagePart = request.getPart("image");

            if (imagePart != null && imagePart.getSize() > 0) {
                String fileName = getFileName(imagePart);
                if (fileName != null && !fileName.isEmpty()) {
                    imageName = generateImageUrl(fileName);

                    // Thư mục lưu ngoài project
                    String targetPath = "D:/MyUploads/ProductImages";
                    File targetDir = new File(targetPath);
                    if (!targetDir.exists()) {
                        targetDir.mkdirs();
                    }

                    // Ghi file ra thư mục ngoài
                    try ( InputStream input = imagePart.getInputStream()) {
                        Files.copy(input,
                                new File(targetDir, imageName).toPath(),
                                StandardCopyOption.REPLACE_EXISTING);
                    }
                }
            }

            Product product = new Product();
            product.setName(name);
            product.setPrice(price);
            product.setStock(stock);
            product.setDescription(description);
            product.setCategory(category);
            product.setImage(imageName);
            product.setBrand(brand);

            log("name: " + name);
            log("price: " + price);
            log("stock: " + stock);
            log("desc: " + description);
            log("category: " + category);
            log("image: " + imageName);
            log("brand: " + brand);

            boolean success = productDAO.addProduct(product);

            if (success) {
                request.getSession().setAttribute("successMessage", "Thêm sản phẩm thành công!");
            } else {
                request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi thêm sản phẩm!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Lỗi: " + e.getMessage());
        }

        response.sendRedirect("admin-product.jsp");
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        for (String cd : contentDisp.split(";")) {
            if (cd.trim().startsWith("filename")) {
                return cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }

    private void showProductDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String productIdStr = request.getParameter("id");

        if (productIdStr == null || productIdStr.trim().isEmpty()) {
            response.sendRedirect("product?action=list");
            return;
        }

        try {
            int productId = Integer.parseInt(productIdStr);
            Product product = productDAO.getProductById(productId);

            if (product != null) {
                request.setAttribute("product", product);
                request.getRequestDispatcher("/product-detail.jsp").forward(request, response);
            } else {
                response.sendRedirect("product?action=list");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("product?action=list");
        }
    }

    private void listProductsByCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String category = request.getParameter("category");

        if (category == null || category.trim().isEmpty()) {
            listProducts(request, response);
            return;
        }

        List<Product> products = productDAO.getProductsByCategory(category);
        request.setAttribute("products", products);
        request.setAttribute("currentCategory", category);
        request.getRequestDispatcher("/products.jsp").forward(request, response);
    }

    private void searchProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String keyword = request.getParameter("keyword");

        if (keyword == null || keyword.trim().isEmpty()) {
            listProducts(request, response);
            return;
        }

        List<Product> products = productDAO.searchProducts(keyword);
        request.setAttribute("products", products);
        request.setAttribute("searchKeyword", keyword);
        request.getRequestDispatcher("/products.jsp").forward(request, response);
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {

        List<Product> products = productDAO.getAllProducts(); // Lấy tất cả sản phẩm

        request.setAttribute("products", products);

        request.getRequestDispatcher("/products.jsp").forward(request, response);
    }
}
