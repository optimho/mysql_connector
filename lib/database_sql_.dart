/// @dart=2.9
/// dependencies:
// database has got to have a database called example
// galileo_sqljocky5: ^3.0.0


import 'dart:io';
import 'package:galileo_sqljocky5/sqljocky.dart';

/// Drops the tables if they already exist
Future<void> dropTables(MySqlConnection conn) async {
  print("Dropping tables ...");
  await conn.execute("DROP TABLE IF EXISTS pets, people");
  print("Dropped tables!");
}

Future<void> createTables(MySqlConnection conn) async {
  print("Creating tables ...");
  await conn.execute('CREATE TABLE people (id INTEGER NOT NULL auto_increment, '
      'name VARCHAR(255), '
      'age INTEGER, '
      'PRIMARY KEY (id))');
  await conn.execute('CREATE TABLE pets (id INTEGER NOT NULL auto_increment, '
      'name VARCHAR(255), '
      'species TEXT, '
      'owner_id INTEGER, '
      'PRIMARY KEY (id),'
      'FOREIGN KEY (owner_id) REFERENCES people (id))');
  print("Created table!");
}

Future<void> insertRows1(MySqlConnection conn) async {
  print("Inserting rows ...");

  List<StreamedResults> r1 = await (await conn
      .preparedWithAll("INSERT INTO people (name, age) VALUES (?, ?)", [
    ["Dave", 15],
    ["John", 16],
    ["Mavis", 93],
    ["Michael", 53],
  ])).toList();
  print("People table insert ids: " + r1.map((r) => r.insertId).toString());
}

Future<void> insertRows2(MySqlConnection conn) async {
  print("Inserting more rows ...");

  List<StreamedResults> r2 = await (await conn.preparedWithAll(
      "INSERT INTO pets (name, species, owner_id) VALUES (?, ?, ?)", [
    ["Rover", "Dog", 1],
    ["Daisy", "Cow", 2],
    ["Spot", "Dog", 2],
    ["indy", "bird", 4],
  ])).toList();
  print("Pet table insert ids: " + r2.map((r) => r.insertId).toString());
  print("Rows inserted!");
}


Future<void> readData(MySqlConnection conn) async {
  print('Print out the owners of pets');
  StreamedResults result =
  await conn.execute('SELECT p.id, p.name, p.age, t.name AS pet, t.species '
      'FROM people p '
      'LEFT JOIN pets t ON t.owner_id = p.id');
  await for (Row r in result) {
    print(r.byName('name'));
  }
}
  Future<void> owners(MySqlConnection conn) async {
  print('Print out the owners');
    StreamedResults result =
    await conn.execute('SELECT * FROM people');
    await for (Row r in result) {
      print(r.byName('name'));
    }
  }

main() async {
  var s = ConnectionSettings(
    user: "root",
    password: "my_password",
    host: "localhost",
    port: 3306,
    db: "example",
  );

  // create a connection
  print("Opening connection ...");
  var conn = await MySqlConnection.connect(s);
  print("Opened connection!");

  await dropTables(conn);
  await createTables(conn);
  await insertRows1(conn);
  await insertRows2(conn);
  await readData(conn);
  await owners(conn);
  await conn.close();
}