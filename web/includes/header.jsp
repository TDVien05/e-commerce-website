<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
