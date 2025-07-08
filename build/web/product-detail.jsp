<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.name} - BaloShop</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-content">
        <div class="container">
            <c:if test="${not empty error}">
                <div class="alert alert-error">${error}</div>
            </c:if>
            
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 3rem; margin-bottom: 2rem;">
                <!-- Product Image -->
                <div>
                    <img src="images/${product.image}" alt="${product.name}" 
                         style="width: 100%; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);"
                         onerror="this.src='images/default-balo.jpg'">
                </div>
                
                <!-- Product Info -->
                <div>
                    <h1 style="margin-bottom: 1rem; color: #333;">${product.name}</h1>
                    
                    <div style="margin-bottom: 1rem;">
                        <span style="background: #f8f9fa; padding: 0.25rem 0.75rem; border-radius: 15px; font-size: 0.9rem; color: #6c757d;">
                            ${product.category}
                        </span>
                        <c:if test="${not empty product.brand}">
                            <span style="background: #f8f9fa; padding: 0.25rem 0.75rem; border-radius: 15px; font-size: 0.9rem; color: #6c757d; margin-left: 0.5rem;">
                                ${product.brand}
                            </span>
                        </c:if>
                    </div>
                    
                    <div style="font-size: 2rem; font-weight: bold; color: #e74c3c; margin-bottom: 1rem;">
                        <fmt:formatNumber value="${product.price}" type="currency" 
                                        currencySymbol="₫" groupingUsed="true"/>
                    </div>
                    
                    <div style="margin-bottom: 1rem;">
                        <c:choose>
                            <c:when test="${product.stock > 0}">
                                <span style="color: #28a745; font-weight: 500;">
                                    ✓ Còn hàng (${product.stock} sản phẩm)
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span style="color: #dc3545; font-weight: 500;">
                                    ✗ Hết hàng
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <c:if test="${sessionScope.user != null && product.stock > 0}">
                        <form action="cart" method="post" style="margin-bottom: 2rem;">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="productId" value="${product.productId}">
                            
                            <div style="display: flex; gap: 1rem; align-items: center; margin-bottom: 1rem;">
                                <label for="quantity" style="font-weight: 500;">Số lượng:</label>
                                <input type="number" id="quantity" name="quantity" value="1" 
                                       min="1" max="${product.stock}" class="quantity-input">
                            </div>
                            
                            <button type="submit" class="btn btn-primary" style="padding: 1rem 2rem; font-size: 1.1rem;">
                                🛒 Thêm vào giỏ hàng
                            </button>
                        </form>
                    </c:if>
                    
                    <c:if test="${sessionScope.user == null}">
                        <div style="margin-bottom: 2rem;">
                            <a href="user?action=login" class="btn btn-primary" style="padding: 1rem 2rem; font-size: 1.1rem;">
                                Đăng nhập để mua hàng
                            </a>
                        </div>
                    </c:if>
                    
                    <div style="background: #f8f9fa; padding: 1.5rem; border-radius: 10px;">
                        <h3 style="margin-bottom: 1rem; color: #333;">Thông tin sản phẩm</h3>
                        <ul style="list-style: none; color: #6c757d;">
                            <li style="margin-bottom: 0.5rem;">🚚 Giao hàng miễn phí cho đơn hàng trên 500.000₫</li>
                            <li style="margin-bottom: 0.5rem;">🔒 Bảo hành 12 tháng</li>
                            <li style="margin-bottom: 0.5rem;">↩️ Đổi trả trong 7 ngày</li>
                            <li style="margin-bottom: 0.5rem;">💳 Thanh toán khi nhận hàng</li>
                        </ul>
                    </div>
                </div>
            </div>
            
            <!-- Product Description -->
            <div style="background: white; padding: 2rem; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
                <h3 style="margin-bottom: 1rem; color: #333;">Mô tả sản phẩm</h3>
                <div style="line-height: 1.8; color: #555;">
                    ${product.description}
                </div>
            </div>
            
            <!-- Back to products -->
            <div style="margin-top: 2rem; text-align: center;">
                <a href="product" class="btn">← Quay lại danh sách sản phẩm</a>
            </div>
        </div>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
    
    <style>
        @media (max-width: 768px) {
            .container > div:first-child {
                grid-template-columns: 1fr !important;
                gap: 2rem !important;
            }
        }
    </style>
</body>
</html>
