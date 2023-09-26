// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomMap extends StatefulWidget {
  final double lat;
  final double lng;
  final bool isThirdScreen;
  const CustomMap({
    Key? key,
    required this.lat,
    required this.lng,
    this.isThirdScreen=true,
  }) : super(key: key);

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  GoogleMapController? myMapController;
  BitmapDescriptor homeMarkerIcon = BitmapDescriptor.defaultMarker;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height:widget.isThirdScreen? MediaQuery.of(context).size.height / 3:MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              _buildMap(),
              Positioned(
                top: 20,
                right: 20,
                child: _buildCurrentLocationBtn(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  GoogleMap _buildMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(widget.lat, widget.lng),
        zoom: 15.0,
      ),
      myLocationEnabled: true,
      markers: <Marker>{
        Marker(
          anchor: const Offset(.5, .5),
          markerId: MarkerId("user_${widget.lat}"),
          icon: homeMarkerIcon,
          position: LatLng(
            widget.lat,
            widget.lng,
          ),
        ),
      },
      mapType: MapType.normal,
      zoomControlsEnabled: false,
      onMapCreated: _onMapCreated,
      myLocationButtonEnabled: false,
    );
  }

  InkWell _buildCurrentLocationBtn(BuildContext context) {
    return InkWell(
      onTap: () {
        myMapController?.animateCamera(
          CameraUpdate.newLatLng(LatLng(
            widget.lat,
            widget.lng,
          )),
        );
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Theme.of(context).dividerColor,
              spreadRadius: 1,
              offset: Offset.zero,
            ),
          ],
        ),
        child: Icon(
          PhosphorIcons.crosshairSimple,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    myMapController = controller;
    if (mounted) {
      myMapController?.setMapStyle('dark');
    }
  }

  @override
  void dispose() {
    myMapController?.dispose();

    super.dispose();
  }
}
