class Vehicle {
  int? id;
  String model;
  String version;
  String? nextRevisionDate;
  String? nextRevisionDistance;
  double? frontTirePressure;
  double? rearTirePressure;
  String? nextTechnicalControlDate;
  String fuel;
  String freeInformations;
  String type;

  // Constructors :
  //Vehicle(this.model,this.version,this.nextRevisionDate,this.nextRevisionDistance,this.frontTirePressure,this.rearTirePressure,this.nextTechnicalControlDate,this.fuel,this.freeInformations);
  Vehicle(
      this.id,
      this.model,
      this.version,
      this.nextRevisionDate,
      this.nextRevisionDistance,
      this.frontTirePressure,
      this.rearTirePressure,
      this.nextTechnicalControlDate,
      this.fuel,
      this.freeInformations,
      this.type);

  Vehicle.bike(
      this.id,
      this.model,
      this.version,
      this.nextRevisionDate,
      this.nextRevisionDistance,
      this.frontTirePressure,
      this.rearTirePressure,
      this.fuel,
      this.freeInformations,
      this.type);

  Vehicle.other(this.id, this.model, this.version, this.nextRevisionDate,
      this.fuel, this.freeInformations, this.type);

  // Map récuperer via sqflite :
  Vehicle.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        model = map['model'],
        version = map['version'],
        nextRevisionDate = map['nextRevisionDate'],
        nextRevisionDistance = map['nextRevisionDistance'],
        frontTirePressure = map['frontTirePressure'],
        rearTirePressure = map['rearTirePressure'],
        nextTechnicalControlDate = map['nextTechnicalControlDate'],
        fuel = map['fuel'],
        freeInformations = map['freeInformations'],
        type = map['type'];

  // Convertir vehicle en map pour l'inserer a la base de données :
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'model': model,
      'version': version,
      'nextRevisionDate': nextRevisionDate,
      'nextRevisionDistance': nextRevisionDistance,
      'frontTirePressure': frontTirePressure,
      'rearTirePressure': rearTirePressure,
      'nextTechnicalControlDate': nextTechnicalControlDate,
      'fuel': fuel,
      'freeInformations': freeInformations,
      'type': type,
    };
    // Définir l'id de la maniere procedural pendant l'insert :
    if (id != null) map['id'] = id;
    return map;
  }
}
