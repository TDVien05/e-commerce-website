<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đơn hàng của tôi - BaloShop</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-content">
        <div class="container">
            <h2 style="margin-bottom: 2rem;">Đơn hàng của tôi</h2>
            
            <c:choose>
                <c:when test="${empty orders}">
                    <div style="text-align: center; padding: 3rem; background: white; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
                        <h3>Bạn chưa có đơn hàng nào</h3>
                        <p style="margin: 1rem 0;">Hãy bắt đầu mua sắm ngay!</p>
                        <a href="product" class="btn btn-primary">Mua sắm ngay</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="display: grid; gap: 1.5rem;">
                        <c:forEach var="order" items="${orders}">
                            <div style="background: white; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); padding: 2rem;">
                                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; border-bottom: 1px solid #dee2e6; padding-bottom: 1rem;">
                                    <div>
                                        <h3 style="margin-bottom: 0.5rem;">Đơn hàng #${order.orderId}</h3>
                                        <div style="color: #6c757d; font-size: 0.9rem;">
                                            Đặt ngày: <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
                                        </div>
                                    </div>
                                    <div style="text-align: right;">
                                        <div style="margin-bottom: 0.5rem;">
                                            <span class="order-status status-${order.status}">
                                                <c:choose>
                                                    <c:when test="${order.status == 'pending'}">Chờ xử lý</c:when>
                                                    <c:when test="${order.status == 'processing'}">Đang xử lý</c:when>
                                                    <c:when test="${order.status == 'shipped'}">Đã giao</c:when>
                                                    <c:when test="${order.status == 'delivered'}">Hoàn thành</c:when>
                                                    <c:when test="${order.status == 'cancelled'}">Đã hủy</c:when>
                                                    <c:otherwise>${order.status}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <div style="font-weight: bold; color: #e74c3c; font-size: 1.1rem;">
                                            <fmt:formatNumber value="${order.totalAmount}" type="currency" 
                                                            currencySymbol="₫" groupingUsed="true"/>
                                        </div>
                                    </div>
                                </div>
                                
                                <div style="margin-bottom: 1rem;">
                                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; font-size: 0.9rem; color: #6c757d;">
                                        <div>
                                            <strong>Địa chỉ giao hàng:</strong><br>
                                            ${order.shippingAddress}
                                        </div>
                                        <div>
                                            <strong>Phương thức thanh toán:</strong><br>
                                            <c:choose>
                                                <c:when test="${order.paymentMethod == 'cod'}">Thanh toán khi nhận hàng</c:when>
                                                <c:when test="${order.paymentMethod == 'bank'}">Chuyển khoản ngân hàng</c:when>
                                                <c:when test="${order.paymentMethod == 'momo'}">Ví MoMo</c:when>
                                                <c:when test="${order.paymentMethod == 'zalopay'}">ZaloPay</c:when>
                                                <c:otherwise>${order.paymentMethod}</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                                
                                <div style="text-align: right;">
                                    <a href="order?action=detail&id=${order.orderId}" class="btn btn-primary">
                                        Xem chi tiết
                                    </a>
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
