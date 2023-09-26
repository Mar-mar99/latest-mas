import '../../../../../core/api_service/base_api_service.dart';
import '../../../../../core/constants/api_constants.dart';
import '../model/my_locations_model.dart';

abstract class MyLocationsDataSource {
  Future<List<MyLocationsModel>> getSavedLocations();
  Future<void> saveLocations({required MyLocationsModel newLocation});
    Future<void> deleteLocation({required int id});
}

class MyLocationsDataSourceWithHttp implements MyLocationsDataSource {
  final BaseApiService client;
  MyLocationsDataSourceWithHttp({
    required this.client,
  });
  @override
  Future<List<MyLocationsModel>> getSavedLocations() async {
    final List<MyLocationsModel> data = [];
    final res = await client.getRequest(url: ApiConstants.getSavedLocation);
    res['Locations'].forEach((c) {
      data.add(MyLocationsModel.fromJson(c));
    });
    return data;
  }

  @override
  Future<void> saveLocations({required MyLocationsModel newLocation}) async {

    final res = await client.postRequest(
        url: ApiConstants.saveLocation, jsonBody: newLocation.toJson());

  }

  @override
  Future<void> deleteLocation({required int id}) async{

       final res = await client.getRequest(url: ApiConstants.deleteLocation+'/$id');
  }
}
