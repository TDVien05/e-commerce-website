<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- FontAwesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<!-- CSS Profile Form ĐẸP -->
<style>
    #profileForm {
        display: none;
        position: absolute;
        right: 20px;
        top: 80px;
        background: #ffffff;
        border: 1px solid #ddd;
        border-radius: 10px;
        box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        padding: 20px;
        width: 320px;
        z-index: 999;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }
    #profileForm h3 {
        margin: 0 0 15px 0;
        font-size: 20px;
        text-align: center;
        color: #333;
    }
    #profileForm label {
        display: block;
        font-weight: 600;
        margin: 8px 0 4px;
        font-size: 14px;
        color: #555;
    }
    #profileForm input {
        width: 100%;
        padding: 8px 10px;
        border: 1px solid #ccc;
        border-radius: 5px;
        font-size: 14px;
        background: #f9f9f9;
    }
    #profileForm input:read-only {
        background: #f1f1f1;
    }
    #profileForm .btn-group {
        display: flex;
        justify-content: space-between;
        margin-top: 15px;
    }
    #profileForm .btn-group button {
        flex: 1;
        text-align: center;
        padding: 10px 12px;
        margin: 0 5px;
        border: none;
        border-radius: 5px;
        font-weight: bold;
        cursor: pointer;
        transition: all 0.2s ease;
    }
    #profileForm .btn-close {
        background: #555;
        color: #fff;
    }
    #profileForm .btn-close:hover {
        background: #333;
    }
    #profileForm .btn-delete {
        background: #e74c3c;
        color: #fff;
    }
    #profileForm .btn-delete:hover {
        background: #c0392b;
    }
    #profileForm .message {
        display: block;
        margin-top: 10px;
        color: red;
        font-weight: bold;
        text-align: center;
    }
</style>

<header class="header">
    <div class="container">
        <div class="header-content">
            <div class="logo">
                <h1><a href="index.jsp" style="color: white; text-decoration: none;">BaloShop</a></h1>
            </div>

            <nav class="nav">
                <ul>
                    <li><a href="index.jsp">Trang chủ</a></li>
                    <li><a href="product">Sản phẩm</a></li>
                        <c:if test="${sessionScope.user != null}">
                        <li><a href="cart">Giỏ hàng</a></li>
                        <li><a href="order">Đơn hàng</a></li>
                        </c:if>
                </ul>
            </nav>

            <div class="user-info">
                <c:choose>
                    <c:when test="${sessionScope.user != null}">
                        <span>Xin chào, ${sessionScope.user.fullName}!</span>
                        <a href="#" id="profileIcon" style="margin-left: 10px; color: white;">
                            <i class="fas fa-user-circle fa-2x"></i>
                        </a>
                        <a href="user?action=logout" class="btn btn-warning">Đăng xuất</a>
                    </c:when>
                    <c:otherwise>
                        <a href="user?action=login" class="btn">Đăng nhập</a>
                        <a href="user?action=register" class="btn btn-primary">Đăng ký</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</header>

<!-- Search Bar -->
<div class="search-bar">
    <div class="container">
        <form action="product" method="get" class="search-form">
            <input type="hidden" name="action" value="search">
            <input type="text" name="keyword" class="search-input" 
                   placeholder="Tìm kiếm balo..." value="${param.keyword}">
            <button type="submit" class="btn btn-primary">Tìm kiếm</button>
        </form>
    </div>
</div>

<!-- Categories -->
<div class="categories">
    <div class="container">
        <div class="category-list">
            <a href="product" class="category-link ${empty param.category ? 'active' : ''}">Tất cả</a>
            <a href="product?action=category&category=laptop" 
               class="category-link ${'laptop'.equals(param.category) ? 'active' : ''}">Balo laptop</a>
            <a href="product?action=category&category=school" 
               class="category-link ${'school'.equals(param.category) ? 'active' : ''}">Balo học sinh</a>
            <a href="product?action=category&category=travel" 
               class="category-link ${'travel'.equals(param.category) ? 'active' : ''}">Balo du lịch</a>
            <a href="product?action=category&category=business" 
               class="category-link ${'business'.equals(param.category) ? 'active' : ''}">Balo công sở</a>
            <a href="product?action=category&category=sport" 
               class="category-link ${'sport'.equals(param.category) ? 'active' : ''}">Balo thể thao</a>
        </div>
    </div>
</div>

<!-- Profile Form -->
<c:if test="${sessionScope.user != null}">
    <div id="profileForm">
        <h3>Thông tin tài khoản</h3>
        <form method="get" action="user" onsubmit="return confirm('Bạn có chắc chắn muốn xóa tài khoản không?');">
            <label>Email:</label>
            <input type="text" value="${sessionScope.user.email}" readonly>

            <label>Họ tên:</label>
            <input type="text" value="${sessionScope.user.fullName}" readonly>

            <label>SĐT:</label>
            <input type="text" value="${sessionScope.user.phone}" readonly>

            <label>Địa chỉ:</label>
            <input type="text" value="${sessionScope.user.address}" readonly>

            <label>Role:</label>
            <input type="text" value="${sessionScope.user.role}" readonly>

            <!-- Hidden input cho action & id -->
            <input type="hidden" name="action" value="deleteAccount">
            <input type="hidden" name="id" value="${sessionScope.user.userId}">

            <div class="btn-group">
                <button type="button" class="btn-close" onclick="document.getElementById('profileForm').style.display = 'none'">Đóng</button>
                <button type="submit" class="btn-delete">Xóa tài khoản</button>
            </div>
            <span class="message">${requestScope.MESSAGE}</span>
        </form>
    </div>

    <script>
        document.getElementById('profileIcon').addEventListener('click', function (event) {
            event.preventDefault();
            var form = document.getElementById('profileForm');
            if (form.style.display === 'none') {
                form.style.display = 'block';
            } else {
                form.style.display = 'none';
            }
        });
    </script>
</c:if>
