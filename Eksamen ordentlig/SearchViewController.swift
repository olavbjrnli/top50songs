//
//  SearchViewController.swift
//  Eksamen ordentlig
//
//  Created by Olav Backer-Grøndahl Bjørnli on 29/11/2019.
//  Copyright © 2019 Olav Backer-Grøndahl Bjørnli. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var collectionView: UICollectionView!
    
    
    var searchedAlbums = [TopAlbums]()
    let placeholder = UIImage(named: "placeholder")
    var searchText : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let collectionCell = UINib(nibName: "AlbumsCollectionViewCell", bundle: nil)
        collectionView.register(collectionCell, forCellWithReuseIdentifier: "hahalol")
        self.title = "Search"
       
    }
    
    func getJsonData() {
        let url = "https://theaudiodb.com/api/v1/json/1/searchalbum.php?a=" + self.searchText
        let urlObj = URL(string: url)
        
        URLSession.shared.dataTask(with: urlObj!) {(data, response, error) in
            
            do {
                let downloadAlbums = try JSONDecoder().decode(Album.self, from: data!)
                
                self.searchedAlbums = downloadAlbums.album
                print(self.searchedAlbums)
                DispatchQueue.main.async {
                   self.collectionView.reloadData()
                }
                
            } catch {
                print("we got an error")
                print(self.searchedAlbums)
                
            }
            
            }.resume()
    }
    
    //https://developer.apple.com/documentation/uikit/uicollectionview
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchedAlbums.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hahalol", for: indexPath) as? AlbumsCollectionViewCell else { return UICollectionViewCell() }
        
        cell.artistLbl.text = searchedAlbums[indexPath.row].strArtist
        cell.albumLbl.text = searchedAlbums[indexPath.row].strAlbum
        
        if(searchedAlbums[indexPath.row].strAlbumThumb == nil){
            cell.imgView.image = self.placeholder
        } else {
        if let imageURL = URL(string: searchedAlbums[indexPath.row].strAlbumThumb!){
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
        }
        return cell
    }
 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        /*Uses the searchbar to get the text input, then calls getJsonData() with the text the user inputs
         Made with help from https://stackoverflow.com/questions/3439853/replace-occurrences-of-space-in-url
                                                                                                */
        let urlString = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        self.searchText = urlString!
        print(self.searchText)
        getJsonData()
       
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    /* Passes all the data to another viewcontroller when you press a collectionViewCell
     */
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "Details") as! DetailViewController
        vc.getArtist = searchedAlbums[indexPath.row].strArtist
        vc.getAlbum = searchedAlbums[indexPath.row].strAlbum
        vc.getAlbumID = searchedAlbums[indexPath.row].idAlbum
        vc.getYear = searchedAlbums[indexPath.row].intYearReleased
    
        if(searchedAlbums[indexPath.row].strAlbumThumb == nil){
            searchedAlbums[indexPath.row].strAlbumThumb?.append("placeholder")
        } else {
           
            if let imageURL = URL(string: searchedAlbums[indexPath.row].strAlbumThumb!){
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
        }
    
        self.navigationController?.pushViewController(vc, animated: true)
        print("lol")
    }
    
}

