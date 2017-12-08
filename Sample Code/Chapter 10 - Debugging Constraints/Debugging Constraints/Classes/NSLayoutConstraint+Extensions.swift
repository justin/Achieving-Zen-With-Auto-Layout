import Foundation

extension NSLayoutConstraint {
    func name(for attribute: NSLayoutAttribute) -> String {
        switch (attribute) {
        case .left: return "left";
        case .leftMargin : return "leftMargin";
        case .right: return "right";
        case .rightMargin: return "rightMargin";
        case .top: return "top";
        case .topMargin: return "topMargin";
        case .bottom: return "bottom";
        case .bottomMargin: return "bottom";
        case .leading: return "leading";
        case .leadingMargin: return "leadingMargin";
        case .trailing: return "trailing";
        case .trailingMargin: return "trailingMargin";
        case .width: return "width";
        case .height: return "height";
        case .centerX: return "centerX";
        case .centerXWithinMargins: return "centerXmargins";
        case .centerY: return "centerY";
        case .centerYWithinMargins: return "centerYmargins";
        case .lastBaseline: return "last-baseline";
        case .firstBaseline: return "firstBaseline"
        case .notAnAttribute: return "not-an-attributes"
        }
    }
    
    
    func debugQuickLookObject() -> Any? {
        var relationString = "EQUALS"
        if (relation == .lessThanOrEqual) {
            relationString = "GREATER THAN OR EQUAL"
        }
        else if (relation == .equal) {
            relationString = "LESS THAN OR EQUAL"
        }
        
        let debugString = """
        \(String(describing: firstItem)): \(name(for: firstAttribute))
            
        [ \(relationString) ]
        
        \(String(describing: secondItem)) : \(name(for: secondAttribute))
        
        Priority: \(priority)
        Multiplier: \(multiplier)
        Constant: \(constant)
        """
        
        return debugString
    }
}
