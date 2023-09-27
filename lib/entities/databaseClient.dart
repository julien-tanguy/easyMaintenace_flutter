import 'dart:io';
import 'package:easy_maintenance/models/vehicle.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseClient {
  // Acceder a la base de donées :
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // sinon, creer la database :
    return await createDatabase();
  }

  Future<Database> createDatabase() async {
    // Récuperer le directory qui appartient a dart.io, récupere les dossier de l'application :
    Directory directory = await getApplicationSupportDirectory();
    // Créer un chemin pour la base de données, ne pas oublier l'import de path.dart :
    final path = join(directory.path, 'database.db');
    return await openDatabase(path, version: 1, onCreate: onCreate);
  }

  onCreate(Database database, int version) async {
    await database.execute('''
      CREATE TABLE vehicle(
        id INTEGER PRIMARY KEY,
        model TEXT NOT NULL,
        version TEXT NOT NULL,
        nextRevisionDate TEXT,
        nextRevisionDistance TEXT,
        frontTirePressure REAL,
        rearTirePressure REAL,
        nextTechnicalControlDate TEXT,
        fuel TEXT NOT NULL,
        freeInformations TEXT NOT NULL,
        type TEXT NOT NULL
      )
    ''');
  }

  // Récupere tous les véhicules :
  Future<List<Vehicle>> allVehicles() async {
    Database db = await database;
    const query = 'SELECT * FROM vehicle';
    // Je recupere une list de map string, dynamic :
    List<Map<String, dynamic>> mapList = await db.rawQuery(query);
    // Passer a travers chacun des éléments (map) et creer un itemList avec le resultat de (map) et les convertir en list
    return mapList.map((map) => Vehicle.fromMap(map)).toList();
  }

  // Supprimer un véhicule via son id :
  // Retourner future bool car return true pour ok  :
  Future<bool> deleteVehiculeWhereId(Vehicle vehicle) async {
    Database db = await database;
    await db.delete('vehicle', where: 'id = ?', whereArgs: [vehicle.id]);
    return true;
  }

  // modifier un véhicule via son id :
  // Retourner future bool car return true pour ok  :
  Future<bool> updateVehiculeWhereId(Vehicle vehicle) async {
    Database db = await database;
    await db.update('vehicle', vehicle.toMap(),
        where: 'id = ?', whereArgs: [vehicle.id]);
    return true;
  }

  // Ajouter un vehicule a la base de donnée :
  // Retourner future bool car return true pour ok  :
  Future<bool> addVehicle(Vehicle vehicle) async {
    Database db = await database;
    // vehicle.id attend l'insert pour etre defini pendant l'insertion a la base de données via le vehicle.toMap() :
    vehicle.id = await db.insert('vehicle', vehicle.toMap());
    return true;
  }
}
