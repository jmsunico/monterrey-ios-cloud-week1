//
//  cityView.swift
//  myWeather2
//
//  Created by José-María Súnico on 20160623.
//  Copyright © 2016 José-María Súnico. All rights reserved.
//

import UIKit

class cityView: UIViewController {
	var cityName = ""
	var cityCountry = ""
	
	@IBOutlet weak var cityAndCountry: UILabel!
	@IBOutlet weak var cityWeather: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.cityAndCountry.text = cityName + ", " + cityCountry
		self.cityWeather.text = ""
        // Do any additional setup after loading the view.
		
		
		let stringQuery = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22" + cityName + "%2C%20" + cityCountry + "%22)&format=json&u='c'&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
		let weatherQuery = NSURL(string: stringQuery)
		//let weather = NSData(contentsOfURL: NSURL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22madrid%2C%20es%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys")!)
		let weather = NSData(contentsOfURL: weatherQuery!)
		do {
			let jsonAnswer = try NSJSONSerialization.JSONObjectWithData(weather!, options: NSJSONReadingOptions.MutableLeaves)
			
			let dictAnswer = jsonAnswer as! NSDictionary
			let dictQuery = dictAnswer["query"] as! NSDictionary
			let dictResults = dictQuery["results"] as! NSDictionary
			let dictChannel = dictResults["channel"] as! NSDictionary
			let dictUnits = dictChannel["units"] as! NSDictionary
			let dictItem = dictChannel["item"] as! NSDictionary
			let dictCondition = dictItem["condition"] as! NSDictionary
			self.cityWeather.text = String(dictCondition["temp"] as! NSString) + "º" +  String (dictUnits["temperature"] as! NSString) + ", " + String (dictCondition["text"] as! NSString)
		}
		catch _ {
			print ("something happened!")
		}

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
