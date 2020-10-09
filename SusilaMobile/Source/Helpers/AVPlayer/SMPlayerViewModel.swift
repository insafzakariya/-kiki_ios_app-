    //
//  SMPlayerViewModel.swift
//  SusilaMobile
//
//  Created by Isuru Jayathissa on 3/6/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import SwiftyJSON

@objc public class SMPlayerViewModel: NSObject {
    fileprivate let api = ApiClient()
    
    var resolutionChangeView: UIView!
    var playerOverlayVC: AVPlayerOverlayVC!
    
    @objc func sendAnalytics(actionType: String, contendId:Int, currentTime: String) -> Void {
        
        mainInstance.epPlayingStatus = false
        
        api.sendAnalytics(actionType: actionType, contendId: contendId, currentTime:currentTime, success: { (data, code) -> Void in
            switch code {
                case 200:
                    NSLog("Analytics sent : \(actionType) - \(contendId) - \(currentTime)")
                default:
                    NSLog("Analytics sent Error occrrued, code: \(code)")
            }
        }) { (error) -> Void in
            NSLog("Error (likeEpisode): \(error.localizedDescription)")
        }
    }
    
    @objc func showResolutionList(sender: UIButton, viewController: UIViewController, perentViewController: UIViewController){
        playerOverlayVC = viewController as? AVPlayerOverlayVC  //last change "?"
        
        let genderList = [PopoverTableCellModel](arrayLiteral: (PopoverTableCellModel(id: 0, userId: 125100, name: "144p", parentID: 0)),
                                                 (PopoverTableCellModel(id: 1, userId: 494100, name: "240p", parentID: 0)),
                                                 (PopoverTableCellModel(id: 2, userId: 625100, name: "360p", parentID: 0)),
        (PopoverTableCellModel(id: 3, userId: 1794100, name: "480p", parentID: 0)),
        (PopoverTableCellModel(id: 4, userId: 4044100, name: "720p", parentID: 0)))
        
        shwoPopupTableView(listItem: genderList, sender: sender, objectTag: 1, viewController: perentViewController)
        
    }
    
    func shwoPopupTableView(listItem: [PopoverTableCellModel], sender: UIButton, objectTag: Int, viewController: UIViewController){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popupViewController = storyboard.instantiateViewController(withIdentifier: "PopoverViewController") as? PopoverViewController
        
        let cellHeight: CGFloat = 30
        
        
        var height: CGFloat = cellHeight * 4
        switch listItem.count{
        case 1:
            height = cellHeight
        case 2:
            height = cellHeight * 2
        case 3:
            height = cellHeight * 3
        case 4:
            height = cellHeight * 4
//        case 5:
//            height = cellHeight * 5
//        case 6:
//            height = cellHeight * 6
        default :()
            
        }
        
        if let popupViewController = popupViewController
        {
            
            popupViewController.cellHeight = cellHeight
            popupViewController.preferredContentSize = CGSize(width: 150,height: height)
            popupViewController.tableList = listItem
            popupViewController.modalPresentationStyle = .popover
            popupViewController.delegate = self
            popupViewController.tabelCelltextAlignment = NSTextAlignment.left
            popupViewController.objectTag = objectTag
            
            
            popupViewController.cellBackGroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            popupViewController.cellTextColor = UIColor.white
            
//            resolutionChangeView = popupViewController.view
            
                        let popoverController = popupViewController.popoverPresentationController
                        popoverController!.permittedArrowDirections = .down
                        popoverController!.delegate = self
                        popoverController!.sourceView = sender
                        popoverController!.sourceRect = sender.bounds //CGRectMake(100,100,0,0)
                        popoverController?.backgroundColor = UIColor.white // ThemeManager.ThemeColors.LighterGrayColor
            
                        viewController.showDetailViewController(popupViewController, sender: nil)
            
            
//                        playerOverlayVC.showResolutionListPopup(popupViewController)
            
            popupViewController.titleViewHeight.constant = 0
            popupViewController.selectedTableItem = listItem[sender.tag];
            
            
            
            
//            popupViewController.cellHeight = cellHeight
////            popupViewController.preferredContentSize = CGSize(width: 150,height: height)
//            popupViewController.tableList = listItem
////            popupViewController.modalPresentationStyle = .popover
//            popupViewController.delegate = self
//            popupViewController.tabelCelltextAlignment = NSTextAlignment.left
//            popupViewController.objectTag = objectTag
//            
//            viewController.addChildViewController(popupViewController)
//            popupViewController.cellBackGroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
//            popupViewController.cellTextColor = UIColor.white
//            
//            popupViewController.view.frame = CGRect(x: 30, y: 30, width: 100, height: height);
//            popupViewController.view.center = viewController.view.center
////            popupViewController.view.frame.origin.x = viewController.view.center.x
////            popupViewController.view.frame.origin.y = viewController.view.center.y - 20
//            
//            viewController.view.addSubview(popupViewController.view)
//            resolutionChangeView = popupViewController.view
//            
////            popupViewController.didMove(toParentViewController: viewController)
//            
////            let popoverController = popupViewController.popoverPresentationController
////            popoverController!.permittedArrowDirections = .down
////            popoverController!.delegate = self
////            popoverController!.sourceView = sender
////            popoverController!.sourceRect = sender.bounds //CGRectMake(100,100,0,0)
////            popoverController?.backgroundColor = UIColor.white // ThemeManager.ThemeColors.LighterGrayColor
//            
////            viewController.showDetailViewController(popupViewController, sender: nil)
////            viewController.present(popupViewController, animated: true, completion: nil)
//            
////            playerOverlayVC.showResolutionListPopup(popupViewController)
//            
//            popupViewController.titleViewHeight.constant = 0
//            //        self.presentViewController(popoverController, animated: true, completion: nil)
        }
        
        
    }

    
}

// MARK: - UIPopoverPresentationControllerDelegate
extension SMPlayerViewModel: UIPopoverPresentationControllerDelegate {
    //    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
    //        return .None
    //    }
    
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        // return UIModalPresentationStyle.FullScreen
        return UIModalPresentationStyle.none
    }
}

extension SMPlayerViewModel: PopoverTableViewDelegate{
    
    func didSelectPopoverTableView(_ popoverViewController: PopoverViewController, selectedIndexPath: IndexPath,item: PopoverTableCellModel?){
        
        if popoverViewController.objectTag == 1{
            if let item = item{
                playerOverlayVC.updatePlayerResolution(Double(item.userId), with:Int32(item.id))
                playerOverlayVC.resolutionButton.setTitle(item.name, for: .normal)
//                resolutionChangeView.removeFromSuperview()
            }
        }
        
    }
    
    func didTappedSubFilterButton(_ sender: UIButton){
        
    }
}

