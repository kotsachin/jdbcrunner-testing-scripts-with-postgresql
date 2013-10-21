/*
 * Tiny TPC-C 1.1 - data loader
 * This script is based on TPC-C Standard Specification 5.10.1.
 *
 * [Oracle Database]
 * shell> sqlplus "/ AS SYSDBA"
 * sql> CREATE USER tpcc IDENTIFIED BY tpcc;
 * sql> GRANT connect, resource TO tpcc;
 *
 * [MySQL]
 * shell> mysql -u root [-p]
 * sql> CREATE DATABASE tpcc;
 * sql> GRANT ALL PRIVILEGES ON tpcc.* TO tpcc@'%' IDENTIFIED BY 'tpcc';
 *
 * [PostgreSQL]
 * shell> psql -U postgres
 * sql> CREATE DATABASE tpcw;
 * sql> CREATE USER tpcw PASSWORD 'tpcw';
 *
 * <postgresql.conf>
 * listen_addresses = '*'
 * port = 5432
 *
 * <pg_hba.conf>
 * host all all 0.0.0.0/0 md5
 */

// JdbcRunner settings -----------------------------------------------

// Oracle Database
// var jdbcUrl = "jdbc:oracle:thin://@localhost:1521/TPCC";

// MySQL
//var jdbcUrl = "jdbc:mysql://localhost:3306/tpcc?rewriteBatchedStatements=true";

// PostgreSQL
 var jdbcUrl = "jdbc:postgresql://localhost:5432/tpcw";

var jdbcUser = "tpcw";
var jdbcPass = "tpcw";
var isLoad = true;
var nAgents = 4;
var isAutoCommit = false;
var logDir = "logs";

// Application settings ----------------------------------------------

var BATCH_SIZE = 100;
var COMMIT_SIZE = 1000;
var PRINT_SIZE = 10000;

// Using a constant value '0' for C-Load, and '100' for C-Run.
var C_255 = 0;
var C_1023 = 0;
var C_8191 = 0;

var SYLLABLE = [
    'BAR', 'OUGHT', 'ABLE', 'PRI', 'PRES',
    'ESE', 'ANTI', 'CALLY', 'ATION', 'EING'];

var ALPHA_NUMERIC_2;
var ALPHA_NUMERIC = [
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
    'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

// JdbcRunner functions ----------------------------------------------

function init() {
    if (getId() == 0) {
        var scale = param0;
        var taskQueue = new java.util.concurrent.LinkedBlockingQueue();
        
        info("Tiny TPC-C 1.1 - data loader");
        info("-param0  : Scale factor (default : 16)");
        info("-nAgents : Parallel loading degree (default : 4)");
        
        if (scale == 0) {
            scale = 16;
        }
        
        info("Scale factor            : " + scale);
        info("Parallel loading degree : " + nAgents);
        
        for (var customerId = 1; customerId <= scale; customerId++) {
            taskQueue.offer(customerId);
        }
        
        putData("TaskQueue", taskQueue);
        
        if (getDatabaseProductName() == "Oracle") {
            dropTable();
            createTableOracle();
        } else if (getDatabaseProductName() == "MySQL") {
            dropTable();
            createTableMySQL();
        } else if (getDatabaseProductName() == "PostgreSQL") {
            dropTable();
            createTablePostgreSQL();
	commit();
        } else {
            error(getDatabaseProductName() + " is not supported yet.");
        }

   	loadAuthor();     
        loadItem();
	loadCountry();
	loadAddress();
	loadCC_xacts();
	loadCustomer();
	loadOrders();
	loadOrder_Line();
	commit();

    }
}

function run() {

/*
   var customerId = Number(getData("TaskQueue").poll());
    
    if (customerId != 0) {
        info("Loading customer id " + customerId + " by agent " + getId() + " ...");
        
   	loadAuthor();     
        loadItem();
	loadCountry();
	loadAddress();
	loadCC_xacts();
	loadCustomer();
	loadOrders();
	loadOrder_Line();
commit();
       loadWarehouse(warehouseId);
        loadDistrict(warehouseId);
        loadCustomer(warehouseId);
        loadStock(warehouseId);
        loadOrders(warehouseId);

    } else {
*/        setBreak();
  // }

}

function fin() {
    if (getId() == 0) {
        if (getDatabaseProductName() == "Oracle") {
            createIndexOracle();
            createForeignKeyOracle();
            gatherStatsOracle();
        } else if (getDatabaseProductName() == "MySQL") {
            // Do nothing.
        } else if (getDatabaseProductName() == "PostgreSQL") {
            createIndexPostgreSQL();
            createForeignKeyPostgreSQL();
            gatherStatsPostgreSQL();
        } else {
            error(getDatabaseProductName() + " is not supported yet.");
        }
        
        commit();
        info("Completed.");
    }
}

// Application functions ---------------------------------------------

function dropTable() {
    info("Dropping tables ...");
    
    dropTableByName("order_line");
    dropTableByName("item");
    dropTableByName("cc_xacts");
    dropTableByName("author");
    dropTableByName("orders");
    dropTableByName("customer");
    dropTableByName("address");
    dropTableByName("country");
 //   dropTableByName("shopping_cart");
 //   dropTableByName("shopping_cart_line");
}

function dropTableByName(tableName) {
    try {
        execute("DROP TABLE " + tableName);
	commit();
    } catch (e) {
        warn(e);
        rollback(); // PostgreSQL requires a rollback.
    }
}

function createTableOracle() {
    info("Creating tables ...");
    
    execute("CREATE TABLE warehouse ("
        + "w_id NUMBER(6, 0), "
        + "w_name VARCHAR2(10), "
        + "w_street_1 VARCHAR2(20), "
        + "w_street_2 VARCHAR2(20), "
        + "w_city VARCHAR2(20), "
        + "w_state CHAR(2), "
        + "w_zip CHAR(9), "
        + "w_tax NUMBER(4, 4), "
        + "w_ytd NUMBER(12, 2))");
    
    execute("CREATE TABLE district ("
        + "d_id NUMBER(2, 0), "
        + "d_w_id NUMBER(6, 0), "
        + "d_name VARCHAR2(10), "
        + "d_street_1 VARCHAR2(20), "
        + "d_street_2 VARCHAR2(20), "
        + "d_city VARCHAR2(20), "
        + "d_state CHAR(2), "
        + "d_zip CHAR(9), "
        + "d_tax NUMBER(4, 4), "
        + "d_ytd NUMBER(12, 2), "
        + "d_next_o_id NUMBER(8, 0))");
    
    execute("CREATE TABLE customer ("
        + "c_id NUMBER(5, 0), "
        + "c_d_id NUMBER(2, 0), "
        + "c_w_id NUMBER(6, 0), "
        + "c_first VARCHAR2(16), "
        + "c_middle CHAR(2), "
        + "c_last VARCHAR2(16), "
        + "c_street_1 VARCHAR2(20), "
        + "c_street_2 VARCHAR2(20), "
        + "c_city VARCHAR2(20), "
        + "c_state CHAR(2), "
        + "c_zip CHAR(9), "
        + "c_phone CHAR(16), "
        + "c_since DATE, "
        + "c_credit CHAR(2), "
        + "c_credit_lim NUMBER(12, 2), "
        + "c_discount NUMBER(4, 4), "
        + "c_balance NUMBER(12, 2), "
        + "c_ytd_payment NUMBER(12, 2), "
        + "c_payment_cnt NUMBER(4, 0), "
        + "c_delivery_cnt NUMBER(4, 0), "
        + "c_data VARCHAR2(500))");
    
    execute("CREATE TABLE history ("
        + "h_c_id NUMBER(5, 0), "
        + "h_c_d_id NUMBER(2, 0), "
        + "h_c_w_id NUMBER(6, 0), "
        + "h_d_id NUMBER(2, 0), "
        + "h_w_id NUMBER(6, 0), "
        + "h_date DATE, "
        + "h_amount NUMBER(6, 2), "
        + "h_data VARCHAR2(24))");
    
    execute("CREATE TABLE item ("
        + "i_id NUMBER(6, 0), "
        + "i_im_id NUMBER(6, 0), "
        + "i_name VARCHAR2(24), "
        + "i_price NUMBER(5, 2), "
        + "i_data VARCHAR2(50))");
    
    execute("CREATE TABLE stock ("
        + "s_i_id NUMBER(6, 0), "
        + "s_w_id NUMBER(6, 0), "
        + "s_quantity NUMBER(4, 0), "
        + "s_dist_01 CHAR(24), "
        + "s_dist_02 CHAR(24), "
        + "s_dist_03 CHAR(24), "
        + "s_dist_04 CHAR(24), "
        + "s_dist_05 CHAR(24), "
        + "s_dist_06 CHAR(24), "
        + "s_dist_07 CHAR(24), "
        + "s_dist_08 CHAR(24), "
        + "s_dist_09 CHAR(24), "
        + "s_dist_10 CHAR(24), "
        + "s_ytd NUMBER(8, 0), "
        + "s_order_cnt NUMBER(4, 0), "
        + "s_remote_cnt NUMBER(4, 0), "
        + "s_data VARCHAR2(50))");
    
    execute("CREATE TABLE orders ("
        + "o_id NUMBER(8, 0), "
        + "o_d_id NUMBER(2, 0), "
        + "o_w_id NUMBER(6, 0), "
        + "o_c_id NUMBER(5, 0), "
        + "o_entry_d DATE, "
        + "o_carrier_id NUMBER(2, 0), "
        + "o_ol_cnt NUMBER(2, 0), "
        + "o_all_local NUMBER(1, 0))");
    
    execute("CREATE TABLE new_orders ("
        + "no_o_id NUMBER(8, 0), "
        + "no_d_id NUMBER(2, 0), "
        + "no_w_id NUMBER(6, 0))");
    
    execute("CREATE TABLE order_line ("
        + "ol_o_id NUMBER(8, 0), "
        + "ol_d_id NUMBER(2, 0), "
        + "ol_w_id NUMBER(6, 0), "
        + "ol_number NUMBER(2, 0), "
        + "ol_i_id NUMBER(6, 0), "
        + "ol_supply_w_id NUMBER(6, 0), "
        + "ol_delivery_d DATE, "
        + "ol_quantity NUMBER(2, 0), "
        + "ol_amount NUMBER(6, 2), "
        + "ol_dist_info CHAR(24))");
}

function createTableMySQL() {
    info("Creating tables ...");
    
    execute("CREATE TABLE warehouse ("
        + "w_id INT, "
        + "w_name VARCHAR(10), "
        + "w_street_1 VARCHAR(20), "
        + "w_street_2 VARCHAR(20), "
        + "w_city VARCHAR(20), "
        + "w_state CHAR(2), "
        + "w_zip CHAR(9), "
        + "w_tax DECIMAL(4, 4), "
        + "w_ytd DECIMAL(12, 2), "
        + "PRIMARY KEY (w_id)) "
        + "ENGINE = InnoDB");
    
    execute("CREATE TABLE district ("
        + "d_id INT, "
        + "d_w_id INT, "
        + "d_name VARCHAR(10), "
        + "d_street_1 VARCHAR(20), "
        + "d_street_2 VARCHAR(20), "
        + "d_city VARCHAR(20), "
        + "d_state CHAR(2), "
        + "d_zip CHAR(9), "
        + "d_tax DECIMAL(4, 4), "
        + "d_ytd DECIMAL(12, 2), "
        + "d_next_o_id INT, "
        + "PRIMARY KEY (d_w_id, d_id), "
        + "CONSTRAINT district_fk1 "
            + "FOREIGN KEY (d_w_id) "
            + "REFERENCES warehouse (w_id)) "
        + "ENGINE = InnoDB");
    
    execute("CREATE TABLE customer ("
        + "c_id INT, "
        + "c_d_id INT, "
        + "c_w_id INT, "
        + "c_first VARCHAR(16), "
        + "c_middle CHAR(2), "
        + "c_last VARCHAR(16), "
        + "c_street_1 VARCHAR(20), "
        + "c_street_2 VARCHAR(20), "
        + "c_city VARCHAR(20), "
        + "c_state CHAR(2), "
        + "c_zip CHAR(9), "
        + "c_phone CHAR(16), "
        + "c_since DATETIME, "
        + "c_credit CHAR(2), "
        + "c_credit_lim DECIMAL(12, 2), "
        + "c_discount DECIMAL(4, 4), "
        + "c_balance DECIMAL(12, 2), "
        + "c_ytd_payment DECIMAL(12, 2), "
        + "c_payment_cnt DECIMAL(4, 0), "
        + "c_delivery_cnt DECIMAL(4, 0), "
        + "c_data VARCHAR(500), "
        + "PRIMARY KEY (c_w_id, c_d_id, c_id), "
        + "KEY customer_ix1 (c_w_id, c_d_id, c_last), "
        + "CONSTRAINT customer_fk1 "
            + "FOREIGN KEY (c_w_id, c_d_id) "
            + "REFERENCES district (d_w_id, d_id)) "
        + "ENGINE = InnoDB");
    
    execute("CREATE TABLE history ("
        + "h_id INT PRIMARY KEY AUTO_INCREMENT, " // A surrogate key for ascending inserts.
        + "h_c_id INT, "
        + "h_c_d_id INT, "
        + "h_c_w_id INT, "
        + "h_d_id INT, "
        + "h_w_id INT, "
        + "h_date DATETIME, "
        + "h_amount DECIMAL(6, 2), "
        + "h_data VARCHAR(24), "
        + "CONSTRAINT history_fk1 "
            + "FOREIGN KEY (h_c_w_id, h_c_d_id, h_c_id) "
            + "REFERENCES customer (c_w_id, c_d_id, c_id), "
        + "CONSTRAINT history_fk2 "
            + "FOREIGN KEY (h_w_id, h_d_id) "
            + "REFERENCES district (d_w_id, d_id)) "
        + "ENGINE = InnoDB");
    
    execute("CREATE TABLE item ("
        + "i_id INT, "
        + "i_im_id INT, "
        + "i_name VARCHAR(24), "
        + "i_price DECIMAL(5, 2), "
        + "i_data VARCHAR(50), "
        + "PRIMARY KEY (i_id)) "
        + "ENGINE = InnoDB");
    
    execute("CREATE TABLE stock ("
        + "s_i_id INT, "
        + "s_w_id INT, "
        + "s_quantity DECIMAL(4, 0), "
        + "s_dist_01 CHAR(24), "
        + "s_dist_02 CHAR(24), "
        + "s_dist_03 CHAR(24), "
        + "s_dist_04 CHAR(24), "
        + "s_dist_05 CHAR(24), "
        + "s_dist_06 CHAR(24), "
        + "s_dist_07 CHAR(24), "
        + "s_dist_08 CHAR(24), "
        + "s_dist_09 CHAR(24), "
        + "s_dist_10 CHAR(24), "
        + "s_ytd DECIMAL(8, 0), "
        + "s_order_cnt DECIMAL(4, 0), "
        + "s_remote_cnt DECIMAL(4, 0), "
        + "s_data VARCHAR(50), "
        + "PRIMARY KEY (s_w_id, s_i_id), "
        + "CONSTRAINT stock_fk1 "
            + "FOREIGN KEY (s_w_id) "
            + "REFERENCES warehouse (w_id), "
        + "CONSTRAINT stock_fk2 "
            + "FOREIGN KEY (s_i_id) "
            + "REFERENCES item (i_id)) "
        + "ENGINE = InnoDB");
    
    execute("CREATE TABLE orders ("
        + "o_id INT, "
        + "o_d_id INT, "
        + "o_w_id INT, "
        + "o_c_id INT, "
        + "o_entry_d DATETIME, "
        + "o_carrier_id INT, "
        + "o_ol_cnt DECIMAL(2, 0), "
        + "o_all_local DECIMAL(1, 0), "
        + "PRIMARY KEY (o_w_id, o_d_id, o_id), "
        + "KEY orders_ix1 (o_w_id, o_d_id, o_c_id), "
        + "CONSTRAINT orders_fk1 "
            + "FOREIGN KEY (o_w_id, o_d_id, o_c_id) "
            + "REFERENCES customer (c_w_id, c_d_id, c_id)) "
        + "ENGINE = InnoDB");
    
    execute("CREATE TABLE new_orders ("
        + "no_o_id INT, "
        + "no_d_id INT, "
        + "no_w_id INT, "
        + "PRIMARY KEY (no_w_id, no_d_id, no_o_id), "
        + "CONSTRAINT new_orders_fk1 "
            + "FOREIGN KEY (no_w_id, no_d_id, no_o_id) "
            + "REFERENCES orders (o_w_id, o_d_id, o_id)) "
        + "ENGINE = InnoDB");
    
    execute("CREATE TABLE order_line ("
        + "ol_o_id INT, "
        + "ol_d_id INT, "
        + "ol_w_id INT, "
        + "ol_number INT, "
        + "ol_i_id INT, "
        + "ol_supply_w_id INT, "
        + "ol_delivery_d DATETIME, "
        + "ol_quantity DECIMAL(2, 0), "
        + "ol_amount DECIMAL(6, 2), "
        + "ol_dist_info CHAR(24), "
        + "PRIMARY KEY (ol_w_id, ol_d_id, ol_o_id, ol_number), "
        + "CONSTRAINT order_line_fk1 "
            + "FOREIGN KEY (ol_w_id, ol_d_id, ol_o_id) "
            + "REFERENCES orders (o_w_id, o_d_id, o_id), "
        + "CONSTRAINT order_line_fk2 "
            + "FOREIGN KEY (ol_supply_w_id, ol_i_id) "
            + "REFERENCES stock (s_w_id, s_i_id)) "
        + "ENGINE = InnoDB");
}

function createTablePostgreSQL() {
    info("Creating tables ...");
 
   execute("create table author (" 
	+ "a_id numeric(10), "
	+ "a_fname varchar(20), "
	+ "a_lname varchar(20), "
	+ "a_mname varchar(20), "
	+ "a_dob date, "
	+ "a_bio varchar(500), "
	+ "primary key (a_id) )");   

   execute("create table country (" 
	+ "co_id numeric(4), "
	+ "co_name varchar(50), "
	+ "co_exchange numeric(12, 6), "
	+ "co_currency varchar(18), "
	+ "primary key (co_id) )");

   execute("create table item (" 
	+ "i_id numeric(10), "
	+ "i_title varchar(60), "
	+ "i_a_id numeric(10), "
	+ "i_pub_date date, "
	+ "i_publisher varchar(60), "
	+ "i_subject varchar(60), "
	+ "i_desc varchar(500), "
	+ "i_related1 numeric(10), "
	+ "i_related2 numeric(10), "
	+ "i_related3 numeric(10), "
	+ "i_related4 numeric(10), "
	+ "i_related5 numeric(10), "
	+ "i_thumbnail bytea, "
	+ "i_image bytea, "
	+ "i_srp numeric(15, 2), "
	+ "i_cost numeric(15, 2), "
	+ "i_avail date, "
	+ "i_stock numeric(4), "
	+ "i_isbn char(13), "
	+ "i_page numeric(4), "
	+ "i_backing varchar(15), "
	+ "i_dimensions varchar(25), "
	+ "primary key (i_id))");

   execute("create table address (" 
	+ "addr_id numeric(10), "
	+ "addr_street1 varchar(40), "
	+ "addr_street2 varchar(40), "
	+ "addr_city varchar(30), "
	+ "addr_state varchar(20), "
	+ "addr_zip varchar(10), "
	+ "addr_co_id numeric(4), "
	+ "primary key (addr_id))");

   execute("create table customer (" 
	+ "c_id numeric(10), "
	+ "c_uname varchar(20), "
	+ "c_passwd varchar(20), "
	+ "c_fname varchar(15), "
	+ "c_lname varchar(15), "
	+ "c_addr_id numeric(10), "
	+ "c_phone varchar(16), "
	+ "c_email varchar(50), "
	+ "c_since date, "
	+ "c_last_visit date, "
	+ "c_login timestamp, "
	+ "c_expiration timestamp, "
	+ "c_discount numeric(3, 2), "
	+ "c_balance numeric(15, 2), "
	+ "c_ytd_pmt numeric(15, 2), "
	+ "c_birthdate date, "
	+ "c_data varchar(500), "
	+ "primary key (c_id))");

   execute("create table orders (" 
	+ "o_id numeric(10), "
	+ "o_c_id numeric(10), "
	+ "o_date timestamp, "
	+ "o_sub_total numeric(15, 2), "
	+ "o_tax numeric(15, 2), "
	+ "o_total numeric(15, 2), "
	+ "o_ship_type varchar(10), "
	+ "o_ship_date timestamp, "
	+ "o_bill_addr_id numeric(10), "
	+ "o_ship_addr_id numeric(10), "
	+ "o_status varchar(15), "
	+ "primary key (o_id))");

   execute("create table order_line (" 
	+ "ol_id numeric(3), "
	+ "ol_o_id numeric(10), "
	+ "ol_i_id numeric(10), "
	+ "ol_qty numeric(3), "
	+ "ol_discount numeric(3, 2), "
	+ "ol_comments varchar(100), "
	+ "primary key(ol_o_id, ol_id))");

   execute("create table cc_xacts (" 
	+ "cx_o_id numeric(10), "
	+ "cx_type varchar(10), "
	+ "cx_num numeric(16), "
	+ "cx_name varchar(31), "
	+ "cx_expiry date, "
	+ "cx_auth_id char(15), "
	+ "cx_xact_amt numeric(15, 2), "
	+ "cx_xact_date timestamp, "
	+ "cx_co_id numeric(4), "
	+ "primary key (cx_o_id))");
/*
   execute("create table shopping_cart (" 
	+ "sc_id numeric(10), "
	+ "sc_c_id numeric(10), "
	+ "sc_date timestamp, "
	+ "sc_sub_total numeric(17, 2), "
	+ "sc_tax numeric(17, 2), "
	+ "sc_ship_cost numeric(17, 2), "
	+ "sc_total numeric(17, 2), "
	+ "sc_c_fname varchar(15), "
	+ "sc_c_lname varchar(15), "
	+ "sc_c_discount numeric(5, 2), "
	+ "primary key(sc_id) )");

   execute("create table shopping_cart_line (" 
	+ "scl_sc_id numeric(10), "
	+ "scl_i_id numeric(10), "
	+ "scl_qty numeric(3), "
	+ "scl_cost numeric(17, 2), "
	+ "scl_srp numeric(17, 2), "
	+ "scl_title varchar(60), "
	+ "scl_backing varchar(15), "
	+ "primary key(scl_sc_id, scl_i_id) )");
*/
}

function createIndexOracle() {
    info("Creating indexes ...");
  /*  
    execute("ALTER TABLE warehouse ADD CONSTRAINT warehouse_pk "
        + "PRIMARY KEY (w_id)");
    
    execute("ALTER TABLE district ADD CONSTRAINT district_pk "
        + "PRIMARY KEY (d_w_id, d_id)");
    
    execute("ALTER TABLE customer ADD CONSTRAINT customer_pk "
        + "PRIMARY KEY (c_w_id, c_d_id, c_id)");
    
    execute("ALTER TABLE item ADD CONSTRAINT item_pk "
        + "PRIMARY KEY (i_id)");
    
    execute("ALTER TABLE stock ADD CONSTRAINT stock_pk "
        + "PRIMARY KEY (s_w_id, s_i_id)");
    
    execute("ALTER TABLE orders ADD CONSTRAINT orders_pk "
        + "PRIMARY KEY (o_w_id, o_d_id, o_id)");
    
    execute("ALTER TABLE new_orders ADD CONSTRAINT new_orders_pk "
        + "PRIMARY KEY (no_w_id, no_d_id, no_o_id)");
    
    execute("ALTER TABLE order_line ADD CONSTRAINT order_line_pk "
        + "PRIMARY KEY (ol_w_id, ol_d_id, ol_o_id, ol_number)");
    
    execute("CREATE INDEX customer_ix1 ON customer (c_w_id, c_d_id, c_last)");
    
    execute("CREATE INDEX orders_ix1 ON orders (o_w_id, o_d_id, o_c_id)");
*/
}

function createIndexPostgreSQL() {
    createIndexOracle();
}

function createForeignKeyOracle() {
    info("Creating foreign keys ...");
    
    execute("ALTER TABLE item ADD CONSTRAINT item_fk1 "
        + "FOREIGN KEY (i_a_id) "
        + "REFERENCES author (a_id)");
    
    execute("ALTER TABLE customer ADD CONSTRAINT customer_fk1 "
        + "FOREIGN KEY (c_addr_id) "
        + "REFERENCES address (addr_id)");
    
    execute("ALTER TABLE orders ADD CONSTRAINT orders_fk1 "
        + "FOREIGN KEY (o_c_id) "
        + "REFERENCES customer (c_id)");
    
/*    execute("ALTER TABLE orders ADD CONSTRAINT orders_fk2 "
        + "FOREIGN KEY (o_bill_addr_id,o_ship_addr_id) "
        + "REFERENCES address (addr_id,addr_id)");
  */  
    execute("ALTER TABLE orders ADD CONSTRAINT orders_fk2 "
        + "FOREIGN KEY (o_bill_addr_id) "
        + "REFERENCES address (addr_id)");

    execute("ALTER TABLE orders ADD CONSTRAINT orders_fk3 "
        + "FOREIGN KEY (o_ship_addr_id) "
        + "REFERENCES address (addr_id)");

    execute("ALTER TABLE order_line ADD CONSTRAINT order_line_fk1 "
        + "FOREIGN KEY (ol_i_id) "
        + "REFERENCES item (i_id)");
    
    execute("ALTER TABLE order_line ADD CONSTRAINT order_line_fk2 "
        + "FOREIGN KEY (ol_o_id) "
        + "REFERENCES orders (o_id)");
    
    execute("ALTER TABLE cc_xacts ADD CONSTRAINT cc_xacts_fk1 "
        + "FOREIGN KEY (cx_o_id) "
        + "REFERENCES orders (o_id)");
    
    execute("ALTER TABLE cc_xacts ADD CONSTRAINT cc_xacts_fk2 "
        + "FOREIGN KEY (cx_co_id) "
        + "REFERENCES country (co_id)");
    
    execute("ALTER TABLE address ADD CONSTRAINT address_fk1 "
        + "FOREIGN KEY (addr_co_id) "
        + "REFERENCES country (co_id)");
   
}

function createForeignKeyPostgreSQL() {
    createForeignKeyOracle();
}

function gatherStatsOracle() {
    info("Analyzing tables ...");
    
    execute("BEGIN DBMS_STATS.GATHER_SCHEMA_STATS(ownname => NULL); END;");
}

function gatherStatsPostgreSQL() {
    info("Vacuuming and analyzing tables ...");
    
    takeConnection().setAutoCommit(true);
    execute("VACUUM ANALYZE customer");
    execute("VACUUM ANALYZE address");
    execute("VACUUM ANALYZE country");
    execute("VACUUM ANALYZE cc_xacts");
    execute("VACUUM ANALYZE item");
    execute("VACUUM ANALYZE orders");
    execute("VACUUM ANALYZE author");
    execute("VACUUM ANALYZE order_line");
    takeConnection().setAutoCommit(false);

}



function loadAuthor() {
    info("Loading Author ...");
   execute("COPY author FROM '/mnt/sdb/data/author.data' WITH DELIMITER '>'");
}

function loadItem() {
    info("Loading Item ...");

   execute("COPY item FROM '/mnt/sdb/data/item.data' WITH DELIMITER '>'");
}


function loadCountry() {
    info("Loading Country ...");
   execute("COPY country FROM '/mnt/sdb/data/country.data' WITH DELIMITER '>'");
}

function loadAddress() {
    info("Loading Address ...");
   execute("COPY address FROM '/mnt/sdb/data/address.data' WITH DELIMITER '>'");
}


function loadCC_xacts() {
    info("Loading CC_xacts ...");
   execute("COPY cc_xacts FROM '/mnt/sdb/data/cc_xacts.data' WITH DELIMITER '>'");
}

function loadCustomer() {
    info("Loading Customer ...");
   execute("COPY customer FROM '/mnt/sdb/data/customer.data' WITH DELIMITER '>'");
}

function loadOrders() {
    info("Loading Orders ...");
   execute("COPY orders FROM '/mnt/sdb/data/orders.data' WITH DELIMITER '>'");
}


function loadOrder_Line() {
    info("Loading Order_line ...");
   execute("COPY order_line FROM '/mnt/sdb/data/order_line.data' WITH DELIMITER '>'");
}



/*

function loadItem() {
    info("Loading item ...");

    var i_id = new Array(BATCH_SIZE);
    var i_im_id = new Array(BATCH_SIZE);
    var i_name = new Array(BATCH_SIZE);
    var i_price = new Array(BATCH_SIZE);
    var i_data = new Array(BATCH_SIZE);
    
    for (var itemId = 1; itemId <= 100000; itemId++) {
        var index = (itemId - 1) % BATCH_SIZE;
        
        i_id[index] = itemId;
        i_im_id[index] = random(1, 10000);
        i_name[index] = randomString(14, 24);
        i_price[index] = random(100, 10000) / 100;
        i_data[index] = randomString(26, 50);
        
        if (random(1, 10) == 1) {
            var replace = random(0, i_data[index].length - 8);
            
            i_data[index] =
                i_data[index].substring(0, replace)
                + "ORIGINAL"
                + i_data[index].substring(replace + 8);
        }
        
        if (itemId % BATCH_SIZE == 0) {
            executeBatch("INSERT INTO item "
                + "(i_id, i_im_id, i_name, i_price, i_data) "
                + "VALUES ($int, $int, $string, $double, $string)",
                i_id, i_im_id, i_name, i_price, i_data);
            
            if (itemId % COMMIT_SIZE == 0) {
                commit();
                
                if (itemId % PRINT_SIZE == 0) {
                    info("item : " + itemId + " / 100000");
                }
            }
        }
    }


}

function loadWarehouse(warehouseId) {
    info("[Agent " + getId() + "] Loading warehouse ...");
    
    var w_name = randomString(6, 10);
    var w_street_1 = randomString(10, 20);
    var w_street_2 = randomString(10, 20);
    var w_city = randomString(10, 20);
    var w_state = randomString(2, 2);
    var w_zip = (random(10000, 19999) + "11111").substring(1);
    var w_tax = random(0, 2000) / 10000;
    var w_ytd = 300000;
    
    execute("INSERT INTO warehouse "
        + "(w_id, w_name, w_street_1, w_street_2, w_city, "
        + "w_state, w_zip, w_tax, w_ytd) "
        + "VALUES ($int, $string, $string, $string, $string, "
        + "$string, $string, $double, $double)",
        warehouseId, w_name, w_street_1, w_street_2, w_city, w_state,
        w_zip, w_tax, w_ytd);
    
    commit();
}

function loadDistrict(warehouseId) {
    info("[Agent " + getId() + "] Loading district ...");
    
    var d_id = new Array(10);
    var d_w_id = new Array(10);
    var d_name = new Array(10);
    var d_street_1 = new Array(10);
    var d_street_2 = new Array(10);
    var d_city = new Array(10);
    var d_state = new Array(10);
    var d_zip = new Array(10);
    var d_tax = new Array(10);
    var d_ytd = new Array(10);
    var d_next_o_id = new Array(10);
    
    for (var districtId = 1; districtId <= 10; districtId++) {
        var index = districtId - 1;
        
        d_id[index] = districtId;
        d_w_id[index] = warehouseId;
        d_name[index] = randomString(6, 10);
        d_street_1[index] = randomString(10, 20);
        d_street_2[index] = randomString(10, 20);
        d_city[index] = randomString(10, 20);
        d_state[index] = randomString(2, 2);
        d_zip[index] = (random(10000, 19999) + "11111").substring(1);
        d_tax[index] = random(0, 2000) / 10000;
        d_ytd[index] = 30000;
        d_next_o_id[index] = 3001;
    }
    
    executeBatch("INSERT INTO district "
        + "(d_id, d_w_id, d_name, d_street_1, d_street_2, "
        + "d_city, d_state, d_zip, d_tax, d_ytd, d_next_o_id) "
        + "VALUES ($int, $int, $string, $string, $string, "
        + "$string, $string, $string, $double, $double, $int)",
        d_id, d_w_id, d_name, d_street_1, d_street_2,
        d_city, d_state, d_zip, d_tax, d_ytd, d_next_o_id);
    
    commit();
}

function loadCustomer(warehouseId) {
    info("[Agent " + getId() + "] Loading customer and history ...");
    
    // customer
    var c_id = new Array(BATCH_SIZE);
    var c_d_id = new Array(BATCH_SIZE);
    var c_w_id = new Array(BATCH_SIZE);
    var c_first = new Array(BATCH_SIZE);
    var c_middle = new Array(BATCH_SIZE);
    var c_last = new Array(BATCH_SIZE);
    var c_street_1 = new Array(BATCH_SIZE);
    var c_street_2 = new Array(BATCH_SIZE);
    var c_city = new Array(BATCH_SIZE);
    var c_state = new Array(BATCH_SIZE);
    var c_zip = new Array(BATCH_SIZE);
    var c_phone = new Array(BATCH_SIZE);
    var c_since = new Array(BATCH_SIZE);
    var c_credit = new Array(BATCH_SIZE);
    var c_credit_lim = new Array(BATCH_SIZE);
    var c_discount = new Array(BATCH_SIZE);
    var c_balance = new Array(BATCH_SIZE);
    var c_ytd_payment = new Array(BATCH_SIZE);
    var c_payment_cnt = new Array(BATCH_SIZE);
    var c_delivery_cnt = new Array(BATCH_SIZE);
    var c_data = new Array(BATCH_SIZE);
    
    // history
    var h_c_id = new Array(BATCH_SIZE);
    var h_c_d_id = new Array(BATCH_SIZE);
    var h_c_w_id = new Array(BATCH_SIZE);
    var h_d_id = new Array(BATCH_SIZE);
    var h_w_id = new Array(BATCH_SIZE);
    var h_date = new Array(BATCH_SIZE);
    var h_amount = new Array(BATCH_SIZE);
    var h_data = new Array(BATCH_SIZE);
    
    for (var districtId = 1; districtId <= 10; districtId++) {
        for (var customerId = 1; customerId <= 3000; customerId++) {
            var index = (customerId - 1) % BATCH_SIZE;
            
            // customer
            c_id[index] = customerId;
            c_d_id[index] = districtId;
            c_w_id[index] = warehouseId;
            c_first[index] = randomString(8, 16);
            c_middle[index] = "OE";
            
            if (customerId <= 1000) {
                c_last[index] = lastName(customerId - 1);
            } else {
                c_last[index] = lastName(nonUniformRandom(255, 0, 999));
            }
            
            c_street_1[index] = randomString(10, 20);
            c_street_2[index] = randomString(10, 20);
            c_city[index] = randomString(10, 20);
            c_state[index] = randomString(2, 2);
            c_zip[index] = (random(10000, 19999) + "11111").substring(1);
            c_phone[index] = String(random(10000000000000000, 19999999999999999)).substring(1);
            c_since[index] = new Date();
            
            if (random(1, 10) == 1) {
                c_credit[index] = "BC";
            } else {
                c_credit[index] = "GC";
            }
            
            c_credit_lim[index] = 50000;
            c_discount[index] = random(0, 5000) / 10000;
            c_balance[index] = -10;
            c_ytd_payment[index] = 10;
            c_payment_cnt[index] = 1;
            c_delivery_cnt[index] = 0;
            c_data[index] = randomString(300, 500);
            
            
            // history
            h_c_id[index] = customerId;
            h_c_d_id[index] = districtId;
            h_c_w_id[index] = warehouseId;
            h_d_id[index] = districtId;
            h_w_id[index] = warehouseId;
            h_date[index] = new Date();
            h_amount[index] = 10;
            h_data[index] = randomString(12, 24);
            
            if (customerId % BATCH_SIZE == 0) {
                executeBatch("INSERT INTO customer "
                    + "(c_id, c_d_id, c_w_id, c_first, c_middle, c_last, "
                    + "c_street_1, c_street_2, c_city, c_state, c_zip, c_phone, "
                    + "c_since, c_credit, c_credit_lim, c_discount, c_balance, "
                    + "c_ytd_payment, c_payment_cnt, c_delivery_cnt, c_data) "
                    + "VALUES ($int, $int, $int, $string, $string, $string, "
                    + "$string, $string, $string, $string, $string, $string, "
                    + "$timestamp, $string, $double, $double, $double, "
                    + "$double, $int, $int, $string)",
                    c_id, c_d_id, c_w_id, c_first, c_middle, c_last,
                    c_street_1, c_street_2, c_city, c_state, c_zip, c_phone, 
                    c_since, c_credit, c_credit_lim, c_discount, c_balance,
                    c_ytd_payment, c_payment_cnt, c_delivery_cnt, c_data);
                
                executeBatch("INSERT INTO history "
                    + "(h_c_id, h_c_d_id, h_c_w_id, h_d_id, "
                    + "h_w_id, h_date, h_amount, h_data) "
                    + "VALUES ($int, $int, $int, $int, "
                    + "$int, $timestamp, $double, $string)",
                    h_c_id, h_c_d_id, h_c_w_id, h_d_id,
                    h_w_id, h_date, h_amount, h_data);
                
                if (customerId % COMMIT_SIZE == 0) {
                    commit();
                    
                    if (((districtId - 1) * 3000 + customerId) % PRINT_SIZE == 0) {
                        info("[Agent " + getId() + "] customer : "
                            + ((districtId - 1) * 3000 + customerId) + " / 30000");
                    }
                }
            }
        }
    }
}

function loadStock(warehouseId) {
    info("[Agent " + getId() + "] Loading stock ...");
    
    var s_i_id = new Array(BATCH_SIZE);
    var s_w_id = new Array(BATCH_SIZE);
    var s_quantity = new Array(BATCH_SIZE);
    var s_dist_01 = new Array(BATCH_SIZE);
    var s_dist_02 = new Array(BATCH_SIZE);
    var s_dist_03 = new Array(BATCH_SIZE);
    var s_dist_04 = new Array(BATCH_SIZE);
    var s_dist_05 = new Array(BATCH_SIZE);
    var s_dist_06 = new Array(BATCH_SIZE);
    var s_dist_07 = new Array(BATCH_SIZE);
    var s_dist_08 = new Array(BATCH_SIZE);
    var s_dist_09 = new Array(BATCH_SIZE);
    var s_dist_10 = new Array(BATCH_SIZE);
    var s_ytd = new Array(BATCH_SIZE);
    var s_order_cnt = new Array(BATCH_SIZE);
    var s_remote_cnt = new Array(BATCH_SIZE);
    var s_data = new Array(BATCH_SIZE);
    
    for (var itemId = 1; itemId <= 100000; itemId++) {
        var index = (itemId - 1) % BATCH_SIZE;
        
        s_i_id[index] = itemId;
        s_w_id[index] = warehouseId;
        s_quantity[index] = random(10, 100);
        s_dist_01[index] = randomString(24, 24);
        s_dist_02[index] = randomString(24, 24);
        s_dist_03[index] = randomString(24, 24);
        s_dist_04[index] = randomString(24, 24);
        s_dist_05[index] = randomString(24, 24);
        s_dist_06[index] = randomString(24, 24);
        s_dist_07[index] = randomString(24, 24);
        s_dist_08[index] = randomString(24, 24);
        s_dist_09[index] = randomString(24, 24);
        s_dist_10[index] = randomString(24, 24);
        s_ytd[index] = 0;
        s_order_cnt[index] = 0;
        s_remote_cnt[index] = 0;
        s_data[index] = randomString(26, 50);
        
        if (random(1, 10) == 1) {
            var replace = random(0, s_data[index].length - 8);
            
            s_data[index] =
                s_data[index].substring(0, replace)
                + "ORIGINAL"
                + s_data[index].substring(replace + 8);
        }
        
        if (itemId % BATCH_SIZE == 0) {
            executeBatch("INSERT INTO stock "
                + "(s_i_id, s_w_id, s_quantity, s_dist_01, s_dist_02, s_dist_03, "
                + "s_dist_04, s_dist_05, s_dist_06, s_dist_07, s_dist_08, s_dist_09, "
                + "s_dist_10, s_ytd, s_order_cnt, s_remote_cnt, s_data) "
                + "VALUES ($int, $int, $int, $string, $string, $string, "
                + "$string, $string, $string, $string, $string, $string, "
                + "$string, $int, $int, $int, $string)",
                s_i_id, s_w_id, s_quantity, s_dist_01, s_dist_02, s_dist_03,
                s_dist_04, s_dist_05, s_dist_06, s_dist_07, s_dist_08, s_dist_09,
                s_dist_10, s_ytd, s_order_cnt, s_remote_cnt, s_data);
            
            if (itemId % COMMIT_SIZE == 0) {
                commit();
                
                if (itemId % PRINT_SIZE == 0) {
                    info("[Agent " + getId() + "] stock : " + itemId + " / 100000");
                }
            }
        }
    }
}

function loadOrders(warehouseId) {
    info("[Agent " + getId() + "] Loading orders, new_orders and order_line ...");
    
    // orders
    var o_id = new Array(BATCH_SIZE);
    var o_d_id = new Array(BATCH_SIZE);
    var o_w_id = new Array(BATCH_SIZE);
    var o_c_id = new Array(BATCH_SIZE);
    var o_entry_d = new Array(BATCH_SIZE);
    var o_carrier_id = new Array(BATCH_SIZE);
    var o_ol_cnt = new Array(BATCH_SIZE);
    var o_all_local = new Array(BATCH_SIZE);
    
    // new_orders
    var no_o_id = new Array();
    var no_d_id = new Array();
    var no_w_id = new Array();
    
    // order_line
    var ol_o_id = new Array();
    var ol_d_id = new Array();
    var ol_w_id = new Array();
    var ol_number = new Array();
    var ol_i_id = new Array();
    var ol_supply_w_id = new Array();
    var ol_delivery_d = new Array();
    var ol_quantity = new Array();
    var ol_amount = new Array();
    var ol_dist_info = new Array();
    
    for (var districtId = 1; districtId <= 10; districtId++) {
        var customerSequence = new Array(3000);
        var rand;
        var swap;
        
        for (var index = 0; index < 3000; index++) {
            customerSequence[index] = index + 1;
        }
        
        // Fisher-Yates algorithm
        for (var tail = 3000 - 1; tail > 0; tail--) {
            rand = random(0, tail);
            swap = customerSequence[tail];
            customerSequence[tail] = customerSequence[rand];
            customerSequence[rand] = swap;
        }
        
        for (var orderId = 1; orderId <= 3000; orderId++) {
            var index = (orderId - 1) % BATCH_SIZE;
            
            // orders
            o_id[index] = orderId;
            o_d_id[index] = districtId;
            o_w_id[index] = warehouseId;
            o_c_id[index] = customerSequence[orderId - 1];
            o_entry_d[index] = new Date();
            
            if (orderId < 2101) {
                o_carrier_id[index] = random(1, 10);
            } else {
                o_carrier_id[index] = null;
            }
            
            o_ol_cnt[index] = random(5, 15);
            o_all_local[index] = 1;
            
            // new_orders
            if (orderId >= 2101) {
                no_o_id.push(orderId);
                no_d_id.push(districtId);
                no_w_id.push(warehouseId);
            }
            
            // order_line
            for (var orderLineId = 1; orderLineId <= o_ol_cnt[index]; orderLineId++) {
                ol_o_id.push(orderId);
                ol_d_id.push(districtId);
                ol_w_id.push(warehouseId);
                ol_number.push(orderLineId);
                ol_i_id.push(random(1, 100000));
                ol_supply_w_id.push(warehouseId);
                
                if (orderId < 2101) {
                    ol_delivery_d.push(o_entry_d[index]);
                    ol_amount.push(0);
                } else {
                    ol_delivery_d.push(null);
                    ol_amount.push(random(1, 999999) / 100);
                }
                
                ol_quantity.push(5);
                ol_dist_info.push(randomString(24, 24));
            }
            
            if (orderId % BATCH_SIZE == 0) {
                executeBatch("INSERT INTO orders "
                    + "(o_id, o_d_id, o_w_id, o_c_id, o_entry_d, "
                    + "o_carrier_id, o_ol_cnt, o_all_local) "
                    + "VALUES ($int, $int, $int, $int, $timestamp, "
                    + "$int, $int, $int)",
                    o_id, o_d_id, o_w_id, o_c_id, o_entry_d,
                    o_carrier_id, o_ol_cnt, o_all_local);
                
                executeBatch("INSERT INTO new_orders "
                    + "(no_o_id, no_d_id, no_w_id) "
                    + "VALUES ($int, $int, $int)",
                    no_o_id, no_d_id, no_w_id);
                
                no_o_id.length = 0;
                no_d_id.length = 0;
                no_w_id.length = 0;
                
                executeBatch("INSERT INTO order_line "
                    + "(ol_o_id, ol_d_id, ol_w_id, ol_number, ol_i_id, ol_supply_w_id, "
                    + "ol_delivery_d, ol_quantity, ol_amount, ol_dist_info) "
                    + "VALUES ($int, $int, $int, $int, $int, $int, "
                    + "$timestamp, $int, $double, $string)",
                    ol_o_id, ol_d_id, ol_w_id, ol_number, ol_i_id, ol_supply_w_id,
                    ol_delivery_d, ol_quantity, ol_amount, ol_dist_info);
                
                ol_o_id.length = 0;
                ol_d_id.length = 0;
                ol_w_id.length = 0;
                ol_number.length = 0;
                ol_i_id.length = 0;
                ol_supply_w_id.length = 0;
                ol_delivery_d.length = 0;
                ol_quantity.length = 0;
                ol_amount.length = 0;
                ol_dist_info.length = 0;
                
                if (orderId % COMMIT_SIZE == 0) {
                    commit();
                    
                    if (((districtId - 1) * 3000 + orderId) % PRINT_SIZE == 0) {
                        info("[Agent " + getId() + "] orders : "
                            + ((districtId - 1) * 3000 + orderId) + " / 30000");
                    }
                }
            }
        }
    }
}
*/


function nonUniformRandom(a, x, y) {
    var c = 0;
    
    switch (a) {
        case 255:
            c = C_255;
            break;
        case 1023:
            c = C_1023;
            break;
        case 8191:
            c = C_8191;
            break;
        default:
            c = 0;
    }
    
    return (((random(0, a) | random(x, y)) + c) % (y - x + 1)) + x;
}

function randomString(minLength, maxLength) {
    if (!ALPHA_NUMERIC_2) {
        ALPHA_NUMERIC_2 = new Array(3844);
        
        for (var i = 0; i < 62; i++) {
            for (var j = 0; j < 62; j++) {
                ALPHA_NUMERIC_2[i * 62 + j] = ALPHA_NUMERIC[i] + ALPHA_NUMERIC[j];
            }
        }
    }
    
    var length = random(minLength, maxLength);
    var index = 0;
    var rand = 0;
    var rest = 0;
    var string = "";
    
    while (index < length) {
        if (rest == 0) {
            rand = random(0, 218340105584895);
            rest = 8;
        }
        
        if (index + 1 < length) {
            var code = rand % 3844;
            string += ALPHA_NUMERIC_2[code];
            rand = (rand - code) / 3844;
            rest -= 2;
            index += 2;
        } else {
            var code = rand % 62;
            string += ALPHA_NUMERIC[code];
            break;
        }
    }
    
    return string;
}

function lastName(seed) {
    return SYLLABLE[Math.floor(seed / 100)]
        + SYLLABLE[Math.floor(seed / 10) % 10]
        + SYLLABLE[seed % 10];
}
