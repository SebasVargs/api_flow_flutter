class InsertDefinitions {

  static const status = '''
  INSERT INTO status (name) VALUES
  ('Pendiente'),
  ('Pagado'),
  ('Vencido'),
  ('Cancelado'),
  ('Reembolsado')
  ''';

  static const measure = '''
  INSERT INTO measure (name) VALUES
  ('Tonelada'),
  ('Kilogramo'),
  ('Gramo'),
  ('Litro'),
  ('Mililitro'),
  ('Metro cubico'),
  ('Onza')
  ''';

  static const category = '''
  INSERT INTO category (name) VALUES
  ('Guanabana'),
  ('Mora'),
  ('Fresa'),
  ('Guayaba'),
  ('Piña')
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

}