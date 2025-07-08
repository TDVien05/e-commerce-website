<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn hàng #${order.orderId} - BaloShop</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-content">
        <div class="container">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
                <h2>Chi tiết đơn hàng #${order.orderId}</h2>
                <a href="order" class="btn">← Quay lại danh sách đơn hàng</a>
            </div>
            
            <!-- Order Info -->
            <div style="background: white; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); padding: 2rem; margin-bottom: 2rem;">
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 2rem;">
                    <div>
                        <h3 style="margin-bottom: 1rem; color: #333;">Thông tin đơn hàng</h3>
                        <div style="color: #6c757d; line-height: 1.8;">
                            <div><strong>Mã đơn hàng:</strong> #${order.orderId}</div>
                            <div><strong>Ngày đặt:</strong> <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></div>
                            <div><strong>Trạng thái:</strong> 
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
                        </div>
                    </div>
                    
                    <div>
                        <h3 style="margin-bottom: 1rem; color: #333;">Thông tin giao hàng</h3>
                        <div style="color: #6c757d; line-height: 1.8;">
                            <div><strong>Người nhận:</strong> ${sessionScope.user.fullName}</div>
                            <div><strong>Số điện thoại:</strong> ${sessionScope.user.phone}</div>
                            <div><strong>Địa chỉ:</strong> ${order.shippingAddress}</div>
                        </div>
                    </div>
                    
                    <div>
                        <h3 style="margin-bottom: 1rem; color: #333;">Thanh toán</h3>
                        <div style="color: #6c757d; line-height: 1.8;">
                            <div><strong>Phương thức:</strong> 
                                <c:choose>
                                    <c:when test="${order.paymentMethod == 'cod'}">Thanh toán khi nhận hàng</c:when>
                                    <c:when test="${order.paymentMethod == 'bank'}">Chuyển khoản ngân hàng</c:when>
                                    <c:when test="${order.paymentMethod == 'momo'}">Ví MoMo</c:when>
                                    <c:when test="${order.paymentMethod == 'zalopay'}">ZaloPay</c:when>
                                    <c:otherwise>${order.paymentMethod}</c:otherwise>
                                </c:choose>
                            </div>
                            <div><strong>Tổng tiền:</strong> 
                                <span style="color: #e74c3c; font-weight: bold; font-size: 1.1rem;">
                                    <fmt:formatNumber value="${order.totalAmount}" type="currency" 
                                                    currencySymbol="₫" groupingUsed="true"/>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Order Items -->
            <div style="background: white; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); padding: 2rem;">
                <h3 style="margin-bottom: 1.5rem; color: #333;">Sản phẩm đã đặt</h3>
                
                <table class="cart-table">
                    <thead>
                        <tr>
                            <th>Sản phẩm</th>
                            <th>Đơn giá</th>
                            <th>Số lượng</th>
                            <th>Thành tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${orderItems}">
                            <tr>
                                <td>
                                    <div style="display: flex; align-items: center; gap: 1rem;">
                                        <img src="images/${item.product.image}" alt="${item.product.name}" 
                                             class="cart-item-image" onerror="this.src='images/default-balo.jpg'">
                                        <div>
                                            <h4>${item.product.name}</h4>
                                            <a href="product?action=detail&id=${item.productId}" 
                                               style="color: #667eea; text-decoration: none; font-size: 0.9rem;">
                                                Xem sản phẩm
                                            </a>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <fmt:formatNumber value="${item.price}" type="currency" 
                                                    currencySymbol="₫" groupingUsed="true"/>
                                </td>
                                <td>${item.quantity}</td>
                                <td style="font-weight: bold; color: #e74c3c;">
                                    <fmt:formatNumber value="${item.totalPrice}" type="currency" 
                                                    currencySymbol="₫" groupingUsed="true"/>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                
                <div style="text-align: right; margin-top: 2rem; padding-top: 1rem; border-top: 1px solid #dee2e6;">
                    <div style="font-size: 1.2rem; font-weight: bold;">
                        Tổng cộng: 
                        <span style="color: #e74c3c;">
                            <fmt:formatNumber value="${order.totalAmount}" type="currency" 
                                            currencySymbol="₫" groupingUsed="true"/>
                        </span>
                    </div>
                </div>
            </div>
            
            <!-- Order Status Timeline -->
            <div style="background: white; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); padding: 2rem; margin-top: 2rem;">
                <h3 style="margin-bottom: 1.5rem; color: #333;">Trạng thái đơn hàng</h3>
                
                <div style="position: relative;">
                    <div style="display: flex; justify-content: space-between; position: relative;">
                        <!-- Timeline line -->
                        <div style="position: absolute; top: 20px; left: 0; right: 0; height: 2px; background: #dee2e6; z-index: 1;"></div>
                        
                        <!-- Status points -->
                        <div style="display: flex; justify-content: space-between; width: 100%; position: relative; z-index: 2;">
                            <div style="text-align: center; background: white; padding: 0 1rem;">
                                <div style="width: 40px; height: 40px; border-radius: 50%; background: #28a745; margin: 0 auto 0.5rem; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold;">✓</div>
                                <div style="font-size: 0.9rem; color: #28a745; font-weight: 500;">Đặt hàng</div>
                            </div>
                            
                            <div style="text-align: center; background: white; padding: 0 1rem;">
                                <div style="width: 40px; height: 40px; border-radius: 50%; background: ${order.status == 'pending' ? '#ffc107' : '#28a745'}; margin: 0 auto 0.5rem; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold;">
                                    ${order.status == 'pending' ? '⏳' : '✓'}
                                </div>
                                <div style="font-size: 0.9rem; color: ${order.status == 'pending' ? '#ffc107' : '#28a745'}; font-weight: 500;">Xác nhận</div>
                            </div>
                            
                            <div style="text-align: center; background: white; padding: 0 1rem;">
                                <div style="width: 40px; height: 40px; border-radius: 50%; background: ${order.status == 'shipped' || order.status == 'delivered' ? '#28a745' : '#dee2e6'}; margin: 0 auto 0.5rem; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold;">
                                    ${order.status == 'shipped' || order.status == 'delivered' ? '✓' : '📦'}
                                </div>
                                <div style="font-size: 0.9rem; color: ${order.status == 'shipped' || order.status == 'delivered' ? '#28a745' : '#6c757d'}; font-weight: 500;">Giao hàng</div>
                            </div>
                            
                            <div style="text-align: center; background: white; padding: 0 1rem;">
                                <div style="width: 40px; height: 40px; border-radius: 50%; background: ${order.status == 'delivered' ? '#28a745' : '#dee2e6'}; margin: 0 auto 0.5rem; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold;">
                                    ${order.status == 'delivered' ? '✓' : '🏠'}
                                </div>
                                <div style="font-size: 0.9rem; color: ${order.status == 'delivered' ? '#28a745' : '#6c757d'}; font-weight: 500;">Hoàn thành</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
    
    <style>
        @media (max-width: 768px) {
            .container > div:nth-child(2) > div {
                grid-template-columns: 1fr !important;
            }
        }
    </style>
</body>
</html>
