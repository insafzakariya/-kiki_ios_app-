//
//  SMNotificationViewController.swift
//  SusilaMobile
//
//  Created by Rashminda on 06/10/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import UIKit

class SMNotificationViewController: UIViewController {
    
    @IBOutlet weak var btnDeleteAll: UIButton!
    @IBOutlet weak var lblEmtyList: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let notificationListViewModel = NotificationListModel()
    var lastOpenedRow = -1;
    fileprivate let api = ApiClient()
    var notificationIDS = Array<Any>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblEmtyList.isHidden = true
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 44.0;

        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.separatorInset = UIEdgeInsets.zero
        // Remove seperator inset
        if tableView.responds(to: #selector(setter: UITableViewCell.separatorInset))  {
            tableView.separatorInset = UIEdgeInsets.zero
        }
        
        // Prevent the cell from inheriting the Table View's margin settings
        if tableView.responds(to: #selector(setter: UIView.layoutMargins))  {
            tableView.layoutMargins =  UIEdgeInsets.zero
        }
        btnDeleteAll.setTitle(NSLocalizedString("CLEAR_ALL".localized(using: "Localizable"), comment: ""), for: .normal)
        self.title = NSLocalizedString("NOTIFICATIONS".localized(using: "Localizable"), comment: "")
        
        loadNotificationList();
        
    }
    
    @IBAction func actExpandToggle(_ sender: UIButton) {

        if(self.lastOpenedRow != sender.tag && self.lastOpenedRow > -1){
            let rowDataLastExpanded = notificationListViewModel.messageList[self.lastOpenedRow]
            rowDataLastExpanded.expanded = false
        }

        self.lastOpenedRow = sender.tag

        let rowData = notificationListViewModel.messageList[sender.tag]
        rowData.expanded = !rowData.expanded
//        if (!rowData.expanded){
//            self.lastOpenedRow = -1
//        }
        self.tableView.reloadData()
    }
    
        @IBAction func actDelete(_ sender: UIButton) {
            ProgressView.shared.show(self.view, mainText: nil, detailText: nil)
            notificationListViewModel.clearNotification(notificationID:sender.tag, clearNotificationCallFinished: { (status, error, userInfo) in
                if status{
    
                    DispatchQueue.main.async(execute: {
                        ProgressView.shared.hide()
                        if let index = self.notificationListViewModel.messageList.firstIndex(where: { (item) -> Bool in
                            item.messageId == sender.tag
                        }) {
                            self.notificationListViewModel.messageList.remove(at: index )
                            if (self.lastOpenedRow == index) {
                                self.lastOpenedRow = -1
                            }
                        }
                        self.tableView.reloadData()
    
                    })
                }else{
                    DispatchQueue.main.async(execute: {
                        ProgressView.shared.hide()
                    })
                }
            })
        }
    
    @IBAction func actDeleteAll(_ sender: UIButton) {
        ProgressView.shared.show(self.view, mainText: nil, detailText: nil)
        notificationListViewModel.clearAllNotification(clearNotificationCallFinished: { (status, error, userInfo) in
            if status{
                
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                    
                    self.loadNotificationList();
                    
                })
            }else{
                DispatchQueue.main.async(execute: {
                    ProgressView.shared.hide()
                })
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadNotificationList(){
        
        ProgressView.shared.show(self.view, mainText: nil, detailText: nil)
        
        var startDate = ""
        var endDate = ""
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "d, MMM yyyy"
        
        startDate = dateFormatter.string(from: Date())
        
        let fromDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        
        endDate = dateFormatter.string(from: fromDate!)
        self.notificationListViewModel.getNotificationList(startDate: startDate, endDate: endDate, getNotificationListCallFinished: { (status, error, userInfo) in
            if status{
                
                DispatchQueue.main.async(execute: {
                    
                    if (self.notificationListViewModel.messageList.count > 0){
                        
                        self.tableView.isHidden = false
                        self.lblEmtyList.isHidden = true
                        
                        self.tableView.reloadData()
                        ProgressView.shared.hide()
                        
                        self.readNotifications()
                    }else{
                        self.tableView.isHidden = true
                        //Common.showAlert(alertTitle: NSLocalizedString("ALERT_TITLE", comment: ""), alertMessage: NSLocalizedString("EMPTY_LIST", comment: ""), perent: self)
                        self.lblEmtyList.isHidden = false
                        ProgressView.shared.hide()

                    }
                    
                })
            }else{
                
                
                DispatchQueue.main.async(execute: {
                    self.tableView.isHidden = true
                    ProgressView.shared.hide()
                })
            }
        })
    }
    
    func readNotifications(){
        for item in notificationListViewModel.messageList {
            notificationIDS.append(item.messageId)
        }
        self.notificationListViewModel.readNotifications(notificationIDArray: notificationIDS, clearNotificationCallFinished:{ (status, error, userInfo) in
        })
    }
    
}

extension SMNotificationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if notificationListViewModel.messageList.isEmpty{
            
        }else{
            
            
        }
    }
    
}
// MARK: - UITableViewDataSource
extension SMNotificationViewController: UITableViewDataSource {
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
////        if (notificationListViewModel.messageList[indexPath.row].expanded){
//            return 150.0
////        }
////        else {
////            return 60.0
////        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if notificationListViewModel.messageList.isEmpty{
            return 0
        }else{
            return notificationListViewModel.messageList.count
        }
        
    }
    
    func getFormattedDate(dateString:String)->String {
        let fullDateTimeArr = dateString.components(separatedBy: " ")
        let dateComponent = fullDateTimeArr[0]
        let dateComponents = dateComponent.components(separatedBy: "-")
        let year = dateComponents[0]
        let day = dateComponents[2]
        var month = ""
        switch dateComponents[1] {
        case "1":
            month = "Jan"
            break
        case "2":
            month = "Feb"
            break
        case "3":
            month = "Mar"
            break
        case "4":
            month = "Apr"
            break
        case "5":
            month = "May"
            break
        case "6":
            month = "Jun"
            break
        case "7":
            month = "Jul"
            break
        case "8":
            month = "Aug"
            break
        case "9":
            month = "Sep"
            break
        case "10":
            month = "Oct"
            break
        case "11":
            month = "Nov"
            break
        case "12":
            month = "Dec"
            break
        default:
            month = "Jan"
            break
        }
        let returnString = day+", "+month+" "+year
        return returnString
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SMNotificationCell", for: indexPath) as! SMNotificationCell
        if notificationListViewModel.messageList.count > 0 {
            let message = notificationListViewModel.messageList[indexPath.row]
            cell.lblNotification.text = message.message
            cell.lblDate.text = getFormattedDate(dateString: message.messageDate)
            cell.notificationID = message.messageId
            cell.btnDelete.tag = message.messageId
//            cell.btnExpandToggle.tag = indexPath.row
            
//            if (notificationListViewModel.messageList[indexPath.row].expanded){
//                cell.btnExpandToggle.setBackgroundImage(UIImage(named: "up"), for: .normal)
//            }
//            else {
//                cell.btnExpandToggle.setBackgroundImage(UIImage(named: "down"), for: .normal)
//            }
        }
        return cell
    }
    
    
}

