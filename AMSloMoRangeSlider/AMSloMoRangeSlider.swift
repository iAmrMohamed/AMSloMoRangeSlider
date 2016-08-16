//
//  AMSloMoRangeSlider.swift
//  AVFPlayer
//
//  Created by Amr Mohamed on 4/20/16.
//  Copyright © 2016 Amr Mohamed. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


import UIKit
import QuartzCore
import AVFoundation

internal class AMSloMoRangeSliderThumbLayer: CAShapeLayer {
    var highlighted = false
    weak var rangeSlider : AMSloMoRangeSlider?
    
    override func layoutSublayers() {
        super.layoutSublayers()
        self.cornerRadius = self.frame.width/2
        self.setNeedsDisplay()
    }
    
    override func drawInContext(ctx: CGContext) {
        CGContextMoveToPoint(ctx, self.bounds.width/2, self.bounds.height/5)
        CGContextAddLineToPoint(ctx, self.bounds.width/2 , self.bounds.height - self.bounds.height/5)
        
        CGContextSetStrokeColorWithColor(ctx, UIColor.whiteColor().CGColor)
        CGContextStrokePath(ctx)
    }
}

public class AMSloMoRangeSliderTrackLayer: CALayer {
    
    var offSet = CGFloat(10)
    var lineColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.00)
    
    override public func drawInContext(ctx: CGContext) {
        
        let numberOfPoints = Int(self.bounds.width / self.offSet)
        var initialPoint = CGPointMake(0, 0)
        for _ in 0...numberOfPoints {
            CGContextMoveToPoint(ctx, initialPoint.x, initialPoint.y)
            CGContextAddLineToPoint(ctx, initialPoint.x, initialPoint.y+self.bounds.height)
            
            initialPoint.x += self.offSet
        }
        
        CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor)
        CGContextStrokePath(ctx)
        
    }
}

public protocol AMSloMoRangeSliderDelegate {
    func slomoRangeSliderLowerThumbValueChanged()
    func slomoRangeSliderUpperThumbValueChanged()
}

public class AMSloMoRangeSlider: UIControl {
    
    public var minimumValue: Double = 0.0 {
        didSet {
            self.updateLayerFrames()
        }
    }
    
    public var maximumValue: Double = 1.0 {
        didSet {
            self.updateLayerFrames()
        }
    }
    
    public var lowerValue: Double = 0.1 {
        didSet {
            self.updateLayerFrames()
        }
    }
    
    public var upperValue: Double = 0.9 {
        didSet {
            self.updateLayerFrames()
        }
    }
    
    public var videoAsset : AVAsset!
    
    public  var startTime : CMTime {
        return CMTimeMakeWithSeconds(self.videoAsset.duration.seconds * self.lowerValue, self.videoAsset.duration.timescale)
    }
    
    public var stopTime : CMTime {
        return CMTimeMakeWithSeconds(self.videoAsset.duration.seconds * self.upperValue, self.videoAsset.duration.timescale)
    }
    
    public var rangeTime : CMTimeRange {
        let lower = self.videoAsset.duration.seconds * self.lowerValue
        let upper = self.videoAsset.duration.seconds * self.upperValue
        let duration = CMTimeMakeWithSeconds(upper - lower, self.videoAsset.duration.timescale)
        return CMTimeRangeMake(self.startTime, duration)
    }
    
    public var sliderThumbColor = UIColor(red:0.97, green:0.71, blue:0.19, alpha:1.00) {
        didSet {
            self.lowerThumbLayer.backgroundColor = self.sliderThumbColor.CGColor
            self.upperThumbLayer.backgroundColor = self.sliderThumbColor.CGColor
        }
    }
    
    public var sliderMiddleLinesColor : UIColor! {
        didSet {
            self.middleTrackLayer.lineColor = self.sliderMiddleLinesColor
        }
    }
    
    public var sliderLowerAndUpperLinesColor : UIColor! {
        didSet {
            self.backgroundTrackLayer.lineColor = self.sliderLowerAndUpperLinesColor
        }
    }
    
    public var delegate : AMSloMoRangeSliderDelegate?
    
    var lowerThumbLayer = AMSloMoRangeSliderThumbLayer()
    var upperThumbLayer = AMSloMoRangeSliderThumbLayer()
    
    var middleTrackLayer = AMSloMoRangeSliderTrackLayer()
    var backgroundTrackLayer = AMSloMoRangeSliderTrackLayer()
    
    var previousLocation = CGPoint()
    
    var thumbWidth : CGFloat {
        return 10
    }
    
    var thumpHeight : CGFloat {
        return self.bounds.height + 15
    }
    
    public override var frame: CGRect {
        didSet {
            self.updateLayerFrames()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required public init(coder : NSCoder) {
        super.init(coder: coder)!
        self.commonInit()
    }
    
    public override func layoutSubviews() {
        self.updateLayerFrames()
    }
    
    func commonInit() {
        self.lowerThumbLayer.rangeSlider = self
        self.upperThumbLayer.rangeSlider = self
        
        self.layer.addSublayer(self.backgroundTrackLayer)
        self.layer.addSublayer(self.middleTrackLayer)
        self.layer.addSublayer(self.lowerThumbLayer)
        self.layer.addSublayer(self.upperThumbLayer)
        
        self.lowerThumbLayer.backgroundColor = self.sliderThumbColor.CGColor
        self.upperThumbLayer.backgroundColor = self.sliderThumbColor.CGColor
        
        self.backgroundTrackLayer.offSet = 5
        self.middleTrackLayer.backgroundColor = UIColor.whiteColor().CGColor
        
        self.backgroundTrackLayer.contentsScale = UIScreen.mainScreen().scale
        self.middleTrackLayer.contentsScale = UIScreen.mainScreen().scale
        self.lowerThumbLayer.contentsScale = UIScreen.mainScreen().scale
        self.upperThumbLayer.contentsScale = UIScreen.mainScreen().scale
        
        self.updateLayerFrames()
    }
    
    func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        self.backgroundTrackLayer.frame = self.bounds
        self.backgroundTrackLayer.setNeedsDisplay()
        
        let lowerValuePosition = CGFloat(self.positionForValue(self.lowerValue))
        let upperValuePosition = CGFloat(self.positionForValue(self.upperValue))
        let layerRect = CGRect(x: lowerValuePosition, y: 0.0, width: upperValuePosition - lowerValuePosition, height: bounds.height)
        
        self.middleTrackLayer.frame = layerRect
        self.middleTrackLayer.setNeedsDisplay()
        
        let lowerThumbCenter = CGFloat(self.positionForValue(self.lowerValue))
        self.lowerThumbLayer.frame = CGRect(x: lowerThumbCenter - self.thumbWidth / 2, y: -(self.thumpHeight-self.frame.height)/2, width: self.thumbWidth, height: self.thumpHeight)
        
        let upperThumbCenter = CGFloat(self.positionForValue(self.upperValue))
        self.upperThumbLayer.frame = CGRect(x: upperThumbCenter - self.thumbWidth / 2, y: -(self.thumpHeight-self.frame.height)/2, width: self.thumbWidth, height: self.thumpHeight)
        
        CATransaction.commit()
    }
    
    func positionForValue(value: Double) -> Double {
        return Double(self.bounds.width - self.thumbWidth) * (value - self.minimumValue) / (self.maximumValue - self.minimumValue) + Double(self.thumbWidth / 2.0)
    }
    
    public override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        self.previousLocation = touch.locationInView(self)
        
        if self.lowerThumbLayer.frame.contains(self.previousLocation) {
            self.lowerThumbLayer.highlighted = true
        } else if self.upperThumbLayer.frame.contains(self.previousLocation) {
            self.upperThumbLayer.highlighted = true
        }
        
        return self.lowerThumbLayer.highlighted || self.upperThumbLayer.highlighted
    }
    
    func boundValue(value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }
    
    public override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let location = touch.locationInView(self)
        
        let deltaLocation = Double(location.x - self.previousLocation.x)
        let deltaValue = (self.maximumValue - self.minimumValue) * deltaLocation / Double(self.bounds.width - self.thumbWidth)
        
        self.previousLocation = location
        
        if self.lowerThumbLayer.highlighted {
            if deltaValue > 0 && self.rangeTime.duration.seconds <= 0.5 && self.upperValue > 0.0 {
                
            } else {
                self.lowerValue += deltaValue
                self.lowerValue = self.boundValue(self.lowerValue, toLowerValue: self.minimumValue, upperValue: self.maximumValue)
                self.delegate?.slomoRangeSliderLowerThumbValueChanged()
            }
        } else if self.upperThumbLayer.highlighted {
            if deltaValue < 0 && self.rangeTime.duration.seconds <= 0.5 && self.lowerValue < 1.0 {
                
            } else {
                self.upperValue += deltaValue
                self.upperValue = self.boundValue(self.upperValue, toLowerValue: self.minimumValue, upperValue: self.maximumValue)
                self.delegate?.slomoRangeSliderUpperThumbValueChanged()
            }
        }
        
        self.sendActionsForControlEvents(.ValueChanged)
        return true
    }
    
    public override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        if self.lowerThumbLayer.highlighted {
            self.lowerThumbLayer.highlighted = false
        }
        if self.upperThumbLayer.highlighted {
            self.upperThumbLayer.highlighted = false
        }
    }
}
