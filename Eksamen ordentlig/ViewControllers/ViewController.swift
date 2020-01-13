//
//  ViewController.swift
//  Eksamen ordentlig
//
//  Created by Olav Backer-Grøndahl Bjørnli on 18/10/2019.
//  Copyright © 2019 Olav Backer-Grøndahl Bjørnli. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    var albumList = [TopAlbums]()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    
    /* This class, with the getJsonData and how to set up tableview and collectionView was made with help from  https://www.youtube.com/watch?v=d9LtFtia4vc and https://www.youtube.com/watch?v=WwT2EyAVLmI The other classes also reuses some of this coded, but i chose to only point that out here, in the mainViewController.
 
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "top 50 albums"
        let tableCell = UINib(nibName: "AlbumsTableViewCell", bundle: nil)
        tableView.register(tableCell, forCellReuseIdentifier: "lolhaha")
        let collectionCell = UINib(nibName: "AlbumsCollectionViewCell", bundle: nil)
        collectionView.register(collectionCell, forCellWithReuseIdentifier: "hahalol")
        getJsonData()
        tableView.alpha = 0
        collectionView.alpha = 1
        
    }
    
    @IBAction func switchVeiws(_ sender:  UISegmentedControl)
       {
            if sender.selectedSegmentIndex == 0 {
                collectionView.alpha = 1
                tableView.alpha = 0
            } else {
                tableView.alpha = 1
                collectionView.alpha = 0
            }
        }
    
    func getJsonData() {
        
        let url = "https://theaudiodb.com/api/v1/json/1/mostloved.php?format=album&format=album"
        let urlObj = URL(string: url)
        
        URLSession.shared.dataTask(with: urlObj!) {(data, response, error) in
            
            do {
                let downloadAlbums = try JSONDecoder().decode(Loved.self, from: data!)
                self.albumList = downloadAlbums.loved
                print(self.albumList)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                }
                
            } catch {
                print("we got an error")
                print(self.albumList)
            }
            
            }.resume()
    }
    
    
    //https://developer.apple.com/documentation/uikit/uicollectionview
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hahalol", for: indexPath) as? AlbumsCollectionViewCell else { return UICollectionViewCell() }
        
        cell.artistLbl.text = albumList[indexPath.row].strArtist
        cell.albumLbl.text = albumList[indexPath.row].strAlbum
        
        
        if let imageURL = URL(string: albumList[indexPath.row].strAlbumThumb!){
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.imgView.image = image
                    }
                }
            }
         }
        
       return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumList.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "lolhaha") as? AlbumsTableViewCell else { return UITableViewCell()}
    
        cell.ArtistLbl.text = albumList[indexPath.row].strArtist
        cell.AlbumLbl.text = albumList[indexPath.row].strAlbum
        
        return cell
    }
    //class made with help from https://www.youtube.com/watch?v=hGV9pfssmXA&t=982s
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "Details") as! DetailViewController
        vc.getArtist = albumList[indexPath.row].strArtist
        vc.getAlbum = albumList[indexPath.row].strAlbum
        vc.getAlbumID = albumList[indexPath.row].idAlbum
        vc.getYear = albumList[indexPath.row].intYearReleased
        
        
        if let imageURL = URL(string: albumList[indexPath.row].strAlbumThumb!){
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        vc.imgThumbnail.image = image
                    }
                }
            }
        }
        //print(albumList[indexPath.row].strAlbum)
        self.navigationController?.pushViewController(vc, animated: true)
    }
  
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "Details") as! DetailViewController
        vc.getArtist = albumList[indexPath.row].strArtist
        vc.getAlbum = albumList[indexPath.row].strAlbum
        vc.getAlbumID = albumList[indexPath.row].idAlbum
        vc.getYear = albumList[indexPath.row].intYearReleased
        
        if let imageURL = URL(string: albumList[indexPath.row].strAlbumThumb!){
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        vc.imgThumbnail.image = image
                    }
                }
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
 
 
    
}

