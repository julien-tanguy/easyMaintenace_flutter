import 'package:easy_maintenance/entities/databaseClient.dart';
import 'package:easy_maintenance/models/vehicle.dart';
import 'package:easy_maintenance/generated/l10n.dart';
import 'package:easy_maintenance/views/addVehicle.dart';
import 'package:easy_maintenance/views/upcomingAlert.dart';
import 'package:easy_maintenance/views/vehicleDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Récuperer la liste des véhicules :
  List<Vehicle> allVehiclesList = [];
  getVehicles() async {
    final FromDb = await DatabaseClient().allVehicles();
    setState(() {
      allVehiclesList = FromDb;
    });
  }

  iconByType(Vehicle vehicle) {
    Icon icon;
    if (vehicle.type == "car") {
      icon = const Icon(Icons.directions_car);
    } else if (vehicle.type == "bike") {
      icon = const Icon(Icons.two_wheeler);
    } else {
      icon = const Icon(Icons.directions_boat);
    }
    return icon;
  }

  // Supprimer un véhicule :
  deleteVehicle(Vehicle vehicle) {
    DatabaseClient()
        // Appele la méthode deleteVehiculeWhereId de l'objet DatabaseClient :
        .deleteVehiculeWhereId(vehicle)
        // Si la méthode s'execute, il y a un succés et donc on appele getVehicles pour mettre a jour les données :
        .then((succes) => getVehicles());
  }

  // Acceder au détail du véhicule :
  getVehicleDetail(Vehicle vehicle) {
    final nextPage = VehicleDetail(vehicle: vehicle);
    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (context) => nextPage);
    Navigator.of(context).push(materialPageRoute);
  }

  @override
  void initState() {
    getVehicles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              child: Image.asset(
                "images/logo_EM.png",
                height: 25,
              ),
            ),
            const Text(
              " Easy Maintenance",
              style: TextStyle(color: Color(0xFF5a6877)),
            )
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: allVehiclesList.isEmpty
          // Ternaire pour verfifier si la liste est vide
          //Si vide remplacer par une informations pour l'utilisateur :
          ? Padding(
              padding: const EdgeInsets.all(10),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                leading:
                    const Icon(Icons.info_rounded, color: Color(0xFF2e353d)),
                title: Text(S.of(context).titleListVehicleHomeIsEmpty),
                subtitle: Text(S.of(context).subTitleListVehicleHomeIsEmpty),
              ))
          // Si non, afficher les véhicules :
          : ListView.separated(
              padding: const EdgeInsets.all(10),
              itemBuilder: ((context, index) {
                final vehicleDetail = allVehiclesList[index];
                return _VehicleCard(
                  vehicle: vehicleDetail,
                  deleteVehicle: deleteVehicle,
                  getVehicleDetail: getVehicleDetail,
                  iconVehicle: iconByType(vehicleDetail),
                );
              }),
              separatorBuilder: ((context, index) => const Divider(
                    height: 2,
                  )),
              itemCount: allVehiclesList.length),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddVehicle()));
        },
        tooltip: 'add',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _BottomAppBar(),
    );
  }
}

//Bottom menu :
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

// Vehicle detail card :
class _VehicleCard extends StatelessWidget {
  Vehicle vehicle;
  Function(Vehicle) deleteVehicle;
  Function(Vehicle) getVehicleDetail;

  Icon iconVehicle;
  _VehicleCard(
      {super.key,
      required this.vehicle,
      required this.deleteVehicle,
      required this.getVehicleDetail,
      required this.iconVehicle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        onTap: () => getVehicleDetail(vehicle),
        leading: iconVehicle,
        title: Text(
          vehicle.model,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: false,
        ),
        subtitle: Text(
          vehicle.version,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: false,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_sharp),
          onPressed: () => deleteVehicle(vehicle),
        ));
  }
}
