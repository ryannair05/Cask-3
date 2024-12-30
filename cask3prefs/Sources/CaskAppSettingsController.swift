import Preferences
import libroot

class CaskAppSettingsController: PSListController {

    var displayName: String?
    var bundleIdentifier: String?

    override var specifiers: NSMutableArray? {
        get {
            if let specifiers = value(forKey: "_specifiers") as? NSMutableArray {
                return specifiers
            } else {
                let specifiers = loadSpecifiers(fromPlistName: "AppSettings", target: self)
                setValue(specifiers, forKey: "_specifiers")
                return specifiers
            }
        }
        set {
            super.specifiers = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = displayName
    }

    override var specifier: PSSpecifier? {
        didSet {
            displayName = specifier!.name
            bundleIdentifier = specifier!.property(forKey: "bundleIdentifier") as? String
        }
    }

    override func readPreferenceValue(_ specifier: PSSpecifier!) -> Any! {
        guard let bundleIdentifier = bundleIdentifier, let defaultPath = specifier.properties["defaults"] as? String else {
            return super.readPreferenceValue(specifier)
        }

        let path = jbRootPath("/var/mobile/Library/Preferences/\(defaultPath).plist")
        let settings = NSDictionary(contentsOfFile: path)

        if let appSettings = settings?.object(forKey: bundleIdentifier) as? NSDictionary {
            return appSettings[specifier.property(forKey: "key") as Any]
        }
        
        return settings?[specifier.property(forKey: "key") as Any] ?? specifier.property(forKey: "default")
    }
    
    override func setPreferenceValue(_ value: Any!, specifier: PSSpecifier!) {
        guard let bundleIdentifier = bundleIdentifier else {
            return
        }

        let path = jbRootPath("/var/mobile/Library/Preferences/\(specifier.properties["defaults"] as! String).plist")
        let prefs = NSMutableDictionary(contentsOfFile:path) ?? NSMutableDictionary()
        let appPrefs = prefs.object(forKey: bundleIdentifier) as? NSMutableDictionary ?? NSMutableDictionary()

        appPrefs.setValue(value, forKey: specifier.property(forKey: "key") as! String)
        prefs.setValue(appPrefs, forKey: bundleIdentifier)

        prefs.write(toFile: path, atomically: true)
        
        if let postNotification = specifier.properties["PostNotification"] as? CFNotificationName {
            CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), postNotification, nil, nil, true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UISwitch.appearance(whenContainedInInstancesOf: [CaskAppSettingsController.self]).onTintColor = UIColor(red: 1.00, green: 0.42, blue: 0.55, alpha: 1.00)
    }
}
