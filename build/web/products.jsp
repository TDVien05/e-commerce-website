<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Sản phẩm - BaloShop</title>
        <link rel="stylesheet" href="css/style.css">
        <style>
            .pagination {
                margin-top: 2rem;
                text-align: center;
            }
            .pagination a {
                display: inline-block;
                margin: 0 5px;
                padding: 8px 12px;
                background: #eee;
                color: #333;
                text-decoration: none;
                border-radius: 4px;
            }
            .pagination a.active {
                background: #007bff;
                color: #fff;
            }
            .product-card {
                width: 300px; /* hoặc linh hoạt % nếu responsive */
                border: 1px solid #ddd;
                border-radius: 8px;
                overflow: hidden;
                background: #fff;
            }

            .product-image {
                width: 100%;
                height: 300px;   /* hoặc chiều cao bạn muốn */
                object-fit: cover;  /* Ảnh tự căn đầy mà không méo */
                display: block;
            }
        </style>
    </head>
    <body>
        <%@ include file="includes/header.jsp" %>

        <div class="main-content">
            <div class="container">
                <h2 style="margin-bottom: 2rem;">
                    <c:choose>
                        <c:when test="${not empty currentCategory}">
                            Danh mục: ${currentCategory}
                        </c:when>
                        <c:when test="${not empty searchKeyword}">
                            Kết quả tìm kiếm: "${searchKeyword}"
                        </c:when>
                        <c:otherwise>
                            Tất cả sản phẩm
                        </c:otherwise>
                    </c:choose>
                </h2>

                <c:choose>
                    <c:when test="${empty products}">
                        <div style="text-align: center; padding: 3rem;">
                            <h3>Không tìm thấy sản phẩm nào</h3>
                            <p>Vui lòng thử tìm kiếm với từ khóa khác hoặc xem tất cả sản phẩm.</p>
                            <a href="product" class="btn btn-primary">Xem tất cả sản phẩm</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="product-grid">
                            <c:forEach var="product" items="${products}">
                                <div class="product-card">
                                    <img src="images/${product.image}" alt="${product.name}"
                                         class="product-image" loading="lazy"
                                         decoding="async" width="300" height="300"
                                         onerror="this.src='images/default-balo.jpg'">
                                    <div class="product-info">
                                        <h3 class="product-name">${product.name}</h3>
                                        <div class="product-price">
                                            <fmt:formatNumber value="${product.price}" type="currency" 
                                                              currencySymbol="₫" groupingUsed="true"/>
                                        </div>
                                        <p class="product-description">
                                            <c:choose>
                                                <c:when test="${product.description.length() > 100}">
                                                    ${product.description.substring(0, 100)}...
                                                </c:when>
                                                <c:otherwise>
                                                    ${product.description}
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                        <div style="display: flex; gap: 0.5rem; margin-top: 1rem;">
                                            <a href="product?action=detail&id=${product.productId}" 
                                               class="btn btn-primary" style="flex: 1; text-align: center;">
                                                Xem chi tiết
                                            </a>
                                            <c:if test="${sessionScope.user != null && product.stock > 0}">
                                                <form action="cart" method="post" style="flex: 1;">
                                                    <input type="hidden" name="action" value="add">
                                                    <input type="hidden" name="productId" value="${product.productId}">
                                                    <input type="hidden" name="quantity" value="1">
                                                    <button type="submit" class="btn" style="width: 100%;">
                                                        Thêm vào giỏ
                                                    </button>
                                                </form>
                                            </c:if>
                                        </div>
                                        <div style="margin-top: 0.5rem; text-align: center;">
                                            <c:choose>
                                                <c:when test="${product.stock > 0}">
                                                    <span style="color: #28a745; font-size: 0.9rem;">
                                                        Còn ${product.stock} sản phẩm
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: #dc3545; font-size: 0.9rem;">
                                                        Hết hàng
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>


                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <%@ include file="includes/footer.jsp" %>
    </body>
</html>
