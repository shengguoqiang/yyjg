/**
 * 资金信息-账号信息
 */
import UIKit

fileprivate let kFundInfoAccountCellIdentifier = "fundInfoAccountCellIdentifier"

class THJGFundInfoAccountView: UIView {

    @IBOutlet weak var accountSumLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //注册cell
        tableView.register(UINib(nibName: "THJGFundInfoAccountCell", bundle: nil), forCellReuseIdentifier: kFundInfoAccountCellIdentifier)
    }
    
    var beans: [ProFundInfoAccountHandledBean]! {
        didSet {
            tableView.reloadData()
        }
    }
    
    func reloadData(accountSum: Double, beans: [ProFundInfoAccountHandledBean]) {
        //监管总额
        accountSumLabel.attributedText = DQSUtils.showString(sourceString: "\(DQSUtils.showNumWithComma(num: DQSUtils.showDoubleNum(sourceDouble: accountSum, floatNum: 2, showStyle: .showStyleNoZero)))万元", neededHandledString: "万元", neededHandledParam: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)])
        
         //列表
        self.beans = beans
    }

}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension THJGFundInfoAccountView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard beans != nil, !beans.isEmpty else {
            return 0
        }
        return beans.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return beans[indexPath.row].cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kFundInfoAccountCellIdentifier) as! THJGFundInfoAccountCell
        cell.reloadData(beans[indexPath.row].cellBean)
        return cell
    }
    
}
