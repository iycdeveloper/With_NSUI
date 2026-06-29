import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iyc/model/data_model/address.dart';
import 'package:iyc/screens/widgets/custom_button.dart';
import 'package:iyc/view_model/location/edit_location_vm.dart';
import 'package:map_picker/map_picker.dart';
import 'package:provider/provider.dart';

import 'map_enlarged_page.dart';

class LocationEditPage extends StatefulWidget {
  const LocationEditPage({
    Key? key,
    this.routeFrom,
    this.initialAddress,
  }) : super(key: key);

  final String? routeFrom;
  final Address? initialAddress;

  @override
  _LocationEditPageState createState() => _LocationEditPageState();
}

class _LocationEditPageState extends State<LocationEditPage> {
  late Address initialAddress;
  LatLng? resultLatLng;

  final _controller = Completer<GoogleMapController>();
  MapPickerController mapPickerController = MapPickerController();
  late Map? argumentsFromPreviousPage;
  late CameraPosition cameraPosition;

  final _editLocationFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    initialAddress = widget.initialAddress!;
    context.read<LocationEditVM>().initAddress(initialAddress);
    cameraPosition = CameraPosition(
      target: LatLng(initialAddress.latitude!, initialAddress.longitude!),
      zoom: 17,
    );
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Location"),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => MapEnlargedPage(
                                    latLong: resultLatLng ??
                                        cameraPosition.target)));
                        resultLatLng = result;
                        if (result != null && result is LatLng) {
                          final GoogleMapController controller =
                              await _controller.future;
                          controller.moveCamera(CameraUpdate.newCameraPosition(
                              CameraPosition(target: result, zoom: 17)));
                        }
                      },
                      child: MapPicker(
                        // pass icon widget
                        iconWidget: const Icon(
                          Icons.location_on,
                          size: 50,
                          color: Colors.red,
                        ),
                        showDot: false,
                        //add map picker controller
                        mapPickerController: mapPickerController,
                        child: AbsorbPointer(
                          absorbing: true,
                          child: GoogleMap(
                            myLocationEnabled: true,
                            // gestureRecognizers: Set()
                            //   ..add(Factory<PanGestureRecognizer>(
                            //       () => PanGestureRecognizer())),
                            zoomControlsEnabled: false,
                            // hide location button
                            myLocationButtonEnabled: false,
                            mapType: MapType.normal,
                            //  camera position
                            initialCameraPosition: cameraPosition,
                            onMapCreated: (GoogleMapController controller) {
                              _controller.isCompleted
                                  ? null
                                  : _controller.complete(controller);
                            },
                            onCameraMoveStarted: () {
                              // notify map is moving
                              mapPickerController.mapMoving!();
                            },
                            onCameraMove: (cameraPosition) {
                              this.cameraPosition = cameraPosition;
                            },

                            onCameraIdle: () async {
                              // notify map stopped moving
                              mapPickerController.mapFinishedMoving!();
                              //get address name from camera position

                              if (resultLatLng != null) {
                                context
                                    .read<LocationEditVM>()
                                    .getLocationFromCameraPosition(LatLng(
                                        resultLatLng!.latitude,
                                        resultLatLng!.longitude));
                              } else {
                                context
                                    .read<LocationEditVM>()
                                    .getLocationFromCameraPosition(LatLng(
                                        cameraPosition.target.latitude,
                                        cameraPosition.target.longitude));
                              }
                              debugPrint(
                                  cameraPosition.target.latitude.toString());
                              debugPrint(
                                  cameraPosition.target.longitude.toString());

                              // update the ui with the address
                            },
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Align(
                          alignment: Alignment.center,
                          child: ActionChip(
                            label: Text(
                              "Adjust Pin",
                            ),
                            onPressed: () async {
                              final result = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => MapEnlargedPage(
                                          latLong: resultLatLng ??
                                              cameraPosition.target)));
                              resultLatLng = result;
                              if (result != null && result is LatLng) {
                                final GoogleMapController controller =
                                    await _controller.future;
                                controller.moveCamera(
                                    CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                            target: result, zoom: 17)));
                              }
                            },
                            backgroundColor: Colors.white70,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Form(
                  key: _editLocationFormKey,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    margin: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Selector<LocationEditVM, Address?>(
                          selector: (context, mod) => mod.selectedAddress,
                          builder: (_, model, __) {
                            return Text(
                              model?.formattedAddress ?? "",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        CustomButton(
                          labelText: "Save and Continue",
                          onTap: () async {
                            if (_editLocationFormKey.currentState!.validate()) {
                              final populatedAddress = context
                                  .read<LocationEditVM>()
                                  .populateModelFromField();
                              Navigator.of(context).pop(populatedAddress);
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
