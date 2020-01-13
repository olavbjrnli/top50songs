//
//  DetailViewController.swift
//  Eksamen ordentlig
//
//  Created by Olav Backer-Grøndahl Bjørnli on 25/10/2019.
//  Copyright © 2019 Olav Backer-Grøndahl Bjørnli. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var trackList = [TrackList]()
    var getArtist = String()
    var getAlbum = String()
    var getThumbnail = UIImage()
    var getAlbumID = String()
    var getYear = String()
    let placeholder = UIImage(named: "placeholder")
    var favouritedTracks: [NSManagedObject] = []
    
    @IBOutlet var imgThumbnail: UIImageView!
    @IBOutlet var lblArtist: UILabel!
    @IBOutlet var lblAlbum: UILabel!
    @IBOutlet var lblYear: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let trackCell = UINib(nibName: "DetailsTableViewCell", bundle: nil)
        tableView.register(trackCell, forCellReuseIdentifier: "detailsCell")
        imgThumbnail.image = placeholder
        lblArtist.text = getArtist
        lblAlbum.text = getAlbum
        lblYear.text = getYear
        getJsonData()
        
    }
    func getJsonData() {
        let url = "https://theaudiodb.com/api/v1/json/1/track.php?m=" + getAlbumID
        let urlObj = URL(string: url)
        
        
        URLSession.shared.dataTask(with: urlObj!) {(data, response, error) in
            
            do {
                let downloadAlbums = try JSONDecoder().decode(Track.self, from: data!)
               
                self.trackList = downloadAlbums.track
                print(self.trackList)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } catch {
                print("we got an error")
                print(self.trackList)
                
            }
            
            }.resume()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell") as? DetailsTableViewCell else { return UITableViewCell()}
        //Takes the string time, change to int, calculate min/sec and back to string. 
        let strMinutes = trackList[indexPath.row].intDuration
        let intMinutes = Int(strMinutes)!
        let timeFormatter = DateComponentsFormatter()
        timeFormatter.allowedUnits = [.minute, .second]
        let outputTime = timeFormatter.string(from: TimeInterval(intMinutes/1000))
        
        
        cell.trackLbl.text = trackList[indexPath.row].strTrack
        cell.durationLbl.text = outputTime
        
        /* https://stackoverflow.com/questions/46299045/provide-action-for-button-in-the-xib-file-using-swift3 */
        cell.favBtn.addTarget(self, action: #selector(getProducts(_:)), for: .touchUpInside);
        return cell
    }
    
    
    /*Adds the data when pressing index path into core data. Made with big help from https://www.raywenderlich.com/7569-getting-started-with-core-data-tutorial
     Function also determine indexpath from the position of button. Done with help from
     https://stackoverflow.com/questions/45133473/selectors-with-local-functions */
    @objc func getProducts(_ sender: UIButton) {
        let position = sender.convert(CGPoint.zero, to: tableView)
        sender.setImage(UIImage(named: "heart"), for: .normal)
        if let indexPath = tableView.indexPathForRow(at: position){
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            let managedContext =
                appDelegate.persistentContainer.viewContext
            let entity =
                NSEntityDescription.entity(forEntityName: "FavTrack",
                                           in: managedContext)!
            let thisTrack = NSManagedObject(entity: entity,
                                            insertInto: managedContext)
            
            let strMinutes = trackList[indexPath.row].intDuration
            let intMinutes = Int(strMinutes)!
            let timeFormatter = DateComponentsFormatter()
            timeFormatter.allowedUnits = [.minute, .second]
            let outputTime = timeFormatter.string(from: TimeInterval(intMinutes/1000))
            
            thisTrack.setValue(trackList[indexPath.row].strTrack, forKeyPath: "name")
            thisTrack.setValue(outputTime, forKeyPath: "duration")
            thisTrack.setValue(lblArtist.text, forKeyPath: "artist")
            
            do {
                try managedContext.save()
                favouritedTracks.append(thisTrack)
            } catch let error as NSError {
                print("Could not save. \(error),")
            }
        }
        
    }

}

