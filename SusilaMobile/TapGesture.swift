//
//  PlaylistSelectSongTapGesture.swift
//  SusilaMobile
//
//  Created by Kiroshan on 2/14/20.
//  Copyright © 2020 Isuru Jayathissa. All rights reserved.
//

class PlaylistSelectSongTapGesture: UITapGestureRecognizer {
    var id = ""
    var sname = ""
    var dese = ""
    var url = ""
}

class HomeTapGesture: UITapGestureRecognizer {
    var lname = ""
}

class PlaylistPlayGesture: UITapGestureRecognizer {
    var id = 0
}

class PlaylistTapGesture: UITapGestureRecognizer {
    var id = ""
    var image = ""
    var title = ""
    var songs = ""
    var year = ""
}

class MyTapGesture: UITapGestureRecognizer {
    var id = 0
    var url = ""
    var aname = ""
    var genre = ""
    var songs = 0
}

class GenreTapGesture: UITapGestureRecognizer {
    var id = ""
    var title = ""
}

class LibraryTapGesture: UITapGestureRecognizer {
    
}

class playSongTapGesture: UITapGestureRecognizer {
    var id = 0
}

class EditPlaylistTapGesture: UITapGestureRecognizer {
    var pid = 0
    var title = ""
    var image = ""
}

class SearchSongTapGesture: UITapGestureRecognizer {
    var objSong:AnyObject? = nil
}

class SearchTapGesture: UITapGestureRecognizer {
    var key = ""
    var type = ""
}
