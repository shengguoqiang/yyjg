/**
 * 日期选择
 */

import UIKit

typealias DatePickerCompleteBlock = (String?)->Void

class THJGDatePickerView: UIView {

    var completeBlock: DatePickerCompleteBlock?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    static func showDatePickerView() -> THJGDatePickerView {
        return Bundle.main.loadNibNamed("THJGDatePickerView", owner: self, options: nil)?.first as! THJGDatePickerView
    }
    
    @IBAction func cancelBtnDidClicked() {
        removeFromSuperview()
    }
    
    @IBAction func confirmBtnDidClicked() {
        completeBlock?(DQSUtils.showTime(interval: datePicker.date.timeIntervalSince1970, timeFormate: "yyyy-MM-dd"))
        removeFromSuperview()
    }
    
}
