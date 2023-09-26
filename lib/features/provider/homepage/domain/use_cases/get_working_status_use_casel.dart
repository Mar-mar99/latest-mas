import '../../../../../core/utils/services/shared_preferences.dart';

class GetWorkingStatusUseCase{


 bool call(){
     bool? isWorking =  PreferenceUtils.getbool(
      "isWorking",
    );
    if (isWorking != null) {
          print('is working sharedPref $isWorking');

      return isWorking;
    } else {
      return false;
    }
  }
}
