<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.*" %>
<%@ page import="dao.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Admin - Quản lý sản phẩm BaloShop</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    </head>
    <body class="bg-gray-50 min-h-screen">
        <header class="bg-gradient-to-r from-blue-600 to-purple-700 text-white shadow-lg">
            <div class="container mx-auto px-4">
                <div class="flex justify-between items-center py-4">
                    <h1 class="text-2xl font-bold flex items-center">
                        <i class="fas fa-shield-alt mr-2"></i> Admin Panel - BaloShop
                    </h1>
                    <nav class="flex space-x-4">
                        <a href="admin-product.jsp" class="bg-white bg-opacity-20 px-3 py-2 rounded">
                            <i class="fas fa-shopping-bag mr-1"></i>Sản phẩm
                        </a>
                        <a href="index.jsp" class="hover:bg-white hover:bg-opacity-20 px-3 py-2 rounded transition">
                            <i class="fas fa-home mr-1"></i>Trang chủ
                        </a>
                    </nav>
                </div>
            </div>
        </header>

        <main class="container mx-auto px-4 py-8">
            <%
                ProductDAO dao = new ProductDAO();
                List<Product> products = dao.getAllProducts();
                int total = products.size();
                double avg = products.stream().mapToDouble(Product::getPrice).average().orElse(0);
                long inStock = products.stream().filter(p -> p.getStock() > 0).count();
                long outStock = total - inStock;
                request.setAttribute("allProducts", products);
            %>

            <!-- Dashboard Cards -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                <div class="bg-white p-6 rounded-lg shadow-md border-l-4 border-blue-500">
                    <p class="text-sm text-gray-600">Tổng sản phẩm</p>
                    <p class="text-3xl font-bold"><%=total%></p>
                </div>
                <div class="bg-white p-6 rounded-lg shadow-md border-l-4 border-green-500">
                    <p class="text-sm text-gray-600">Còn hàng</p>
                    <p class="text-3xl font-bold"><%=inStock%></p>
                </div>
                <div class="bg-white p-6 rounded-lg shadow-md border-l-4 border-red-500">
                    <p class="text-sm text-gray-600">Hết hàng</p>
                    <p class="text-3xl font-bold"><%=outStock%></p>
                </div>
                <div class="bg-white p-6 rounded-lg shadow-md border-l-4 border-yellow-500">
                    <p class="text-sm text-gray-600">Giá trung bình</p>
                    <p class="text-3xl font-bold">₫<%=String.format("%.0f", avg)%></p>
                </div>
            </div>

            <!-- Action Bar -->
            <div class="bg-white rounded-lg shadow-md p-6 mb-6">
                <div class="flex flex-col md:flex-row justify-between items-center space-y-4 md:space-y-0">
                    <button onclick="openAddModal()" class="bg-green-600 hover:bg-green-700 text-white px-6 py-3 rounded-lg flex items-center">
                        <i class="fas fa-plus mr-2"></i> Thêm sản phẩm mới
                    </button>
                    <div class="flex space-x-2">
                        <input id="searchInput" type="text" placeholder="Tìm kiếm sản phẩm..." class="px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500">
                        <button onclick="searchProducts()" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </div>
            </div>

            <!-- Table -->
            <div class="bg-white rounded-lg shadow-md overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200" id="productsTable">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500">ID</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500">Hình ảnh</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500">Tên</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500">Giá</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500">Kho</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500">Danh mục</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <c:forEach var="product" items="${allProducts}">
                            <tr>
                                <td class="px-6 py-4">${product.productId}</td>
                                <td class="px-6 py-4"><img src="images/${product.image}" class="w-16 h-16 object-cover"></td>
                                <td class="px-6 py-4">${product.name}</td>
                                <td class="px-6 py-4">₫<fmt:formatNumber value="${product.price}" type="number"/></td>
                                <td class="px-6 py-4">${product.stock}</td>
                                <td class="px-6 py-4">${product.category}</td>
                                <td class="px-6 py-4 flex space-x-2">
                                    <button 
                                        onclick="openEditModal(
                                        ${product.productId},
                                                        '${product.name}',
                                        ${product.price},
                                        ${product.stock},
                                                        '${product.brand}',
                                                        '${product.category}',
                                                        '${product.description}',
                                                        '${product.image}'
                                                        )"
                                        class="text-yellow-600"><i class="fas fa-edit"></i></button>
                                    <button onclick="deleteProduct(${product.productId})" class="text-red-600"><i class="fas fa-trash"></i></button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Messages -->
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="bg-green-100 text-green-800 px-4 py-2 my-2 rounded">${sessionScope.successMessage}</div>
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="bg-red-100 text-red-800 px-4 py-2 my-2 rounded">${sessionScope.errorMessage}</div>
            </c:if>
            <%
                session.removeAttribute("successMessage");
                session.removeAttribute("errorMessage");
            %>

            <!-- Modal -->
            <div id="productModal" class="fixed inset-0 hidden z-50 flex items-center justify-center bg-black bg-opacity-50">
                <div class="bg-white p-6 rounded w-full max-w-lg">
                    <h2 id="modalTitle" class="text-lg font-bold mb-4">Thêm sản phẩm</h2>
                    <!-- Preview -->
                    <img id="imagePreview" src="" class="w-32 h-32 object-cover mb-2 hidden">
                    <form id="productForm" action="product" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="action" id="action" value="add"/>
                        <input type="hidden" name="productId" id="productId" value=""/>

                        <input type="text" name="name" id="name" placeholder="Tên sản phẩm" required class="w-full mb-2 border p-2 rounded">
                        <input type="number" name="price" id="price" placeholder="Giá" required class="w-full mb-2 border p-2 rounded">
                        <input type="number" name="stock" id="stock" placeholder="Kho" required class="w-full mb-2 border p-2 rounded">
                        <input type="text" name="brand" id="brand" placeholder="Nhãn hàng" required class="w-full mb-2 border p-2 rounded">

                        <select name="category" id="category" required class="w-full mb-2 border p-2 rounded">
                            <option value="">--Chọn danh mục--</option>
                            <option value="Balo học sinh">Balo học sinh</option>
                            <option value="Balo laptop">Balo laptop</option>
                        </select>

                        <input type="file" name="image" id="image" class="w-full mb-2">
                        <textarea name="description" id="description" placeholder="Mô tả" class="w-full mb-2 border p-2 rounded"></textarea>

                        <div class="flex justify-end space-x-2">
                            <button type="button" onclick="closeModal()" class="px-4 py-2 bg-gray-300">Huỷ</button>
                            <button type="submit" class="px-4 py-2 bg-green-600 text-white">Lưu</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- FORM ẨN DELETE -->
            <form id="deleteForm" action="product" method="post" class="hidden">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="productId" id="deleteProductId">
            </form>

            <script>
                function openAddModal() {
                    document.getElementById('modalTitle').textContent = 'Thêm sản phẩm';
                    document.getElementById('action').value = 'add';
                    document.getElementById('productId').value = '';
                    document.getElementById('name').value = '';
                    document.getElementById('price').value = '';
                    document.getElementById('stock').value = '';
                    document.getElementById('brand').value = '';
                    document.getElementById('category').value = '';
                    document.getElementById('description').value = '';
                    document.getElementById('image').value = '';
                    document.getElementById('imagePreview').classList.add('hidden');
                    document.getElementById('productModal').classList.remove('hidden');
                }

                function openEditModal(id, name, price, stock, brand, category, description, image) {
                    document.getElementById('modalTitle').textContent = 'Sửa sản phẩm';
                    document.getElementById('action').value = 'edit';
                    document.getElementById('productId').value = id;
                    document.getElementById('name').value = name;
                    document.getElementById('price').value = price;
                    document.getElementById('stock').value = stock;
                    document.getElementById('brand').value = brand;
                    document.getElementById('category').value = category;
                    document.getElementById('description').value = description;
                    document.getElementById('image').value = '';
                    document.getElementById('imagePreview').src = 'images/' + image;
                    document.getElementById('imagePreview').classList.remove('hidden');
                    document.getElementById('productModal').classList.remove('hidden');
                }

                function closeModal() {
                    document.getElementById('productModal').classList.add('hidden');
                }

                function deleteProduct(id) {
                    if (confirm(`Bạn có chắc muốn xoá sản phẩm "${name}" không?`)) {
                        document.getElementById('deleteProductId').value = id;
                        document.getElementById('deleteForm').submit();
                    }
                }
            </script>
        </main>
    </body>
</html>
