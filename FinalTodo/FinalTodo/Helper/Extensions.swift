//
//  Extensions.swift
//  FinalTodo
//
//  Created by SR on 2023/10/11.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

// Date 객체의 확장을 통해 특정 날짜의 시작 시간을 가져오는 기능
extension Date {
    // 해당 날짜의 시작 시간을 반환
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
}

extension UIView {
    func shake() {
        self.transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}

extension UINavigationController {
    func popViewController(animated: Bool, completion: @escaping (() -> ())) {
        CATransaction.setCompletionBlock(completion)
        CATransaction.begin()
        _ = self.popViewController(animated: animated)
        CATransaction.commit()
    }

    func pushViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping (() -> ())) {
        CATransaction.setCompletionBlock(completion)
        CATransaction.begin()
        self.pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
}

extension UIColor {
    static var myPointColor = UIColor(hex: CoreDataManager.shared.getUser().themeColor)
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        if hex == "error" {
            self.init(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

            if hexFormatted.hasPrefix("#") {
                hexFormatted = String(hexFormatted.dropFirst())
            }

            assert(hexFormatted.count == 6, "Invalid hex code used.")

            var rgbValue: UInt64 = 0
            Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

            self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                      alpha: alpha)
        }
    }

    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb = Int(r*255)<<16 | Int(g*255)<<8 | Int(b*255)<<0

        return String(format: "#%06x", rgb)
    }
}

// 배경색 채도에 따른 텍스트 컬러변경
extension UIColor {
    static func appropriateTextColor(forBackgroundColor backgroundColor: UIColor) -> UIColor {
        var brightness: CGFloat = 0.0
        backgroundColor.getWhite(&brightness, alpha: nil)
        return brightness > 0.5 ? .black : .white
    }
}

extension DateFormatter {
    static let yourFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
}
