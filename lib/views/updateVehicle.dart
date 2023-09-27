import 'package:easy_maintenance/views/home.dart';
import 'package:easy_maintenance/views/upcomingAlert.dart';
import 'package:easy_maintenance/views/vehicleDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:easy_maintenance/generated/l10n.dart';
import 'package:intl/intl.dart';
import '../entities/databaseClient.dart';
import '../models/vehicle.dart';

// RegExp pour la pression des pneus :
final RegExp regExpPression = RegExp(r'^\d\.\d$');

class UpdateVehicle extends StatefulWidget {
  final Vehicle vehicle;
  const UpdateVehicle({super.key, required this.vehicle});

  @override
  State<UpdateVehicle> createState() => _UpdateVehicleState();
}

class _UpdateVehicleState extends State<UpdateVehicle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
              child: Text(
                  '${S.of(context).editVehicle} ${widget.vehicle.model}'))),
      body: Center(
        child: ListView(children: [
          if (widget.vehicle.type == "car")
            _CarUpdateForm(
              vehicle: widget.vehicle,
            ),
          if (widget.vehicle.type == "bike")
            _BikeUpdateForm(vehicle: widget.vehicle),
          if (widget.vehicle.type == "other")
            _OtherUpdateForm(vehicle: widget.vehicle)
        ]),
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

/* ################################
###################################
###################################
#### FORM FOR UPDATE CAR #########
################################
###################################
#################################*/

class _CarUpdateForm extends StatefulWidget {
  Vehicle vehicle;
  _CarUpdateForm({super.key, required this.vehicle});

  @override
  State<_CarUpdateForm> createState() => _CarUpdateFormState();
}

class _CarUpdateFormState extends State<_CarUpdateForm> {
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
  _carUpdateFormValidate() {
    if (_carUpdateFormKey.currentState!.validate()) {
      var freeInfoProvisional = freeInformationsController.value.text;
      setState(() {
        final idUpdateCar = widget.vehicle.id;
        final modelUpdateCar = modelController.value.text;
        final versionUpdateCar = versionController.value.text;
        final nextRevisionDateUpdateCar = nextRevisionDateController.value.text;
        final nextRevisionDistanceUpdateCar =
            nextRevisionDistanceController.value.text;
        final frontTirePressureUpdateCar =
            double.parse(frontTirePressureController.value.text);
        final rearTirePressureUpdateCar =
            double.parse(rearTirePressureController.value.text);
        final nextTechnicalControlDateUpdateCar =
            nextTechnicalControlDateController.value.text;
        final fuelUpdateCar = fuelController.value.text;
        // Controller si free informations est vide :
        freeInfoProvisional.isNotEmpty
            ? null
            : freeInfoProvisional = S.of(context).emptyTextFreeInformations;
        final freeInformationsUpdateCar = freeInfoProvisional;
        const typeUpdateCar = "car";

        databaseClient.updateVehiculeWhereId(Vehicle(
            idUpdateCar,
            modelUpdateCar,
            versionUpdateCar,
            nextRevisionDateUpdateCar,
            nextRevisionDistanceUpdateCar,
            frontTirePressureUpdateCar,
            rearTirePressureUpdateCar,
            nextTechnicalControlDateUpdateCar,
            fuelUpdateCar,
            freeInformationsUpdateCar,
            typeUpdateCar));

        //Modal validation :
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
                      S.of(context).vehicleUpdate,
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

  // Pré-remplir le formulaire :
  @override
  void initState() {
    modelController = TextEditingController(text: widget.vehicle.model);
    versionController = TextEditingController(text: widget.vehicle.version);
    nextRevisionDateController =
        TextEditingController(text: widget.vehicle.nextRevisionDate);
    nextRevisionDistanceController =
        TextEditingController(text: widget.vehicle.nextRevisionDistance);
    frontTirePressureController = TextEditingController(
        text: widget.vehicle.frontTirePressure.toString());
    rearTirePressureController =
        TextEditingController(text: widget.vehicle.rearTirePressure.toString());
    nextTechnicalControlDateController =
        TextEditingController(text: widget.vehicle.nextTechnicalControlDate);
    fuelController = TextEditingController(text: widget.vehicle.fuel);
    freeInformationsController =
        TextEditingController(text: widget.vehicle.freeInformations);
    super.initState();
  }

  // Identifiant formulaire :
  final _carUpdateFormKey = GlobalKey<FormState>();

  // Controller de champ de form pour récuperer les informations :
  var modelController = TextEditingController();
  var versionController = TextEditingController();
  var nextRevisionDateController = TextEditingController();
  var nextRevisionDistanceController = TextEditingController();
  var frontTirePressureController = TextEditingController();
  var rearTirePressureController = TextEditingController();
  var nextTechnicalControlDateController = TextEditingController();
  var fuelController = TextEditingController();
  var freeInformationsController = TextEditingController();

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
        key: _carUpdateFormKey,
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
                onPressed: _carUpdateFormValidate,
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
#### FORM FOR UPDATE BIKE #########
################################
###################################
#################################*/
class _BikeUpdateForm extends StatefulWidget {
  Vehicle vehicle;
  _BikeUpdateForm({super.key, required this.vehicle});

  @override
  State<_BikeUpdateForm> createState() => _BikeUpdateFormState();
}

class _BikeUpdateFormState extends State<_BikeUpdateForm> {
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
  _bikeUpdateFormValidate() {
    if (_bikeUpdateFormKey.currentState!.validate()) {
      var freeInfoProvisional = freeInformationsController.value.text;
      setState(() {
        final idUpdateBike = widget.vehicle.id;
        final modelUpdateBike = modelController.value.text;
        final versionUpdateBike = versionController.value.text;
        final nextRevisionDateUpdateBike =
            nextRevisionDateController.value.text;
        final nextRevisionDistanceUpdateBike =
            nextRevisionDistanceController.value.text;
        final frontTirePressureUpdateBike =
            double.parse(frontTirePressureController.value.text);
        final rearTirePressureUpdateBike =
            double.parse(rearTirePressureController.value.text);
        final fuelUpdateBike = fuelController.value.text;
        // Controller si free informations est vide :
        freeInfoProvisional.isNotEmpty
            ? null
            : freeInfoProvisional = S.of(context).emptyTextFreeInformations;
        final freeInformationsUpdateBike = freeInfoProvisional;
        const typeUpdateBike = "bike";

        databaseClient.updateVehiculeWhereId(Vehicle.bike(
            idUpdateBike,
            modelUpdateBike,
            versionUpdateBike,
            nextRevisionDateUpdateBike,
            nextRevisionDistanceUpdateBike,
            frontTirePressureUpdateBike,
            rearTirePressureUpdateBike,
            fuelUpdateBike,
            freeInformationsUpdateBike,
            typeUpdateBike));
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
                      S.of(context).vehicleUpdate,
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

  // Pré-remplir le formulaire :
  @override
  void initState() {
    modelController = TextEditingController(text: widget.vehicle.model);
    versionController = TextEditingController(text: widget.vehicle.version);
    nextRevisionDateController =
        TextEditingController(text: widget.vehicle.nextRevisionDate);
    nextRevisionDistanceController =
        TextEditingController(text: widget.vehicle.nextRevisionDistance);
    frontTirePressureController = TextEditingController(
        text: widget.vehicle.frontTirePressure.toString());
    rearTirePressureController =
        TextEditingController(text: widget.vehicle.rearTirePressure.toString());
    fuelController = TextEditingController(text: widget.vehicle.fuel);
    freeInformationsController =
        TextEditingController(text: widget.vehicle.freeInformations);
    super.initState();
  }

  // Identifiant formulaire :
  final _bikeUpdateFormKey = GlobalKey<FormState>();

  // Controller de champ de form pour récuperer les informations :
  var modelController = TextEditingController();
  var versionController = TextEditingController();
  var nextRevisionDateController = TextEditingController();
  var nextRevisionDistanceController = TextEditingController();
  var frontTirePressureController = TextEditingController();
  var rearTirePressureController = TextEditingController();
  var fuelController = TextEditingController();
  var freeInformationsController = TextEditingController();

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
        key: _bikeUpdateFormKey,
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
                onPressed: _bikeUpdateFormValidate,
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
###### FORM FOR UPDATE OTHER ######
################################
###################################
#################################*/
class _OtherUpdateForm extends StatefulWidget {
  Vehicle vehicle;
  _OtherUpdateForm({super.key, required this.vehicle});

  @override
  State<_OtherUpdateForm> createState() => _OtherUpdateFormState();
}

class _OtherUpdateFormState extends State<_OtherUpdateForm> {
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
  _otherUpdateFormValidate() {
    if (_otherUpdateFormKey.currentState!.validate()) {
      var freeInfoProvisional = freeInformationsController.value.text;
      setState(() {
        final idUpdateOther = widget.vehicle.id;
        final modelUpdateOther = modelController.value.text;
        final versionUpdateOther = versionController.value.text;
        final nextRevisionDateUpdateOther =
            nextRevisionDateController.value.text;
        final fuelUpdateOther = fuelController.value.text;
        // Controller si free informations est vide :
        freeInfoProvisional.isNotEmpty
            ? null
            : freeInfoProvisional = S.of(context).emptyTextFreeInformations;
        final freeInformationsUpdateOther = freeInfoProvisional;
        const typeNewOther = "other";

        databaseClient.updateVehiculeWhereId(Vehicle.other(
            idUpdateOther,
            modelUpdateOther,
            versionUpdateOther,
            nextRevisionDateUpdateOther,
            fuelUpdateOther,
            freeInformationsUpdateOther,
            typeNewOther));

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
                      S.of(context).vehicleUpdate,
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

  // Pré-remplir le formulaire :
  @override
  void initState() {
    modelController = TextEditingController(text: widget.vehicle.model);
    versionController = TextEditingController(text: widget.vehicle.version);
    nextRevisionDateController =
        TextEditingController(text: widget.vehicle.nextRevisionDate);
    fuelController = TextEditingController(text: widget.vehicle.fuel);
    freeInformationsController =
        TextEditingController(text: widget.vehicle.freeInformations);
    super.initState();
  }

  // Identifiant formulaire :
  final _otherUpdateFormKey = GlobalKey<FormState>();

  // Controller de champ de form pour récuperer les informations :
  var modelController = TextEditingController();
  var versionController = TextEditingController();
  var nextRevisionDateController = TextEditingController();
  var fuelController = TextEditingController();
  var freeInformationsController = TextEditingController();

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
        key: _otherUpdateFormKey,
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
                onPressed: _otherUpdateFormValidate,
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
