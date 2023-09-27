import 'package:easy_maintenance/entities/databaseClient.dart';
import 'package:easy_maintenance/models/vehicle.dart';
import 'package:easy_maintenance/generated/l10n.dart';
import 'package:easy_maintenance/views/upcomingAlert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:easy_maintenance/views/home.dart';
import 'package:intl/intl.dart';

// RegExp pour la pression des pneus :
final RegExp regExpPression = RegExp(r'^\d\.\d$');

class AddVehicle extends StatefulWidget {
  const AddVehicle({super.key});

  @override
  State<AddVehicle> createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 1,
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Center(child: Text(S.of(context).addTitle)),
            automaticallyImplyLeading: false,
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  icon: const Icon(Icons.directions_car),
                  text: S.of(context).car,
                ),
                Tab(
                  icon: const Icon(Icons.two_wheeler),
                  text: S.of(context).bike,
                ),
                Tab(
                  icon: const Icon(Icons.directions_boat),
                  text: S.of(context).other,
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Center(
                child: ListView(children: const [_CarForm()]),
              ),
              Center(
                child: ListView(children: const [_BikeForm()]),
              ),
              Center(
                child: ListView(children: const [_OtherForm()]),
              ),
            ],
          ),
          bottomNavigationBar: _BottomAppBar(),
        ));
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

/* ################################
###################################
###################################
###### FORM FOR CAR ###############
################################
###################################
#################################*/

class _CarForm extends StatefulWidget {
  const _CarForm({super.key});

  @override
  State<_CarForm> createState() => __CarFormState();
}

class __CarFormState extends State<_CarForm> {
  final databaseClient = DatabaseClient();

  // Selectionner une date :
  DateTime? date;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year + 10));
    if (pickedDate == null) {
      date = DateTime.now();
    }
    if (pickedDate != null && pickedDate != date) {
      setState(() {
        date = pickedDate;
      });
    }
  }

  // Form function :
  _carFormValidate() {
    if (_carFormKey.currentState!.validate()) {
      var freeInfoProvisional = freeInformationsController.value.text;
      setState(() {
        final modelNewCar = modelController.value.text;
        final versionNewCar = versionController.value.text;
        final nextRevisionDateNewCar = nextRevisionDateController.value.text;
        final nextRevisionDistanceNewCar =
            nextRevisionDistanceController.value.text;
        final frontTirePressureNewCar =
            double.parse(frontTirePressureController.value.text);
        final rearTirePressureNewCar =
            double.parse(rearTirePressureController.value.text);
        final nextTechnicalControlDateNewCar =
            nextTechnicalControlDateController.value.text;
        final fuelNewCar = fuelController.value.text;
        // Controller si free informations est vide :
        freeInfoProvisional.isNotEmpty
            ? null
            : freeInfoProvisional = S.of(context).emptyTextFreeInformations;
        final freeInformationsNewCar = freeInfoProvisional;
        const typeNewCar = "car";

        databaseClient.addVehicle(Vehicle(
            null,
            modelNewCar,
            versionNewCar,
            nextRevisionDateNewCar,
            nextRevisionDistanceNewCar,
            frontTirePressureNewCar,
            rearTirePressureNewCar,
            nextTechnicalControlDateNewCar,
            fuelNewCar,
            freeInformationsNewCar,
            typeNewCar));

        // Modal validation :
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              height: 400,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Spacer(),
                    const Icon(
                      Icons.check,
                      size: 48.0,
                    ),
                    Text(
                      S.of(context).vehicleSave,
                      style: const TextStyle(
                        color: Color(0xFFFACF39),
                        fontSize: 24.0,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                      ),
                      child: Text(S.of(context).registerNewVehicle),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddVehicle())),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                      ),
                      child: Text(S.of(context).backToHome),
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home())),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            );
          },
        );
      });
    }
  }

  // Identifiant formulaire :
  final _carFormKey = GlobalKey<FormState>();

  // Controller de champ de form pour récuperer les informations :
  final modelController = TextEditingController();
  final versionController = TextEditingController();
  final nextRevisionDateController = TextEditingController();
  final nextRevisionDistanceController = TextEditingController();
  final frontTirePressureController = TextEditingController();
  final rearTirePressureController = TextEditingController();
  final nextTechnicalControlDateController = TextEditingController();
  final fuelController = TextEditingController();
  final freeInformationsController = TextEditingController();

  // Libérer l'espace des controller :
  @override
  void dispose() {
    modelController.dispose();
    versionController.dispose();
    nextRevisionDateController.dispose();
    nextRevisionDistanceController.dispose();
    frontTirePressureController.dispose();
    rearTirePressureController.dispose();
    nextTechnicalControlDateController.dispose();
    fuelController.dispose();
    freeInformationsController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _carFormKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: modelController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        //helperText: S.of(context).helperTextModel,
                        hintText: S.of(context).hintTextModel,
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) => value!.length > 3
                          ? null
                          : S.of(context).errorTextModel,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: versionController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        //helperText: S.of(context).helperTextVersion,
                        hintText: S.of(context).hintTextVersion,
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) => value!.length > 3
                          ? null
                          : S.of(context).errorTextVersion,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: nextRevisionDateController,
                      onTap: () async {
                        // La ligne ci-dessous empêche le clavier d'apparaître :
                        //FocusScope.of(context).requestFocus(FocusNode());
                        // Afficher le sélecteur de date ici :
                        await _selectDate(context);
                        if (mounted) {
                          nextRevisionDateController.text =
                              DateFormat(S.of(context).dateFormat)
                                  .format(date!);
                        }
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        //helperText: S.of(context).helperTextNextRevisionDate,
                        hintText: S.of(context).hintTextNextRevisionDate,
                      ),
                      keyboardType: TextInputType.none,
                      validator: (value) => value!.length > 3
                          ? null
                          : S.of(context).errorTextNextRevisionDate,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: nextRevisionDistanceController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        //helperText: S.of(context).helperTextNextRevisionDistance,
                        hintText: S.of(context).hintTextNextRevisionDistance,
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) => value!.length > 3
                          ? null
                          : S.of(context).errorTextNextRevisionDistance,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: frontTirePressureController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        //helperText: S.of(context).helperTextFrontTire,
                        hintText: S.of(context).hintTextFrontTire,
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: false, decimal: true),
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          if (regExpPression.hasMatch(value)) {
                            return null;
                          } else {
                            return S.of(context).errorTextFrontTireNotDouble;
                          }
                        } else {
                          return S.of(context).errorTextFrontTireShort;
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: rearTirePressureController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        //helperText: S.of(context).helperTextRearTire,
                        hintText: S.of(context).hintTextRearTire,
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: false, decimal: true),
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          if (regExpPression.hasMatch(value)) {
                            return null;
                          } else {
                            return S.of(context).errorTextRearTireNotDouble;
                          }
                        } else {
                          return S.of(context).errorTextRearTireShort;
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: nextTechnicalControlDateController,
                      onTap: () async {
                        // La ligne ci-dessous empêche le clavier d'apparaître :
                        //FocusScope.of(context).requestFocus(FocusNode());
                        // Afficher le sélecteur de date ici :
                        await _selectDate(context);
                        if (mounted) {
                          nextTechnicalControlDateController.text =
                              DateFormat(S.of(context).dateFormat)
                                  .format(date!);
                        }
                        //setState(() {});
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        //helperText: S.of(context).helperTextNextTechnicalControlDate,
                        hintText:
                            S.of(context).hintTextNextTechnicalControlDate,
                      ),
                      keyboardType: TextInputType.none,
                      validator: (value) => value!.length > 3
                          ? null
                          : S.of(context).errorTextNextTechnicalControlDate,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: fuelController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        //helperText: S.of(context).helperTextFuel,
                        hintText: S.of(context).hintTextFuel,
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) => value!.length > 3
                          ? null
                          : S.of(context).errorTextFuel,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: freeInformationsController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        //helperText: S.of(context).helperTextFreeInformations,
                        hintText: S.of(context).hintTextFreeInformations,
                      ),
                      keyboardType: TextInputType.multiline,
                      // minLines: 3,
                      // maxLines: 7,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: ElevatedButton(
                onPressed: _carFormValidate,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  shape: const StadiumBorder(),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      child: Icon(Icons.check)),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    child: Text(
                      S.of(context).tooltipFormValidate,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ));
  }
}

/* ################################
###################################
###################################
###### FORM FOR BIKE ###############
################################
###################################
#################################*/
class _BikeForm extends StatefulWidget {
  const _BikeForm({super.key});

  @override
  State<_BikeForm> createState() => __BikeFormState();
}

class __BikeFormState extends State<_BikeForm> {
  final databaseClient = DatabaseClient();

  // Selectionner une date :
  DateTime? date;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year + 10));
    if (pickedDate == null) {
      date = DateTime.now();
    }
    if (pickedDate != null && pickedDate != date) {
      setState(() {
        date = pickedDate;
      });
    }
  }

  // Form function :
  _bikeFormValidate() {
    if (_bikeFormKey.currentState!.validate()) {
      var freeInfoProvisional = freeInformationsController.value.text;
      setState(() {
        final modelNewBike = modelController.value.text;
        final versionNewBike = versionController.value.text;
        final nextRevisionDateNewBike = nextRevisionDateController.value.text;
        final nextRevisionDistanceNewBike =
            nextRevisionDistanceController.value.text;
        final frontTirePressureNewBike =
            double.parse(frontTirePressureController.value.text);
        final rearTirePressureNewBike =
            double.parse(rearTirePressureController.value.text);
        final fuelNewBike = fuelController.value.text;
        // Controller si free informations est vide :
        freeInfoProvisional.isNotEmpty
            ? null
            : freeInfoProvisional = S.of(context).emptyTextFreeInformations;
        final freeInformationsNewBike = freeInfoProvisional;
        const typeNewBike = "bike";

        databaseClient.addVehicle(Vehicle.bike(
            null,
            modelNewBike,
            versionNewBike,
            nextRevisionDateNewBike,
            nextRevisionDistanceNewBike,
            frontTirePressureNewBike,
            rearTirePressureNewBike,
            fuelNewBike,
            freeInformationsNewBike,
            typeNewBike));
        // Modal validation :
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              height: 400,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Spacer(),
                    const Icon(
                      Icons.check,
                      size: 48.0,
                    ),
                    Text(
                      S.of(context).vehicleSave,
                      style: const TextStyle(
                        color: Color(0xFFFACF39),
                        fontSize: 24.0,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                      ),
                      child: Text(S.of(context).registerNewVehicle),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddVehicle())),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                      ),
                      child: Text(S.of(context).backToHome),
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home())),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            );
          },
        );
      });
    }
  }

  // Identifiant formulaire :
  final _bikeFormKey = GlobalKey<FormState>();

  // Controller de champ de form pour récuperer les informations :
  final modelController = TextEditingController();
  final versionController = TextEditingController();
  final nextRevisionDateController = TextEditingController();
  final nextRevisionDistanceController = TextEditingController();
  final frontTirePressureController = TextEditingController();
  final rearTirePressureController = TextEditingController();
  final fuelController = TextEditingController();
  final freeInformationsController = TextEditingController();

  // Libérer l'espace des controller :
  @override
  void dispose() {
    modelController.dispose();
    versionController.dispose();
    nextRevisionDateController.dispose();
    nextRevisionDistanceController.dispose();
    frontTirePressureController.dispose();
    rearTirePressureController.dispose();
    fuelController.dispose();
    freeInformationsController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _bikeFormKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: modelController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        //helperText: S.of(context).helperTextModel,
                        hintText: S.of(context).hintTextModel,
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) => value!.length > 3
                          ? null
                          : S.of(context).errorTextModel,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: versionController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        //helperText: S.of(context).helperTextVersion,
                        hintText: S.of(context).hintTextVersion,
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) => value!.length > 3
                          ? null
                          : S.of(context).errorTextVersion,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: nextRevisionDateController,
                      onTap: () async {
                        // La ligne ci-dessous empêche le clavier d'apparaître :
                        //FocusScope.of(context).requestFocus(FocusNode());
                        // Afficher le sélecteur de date ici :
                        await _selectDate(context);
                        if (mounted) {
                          nextRevisionDateController.text =
                              DateFormat(S.of(context).dateFormat)
                                  .format(date!);
                        }
                        //setState(() {});
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        //helperText: S.of(context).helperTextNextRevisionDate,
                        hintText: S.of(context).hintTextNextRevisionDate,
                      ),
                      keyboardType: TextInputType.none,
                      validator: (value) => value!.length > 3
                          ? null
                          : S.of(context).errorTextNextRevisionDate,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: nextRevisionDistanceController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        //helperText: S.of(context).helperTextNextRevisionDistance,
                        hintText: S.of(context).hintTextNextRevisionDistance,
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) => value!.length > 3
                          ? null
                          : S.of(context).errorTextNextRevisionDistance,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: frontTirePressureController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        //helperText: S.of(context).helperTextFrontTire,
                        hintText: S.of(context).hintTextFrontTire,
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: false, decimal: true),
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          if (regExpPression.hasMatch(value)) {
                            return null;
                          } else {
                            return S.of(context).errorTextFrontTireNotDouble;
                          }
                        } else {
                          return S.of(context).errorTextFrontTireShort;
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: rearTirePressureController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        //helperText: S.of(context).helperTextRearTire,
                        hintText: S.of(context).hintTextRearTire,
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: false, decimal: true),
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          if (regExpPression.hasMatch(value)) {
                            return null;
                          } else {
                            return S.of(context).errorTextRearTireNotDouble;
                          }
                        } else {
                          return S.of(context).errorTextRearTireShort;
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: fuelController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        //helperText: S.of(context).helperTextFuel,
                        hintText: S.of(context).hintTextFuel,
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) => value!.length > 3
                          ? null
                          : S.of(context).errorTextFuel,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: freeInformationsController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        //helperText: S.of(context).helperTextFreeInformations,
                        hintText: S.of(context).hintTextFreeInformations,
                      ),
                      keyboardType: TextInputType.multiline,
                      // minLines: 3,
                      // maxLines: 7,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: ElevatedButton(
                onPressed: _bikeFormValidate,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  shape: const StadiumBorder(),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      child: Icon(Icons.check)),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    child: Text(
                      S.of(context).tooltipFormValidate,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ));
  }
}

/* ################################
###################################
###################################
###### FORM FOR OTHER ###############
################################
###################################
#################################*/
class _OtherForm extends StatefulWidget {
  const _OtherForm({super.key});

  @override
  State<_OtherForm> createState() => __OtherFormState();
}

class __OtherFormState extends State<_OtherForm> {
  final databaseClient = DatabaseClient();

  // Selectionner une date :
  DateTime? date;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year + 10));
    if (pickedDate == null) {
      date = DateTime.now();
    }
    if (pickedDate != null && pickedDate != date) {
      setState(() {
        date = pickedDate;
      });
    }
  }

  // Form function :
  _otherFormValidate() {
    if (_otherFormKey.currentState!.validate()) {
      var freeInfoProvisional = freeInformationsController.value.text;
      setState(() {
        final modelNewOther = modelController.value.text;
        final versionNewOther = versionController.value.text;
        final nextRevisionDateNewOther = nextRevisionDateController.value.text;
        final fuelNewOther = fuelController.value.text;
        // Controller si free informations est vide :
        freeInfoProvisional.isNotEmpty
            ? null
            : freeInfoProvisional = S.of(context).emptyTextFreeInformations;
        final freeInformationsNewOther = freeInfoProvisional;
        const typeNewOther = "other";

        databaseClient.addVehicle(Vehicle.other(
            null,
            modelNewOther,
            versionNewOther,
            nextRevisionDateNewOther,
            fuelNewOther,
            freeInformationsNewOther,
            typeNewOther));

        // Modal validation :
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              height: 400,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Spacer(),
                    const Icon(
                      Icons.check,
                      size: 48.0,
                    ),
                    Text(
                      S.of(context).vehicleSave,
                      style: const TextStyle(
                        color: Color(0xFFFACF39),
                        fontSize: 24.0,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                      ),
                      child: Text(S.of(context).registerNewVehicle),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddVehicle())),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                      ),
                      child: Text(S.of(context).backToHome),
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home())),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            );
          },
        );
      });
    }
  }

  // Identifiant formulaire :
  final _otherFormKey = GlobalKey<FormState>();

  // Controller de champ de form pour récuperer les informations :
  final modelController = TextEditingController();
  final versionController = TextEditingController();
  final nextRevisionDateController = TextEditingController();
  final fuelController = TextEditingController();
  final freeInformationsController = TextEditingController();

  // Libérer l'espace des controller :
  @override
  void dispose() {
    modelController.dispose();
    versionController.dispose();
    nextRevisionDateController.dispose();
    fuelController.dispose();
    freeInformationsController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _otherFormKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: modelController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        //helperText: S.of(context).helperTextModel,
                        hintText: S.of(context).hintTextModel,
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) => value!.length > 3
                          ? null
                          : S.of(context).errorTextModel,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: versionController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        //helperText: S.of(context).helperTextVersion,
                        hintText: S.of(context).hintTextVersion,
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) => value!.length > 3
                          ? null
                          : S.of(context).errorTextVersion,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: nextRevisionDateController,
                      onTap: () async {
                        // La ligne ci-dessous empêche le clavier d'apparaître :
                        //FocusScope.of(context).requestFocus(FocusNode());
                        // Afficher le sélecteur de date ici :
                        await _selectDate(context);
                        if (mounted) {
                          nextRevisionDateController.text =
                              DateFormat(S.of(context).dateFormat)
                                  .format(date!);
                        }
                        //setState(() {});
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        //helperText: S.of(context).helperTextNextRevisionDate,
                        hintText: S.of(context).hintTextNextRevisionDate,
                      ),
                      keyboardType: TextInputType.none,
                      validator: (value) => value!.length > 3
                          ? null
                          : S.of(context).errorTextNextRevisionDate,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: fuelController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        //helperText: S.of(context).helperTextFuel,
                        hintText: S.of(context).hintTextFuel,
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) => value!.length > 3
                          ? null
                          : S.of(context).errorTextFuel,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: freeInformationsController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        //helperText: S.of(context).helperTextFreeInformations,
                        hintText: S.of(context).hintTextFreeInformations,
                      ),
                      keyboardType: TextInputType.multiline,
                      // minLines: 3,
                      // maxLines: 7,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: ElevatedButton(
                onPressed: _otherFormValidate,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  shape: const StadiumBorder(),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      child: Icon(Icons.check)),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    child: Text(
                      S.of(context).tooltipFormValidate,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ));
  }
}
