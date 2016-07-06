//
//  ViewController.swift
//  myWeather
//
//  Created by José-María Súnico on 20160622.
//  Copyright © 2016 José-María Súnico. All rights reserved.



import UIKit
import AudioToolbox
import AVFoundation
import AVKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
	@IBOutlet weak var cityName: UILabel!
	
	private var cities : Array<Array<String>> = Array<Array<String>>()
	private var mySound : SystemSoundID = 0
	private var audioPlayer : AVAudioPlayer!
	private var videoPlayer : AVPlayer!
	private var videoController : AVPlayerViewController!
	
	@IBOutlet weak var cityTemperature: UILabel!
	
	
	override func viewDidDisappear(animated: Bool) {
		if audioPlayer.playing {
			audioPlayer.stop()
		}
		
		super.viewDidDisappear(true)
	}

	override func viewDidAppear(animated: Bool) {
		if !audioPlayer.playing {
			//audioPlayer.play()
		}
		
		super.viewDidAppear(true)

	}

	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let soundURL = NSBundle.mainBundle().URLForResource("r2d2", withExtension: "mp3")
		AudioServicesCreateSystemSoundID(soundURL! as CFURL, &mySound)

		let audioURL = NSBundle.mainBundle().URLForResource("r2d2", withExtension: "mp3")
		do {
			try audioPlayer = AVAudioPlayer(contentsOfURL: audioURL!)
		}
		catch {
			print("some error regarding (likely) AV (audio) Player controller")
		}
		AudioServicesCreateSystemSoundID(soundURL! as CFURL, &mySound)

		//let videoURL = NSBundle.mainBundle().URLForResource("seasons", withExtension: "3gp")
		let videoURL = NSBundle.mainBundle().URLForResource("weathers", withExtension: "gif")
		videoPlayer = AVPlayer(URL: videoURL!)
		videoController = AVPlayerViewController()
		videoController.player = videoPlayer

		self.addChildViewController(videoController)
		videoController.view.frame = CGRectMake(50, 150, 180+135, 160+120+100)
		self.view.addSubview(videoController.view)
		videoPlayer.play()

		self.cityName.text = ""
		self.cityTemperature.text = ""
		// Do any additional setup after loading the view, typically from a nib.
		cities.append(["Madrid", "ES"])
		cities.append(["Paris", "FR"])
		cities.append(["Berlin", "DE"])
		cities.append(["Lisboa", "PR"])
		cities.append(["Rome", "IT"])
		cities.append(["London", "UK"])
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	//This method indicates that the number of components of the view selector is just one, the name of the city
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}
	
	//This method indicates that the number of items in the component equals the number of elements in the cities array
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return self.cities.count
	}
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		self.cityName.text = self.cities[row][0] + ", " + self.cities[row][1]
		return self.cities[row][0]
	}
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
		let stringQuery = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22" + String(self.cities[row][0]) + "%2C%20" + String(self.cities[row][1]) + "%22)&format=json&u='c'&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
		let weatherQuery = NSURL(string: stringQuery)
		//let weather = NSData(contentsOfURL: NSURL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22madrid%2C%20es%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys")!)
		let weather = NSData(contentsOfURL: weatherQuery!)
		AudioServicesPlaySystemSound(mySound)
		

		
		do {
			let jsonAnswer = try NSJSONSerialization.JSONObjectWithData(weather!, options: NSJSONReadingOptions.MutableLeaves)
			
			let dictAnswer = jsonAnswer as! NSDictionary
			let dictQuery = dictAnswer["query"] as! NSDictionary
			let dictResults = dictQuery["results"] as! NSDictionary
			let dictChannel = dictResults["channel"] as! NSDictionary
			let dictUnits = dictChannel["units"] as! NSDictionary
			let dictItem = dictChannel["item"] as! NSDictionary
			let dictCondition = dictItem["condition"] as! NSDictionary
			self.cityTemperature.text = String(dictCondition["temp"] as! NSString) + "º" +  String (dictUnits["temperature"] as! NSString) + ", " + String (dictCondition["text"] as! NSString)
		}
		catch _ {
			print ("something happened!")
		}
	}
	
}

