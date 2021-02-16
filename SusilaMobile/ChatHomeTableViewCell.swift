//
//  ChatHomeTableViewCell.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 2021-02-06.
//

import UIKit

protocol ChatPickerViewDelegate{
    func didChatChannelTapped(for channel:ChatChannel)
}

class ChatHomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var channels:[ChatChannel]?
    var delegate:ChatPickerViewDelegate?
    
    func setupCell(){
        collectionView.register(UINib(nibName: "ChatCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "chatCollectionViewCell")
        setDataSourceAndDelegate()
    }
    
    private func setDataSourceAndDelegate(){
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setChannels(for channels:[ChatChannel]){
        self.channels = channels
        self.collectionView.reloadData()
    }
    
    
}


extension ChatHomeTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.channels?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let channel = channels?[indexPath.row]{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chatCollectionViewCell", for: indexPath) as! ChatCollectionViewCell
            cell.setupCell(for: channel)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let tappedChannel = channels?[indexPath.row]{
            delegate?.didChatChannelTapped(for: tappedChannel)
        }
    }
}
