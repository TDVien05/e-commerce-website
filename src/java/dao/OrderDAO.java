package dao;

import model.Order;
import model.OrderItem;
import model.Product;
import util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.CartItem;

public class OrderDAO {

    public int createOrder(Order order) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO orders (user_id, order_date, total_amount, status, shipping_address, payment_method) VALUES (?, ?, ?, ?, ?, ?)";
        try ( Connection conn = DatabaseConnection.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, order.getUserId());
            stmt.setTimestamp(2, new Timestamp(order.getOrderDate().getTime()));
            stmt.setDouble(3, order.getTotalAmount());
            stmt.setString(4, order.getStatus());
            stmt.setString(5, order.getShippingAddress());
            stmt.setString(6, order.getPaymentMethod());

            int result = stmt.executeUpdate();
            if (result > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean addOrderItem(OrderItem orderItem) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
        try ( Connection conn = DatabaseConnection.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderItem.getOrderId());
            stmt.setInt(2, orderItem.getProductId());
            stmt.setInt(3, orderItem.getQuantity());
            stmt.setDouble(4, orderItem.getPrice());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Order> getOrdersByUserId(int userId) throws SQLException, ClassNotFoundException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC";

        try ( Connection conn = DatabaseConnection.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("order_id"));
                order.setUserId(rs.getInt("user_id"));
                order.setOrderDate(rs.getTimestamp("order_date"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setStatus(rs.getString("status"));
                order.setShippingAddress(rs.getString("shipping_address"));
                order.setPaymentMethod(rs.getString("payment_method"));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public Order getOrderById(int orderId) throws SQLException, ClassNotFoundException {
        String sql = "SELECT * FROM orders WHERE order_id = ?";
        try ( Connection conn = DatabaseConnection.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("order_id"));
                order.setUserId(rs.getInt("user_id"));
                order.setOrderDate(rs.getTimestamp("order_date"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setStatus(rs.getString("status"));
                order.setShippingAddress(rs.getString("shipping_address"));
                order.setPaymentMethod(rs.getString("payment_method"));
                return order;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<OrderItem> getOrderItems(int orderId) throws SQLException, ClassNotFoundException {
        List<OrderItem> orderItems = new ArrayList<>();
        String sql = "SELECT oi.*, p.name, p.image FROM order_items oi "
                + "JOIN products p ON oi.product_id = p.product_id WHERE oi.order_id = ?";

        try ( Connection conn = DatabaseConnection.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                OrderItem orderItem = new OrderItem();
                orderItem.setOrderItemId(rs.getInt("order_item_id"));
                orderItem.setOrderId(rs.getInt("order_id"));
                orderItem.setProductId(rs.getInt("product_id"));
                orderItem.setQuantity(rs.getInt("quantity"));
                orderItem.setPrice(rs.getDouble("price"));

                Product product = new Product();
                product.setProductId(rs.getInt("product_id"));
                product.setName(rs.getString("name"));
                product.setImage(rs.getString("image"));
                orderItem.setProduct(product);

                orderItems.add(orderItem);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orderItems;
    }

    public boolean updateOrderStatus(int orderId, String status) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";
        try ( Connection conn = DatabaseConnection.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, orderId);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int createOrderAtomic(Order order, List<CartItem> cartItems) throws SQLException, ClassNotFoundException {
        int orderId = -1;
        String insertOrderSQL = "INSERT INTO orders (user_id, total_amount, shipping_address, payment_method) VALUES (?, ?, ?, ?)";
        String insertItemSQL = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
        String updateStockSQL = "UPDATE products SET stock = stock - ? WHERE product_id = ? AND stock >= ?";

        try ( Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (
                     PreparedStatement orderStmt = conn.prepareStatement(insertOrderSQL, Statement.RETURN_GENERATED_KEYS);  PreparedStatement itemStmt = conn.prepareStatement(insertItemSQL);  PreparedStatement stockStmt = conn.prepareStatement(updateStockSQL)) {
                // Tạo order
                orderStmt.setInt(1, order.getUserId());
                orderStmt.setDouble(2, order.getTotalAmount());
                orderStmt.setString(3, order.getShippingAddress());
                orderStmt.setString(4, order.getPaymentMethod());
                if (orderStmt.executeUpdate() == 0) {
                    conn.rollback();
                    return -1;
                }

                try ( ResultSet rs = orderStmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        orderId = rs.getInt(1);
                    } else {
                        conn.rollback();
                        return -1;
                    }
                }

                for (CartItem item : cartItems) {
                    // Thêm order_item
                    itemStmt.setInt(1, orderId);
                    itemStmt.setInt(2, item.getProductId());
                    itemStmt.setInt(3, item.getQuantity());
                    itemStmt.setDouble(4, item.getProduct().getPrice());
                    itemStmt.executeUpdate();

                    // Update tồn kho, chỉ thành công nếu đủ stock ngay tại DB
                    stockStmt.setInt(1, item.getQuantity());
                    stockStmt.setInt(2, item.getProductId());
                    stockStmt.setInt(3, item.getQuantity());
                    if (stockStmt.executeUpdate() == 0) {
                        conn.rollback();
                        return -1;
                    }
                }

                conn.commit();
                return orderId;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

}
