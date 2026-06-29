import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/model/data_model/address.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/view_model/location/select_location_vm.dart';
import 'package:place_picker_google/place_picker_google.dart';
// import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//TODO
class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  @override
  void dispose() {
    print(
        "dispose select location screen was called here............................./////////////");
    // searchController.dispose();

    super.dispose();
  }

  // final LocationSettings locationSettings = LocationSettings(
  //   accuracy: LocationAccuracy.high,
  //   distanceFilter: 100,
  // );

  @override
  void initState() {
    super.initState();
  }

  GoogleMapController? mapController;

  // FloatingSearchBarController searchController = FloatingSearchBarController();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    // context.read<SelectLocationProvider>().checkLocation();
    //   context.read<SelectLocationProvider>().getRecentLocations();
    return Consumer<SelectLocationVM>(
      builder: (_, model, __) => Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Constants.themeGradients[0],
          title: Text(
            "Pick Location",
            // "MB-005-00-16",
            style: Constants.appbarTitleTextStyle,
          ),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.location_pin,
                      size: screenHeight * 0.15,
                      color: Colors.green,
                    ),
                    model.result!.isEmpty
                        ? CircularProgressIndicator()
                        : Text(
                            model.result.toString(),
                            style: theme.textTheme.headlineSmall!
                                .copyWith(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: screenHeight * 0.07,
                    width: screenHeight * 0.2,
                    child: ElevatedButton(
                      child: Text(
                        "Reset Location",
                        style: theme.textTheme.bodyLarge!.copyWith(),
                      ),
                      onPressed: () {
                        showPlacePicker(model);
                      },
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.07,
                    width: screenHeight * 0.2,
                    child: ElevatedButton(
                      child: Text(
                        "Confirm",
                        style: theme.textTheme.bodyLarge!.copyWith(),
                      ),
                      onPressed: () {
                        Address add = Address();
                        add.formattedAddress = model.result.toString();
                        Navigator.pop(context, add);
                        // showPlacePicker();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        //TODO
        // body: FloatingSearchBar(
        //   borderRadius: BorderRadius.circular(8),
        //   border: const BorderSide(color: Colors.black38),
        //   height: 60,
        //   hint: "Search...",
        //   // queryStyle: titleGrey,
        //   // hintStyle: placeholderTextGrey,
        //   backdropColor: Colors.transparent,
        //   onQueryChanged: (pattern) {
        //     print(pattern);
        //     context
        //         .read<SelectLocationVM>()
        //         .searchLocation(searchController, context, pattern);
        //   },
        //   accentColor: Colors.black45,
        //   controller: searchController,
        //   clearQueryOnClose: true,
        //   automaticallyImplyBackButton: false,
        //   leadingActions: [
        //     IconButton(
        //         onPressed: () {
        //           Navigator.of(context).pop();
        //         },
        //         icon: const Icon(
        //           Icons.arrow_back,
        //           color: Colors.black45,
        //         ))
        //   ],
        //   debounceDelay: const Duration(milliseconds: 300),
        //   actions: [
        //     searchController.isOpen
        //         ? IconButton(
        //             onPressed: () {
        //               searchController.clear();
        //               searchController.close();
        //               context.read<SelectLocationVM>().clearPredictions();
        //             },
        //             icon: const Icon(
        //               Icons.clear,
        //               color: Colors.black45,
        //             ))
        //         : IconButton(
        //             onPressed: () {},
        //             icon: const Icon(
        //               Icons.search,
        //               color: Colors.black45,
        //             ))
        //   ],
        //   // builder: (context, anim) {
        //     // return model.predictionList != null && searchController.isVisible
        //     //     ? Container(
        //     //         height: screenHeight * 0.7,
        //     //         decoration: BoxDecoration(
        //     //           borderRadius: BorderRadius.circular(20),
        //     //           color: Colors.white,
        //     //         ),
        //     //         child: ListView.builder(
        //     //           itemCount: model.predictionList!.length,
        //     //           // shrinkWrap: true,
        //     //           itemBuilder: (context, index) => ListTile(
        //     //             onTap: () {
        //     //               context.read<SelectLocationVM>().onSelectedSuggestion(
        //     //                   context, model.predictionList![index]);
        //     //             },
        //     //             minLeadingWidth: 25.0,
        //     //             leading: const Icon(Icons.location_pin),
        //     //             title: Text(
        //     //               model.predictionList![index].description!
        //     //                   .split(",")
        //     //                   .first,
        //     //               // style: titleGrey,
        //     //             ),
        //     //             subtitle: Text(
        //     //               model.predictionList![index].description!
        //     //                           .split(",")
        //     //                           .sublist(1)
        //     //                           .toList()
        //     //                           .length >
        //     //                       2
        //     //                   ? model.predictionList![index].description!
        //     //                       .split(",")
        //     //                       .sublist(1)
        //     //                       .toList()
        //     //                       .reduce((value, element) => "$value,$element")
        //     //                   : model.predictionList![index].description!,
        //     //               // style: subtitleGrey400,
        //     //             ),
        //     //           ),
        //     //           shrinkWrap: true,
        //     //         ))
        //     //     : Container();
        //   // },
        //   body: Column(
        //     children: [
        //       SizedBox(
        //         height: screenHeight * 0.15,
        //       ),
        //       // Padding(
        //       //   padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        //       //   child: ListTile(
        //       //     horizontalTitleGap: 1.0,
        //       //     selectedTileColor: Colors.white,
        //       //     selected: model.selectedCurrentLocation,
        //       //     onTap: () => context
        //       //         .read<SelectLocationVM>()
        //       //         .onTapCurrentLocation(context),
        //       //     leading: const Center(
        //       //       heightFactor: 1.5,
        //       //       widthFactor: 0.1,
        //       //       child: Icon(
        //       //         Icons.location_searching_sharp,
        //       //         color: AppColors.GREEN_KX,
        //       //         size: 25,
        //       //       ),
        //       //     ),
        //       //     title: const Text(
        //       //       "Current Location",
        //       //       style: titleGreen,
        //       //     ),
        //       //     subtitle: const Text(
        //       //       "Using Gps",
        //       //       style: bodyGreen400,
        //       //     ),
        //       //   ),
        //       // ),
        //       // Consumer<SelectLocationVM>(
        //       //   builder: (_, model, __) => model.isLoading
        //       //       ? const Center(
        //       //           child: CircularProgressIndicator(),
        //       //         )
        //       //       : model.userAddress != null && widget.routeFrom == "/home"
        //       //           ? Container(
        //       //               decoration: BoxDecoration(
        //       //                   borderRadius: BorderRadius.circular(5)),
        //       //               margin: const EdgeInsets.only(
        //       //                   left: 15),
        //       //               child: ListTile(
        //       //                 minLeadingWidth: 35.0,
        //       //                 leading: SizedBox(
        //       //                   child: Image.asset(
        //       //                     "assets/icons/png/home-140 1.png",
        //       //                     height: 23,
        //       //                     width: 23,
        //       //                     color:Colors.grey,
        //       //                   ),
        //       //                   height: double.infinity,
        //       //                 ),
        //       //                 onTap: () {
        //       //                   context
        //       //                       .read<SelectLocationVM>()
        //       //                       .onTapHomeAddress(context,
        //       //                           routeFrom: widget.routeFrom!);
        //       //                 },
        //       //                 selected: false,
        //       //                 selectedTileColor: Colors.white,
        //       //                 title: const Text(
        //       //                   "Home",
        //       //                   style: titleGreen,
        //       //                 ),
        //       //                 subtitle: Text(
        //       //                   "${model.userAddress?.streetName ?? ""}, ${model.userAddress?.houseNumber ?? ""} ${model.userAddress?.unitNumber ?? ""}, ${model.userAddress?.postCode ?? ""}, ${model.userAddress?.locality ?? ""}, ${model.userAddress?.country ?? ""}, ${model.userAddress?.landmark ?? ""}",
        //       //                   style: titleGrey,
        //       //                   overflow: TextOverflow.ellipsis,
        //       //                   maxLines: 3,
        //       //                 ),
        //       //               ),
        //       //             )
        //       //           : const SizedBox.shrink(),
        //       // ),
        //     ],
        //   ),
        // ),
      ),
    );
  }

  void showPlacePicker(SelectLocationVM logic) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return Theme(
            data: ThemeData(
              colorScheme: const ColorScheme.light(
                // Primary colors
                primary: Colors.white,
                primaryContainer: Color(0XFF263238),
                secondary: Color(0XFF263238),
                secondaryContainer: Color(0X1EA2A9B3),
                tertiary: Color(0XFF263238),
                tertiaryContainer: Color(0X1EA2A9B3),
                onPrimary: Color(0XFF1F1F1F),
                onPrimaryContainer: Color(0X99FFFFFF),
                onSecondary: Color(0X99FFFFFF),
                onSecondaryContainer: Color(0XFF1F1F1F),
              ),
              primarySwatch: Colors.green, // Custom Theme for this page
              scaffoldBackgroundColor: Colors.green[50],
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Colors.green, fontSize: 20),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    textStyle: theme.textTheme.bodyLarge!
                        .copyWith(color: Colors.white)),
              ),
            ),
            child: PlacePicker(
              mapsBaseUrl:
                  // kIsWeb
                  //     ? 'https://cors-anywhere.herokuapp.com/https://maps.googleapis.com/maps/api/'
                  //     :
                  "https://maps.googleapis.com/maps/api/",
              usePinPointingSearch: true,
              apiKey: 'AIzaSyBQaoLL-DePeRTz-CFxg6BSKL1Q2gf4SxE',
              // kIsWeb
              //     ? "GOOGLE_MAPS_API_KEY_WEB"
              //     : Platform.isAndroid
              //         ? FlutterConfig.get('GOOGLE_MAPS_API_KEY_ANDROID')
              //         : FlutterConfig.get('GOOGLE_MAPS_API_KEY_IOS'),
              onPlacePicked: (LocationResult result) {
                debugPrint("Place picked: ${result.formattedAddress}");
                logic.changeAddress(result.formattedAddress!);
                Navigator.of(context).pop();
              },
              enableNearbyPlaces: false,
              showSearchInput: true,
              initialLocation: LatLng(
                logic.latitude,
                logic.longitude,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: (controller) {
                mapController = controller;
              },
              autoCompleteOverlayElevation: 0,
              searchInputConfig: SearchInputConfig(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                autofocus: false,
                style: theme.textTheme.bodyLarge!.copyWith(),
                textDirection: TextDirection.ltr,
              ),
              searchInputDecorationConfig: const SearchInputDecorationConfig(
                  hintText: "Search for a building, street or ...",
                  fillColor: Colors.white),
              // selectedPlaceWidgetBuilder: (ctx, state, result) {
              //   return const SizedBox.shrink();
              // },
              autocompletePlacesSearchRadius: 30,
            ),
          );
        },
      ),
    );
  }
}
