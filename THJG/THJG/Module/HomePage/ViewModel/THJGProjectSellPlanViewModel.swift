/**
 * 销售进度与计划ViewModel
 */

struct THJGProjectSellPlanViewModel {

    //MARK: 外部所需数据
    /**
     * 幢列表
     */
    var plans: [THJGProjectSellPlanBlockViewModel]

    static func viewWithData(_ bean: THJGProjectSellPlanBean) -> THJGProjectSellPlanViewModel {
        var plans = [THJGProjectSellPlanBlockViewModel]()
        for plan in bean.plans {
            plans.append(THJGProjectSellPlanBlockViewModel.viewWithData(plan))
        }
        return THJGProjectSellPlanViewModel(plans: plans)
    }
}

struct THJGProjectSellPlanBlockViewModel {

    //MARK: 外部所需数据
    /**
     * 幢号
     */
    var blockNum: String
    /**
     * 每幢进度列表
     */
    var blockPlans: [THJGProjectSellPlanBlockCellViewModel]
    
    static func viewWithData(_ bean: THJGProjectSellPlanBlockBean) -> THJGProjectSellPlanBlockViewModel {
        var blockPlans = [THJGProjectSellPlanBlockCellViewModel]()
        for block in bean.planDetailList {
            blockPlans.append(THJGProjectSellPlanBlockCellViewModel.viewWithData(block))
        }
        return THJGProjectSellPlanBlockViewModel(blockNum: bean.planBuildingNum,
                                                 blockPlans: blockPlans)
    }
    
}

struct THJGProjectSellPlanBlockCellViewModel {

    //MARK: 外部所需数据
    /**
     * 实体
     */
    var bean: THJGProjectSellPlanBlockDetailBean
    /**
     * cell高度
     */
    var cellHeight: CGFloat
    
    static func viewWithData(_ bean: THJGProjectSellPlanBlockDetailBean) -> THJGProjectSellPlanBlockCellViewModel {
        // 计算cell高度
        var cellHeight: CGFloat = 90
        if DQSUtils.isNotBlank(bean.planRemark) { // 备注不为空
            cellHeight += DQSUtils.heightForText(text: bean.planRemark, fixedWidth: SCREEN_WIDTH - 30, fixedFont: .systemFont(ofSize: 14)) + 20
        }
        return THJGProjectSellPlanBlockCellViewModel(bean: bean,
                                                     cellHeight: cellHeight)
    }
    
}
