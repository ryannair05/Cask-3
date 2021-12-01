import Orion
import UIKit

var hasMovedToWindow = false
var animater = Cask(animStyle:11, duration:0.5, animateAlways:false)

class UIScrollViewHook : ClassHook<UIScrollView> {

    func initWithFrame(_ frame: CGRect) -> UIScrollView {
        hasMovedToWindow = false
        return orig.initWithFrame(frame);
    }

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

        return animater.animatedTable(cell, hasMovedToWindow)
    }
}

let loadPrefs: CFNotificationCallback = {center, observer, name, object, userInfo in
    if let prefs = NSDictionary(contentsOfFile:"/User/Library/Preferences/com.ryannair05.cask3.plist") {
        var animStyle = prefs["style"] as? Int ?? 11
        var duration = prefs["duration"] as? Double ?? 0.5
        var animateAlways = prefs["animateAlways"] as? Bool ?? false

        if let bundleIdentifier = Bundle.main.bundleIdentifier, let appSettings = prefs[bundleIdentifier] as? NSDictionary {
            animStyle = appSettings["style"] as? Int ?? animStyle
            duration = appSettings["duration"] as? Double ?? duration
            animateAlways = appSettings["animateAlways"] as? Bool ?? animateAlways
        }

        animater = Cask(animStyle:animStyle, duration:duration, animateAlways:animateAlways)
    }
}

struct Cask3 : Tweak {
    init() {
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), nil, loadPrefs, "com.ryannair05.cask3/prefsupdated" as CFString, nil, .coalesce)
        loadPrefs(nil, nil, nil, nil, nil)
    }
}
