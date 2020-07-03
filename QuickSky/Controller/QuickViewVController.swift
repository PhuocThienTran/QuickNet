//
//  QuickViewVController.swift
//  QuickNet
//
//  Created by DTran on 12/13/19.
//  Copyright © 2019 TPT. All rights reserved.
//

import UIKit
import SwiftyJSON



class QuickViewVC: UIViewController {
    
    enum ScreenMode {
        case search
        case history
    }
    
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var infoLAbel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var models = [ModeSearchCity]()
    
    private var screenMode: ScreenMode = .search
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.searchBar.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch  screenMode {
        case .search:
            navigationItem.title = "QuickSky"
            searchBar.isHidden = false
            models.removeAll()
            weatherCollectionView.reloadData()
        case .history:
            searchBar.isHidden = true
            navigationItem.title = "History"
            models = appDelegate.modeCitys
            weatherCollectionView.reloadData()
        }
        
    }
    @IBAction func btnChangeScreen(_ sender: Any) {
        changeScreenMode()
    }
    
    func changeScreenMode () {
        switch screenMode {
        case .history:
            self.screenMode = .search
        case .search:
            self.screenMode = .history
        }
        
        viewWillAppear(true)
    }
    
    
}

extension QuickViewVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cityCell", for: indexPath) as! cityCell
        let model = models[indexPath.row]
        cell.bind(model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //push
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: "WeatherDetail") as? WeatherDetail{
            vc.model = models[indexPath.row]
            
            switch screenMode {
            case .search:
                // save data City
                appDelegate.modeCitys.append(vc.model)
                UserDefaults.standard.setLocations(appDelegate.modeCitys, forKey: "modeCitys")
            default:
                break
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

extension QuickViewVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        getlocationKey(city: searchText)
    }
}

extension QuickViewVC {
    func getlocationKey(city : String?){
        guard let city  = city else {
            return
        }
        let session = URLSession.shared
        guard let WeatherUrl = URL(string: "http://dataservice.accuweather.com/locations/v1/cities/autocomplete?apikey=\(apiKey)&q=\(city)&language=en")
            else {
                return
        }
        
        let dataTask = session.dataTask(with: WeatherUrl) { [weak self](data : Data?, response : URLResponse?, error : Error?) in
            guard let self = self else {return}
            if let error = error {
                print("Error : \(error)")
            } else {
                print(JSON(data))
                do {
                    let decode = JSONDecoder()
                    let models = try decode.decode([ModeSearchCity].self, from: data!)
                    self.models = models
                    DispatchQueue.main.async {
                        self.weatherCollectionView.reloadData()
                    }
                }catch{
                    self.models.removeAll()
                    DispatchQueue.main.async {
                        self.weatherCollectionView.reloadData()
                    }
                    
                    print("Error : \(error)")
                }
            }
        }
        dataTask.resume()
    }
    
}
