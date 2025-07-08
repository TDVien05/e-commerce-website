/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CartDAO;
import dao.ProductDAO;
import model.CartItem;
import model.Product;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author vient
 */
@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

    private CartDAO cartDAO;
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            action = "view";
        }

        switch (action) {
            case "view": {
                try {
                    viewCart(request, response);
                } catch (SQLException ex) {
                    Logger.getLogger(CartServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (ClassNotFoundException ex) {
                    Logger.getLogger(CartServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            break;

            case "remove": {
                try {
                    removeFromCart(request, response);
                } catch (SQLException ex) {
                    Logger.getLogger(CartServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (ClassNotFoundException ex) {
                    Logger.getLogger(CartServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            break;

            default:
                try {
                    viewCart(request, response);
                } catch (SQLException ex) {
                    Logger.getLogger(CartServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (ClassNotFoundException ex) {
                    Logger.getLogger(CartServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect("cart");
            return;
        }

        switch (action) {
            case "add":
            {
                try {
                    addToCart(request, response);
                } catch (SQLException ex) {
                    Logger.getLogger(CartServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (ClassNotFoundException ex) {
                    Logger.getLogger(CartServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
                break;

            case "update":
            {
                try {
                    updateCart(request, response);
                } catch (SQLException ex) {
                    Logger.getLogger(CartServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (ClassNotFoundException ex) {
                    Logger.getLogger(CartServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
                break;

            default:
                response.sendRedirect("cart");
                break;
        }
    }

    private void viewCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("user?action=login");
            return;
        }

        User user = (User) session.getAttribute("user");
        List<CartItem> cartItems = cartDAO.getCartItems(user.getUserId());
        double totalAmount = cartDAO.getCartTotal(user.getUserId());

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("totalAmount", totalAmount);
        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("user?action=login");
            return;
        }

        String productIdStr = request.getParameter("productId");
        String quantityStr = request.getParameter("quantity");

        if (productIdStr == null || quantityStr == null) {
            response.sendRedirect("product");
            return;
        }

        try {
            int productId = Integer.parseInt(productIdStr);
            int quantity = Integer.parseInt(quantityStr);

            if (quantity <= 0) {
                response.sendRedirect("product?action=detail&id=" + productId);
                return;
            }

            // Check if product exists and has enough stock
            Product product = productDAO.getProductById(productId);
            if (product == null || product.getStock() < quantity) {
                request.setAttribute("error", "Sản phẩm không đủ số lượng trong kho");
                response.sendRedirect("product?action=detail&id=" + productId);
                return;
            }

            User user = (User) session.getAttribute("user");
            CartItem cartItem = new CartItem(user.getUserId(), productId, quantity);

            if (cartDAO.addToCart(cartItem)) {
                response.sendRedirect("cart");
            } else {
                response.sendRedirect("product?action=detail&id=" + productId);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("product");
        }
    }

    private void updateCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("user?action=login");
            return;
        }

        String[] cartItemIds = request.getParameterValues("cartItemId");
        String[] quantities = request.getParameterValues("quantity");

        if (cartItemIds != null && quantities != null && cartItemIds.length == quantities.length) {
            for (int i = 0; i < cartItemIds.length; i++) {
                try {
                    int cartItemId = Integer.parseInt(cartItemIds[i]);
                    int quantity = Integer.parseInt(quantities[i]);
                    cartDAO.updateCartItemQuantity(cartItemId, quantity);
                } catch (NumberFormatException e) {
                    // Skip invalid entries
                }
            }
        }

        response.sendRedirect("cart");
    }

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("user?action=login");
            return;
        }

        String cartItemIdStr = request.getParameter("cartItemId");

        if (cartItemIdStr != null) {
            try {
                int cartItemId = Integer.parseInt(cartItemIdStr);
                cartDAO.removeCartItem(cartItemId);
            } catch (NumberFormatException e) {
                // Handle error
            }
        }

        response.sendRedirect("cart");
    }
}
