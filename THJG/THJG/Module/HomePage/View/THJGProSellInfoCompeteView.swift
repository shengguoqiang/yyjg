/**
 * 销售消息-竞品楼盘
 */

import UIKit

//地图标识
fileprivate let kPinPointIdentifier = "pinPointIdentifier"
fileprivate let kCustomPointIdentifier = "customPointIdentifier"

class THJGProSellInfoCompeteView: UIView {

    var mapView: BMKMapView!
    var searchArray = [BMKGeoCodeSearch]()
    var beanArray = [THJGBaseBean]()
    @IBOutlet weak var containerView: THJGProjectCompetionDetailView!
    
    func reloadData(curProject: CurProjectBean,
                    competions: [ProjectSellCompetionBean]) {
        //展示当前项目annotation
        if DQSUtils.isNotBlank(curProject.curProCoordinate), curProject.curProCoordinate.contains(","), curProject.curProCoordinate.split(separator: ",").count == 2 {//直接根据项目经纬度标注
            //经度
            let longitude = Double(curProject.curProCoordinate.split(separator: ",")[0].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0.0
            //纬度
            let latitude = Double(curProject.curProCoordinate.split(separator: ",")[1].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0.0
            let coor2d = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            //地图定位到当前项目位置
            self.mapView.centerCoordinate = coor2d
            
            //大头针
            let pin = THJGPointAnnotation()
            pin.type = .ownProject
            pin.coordinate = coor2d
            self.mapView.addAnnotation(pin)
            
            //tip
            let cus = THJGTipAnnotation()
            cus.coordinate = coor2d
            cus.tip = (.ownProject, curProject)
            cus.title = ""
            self.mapView.addAnnotation(cus)
        } else {//根据项目地址-》坐标
            let search = BMKGeoCodeSearch()
            search.delegate = self
            let geoCodeSearchOption = BMKGeoCodeSearchOption()
            geoCodeSearchOption.address = curProject.curProLocation
            let flag = search.geoCode(geoCodeSearchOption)
            if flag {
                DQSUtils.log("geo检索成功")
            } else {
                DQSUtils.log("geo检索失败")
            }
            searchArray.append(search)
            beanArray.append(curProject)
        }
        
        //展示竞品楼盘annotation
        for bean in competions {//直接根据项目经纬度标注
            if DQSUtils.isNotBlank(bean.competionCoordinate), bean.competionCoordinate.contains(","), bean.competionCoordinate.split(separator: ",").count == 2 {
                //经度
                let longitude = Double(bean.competionCoordinate.split(separator: ",")[0])!
                //纬度
                let latitude = Double(bean.competionCoordinate.split(separator: ",")[1])!
                let coor2d = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                //大头针
                let pin = THJGPointAnnotation()
                pin.type = .compeProject
                pin.coordinate = coor2d
                self.mapView.addAnnotation(pin)
                
                //tip
                let cus = THJGTipAnnotation()
                cus.coordinate = coor2d
                cus.tip = (.compeProject, bean)
                cus.title = ""
                self.mapView.addAnnotation(cus)
            } else {//根据项目地址-》坐标
                let search = BMKGeoCodeSearch()
                search.delegate = self
                let geoCodeSearchOption = BMKGeoCodeSearchOption()
                geoCodeSearchOption.address = bean.competionLocation
                let flag = search.geoCode(geoCodeSearchOption)
                if flag {
                    DQSUtils.log("geo检索成功")
                } else {
                    DQSUtils.log("geo检索失败")
                }
                searchArray.append(search)
                beanArray.append(bean)
            }
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //添加百度地图
        if mapView == nil {
            mapView = BMKMapView(frame: .zero)
            mapView.zoomLevel = 17
            mapView.showMapScaleBar = true
            mapView.delegate = self
            addSubview(mapView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if mapView.bounds.width < SCREEN_WIDTH {
            //设置百度地图视图大小
            mapView.frame = bounds
        }
    }
    
}

//MARK: - BMKGeoCodeSearchDelegate
extension THJGProSellInfoCompeteView: BMKGeoCodeSearchDelegate {
    
    func onGetGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKGeoCodeSearchResult!, errorCode error: BMKSearchErrorCode) {
        if error == BMK_SEARCH_NO_ERROR {
            guard !beanArray.isEmpty, !beanArray.isEmpty else {
                return
            }
            let searchIndex = searchArray.index(of: searcher) ?? 0
            let bean = beanArray[searchIndex]
            if bean is CurProjectBean {//当前项目
                let coor2d = result.location
                //地图定位到当前项目位置
                self.mapView.centerCoordinate = coor2d
                
                //大头针
                let pin = THJGPointAnnotation()
                pin.type = .ownProject
                pin.coordinate = coor2d
                self.mapView.addAnnotation(pin)
                
                //tip
                let cus = THJGTipAnnotation()
                cus.coordinate = coor2d
                cus.tip = (.ownProject, bean as! CurProjectBean)
                cus.title = ""
                self.mapView.addAnnotation(cus)
            } else {//竞品楼盘
                let coor2d = result.location
                //大头针
                let pin = THJGPointAnnotation()
                pin.type = .compeProject
                pin.coordinate = coor2d
                self.mapView.addAnnotation(pin)
                
                //tip
                let cus = THJGTipAnnotation()
                cus.coordinate = coor2d
                cus.tip = (.compeProject, bean as! ProjectSellCompetionBean)
                cus.title = ""
                self.mapView.addAnnotation(cus)
            }
        }
    }
    
}

//MARK: - BMKMapViewDelegate
extension THJGProSellInfoCompeteView: BMKMapViewDelegate {
    
    //annotation显示
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        if annotation .isMember(of: THJGPointAnnotation.self)  {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: kPinPointIdentifier)
            if annotationView == nil {
                annotationView = BMKPinAnnotationView(annotation: annotation, reuseIdentifier: kPinPointIdentifier)
            }
            let type = (annotation as! THJGPointAnnotation).type
            if type == .ownProject {//当前项目
                annotationView?.image = UIImage(named: "project_map_redPointer")
            } else if type == .compeProject {//竞品楼盘
                annotationView?.image = UIImage(named: "project_map_bluePointer")
            }
            return annotationView
        } else if annotation .isMember(of: THJGTipAnnotation.self)  {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: kCustomPointIdentifier) as? THJGProjectCompetionView
            if annotationView == nil {
                annotationView = THJGProjectCompetionView(annotation: annotation, reuseIdentifier: kCustomPointIdentifier)
            }
            //赋值
            annotationView!.selectTip = (annotation as! THJGTipAnnotation).tip
            //调整UI
            let type = (annotation as! THJGTipAnnotation).tip.0
            if type == .ownProject {//当前项目
                annotationView!.backgroundColor = UIColor(patternImage: UIImage(named: "project_map_redBg")!)
                annotationView!.priceLabel.textColor = DQSUtils.rgbColor(176, 30, 49)
                let bean = (annotation as! THJGTipAnnotation).tip.1 as! CurProjectBean
                annotationView!.priceLabel.text = "均价：\(DQSUtils.showDoubleNum(sourceDouble: bean.curProUnitPrice/10000, floatNum: 2, showStyle: .showStyleNoZero))万元"
            } else if type == .compeProject {//竞品楼盘
                annotationView!.backgroundColor = UIColor(patternImage: UIImage(named: "project_map_greyBg")!)
                annotationView!.priceLabel.textColor = DQSUtils.rgbColor(33, 33, 33)
                let bean = (annotation as! THJGTipAnnotation).tip.1 as! ProjectSellCompetionBean
                annotationView!.priceLabel.text = "均价：\(DQSUtils.showDoubleNum(sourceDouble: bean.competionUnitPrice/10000, floatNum: 2, showStyle: .showStyleNoZero))万元"
            }
            
            return annotationView
        }
        return nil
    }
    
    //annotation点击事件监听
    func mapView(_ mapView: BMKMapView!, didSelect view: BMKAnnotationView!) {
        if view .isMember(of: THJGProjectCompetionView.self) {
            let competionView = view as! THJGProjectCompetionView
            bringSubviewToFront(containerView)
            containerView.beans = handleDetailData(competionView.selectTip)
            view.setSelected(false, animated: false)
        }
    }
    
}

//MARK: - METHODS
extension THJGProSellInfoCompeteView {
    
    fileprivate func handleDetailData(_ selectTip: (THJGPointType, THJGBaseBean)) -> [ProjectSellCompetionDetailBean] {
        var handledBeans = [ProjectSellCompetionDetailBean]()
        if selectTip.0 == .ownProject {//当前项目
            let bean = selectTip.1 as! CurProjectBean
            if DQSUtils.isNotBlank(bean.curProName) {
                handledBeans.append(ProjectSellCompetionDetailBean(title: "当前楼盘", content: bean.curProName, cellHeight: 45))
            }
            if DQSUtils.isNotBlank(bean.curProLocation) {
                let textHeight = DQSUtils.heightForText(text: bean.curProLocation, fixedWidth: SCREEN_WIDTH-250, fixedFont: UIFont.systemFont(ofSize: 14))
                handledBeans.append(ProjectSellCompetionDetailBean(title: "地理位置", content: bean.curProLocation, cellHeight: textHeight + 45))
                
            }
            if bean.curProUnitPrice != 0 {
                handledBeans.append(ProjectSellCompetionDetailBean(title: "销售均价", content: "\(DQSUtils.showDoubleNum(sourceDouble: bean.curProUnitPrice/10000, floatNum: 2, showStyle: .showStyleNoZero))万元/㎡", cellHeight: 45))
            }
            if bean.curProTotal != 0 {
                handledBeans.append(ProjectSellCompetionDetailBean(title: "总套数", content: "\(DQSUtils.showDoubleNum(sourceDouble: Double(bean.curProTotal), floatNum: 2, showStyle: .showStyleNoZero))", cellHeight: 45))
            }
            if bean.curProQHRate != 0 {
                handledBeans.append(ProjectSellCompetionDetailBean(title: "去化率", content: "\(DQSUtils.showDoubleNum(sourceDouble: bean.curProQHRate, floatNum: 2, showStyle: .showStyleNoZero))%", cellHeight: 45))
            }
        } else if selectTip.0 == .compeProject {//竞品楼盘
            let bean = selectTip.1 as! ProjectSellCompetionBean
            if DQSUtils.isNotBlank(bean.competionName) {
                handledBeans.append(ProjectSellCompetionDetailBean(title: "竞品楼盘", content: bean.competionName, cellHeight: 45))
            }
            if DQSUtils.isNotBlank(bean.competionLocation) {
                let textHeight = DQSUtils.heightForText(text: bean.competionLocation, fixedWidth: SCREEN_WIDTH-250, fixedFont: UIFont.systemFont(ofSize: 14))
                handledBeans.append(ProjectSellCompetionDetailBean(title: "地理位置", content: bean.competionLocation, cellHeight: textHeight + 45))
                
            }
            if bean.competionSellDate != 0 {
                handledBeans.append(ProjectSellCompetionDetailBean(title: "开盘时间", content: DQSUtils.showTime(interval: TimeInterval(bean.competionSellDate/1000), timeFormate: "yyyy-MM-dd"), cellHeight: 45))
            }
            if DQSUtils.isNotBlank(bean.competionRoom) {
                handledBeans.append(ProjectSellCompetionDetailBean(title: "主力户型", content: bean.competionRoom, cellHeight: 45))
            }
            if bean.competionUnitPrice != 0 {
                handledBeans.append(ProjectSellCompetionDetailBean(title: "销售均价", content: "\(DQSUtils.showDoubleNum(sourceDouble: bean.competionUnitPrice/10000, floatNum: 2, showStyle: .showStyleNoZero))万元/㎡", cellHeight: 45))
            }
            if bean.competionAll != 0 {
                handledBeans.append(ProjectSellCompetionDetailBean(title: "总套数", content: "\(DQSUtils.showDoubleNum(sourceDouble: Double(bean.competionAll), floatNum: 2, showStyle: .showStyleNoZero))", cellHeight: 45))
            }
            if DQSUtils.isNotBlank(bean.competionSellRate) {
                let textHeight = DQSUtils.heightForText(text: bean.competionSellRate, fixedWidth: SCREEN_WIDTH-250, fixedFont: UIFont.systemFont(ofSize: 14))
                handledBeans.append(ProjectSellCompetionDetailBean(title: "去化率", content: bean.competionSellRate, cellHeight: textHeight + 45))
            }
            if DQSUtils.isNotBlank(bean.competionRateThreeMonth) {
                let textHeight = DQSUtils.heightForText(text: bean.competionRateThreeMonth, fixedWidth: SCREEN_WIDTH-250, fixedFont: UIFont.systemFont(ofSize: 14))
                handledBeans.append(ProjectSellCompetionDetailBean(title: "最近三个月去化情况", content: bean.competionRateThreeMonth, cellHeight: textHeight + 45))
            }
            if DQSUtils.isNotBlank(bean.competionSituation) {
                let textHeight = DQSUtils.heightForText(text: bean.competionSituation, fixedWidth: SCREEN_WIDTH-250, fixedFont: UIFont.systemFont(ofSize: 14))
                handledBeans.append(ProjectSellCompetionDetailBean(title: "优劣势比较", content: bean.competionSituation, cellHeight: textHeight + 45))
            }
        }
        
        return handledBeans
    }
    
    @IBAction func hideDetailView() {
        bringSubviewToFront(mapView)
    }
}

