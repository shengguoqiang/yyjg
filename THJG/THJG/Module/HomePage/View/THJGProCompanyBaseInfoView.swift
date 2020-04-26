/**
 * 企业信息-公司信息
 */

/* pdf cell */
fileprivate let kProCompanyPdfCellIdentifier = "proCompanyPdfCellIdentifier"

import UIKit

class THJGProCompanyBaseInfoView: UIView {
    
    @IBOutlet weak var containerView: UIScrollView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var legalNameLabel: UILabel!
    @IBOutlet weak var regisAmountLabel: UILabel!
    @IBOutlet weak var actualAmountLabel: UILabel!
    @IBOutlet weak var authCodeLabel: UILabel!
    @IBOutlet weak var companyDesLabel: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //初始化
        setup()
    }
    
    var bean: THJGProCompanyBean! {
        didSet {
            if DQSUtils.isBlank(bean.baseInfo.companyName) ||
                DQSUtils.isBlank(bean.baseInfo.authCode){
                //添加占位图片
                DQSUtils.showPlaceholderImg(containerView)
            } else {
                //隐藏占位图片
                DQSUtils.hidePlaceholderImg(containerView)
            }
            /* 顶部视图 */
            //计算顶部视图高度
            let desHeight = DQSUtils.heightForText(text: bean.baseInfo.companyDes, fixedWidth: SCREEN_WIDTH-30, fixedFont: UIFont.systemFont(ofSize: 14)) + 30
            topViewHeight.constant = 270 + desHeight
            //顶部视图赋值
            companyNameLabel.text = bean.baseInfo.companyName
            legalNameLabel.text = bean.baseInfo.legalName
            regisAmountLabel.text = bean.baseInfo.registerAmount
            actualAmountLabel.text = bean.baseInfo.actualAmount
            authCodeLabel.text = bean.baseInfo.authCode
            companyDesLabel.text = bean.baseInfo.companyDes
            
            /* 底部视图 */
            guard !bean.baseInfo.leaderInfo.isEmpty else {
                bottomView.isHidden = true
                return
            }
            //计算底部视图高度
            let leaderCount = bean.baseInfo.leaderInfo.count
            let leaderHeight: CGFloat = CGFloat((leaderCount / 3 + (leaderCount % 3 == 0 ? 0 : 1)) * 110)
            bottomViewHeight.constant = 45 + leaderHeight
            //底部视图赋值
            collectionView.reloadData()
        }
    }
    
    var pdfBlock: THJGProDetailTabBlock!
    
    func reloadData(bean: THJGProCompanyBean,
                    bloc: @escaping THJGProDetailTabBlock) {
        self.bean = bean
        pdfBlock = bloc
    }

}

//MARK: - METHODS
extension THJGProCompanyBaseInfoView {
    
    //初始化
    func setup() {
        //collectionView属性设置
        collectionViewLayout.itemSize = CGSize(width: (SCREEN_WIDTH-30-30)/3, height: 90)
        collectionViewLayout.minimumInteritemSpacing = 15
        collectionViewLayout.minimumLineSpacing = 20
        
        //注册item
        collectionView.register(UINib(nibName: "THJGProCompanyPdfCell", bundle: nil), forCellWithReuseIdentifier: kProCompanyPdfCellIdentifier)
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension THJGProCompanyBaseInfoView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if nil == bean {
            return  0
        }
        return bean.baseInfo.leaderInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kProCompanyPdfCellIdentifier, for: indexPath) as! THJGProCompanyPdfCell
        cell.bean = bean.baseInfo.leaderInfo[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pdfBean = bean.baseInfo.leaderInfo[indexPath.row]
        pdfBlock(pdfBean.resourceUrl, nil)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
