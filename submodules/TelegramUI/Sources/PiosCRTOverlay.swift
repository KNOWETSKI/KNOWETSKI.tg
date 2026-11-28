import UIKit

private final class PiosCRTWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
}

private final class PiosCRTView: UIView {
    private let vignetteLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.isUserInteractionEnabled = false
        self.backgroundColor = UIColor(patternImage: PiosCRTView.scanlineImage())

        self.vignetteLayer.type = .radial
        self.vignetteLayer.colors = [
            UIColor(white: 0.0, alpha: 0.0).cgColor,
            UIColor(white: 0.0, alpha: 0.7).cgColor
        ]
        self.vignetteLayer.locations = [0.5, 1.0]
        self.vignetteLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        self.vignetteLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.layer.addSublayer(self.vignetteLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.vignetteLayer.frame = self.bounds
    }

    private static func scanlineImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1.0, height: 3.0))
        return renderer.image { context in
            UIColor(white: 0.0, alpha: 0.6).setFill()
            context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        }
    }
}

private nonisolated(unsafe) var piosCRTWindowStorage: UIWindow?

public enum PiosCRTOverlay {
    public static func install(windowScene: UIWindowScene?) {
        guard let windowScene = windowScene else {
            return
        }
        if piosCRTWindowStorage != nil {
            return
        }
        let window = PiosCRTWindow(windowScene: windowScene)
        window.frame = windowScene.screen.bounds
        window.windowLevel = UIWindow.Level(rawValue: UIWindow.Level.alert.rawValue + 1.0)
        window.backgroundColor = .clear
        window.isUserInteractionEnabled = false

        let controller = UIViewController()
        controller.view = PiosCRTView(frame: window.bounds)
        window.rootViewController = controller
        window.isHidden = false

        piosCRTWindowStorage = window
    }
}
