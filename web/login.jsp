<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - BaloShop</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-content">
        <div class="container">
            <div class="form-container">
                <h2 style="text-align: center; margin-bottom: 2rem; color: #333;">Đăng nhập</h2>
                
                <c:if test="${not empty error}">
                    <div class="alert alert-error">${error}</div>
                </c:if>
                
                <c:if test="${not empty success}">
                    <div class="alert alert-success">${success}</div>
                </c:if>
                
                <form action="user" method="post">
                    <input type="hidden" name="action" value="login">
                    
                    <div class="form-group">
                        <label for="username" class="form-label">Tên đăng nhập:</label>
                        <input type="text" id="username" name="username" class="form-input" 
                               required value="${param.username}">
                    </div>
                    
                    <div class="form-group">
                        <label for="password" class="form-label">Mật khẩu:</label>
                        <input type="password" id="password" name="password" class="form-input" required>
                    </div>
                    
                    <div class="form-group">
                        <button type="submit" class="btn btn-primary" style="width: 100%;">Đăng nhập</button>
                    </div>
                </form>
                
                <div style="text-align: center; margin-top: 1rem;">
                    <p>Chưa có tài khoản? <a href="user?action=register" style="color: #667eea;">Đăng ký ngay</a></p>
                </div>
            </div>
        </div>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>
