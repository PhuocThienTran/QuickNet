//
//  WeatherDetailController.swift
//  QuickNet
//
//  Created by DTran on 12/13/19.
//  Copyright © 2019 TPT. All rights reserved.
//

import UIKit
import SwiftyJSON

class WeatherDetail: UIViewController
{
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var maxDegree: UILabel!
    @IBOutlet weak var detailText: UILabel!
    @IBOutlet weak var detailTableView: UITableView!
    
    var dailyForecast: [DailyForecast] = []
    var today: Headline?
    var selectCity: [String:String] = [:]
    var model : ModeSearchCity!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.title = selectCity["city"]?.capitalizingFirstLetter
        fetchWeatherDetails()
    }
    
    func fetchWeatherDetails()
    {
        guard let model = model else {return}
        if let urlStirng = URL(string: "https://dataservice.accuweather.com/forecasts/v1/daily/5day/\(model.key!)?apikey=\(apiKey)&language=en&metric=true")
        {
            let task = URLSession.shared.dataTask(with: urlStirng) { (data, response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print(JSON(data!))
                    DispatchQueue.main.async {
                        do {
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .secondsSince1970
                            var weather = try decoder.decode(WeatherResponse.self, from: data!)
                            weather.selectCity = self.selectCity
                            appDelegate.weatherResponses.append(weather)
                            UserDefaults.standard.setLocations(appDelegate.weatherResponses, forKey: "weatherResponses")
                            self.maxDegree.text = weather.dailyForecasts.first!.temperature.maximum.value.degreeFormat
                            self.detailText.text = weather.headline.text
                            self.today = weather.headline
                            self.dailyForecast = weather.dailyForecasts
                            
                            self.detailTableView.reloadData()
                        } catch {
                            print("Parse Error \(error)")
                        }
                    }
                }
            }
            task.resume()
        }
    }
}

extension WeatherDetail: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyForecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as? DetailTableView
        {
            let weather = self.dailyForecast[indexPath.row]
            
            dayLabel.text = dailyForecast.first?.epochDate?.weekDayName
            cell.dateLabel.text = weather.epochDate?.weekDayName
            cell.maxDegree.text = weather.temperature.maximum.value.degreeFormat
            cell.minDegree.text = weather.temperature.minimum.value.degreeFormat
            //            cell.selectionStyle
            
            switch weather.day.icon
            {
            case 1...5:
                cell.dayIcon.image = UIImage(named: "sun")
            case 6...8, 11:
                cell.dayIcon.image = UIImage(named: "cloud")
            case 12...14, 16, 17:
                cell.dayIcon.image = UIImage(named: "rain")
            case 15, 18:
                cell.dayIcon.image = UIImage(named: "thunder")
            case 19, 22...26, 29:
                cell.dayIcon.image = UIImage(named: "snowflake")
            case 32:
                cell.dayIcon.image = UIImage(named: "wind")
            default:
                cell.dayIcon.image = UIImage(named: "notFound")
            }
            return cell
        }
        else
        {
            return DetailTableView()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let weather = self.dailyForecast[indexPath.row]
        
        dayLabel.text = weather.epochDate?.weekDayName
        maxDegree.text = weather.temperature.maximum.value.degreeFormat
        
        if indexPath.row == 0
        { detailText.text = today?.text }
        else
        { detailText.text = "\(weather.epochDate!.weekDayName) \(weather.day.iconPhrase)" }
    }
}
