
import Foundation
import XLPagerTabStrip

class ChildExampleViewController: UIViewController, IndicatorInfoProvider {
    
    var itemInfo: IndicatorInfo = "View"
    var labelText = ""
    
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if labelText == "Video subscriptions are under development. We will update it soon.Thank you" {
            let label = UILabel(frame: CGRect(x: 35, y: 150, width: self.view.bounds.size.width - 40, height: 100))
            label.textAlignment = .center
            label.font.withSize(20)
            label.numberOfLines = 0
            label.text = labelText
            label.sizeToFit()
            view.addSubview(label)
        }
        else
        {
            let label = UILabel(frame: CGRect(x: 20, y: 150, width: self.view.bounds.size.width - 40, height: 100))
            label.center.x = self.view.center.x
            label.textAlignment = .center
            label.font.withSize(20)
            label.numberOfLines = 0
            label.text = labelText
            label.sizeToFit()
            view.addSubview(label)
        }
        
        view.backgroundColor = .white
    }
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        print(itemInfo)

        return itemInfo
    }
}
