/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.ProductDAO;
import model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author vient
 */
@WebServlet(name = "Productservlet", urlPatterns = {"/product"})
public class Productservlet extends HttpServlet {

    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
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
