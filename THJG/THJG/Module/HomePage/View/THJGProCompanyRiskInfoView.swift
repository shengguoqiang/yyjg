/**
 * 企业信息-风险信息
 */

/* pdf cell */
fileprivate let kProCompanyPdfBigCellIdentifier = "proCompanyPdfBigCellIdentifier"

import UIKit

class THJGProCompanyRiskInfoView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!

    override func awakeFromNib() {
        super.awakeFromNib()
        //初始化
        setup()
    }
    
    fileprivate var bean: THJGProCompanyBean! {
        didSet {
            if bean.riskInfo.isEmpty {
                //添加占位图片
                DQSUtils.showPlaceholderImg(collectionView)
            } else {
                //隐藏占位图片
                DQSUtils.hidePlaceholderImg(collectionView)
            }
            collectionView.reloadData()
        }
    }
    
    fileprivate var pdfBlock: THJGProDetailTabBlock!
    
    func reloadData(bean: THJGProCompanyBean,
                    bloc: @escaping THJGProDetailTabBlock) {
        self.bean = bean
        pdfBlock = bloc
    }

}

//MARK: - METHODS
extension THJGProCompanyRiskInfoView {
    
    //初始化
    func setup() {
        //collectionView属性设置
        collectionViewLayout.itemSize = CGSize(width: SCREEN_WIDTH/2, height: 150)
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 0
        
        //注册item
        collectionView.register(UINib(nibName: "THJGProCompanyPdfBigCell", bundle: nil), forCellWithReuseIdentifier: kProCompanyPdfBigCellIdentifier)
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension THJGProCompanyRiskInfoView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if nil == bean {
            return  0
        }
        return bean.riskInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kProCompanyPdfBigCellIdentifier, for: indexPath) as! THJGProCompanyPdfBigCell
        cell.bean = bean.riskInfo[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pdfBean = bean.riskInfo[indexPath.row]
        pdfBlock(pdfBean.resourceUrl, nil)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

