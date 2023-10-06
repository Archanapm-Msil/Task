
import UIKit
import Flutter
import CoreTelephony


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private let CHANNEL = "sim_card_reader"

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        let controller = window?.rootViewController as! FlutterViewController
        let methodChannel = FlutterMethodChannel(
            name: CHANNEL,
            binaryMessenger: controller.binaryMessenger
        )

        methodChannel.setMethodCallHandler { [weak self] (call, result) in
            if call.method == "getSimCardInfo" {
                let simInfo = self?.getSimCardInfo()
                result(simInfo)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func getSimCardInfo() -> [String: String] {
        var simInfo = [String: String]()

        if let carrier = CTTelephonyNetworkInfo().subscriberCellularProvider {
            let phoneNumber = carrier.isoCountryCode ?? "" + (carrier.mobileCountryCode ?? "")
            let carrierName = carrier.carrierName ?? ""

            simInfo["phoneNumber"] = phoneNumber
            simInfo["carrierName"] = carrierName
        }

        return simInfo
    }
}
