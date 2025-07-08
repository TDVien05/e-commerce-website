<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - BaloShop</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-content">
        <div class="container">
            <div class="form-container">
                <h2 style="text-align: center; margin-bottom: 2rem; color: #333;">Đăng ký tài khoản</h2>
                
                <c:if test="${not empty error}">
                    <div class="alert alert-error">${error}</div>
                </c:if>
                
                <form action="user" method="post">
                    <input type="hidden" name="action" value="register">
                    
                    <div class="form-group">
                        <label for="username" class="form-label">Tên đăng nhập: <span style="color: red;">*</span></label>
                        <input type="text" id="username" name="username" class="form-input" 
                               required value="${param.username}">
                    </div>
                    
                    <div class="form-group">
                        <label for="password" class="form-label">Mật khẩu: <span style="color: red;">*</span></label>
                        <input type="password" id="password" name="password" class="form-input" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="confirmPassword" class="form-label">Xác nhận mật khẩu: <span style="color: red;">*</span></label>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="email" class="form-label">Email: <span style="color: red;">*</span></label>
                        <input type="email" id="email" name="email" class="form-input" 
                               required value="${param.email}">
                    </div>
                    
                    <div class="form-group">
                        <label for="fullName" class="form-label">Họ và tên: <span style="color: red;">*</span></label>
                        <input type="text" id="fullName" name="fullName" class="form-input" 
                               required value="${param.fullName}">
                    </div>
                    
                    <div class="form-group">
                        <label for="phone" class="form-label">Số điện thoại:</label>
                        <input type="tel" id="phone" name="phone" class="form-input" value="${param.phone}">
                    </div>
                    
                    <div class="form-group">
                        <label for="address" class="form-label">Địa chỉ:</label>
                        <textarea id="address" name="address" class="form-input form-textarea">${param.address}</textarea>
                    </div>
                    
                    <div class="form-group">
                        <button type="submit" class="btn btn-primary" style="width: 100%;">Đăng ký</button>
                    </div>
                </form>
                
                <div style="text-align: center; margin-top: 1rem;">
                    <p>Đã có tài khoản? <a href="user?action=login" style="color: #667eea;">Đăng nhập ngay</a></p>
                </div>
            </div>
        </div>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
    
    <script>
        // Validate password match
        document.querySelector('form').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Mật khẩu xác nhận không khớp!');
                return false;
            }
        });
    </script>
</body>
</html>
