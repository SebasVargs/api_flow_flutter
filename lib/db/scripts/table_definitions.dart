class TableDefinitios {

  static const methOfPayment = '''
  CREATE TABLE meth_of_payment (
  id INTEGER PRIMARY KEY,
  name TEXT not null
  )
  ''';

  static const documentType = '''
  CREATE TABLE document_type (
  id INTEGER PRIMARY KEY,
  name TEXT not null
  )
  ''';

  static const city = '''
  CREATE TABLE city (
  id INTEGER PRIMARY KEY,
  name TEXT not null
  )
  ''';

  static const department = '''
  CREATE TABLE department (
  id INTEGER PRIMARY KEY,
  name TEXT not null
  )
  ''';

  static const statusBill = '''
  CREATE TABLE status_bill (
  id INTEGER PRIMARY KEY,
  name TEXT not null
  )
  ''';

  static const measure = '''
  CREATE TABLE measure (
  id INTEGER PRIMARY KEY,
  name TEXT not null
  )
  ''';

  static const categorySup = '''
  CREATE TABLE category_sup (
  id INTEGER PRIMARY KEY,
  name TEXT not null
  )
  ''';

  static const categoryPro = '''
  CREATE TABLE category_pro (
  id INTEGER PRIMARY KEY,
  name TEXT not null
  )
  ''';

  static const type = '''
  CREATE TABLE type (
  id INTEGER PRIMARY KEY,
  name TEXT not null
  )
  ''';

  static const client = '''
  CREATE TABLE client (
  id INTEGER PRIMARY KEY,
  company_name TEXT not null,
  document_number TEXT not null,
  address TEXT not null,
  phone TEXT not null,
  email TEXT null,
  id_document_type INTEGER not null,
  id_city INTEGER not null,
  id_department INTEGER not null,
  FOREIGN KEY (id_document_type) REFERENCES document_type(id),
  FOREIGN KEY (id_city) REFERENCES city(id),
  FOREIGN KEY (id_department) REFERENCES department(id)
  )
  ''';

  static const clienType = '''
  CREATE TABLE client_type (
  id_client INTEGER not null,
  id_type INTEGER not null,
  PRIMARY KEY (id_client, id_type),
  FOREIGN KEY (id_client) REFERENCES client(id),
  FOREIGN KEY (id_type) REFERENCES type(id)
  )
  ''';

  static const sale = '''
  CREATE TABLE sale (
  id INTEGER PRIMARY KEY,
  sell_date DATETIME not null,
  total DOUBLE not null,
  discount DOUBLE null,
  id_status INTEGER not null,
  id_client INTEGER null,
  FOREIGN KEY (id_status) REFERENCES status(id),
  FOREIGN KEY (id_client) REFERENCES client(id)
  )
  ''';

  static const paymentMeth = '''
  CREATE TABLE payment_meth (
  id INTEGER PRIMARY KEY,
  name TEXT not null
  )
  ''';

  static const salePayment = '''
  CREATE TABLE sale_payment (
  id_payment_meth INTEGER not null,
  id_sale INTEGER not null,
  PRIMARY KEY (id_payment_meth, id_sale),
  FOREIGN KEY (id_payment_meth) REFERENCES payment_meth(id),
  FOREIGN KEY (id_sale) REFERENCES sale(id)
  )
  ''';

  static const product = '''
  CREATE TABLE product (
  id INTEGER PRIMARY KEY,
  product_code TEXT not null,
  description TEXT not null,
  unit_price DOUBLE not null,
  unit_cost DOUBLE not null,
  stock INTEGER not null,
  id_measure INTEGER not null,
  id_category INTEGER not null,
  FOREIGN KEY (id_measure) REFERENCES measure(id),
  FOREIGN KEY (id_category) REFERENCES category(id)
  )
  ''';

  static const supplier = '''
  CREATE TABLE supplier (
  id INTEGER PRIMARY KEY,
  company_name TEXT not null,
  document_number TEXT not null,
  address TEXT not null,
  phone TEXT not null,
  email TEXT null,
  id_document_type INTEGER not null,
  id_city INTEGER not null,
  id_department INTEGER not null,
  FOREIGN KEY (id_document_type) REFERENCES document_type(id),
  FOREIGN KEY (id_city) REFERENCES city(id),
  FOREIGN KEY (id_department) REFERENCES department(id)
  )
  ''';

  static const buys = '''
  CREATE TABLE buys (
  id INTEGER PRIMARY KEY,
  date_buy DATETIME,
  total DOUBLE,
  id_supplier INTEGER null,
  id_status_bill INTEGER not null,
  FOREIGN KEY (id_supplier) REFERENCES supplier(id),
  FOREIGN KEY (id_status_bill) REFERENCES status(id)
  )
  ''';

  static const supply = '''
  CREATE TABLE supply (
  id INTEGER PRIMARY KEY,
  name TEXT not null,
  stock INTEGER not null,
  weight DOUBLE null,
  size TEXT null,
  unit_cost DOUBLE not null,
  id_measure INTEGER not null,
  id_buys INTEGER not null,
  id_category INTEGER not null,
  FOREIGN KEY (id_buys) REFERENCES buys(id),
  FOREIGN KEY (id_category) REFERENCES category(id),
  FOREIGN KEY (id_measure) REFERENCES measure(id)
  )
  ''';

  static const saleDetail = '''
  CREATE TABLE sale_detail (
  id INTEGER PRIMARY KEY,
  amount INTEGER not null,
  unit_price DOUBLE not null,
  sub_total DOUBLE not null,
  id_sale INTEGER not null,
  id_product INTEGER not null,
  FOREIGN KEY (id_sale) REFERENCES sale(id),
  FOREIGN KEY (id_product) REFERENCES product(id)
  )
  ''';

  static const tpyeCash = '''
  CREATE TABLE type_cash (
  id INTEGER PRIMARY KEY,
  name TEXT not null
  )
  ''';

  static const conceptCash = '''
  CREATE TABLE concept_cash (
  id INTEGER PRIMARY KEY,
  name TEXT not null
  )
  ''';

  static const cashFlow = '''
  CREATE TABLE cash_flow (
  id INTEGER PRIMARY KEY,
  cash_date DATETIME not null,
  amount DOUBLE not null,
  detail TEXT not null,
  id_sale INTEGER not null,
  id_buys INTEGER not null,
  id_type_cash INTEGER not null,
  id_concept_cash INTEGER not null,
  FOREIGN KEY (id_sale) REFERENCES sale(id),
  FOREIGN KEY (id_buys) REFERENCES buys(id),
  FOREIGN KEY (id_type_cash) REFERENCES type_cash(id),
  FOREIGN KEY (id_concept_cash) REFERENCES conceptt_cash(id)
  )
  ''';

  static const user = '''
  CREATE TABLE user (
  id INTEGER PRIMARY KEY,
  name TEXT not null,
  username TEXT not null,
  email TEXT not null,
  password TEXT not null,
  image_uri TEXT null
  )
  ''';

  static const maps = '''
  CREATE TABLE maps (
  id INTEGER PRIMARY KEY,
  name TEXT not null,
  latitude REAL not null,
  longitude REAL not null
  )
  ''';
  
  static const transmitter = '''
  CREATE TABLE transmitter (
  id INTEGER PRIMARY KEY,
  company_name TEXT not null,
  trade_name TEXT not null,
  nit TEXT not null,
  address TEXT not null,
  phone TEXT not null,
  email TEXT not null,
  economic_activity not null,
  id_document_type INTEGER not null,
  id_city INTEGER not null,
  id_department INTEGER not null,
  FOREIGN KEY (id_document_type) REFERENCES document_type(id),
  FOREIGN KEY (id_city) REFERENCES city(id),
  FOREIGN KEY (id_department) REFERENCES department(id)
  )
  ''';

  static const bill = '''
  CREATE TABLE bill (
  id INTEGER PRIMARY KEY,
  num_bill TEXT not null,
  cufe TEXT not null,
  issue_date DATETIME not null,
  expiration_date DATETIME not null,
  sub_total DOUBLE not null,
  iva DOUBLE,
  inc DOUBLE,
  other_taxes DOUBLE,
  gross_total DOUBLE not null,
  total_taxes DOUBLE,
  total_neto DOUBLE not null,
  total_bill DOUBLE not null,
  authorization_number TEXT not null,
  authorization_validity DATE,
  id_transmitter INTEGER not null,
  id_meth_of_payment INTEGER not null,
  id_payment_meth INTEGER not null,
  id_client INTEGER not null,
  FOREIGN KEY (id_transmitter) REFERENCES trasmitter(id),
  FOREIGN KEY (id_meth_of_payment) REFERENCES meth_of_payment(id),
  FOREIGN KEY (id_payment_meth) REFERENCES payment_meth(id),
  FOREIGN KEY (id_client) REFERENCES client(id)
  )
  ''';

  static const detailBill = '''
  CREATE TABLE detail_bill (
  id INTEGER PRIMARY KEY,
  product_code INTEGER not null,
  description TEXT not null,
  id_bill INTEGER not null,
  FOREIGN KEY (id_bill) REFERENCES bill(id)
  )
  ''';
}