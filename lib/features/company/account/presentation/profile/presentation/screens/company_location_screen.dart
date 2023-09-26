import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../../../core/ui/widgets/app_button.dart';
import '../../../../../../../core/utils/services/location_service.dart';
import '../../../../../../../core/ui/widgets/map_picker.dart';

class CompanyLocationScreen extends StatefulWidget {
  static const routeName = 'company_location_screen';
  const CompanyLocationScreen({super.key});

  @override
  State<CompanyLocationScreen> createState() => _CompanyLocationScreenState();
}

class _CompanyLocationScreenState extends State<CompanyLocationScreen> {
  late GeoLoc currentUserCoords;
  late CameraPosition _initialCameraPosition;
  final Set<Marker> _markers = {};
  GoogleMapController? _googleMapController;
  TextEditingController searchController = TextEditingController();
  MapPickerController mapPickerController = MapPickerController();
  var _isLoading = true;
  var loadingFetchingAddress = false;

  @override
  void initState() {
    super.initState();
    LocationService.getLocationCoords().then((geoLocData) {
      currentUserCoords = GeoLoc(lat: geoLocData!.lat, lng: geoLocData.lng);
      _initialCameraPosition = CameraPosition(
        target: LatLng(currentUserCoords.lat, currentUserCoords.lng),
        zoom: 15.0,
        tilt: 0,
        bearing: 0,
      );
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.companyLocation),
      ),
      body: Container(

        child: Column(
          children: [
            Container(),
            Expanded(
              child: Stack(
                children: [
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildMapPicker(),
                  Positioned(
                    top: 24,
                    left: 24,
                    right: 24,
                    child: Row(
                      children: [
                        _buildFormBuilder(context),
                        const SizedBox(width: 8),
                        _buildGoToCurrentLocation(context),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 24,
                    left: 24,
                    right: 24,
                    child: _buildPickBtn(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InkWell _buildGoToCurrentLocation(BuildContext context) {
    return InkWell(
      onTap: () async {
        GeoLoc? coord = await LocationService.getLocationCoords();
        HapticFeedback.selectionClick();
        _googleMapController!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 0,
            target: LatLng(
              coord!.lat,
              coord.lng,
            ),
            zoom: 17.0,
          ),
        ));
        setState(() {
          currentUserCoords = GeoLoc(lat: coord.lat, lng: coord.lng);
        });
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).hintColor.withOpacity(0.4),
                  blurRadius: 12)
            ],
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 1.0,
            ),
            color: Theme.of(context).colorScheme.background),
        padding: const EdgeInsets.all(8),
        child: Icon(
          Icons.location_on,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Expanded _buildFormBuilder(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: FormBuilderTypeAhead<Locationprediction>(
          decoration: InputDecoration(
            fillColor: Colors.white,
            hintText: AppLocalizations.of(context)!.start_typing_to_search,
            border: InputBorder.none,
            filled: true,
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => searchController.clear(),
            ),
          ),
          name: AppLocalizations.of(context)!.search,
          onChanged: _onChanged,
          itemBuilder: (context, data) {
            return ListTile(title: Text(data.text));
          },
          controller: searchController,
          selectionToTextTransformer: (result) {
            return result.text;
          },
          suggestionsCallback: (query) async {
            if (query.isNotEmpty) {
              List<Locationprediction> preds =
                  await LocationService.getSuggestion(query);
              return preds;
            } else {
              return [];
            }
          },
          onSuggestionSelected: (value) async {
            searchController.selection = TextSelection.collapsed(
              offset: searchController.text.length,
            );
            GeoLoc? locationDetail =
                await LocationService.getLocationDetails(value.id);
            if (locationDetail != null) {

              HapticFeedback.selectionClick();

              _googleMapController!.animateCamera(CameraUpdate.newLatLngZoom(
                  LatLng(locationDetail.lat, locationDetail.lng), 14));
              setState(() {
                currentUserCoords =
                    GeoLoc(lat: locationDetail.lat, lng: locationDetail.lng);
              });
            }
          },
        ),
      ),
    );
  }

  MapPicker _buildMapPicker() {
    return MapPicker(
      mapPickerController: mapPickerController,
      // pass icon widget
      iconWidget: SvgPicture.asset(
        "assets/images/location_icon.svg",
        height: 60,
      ),
      child: GoogleMap(
        myLocationEnabled: false,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        buildingsEnabled: false,

        onCameraMoveStarted: () {
          // notify map is moving
          mapPickerController.mapMoving!();
        },
        onCameraMove: (cameraPosition) {
            print('camer position ${_initialCameraPosition.target.latitude} ${_initialCameraPosition.target.longitude}');

        },
        onCameraIdle: () async {
          // notify map stopped moving
          mapPickerController.mapFinishedMoving!();
        },
        onMapCreated: ((controller) {
          _googleMapController = controller;
          // controller
          //     .showMarkerInfoWindow(const MarkerId('userLocation'));
        }),
        initialCameraPosition: _initialCameraPosition,
        markers: _markers,
      ),
    );
  }

  Widget _buildPickBtn() {
    return AppButton(
      title: AppLocalizations.of(context)!.save,
      isLoading: loadingFetchingAddress,
      onTap: () async {
        // BlocProvider.of<CreateRequestBloc>(context).add(
        //   CoordsChangedEvent(
        //     lat: currentUserCoords.lat,
        //     lng: currentUserCoords.lng,
        //   ),
        // );
        setState(() {
          loadingFetchingAddress = true;
        });
        String address = await LocationService.fetchAddress(currentUserCoords);
        setState(() {
          loadingFetchingAddress = false;
        });
        // BlocProvider.of<CreateRequestBloc>(context).add(
        //   AddressChangedEvent(address: address),
        // );
      },
    );
  }

  void _onChanged(dynamic val) => debugPrint(val.toString());

}
