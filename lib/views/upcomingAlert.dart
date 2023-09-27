import 'package:easy_maintenance/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import '../entities/databaseClient.dart';
import '../generated/l10n.dart';
import '../models/vehicle.dart';

class UpcomingAlert extends StatefulWidget {
  const UpcomingAlert({super.key});

  @override
  State<UpcomingAlert> createState() => _UpcomingAlertState();
}

class _UpcomingAlertState extends State<UpcomingAlert> {
  // Récuperer la liste des véhicules :
  List<Vehicle> allVehiclesList = [];
  getVehicles() async {
    final FromDb = await DatabaseClient().allVehicles();
    setState(() {
      allVehiclesList = FromDb;
    });
  }

  // Appeler la fonction pour récuperer tous les véhicules au chargement de la page :
  @override
  void initState() {
    getVehicles();
    super.initState();
  }

  // Fonction pour vérifier si la date arrivera avant les 6 prochains mois
  bool isDateBeforeSixMonths(String? controlDate) {
    if (controlDate == null) {
      return false;
    }

    // Convertir la date en objet DateTime
    DateTime technicalControlDate =
        DateFormat(S.of(context).dateFormat).parse(controlDate);

    // Obtenir la date actuelle
    DateTime now = DateTime.now();

    // Ajouter 6 mois à la date actuelle
    DateTime sixMonthsFromNow = now.add(const Duration(days: 6 * 30));

    // Comparer si la date de contrôle technique est avant les 6 prochains mois
    return technicalControlDate.isBefore(sixMonthsFromNow);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(child: Text(S.of(context).alertTitlePage))),
      body: VehicleListWidget(
        vehicles: allVehiclesList,
        isDateBeforeSixMonths: isDateBeforeSixMonths,
      ),
      bottomNavigationBar: _BottomAppBar(),
    );
  }
}

// Bottom menu :
class _BottomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          IconButton(
            iconSize: 35,
            tooltip: 'home',
            icon: const Icon(Icons.home_rounded),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
          ),
          IconButton(
            iconSize: 35,
            tooltip: 'account',
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UpcomingAlert()));
            },
          ),
        ]));
  }
}

class VehicleListWidget extends StatelessWidget {
  final List<Vehicle> vehicles;
  Function(String? controlDate) isDateBeforeSixMonths;

  VehicleListWidget(
      {required this.vehicles, required this.isDateBeforeSixMonths});

  @override
  Widget build(BuildContext context) {
    List<Vehicle> vehiclesBeforeSixMonthsForTechnicalControlDate =
        vehicles.where((vehicle) {
      return isDateBeforeSixMonths(vehicle.nextTechnicalControlDate);
    }).toList();

    List<Vehicle> vehiclesBeforeSixMonthsForRevisionDate =
        vehicles.where((vehicle) {
      return isDateBeforeSixMonths(vehicle.nextRevisionDate);
    }).toList();

    return ListView.separated(
      shrinkWrap: true,
      itemCount: 4, // Nombre total d'éléments : 2 listes + 2 textes
      separatorBuilder: (context, index) {
        return const Divider(height: 2);
      },
      itemBuilder: (context, index) {
        if (index == 0) {
          // Texte pour la section "Contrôle technique"
          return Padding(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              title: Center(child: Text(S.of(context).technicalControl)),
            ),
          );
        } else if (index == 1) {
          // Liste pour les véhicules avec prochain contrôle technique
          if (vehiclesBeforeSixMonthsForTechnicalControlDate.isNotEmpty) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: vehiclesBeforeSixMonthsForTechnicalControlDate.length,
              itemBuilder: (context, listIndex) {
                Vehicle vehicle =
                    vehiclesBeforeSixMonthsForTechnicalControlDate[listIndex];
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(vehicle.model),
                    subtitle: Text(
                        "${S.of(context).subtitleCtTile} ${vehicle.nextTechnicalControlDate}"),
                    trailing:
                        const Icon(Icons.warning_rounded, color: Colors.red),
                  ),
                );
              },
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                title: const Center(
                    child: Icon(Icons.check_circle, color: Colors.green)),
                subtitle: Center(child: Text(S.of(context).ctIsEmpty)),
              ),
            );
          }
        } else if (index == 2) {
          // Texte pour la section "Révision"
          return Padding(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              title: Center(child: Text(S.of(context).revision)),
            ),
          );
        } else {
          // Liste pour les véhicules avec prochaine révision
          if (vehiclesBeforeSixMonthsForRevisionDate.isNotEmpty) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: vehiclesBeforeSixMonthsForRevisionDate.length,
              itemBuilder: (context, listIndex) {
                Vehicle vehicle =
                    vehiclesBeforeSixMonthsForRevisionDate[listIndex];
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(vehicle.model),
                    subtitle: Text(
                        "${S.of(context).subtitleRevisionTile} ${vehicle.nextRevisionDate}"),
                    trailing:
                        const Icon(Icons.warning_rounded, color: Colors.red),
                  ),
                );
              },
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                title: const Center(
                    child: Icon(Icons.check_circle, color: Colors.green)),
                subtitle: Center(child: Text(S.of(context).revisionIsEmpty)),
              ),
            );
          }
        }
      },
    );
  }
}
