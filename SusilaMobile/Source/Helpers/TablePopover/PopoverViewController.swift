//
//  PopoverViewController.swift
//  CAMS
//
//  Created by Isuru Jayathissa on 7/23/15.
//  Copyright (c) 2015 Isuru Jayathissa. All rights reserved.
//

import UIKit

 protocol PopoverTableViewDelegate {

    func didSelectPopoverTableView(_ popoverViewController: PopoverViewController, selectedIndexPath: IndexPath,item: PopoverTableCellModel?)
    func didTappedSubFilterButton(_ sender: UIButton)
}


class PopoverViewController: UIViewController {

    var objectTag: Int = 0
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var titleViewHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleView: UIView!
    
    var tableList : [PopoverTableCellModel]?
    var delegate: PopoverTableViewDelegate?
    var selectedTableItem: PopoverTableCellModel?
    
    var tabelCelltextAlignment: NSTextAlignment = NSTextAlignment.center
    var cellBackGroundColor = UIColor.white
    var cellTextFont = UIFont.systemFont(ofSize: 17)
    var cellTextColor = UIColor.black
    var cellColorViewEnable = false
    var cellHeight:CGFloat = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none

//        if let selectedTableIndex = selectedTableIndex{
//            if let _ = tableView.cellForRowAtIndexPath(selectedTableIndex){
//                tableView.selectRowAtIndexPath(selectedTableIndex, animated: false, scrollPosition: .Bottom)
//            }
//        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


// MARK: - UITableViewDataSource
extension PopoverViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let tableList = tableList {
            return tableList.count
        }
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PopoverTableViewCell.identifier(), for: indexPath) as! PopoverTableViewCell
        
        cell.contentView.backgroundColor = cellBackGroundColor
        configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    fileprivate func configureCell(_ cell: PopoverTableViewCell, indexPath: IndexPath) {
        if let tableList = tableList {
            
            if (indexPath as NSIndexPath).row == tableList.count - 1{
                cell.bottomView.isHidden = true
            }else{
                cell.bottomView.isHidden = false
            }
            
            let item = tableList[(indexPath as NSIndexPath).row]
//            if titleViewHeight.constant == 0 {
//                cell.tableCellLabel.textAlignment = NSTextAlignment.Center
//            }else{
//                cell.tableCellLabel.textAlignment = NSTextAlignment.Left
//            }
            cell.accessoryType = .none
            if let selectedTableItem = selectedTableItem{
                if item.id == selectedTableItem.id{
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .bottom)
                    cell.accessoryType = .checkmark
                }
            }
            
            cell.tableCellLabel.textColor = cellTextColor
            cell.tableCellLabel.font = cellTextFont
            cell.tableCellLabel.textAlignment = tabelCelltextAlignment
            cell.tableCellLabel.text = item.name
            
            if cellColorViewEnable{
                cell.colorView.isHidden = false
                cell.colorViewWidth.constant = 12
                let alpha = (0.2 * Float((indexPath as NSIndexPath).row)) + 0.2
                cell.colorView.backgroundColor = UIColor(red: 179/255, green: 179/255, blue: 179/255, alpha: CGFloat(alpha))
            }else{
                cell.colorView.isHidden = true
                cell.colorViewWidth.constant = 0
            }
        }
        
    }
    
    fileprivate func close(_ item: PopoverTableCellModel?, selectedIndexPath: IndexPath) {
        
        self.dismiss(animated: false, completion: { () -> Void in
            self.delegate?.didSelectPopoverTableView(self, selectedIndexPath: selectedIndexPath, item:item)
        })
    }
}

// MARK: - UITableViewDelegate
extension PopoverViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tableList = tableList {
            let item = tableList[(indexPath as NSIndexPath).row]
            close(item, selectedIndexPath:indexPath)
        }else{
            close(nil, selectedIndexPath:indexPath)
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight //heightForCellAtIndexPath(indexPath)
    }

}
