package dao;

import model.CartItem;
import model.Product;
import util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    public boolean addToCart(CartItem cartItem) throws SQLException, ClassNotFoundException {
        // Check if item already exists in cart
        CartItem existingItem = getCartItem(cartItem.getUserId(), cartItem.getProductId());

        if (existingItem != null) {
            // Update quantity
            return updateCartItemQuantity(existingItem.getCartItemId(),
                    existingItem.getQuantity() + cartItem.getQuantity());
        } else {
            // Add new item
            String sql = "INSERT INTO cart_items (user_id, product_id, quantity) VALUES (?, ?, ?)";
            try (Connection conn = DatabaseConnection.getConnection();
                    PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setInt(1, cartItem.getUserId());
                stmt.setInt(2, cartItem.getProductId());
                stmt.setInt(3, cartItem.getQuantity());

                return stmt.executeUpdate() > 0;
            } catch (SQLException e) {
                e.printStackTrace();
                return false;
            }
        }
    }

    public List<CartItem> getCartItems(int userId) throws SQLException, ClassNotFoundException {
        List<CartItem> cartItems = new ArrayList<>();
        String sql = "SELECT ci.*, p.name, p.price, p.image FROM cart_items ci " +
                "JOIN products p ON ci.product_id = p.product_id WHERE ci.user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                CartItem cartItem = new CartItem();
                cartItem.setCartItemId(rs.getInt("cart_item_id"));
                cartItem.setUserId(rs.getInt("user_id"));
                cartItem.setProductId(rs.getInt("product_id"));
                cartItem.setQuantity(rs.getInt("quantity"));

                Product product = new Product();
                product.setProductId(rs.getInt("product_id"));
                product.setName(rs.getString("name"));
                product.setPrice(rs.getDouble("price"));
                product.setImage(rs.getString("image"));
                cartItem.setProduct(product);

                cartItems.add(cartItem);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cartItems;
    }

    public CartItem getCartItem(int userId, int productId) throws SQLException, ClassNotFoundException {
        String sql = "SELECT * FROM cart_items WHERE user_id = ? AND product_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setInt(2, productId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                CartItem cartItem = new CartItem();
                cartItem.setCartItemId(rs.getInt("cart_item_id"));
                cartItem.setUserId(rs.getInt("user_id"));
                cartItem.setProductId(rs.getInt("product_id"));
                cartItem.setQuantity(rs.getInt("quantity"));
                return cartItem;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateCartItemQuantity(int cartItemId, int quantity) throws SQLException, ClassNotFoundException {
        if (quantity <= 0) {
            return removeCartItem(cartItemId);
        }

        String sql = "UPDATE cart_items SET quantity = ? WHERE cart_item_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, quantity);
            stmt.setInt(2, cartItemId);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean removeCartItem(int cartItemId) throws SQLException, ClassNotFoundException {
        String sql = "DELETE FROM cart_items WHERE cart_item_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, cartItemId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean clearCart(int userId) throws SQLException, ClassNotFoundException {
        String sql = "DELETE FROM cart_items WHERE user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            return stmt.executeUpdate() >= 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public double getCartTotal(int userId)  throws SQLException, ClassNotFoundException{
        String sql = "SELECT SUM(ci.quantity * p.price) as total FROM cart_items ci " +
                "JOIN products p ON ci.product_id = p.product_id WHERE ci.user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }
}
