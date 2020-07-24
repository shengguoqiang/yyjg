/**
 * 缩略图展示
 */

import UIKit

//cell 标识
fileprivate let kBriefImgCellIdentifier = "briefImgCellIdentifier"

//回调
typealias ImgShowBlock = (_ beans: [THJGImgShowBean], _ curIndex: Int?) -> Void

class THJGBriefImgShowView: UIView {

    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    
    @IBOutlet weak var multiImgsView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var singleImgView: UIView!
    @IBOutlet weak var single_imgView: UIImageView!
    @IBOutlet weak var single_playView: UIImageView!
    @IBOutlet weak var liveView: UILabel!
    @IBOutlet weak var single_nameLabel: UILabel!
    
    fileprivate var beans: [THJGImgShowBean]! {
        didSet {
            singleImgView.isHidden = beans.count > 1
            multiImgsView.isHidden = !singleImgView.isHidden
            leftBtn.isHidden = !singleImgView.isHidden
            rightBtn.isHidden = leftBtn.isHidden
        }
    }
    
    fileprivate var curIndex: Int! {
        didSet {
            guard beans.count > 1 else {
                return
            }
            leftBtn.isHidden = (curIndex == 0)
            rightBtn.isHidden = (curIndex == beans.count - 2)
            collectionView.scrollToItem(at: IndexPath(item: curIndex, section: 0), at: .left, animated: true)
        }
    }
    
    var selectBlock: ImgShowBlock!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //注册cell
        collectionView.register(UINib(nibName: "THJGBriefImgShowCell", bundle: nil), forCellWithReuseIdentifier: kBriefImgCellIdentifier)
        
        //单个视图添加手势
        singleImgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(singleViewDidClicked)))
    }
    
    static func showBriefImgView() -> THJGBriefImgShowView {
        return Bundle.main.loadNibNamed("THJGBriefImgShowView", owner: self, options: nil)?.last as! THJGBriefImgShowView
    }
    
    func reloadData(_ beans: [THJGImgShowBean],
                    selectBlock: @escaping ImgShowBlock) {
        guard !beans.isEmpty else {
            return
        }
        //赋值
        self.beans = beans
        if beans.count > 1 {//多个资源
            self.collectionView.reloadData()
        } else {//单个资源
            let bean = beans.first!
            if bean.isVideo, bean.videoType! == 20 {//本地视频
                single_imgView.image = UIImage(named: "common_bg_placeholder_nodata")
                DispatchQueue.global().async {
                    let image = DQSUtils_OC.thumbnailImage(forVideo: URL(string: bean.videoUrl ?? "")!, atTime: 1)
                    DispatchQueue.main.async {
                        self.single_imgView.image = image
                    }
                }
            } else if bean.isPdf {//pdf
                single_imgView.image = UIImage(named: "pro_pdf_big")
            } else {
                single_imgView.kf.setImage(with: URL(string: beans.last!.imgUrl), placeholder: UIImage(named: "common_bg_placeholder_nodata"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            liveView.isHidden = !(beans.last!.isVideo && beans.last!.videoType! != 20)
            if bean.videoType == 13 && bean.videoStatus != 1 { // 大华视频离线
                liveView.text = "离线"
            } else {
                liveView.text = "实时"
            }
            single_playView.isHidden = !beans.last!.isVideo
            single_nameLabel.text = beans.last!.imgName
        }
        //默认当前页
        curIndex = 0
        //回调
        self.selectBlock = selectBlock
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 7
        flowLayout.itemSize = CGSize(width: (multiImgsView.bounds.width-7)/CGFloat(2), height: multiImgsView.bounds.height)
        flowLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = flowLayout
    }
    
}

//MARK: - METHODS
extension THJGBriefImgShowView {
    //左滑按钮事件监听
    @IBAction func leftBtnDidClicked(_ sender: UIButton) {
        guard curIndex > 0 else {
            return
        }
        curIndex -= 1
    }
    
    //右滑按钮事件监听
    @IBAction func rightBtnDidClicked(_ sender: UIButton) {
        guard curIndex < beans.count-2 else {
            return
        }
        curIndex += 1
    }
    
    @objc fileprivate func singleViewDidClicked() {
        selectBlock(beans, nil)
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension THJGBriefImgShowView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard beans != nil else {
            return 0
        }
        return beans.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kBriefImgCellIdentifier, for: indexPath) as! THJGBriefImgShowCell
        cell.bean = beans[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectBlock(beans, indexPath.item)
        collectionView.deselectItem(at: indexPath, animated: true)
    }

}

//MARK: - UIScrollViewDelegate
extension THJGBriefImgShowView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = (Int)(scrollView.contentOffset.x / ((multiImgsView.bounds.width-7)/CGFloat(2)))
        curIndex = index
    }
}
