//
//  THJGBigImgShowView.swift
//  THJG
//
//  Created by 大强神 on 2019/8/6.
//  Copyright © 2019 中南金融. All rights reserved.
//

import UIKit

class THJGBigImgShowView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    var imageView: UIImageView!
    
    static func showBigImageView() -> THJGBigImgShowView {
        return Bundle.main.loadNibNamed("THJGBigImgShowView", owner: self, options: nil)?.first as! THJGBigImgShowView
    }
    
    var imageUrl: String! {
        didSet {
            imageView = UIImageView(frame: CGRect(x: 15, y: (SCREEN_HEIGHT-220)/2, width: SCREEN_WIDTH-30, height: 220))
            imageView.kf.setImage(with: URL(string: imageUrl), placeholder: UIImage(named: "common_bg_placeholder_nodata"), options: nil, progressBlock: nil, completionHandler: nil)
            scrollView.addSubview(imageView)
        }
    }
    
    @IBAction func cancelBtnDidClicked() {
        removeFromSuperview()
    }
    
}

extension THJGBigImgShowView: UIScrollViewDelegate {
   
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        let imageScaleWidth = scale * (SCREEN_WIDTH-30)
        let imageScaleHeight = scale * 220
        let imageX = 15
        let imageY = (SCREEN_HEIGHT - imageScaleHeight) / 2.0 + 20
        //沿中心点缩放
        imageView.frame = CGRect(x: CGFloat(imageX), y: imageY, width: imageScaleWidth, height: imageScaleHeight)
        //调整滚动视图内容大小
        self.scrollView.contentSize = CGSize(width: max(SCREEN_WIDTH-30, imageScaleWidth+30), height: max(220, imageScaleHeight))
    }
    
}
