import Orion
import UIKit

var hasMovedToWindow = false
var animater = Cask(animStyle:.stretch, duration:0.5, animateAlways:false)

struct iOS14: HookGroup {}

class UIScrollView14Hook : ClassHook<UIScrollView> {
    typealias Group = iOS14

    func initWithFrame(_ frame: CGRect) -> UIScrollView {
        hasMovedToWindow = false
        return orig.initWithFrame(frame);
    }
}

class UIScrollViewHook : ClassHook<UIScrollView> {
    func _scrollViewWillBeginDragging() {
        hasMovedToWindow = false
        orig._scrollViewWillBeginDragging()
    }

    func isDragging() -> Bool {
        let original = orig.isDragging()
        hasMovedToWindow = !original
        return original
    }
}

class UITableViewHook : ClassHook<UITableView> {

    func reloadData() {
        hasMovedToWindow = true
        orig.reloadData()
    }

    func _createPreparedCellForGlobalRow(_ row: Int, withIndexPath indexPath: IndexPath, willDisplay: Bool) -> UITableViewCell {
        let cell = orig._createPreparedCellForGlobalRow(row, withIndexPath: indexPath, willDisplay: willDisplay)

        guard !hasMovedToWindow || animater.animateAlways else {
            return cell
        }

        DispatchQueue.main.async {
            animater.animation(cell)
        }

        return cell
    }
}

let loadPrefs: CFNotificationCallback = {_, _, _, _, _ in
    guard let prefs = NSDictionary(contentsOfFile:"/var/mobile/Library/Preferences/com.ryannair05.cask3.plist") else { return }
    
    var animStyle = prefs["style"] as? Int ?? 11
    var duration = prefs["duration"] as? Double ?? 0.5
    var animateAlways = prefs["animateAlways"] as? Bool ?? false

    if let bundleIdentifier = Bundle.main.bundleIdentifier, let appSettings = prefs[bundleIdentifier] as? NSDictionary {
        animStyle = appSettings["style"] as? Int ?? animStyle
        duration = appSettings["duration"] as? Double ?? duration
        animateAlways = appSettings["animateAlways"] as? Bool ?? animateAlways
    }

    let animationStyle = AnimationStyle(rawValue: animStyle) ?? .none
    animater = Cask(animStyle:animationStyle, duration:duration, animateAlways:animateAlways)
}

struct Cask3 : Tweak {
    init() {
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), nil, loadPrefs, "com.ryannair05.cask3/prefsupdated" as CFString, nil, .coalesce)
        loadPrefs(nil, nil, nil, nil, nil)
        if #unavailable(iOS 15) {
            iOS14().activate()
        }
    }
}
