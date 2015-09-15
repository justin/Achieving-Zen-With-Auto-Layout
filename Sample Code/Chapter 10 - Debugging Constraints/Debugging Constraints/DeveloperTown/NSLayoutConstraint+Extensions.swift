import Foundation

extension NSLayoutConstraint
{
    func nameForLayoutAttribute(attribute:NSLayoutAttribute) -> String
    {
        switch (attribute)
        {
        case NSLayoutAttribute.Left: return "left";
        case NSLayoutAttribute.LeftMargin : return "leftMargin";
        case NSLayoutAttribute.Right: return "right";
        case NSLayoutAttribute.RightMargin: return "rightMargin";
        case NSLayoutAttribute.Top: return "top";
        case NSLayoutAttribute.TopMargin: return "topMargin";
        case NSLayoutAttribute.Bottom: return "bottom";
        case NSLayoutAttribute.BottomMargin: return "bottom";
        case NSLayoutAttribute.Leading: return "leading";
        case NSLayoutAttribute.LeadingMargin: return "leadingMargin";
        case NSLayoutAttribute.Trailing: return "trailing";
        case NSLayoutAttribute.TrailingMargin: return "trailingMargin";
        case NSLayoutAttribute.Width: return "width";
        case NSLayoutAttribute.Height: return "height";
        case NSLayoutAttribute.CenterX: return "centerX";
        case NSLayoutAttribute.CenterXWithinMargins: return "centerXmargins";
        case NSLayoutAttribute.CenterY: return "centerY";
        case NSLayoutAttribute.CenterYWithinMargins: return "centerYmargins";
        case NSLayoutAttribute.Baseline: return "baseline";
        case NSLayoutAttribute.LastBaseline: return "lastBaseline"
        case NSLayoutAttribute.FirstBaseline: return "firstBaseline"
        case NSLayoutAttribute.NotAnAttribute: return "not-an-attributes"
        }
    }
    
    func debugQuickLookObject() -> AnyObject?
    {
        var relation = "EQUALS"
        if (self.relation == NSLayoutRelation.LessThanOrEqual)
        {
            relation = "GREATER THAN OR EQUAL"
        }
        else if (self.relation == NSLayoutRelation.Equal)
        {
            relation = "LESS THAN OR EQUAL"
        }
        
        return "\n\(firstItem) : \(nameForLayoutAttribute(firstAttribute))" +
            
            "\n\n [ \(relation) ]" +
            "\n\n\(secondItem) : \(nameForLayoutAttribute(secondAttribute))" +
            "\n\nPriority:\(priority)" +
            "\nMultiplier: \(multiplier)" +
        "\nConstant: \(constant)"
    }
}
