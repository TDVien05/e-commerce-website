<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.*" %>
<%@ page import="dao.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BaloShop - Cửa hàng balo chất lượng cao</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@ include file="includes/header.jsp" %>

    
    <!-- Hero Section -->
    <section class="hero">
        <div class="container">
            <h2>Chào mừng đến với BaloShop</h2>
            <p>Khám phá bộ sưu tập balo chất lượng cao, thiết kế hiện đại</p>
            <a href="product" class="btn btn-primary">Xem sản phẩm</a>
        </div>
    </section>
    
    <!-- Features Section -->
    <section class="features">
        <div class="container">
            <div class="features-grid">
                <div class="feature-item">
                    <div class="feature-icon">🎒</div>
                    <h3 class="feature-title">Sản phẩm chất lượng</h3>
                    <p>Balo được làm từ chất liệu cao cấp, bền bỉ theo thời gian</p>
                </div>
                <div class="feature-item">
                    <div class="feature-icon">🚚</div>
                    <h3 class="feature-title">Giao hàng nhanh</h3>
                    <p>Giao hàng tận nơi trong 24-48h, miễn phí với đơn hàng trên 500k</p>
                </div>
                <div class="feature-item">
                    <div class="feature-icon">💝</div>
                    <h3 class="feature-title">Ưu đãi hấp dẫn</h3>
                    <p>Nhiều chương trình khuyến mãi và ưu đãi đặc biệt</p>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Featured Products -->
    <section class="main-content">
        <div class="container">
            <h2 style="text-align: center; margin-bottom: 2rem;">Sản phẩm nổi bật</h2>
            
            <%
                ProductDAO productDAO = new ProductDAO();
                List<Product> featuredProducts = productDAO.getAllProducts();
                if (featuredProducts.size() > 8) {
                    featuredProducts = featuredProducts.subList(0, 8);
                }
                request.setAttribute("featuredProducts", featuredProducts);
            %>
            
            <div class="product-grid">
                <c:forEach var="product" items="${featuredProducts}">
                    <div class="product-card">
                        <img src="images/${product.image}" alt="${product.name}" class="product-image" onerror="this.src='images/default-balo.jpg'">
                        <div class="product-info">
                            <h3 class="product-name">${product.name}</h3>
                            <div class="product-price">₫${product.price}</div>
                            <p class="product-description">${product.description}</p>
                            <a href="product?action=detail&id=${product.productId}" class="btn btn-primary">Xem chi tiết</a>
                        </div>
                    </div>
                </c:forEach>
            </div>
            
            <div style="text-align: center; margin-top: 2rem;">
                <a href="product" class="btn btn-primary">Xem tất cả sản phẩm</a>
            </div>
        </div>
    </section>
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>
