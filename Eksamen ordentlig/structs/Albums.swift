//
//  Albums.swift
//  Eksamen ordentlig
//
//  Created by Olav Backer-Grøndahl Bjørnli on 18/10/2019.
//  Copyright © 2019 Olav Backer-Grøndahl Bjørnli. All rights reserved.
//

import UIKit

struct TopAlbums : Decodable {
    let strAlbum : String
    let strArtist : String
    let strStyle : String
    var strAlbumThumb : String?
    let idAlbum : String
    let intYearReleased : String

}
struct Loved : Decodable {
    let loved : [TopAlbums]
}

struct TrackList : Decodable {
    let strTrack : String
    let intDuration : String
   
}
struct Track : Decodable {
    let track : [TrackList]
}

struct Album : Decodable {
    let album : [TopAlbums]
}



