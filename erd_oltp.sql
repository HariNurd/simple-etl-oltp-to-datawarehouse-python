create database projek1;
create database OLTP

CREATE TABLE IF NOT EXISTS  tb_user (
    user_id INT NOT NULL PRIMARY KEY,
    user_first_name VARCHAR(255) NOT NULL,
    user_last_name VARCHAR(255) NOT NULL,
    user_gender VARCHAR(50) NOT NULL,
    user_address VARCHAR(255),
    user_birthday DATE NOT NULL,
    user_join DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS tb_payment (
    payment_id INT NOT NULL PRIMARY KEY,
    payment_name VARCHAR(255) NOT NULL,
    payment_status BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS tb_shipper (
    shipper_id INT NOT NULL PRIMARY KEY,
    shipper_name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS tb_rating (
    rating_id INT NOT NULL PRIMARY KEY,
    rating_level INT NOT NULL,
    rating_status VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS tb_voucher (
    voucher_id INT NOT NULL PRIMARY KEY,
    voucher_name VARCHAR(255) NOT NULL,
    voucher_price INT,
    voucher_created DATE NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES tb_user(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS tb_orders(
    order_id INT NOT null PRIMARY KEY,
    order_date DATE NOT NULL,
    user_id INT NOT NULL,
    payment_id INT NOT NULL,
    shipper_id INT NOT NULL,
    order_price INT NOT NULL,
    order_discount INT,
    voucher_id INT,
    order_total INT NOT NULL,
    rating_id INT NOT null,
    FOREIGN KEY (user_id) REFERENCES tb_user(user_id),
    FOREIGN KEY (payment_id) REFERENCES tb_payment(payment_id),
    FOREIGN KEY (shipper_id) REFERENCES tb_shipper(shipper_id),
    FOREIGN KEY (voucher_id) REFERENCES tb_voucher(voucher_id),
    FOREIGN KEY (rating_id) REFERENCES tb_rating(rating_id)
);

CREATE TABLE IF NOT EXISTS tb_product_category (
    product_category_id INT NOT null PRIMARY KEY,
    product_category_name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS tb_products (
    product_id INT NOT null PRIMARY KEY,
    product_category_id INT NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    product_created DATE NOT NULL,
    product_price INT NOT NULL,
    product_discount INT,
    FOREIGN KEY (product_category_id) REFERENCES tb_product_category(product_category_id)
);

CREATE TABLE IF NOT EXISTS tb_order_items (
    order_item_id INT NOT NULL,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    order_item_quantity INT,
    product_discount INT,
    product_price INT NOT NULL,
    product_subprice INT NOT null,
    FOREIGN KEY (order_id) REFERENCES tb_orders(order_id),
    FOREIGN KEY (product_id) REFERENCES tb_products(product_id)
);