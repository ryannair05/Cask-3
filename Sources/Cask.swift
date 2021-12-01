import UIKit

struct Cask {

    let animStyle: Int
    let duration: Double
    let animateAlways: Bool

    func animatedTable(_ result: UITableViewCell, _ hasMovedToWindow : Bool) -> UITableViewCell {
    
        if hasMovedToWindow && !animateAlways {
            return result
        }

        let defaultOptions = UIView.AnimationOptions.allowUserInteraction.union(.allowAnimatedContent)

        switch animStyle {
            case 1: // Fade
                DispatchQueue.main.async(execute: {
                    let original = result.alpha
                    result.alpha = 0.0
                    UIView.animate(withDuration: duration, delay: 0.0, options: [defaultOptions, .curveEaseOut], animations: {
                        result.alpha = original
                    })
                })
            case 2: // Flip
                DispatchQueue.main.async(execute: {
                    let original = result.layer.transform
                    result.layer.transform = CATransform3DMakeRotation(.pi, 1, 0, 0)
                    UIView.animate(withDuration: duration, delay: 0, options: [defaultOptions, .curveEaseOut], animations: {
                        result.layer.transform = original
                    })
                })
            case 3: // Bounce
                DispatchQueue.main.async(execute: {
                    let original = result.transform
                    result.transform = CGAffineTransform(scaleX: 0.01, y: 1.0)
                    UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10.0, options: [defaultOptions, .curveEaseOut], animations: {
                        result.transform = original
                    })
                })
            case 4: // Color
                DispatchQueue.main.async(execute: {
                    let original = result.backgroundColor
                    let red = CGFloat.random(in: 0...1)
                    let green = CGFloat.random(in: 0...1)
                    let blue = CGFloat.random(in: 0...1)
                    result.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
                    UIView.animate(withDuration: duration, delay: 0.0, options: [defaultOptions, .curveEaseOut], animations: {
                        result.backgroundColor = original
                    })
                })
            case 5: // Permanent Color
                DispatchQueue.main.async(execute: {
                    let original = result.backgroundColor
                    let red = CGFloat.random(in: 0...1)
                    let green = CGFloat.random(in: 0...1)
                    let blue = CGFloat.random(in: 0...1)
                    result.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
                    UIView.animate(withDuration: duration, delay: 0.0, options: [defaultOptions, .curveLinear, .repeat, .autoreverse], animations: {
                        result.backgroundColor = original
                    })
                })
            case 6: // Glitch
                DispatchQueue.main.async(execute: {
                    let original = result.transform
                    result.transform = CGAffineTransform(scaleX: 0.3, y: 0.5)
                    UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.0, initialSpringVelocity: 10.0, options: [defaultOptions, .curveEaseOut], animations: {
                        result.transform = original
                    })
                })
            case 7: // Helix
                DispatchQueue.main.async(execute: {
                    let original = result.layer.transform
                    let layer = result.layer
                    result.layer.transform = CATransform3DIdentity
                    result.layer.transform = CATransform3DTranslate(result.layer.transform, 0.0, layer.bounds.size.height/2.0, 0.0)
                    result.layer.transform = CATransform3DRotate(result.layer.transform, CGFloat(Double.pi), 0.0, 1.0, 0.0)
                    result.layer.transform = CATransform3DTranslate(result.layer.transform, 0.0, -layer.bounds.size.height/2.0, 0.0)
                    UIView.animate(withDuration: duration, delay: 0, options: [defaultOptions, .curveEaseOut], animations: {
                        result.layer.transform = original
                    })
                })
            case 8: // Rotate
                DispatchQueue.main.async(execute: {
                    let original = result.transform
                    result.transform = CGAffineTransform(rotationAngle: 360)
                    UIView.animate(withDuration: duration, delay: 0.0, options: [defaultOptions, .curveEaseOut], animations: {
                    result.transform = original
                    })
                })
            case 9: // Zoom
                DispatchQueue.main.async(execute: {
                    let original = result.transform
                    result.transform =  CGAffineTransform(scaleX: 5, y : 5)
                    UIView.animate(withDuration: duration, delay: 0.0, options: [defaultOptions, .curveLinear], animations: {
                        result.transform = original
                    })
                })
            case 10: // Drop
                DispatchQueue.main.async(execute: {
                    let original = result.transform
                    result.transform = CGAffineTransform(translationX: 0, y: -150)
                    UIView.animate(withDuration: duration, delay: 0.0, options: [defaultOptions, .curveEaseOut], animations: {
                        result.transform = original
                    })
                })
            case 11: // Stretch
                DispatchQueue.main.async(execute: {
                    let original = result.transform
                    result.transform = CGAffineTransform(scaleX: 0.01, y: 1.0)
                    UIView.animate(withDuration: duration, delay: 0.0, options: [defaultOptions, .curveEaseOut], animations: {
                        result.transform = original
                    })
                })
            case 12: // Slide
                DispatchQueue.main.async(execute: {
                    let original = result.frame
                    var newFrame = original
                    newFrame.origin.x += original.size.width
                    result.frame = newFrame
                    UIView.animate(withDuration: duration, delay: 0.0, options: [defaultOptions, .curveEaseOut], animations: {
                        result.frame = original
                    })
                })
            default: // None
                break
        }

        return result
    }
}