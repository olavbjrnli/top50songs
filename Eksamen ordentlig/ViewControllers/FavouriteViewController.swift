//
//  FavouriteViewController.swift
//  Eksamen ordentlig
//
//  Created by Olav Backer-Grøndahl Bjørnli on 02/12/2019.
//  Copyright © 2019 Olav Backer-Grøndahl Bjørnli. All rights reserved.
//

import UIKit
import CoreData

class FavouriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
   
    var favouriteTracks: [NSManagedObject] = []
    var artistNamesArray = [String]()
    var realQuery : String = ""
    var rec = [String]()

    @IBOutlet var tableView: UITableView!
    @IBOutlet var recCollectionView: UICollectionView!
    @IBOutlet var tableViewText: UITableViewCell!
    @IBOutlet var recAritstText: UILabel!
    
    @IBAction func editMode(_ sender: UIBarButtonItem) {
        if(!tableView.isEditing){
           tableView.isEditing = true
        } else {
            tableView.isEditing = false
        }
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tableCell = UINib(nibName: "FavouriteTableViewCell", bundle: nil)
        tableView.register(tableCell, forCellReuseIdentifier: "favCell")
        let recCollCell = UINib(nibName: "RecommendationsCollectionViewCell", bundle: nil)
        recCollectionView.register(recCollCell, forCellWithReuseIdentifier: "recCell")
        recAritstText.text = "Artists based on your favourites:"
    }

    //Made with big help from https://www.raywenderlich.com/7569-getting-started-with-core-data-tutorial
    override func viewWillAppear(_ animated: Bool) {
        //Resets the recommendations
        self.rec.removeAll()
        super.viewWillAppear(animated)
        tableView.isEditing = false
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext

        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "FavTrack")
 
        do {
            favouriteTracks = try managedContext.fetch(fetchRequest)
            
            for artist in favouriteTracks {
                /* tried to do something here where if artist was already in list, it woundt add. I did not make the delete function to work with this.
                if(artistNamesArray.contains(artist.value(forKey: "artist") as! String)){
                    
                }else { */
                artistNamesArray.append(artist.value(forKey: "artist") as! String)
                
               
            }
            self.getQuery()
            self.getJsonData()
        } catch let error as NSError {
            print("Could not fetch. \(error)")
            }
         tableView.reloadData()
        //Hides text and collectionview if there isnt any favourites
        if(self.favouriteTracks.count == 0){
            self.tableViewText.alpha = 0
            self.recCollectionView.alpha = 0
           
        } else {
            self.tableViewText.alpha = 1
            self.recCollectionView.alpha = 1
        }
        }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteTracks.count
    }
    func getQuery(){
        
        //adds all artits in a single string, making it possible to query it
        let queryUrl = artistNamesArray.joined(separator: "%2c+")
        realQuery = queryUrl.replacingOccurrences(of: " ", with: "+")
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favCell") as? FavouriteTableViewCell else { return UITableViewCell()}
        
        cell.artistLbl.text = favouriteTracks[indexPath.row].value(forKey: "artist") as? String
        cell.trackLbl.text = favouriteTracks[indexPath.row].value(forKey: "name") as? String
        cell.durLbl.text = favouriteTracks[indexPath.row].value(forKey: "duration") as? String
        return cell
        
    }
 
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "FavTrack")
        //alertController made with help from https://medium.com/ios-os-x-development/how-to-use-uialertcontroller-in-swift-70143d7fbede
        let alertController = UIAlertController(title: "Delete", message: "Are you sure you want to delete?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
                print("You've pressed cancel");
            }
            
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action:UIAlertAction) in

            //loop through favTracks object an find item at indexpath, then delete from core data and remove
            //the tableview row at the same time.
            do {
                self.favouriteTracks = try managedContext.fetch(fetchRequest)
                for tracks in [self.favouriteTracks[indexPath.row]] as [NSManagedObject]  {
                    managedContext.delete(tracks)
                    self.favouriteTracks.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                    try managedContext.save()
                    self.artistNamesArray.remove(at: indexPath.row)
                    if(self.favouriteTracks.count == 0){
                        self.artistNamesArray.removeAll()
                    }
                    self.getQuery()
                    self.recCollectionView.reloadData()
                }
                
            } catch let error as NSError {
                print("Could not fetch. \(error)")
            }
           
                }
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            self.present(alertController, animated: true, completion: nil)
            }
    }
    //Made with help from https://www.ralfebert.de/ios-examples/uikit/uitableviewcontroller/reorderable-cells/
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = favouriteTracks[sourceIndexPath.row]
        favouriteTracks.remove(at: sourceIndexPath.row)
        favouriteTracks.insert(movedObject, at: destinationIndexPath.row)
    }
    func getJsonData() {
        
        let url = "https://tastedive.com/api/similar?q=" + self.realQuery
        print(url)
        let urlObj = URL(string: url)
        
       URLSession.shared.dataTask(with: urlObj!) {(data, response, error) in
            //decodes the dictionaries and adds all the names of artist in an array
            do {
                let downloadAlbums = try JSONDecoder().decode(Welcome.self, from: data!)
                print(downloadAlbums.self.Similar.Results)
                for item in downloadAlbums.self.Similar.Results {
                    self.rec.append(item.Name)
                }
                print(self.rec.count)

                DispatchQueue.main.async {
                    self.recCollectionView.reloadData()
                }
            } catch {
                print("we got an error", error)
              
            }
            }.resume()
       
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rec.count
    }
    //Some customization on the cells, adding border and round edges
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recCell", for: indexPath) as? RecommendationsCollectionViewCell else { return UICollectionViewCell() }
    
        cell.artistLbl.text = rec[indexPath.row]
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10.0
        
        return cell
    
    }
 
}

