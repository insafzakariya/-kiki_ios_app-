//
//  CollapsibleTableViewController.swift
//  ios-swift-collapsible-table-section
//
//  Created by Yong Su on 5/30/16.
//  Copyright © 2016 Yong Su. All rights reserved.
//

import UIKit

//
// MARK: - View Controller
//
class CollapsiblePlaylistTableViewController: UITableViewController {
    
    var sections = [Section](){
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var parentView: PlaylistViewController?
    var playerView: PlayerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }
    public func loadData(){
        // Auto resizing the height of the cell
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = .none
        
        self.title = "Apple Products"
        tableView.reloadData()
    }
    
}

//
// MARK: - View Controller DataSource and Delegate
//
extension CollapsiblePlaylistTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].collapsed ? 0 : sections[section].songs.count
    }
    
    // Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CollapsibleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CollapsibleTableViewCell ??
            CollapsibleTableViewCell(style: .default, reuseIdentifier: "cell")
        
        cell.song = sections[indexPath.section].songs[indexPath.row]
        cell.index = indexPath.row
        cell.playList = sections[indexPath.section].songs
        cell.playerView = self.playerView
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // Header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let playlistItem = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsiblePlaylistItem ?? CollapsiblePlaylistItem(reuseIdentifier: "header")
        
        playlistItem.titleLabel.text = sections[section].name
        playlistItem.setCollapsed(sections[section].collapsed)
        playlistItem.section = section
        playlistItem.delegate = self
        playlistItem.playerView = self.playerView
        playlistItem.songs = sections[section].songs
        return playlistItem
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }

}

//
// MARK: - Section Header Delegate
//
extension CollapsiblePlaylistTableViewController: CollapsibleTableViewHeaderDelegate {
    
    func toggleSection(_ header: CollapsiblePlaylistItem, section: Int) {
        let collapsed = !sections[section].collapsed
        
        if (sections[section].songs.isEmpty) {
            let alert = UIAlertController(title: "Kiki", message: "No Songs Available", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK_BUTTON_TITLE".localized(using: "Localizable"), comment: ""), style: UIAlertAction.Style.default, handler: nil))
            self.parentView?.viewController!.present(alert, animated: true, completion: nil)
            return
        }
        // Toggle collapse
        sections[section].collapsed = collapsed
        header.setCollapsed(collapsed)
        
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
    
}
