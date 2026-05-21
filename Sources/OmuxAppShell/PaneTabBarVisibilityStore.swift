import Foundation

@MainActor
protocol PaneTabBarVisibilityStoring: AnyObject {
    var isPaneTabBarVisible: Bool { get set }
}

@MainActor
final class PaneTabBarVisibilityStore: PaneTabBarVisibilityStoring {
    static let shared = PaneTabBarVisibilityStore()

    private let defaults: UserDefaults
    private let key = "dev.fingergun.omux.paneTabBarVisible"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var isPaneTabBarVisible: Bool {
        get {
            if defaults.object(forKey: key) == nil {
                return true
            }
            return defaults.bool(forKey: key)
        }
        set {
            defaults.set(newValue, forKey: key)
        }
    }
}
