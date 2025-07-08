CREATE DATABASE baloshop 


-- Drop tables if they exist (for recreation)
IF OBJECT_ID('order_items', 'U') IS NOT NULL DROP TABLE order_items;
IF OBJECT_ID('orders', 'U') IS NOT NULL DROP TABLE orders;
IF OBJECT_ID('cart_items', 'U') IS NOT NULL DROP TABLE cart_items;
IF OBJECT_ID('products', 'U') IS NOT NULL DROP TABLE products;
IF OBJECT_ID('users', 'U') IS NOT NULL DROP TABLE users;
GO

-- Users table
CREATE TABLE users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50) UNIQUE NOT NULL,
    password NVARCHAR(255) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    full_name NVARCHAR(100) NOT NULL,
    phone NVARCHAR(20),
    address NVARCHAR(MAX),
    role NVARCHAR(20) DEFAULT 'customer',
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE()
);
GO

-- Products table
CREATE TABLE products (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(200) NOT NULL,
    description NVARCHAR(MAX),
    price DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    image NVARCHAR(255),
    category NVARCHAR(50),
    brand NVARCHAR(100),
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE()
);
GO

-- Cart items table
CREATE TABLE cart_items (
    cart_item_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    CONSTRAINT UQ_cart_user_product UNIQUE (user_id, product_id)
);
GO

-- Orders table
CREATE TABLE orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    order_date DATETIME2 DEFAULT GETDATE(),
    total_amount DECIMAL(10,2) NOT NULL,
    status NVARCHAR(20) DEFAULT 'pending',
    shipping_address NVARCHAR(MAX) NOT NULL,
    payment_method NVARCHAR(50) NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);
GO

-- Order items table
CREATE TABLE order_items (
    order_item_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);
GO

-- Create triggers for updated_at columns
CREATE TRIGGER trg_users_updated_at
    ON users
    AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE users 
    SET updated_at = GETDATE()
    FROM users u
    INNER JOIN inserted i ON u.user_id = i.user_id;
END;
GO

CREATE TRIGGER trg_products_updated_at
    ON products
    AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE products 
    SET updated_at = GETDATE()
    FROM products p
    INNER JOIN inserted i ON p.product_id = i.product_id;
END;
GO

CREATE TRIGGER trg_orders_updated_at
    ON orders
    AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE orders 
    SET updated_at = GETDATE()
    FROM orders o
    INNER JOIN inserted i ON o.order_id = i.order_id;
END;
GO

-- Insert sample data
-- Sample users
SET IDENTITY_INSERT users ON;
INSERT INTO users (user_id, username, password, email, full_name, phone, address, role) VALUES
(1, N'admin', N'admin123', N'admin@baloshop.com', N'Administrator', N'0123456789', N'123 Admin Street', N'admin'),
(2, N'user1', N'user123', N'user1@example.com', N'Nguyễn Văn A', N'0987654321', N'456 User Avenue', N'customer'),
(3, N'user2', N'user123', N'user2@example.com', N'Trần Thị B', N'0912345678', N'789 Customer Road', N'customer');
SET IDENTITY_INSERT users OFF;
GO

-- Sample products
SET IDENTITY_INSERT products ON;
INSERT INTO products (product_id, name, description, price, stock, image, category, brand) VALUES
(1, N'Balo Laptop Dell Essential 15.6"', N'Balo laptop Dell thiết kế đơn giản, chuyên nghiệp, phù hợp cho công sở và học tập. Có ngăn đựng laptop riêng biệt, an toàn và tiện lợi.', 599000, 50, N'balo-dell-essential.jpg', N'laptop', N'Dell'),

(2, N'Balo Học Sinh Nike Classic', N'Balo học sinh Nike với thiết kế trẻ trung, năng động. Chất liệu polyester bền bỉ, nhiều ngăn tiện dụng, phù hợp cho học sinh, sinh viên.', 750000, 30, N'balo-nike-classic.jpg', N'school', N'Nike'),

(3, N'Balo Du Lịch The North Face Jester', N'Balo du lịch The North Face với dung tích lớn, thiết kế ergonomic thoải mái. Chất liệu chống nước, phù hợp cho các chuyến đi dài ngày.', 1200000, 25, N'balo-tnf-jester.jpg', N'travel', N'The North Face'),

(4, N'Balo Công Sở Samsonite Business', N'Balo công sở Samsonite cao cấp, thiết kế sang trọng, chuyên nghiệp. Có ngăn laptop, tài liệu riêng biệt, phù hợp cho doanh nhân.', 1800000, 20, N'balo-samsonite-business.jpg', N'business', N'Samsonite'),

(5, N'Balo Thể Thao Adidas Performance', N'Balo thể thao Adidas với thiết kế năng động, chất liệu thoáng khí. Có ngăn đựng giày riêng, phù hợp cho tập luyện và thể thao.', 850000, 40, N'balo-adidas-performance.jpg', N'sport', N'Adidas'),

(6, N'Balo Laptop HP Prelude Pro 15.6"', N'Balo laptop HP thiết kế hiện đại, bảo vệ laptop tối ưu. Chất liệu cao cấp, nhiều ngăn tiện ích, phù hợp cho công việc và học tập.', 680000, 35, N'balo-hp-prelude.jpg', N'laptop', N'HP'),

(7, N'Balo Học Sinh Converse All Star', N'Balo học sinh Converse phong cách street style, thiết kế iconic. Chất liệu canvas bền đẹp, phù hợp cho giới trẻ năng động.', 550000, 45, N'balo-converse-allstar.jpg', N'school', N'Converse'),

(8, N'Balo Du Lịch Osprey Farpoint 40L', N'Balo du lịch Osprey dung tích 40L, thiết kế chuyên nghiệp cho backpacker. Có khung nội bộ, đai hông thoải mái cho chuyến đi dài.', 2500000, 15, N'balo-osprey-farpoint.jpg', N'travel', N'Osprey'),

(9, N'Balo Công Sở Targus City Smart', N'Balo công sở Targus thiết kế thông minh, có ngăn sạc USB tích hợp. Chất liệu chống thấm, phù hợp cho cuộc sống hiện đại.', 950000, 28, N'balo-targus-smart.jpg', N'business', N'Targus'),

(10, N'Balo Thể Thao Under Armour Storm', N'Balo thể thao Under Armour với công nghệ Storm chống nước. Thiết kế ergonomic, phù hợp cho hoạt động thể thao và outdoor.', 1100000, 32, N'balo-ua-storm.jpg', N'sport', N'Under Armour'),

(11, N'Balo Laptop Asus ROG Gaming', N'Balo laptop gaming Asus ROG thiết kế hầm hố, phù hợp cho game thủ. Có ngăn đựng laptop gaming riêng, chất liệu cao cấp bền bỉ.', 1350000, 22, N'balo-asus-rog.jpg', N'laptop', N'Asus'),

(12, N'Balo Học Sinh Jansport SuperBreak', N'Balo học sinh Jansport classic, thiết kế đơn giản bền đẹp. Được tin dùng hàng thập kỷ, phù hợp cho mọi lứa tuổi học sinh.', 650000, 55, N'balo-jansport-superbreak.jpg', N'school', N'Jansport'),

(13, N'Balo Du Lịch Deuter Futura 32L', N'Balo du lịch Deuter với hệ thống lưng Aircomfort thoáng khí. Thiết kế chuyên nghiệp cho trekking và hiking, chất lượng Đức.', 2200000, 18, N'balo-deuter-futura.jpg', N'travel', N'Deuter'),

(14, N'Balo Công Sở Bellroy Transit', N'Balo công sở Bellroy thiết kế tinh tế, chất liệu da cao cấp. Có ngăn laptop, tài liệu được bố trí khoa học, phong cách minimalist.', 2800000, 12, N'balo-bellroy-transit.jpg', N'business', N'Bellroy'),

(15, N'Balo Thể Thao Puma Deck', N'Balo thể thao Puma thiết kế trẻ trung, năng động. Chất liệu polyester bền bỉ, nhiều ngăn tiện ích, phù hợp cho tập luyện hàng ngày.', 720000, 38, N'balo-puma-deck.jpg', N'sport', N'Puma');
SET IDENTITY_INSERT products OFF;
GO

-- Sample orders (for demonstration)
SET IDENTITY_INSERT orders ON;
INSERT INTO orders (order_id, user_id, total_amount, status, shipping_address, payment_method) VALUES
(1, 2, 599000, N'delivered', N'456 User Avenue, Q1, TP.HCM', N'cod'),
(2, 2, 1350000, N'shipped', N'456 User Avenue, Q1, TP.HCM', N'bank'),
(3, 3, 750000, N'processing', N'789 Customer Road, Q3, TP.HCM', N'momo');
SET IDENTITY_INSERT orders OFF;
GO

-- Sample order items
SET IDENTITY_INSERT order_items ON;
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, price) VALUES
(1, 1, 1, 1, 599000),
(2, 2, 11, 1, 1350000),
(3, 3, 2, 1, 750000);
SET IDENTITY_INSERT order_items OFF;
GO

-- Create indexes for better performance
CREATE INDEX IX_products_category ON products(category);
CREATE INDEX IX_products_name ON products(name);
CREATE INDEX IX_orders_user_id ON orders(user_id);
CREATE INDEX IX_orders_status ON orders(status);
CREATE INDEX IX_cart_items_user_id ON cart_items(user_id);
GO

-- Show tables
SELECT 
    TABLE_NAME as [Table Name],
    TABLE_TYPE as [Type]
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO

-- Show sample data
SELECT 'Users:' as Info;
SELECT user_id, username, full_name, email, role FROM users;

SELECT 'Products:' as Info;
SELECT TOP 5 product_id, name, price, stock, category, brand FROM products;

SELECT 'Sample complete!' as Status;
GO