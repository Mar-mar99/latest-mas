import UIKit
import Flutter
import GoogleMaps
import CoreLocation


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate,CLLocationManagerDelegate {

    private var locationManager:CLLocationManager?
    var result: FlutterResult?

    var token: String?


  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let videoCallChannel = FlutterMethodChannel(name: "Masbar/TrackingLocation",
                                                  binaryMessenger: controller.binaryMessenger,)
          videoCallChannel.setMethodCallHandler({
              (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
              self.result = result
              switch call.method {
                case "startLocationService":
                  do {
                    let arguments = call.arguments as? NSDictionary
                      self.token = arguments!["token"] as? String
                      self.startGetUserLocation()
                  }
                case "stopLocationService":
                  do {
                      self.stopGetUserLocation()
                  }
                  default:
                  result(FlutterMethodNotImplemented)
                }
          })

    GMSServices.provideAPIKey("AIzaSyCuJqhCpPBI5Qx4gbE6GxvOkP_96ifaoF0")
      GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    func startGetUserLocation() {
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
        if #available(iOS 11.0, *) {
            locationManager?.showsBackgroundLocationIndicator = true
        } else {

        }

       }



    func stopGetUserLocation(){
        locationManager?.stopUpdatingLocation()
    }

    // MARK: - Call API to update Location in service
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("Lat : \(location.coordinate.latitude) \nLng : \(location.coordinate.longitude)")
            updateLocationInService(location: locations)
        }

    }


    func updateLocationInService(location: [CLLocation]){

        guard let url = URL(string: "https://dashboard.masbar.ae/api/provider/set-location")else{
            return
        }
        var request = URLRequest(url: url)
        var barerToken = "Bearer \(String(describing: token))"
        request.httpMethod = "POST"
        request.setValue("X-Requested-With", forHTTPHeaderField:"XMLHttpRequest")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Authorization", forHTTPHeaderField: barerToken)

       let loc = location.last

        let body: [String: Any] = [
            "latitude": Double(loc?.coordinate.latitude ?? 0),
            "longitude": Double(loc?.coordinate.longitude ?? 0 ),
        ]

        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )

        request.httpBody = bodyData

        let task = URLSession.shared.dataTask(with: request, completionHandler: {data,_,error in
            guard let data = data, error == nil else{
                return
            }

        })

        task.resume()

    }

}
