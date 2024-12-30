import Preferences
import libroot

class CaskRootListController: PSListController {

    let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    let iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))

    override init(forContentSize contentSize: CGSize) {
        super.init(forContentSize: contentSize)
        
        navigationItem.titleView = UIView()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Cask 3"
        navigationItem.titleView!.addSubview(titleLabel)
       
        iconView.contentMode = .scaleAspectFit
       
        iconView.image = UIImage(contentsOfFile: jbRootPath("/Library/PreferenceBundles/cask3prefs.bundle/icon@3x.png"))
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.alpha = 0.0
        navigationItem.titleView!.addSubview(iconView)
       
        let headerImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 250))
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.image = UIImage(contentsOfFile: jbRootPath("/Library/PreferenceBundles/cask3prefs.bundle/banner.png"))
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(headerImageView)

        NSLayoutConstraint.activate(
            [
                titleLabel.topAnchor.constraint(equalTo: navigationItem.titleView!.topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: navigationItem.titleView!.leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: navigationItem.titleView!.trailingAnchor),
                titleLabel.bottomAnchor.constraint(equalTo: navigationItem.titleView!.bottomAnchor),
                iconView.topAnchor.constraint(equalTo: navigationItem.titleView!.topAnchor),
                iconView.leadingAnchor.constraint(equalTo: navigationItem.titleView!.leadingAnchor),
                iconView.trailingAnchor.constraint(equalTo: navigationItem.titleView!.trailingAnchor),
                iconView.bottomAnchor.constraint(equalTo: navigationItem.titleView!.bottomAnchor),
                headerImageView.topAnchor.constraint(equalTo: headerView.topAnchor),
                headerImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
                headerImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
                headerImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            ]
        )
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y

        if offsetY > 100 {
            UIView.animate(withDuration: 0.2, animations: {
                self.iconView.alpha = 1.0
                self.titleLabel.alpha = 0.0
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.iconView.alpha = 0.0
                self.titleLabel.alpha = 1.0
            })
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.tableHeaderView = headerView
        return super.tableView(tableView, cellForRowAt: indexPath)
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UISwitch.appearance(whenContainedInInstancesOf: [CaskRootListController.self]).onTintColor = UIColor(red: 1.00, green: 0.42, blue: 0.55, alpha: 1.00)
    }

    var appSpecifiers: [PSSpecifier] {
        let bannedIdentifiers: Set<String> = [
            "com.apple.sidecar",
            "com.apple.compass",
            "com.apple.AppStore",
            "com.apple.measure",
            "com.apple.calculator",
            "com.apple.tv"
        ]
        
        var specifiers: [PSSpecifier] = []
        let groupSpecifier = PSSpecifier.groupSpecifier(withName: "Per-app Customization:").unsafelyUnwrapped
        specifiers.append(groupSpecifier)

        let dataSourceUser = SBSCopyDisplayIdentifiers().takeRetainedValue() as! Set<String>
        dataSourceUser
            .compactMap { appIdentifier -> (String, String)? in
                guard !bannedIdentifiers.contains(appIdentifier), let appName = SBSCopyLocalizedApplicationNameForDisplayIdentifier(appIdentifier) else { return nil }
                return (appIdentifier, appName)
            }
            .sorted(by: { $0.1 < $1.1 })
            .forEach { bundleIdentifier, displayName in
                if let spe = PSSpecifier.preferenceSpecifierNamed(displayName, target: self, set: nil, get: nil, detail: CaskAppSettingsController.self, cell: PSCellType.linkListCell, edit: nil) {
                    spe.setProperty("IBKWidgetSettingsController", forKey: "detail")
                    spe.setProperty(true, forKey: "isController")
                    spe.setProperty(true, forKey: "enabled")
                    spe.setProperty(bundleIdentifier, forKey: "bundleIdentifier")
                    spe.setProperty(bundleIdentifier, forKey: "appIDForLazyIcon")
                    spe.setProperty(true, forKey: "useLazyIcons")
                    specifiers.append(spe)
                }
            }

        return specifiers
    }

    override var specifiers: NSMutableArray? {
        get {
            if let specifiers = value(forKey: "_specifiers") as? NSMutableArray {
                return specifiers
            } else {
                let specifiers = loadSpecifiers(fromPlistName: "Root", target: self)
                specifiers?.addObjects(from: appSpecifiers)
                setValue(specifiers, forKey: "_specifiers")
                return specifiers
            }
        }
        set {
            super.specifiers = newValue
        }
    }

    override func readPreferenceValue(_ specifier: PSSpecifier!) -> Any! {
        guard let defaultPath = specifier.properties["defaults"] as? String else {
            return super.readPreferenceValue(specifier)
        }

        let path = jbRootPath("/var/mobile/Library/Preferences/\(defaultPath).plist")
        let settings = NSDictionary(contentsOfFile: path)

        return settings?[specifier.property(forKey: "key") as Any] ?? specifier.property(forKey: "default")
    }
    
    override func setPreferenceValue(_ value: Any!, specifier: PSSpecifier!) {
        let path = jbRootPath("/var/mobile/Library/Preferences/\(specifier.properties["defaults"] as! String).plist")
        let prefs = NSMutableDictionary(contentsOfFile:path) ?? NSMutableDictionary()
        
        prefs.setValue(value, forKey: specifier.property(forKey: "key") as! String)
        prefs.write(toFile: path, atomically: true)

        if let postNotification = specifier.properties["PostNotification"] {
            let notificationName = CFNotificationName(postNotification as! CFString)
            CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), notificationName, nil, nil, true)
        }
    }
}
