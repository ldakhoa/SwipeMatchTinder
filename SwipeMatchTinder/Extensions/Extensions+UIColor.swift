import UIKit

extension UIColor {
	static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
		return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
	}
    
    static var officialApplePlaceholderGray: UIColor {
        return UIColor(red: 0, green: 0, blue: 0.0980392, alpha: 0.22)
    }
}
