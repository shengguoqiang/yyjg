/**
 * 资金信息-用款登记
 */

import UIKit

class THJGProjectFundCheckCell: UITableViewCell {

    @IBOutlet weak var smallTypeNameLabel: UILabel!
    @IBOutlet weak var acutalAmountLabel: UILabel!
    @IBOutlet weak var operatorLabel: UILabel!
    @IBOutlet weak var payWayLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var payAccountTitleLabel: UILabel!
    @IBOutlet weak var payAccountLabel: UILabel!
    @IBOutlet weak var recAccountTitleLabel: UILabel!
    @IBOutlet weak var recAccountLabel: UILabel!
    @IBOutlet weak var remarkTitleLabel: UILabel!
    @IBOutlet weak var remarkLabel: UILabel!
    
    @IBOutlet weak var remarkLabelBottom: NSLayoutConstraint!
    @IBOutlet weak var resourceView: UIView!
    
    //分割线
    @IBOutlet weak var seperatorOneOne: UIView!
    @IBOutlet weak var seperatorFour: UIView!
    
    //箭头
    @IBOutlet weak var arrowBtn: UIButton!
    
    //凭证
    var imgShowView: THJGBriefImgShowView!
    
    var bean: ProFundInfoCheckDetailHandledBean! {
        didSet {
            //调整UI显示与隐藏            
            if bean.isSelected {
                //其他元素
                payAccountTitleLabel.isHidden = DQSUtils.isBlank(bean.cellBean.payPayAccount)
                payAccountLabel.isHidden = payAccountTitleLabel.isHidden
                recAccountTitleLabel.isHidden = DQSUtils.isBlank(bean.cellBean.payRecAccount)
                recAccountLabel.isHidden = recAccountTitleLabel.isHidden
                remarkTitleLabel.isHidden = DQSUtils.isBlank(bean.cellBean.payRemark)
                remarkLabel.isHidden = remarkTitleLabel.isHidden
                resourceView.isHidden = bean.cellBean.payResources.isEmpty
                
                //分割线
                seperatorOneOne.isHidden = true
                seperatorFour.isHidden = false
            } else {
                //其他元素
                payAccountTitleLabel.isHidden = true
                payAccountLabel.isHidden = payAccountTitleLabel.isHidden
                recAccountTitleLabel.isHidden = true
                recAccountLabel.isHidden = recAccountTitleLabel.isHidden
                remarkTitleLabel.isHidden = true
                remarkLabel.isHidden = remarkTitleLabel.isHidden
                resourceView.isHidden = true
                
                //分割线
                seperatorOneOne.isHidden = false
                seperatorFour.isHidden = true
            }
            remarkLabelBottom.constant = bean.cellBean.payResources.isEmpty ? 30 : 165
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgShowView = THJGBriefImgShowView.showBriefImgView()
        resourceView.addSubview(imgShowView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgShowView.frame = resourceView.bounds
    }
    
    func reloadData(_ bean: ProFundInfoCheckDetailHandledBean,
                    _ isLastIndexInCurSection: Bool,
                    selectBlock: @escaping ImgShowBlock) {
        //调整UI显示与隐藏
        self.bean = bean
        
        //调整分割线
        if !bean.isSelected {
            seperatorOneOne.isHidden = isLastIndexInCurSection
        }
        
        //调整箭头
        if DQSUtils.isNotBlank(bean.cellBean.payPayAccount) ||
            DQSUtils.isNotBlank(bean.cellBean.payRecAccount) ||
            DQSUtils.isNotBlank(bean.cellBean.payRemark) ||
            !bean.cellBean.payResources.isEmpty {
            arrowBtn.isHidden = false
            arrowBtn.isSelected = bean.isSelected
        } else {
            arrowBtn.isHidden = true
            arrowBtn.isSelected = false
        }
        
        //赋值内容
        smallTypeNameLabel.text = bean.cellBean.paySmallTypeName
        acutalAmountLabel.text = "\(DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: bean.cellBean.payActualPay, floatNum: 2, showStyle: .showStyleNoZero)))万元"
        operatorLabel.text = bean.cellBean.payOperator
        switch bean.cellBean.payWay {
        case "1":
            payWayLabel.text = "网银转账"
        case "2":
            payWayLabel.text = "支票转账"
        case "3":
            payWayLabel.text = "电汇单"
        case "4":
            payWayLabel.text = "支票取现"
        default:
            payWayLabel.text = ""
        }
        
        reasonLabel.text = bean.cellBean.payReason
        payAccountLabel.text = bean.cellBean.payPayAccount
        recAccountLabel.text = bean.cellBean.payRecAccount
        remarkLabel.text = bean.cellBean.payRemark
        if !bean.cellBean.payResources.isEmpty {
            var imgBeans = [THJGImgShowBean]()
            for res in bean.cellBean.payResources {
                imgBeans.append(THJGImgShowBean(imgUrl: res.fundCheckResUrl, imgName: res.fundCheckResName, isVideo: false, videoType: nil, videoStatus: nil, videoSerial: nil, videoUrl: nil))
            }
            imgShowView.reloadData(imgBeans) { (beans, curIndex) in
                selectBlock(beans, curIndex)
            }
        }
    }
    
}
