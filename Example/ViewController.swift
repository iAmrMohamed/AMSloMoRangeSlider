//
//  ViewController.swift
//  SloMoRangeSlider
//
//  Created by Amr Mohamed on 7/7/16.
//  Copyright © 2016 Amr Mohamed. All rights reserved.
//

import UIKit
import AVFoundation
import AMSloMoRangeSlider

class ViewController: UIViewController , AMSloMoRangeSliderDelegate {

    @IBOutlet weak var sloMoRangeSlider: AMSloMoRangeSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSBundle.mainBundle().URLForResource("video", withExtension: "mp4")
        self.sloMoRangeSlider.videoAsset = AVAsset(URL: url!)
        self.sloMoRangeSlider.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func slomoRangeSliderLowerThumbValueChanged() {
        print(self.sloMoRangeSlider.startTime.seconds)
    }
    
    func slomoRangeSliderUpperThumbValueChanged() {
        print(self.sloMoRangeSlider.stopTime.seconds)
    }
}