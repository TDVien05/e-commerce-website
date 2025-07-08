<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng - BaloShop</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-content">
        <div class="container">
            <h2 style="margin-bottom: 2rem;">Giỏ hàng của bạn</h2>
            
            <c:choose>
                <c:when test="${empty cartItems}">
                    <div style="text-align: center; padding: 3rem; background: white; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
                        <h3>Giỏ hàng trống</h3>
                        <p style="margin: 1rem 0;">Hãy thêm sản phẩm vào giỏ hàng để tiếp tục mua sắm.</p>
                        <a href="product" class="btn btn-primary">Tiếp tục mua sắm</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <form action="cart" method="post">
                        <input type="hidden" name="action" value="update">
                        
                        <table class="cart-table">
                            <thead>
                                <tr>
                                    <th>Sản phẩm</th>
                                    <th>Đơn giá</th>
                                    <th>Số lượng</th>
                                    <th>Thành tiền</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${cartItems}">
                                    <tr>
                                        <td>
                                            <div style="display: flex; align-items: center; gap: 1rem;">
                                                <img src="images/${item.product.image}" alt="${item.product.name}" 
                                                     class="cart-item-image" onerror="this.src='images/default-balo.jpg'">
                                                <div>
                                                    <h4>${item.product.name}</h4>
                                                    <a href="product?action=detail&id=${item.productId}" 
                                                       style="color: #667eea; text-decoration: none; font-size: 0.9rem;">
                                                        Xem chi tiết
                                                    </a>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <fmt:formatNumber value="${item.product.price}" type="currency" 
                                                            currencySymbol="₫" groupingUsed="true"/>
                                        </td>
                                        <td>
                                            <input type="hidden" name="cartItemId" value="${item.cartItemId}">
                                            <input type="number" name="quantity" value="${item.quantity}" 
                                                   min="1" class="quantity-input">
                                        </td>
                                        <td style="font-weight: bold; color: #e74c3c;">
                                            <fmt:formatNumber value="${item.totalPrice}" type="currency" 
                                                            currencySymbol="₫" groupingUsed="true"/>
                                        </td>
                                        <td>
                                            <a href="cart?action=remove&cartItemId=${item.cartItemId}" 
                                               class="btn btn-danger"
                                               onclick="return confirm('Bạn có muốn xóa sản phẩm này khỏi giỏ hàng?')">
                                                Xóa
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        
                        <div style="display: flex; justify-content: space-between; align-items: center; margin: 2rem 0;">
                            <button type="submit" class="btn btn-warning">Cập nhật giỏ hàng</button>
                            <a href="product" class="btn">Tiếp tục mua sắm</a>
                        </div>
                    </form>
                    
                    <div class="cart-total">
                        <h3>Tổng cộng</h3>
                        <div class="total-amount">
                            <fmt:formatNumber value="${totalAmount}" type="currency" 
                                            currencySymbol="₫" groupingUsed="true"/>
                        </div>
                        <div style="margin-top: 1rem;">
                            <a href="order?action=checkout" class="btn btn-primary" style="padding: 1rem 2rem; font-size: 1.1rem;">
                                Tiến hành thanh toán
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
    
    <script>
        // Auto-submit on quantity change
        document.querySelectorAll('.quantity-input').forEach(input => {
            input.addEventListener('change', function() {
                if (this.value < 1) {
                    this.value = 1;
                }
            });
        });
    </script>
</body>
</html>
