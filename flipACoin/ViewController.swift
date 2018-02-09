//
//  ViewController.swift
//  flipACoin
//
//  Created by Erik Hede on 2018-01-19.
//  Copyright © 2018 Erik Hede. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var coinImageview: UIImageView!

    @IBOutlet weak var coinText: UILabel!
    
    var audioPlayer : AVAudioPlayer!
    
    var coinImages : [UIImage] = []
    
    var motionManager = CMMotionManager()
    
    var randomNumber : Int = 0
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        coinImages = createImageArray(total: 6, imagePrefix: "coin")
        coinImageview.image = coinImages[0]
        coinText.text = "KRONA"
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        leftSwipe.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(leftSwipe)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        motionManager.accelerometerUpdateInterval = 0.2
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            if let myData = data
            {
                
                print(myData)
                if myData.acceleration.z > 0.3
                {
                    print ("Du skakade telefonen")

                    self.setHeadsOrTail()
                }
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func playSound(_ sender: UIButton) {
        
        playCoinSound()
        
        audioPlayer.play()
        
        setHeadsOrTail()
       
    }
    
    
    
    func createImageArray(total: Int, imagePrefix: String) -> [UIImage] {
        
        var imageArray: [UIImage] = []
        
        for imageCount in 1..<total {
            let imageName = "\(imagePrefix)-\(imageCount).png"
            let image = UIImage(named: imageName)!
            
            imageArray.append(image)
        }
        return imageArray
    }
    
    func animate(imageView: UIImageView, images: [UIImage]) {
        imageView.animationImages = images
        imageView.animationDuration = 0.3
        imageView.animationRepeatCount = 3
        imageView.startAnimating()
    }
    
    func setHeadsOrTail() {
        
        randomNumber = Int(arc4random_uniform(2))
        
        animate(imageView: coinImageview, images: coinImages)
        
        _ = Timer.scheduledTimer(withTimeInterval: 0.9, repeats: false) { (timer) in
            
            if self.randomNumber == 0 {
                if self.coinText.text == "KRONA" {
                    self.coinText.text = "KLAVE"
                    
                    print(self.randomNumber)
                }
            } else {
                self.coinText.text = "KRONA"
                
                print(self.randomNumber)
            }
        }
        
        print(randomNumber)
    }
    
    func playCoinSound() {
        
        let soundURL = Bundle.main.url(forResource: "coinflip", withExtension: "wav")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
        }
        catch {
            print(error)
        }
        
        audioPlayer.play()
    }
    
    @objc func swipeAction(swipe:UISwipeGestureRecognizer) {
        performSegue(withIdentifier: "goRight", sender: self)
    }
    
}

