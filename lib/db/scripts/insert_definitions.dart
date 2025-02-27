class InsertDefinitions {
  static const methOfPayment = '''
  INSERT INTO meth_of_payment (name) VALUES
  ('Contado'),
  ('Crédito'),
  ('Cuotas'),
  ('Contra entrega'),
  ('Anticipado')
  ''';

  static const documentType = '''
  INSERT INTO document_type (name) VALUES
  ('Cédula de Ciudadanía'),
  ('Tarjeta de Identidad'),
  ('Registro Civil'),
  ('Cédula de Extranjería'),
  ('Pasaporte')
  ''';

  static const statusBill = '''
  INSERT INTO status_bill (name) VALUES
  ('Pendiente'),
  ('Pagado')
  ''';

  static const measure = '''
  INSERT INTO measure (name) VALUES
  ('NIU'),
  ('Tonelada'),
  ('Kilogramo'),
  ('Libra'),
  ('Gramo'),
  ('Litro'),
  ('Mililitro'),
  ('Metro cubico'),
  ('Onza')
  ''';

  static const categorySup = '''
  INSERT INTO category_sup (name) VALUES
  ('Lulo'),
  ('Guanábana'),
  ('Guayaba'),
  ('Fresa'),
  ('Mora'),
  ('Mango'),
  ('Piña'),
  ('Maracuyá')
  ''';

  static const categoryPro = '''
  INSERT INTO category_pro (name) VALUES
  ('Lulo'),
  ('Guanábana'),
  ('Guayaba'),
  ('Fresa'),
  ('Mora'),
  ('Mango'),
  ('Piña'),
  ('Maracuyá'),
  ('Maracumango'),
  ('Limonada de feijoa'),
  ('Tomate de árbol'),
  ('Frutos rojos')
  ''';

  static const type = '''
  INSERT INTO type (name) VALUES
  ('Mayorista'),
  ('Minorista')
  ''';

  static const paymentMeth = '''
  INSERT INTO payment_meth (name) VALUES
  ('Efectivo'),
  ('Tarjeta'),
  ('Transferencia'),
  ('Cheque'),
  ('Mercado Pago')
  ''';

  static const typeCash = '''
  INSERT INTO type_cash (name) VALUES
  ('Ingreso'),
  ('Egreso')
  ''';

  static const conceptCash = '''
  INSERT INTO concept_cash (name) VALUES
  ('Venta'),
  ('Gasto'),
  ('Compra'),
  ('Salario'),
  ('Alquiler'),
  ('Publicidad'),
  ('Impuestos')
  ''';

  static const city = '''
  INSERT INTO city (name) VALUES
  ('Duitama'),
  ('Paipa'),
  ('Santa Rosa de Viterbo'),
  ('Sogamoso'),
  ('Nobsa'),
  ('Floresta'),
  ('Belén'),
  ('Tibasosa'),
  ('Corrales'),
  ('Busbanzá'),
  ('Betéitiva'),
  ('Iza'),
  ('Firavitoba'),
  ('Pesca'),
  ('Toca'),
  ('Tunja'),
  ('Chivatá'),
  ('Gámeza'),
  ('Tópaga'),
  ('Monguí'),
  ('Mongua'),
  ('Bucaramanga'),
  ('Floridablanca'),
  ('Girón'),
  ('Piedecuesta'),
  ('Barrancabermeja'),
  ('San Gil'),
  ('Socorro'),
  ('Barranco de Loba'),
  ('Málaga'),
  ('Sabana de Torres'),
  ('Other')
  ''';

  static const department = '''
  INSERT INTO department (name) VALUES
  ('Boyacá'),
  ('Santander'),
  ('Cundinamarca'),
  ('Meta'),
  ('Casanare'),
  ('Arauca')
  ''';

  static const user = '''
  INSERT INTO user (name, username, email, password, image_uri) VALUES
  ('Laura Barroso', 'laura', 'laurabarroso@gmail.com', 'root', '')
  ''';
}
