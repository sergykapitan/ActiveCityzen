import UIKit
import MaterialComponents

class CustomTabViewIndicator: NSObject, MDCTabBarIndicatorTemplate {
    func indicatorAttributes(for context: MDCTabBarIndicatorContext) -> MDCTabBarIndicatorAttributes {
        let attributes = MDCTabBarIndicatorAttributes()
        // Outset frame, round corners, and stroke.
        let indicatorFrame = context.bounds.insetBy(dx: 4, dy: 8)
        let path = UIBezierPath(roundedRect: indicatorFrame, cornerRadius: 4)
        attributes.path = path
        return attributes
    }
}
