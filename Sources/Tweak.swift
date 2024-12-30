import libroot

private var hasMovedToWindow = false
private var animater = Cask(animStyle:.stretch, duration:0.5, animateAlways:false)

private var orig_UIScrollView_isDragging:  (@convention(c) (UIScrollView, Selector) -> Bool)!
private var orig_UIScrollView___scrollViewWillBeginDragging: (@convention(c) (UITableView, Selector) -> Void)!
private var orig_UITableView_reloadData: (@convention(c) (UITableView, Selector) -> Void)!
private var orig_UITableView__createPreparedCellForGlobalRow: (@convention(c) (UITableView, Selector, Int, IndexPath, Bool) -> UITableViewCell)!
private var orig_UIScrollView_initWithFrame: (@convention(c) (UIScrollView, Selector, CGRect) -> UIScrollView)!

private func UIScrollView_isDragging(_ self: UIScrollView, _ _cmd: Selector) -> Bool {
    let original = orig_UIScrollView_isDragging(self, _cmd)
    hasMovedToWindow = !original
    return original
}

private func UITableView_reloadData(_ self: UITableView, _ _cmd: Selector) -> Void {
    hasMovedToWindow = true
    orig_UITableView_reloadData(self, _cmd)
}

private func UITableView__scrollViewWillBeginDragging(_ self: UITableView, _ _cmd: Selector) -> Void {
    hasMovedToWindow = false
    orig_UIScrollView___scrollViewWillBeginDragging(self, _cmd)
}

private func UITableView__createPreparedCellForGlobalRow(_ self: UITableView, _ _cmd: Selector, _ row: Int, _ indexPath: IndexPath, _ willDisplay: Bool) -> UITableViewCell {
    let cell = orig_UITableView__createPreparedCellForGlobalRow(self, _cmd, row, indexPath, willDisplay)

    guard !hasMovedToWindow || animater.animateAlways else {
        return cell
    }

    DispatchQueue.main.async {
        animater.animation(cell)
    }

    return cell
}

let loadPrefs: CFNotificationCallback = {_, _, _, _, _ in
    guard let prefs = NSDictionary(contentsOfFile: jbRootPath("/var/mobile/Library/Preferences/com.ryannair05.cask3.plist")) else { return }
    var animStyle = prefs["style"] as? Int ?? 11
    var duration = prefs["duration"] as? Double ?? 0.5
    var animateAlways = prefs["animateAlways"] as? Bool ?? false

    if let bundleIdentifier = Bundle.main.bundleIdentifier, let appSettings = prefs[bundleIdentifier] as? NSDictionary {
        animStyle = appSettings["style"] as? Int ?? animStyle
        duration = appSettings["duration"] as? Double ?? duration
        animateAlways = appSettings["animateAlways"] as? Bool ?? animateAlways
    }

    let animationStyle = AnimationStyle(rawValue: animStyle) ?? .stretch
    animater = Cask(animStyle:animationStyle, duration:duration, animateAlways:animateAlways)
}

private func replaceMethod<T>(cls: AnyClass, selector: Selector, newImp: T) -> T {
    let method = class_getInstanceMethod(cls, selector).unsafelyUnwrapped
    let newMethodImp = unsafeBitCast(newImp, to: IMP.self)
    return unsafeBitCast(method_setImplementation(method, newMethodImp), to: T.self)
}

@_cdecl("cask_init") func initCask() {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), nil, loadPrefs, "com.ryannair05.cask3/prefsupdated" as CFString, nil, .coalesce)
    loadPrefs(nil, nil, nil, nil, nil)
    if #unavailable(iOS 15) {
        let UIScrollView_initWithFrame : @convention(c) (UIScrollView, Selector, CGRect) -> UIScrollView = { (self, _cmd, frame) -> UIScrollView in
            hasMovedToWindow = false
            return orig_UIScrollView_initWithFrame(self, _cmd, frame);
        } 

        let method = class_getInstanceMethod(UIScrollView.self, #selector(UIScrollView.init(frame:))).unsafelyUnwrapped
        let newMethodImp = unsafeBitCast(UIScrollView_initWithFrame, to: IMP.self)
        orig_UIScrollView_initWithFrame = unsafeBitCast(method_setImplementation(method, newMethodImp), to: (@convention(c) (UIScrollView, Selector, CGRect) -> UIScrollView).self)
    }

    orig_UIScrollView_isDragging = replaceMethod(
        cls: UIScrollView.self,
        selector: #selector(getter: UIScrollView.isDragging),
        newImp: UIScrollView_isDragging as @convention(c) (UIScrollView, Selector) -> Bool
    )

    orig_UITableView_reloadData = replaceMethod(
        cls: UITableView.self,
        selector: #selector(UITableView.reloadData),
        newImp: UITableView_reloadData as @convention(c) (UITableView, Selector) -> Void
    )

    orig_UIScrollView___scrollViewWillBeginDragging = replaceMethod(
        cls: UIScrollView.self,
        selector: #selector(UIScrollView._scrollViewWillBeginDragging),
        newImp: UITableView__scrollViewWillBeginDragging as @convention(c) (UITableView, Selector) -> Void
    )

    orig_UITableView__createPreparedCellForGlobalRow = replaceMethod(
        cls: UITableView.self,
        selector: #selector(UITableView._createPreparedCell),
        newImp: UITableView__createPreparedCellForGlobalRow as @convention(c) (UITableView, Selector, Int, IndexPath, Bool) -> UITableViewCell
    )
}
