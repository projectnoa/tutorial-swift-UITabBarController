//
//  item2.swift
//  UITabBarControllerExample
//
//  Created by Juan Reyes on 11/19/22.
//

import Foundation
import UIKit

class ViewController2: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var wdata: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "dataCell")
        tableView?.dataSource = self
        
        requestWeatherData {
            DispatchQueue.main.async { [self] in
                tableView?.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Weather"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
        
        switch indexPath.item {
        case 0:
            cell.textLabel?.text = "Temp: " + (wdata != nil ? "\((wdata!["current_weather"] as! [String : Any])["temperature"] ?? "---")" : "---")
            break
        case 1:
            cell.textLabel?.text = "Elevation: " + (wdata != nil ? "\(wdata!["elevation"] ?? "---")" : "---")
            break
        case 2:
            cell.textLabel?.text = "Wind speed: " + (wdata != nil ? "\((wdata!["current_weather"] as! [String : Any])["windspeed"] ?? "---")" : "---")
            break
        case 3:
            cell.textLabel?.text = "Feels like: " + (wdata != nil ? "\(((wdata!["daily"] as! [String : Any])["apparent_temperature_max"] as! [NSNumber])[0])" : "---")
            break
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func requestWeatherData(_ completion: @escaping () -> Void) {
        // create the url
        let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=32.22&longitude=-110.93&daily=temperature_2m_max,temperature_2m_min,apparent_temperature_max,apparent_temperature_min,sunrise,sunset&current_weather=true&temperature_unit=fahrenheit&timezone=America%2FLos_Angeles")!
            
        // now create the URLRequest object using the url object
        let request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 30.0)
            
        // create dataTask using the session object to send data to the server
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [self] data, response, error in
                
           guard error == nil else {
               return
           }
                
           guard let data = data else {
               return
           }
                
          do {
             //create json object from data
             if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                 wdata = json
                 
                 completion()
             }
          } catch let error {
            print(error.localizedDescription)
          }
        })

        task.resume()
    }
}
