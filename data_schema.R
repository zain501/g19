library(RSQLite)

data <- dbConnect(SQLite(), "mydatabase.db")

# Define the schema for the order table
order_schema <- "
CREATE TABLE IF NOT EXISTS orders (
   order_id VARCHAR(6) PRIMARY KEY,
   product_id VARCHAR(6) NOT NULL,
   customer_id VARCHAR(6) NOT NULL,
   order_date DATE,
   order_quantity INTEGER,
   order_final_amount DECIMAL(10,2), 
   order_status CHECK (Order_status IN ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled')),
   order_approval_date DATE NOT NULL,
   order_delivery_date DATE NOT NULL,
   FOREIGN KEY ('customer_id') REFERENCES customer ('customer_id'),
   FOREIGN KEY ('product_id') REFERENCES product ('product_id')
);"


#schema for product table
product_schema <- "
CREATE TABLE IF NOT EXISTS 'product'(
  'product_id' VARCHAR(6) PRIMARY KEY,
  'category_id' VARCHAR(6) NOT NULL,
  'supplier_id' VARCHAR(6) NOT NULL,
  'product_name' CHAR,
  'price' FLOAT,
  'description' CHAR,
  'stock_quantity' INT,
  ‘discount’ FLOAT,
  
  FOREIGN KEY ('category_id') REFERENCES category('category_id'),
  FOREIGN KEY ('supplier_id') REFERENCES supplier('supplier_id')
);"

#schema for customer table

customer_schema <- "
CREATE TABLE IF NOT EXISTS 'customer'(
  'customer_id' VARCHAR(6) PRIMARY KEY,
  'customer_first_name' CHAR(50),
  'customer_last_name' CHAR(50) ,
  'customer_email' VARCHAR(200) ,
  'customer_address' VARCHAR(200),
  'customer_postcode' VARCHAR(8),
  'registration_date' DATE ,
  'customer_phone' INT
);"


# Define the schema for the payment table
payment_schema <- "
CREATE TABLE IF NOT EXISTS payment (
   payment_id VARCHAR(6) PRIMARY KEY,
   customer_id VARCHAR(6),
   total_invoice_amount DOUBLE,
   payment_date DATE,
   payment_timestamp TIMESTAMP,
   invoice_no DOUBLE,
   FOREIGN KEY ('customer_id') REFERENCES customer('customer_id')
);"

#schema for supplier table
supplier_schema <- "
CREATE TABLE IF NOT EXISTS 'supplier'(
'supplier_id' VARCHAR(6) PRIMARY KEY,
'product_id' VARCHAR(6) ,
'seller_name'  TEXT,
'seller_email' VARCHAR(200),
'seller_address' VARCHAR(200),
'seller_city' CHAR(50) ,
'seller_state' CHAR(50) ,
'seller_phone' INT(11) ,
'registration_date' DATE ,
FOREIGN KEY ('product_id') REFERENCES product('product_id')
);"


# Define the schema for settlement table
settlement_schema <- "
CREATE TABLE IF NOT EXISTS payment (
   settlement_id VARCHAR(6) PRIMARY KEY,
   settlement_date DATE,
   total_sale_amount DOUBLE,
   settlement_tyme BINARY,
   sale_id VARCHAR(6),
   FOREIGN KEY ('sale_id') REFERENCES sale('sale_id')
);"

# Define the schema for sale table
sale_schema <- "
CREATE TABLE IF NOT EXISTS sale (
    sale_id VARCHAR(6) PRIMARY KEY,
    supplier_id VARCHAR(6),
    product_id VARCHAR(6),
    settlement_id VARCHAR(6),
    sale_date DATE,
    sale_amount DOUBLE,
    settlement_type TEXT,
    platform_fees DOUBLE,
    FOREIGN KEY ('product_id') REFERENCES product('product_id'),
    FOREIGN KEY ('supplier_id') REFERENCES supplier('supplier_id'),
    FOREIGN KEY ('settlement_id') REFERENCES settlement('settlement_id')
    
);"

# Define the schema for category table
category_schema <- "
CREATE TABLE IF NOT EXISTS category (
  category_id VARCHAR(6) PRIMARY KEY,
  category_name TEXT,
  product_id VARCHAR(6),
  FOREIGN KEY ('product_id') REFERENCES product('product_id')
);"

# Define the schema for rating table
rating_schema <- "
CREATE TABLE IF NOT EXISTS 'settlement'(
  rating_id VARCHAR(6) PRIMARY KEY,
  order_id VARCHAR(6) NOT NULL,
  rating DOUBLE,
  rating_date DATE,
  FOREIGN KEY ('order_id') REFERENCES orders('order_id')
);"

#schema for promotion table
promotion_schema <- "
CREATE TABLE IF NOT EXISTS 'promotion'(
  'promotion_id' VARCHAR(6) PRIMARY KEY,
  'supplier_id' VARCHAR(6),
  'promotion_name' CHAR,
  'promotion_fees' FLOAT ,
  'promotion_start_date' DATE,
  'promotion_end_date' DATE,
  FOREIGN KEY ('supplier_id') REFERENCES supplier('supplier_id')
);"

# Execute the schema creation queries
dbExecute(data, order_schema)
dbExecute(data, product_schema)
dbExecute(data, customer_schema)
dbExecute(data, payment_schema)
dbExecute(data, supplier_schema)
dbExecute(data, settlement_schema)
dbExecute(data, sale_schema)
dbExecute(data, category_schema)
dbExecute(data, rating_schema)
dbExecute(data, promotion_schema)

# Close the connection
dbDisconnect(data)
