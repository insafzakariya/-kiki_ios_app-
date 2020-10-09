//
//  DetailPopoverViewController.swift
//  SusilaMobile
//
//  Created by Isuru Jayathissa on 1/26/17.
//  Copyright © 2017 Isuru Jayathissa. All rights reserved.
//

import UIKit

class DetailPopoverViewController: UIViewController {
    
    var returnView:UIView?
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var popoverTitleLabel: UILabel!
    
    @IBOutlet weak var titleViewHeight: NSLayoutConstraint!
    @IBOutlet weak var titleView: UIView!
    
    @IBOutlet weak var rejectNoteTextView: UITextView!
    //    var mapModel : MapModel!
    fileprivate var tapCloserRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapCloserRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailPopoverViewController.dismissViewController(_:)))
        tapCloserRecognizer.cancelsTouchesInView = false;
        tapCloserRecognizer.numberOfTapsRequired = 1;
        tapCloserRecognizer.delegate = self
        
        
        popoverTitleLabel.text = title
        if let returnView = returnView{
            mainView.addSubview(returnView)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let windowView = self.view.window{
            windowView.addGestureRecognizer(tapCloserRecognizer)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @objc func dismissViewController(_ sender: UITapGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.ended{
            var location: CGPoint = sender.location(in: nil)
            if UIApplication.shared.statusBarOrientation.isLandscape{
                location = CGPoint(x: location.y, y: location.x)
            }
            
            let inView: Bool = self.view.point(inside: self.view.convert(location, from: self.view.window), with: nil)
            if (!inView){
                //                self.view.window?.removeGestureRecognizer(tapCloserRecognizer)
                //                dismissViewControllerAnimated(true, completion: nil)
                self.tappedCloseButton(nil)
            }
        }
        //        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func tappedCloseButton(_ sender: AnyObject?) {
        //        dismissViewControllerAnimated(true, completion: nil)
        self.view.window?.removeGestureRecognizer(tapCloserRecognizer)
        dismiss(animated: true, completion: nil)
    }
    
}


extension DetailPopoverViewController: UIGestureRecognizerDelegate  {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
}
