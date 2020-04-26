//
//  THJGProjectFeeTypeView.swift
//  THJG
//
//  Created by 大强神 on 2019/8/1.
//  Copyright © 2019 中南金融. All rights reserved.
//

import UIKit

fileprivate let THJGProjectFeeTypeCellIdentifier = "THJGProjectFeeTypeCellIdentifier"

typealias THJGProjectFeeTypeCompleteBlock = (SmallTypeBean?)->Void

class THJGProjectFeeTypeView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    
    var completionBlock: THJGProjectFeeTypeCompleteBlock?
    
    var beans: [SmallTypeBean]! {
        didSet {
            tableView.reloadData()
        }
    }
    
    var selectedBean: SmallTypeBean?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //注册cell
        tableView.register(UINib(nibName: "THJGTProjectFeeTypeCell", bundle: nil), forCellReuseIdentifier: THJGProjectFeeTypeCellIdentifier)
        tableView.rowHeight = 45
    }

    static func showFeeTypeView() -> THJGProjectFeeTypeView {
        return Bundle.main.loadNibNamed("THJGProjectFeeTypeView", owner: self, options: nil)?.first as! THJGProjectFeeTypeView
    }
    
}

//MARK: - 方法
extension THJGProjectFeeTypeView {
    
    @IBAction func cancelBtnDidClicked() {
        removeFromSuperview()
    }
    
    @IBAction func confirmBtnDidClicked() {
        completionBlock?(selectedBean)
        removeFromSuperview()
    }
}

extension THJGProjectFeeTypeView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard beans != nil, !beans.isEmpty else {
            return 0
        }
        return beans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: THJGProjectFeeTypeCellIdentifier) as! THJGTProjectFeeTypeCell
        cell.bean = beans[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedBean = beans[indexPath.row]
    }
    
}

