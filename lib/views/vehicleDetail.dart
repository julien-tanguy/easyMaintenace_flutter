import 'package:easy_maintenance/views/upcomingAlert.dart';
import 'package:easy_maintenance/views/updateVehicle.dart';
import 'package:flutter/material.dart';
import 'package:easy_maintenance/models/vehicle.dart';
import 'package:easy_maintenance/entities/databaseClient.dart';
import 'package:intl/intl.dart';
import 'package:easy_maintenance/generated/l10n.dart';

import 'home.dart';

class VehicleDetail extends StatefulWidget {
  final Vehicle vehicle;
  const VehicleDetail({super.key, required this.vehicle});

  @override
  State<VehicleDetail> createState() => _VehicleDetailState();
}

class _VehicleDetailState extends State<VehicleDetail> {
  iconByType() {
    Icon icon;
    if (widget.vehicle.type == "car") {
      icon = const Icon(Icons.directions_car);
    } else if (widget.vehicle.type == "bike") {
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
        .then((succes) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(child: Text(widget.vehicle.model))),
      body: ListView(
        children: [
          // customListInfoVehicle(
          //     icon: iconByType(),
          //     title: Text(S.of(context).hintTextModel),
          //     subtitle: Text(widget.vehicle.model)),
          customListInfoVehicle(
              icon: iconByType(),
              title: Text(S.of(context).hintTextVersion),
              subtitle: Text(widget.vehicle.version)),
          customListInfoVehicle(
              icon: const Icon(Icons.date_range),
              title: Text(S.of(context).hintTextNextRevisionDate),
              subtitle: Text(widget.vehicle.nextRevisionDate.toString())),
          if (widget.vehicle.type == "car" || widget.vehicle.type == "bike")
            customListInfoVehicle(
                icon: const Icon(Icons.assistant_direction),
                title: Text(S.of(context).hintTextNextRevisionDistance),
                subtitle: Text(widget.vehicle.nextRevisionDistance.toString())),
          if (widget.vehicle.type == "car" || widget.vehicle.type == "bike")
            customListInfoVehicle(
                icon: const Icon(Icons.tire_repair_sharp),
                title: Text(S.of(context).hintTextFrontTire),
                subtitle: Text(widget.vehicle.frontTirePressure.toString())),
          if (widget.vehicle.type == "car" || widget.vehicle.type == "bike")
            customListInfoVehicle(
                icon: const Icon(Icons.tire_repair_sharp),
                title: Text(S.of(context).hintTextRearTire),
                subtitle: Text(widget.vehicle.rearTirePressure.toString())),
          if (widget.vehicle.type == "car")
            customListInfoVehicle(
                icon: const Icon(Icons.date_range),
                title: Text(S.of(context).hintTextNextTechnicalControlDate),
                subtitle:
                    Text(widget.vehicle.nextTechnicalControlDate.toString())),
          customListInfoVehicle(
              icon: const Icon(Icons.local_gas_station),
              title: Text(S.of(context).hintTextFuel),
              subtitle: Text(widget.vehicle.fuel)),
          customListInfoVehicle(
              icon: const Icon(Icons.info),
              title: Text(S.of(context).hintTextFreeInformations),
              subtitle: Text(widget.vehicle.freeInformations)),
          /* ################################
          ###################################
          ###################################
          ##### BUTTONS #####################
          ###################################
          ###################################
          #################################*/
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Update :
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateVehicle(
                                    vehicle: widget.vehicle,
                                  )));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      shape: const StadiumBorder(),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              child: Icon(Icons.edit)),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            child: Text(
                              S.of(context).editVehicle,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ]),
                  ),
                  // Delete :
                  ElevatedButton(
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text(
                          'Supprimer le véhicule?',
                          style: TextStyle(color: Colors.red),
                        ),
                        content: const Text(
                          'Cette action est irréversible',
                          style: TextStyle(color: Colors.black),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Annuler'),
                            child: const Text('Annuler',
                                style: TextStyle(color: Colors.black)),
                          ),
                          TextButton(
                            onPressed: () => deleteVehicle(widget.vehicle),
                            child: const Text('Supprimer',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      shape: const StadiumBorder(),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              child: Icon(Icons.delete)),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            child: Text(
                              S.of(context).deleteVehicle,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ]),
                  ),
                ],
              )),
        ],
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

class customListInfoVehicle extends StatelessWidget {
  Icon icon;
  Text title;
  Text subtitle;
  customListInfoVehicle({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: ListTile(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        leading: icon,
        title: title,
        subtitle: subtitle,
      ),
    );
  }
}
