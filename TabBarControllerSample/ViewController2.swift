//
//  ViewController2.swift
//  TabBarControllerSample
//
//  Created by Juan Mueller on 11/19/22.
//  www.ajourneyforwisdom.com

import Foundation
import UIKit

class ViewController2: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // Outlet for tableView
    @IBOutlet weak var tableView: UITableView!
    // Weather data JSON property
    var wdata: [String: Any]?
    
    override func viewDidLoad() {
        // Call the viewdidload super
        super.viewDidLoad()
        // Always register the tableview cell with the corresponding identifier in the storyboard
        // so it can be reused
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "dataCell")
        // Set the tableview datasource to self
        tableView?.dataSource = self
        // invoke the requestWeatherData method and handle its completion
        requestWeatherData {
            // Code inside this block will be executed in the main thread
            DispatchQueue.main.async { [self] in
                // Reload the tableview
                tableView?.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Retrieve the registered reusable cell from the tableview
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "dataCell",
                                                                  for: indexPath)
        // Switch between the 4 possible rows to display
        switch indexPath.item {
        case 0:
            // Set the cell text
            cell.textLabel?.text = "Temp: " + (wdata != nil ? "\((wdata!["current_weather"] as! [String : Any])["temperature"] ?? "---")" : "---")
            break
        case 1:
            // Set the cell text
            cell.textLabel?.text = "Elevation: " + (wdata != nil ? "\(wdata!["elevation"] ?? "---")" : "---")
            break
        case 2:
            // Set the cell text
            cell.textLabel?.text = "Wind speed: " + (wdata != nil ? "\((wdata!["current_weather"] as! [String : Any])["windspeed"] ?? "---")" : "---")
            break
        case 3:
            // Set the cell text
            cell.textLabel?.text = "Feels like: " + (wdata != nil ? "\(((wdata!["daily"] as! [String : Any])["apparent_temperature_max"] as! [NSNumber])[0])" : "---")
            break
        default:
            break
        }
        // Return cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Set the height of cells as fixed
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Set the number of rows to 4
        return 4
    }
    
    // Method that requests the weather data to meteo and updates the wdata property
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
                 // Update wdata property
                 wdata = json
                 // Call completion handler
                 completion()
             }
          } catch let error {
            print(error.localizedDescription)
          }
        })
        // Trigger request
        task.resume()
    }
}
