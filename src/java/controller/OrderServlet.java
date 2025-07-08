/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CartDAO;
import dao.OrderDAO;
import dao.ProductDAO;
import model.*;
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
@WebServlet(name = "OrderServlet", urlPatterns = {"/order"})
public class OrderServlet extends HttpServlet {

    private OrderDAO orderDAO;
    private CartDAO cartDAO;
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        cartDAO = new CartDAO();
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
            case "list":
            {
                try {
                    listOrders(request, response);
                } catch (SQLException ex) {
                    Logger.getLogger(OrderServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (ClassNotFoundException ex) {
                    Logger.getLogger(OrderServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
                break;

            case "detail":
            {
                try {
                    showOrderDetail(request, response);
                } catch (SQLException ex) {
                    Logger.getLogger(OrderServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (ClassNotFoundException ex) {
                    Logger.getLogger(OrderServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
                break;

            case "checkout":
            {
                try {
                    showCheckout(request, response);
                } catch (SQLException ex) {
                    Logger.getLogger(OrderServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (ClassNotFoundException ex) {
                    Logger.getLogger(OrderServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
                break;

            default:
                try {
                    listOrders(request, response);
                } catch (SQLException ex) {
                    Logger.getLogger(OrderServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (ClassNotFoundException ex) {
                    Logger.getLogger(OrderServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect("order");
            return;
        }

        switch (action) {
            case "place":
            {
                try {
                    placeOrder(request, response);
                } catch (SQLException ex) {
                    Logger.getLogger(OrderServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (ClassNotFoundException ex) {
                    Logger.getLogger(OrderServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
                break;

            default:
                response.sendRedirect("order");
                break;
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("user?action=login");
            return;
        }

        User user = (User) session.getAttribute("user");
        List<Order> orders = orderDAO.getOrdersByUserId(user.getUserId());

        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/orders.jsp").forward(request, response);
    }

    private void showOrderDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("user?action=login");
            return;
        }

        String orderIdStr = request.getParameter("id");

        if (orderIdStr == null) {
            response.sendRedirect("order");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            Order order = orderDAO.getOrderById(orderId);
            List<OrderItem> orderItems = orderDAO.getOrderItems(orderId);

            if (order != null) {
                User user = (User) session.getAttribute("user");
                // Check if order belongs to current user
                if (order.getUserId() == user.getUserId()) {
                    request.setAttribute("order", order);
                    request.setAttribute("orderItems", orderItems);
                    request.getRequestDispatcher("/order-detail.jsp").forward(request, response);
                    return;
                }
            }

            response.sendRedirect("order");
        } catch (NumberFormatException e) {
            response.sendRedirect("order");
        }
    }

    private void showCheckout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("user?action=login");
            return;
        }

        User user = (User) session.getAttribute("user");
        List<CartItem> cartItems = cartDAO.getCartItems(user.getUserId());

        if (cartItems.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }

        double totalAmount = cartDAO.getCartTotal(user.getUserId());

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("totalAmount", totalAmount);
        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }

    private void placeOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("user?action=login");
            return;
        }

        String shippingAddress = request.getParameter("shippingAddress");
        String paymentMethod = request.getParameter("paymentMethod");

        if (shippingAddress == null || shippingAddress.trim().isEmpty()
                || paymentMethod == null || paymentMethod.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin");
            showCheckout(request, response);
            return;
        }

        User user = (User) session.getAttribute("user");
        List<CartItem> cartItems = cartDAO.getCartItems(user.getUserId());

        if (cartItems.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }

        double totalAmount = cartDAO.getCartTotal(user.getUserId());

        // Create order
        Order order = new Order(user.getUserId(), totalAmount, shippingAddress, paymentMethod);
        int orderId = orderDAO.createOrder(order);

        if (orderId > 0) {
            // Add order items and update product stock
            boolean success = true;
            for (CartItem cartItem : cartItems) {
                OrderItem orderItem = new OrderItem(orderId, cartItem.getProductId(),
                        cartItem.getQuantity(), cartItem.getProduct().getPrice());

                if (!orderDAO.addOrderItem(orderItem)) {
                    success = false;
                    break;
                }

                // Update product stock
                Product product = cartItem.getProduct();
                int newStock = product.getStock() - cartItem.getQuantity();
                productDAO.updateStock(product.getProductId(), newStock);
            }

            if (success) {
                // Clear cart
                cartDAO.clearCart(user.getUserId());
                response.sendRedirect("order?action=detail&id=" + orderId);
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi đặt hàng");
                showCheckout(request, response);
            }
        } else {
            request.setAttribute("error", "Có lỗi xảy ra khi đặt hàng");
            showCheckout(request, response);
        }
    }
}
