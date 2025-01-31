class TableDefinitios {

  static const status = '''
  CREATE TABLE status (
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

  static const category = '''
  CREATE TABLE category (
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
  name TEXT not null,
  phone TEXT not null,
  email TEXT null,
  address TEXT not null
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
  id_client INTEGER not null,
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
  name TEXT not null,
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
  name TEXT not null,
  phone TEXT not null,
  email TEXT null,
  address TEXT not null
  )
  ''';

  static const buys = '''
  CREATE TABLE buys (
  id INTEGER PRIMARY KEY,
  date_buy DATETIME,
  total DOUBLE,
  id_supplier INTEGER not null,
  id_status INTEGER not null,
  FOREIGN KEY (id_supplier) REFERENCES supplier(id),
  FOREIGN KEY (id_status) REFERENCES status(id)
  )
  ''';

  static const supply = '''
  CREATE TABLE supply (
  id INTEGER PRIMARY KEY,
  name TEXT not null,
  stock INTEGER not null,
  weight DOUBLE not null,
  unit_cost DOUBLE not null,
  id_measure INTEGER not null,
  FOREIGN KEY (id_measure) REFERENCES measure(id)
  )
  ''';

  static const buysDetail = '''
  CREATE TABLE buys_detail (
  id INTEGER PRIMARY KEY,
  amount INTEGER not null,
  unit_price DOUBLE not null,
  sub_total DOUBLE not null,
  id_buys INTEGER not null,
  id_supply INTEGER not null,
  FOREIGN KEY (id_buys) REFERENCES buys(id),
  FOREIGN KEY (id_supply) REFERENCES supply(id)
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
}