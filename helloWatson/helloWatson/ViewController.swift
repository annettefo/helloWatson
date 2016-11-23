//
//  ViewController.swift
//  helloWatson
//
//  Created by Annette Fontanilla on 11/22/16.
//  Copyright © 2016 Annette Fontanilla. All rights reserved.
//

import UIKit
import VisualRecognitionV3
import AlamofireImage
import Social

class ViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    let apiKey = ""
    let version = "2016-11-22"
    var test = "Picture Here"

    
    @IBAction func TweetAction(_ sender: Any) {
        
        //tweet sheet
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
            
            //tweet controller
            let tweetController = SLComposeViewController(forServiceType:SLServiceTypeTwitter)
            
            tweetController?.setInitialText("Share this post to twitter - \(test)")
            
            self.present(tweetController!, animated: true, completion:nil)
            //if nothing hooked up
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to your Twitter Account", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil))
            
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.default, handler: {
                (UIAlertAction) in
                
                let settingsURL = NSURL(string:UIApplicationOpenSettingsURLString)
                if let url = settingsURL {
                    UIApplication.shared.openURL(url as URL)
                }
                
            }))
            self.present(alert, animated:true, completion:nil)
        }
    }
    
    @IBAction func getImage(_ sender: Any) {
        // https://unsplash.it/200/300/?random
        //https://unsplash.it/400/700/?random
        
        let button = sender as! UIBarButtonItem
        
        button.isEnabled = false
        
        let randomNum = Int(arc4random_uniform(1000))
        
        let url = URL(string: "https://unsplash.it/400/700/?image=\(randomNum)")!
        //let url = URL(string: "http://zdnet4.cbsistatic.com/hub/i/r/2014/10/04/2777ce93-4bf8-11e4-b6a0-d4ae52e95e57/resize/770xauto/b74c940f88384719c17d2680801f0deb/michaeldojo.png")!

        
        imageView.af_setImage(withURL: url)
        
        let visualRecognition = VisualRecognition(apiKey: apiKey, version: version)
        
        let failure = {(error:Error) in
            DispatchQueue.main.async {
                self.navigationItem.title = "Image could not be IBMWATSONIZED"
                button.isEnabled = true
            }
            
            print (error)

        }
        
        let recogURL = URL(string: "https://unsplash.it/50/100/?image=\(randomNum)")!
        //let recogURL = URL(string: "http://zdnet4.cbsistatic.com/hub/i/r/2014/10/04/2777ce93-4bf8-11e4-b6a0-d4ae52e95e57/resize/770xauto/b74c940f88384719c17d2680801f0deb/michaeldojo.png")!

        visualRecognition.classify(image:recogURL.absoluteString, failure: failure) { ClassifiedImages in
            if let classifiedImage = ClassifiedImages.images.first {
                print("IMAGE INFORMATION",classifiedImage.classifiers)
                if let classification = classifiedImage.classifiers.first?.classes.first?.classification {
                    DispatchQueue.main.async {
                        self.navigationItem.title = classification
                        button.isEnabled = true
                    }
                }
                
            } else {
                DispatchQueue.main.async {
                    self.navigationItem.title = "Could not be determined"
                    button.isEnabled = true
                }
            }
    
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

