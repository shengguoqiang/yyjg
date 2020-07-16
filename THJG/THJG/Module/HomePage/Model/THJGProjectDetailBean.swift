/**
 * 项目详情实体
 */

//MARK: - 项目详情
struct THJGProjectDetailBean: THJGBaseBean {
    
    var proImgs: [THJGProImgBean]
    var proVideos: [THJGProVideoBean]
    var proIndicators: String
    var proSituation: String
    var proDeveloper: THJGProDevBean
    var proType: String
    var proLoanAmount: Double
    var proLoanBalance: Double
    var proExpireDate: Int64
    var proRisk: String
    var proSellIndicators: String
    var proDaylyManageVideos: [THJGProVideoBean]
    var loanCompanys: [THJGCompanyInfoBean]
    var guaranteeCompanys: [THJGCompanyInfoBean]
    var devCompanys: [THJGCompanyInfoBean]
    var pledgeInfos: [THJGPldgeInfoBean]
    var workCompanys: [THJGCompanyInfoBean]
    
    static func parse(_ data: JSONTYPE) -> THJGProjectDetailBean {
        var proImgs = [THJGProImgBean]()
        if let imgArray = data["proImgs"].array  {
            for img in imgArray {
                proImgs.append(THJGProImgBean.parse(img))
            }
        }
        
        var proVideos = [THJGProVideoBean]()
        if let videoArray = data["proVideos"].array {
            for video in videoArray {
                proVideos.append(THJGProVideoBean.parse(video))
            }
            // TODO:测试专用，后期删除！！！
            proVideos.append(THJGProVideoBean(proVideoStatus: 1, proVideoType: 13, proVideoPic: "https://statics.ys7.com/device/assets/imgs/public/homeDevice.jpeg", proVideoName: "新楚", proVideoUrl: "", proVideoDeviceSerial: "6D07CC7PANED259"))
        }
        
        let proDeveloper = THJGProDevBean.parse(data["proDeveloper"])
        
        var proDaylyManageVideos = [THJGProVideoBean]()
        if let manageVideoArray = data["proDaylyManageVideos"].array {
            for video in manageVideoArray {
                proDaylyManageVideos.append(THJGProVideoBean.parse(video))
            }
        }
        
        var loanCompanys = [THJGCompanyInfoBean]()
        if let loanCompanyArray = data["loanCompanys"].array {
            for com in loanCompanyArray {
                loanCompanys.append(THJGCompanyInfoBean.parse(com))
            }
        }
        
        var guaranteeCompanys = [THJGCompanyInfoBean]()
        if let guaCompanyArray = data["guaranteeCompanys"].array {
            for com in guaCompanyArray {
                guaranteeCompanys.append(THJGCompanyInfoBean.parse(com))
            }
        }
        
        var devCompanys = [THJGCompanyInfoBean]()
        if let devCompanyArray = data["devCompanys"].array {
            for com in devCompanyArray {
                devCompanys.append(THJGCompanyInfoBean.parse(com))
            }
        }
        
        var pledgeInfos = [THJGPldgeInfoBean]()
        if let pledgeArray = data["pledgeInfos"].array {
            for pledge in pledgeArray {
                pledgeInfos.append(THJGPldgeInfoBean.parse(pledge))
            }
        }
        
        var workCompanys = [THJGCompanyInfoBean]()
        if let workCompanyArray = data["workCompanys"].array {
            for com in workCompanyArray {
                workCompanys.append(THJGCompanyInfoBean.parse(com))
            }
        }
        
        return THJGProjectDetailBean(proImgs: proImgs,
                                     proVideos: proVideos,
                                     proIndicators: data["proIndicators"].string ?? "000000",
                                     proSituation: data["proSituation"].string ?? "",
                                     proDeveloper: proDeveloper,
                                     proType: data["proType"].string ?? "",
                                     proLoanAmount: data["proLoanAmount"].double ?? 0,
                                     proLoanBalance: data["proLoanBalance"].double ?? 0,
                                     proExpireDate: data["proExpireDate"].int64 ?? 0,
                                     proRisk: data["proRisk"].string ?? "",
                                     proSellIndicators: data["proSellIndicators"].string ?? "",
                                     proDaylyManageVideos: proDaylyManageVideos,
                                     loanCompanys: loanCompanys,
                                     guaranteeCompanys: guaranteeCompanys,
                                     devCompanys: devCompanys,
                                     pledgeInfos: pledgeInfos,
                                     workCompanys: workCompanys)
    }
}

//MARK: - 项目平面图
struct THJGProImgBean: THJGBaseBean {
    
    var proImgName: String
    var proImgUrl: String
    
    static func parse(_ data: JSONTYPE) -> THJGProImgBean {
        return THJGProImgBean(proImgName: data["proImgName"].string ?? "",
                              proImgUrl: data["proImgUrl"].string ?? "")
    }
    
}

//MARK: - 项目实时监控
struct THJGProVideoBean: THJGBaseBean {
    
    var proVideoStatus: Int //0.不在线，1.在线，-1.设备未上报
    var proVideoType: Int  //10.萤石实时视频 20.本地录制视频 13.大华实时视频
    var proVideoPic: String
    var proVideoName: String
    var proVideoUrl: String
    var proVideoDeviceSerial: String
    
    static func parse(_ data: JSONTYPE) -> THJGProVideoBean {
        return THJGProVideoBean(proVideoStatus: data["proVideoStatus"].int ?? 0,
                                proVideoType: data["proVideoType"].int ?? 0,
                                proVideoPic: data["proVideoPic"].string ?? "",
                                proVideoName: data["proVideoName"].string ?? "",
                                proVideoUrl: data["proVideoUrl"].string ?? "",
                                proVideoDeviceSerial: data["proVideoDeviceSerial"].string ?? "")
    }
}

//MARK: - 开发商
struct THJGProDevBean: THJGBaseBean {
    
    var devName: String
    var devCode: String
    var devLegalName: String
    var devDes: String
    
    static func parse(_ data: JSONTYPE) -> THJGProDevBean {
        return THJGProDevBean(devName: data["devName"].string ?? "",
                              devCode: data["devCode"].string ?? "",
                              devLegalName: data["devLegalName"].string ?? "",
                              devDes: data["devDes"].string ?? "")
    }
}

//MARK: - 公司信息
struct THJGCompanyInfoBean: THJGBaseBean {
   
    var companyId: String
    var companyName: String
    var companyIndicators: String
    var companyType: String
    
    static func parse(_ data: JSONTYPE) -> THJGCompanyInfoBean {
        return THJGCompanyInfoBean(companyId: data["companyId"].string ?? "",
                                   companyName: data["companyName"].string ?? "",
                                   companyIndicators: data["companyIndicators"].string ?? "",
                                   companyType: data["companyType"].string ?? "")
    }
}

//MARK: - 项目抵押情况
struct THJGPldgeInfoBean: THJGBaseBean {
    
    var pledgeIndex: Int // 索引
    var pledgeType: Int // 10 抵押物 20 质押物
    var pledgeNodeType: Int // 10 设定时 20 当前现状
    var pledgeContent: String
    
    static func parse(_ data: JSONTYPE) -> THJGPldgeInfoBean {
        return THJGPldgeInfoBean(pledgeIndex: data["pledgeIndex"].int ?? 0,
                                 pledgeType: data["pledgeType"].int ?? 0,
                                 pledgeNodeType: data["pledgeNodeType"].int ?? 0,
                                 pledgeContent: data["pledgeContent"].string ?? "")
    }
}
