// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../../../core/ui/dialogs/loading_dialog.dart';
import '../../../../../../../core/ui/widgets/app_button.dart';
import '../../../../../../../core/ui/widgets/app_drop_down.dart';
import '../../../../../../../core/ui/widgets/app_textfield.dart';
import '../../../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../../../core/ui/widgets/map_picker.dart';
import '../../../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../../../../../core/utils/helpers/toast_utils.dart';
import '../../../../../../../core/utils/services/location_service.dart';
import '../../../../../my_locations/data/model/my_locations_model.dart';
import '../../../../../my_locations/domain/entities/my_location_entity.dart';
import '../../../../../my_locations/presentation/bloc/get_saved_location_bloc.dart';
import '../../../../../my_locations/presentation/bloc/save_location_bloc.dart';
import '../../bloc/request_offer_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class OfferStep2 extends StatefulWidget {
  final Function changeCurrentTab;
  const OfferStep2({
    Key? key,
    required this.changeCurrentTab,
  }) : super(key: key);

  @override
  State<OfferStep2> createState() => _OfferStep2State();
}

class _OfferStep2State extends State<OfferStep2> {
   late GeoLoc currentUserCoords;
  late CameraPosition _initialCameraPosition;
  final Set<Marker> _markers = {};
  GoogleMapController? _googleMapController;
  TextEditingController searchController = TextEditingController();
  MapPickerController mapPickerController = MapPickerController();
  var _isLoading = true;
  var loadingFetchingAddress = false;
  bool showSaveAndPick = false;
  @override
  void initState() {
    super.initState();
    if (context.read<RequestOfferBloc>().state.latitude != 0) {
      currentUserCoords = GeoLoc(
          lat: context.read<RequestOfferBloc>().state.latitude,
          lng: context.read<RequestOfferBloc>().state.longitude);
      _initialCameraPosition = CameraPosition(
        target: LatLng(currentUserCoords.lat, currentUserCoords.lng),
        zoom: 15.0,
        tilt: 0,
        bearing: 0,
      );
      setState(() {
        _isLoading = false;
      });
    } else {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SaveLocationBloc, SaveLocationState>(
        listener: (context, state) {
          _buildSaveLocationListener(state, context);
        },
        child: BlocBuilder<GetSavedLocationBloc, GetSavedLocationState>(
          builder: (context, state) {
            if (state is LoadingGetSavedLocation) {
              return _buildLoadingState();
            } else if (state is GetSavedLocationOfflineState) {
              return _buildNoConnectionState(context);
            } else if (state is GetSavedLocationErrorState) {
              return _buildNetworkErrorState(state, context);
            } else if (state is LoadedGetSavedLocation) {
              return Stack(
                children: [
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : MapPicker(
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
                            onCameraMove: (cameraPosition) {},
                            onCameraIdle: () async {
                              // notify map stopped moving
                              mapPickerController.mapFinishedMoving!();
                            },
                            onMapCreated: ((controller) {
                              _googleMapController = controller;
                            }),
                            initialCameraPosition: _initialCameraPosition,
                            markers: _markers,
                          ),
                        ),
                  Positioned(
                    top: 24,
                    left: 24,
                    right: 24,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: _buildAutoComplete(context)),
                                  const SizedBox(width: 4),
                                  _buildNavigatToCurrentLocation(context),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              _buildLocationDropDown(context, state),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 24,
                    left: 24,
                    right: 24,
                    child: _buildBtns(),
                  ),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  AppDropDown<MyLocationsEntity> _buildLocationDropDown(
      BuildContext context, LoadedGetSavedLocation state) {
    return AppDropDown<MyLocationsEntity>(
      hintText: AppLocalizations.of(context)!.select_from_location_list,
      items: state.data.map((e) => _buildDropMenuItem(context, e)).toList(),
      initSelectedValue: null,
      onChanged: (value) {
        _googleMapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(value.lat, value.lng),
            14,
          ),
        );
        setState(() {
          showSaveAndPick = false;
          currentUserCoords = GeoLoc(
            lat: value.lat,
            lng: value.lng,
          );
        });
      },
    );
  }

  void _buildSaveLocationListener(
      SaveLocationState state, BuildContext context) {
    if (state is LoadingSaveLocation) {
      showLoadingDialog(context, text: 'Saving Location...');
    }
    if (state is LoadedSaveLocation) {
      Navigator.pop(context);
      Navigator.pop(context);
      Future.delayed(const Duration(seconds: 1), () {
        widget.changeCurrentTab(2);
      });
    } else if (state is SaveLocationOfflineState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('No internet Connection');
    } else if (state is SaveLocationErrorState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('Error saving the location, try again');
    }
  }

  DropdownMenuItem<MyLocationsEntity> _buildDropMenuItem(
      BuildContext context, MyLocationsEntity e) {
    return DropdownMenuItem<MyLocationsEntity>(
      value: e,
      child: Text(
        e.name,
      ),
    );
  }

  InkWell _buildNavigatToCurrentLocation(BuildContext context) {
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

  ClipRRect _buildAutoComplete(BuildContext context) {
    return ClipRRect(
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
            print('in');
            HapticFeedback.selectionClick();

            _googleMapController!.animateCamera(
              CameraUpdate.newLatLngZoom(
                LatLng(locationDetail.lat, locationDetail.lng),
                14,
              ),
            );
            setState(() {
              showSaveAndPick = true;
              currentUserCoords = GeoLoc(
                lat: locationDetail.lat,
                lng: locationDetail.lng,
              );
            });
          }
        },
      ),
    );
  }

  NetworkErrorWidget _buildNetworkErrorState(
      GetSavedLocationErrorState state, BuildContext context) {
    return NetworkErrorWidget(
      message: state.message,
      onPressed: () {
        BlocProvider.of<GetSavedLocationBloc>(context).add(GetLocations());
      },
    );
  }

  NoConnectionWidget _buildNoConnectionState(BuildContext context) {
    return NoConnectionWidget(
      onPressed: () {
        BlocProvider.of<GetSavedLocationBloc>(context).add(GetLocations());
      },
    );
  }

  LoadingWidget _buildLoadingState() {
    return const LoadingWidget();
  }

  Widget _buildBtns() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPickBtn(),
        if (showSaveAndPick) ...[
          const SizedBox(
            height: 8,
          ),
          _buildSaveAndPickButton()
        ]
      ],
    );
  }

  AppButton _buildPickBtn() {
    return AppButton(
      title: AppLocalizations.of(context)!.pick_location,
      isLoading: loadingFetchingAddress,
      onTap: () async {
        BlocProvider.of<RequestOfferBloc>(context).add(
          CoordsChangedEvent(
            lat: currentUserCoords.lat,
            lng: currentUserCoords.lng,
          ),
        );
        setState(() {
          loadingFetchingAddress = true;
        });
        String address = await LocationService.fetchAddress(currentUserCoords);
        setState(() {
          loadingFetchingAddress = false;
        });
        BlocProvider.of<RequestOfferBloc>(context).add(
          AddressChangedEvent(address: address),
        );
        widget.changeCurrentTab(2);
      },
    );
  }

  AppButton _buildSaveAndPickButton() {
    return AppButton(
      title: AppLocalizations.of(context)!.save_and_pick,
      buttonColor: ButtonColor.green,
      isLoading: loadingFetchingAddress,
      onTap: () async {
        showDialog(
          context: context,
          builder: (dialogContext) {
            TextEditingController addressNameController =
                TextEditingController();
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.save_location_name,
                      textAlign: TextAlign.center,
                    ),
                    AppTextField(controller: addressNameController),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.withOpacity(.5),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.cancel,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            child: ElevatedButton(
                          onPressed: () async {
                            BlocProvider.of<RequestOfferBloc>(context).add(
                              CoordsChangedEvent(
                                lat: currentUserCoords.lat,
                                lng: currentUserCoords.lng,
                              ),
                            );
                            String address = await LocationService.fetchAddress(
                              currentUserCoords,
                            );
                            BlocProvider.of<RequestOfferBloc>(context).add(
                              AddressChangedEvent(address: address),
                            );

                            BlocProvider.of<SaveLocationBloc>(context)
                                .add(SaveLocation(
                              myLocationsModel: MyLocationsModel(
                                id: -1,
                                lat: currentUserCoords.lat,
                                lng: currentUserCoords.lng,
                                address: address,
                                name: addressNameController.text,
                              ),
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          child:
                              Text(AppLocalizations.of(context)!.save_and_pick,maxLines: 1,style:TextStyle(overflow: TextOverflow.ellipsis)),
                        ))
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _onChanged(dynamic val) => debugPrint(val.toString());
}

