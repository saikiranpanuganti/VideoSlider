//
//  Model.swift
//  VideoSlider
//
//  Created by SaiKiran Panuganti on 16/05/21.
//

import Foundation
import UIKit

public protocol SliderDelegate: AnyObject {
    func valueChanges(value: CGFloat)
}

public class Slider: UIControl {
    public weak var delegate: SliderDelegate?
    
    private var fullTrack : UIView!
    private var currentTrack: UIView!
    private var bufferTrack: UIView!
    private var thumbImage: UIImageView!
    
    public var sliderAlignment: SliderAlignment = .center
    public var minimumValue: CGFloat = 0
    public var maximumValue: CGFloat = 1
    public var trackHeight: CGFloat = 4
    public var thumbHeight: CGFloat = 16
    private var frameWidth: CGFloat = 0
    private var frameHeight: CGFloat = 0
    private var thumbTrackWidth: CGFloat = 0
    private var valueConvertion: CGFloat = 0
    private var pointConversion: CGFloat = 0
    private var handleTouch: Bool = false
    private var setUpDone: Bool = false
    private var handleValueChange: Bool = true
    private var bufferCurrentPosition: CGFloat = 0
    private var currentPosition: CGFloat = 0
    private var bufferTrackPostion: CGFloat {
        return bufferValue*valueConvertion
    }
    private var thumbInitialCurrentPosition: CGFloat {
        if value*valueConvertion > thumbTrackWidth {
            return thumbTrackWidth
        }
        return value*valueConvertion
    }
    private var bufferInitialCurrentPosition: CGFloat {
        return bufferValue*valueConvertion
    }
    public var value: CGFloat = 0.4 {
        didSet {
            if setUpDone {
                currentPosition = value*valueConvertion
                if currentPosition > thumbTrackWidth {
                    currentPosition = thumbTrackWidth
                }
                updateFramesFromValue()
            }
        }
    }
    public var bufferValue: CGFloat = 0 {
        didSet {
            if setUpDone {
                bufferCurrentPosition = bufferValue*valueConvertion
                updateBufferFrame()
            }
        }
    }
    private var trackY: CGFloat {
        switch sliderAlignment {
        case .top:
            return (thumbHeight - trackHeight)/2
        case .bottom:
            return frameHeight - (thumbHeight + trackHeight)/2
        default:
            return (frameHeight - trackHeight)/2
        }
    }
    private var thumbY: CGFloat {
        switch sliderAlignment {
        case .top:
            return 0
        case .bottom:
            return frameHeight - thumbHeight
        default:
            return (frameHeight - thumbHeight)/2
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        frameWidth = frame.width
        frameHeight = frame.height
        setUpUI()
    }
    
    func computeValues() {
        thumbTrackWidth = frameWidth-thumbHeight
        valueConvertion = frameWidth/(maximumValue-minimumValue)
        pointConversion = (maximumValue-minimumValue)/frameWidth
    }
    
    func setUpUI() {
        self.backgroundColor = UIColor.red
        addViews()
    }
    
    func addViews() {
        computeValues()
        fullTrack = UIView(frame: CGRect(x: 0, y: trackY, width: self.frame.width, height: trackHeight))
        self.addSubview(fullTrack)
        
        bufferTrack = UIView(frame: CGRect(x: 0, y: trackY, width: bufferInitialCurrentPosition, height: trackHeight))
        currentTrack = UIView(frame: CGRect(x: 0, y: trackY, width: thumbInitialCurrentPosition, height: trackHeight))
        thumbImage = UIImageView(frame: CGRect(x: thumbInitialCurrentPosition, y: thumbY, width: thumbHeight, height: thumbHeight))
        
        fullTrack.backgroundColor = UIColor.green
        bufferTrack.backgroundColor = UIColor.darkGray
        currentTrack.backgroundColor = UIColor.blue
        thumbImage.backgroundColor = UIColor.red
        thumbImage.layer.cornerRadius = trackHeight*2
        
        self.addSubview(bufferTrack)
        self.addSubview(currentTrack)
        self.addSubview(thumbImage)
        
        addTapGestureRecogniser()
        setUpDone = true
    }
    
    func addTapGestureRecogniser() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImageView(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func updateFrames() {
        if handleTouch {
            UIView.animateKeyframes(withDuration: 0, delay: 0, options: []) { [weak self] in
                guard let self = self else { return }
                self.thumbImage.frame.origin.x = self.currentPosition
                self.currentTrack.frame.size.width = self.currentPosition
            }
        }
    }
    
    func updateFramesFromValue() {
        if handleValueChange {
            UIView.animateKeyframes(withDuration: 0, delay: 0, options: []) { [weak self] in
                self?.thumbImage.frame.origin.x = self?.currentPosition ?? 0
                self?.currentTrack.frame.size.width = self?.currentPosition ?? 0
            }
        }
    }
    
    func updateBufferFrame() {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: []) { [weak self] in
            guard let self = self else { return }
            self.bufferTrack.frame.size.width = self.bufferCurrentPosition
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleValueChange = false
        let touch = touches.first
        let point = touch!.location(in: thumbImage)
        
        if point.x < thumbHeight && point.x > -thumbHeight {
            handleTouch = true
        }else {
            handleTouch = false
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let point = touch!.location(in: self)
        
        if point.x > 0 && point.x < (self.frame.width - thumbHeight) {
            currentPosition = point.x
        }else if point.x <= 0 {
            currentPosition = 0
        }else if point.x >= (self.frame.width - thumbHeight){
            currentPosition = self.frame.width - thumbHeight
        }
        
        updateFrames()
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let point = touch!.location(in: self)
        
        if point.x <= 0 {
            currentPosition = 0
        }else if point.x >= (self.frame.width - thumbHeight) {
            currentPosition = frameWidth - thumbHeight
        }
        
        updateFrames()
        
        value = currentPosition*pointConversion
        handleTouch = false
        handleValueChange = true
        delegate?.valueChanges(value: value)
    }
    
    @IBAction func didTapImageView(_ sender: UITapGestureRecognizer) {
        print("did tap image view", sender)
    }
}
