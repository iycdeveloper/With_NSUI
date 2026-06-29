import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iyc/screens/widgets/custom_button.dart';
import 'package:map_picker/map_picker.dart';

class MapEnlargedPage extends StatefulWidget {
  const MapEnlargedPage({Key? key, required this.latLong}) : super(key: key);

  final LatLng latLong;

  @override
  _MapEnlargedPageState createState() => _MapEnlargedPageState();
}

class _MapEnlargedPageState extends State<MapEnlargedPage> {
  late CameraPosition cameraPosition;
  final _controller = Completer<GoogleMapController>();

  MapPickerController mapPickerController = MapPickerController();
  @override
  void initState() {
    cameraPosition = CameraPosition(
      target: LatLng(widget.latLong.latitude, widget.latLong.longitude),
      zoom: 19.00,
    );

    // if (defaultTargetPlatform == TargetPlatform.android) {
    //   AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            MapPicker(
              // pass icon widget
              iconWidget: const Icon(
                Icons.location_pin,
                size: 50,
                color: Colors.red,
              ),
              showDot: true,
              //add map picker controller
              mapPickerController: mapPickerController,
              child: GoogleMap(
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                // hide location button
                myLocationButtonEnabled: true, indoorViewEnabled: true,
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

                  print(cameraPosition.target.latitude);
                },
                onTap: (latLong) {},
                onCameraIdle: () async {
                  // notify map stopped moving
                  mapPickerController.mapFinishedMoving!();

                  //get address name from camera position
                },
              ),
            ),
            Column(
              children: [
                Container(),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CustomButton(
                    labelText: "Confirm Location",
                    onTap: () {
                      print(cameraPosition.target.latitude);
                      Navigator.of(context).pop(cameraPosition.target);
                    },
                  ),
                )
              ],
            ),
            Positioned(
                left: 20,
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close)))
          ],
        ),
      ),
    );
  }
}
