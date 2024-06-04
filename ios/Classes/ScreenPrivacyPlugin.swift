import Flutter
import UIKit

public class ScreenPrivacyPlugin: NSObject, FlutterPlugin {

  private var textField = UITextField();
  private var screenshotBlock = false
  private var firstInit = false
  private var isPrivacyEnabled = false
  private var screenshotObserve: NSObjectProtocol? = nil
  private var screenRecordObserve: NSObjectProtocol? = nil
  private var becomeActiveNotification: NSObjectProtocol? = nil
  private var tempObserver: NSObjectProtocol? = nil
  private var resignActiveNotification: NSObjectProtocol? = nil
  public  static var screenCaptureEventSink: FlutterEventSink? = nil;

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "screen_privacy", binaryMessenger: registrar.messenger())
    let instance = ScreenPrivacyPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    let scanResultEvents = FlutterEventChannel(name: "screen_privacy/events", binaryMessenger: registrar.messenger())
    scanResultEvents.setStreamHandler(ScreenCaptureEvents())
  }

   public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
          switch call.method {
          case "disableScreenshot":
              screenshotBlock = true;
              setupObserver()
              if firstInit {
                  textField.isSecureTextEntry = true;
              } else{
                  UIApplication.shared.keyWindow?.disableScreenshot(field:  textField);
                  firstInit=true
              }
              result("Method channel call [disableScreenshot]")
          case "enableScreenshot":
              removeAllObserver()
              screenshotBlock = false;
              UIApplication.shared.keyWindow?.enableScreenshot(field: textField);
              result("Method channel call [enableScreenshot]")
          case "isScreenshotDisabled":
              result(screenshotBlock)
          case "enablePrivacyScreen":
              if(isPrivacyEnabled == false){
                  isPrivacyEnabled = true;
                  setupPrivacyScreenObserver()
              }

              result("Method channel call [enablePrivacyScreen] | isPrivacyEnabled = \(isPrivacyEnabled)")
          case "disablePrivacyScreen":
              isPrivacyEnabled = false;
              removePrivacyScreenObserver()
              result("Method channel call [disablePrivacyScreen]")
          default:
              result(FlutterMethodNotImplemented)
          }
      }


    public func setupObserver(){
        print("setupObserver")

        screenshotObserver{
            print("Screenshot making")
            ScreenPrivacyPlugin.screenCaptureEventSink?(true);

        }

        if #available(iOS 11.0, *) {
            screenRecordObserver { isCaptured in
                print("Screen recording  \(isCaptured)")
                ScreenPrivacyPlugin.screenCaptureEventSink?(isCaptured);
            }
        }
    }


    public func screenshotObserver(using onScreenshot: @escaping () -> Void) {
        screenshotObserve = NotificationCenter.default.addObserver(
            forName: UIApplication.userDidTakeScreenshotNotification,
            object: nil,
            queue: OperationQueue.main
        ) { notification in
            onScreenshot()
        }
    }
    // How to used:
    //
    // if #available(iOS 11.0, *) {
    //     screenProtectorKit.screenRecordObserver { isCaptured in
    //         // Callback on Screen Record
    //     }
    // }
    @available(iOS 11.0, *)
    public func screenRecordObserver(using onScreenRecord: @escaping (Bool) -> Void) {
        screenRecordObserve =
        NotificationCenter.default.addObserver(
            forName: UIScreen.capturedDidChangeNotification,
            object: nil,
            queue: OperationQueue.main
        ) { notification in
            let isCaptured = UIScreen.main.isCaptured
            onScreenRecord(isCaptured)
        }
    }



    public func removeAllObserver() {
        print("removeAllObserver")
        removeScreenRecordObserver()
        removeScreenshotObserver()
    }
    public func removeScreenRecordObserver() {
            if screenRecordObserve != nil {
                self.removeObserver(observer: screenRecordObserve)
                self.screenRecordObserve = nil
            }
        }


        public func removeScreenshotObserver() {
            if screenshotObserve != nil {
                self.removeObserver(observer: screenshotObserve)
                self.screenshotObserve = nil
            }
        }

        public func removeObserver(observer: NSObjectProtocol?) {
            guard let obs = observer else {return}
            NotificationCenter.default.removeObserver(obs)
        }


        public func setupPrivacyScreenObserver(){
            print("setupPrivacyScreenObserver")

            if let window = UIApplication.shared.windows.first {
              let v = window.rootViewController?.view
              v?.backgroundColor = .clear

              let blurEffect = UIBlurEffect(style: .light)
              let blurEffectView = UIVisualEffectView(effect: blurEffect)

              // Always fill the view
              blurEffectView.frame = v?.bounds ?? CGRect.zero
              blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
              blurEffectView.tag = 55

              v?.addSubview(blurEffectView)
            }
        }

        public func removePrivacyScreenObserver() {
            print("removePrivacyScreenObserver")

            if let window = UIApplication.shared.windows.first {
                window.rootViewController?.view?.viewWithTag(55)?.removeFromSuperview()
            }
        }
}


extension UIWindow {

    func disableScreenshot(field: UITextField) {
        DispatchQueue.main.async {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: field.frame.self.width, height: field.frame.self.height))
            field.isSecureTextEntry = true
            self.addSubview(field)
            self.layer.superlayer?.addSublayer(field.layer)
            field.layer.sublayers?.last!.addSublayer(self.layer)
            field.leftView = view
            field.leftViewMode = .always
        }
    }

    func enableScreenshot(field: UITextField) {
        field.isSecureTextEntry = false
    }
}


class ScreenCaptureEvents: NSObject, FlutterStreamHandler{

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        ScreenPrivacyPlugin.screenCaptureEventSink = events
        return nil
    }


    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        ScreenPrivacyPlugin.screenCaptureEventSink = nil;
        return nil
    }
}
