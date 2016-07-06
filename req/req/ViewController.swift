//
//  ViewController.swift
//  req
//
//  Created by José-María Súnico on 20160622.
//  Copyright © 2016 José-María Súnico. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	func syncomm(){
		let urls = "http://dia.ccm.itesm.mx"
		let url = NSURL(string: urls)
		let datas : NSData? = NSData(contentsOfURL : url!)
		let text = NSString(data : datas!, encoding: NSUTF8StringEncoding)
		print("hi")
		print(text!)
	}
	
	func asyncomm(){
		let urls = "http://dia.ccm.itesm.mx"
		let url = NSURL(string: urls)
		let session = NSURLSession.sharedSession()
		let block = { (datas: NSData?, answer : NSURLResponse?, error : NSError?) -> Void in let text = NSString(data: datas!, encoding: NSUTF8StringEncoding)
			print(text)
		}
		
		let dt = session.dataTaskWithURL(url!, completionHandler: block)
		dt.resume()
		print ("before or after2")
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		asyncomm()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

