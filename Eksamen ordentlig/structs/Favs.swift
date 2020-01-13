//
//  Favs.swift
//  Eksamen ordentlig
//
//  Created by Olav Backer-Grøndahl Bjørnli on 06/12/2019.
//  Copyright © 2019 Olav Backer-Grøndahl Bjørnli. All rights reserved.
//
//This file was made with big help from https://app.quicktype.io/. helped me figuring out how to decode the recommended api
struct Welcome: Decodable {
    let Similar: Similar
    
    enum CodingKeys: String, CodingKey {
        case Similar
    }
}

struct Similar: Decodable {
    let Results: [Results]
    
    enum CodingKeys: String, CodingKey {
        case Results
    }
}

struct Results: Decodable {
    let Name: String

    
    enum CodingKeys: String, CodingKey {
        case Name
        
    }
}


