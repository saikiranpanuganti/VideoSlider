//
//  ViewController.swift
//  VideoSlider
//
//  Created by saikiranpanuganti on 05/16/2021.
//  Copyright (c) 2021 saikiranpanuganti. All rights reserved.
//

import UIKit
import VideoSlider

class ViewController: UIViewController {
    var randomNumber : Int = 0
    var slider : Slider = Slider(frame: .zero)
    var slider1 : Slider = Slider(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        slider = Slider(frame: CGRect(x: 40, y: 50, width: self.view.frame.width-80, height: 50))
        slider.backgroundColor = UIColor.systemPurple
        slider.sliderAlignment = .top
        slider.value = 15
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.delegate = self
        
        self.view.addSubview(slider)
        
        slider1 = Slider(frame: CGRect(x: 40, y: self.view.frame.height-90, width: self.view.frame.width-80, height: 50))
        slider1.backgroundColor = UIColor.systemPurple
        slider1.sliderAlignment = .bottom
        slider1.value = 15
        slider1.minimumValue = 0
        slider1.maximumValue = 100
        
        self.view.addSubview(slider1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            self?.randomNumber += 1
            self?.slider.value = (self?.slider.value ?? 0) + 1
            self?.slider1.value = (self?.slider1.value ?? 0) + 1
            
            if self?.randomNumber == 180 {
                timer.invalidate()
            }
            
            if self?.randomNumber == 10 {
                self?.slider.bufferValue = 45
                self?.slider1.bufferValue = 45
            }else if self?.randomNumber == 15 {
                self?.slider.bufferValue = 55
                self?.slider1.bufferValue = 55
            }else if self?.randomNumber == 20 {
                self?.slider.bufferValue = 70
                self?.slider1.bufferValue = 70
            }else if self?.randomNumber == 25 {
                self?.slider.bufferValue = 85
                self?.slider1.bufferValue = 85
            }
        }
        
    }
}

extension ViewController : SliderDelegate {
    func valueChanges(value: CGFloat) {
        print("Value is: ", value)
    }
}

