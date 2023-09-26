import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../../core/constants/api_constants.dart';
import '../../../domain/entities/request_details_entity.dart';
import '../widgets/custom_map_widget.dart';

class ActiveRequestMap extends StatefulWidget {
  final RequestDetailsEntity requestDetailsEntity;
  final StreamController<RequestDetailsEntity> dataStream;
  const ActiveRequestMap({
    Key? key,
    required this.requestDetailsEntity,
    required this.dataStream,
  }) : super(key: key);

  @override
  State<ActiveRequestMap> createState() => _ActiveRequestMapState();
}

class _ActiveRequestMapState extends State<ActiveRequestMap> {
  Completer<GoogleMapController> _controller = Completer();
  Map<String, Marker> _markers = {};
  Set<Polyline> polyLines = <Polyline>{};
  late CameraPosition _cameraPosition;
  GlobalKey userLocationKey = GlobalKey();
  GlobalKey expertLocationKey = GlobalKey();
  BitmapDescriptor userIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor providerIcon = BitmapDescriptor.defaultMarker;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    _cameraPosition = CameraPosition(
      target: LatLng(
        widget.requestDetailsEntity.sLatitude!,
        widget.requestDetailsEntity.sLongitude!,
      ),
      zoom: 14.0,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _buildIcon();
    });
    widget.dataStream.stream.listen((data) async {
      if (isLoaded && widget.requestDetailsEntity.status != 'SEARCHING' &&  widget.requestDetailsEntity.provider!=null) {
        _buildMarkers(true);
        changeCameraPosition();
        await getDirections(
          starting: LatLng(
            widget.requestDetailsEntity.sLatitude!,
            widget.requestDetailsEntity.sLongitude!,
          ),
          end: LatLng(
            widget.requestDetailsEntity.provider!.latitude!,
            widget.requestDetailsEntity.provider!.longitude!,
          ),
        );
      } else {
        _buildMarkers(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: isLoaded
          ? GoogleMap(
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: _cameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: _markers.values.toSet(),
              polylines: polyLines,
            )
          : ListView(
              children: [
                Transform.translate(
                  offset: Offset(
                    -MediaQuery.of(context).size.width * 2,
                    -MediaQuery.of(context).size.height * 2,
                  ),
                  child: RepaintBoundary(
                    key: userLocationKey,
                    child: CustomMapWidget(
                      title: 'Home',
                      icon: FeatherIcons.home,
                      backgroundColor: Theme.of(context).dividerColor,
                      colorIcon: Theme.of(context).colorScheme.background,
                    ),
                  ),
                ),
                RepaintBoundary(
                  key: expertLocationKey,
                  child: CustomMapWidget(
                    title: 'expert',
                    icon: PhosphorIcons.car,
                    backgroundColor: Theme.of(context).dividerColor,
                    colorIcon: Theme.of(context).colorScheme.background,
                  ),
                )
              ],
            ),
    );
  }

  Future<void> _buildIcon() async {
    var userMapData = {
      'id': '1',
      'globalKey': userLocationKey,
    };
    var expertMapData = {
      'id': '2',
      'globalKey': expertLocationKey,
    };
    var icon1 = await _generateIconsFromWidgets(userMapData);
    var icon2 = await _generateIconsFromWidgets(expertMapData);
    setState(() {
      userIcon = icon1;
      providerIcon = icon2;
      isLoaded = true;
    });
  }

  Future<BitmapDescriptor> _generateIconsFromWidgets(
      Map<String, dynamic> data) async {
    RenderRepaintBoundary boundary = data['globalKey']
        .currentContext
        ?.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  void _buildMarkers(bool showBoth) {
    if (showBoth) {
      setState(() {
        _markers.clear();
        Marker marker1 = Marker(
          markerId: MarkerId('user'),
          position: LatLng(
            widget.requestDetailsEntity.sLatitude!,
            widget.requestDetailsEntity.sLongitude!,
          ),
          icon: userIcon,
        );
        _markers[marker1.markerId.value] = marker1;

        Marker marker2 = Marker(
          markerId: MarkerId('provider'),
          position: LatLng(widget.requestDetailsEntity.provider!.latitude!,
              widget.requestDetailsEntity.provider!.longitude!),
          icon: providerIcon,
        );
        _markers[marker2.markerId.value] = marker2;
      });
    } else {
      _markers.clear();
      Marker marker1 = Marker(
        markerId: MarkerId('user'),
        position: LatLng(
          widget.requestDetailsEntity.sLatitude!,
          widget.requestDetailsEntity.sLongitude!,
        ),
        icon: userIcon,
      );
      _markers[marker1.markerId.value] = marker1;
    }
  }

  Future<void> getDirections({
    required LatLng starting,
    required LatLng end,
  }) async {
    print('getting directions');
    final PolylinePoints polylinePoints = PolylinePoints();
    await polylinePoints
        .getRouteBetweenCoordinates(
      dotenv.env['serverKey']!,
      PointLatLng(starting.latitude, starting.longitude),
      PointLatLng(end.latitude, end.longitude),
    )
        .then((PolylineResult value) {
      polyLines.clear();
      final List<LatLng> points = <LatLng>[];

      for (final element in value.points) {
        points.add(
          LatLng(element.latitude, element.longitude),
        );
      }

      final Polyline polyline = Polyline(
        polylineId: PolylineId(
          starting.hashCode.toString() + end.hashCode.toString(),
        ),
        width: 3,
        points: points,
        color: const Color(0xff9e0707),
      );

      polyLines.add(polyline);
    }).catchError((dynamic e) {});
  }

  Future<void> changeCameraPosition() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            widget.requestDetailsEntity.provider!.latitude!,
            widget.requestDetailsEntity.provider!.longitude!,
          ),
          zoom: 14.47,
        ),
      ),
    );
  }
}
