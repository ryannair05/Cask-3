import UIKit

enum AnimationStyle: Int {
    case none
    case fade
    case flip
    case bounce
    case color
    case permanentColor
    case glitch
    case helix
    case rotate
    case zoom
    case drop
    case stretch
    case slide
    case shake
    case swing
    case jiggle
}

struct Cask {
    let animateAlways: Bool
    let animation: @MainActor (UITableViewCell) -> Void

    init(animStyle: AnimationStyle, duration: Double, animateAlways: Bool) {
        self.animateAlways = animateAlways

        switch animStyle {
        case .none: 
            animation = { _ in

            }
        case .fade:
            animation = { result in
                let original = result.alpha
                result.alpha = 0.0
                UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction, .allowAnimatedContent, .curveEaseOut], animations: {
                    result.alpha = original
                })
            }
        case .flip:
            animation = { result in
                let original = result.layer.transform
                result.layer.transform = CATransform3DMakeRotation(.pi, 1, 0, 0)
                UIView.animate(withDuration: duration, delay: 0, options: [.allowUserInteraction, .allowAnimatedContent, .curveEaseOut], animations: {
                    result.layer.transform = original
                })
            }
        case .bounce:
            animation = { result in
                let original = result.transform
                result.transform = CGAffineTransform(scaleX: 0.01, y: 1.0)
                UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10.0, options: [.allowUserInteraction, .allowAnimatedContent, .curveEaseOut], animations: {
                    result.transform = original
                })
            }
        case .color:
            animation = { result in
                let original = result.backgroundColor
                let red = CGFloat.random(in: 0...1)
                let green = CGFloat.random(in: 0...1)
                let blue = CGFloat.random(in: 0...1)
                result.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
                UIView.animate(withDuration: duration, delay: 0, options: [.allowUserInteraction, .allowAnimatedContent, .curveEaseOut], animations: {
                    result.backgroundColor = original
                })
            }
        case .permanentColor:
            animation = { result in
                let original = result.backgroundColor
                let red = CGFloat.random(in: 0...1)
                let green = CGFloat.random(in: 0...1)
                let blue = CGFloat.random(in: 0...1)
                result.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
                UIView.animate(withDuration: duration, delay: 0, options: [.allowUserInteraction, .allowAnimatedContent, .curveLinear, .repeat, .autoreverse], animations: {
                    result.backgroundColor = original
                })
            }
        case .glitch:
            animation = { result in
                let original = result.transform
                result.transform = CGAffineTransform(scaleX: 0.3, y: 0.5)
                UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.0, initialSpringVelocity: 10.0, options: [.allowUserInteraction, .allowAnimatedContent, .curveEaseOut], animations: {
                    result.transform = original
                })
            }
        case .helix:
            animation = { result in
                let original = result.layer.transform
                let layer = result.layer
                result.layer.transform = CATransform3DIdentity
                result.layer.transform = CATransform3DTranslate(result.layer.transform, 0.0, layer.bounds.size.height/2.0, 0.0)
                result.layer.transform = CATransform3DRotate(result.layer.transform, .pi, 0.0, 1.0, 0.0)
                result.layer.transform = CATransform3DTranslate(result.layer.transform, 0.0, -layer.bounds.size.height/2.0, 0.0)
                UIView.animate(withDuration: duration, delay: 0, options: [.allowUserInteraction, .allowAnimatedContent, .curveEaseOut], animations: {
                    result.layer.transform = original
                })
            }
        case .rotate:
            animation = { result in
                let original = result.transform
                result.transform = CGAffineTransform(rotationAngle: 360)
                UIView.animate(withDuration: duration, delay: 0, options: [.allowUserInteraction, .allowAnimatedContent, .curveEaseOut], animations: {
                    result.transform = original
                })
            }
        case .zoom:
            animation = { result in
                let original = result.transform
                result.transform =  CGAffineTransform(scaleX: 5, y : 5)
                UIView.animate(withDuration: duration, delay: 0, options: [.allowUserInteraction, .allowAnimatedContent, .curveLinear], animations: {
                    result.transform = original
                })
            }
        case .drop:
            animation = { result in
                let original = result.transform
                result.transform = CGAffineTransform(translationX: 0, y: -150)
                UIView.animate(withDuration: duration, delay: 0, options: [.allowUserInteraction, .allowAnimatedContent, .curveEaseOut], animations: {
                    result.transform = original
                })
            }
        case .stretch:
            animation = { result in
                let original = result.transform
                result.transform = CGAffineTransform(scaleX: 0.01, y: 1.0)
                UIView.animate(withDuration: duration, delay: 0, options: [.allowUserInteraction, .allowAnimatedContent, .curveEaseOut], animations: {
                    result.transform = original
                })
            }
        case .slide:
            animation = { result in
                let original = result.frame
                var newFrame = original
                newFrame.origin.x += original.size.width
                result.frame = newFrame
                UIView.animate(withDuration: duration, delay: 0, options: [.allowUserInteraction, .allowAnimatedContent, .curveEaseOut], animations: {
                    result.frame = original
                })
            }
        case .shake:
            animation = { result in
                let animation = CAKeyframeAnimation(keyPath: "position.x")
                animation.values = [0, 10, -10, 10, -5, 5, -5, 0 ]
                animation.keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1]
                animation.duration = duration
                animation.isAdditive = true
                result.layer.add(animation, forKey: "shake")
            }
        case .swing:
            animation = { result in
                let animation = CAKeyframeAnimation(keyPath: "position.x")
                animation.values = [0, 40, -50, 30, 0]
                animation.keyTimes = [0, 0.16, 0.5, 0.83, 1]
                animation.duration = duration
                animation.isAdditive = true
                result.layer.add(animation, forKey: "swing")
            }
        case .jiggle:
            animation = { result in
                let animation =   CAKeyframeAnimation(keyPath: "transform.rotation.z")
                animation.values = [0, -0.075, 0.075, -0.075, 0.075, 0]
                animation.duration = duration
                animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                animation.isAdditive = true
                animation.repeatCount = 1
                result.layer.add(animation, forKey: "jiggle")
            }
        }
    }
}