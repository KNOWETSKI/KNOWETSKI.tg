import UIKit

public enum PiosStyle {
    public static let fontName: String = "PerfectDOSVGA437"

    public static func font(size: CGFloat) -> UIFont? {
        let pixelSize: CGFloat = size >= 26.0 ? 32.0 : 16.0
        return UIFont(name: PiosStyle.fontName, size: pixelSize)
    }
}
