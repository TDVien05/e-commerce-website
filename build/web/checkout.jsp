<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán - BaloShop</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-content">
        <div class="container">
            <h2 style="margin-bottom: 2rem;">Thanh toán đơn hàng</h2>
            
            <c:if test="${not empty error}">
                <div class="alert alert-error">${error}</div>
            </c:if>
            
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 3rem;">
                <!-- Order Form -->
                <div>
                    <div style="background: white; padding: 2rem; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
                        <h3 style="margin-bottom: 1.5rem;">Thông tin giao hàng</h3>
                        
                        <form action="order" method="post">
                            <input type="hidden" name="action" value="place">
                            
                            <div class="form-group">
                                <label for="customerName" class="form-label">Họ và tên:</label>
                                <input type="text" id="customerName" class="form-input" 
                                       value="${sessionScope.user.fullName}" readonly>
                            </div>
                            
                            <div class="form-group">
                                <label for="customerEmail" class="form-label">Email:</label>
                                <input type="email" id="customerEmail" class="form-input" 
                                       value="${sessionScope.user.email}" readonly>
                            </div>
                            
                            <div class="form-group">
                                <label for="customerPhone" class="form-label">Số điện thoại:</label>
                                <input type="tel" id="customerPhone" class="form-input" 
                                       value="${sessionScope.user.phone}" readonly>
                            </div>
                            
                            <div class="form-group">
                                <label for="shippingAddress" class="form-label">Địa chỉ giao hàng: <span style="color: red;">*</span></label>
                                <textarea id="shippingAddress" name="shippingAddress" class="form-input form-textarea" 
                                          required placeholder="Nhập địa chỉ giao hàng chi tiết...">${sessionScope.user.address}</textarea>
                            </div>
                            
                            <div class="form-group">
                                <label for="paymentMethod" class="form-label">Phương thức thanh toán: <span style="color: red;">*</span></label>
                                <select id="paymentMethod" name="paymentMethod" class="form-input" required>
                                    <option value="">Chọn phương thức thanh toán</option>
                                    <option value="cod">Thanh toán khi nhận hàng (COD)</option>
                                    <option value="bank">Chuyển khoản ngân hàng</option>
                                    <option value="momo">Ví MoMo</option>
                                    <option value="zalopay">ZaloPay</option>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label for="note" class="form-label">Ghi chú:</label>
                                <textarea id="note" name="note" class="form-input form-textarea" 
                                          placeholder="Ghi chú đặc biệt cho đơn hàng..."></textarea>
                            </div>
                            
                            <button type="submit" class="btn btn-primary" style="width: 100%; padding: 1rem; font-size: 1.1rem;">
                                Đặt hàng
                            </button>
                        </form>
                    </div>
                </div>
                
                <!-- Order Summary -->
                <div>
                    <div style="background: white; padding: 2rem; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
                        <h3 style="margin-bottom: 1.5rem;">Đơn hàng của bạn</h3>
                        
                        <div style="border-bottom: 1px solid #dee2e6; padding-bottom: 1rem; margin-bottom: 1rem;">
                            <c:forEach var="item" items="${cartItems}">
                                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                                    <div style="display: flex; align-items: center; gap: 1rem;">
                                        <img src="images/${item.product.image}" alt="${item.product.name}" 
                                             style="width: 50px; height: 50px; object-fit: cover; border-radius: 5px;"
                                             onerror="this.src='images/default-balo.jpg'">
                                        <div>
                                            <div style="font-weight: 500;">${item.product.name}</div>
                                            <div style="color: #6c757d; font-size: 0.9rem;">Số lượng: ${item.quantity}</div>
                                        </div>
                                    </div>
                                    <div style="font-weight: bold; color: #e74c3c;">
                                        <fmt:formatNumber value="${item.totalPrice}" type="currency" 
                                                        currencySymbol="₫" groupingUsed="true"/>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        
                        <div style="margin-bottom: 1rem;">
                            <div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem;">
                                <span>Tạm tính:</span>
                                <span><fmt:formatNumber value="${totalAmount}" type="currency" 
                                                      currencySymbol="₫" groupingUsed="true"/></span>
                            </div>
                            <div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem;">
                                <span>Phí vận chuyển:</span>
                                <span>
                                    <c:choose>
                                        <c:when test="${totalAmount >= 500000}">
                                            <span style="color: #28a745;">Miễn phí</span>
                                        </c:when>
                                        <c:otherwise>
                                            30.000₫
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                        
                        <div style="border-top: 1px solid #dee2e6; padding-top: 1rem;">
                            <div style="display: flex; justify-content: space-between; font-size: 1.2rem; font-weight: bold;">
                                <span>Tổng cộng:</span>
                                <span style="color: #e74c3c;">
                                    <c:choose>
                                        <c:when test="${totalAmount >= 500000}">
                                            <fmt:formatNumber value="${totalAmount}" type="currency" 
                                                            currencySymbol="₫" groupingUsed="true"/>
                                        </c:when>
                                        <c:otherwise>
                                            <fmt:formatNumber value="${totalAmount + 30000}" type="currency" 
                                                            currencySymbol="₫" groupingUsed="true"/>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                        
                        <c:if test="${totalAmount < 500000}">
                            <div style="background: #fff3cd; color: #856404; padding: 1rem; border-radius: 5px; margin-top: 1rem; font-size: 0.9rem;">
                                💡 Mua thêm <fmt:formatNumber value="${500000 - totalAmount}" type="currency" 
                                                            currencySymbol="₫" groupingUsed="true"/> 
                                để được miễn phí vận chuyển!
                            </div>
                        </c:if>
                    </div>
                    
                    <div style="background: #f8f9fa; padding: 1.5rem; border-radius: 10px; margin-top: 1rem;">
                        <h4 style="margin-bottom: 1rem; color: #333;">Chính sách</h4>
                        <ul style="list-style: none; color: #6c757d; font-size: 0.9rem;">
                            <li style="margin-bottom: 0.5rem;">✓ Đổi trả trong 7 ngày</li>
                            <li style="margin-bottom: 0.5rem;">✓ Bảo hành 12 tháng</li>
                            <li style="margin-bottom: 0.5rem;">✓ Giao hàng 2-3 ngày</li>
                            <li style="margin-bottom: 0.5rem;">✓ Hỗ trợ 24/7</li>
                        </ul>
                    </div>
                </div>
            </div>
            
            <div style="text-align: center; margin-top: 2rem;">
                <a href="cart" class="btn">← Quay lại giỏ hàng</a>
            </div>
        </div>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
    
    <style>
        @media (max-width: 768px) {
            .container > div:first-child > div {
                grid-template-columns: 1fr !important;
                gap: 2rem !important;
            }
        }
    </style>
</body>
</html>
