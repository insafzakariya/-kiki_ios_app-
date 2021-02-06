//
//  ChatPickerView.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 2021-02-03.
//

import UIKit

protocol ChatPickerViewDelegate{
    //FIXME:
    func didChatItemTapped()
}

class ChatPickerView: UIView {
    
    //TODO: Bind with model
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate:ChatPickerViewDelegate?
    var channels:[Channel]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("ChatPicker", owner: self, options: nil)
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
        
    }
    
    func setDataSourceAndDelegate(){
        //FIXME
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setChannels(for channels:[Channel]){
        self.channels = channels
        self.collectionView.reloadData()
    }
    
    
}

extension ChatPickerView:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
        //TODO
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO
        delegate?.didChatItemTapped()
    }
}
