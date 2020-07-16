/**
 * 查看大图
 */

import UIKit
import MJRefresh
import AVKit

enum ImgShowType {
    case ezopenLiveVideo  //萤石实时视频
    case imgAndLocalVideo //图片和本地视频和大华视频
}

//顶部cell 标识
fileprivate let kImgShowCellIdentifier = "imgShowCellIdentifier"
fileprivate let kVideoShowCellIdentifier = "videoShowCellIdentifier"
fileprivate let kTHJGLeChengVideoCellIdentifier = "THJGLeChengVideoCell"

//告警cell 标识
fileprivate let kMonitorCellIdentifier = "monitorCellIdentifier"

class THJGImageShowView: UIView {
    
    
    @IBOutlet weak var imageNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    
    @IBOutlet weak var fullScreenBtn: UIButton!
   
    @IBOutlet weak var playBtn: UIButton!
    
    // 底部告警相关
    @IBOutlet weak var deviceWarnContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //注册顶部cell
        collectionView.register(UINib(nibName: "THJGImgShowCell", bundle: nil), forCellWithReuseIdentifier: kImgShowCellIdentifier)
        collectionView.register(UINib(nibName: "THJGEZOpenVideoCell", bundle: nil), forCellWithReuseIdentifier: kVideoShowCellIdentifier)
        collectionView.register(UINib(nibName: "THJGLeChengVideoCell", bundle: nil), forCellWithReuseIdentifier: kTHJGLeChengVideoCellIdentifier)
        //底部告警列表
        warning_setup()
        //适配视频播放器
        playBtn.addTarget(self, action: #selector(playLocalVideo), for: .touchUpInside)
    }
    
    static func showImgView() -> THJGImageShowView {
        return Bundle.main.loadNibNamed("THJGImageShowView", owner: self, options: nil)?.last! as! THJGImageShowView
    }
    
    fileprivate var beans: [THJGImgShowBean]! {
        didSet {
            collectionView.reloadData()
        }
    }

    var curIndex: Int! {
        didSet {
            //处理顶部
            leftBtn.isHidden = (curIndex == 0)
            rightBtn.isHidden = (curIndex == beans.count-1)
            collectionView.scrollToItem(at: IndexPath(item: curIndex, section: 0), at: .left, animated: false)
            imageNameLabel.text = beans[curIndex].imgName
            fullScreenBtn.isHidden = !beans[curIndex].isVideo
            playBtn.isHidden = fullScreenBtn.isHidden
            
            //处理告警
            let curBean = beans[curIndex]
            if curBean.isVideo, curBean.videoType! == 10 {//萤石视频
                showType = .ezopenLiveVideo
            } else {//图片或本地视频或大华视频
                showType = .imgAndLocalVideo
            }
        }
    }
    
    var showType: ImgShowType = .ezopenLiveVideo {
        didSet {
            switch showType {
            case .ezopenLiveVideo:
                deviceWarnContainerView.isHidden = false
                deviceSerial = beans[curIndex].videoSerial
            case .imgAndLocalVideo:
                deviceWarnContainerView.isHidden = true
                deviceSerial = nil
            }
        }
    }
    
    /* 设备告警信息列表 */
    var deviceSerial: String? {
        didSet {
            guard DQSUtils.isNotBlank(deviceSerial) else {
                return
            }
            tableView.mj_header.beginRefreshing()
        }
    }
    lazy var monitorVM = THJGMonitorViewModel()
    var curPage: Int = 0
    var monitorBeans: [MonitorBean]!
    
    deinit {
        //注销网络请求通知
        NotificationCenter.default.removeObserver(self)
    }
    
}

//MARK: - 左右滑动按钮相关
extension THJGImageShowView {

    /* 加载顶部数据 */
    func reloadData(_ beans: [THJGImgShowBean],
                    curIndex: Int) {
        self.beans = beans
        self.curIndex = curIndex
    }
    
    /* 加载底部告警数据 */
    func reloadWarningData() {
        tableView.reloadData()
    }
    
    //MARK: 全屏事件监听
    @IBAction func fullScreenDidClicked(_ sender: UIButton) {
        let bean = beans[curIndex]
        guard bean.isVideo else {
            return
        }
        
        //暂停当前视频
        if bean.videoType == 10 {//萤石视频
            let cell = collectionView.cellForItem(at: IndexPath(item: curIndex, section: 0)) as! THJGEZOpenVideoCell
            cell.mplayer?.pausePlay()
        } else if bean.videoType == 20 {//本地视频
            let cell = collectionView.cellForItem(at: IndexPath(item: curIndex, section: 0)) as! THJGImgShowCell
            cell.avPlayerVC?.player?.pause()
        } else if bean.videoType == 13 { // 大华视频
            let cell = collectionView.cellForItem(at: IndexPath(item: curIndex, section: 0)) as! THJGLeChengVideoCell
            cell.stopRtspVideo()
        }
        
        //显示播放图标
        playBtn.isHidden = false
        
        //发送全屏通知
        if bean.videoType == 13 {
            NotificationCenter.default.post(name: NSNotification.Name(NOTIFICATION_VIDEO_REC_FULLSCREEN), object: "lechengVideo_\(bean.videoSerial ?? "")")
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(NOTIFICATION_VIDEO_REC_FULLSCREEN), object: bean.videoUrl)
        }
    }
    
    @IBAction func cancleDidClicked(_ sender: UIButton) {
        removeFromSuperview()
    }
    
    @IBAction func leftBtnDidClicked(_ sender: UIButton) {
        guard curIndex >= 1 else {
            return
        }
        curIndex -= 1
    }
    
    @IBAction func rightBtnDidClicked(_ sender: UIButton) {
        guard curIndex < beans.count else {
            return
        }
        curIndex += 1
    }
    
    //MARK: 播放本地视频
    @objc func playLocalVideo() {
        let bean = beans[curIndex]
        if bean.videoType == 20 { // 本地视频
            //隐藏播放图标
            playBtn.isHidden = true
            //播放视频
            let indexPath = IndexPath(item: curIndex, section: 0)
            let cell = collectionView.cellForItem(at: indexPath) as! THJGImgShowCell
            cell.avPlayerVC?.player?.play()
        } else if bean.videoType == 13 { // 大华视频
            //隐藏播放图标
            playBtn.isHidden = true
            //播放视频
            let indexPath = IndexPath(item: curIndex, section: 0)
            let cell = collectionView.cellForItem(at: indexPath) as! THJGLeChengVideoCell
            cell.startRtspVideo()
        }
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension THJGImageShowView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard beans != nil else {
            return 0
        }
        return beans.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bean = beans[indexPath.item]
        if bean.isVideo, bean.videoType! == 10 {//萤石实时视频
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kVideoShowCellIdentifier, for: indexPath) as! THJGEZOpenVideoCell
            cell.bean = bean
            return cell
        } else if bean.isVideo, bean.videoType == 13 { //大华视频
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kTHJGLeChengVideoCellIdentifier, for: indexPath) as! THJGLeChengVideoCell
            cell.bean = bean
            return cell
        } else {//图片或本地视频
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kImgShowCellIdentifier, for: indexPath) as! THJGImgShowCell
            cell.bean = beans[indexPath.item]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bean = beans[indexPath.item]
        //隐藏播放图标
        playBtn.isHidden = true
        if bean.isVideo, bean.videoType! == 10 {//萤石实时视频
            let cell = collectionView.cellForItem(at: indexPath) as! THJGEZOpenVideoCell
            cell.addSubview(cell.mplayer!.previewView)
            cell.mplayer!.startPlay()
        } else if bean.isVideo, bean.videoType == 13 { // 大华视频
            let cell = collectionView.cellForItem(at: indexPath) as! THJGLeChengVideoCell
            cell.startRtspVideo()
        } else {//图片或本地视频
            if bean.videoType == 20 {//本地视频
                let cell = collectionView.cellForItem(at: indexPath) as! THJGImgShowCell
                cell.avPlayerVC?.player?.play()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        //将视频清空
        if cell.isMember(of: THJGEZOpenVideoCell.self) {//萤石视频
            let ezCell = cell as! THJGEZOpenVideoCell
            ezCell.mplayer?.previewView.removeFromSuperview()
            ezCell.mplayer = nil
        } else if cell.isMember(of: THJGLeChengVideoCell.self) { // 大华视频
            let lcCell = cell as! THJGLeChengVideoCell
            lcCell.stopRtspVideo()
        } else if cell.isMember(of: THJGImgShowCell.self) {//本地视频
            let localVideoCell = cell as! THJGImgShowCell
            localVideoCell.avPlayerVC?.player = nil
            localVideoCell.avPlayerVC?.view.removeFromSuperview()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let bean = beans[indexPath.item]
        //播放器
        if bean.isVideo, bean.videoType != nil {
            if bean.videoType == 10 {//萤石视频
                guard DQSUtils.isNotBlank(bean.videoUrl) else {
                    return
                }
                let ezCell = cell as! THJGEZOpenVideoCell
                ezCell.mplayer = EZUIPlayer.createPlayer(withUrl: bean.videoUrl!)
                ezCell.mplayer!.previewView.frame = ezCell.bounds
                ezCell.mplayer!.mDelegate = ezCell
                //播放按钮
                playBtn.isUserInteractionEnabled = false
            } else if bean.videoType! == 20 {//本地视频
                guard DQSUtils.isNotBlank(bean.videoUrl) else {
                    return
                }
                let localVideoCell = cell as! THJGImgShowCell
                let avPlayer = AVPlayer(url: URL(string: bean.videoUrl!)!)
                localVideoCell.avPlayerVC = AVPlayerViewController()
                localVideoCell.avPlayerVC!.showsPlaybackControls = false
                localVideoCell.avPlayerVC!.player = avPlayer
                localVideoCell.avPlayerVC!.view.frame = localVideoCell.bounds
                localVideoCell.addSubview(localVideoCell.avPlayerVC!.view)
                //播放按钮
                playBtn.isUserInteractionEnabled = true
            } else if bean.videoType == 13 { // 大华视频
                // 暂不设置！！！
            }
        }
    }
    
}

//MARK: - UIScrollViewDelegate
extension THJGImageShowView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.isKind(of: UICollectionView.self) {
            let index = (Int)(scrollView.contentOffset.x/collectionView.bounds.width)
            curIndex = index
        }
    }
}

//MARK: - 设备告警相关
extension THJGImageShowView {
    
    //告警列表设置
    fileprivate func warning_setup() {
        //注册网络请求通知
        NotificationCenter.default.addObserver(self, selector: #selector(requestNewDataSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_DEVICE_WARNING_NEWDATA_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestNewDataFailure(_:)), name: Notification.Name(THJG_NOTIFICATION_DEVICE_WARNING_NEWDATA_FAILURE), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestMoreDataSuccess(_:)), name: Notification.Name(THJG_NOTIFICATION_DEVICE_WARNING_MOREDATA_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestMoreDataFailure(_:)), name: Notification.Name(THJG_NOTIFICATION_DEVICE_WARNING_MOREDATA_FAILURE), object: nil)
        
        //注册设备告警cell
        tableView.register(UINib(nibName: "THJGMonitorCell", bundle: nil), forCellReuseIdentifier: kMonitorCellIdentifier)
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[unowned self] in
            self.requestForNewData()
        })
    }

    //request for new data
    fileprivate func requestForNewData() {
        curPage = 0
        tableView.mj_footer = nil
        monitorVM.requestForNewDeviceWarning(param: ["deviceSerial": deviceSerial!, "pageNum": curPage])
    }
    
    @objc func requestNewDataSuccess(_ notification: Notification) {
        //隐藏占位图
        DQSUtils.hidePlaceholderImg(tableView)
        //结束刷新
        tableView.mj_header.endRefreshing()
        //赋值
        let specBean = notification.object as! THJGSuccessBean
        let monitorBean = specBean.bean as! THJGMonitorBean
        monitorBeans = monitorBean.videos
        if monitorBeans.isEmpty {
            //显示占位图
            DQSUtils.showPlaceholderImg(tableView, 30, "暂无消息")
        } else {
            //隐藏占位图
            DQSUtils.hidePlaceholderImg(tableView)
            //加载数据
            self.reloadWarningData()
            //处理分页
            if monitorBean.videosTotal == 20 {
                tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
                    [unowned self] in
                    self.requestForMoreData()
                })
            }
        }
    }
    
    @objc func requestNewDataFailure(_ notification: Notification) {
        //结束刷新
        tableView.mj_header.endRefreshing()
        //提示
        let specBean = notification.object as! THJGFailureBean
        DQSUtils.showToast(specBean.msg, self)
    }
    
    //request for more data
    fileprivate func requestForMoreData() {
        curPage += 1
        monitorVM.requestForMoreDeviceWarning(param: ["deviceSerial": deviceSerial!, "pageNum": curPage])
    }
    
    @objc func requestMoreDataSuccess(_ notification: Notification) {
        //处理分页
        let specBean = notification.object as! THJGSuccessBean
        let monitorBean = specBean.bean as! THJGMonitorBean
        guard !monitorBean.videos.isEmpty else {//无更多数据
            (tableView.mj_footer as! MJRefreshAutoNormalFooter).endRefreshingWithNoMoreData()
            return
        }
        if monitorBean.videosTotal < 20 {
            (tableView.mj_footer as! MJRefreshAutoNormalFooter).endRefreshingWithNoMoreData()
        } else {
            (tableView.mj_footer as! MJRefreshAutoNormalFooter).endRefreshing()
        }
        
        //处理数据
        var loadedBeans = monitorBean.videos
        //处理最新的数据是否与之前的数据的重叠情形，并赋值数据源
        if monitorBeans.last!.videoDate == loadedBeans.first!.videoDate {//有重叠
            var lastBean = monitorBeans.removeLast()
            let loadBean = loadedBeans.removeFirst()
            for detailBean in loadBean.videoDetails {
                lastBean.videoDetails.append(detailBean)
            }
            monitorBeans.append(lastBean)
            monitorBeans += loadedBeans
            reloadWarningData()
        } else {//没有重叠
            monitorBeans += loadedBeans
            reloadWarningData()
        }
    }
    
    @objc func requestMoreDataFailure(_ notification: Notification) {
        //当前页递减
        curPage -= 1
        //结束底部刷新
        (tableView.mj_footer as! MJRefreshAutoNormalFooter).endRefreshing()
        //提示
        let specBean = notification.object as! THJGFailureBean
        DQSUtils.showToast(specBean.msg, self)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension THJGImageShowView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard monitorBeans != nil else {
            return 0
        }
        return monitorBeans.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !monitorBeans.isEmpty else {
            return nil
        }
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 45))
        headerView.backgroundColor = DQSUtils.rgbColor(242, 242, 243)
        let header = UILabel(frame: CGRect(x: 14, y: 0, width: SCREEN_WIDTH, height: 45))
        header.font = UIFont.systemFont(ofSize: 13)
        header.text = monitorBeans[section].videoDate + "  " + (DQSUtils.showWeekDay(dateStr: monitorBeans[section].videoDate) ?? "")
        headerView.addSubview(header)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !monitorBeans.isEmpty else {
            return 0
        }
        return monitorBeans[section].videoDetails.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kMonitorCellIdentifier) as! THJGMonitorCell
        if !monitorBeans.isEmpty {
            cell.bean = monitorBeans[indexPath.section].videoDetails[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let bean = monitorBeans[indexPath.section].videoDetails[indexPath.row]
        let recView = THJGVideoRecView.showVideoRecView()
        recView.frame = bounds
        addSubview(recView)
        recView.param = ("\(imageNameLabel.text ?? "")告警", bean.alarmVideoUrl)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
