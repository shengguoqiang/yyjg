/**
 * 竞品楼盘标注
 */

import UIKit

class THJGProjectCompetionView: BMKAnnotationView {
    
    var priceLabel: UILabel = {
       let label = UILabel(frame: CGRect(x: 0, y: 0, width: 126, height: 28))
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    var selectTip: (type: THJGPointType, bean: THJGBaseBean)!

    override init!(annotation: BMKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        bounds = CGRect(x: 0, y: 0, width: 126, height: 31)
        paopaoView = BMKActionPaopaoView(customView: UIView(frame: .zero))
        centerOffset = CGPoint(x: 50, y: -45)
        addSubview(priceLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


