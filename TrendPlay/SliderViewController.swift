//
//  SliderViewController.swift
//  TrendPlay
// 
//  Created by Chelsea Smith on 9/2/17.
//  Copyright © 2017 Trending Productions LLC. All rights reserved.
//

import UIKit
import Eureka
import MaterialComponents
import SwiftRangeSlider
import Floaty
 
extension String {
    func indexDistance(of character: Character) -> Int? {
        guard let index = index(of: character) else { return nil }
        return distance(from: startIndex, to: index)
    }
}

extension UILabel {
    func addTextSpacing(spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: self.text!)
        attributedString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: self.text!.count))
        self.attributedText = attributedString
    }
}


class SliderViewController: FormViewController, FloatyDelegate {
    @IBOutlet weak var rangeSliderObject: CustomRangeSlider!
    @IBOutlet weak var buttonView: UIButton!
    let doneButtonImage = UIImage(named: "doneEmpty")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    var headerLabel: String = ""
    var sliderValues = [Float(0), Float(1), Float(2), Float(3), Float(4), Float(5)]
    var buttonText: String = ""
    var buttonTextMutableString = NSMutableAttributedString()
    let char: Character = "\0"
    let spacing = CGFloat(-0.2)
    var queryEnglishString: String = ""
    var rangeBoolean: Bool = false
    let frameX: Float = 23.0
    let sliderFrameHeightRatio: Float = Float(35.0/screenHeight) //Float(35.0/667.0)
    let rangeSliderFrameHeightRatio: Float = Float(130.0/screenHeight) //Float(screenHeight * 0.1874) //Float(125.0/667.0)
    let sliderFrameWidthRatio: Float = Float(329.0/screenWidth) //Float(329.0/375.0)
    let rangeSliderFrameWidthRatio: Float = Float(327.0/screenWidth) //Float(327.0/375.0)
    let frameHeight: Float = 31.0

    var rangeSliderObjectMinimumValue: Double = -10000
    var rangeSliderObjectMaximumValue: Double = -10000
    var team1ButtonLabel: String = ""
    var team2ButtonLabel: String = ""
    var operatorDictionary = ["-10000" : " EQUAL ",
                              "=" : " EQUAL ",
                              "≠" : " DO NOT EQUAL ",
                              "<" : " EQUAL FEWER THAN ",
                              ">" : " EQUAL MORE THAN ",
                              "< >" : " EQUAL BETWEEN "]
    var messageString: String = ""
    var titleString: String = ""
    var alertController = MDCAlertController()
    var raisedButton = MDCRaisedButton()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SliderVC Loaded")
        let floatActionButton = Floaty()
        let floatyItem = FloatyItem()
        NotificationCenter.default.addObserver(self, selector: #selector(SliderViewController.reloadRowValue), name: NSNotification.Name(rawValue: "sliderControllerNotification"), object: nil)
        var operatorsArray: Array<Any>
        let action = MDCAlertAction(title:"OK") { (action) in print("OK") }
        alertController = MDCAlertController(title: titleString, message: messageString)
        alertController.addAction(action)
        alertController.buttonTitleColor = orangeColor
        alertController.buttonFont = fifteenBlackRoboto
        alertController.view.backgroundColor = lightGreyColor.withAlphaComponent(0.8)
        alertController.titleFont = sixteenBoldRobotoCondensed
        alertController.messageFont = fifteenRegularRobotoCondensed
        alertController.titleColor = darkGreyColor
        alertController.messageColor = dashboardGreyColor
    
        raisedButton.setElevation(ShadowElevation(rawValue: 2), for: .normal)
        raisedButton.setTitleColor(silverColor, for: .normal)
        raisedButton.setTitleColor(silverColor, for: .selected)
        raisedButton.addTarget(self, action: #selector(SliderViewController.labelTapped), for: .touchUpInside)
        buttonView = raisedButton
        let editButtonImage = UIImage(named: "edit")?.withRenderingMode(
            UIImageRenderingMode.alwaysTemplate)
        let resetItemImage = UIImage(named: "reset")?.withRenderingMode(
            UIImageRenderingMode.alwaysTemplate)
        floatActionButton.buttonImage = editButtonImage
        floatActionButton.buttonColor = lightMediumGreyColor.withAlphaComponent(0.85)
        floatActionButton.openAnimationType = .slideLeft
        floatActionButton.overlayColor = dashboardGreyColor.withAlphaComponent(0.75)
        floatyItem.title = "RESET SELECTION"
        floatyItem.titleColor = lightGreyColor
        floatyItem.titleLabel.font = thirteenBlackRoboto
        floatyItem.titleLabel.textAlignment = .right
        floatyItem.buttonColor = lightMediumGreyColor
        floatyItem.tintColor = lightGreyColor
        floatyItem.size = CGFloat(52)
        floatyItem.frame = CGRect(x: 0, y: 0, width: 52, height: 52)
        floatyItem.imageSize = CGSize(width: 35, height: 35)
        floatyItem.icon = resetItemImage
        let deleteHandler: (FloatyItem) -> Void = { item in
            self.clearSliderSelections()
        }
        floatyItem.handler = deleteHandler
        floatActionButton.friendlyTap = true
        floatActionButton.addItem(item: floatyItem)
        self.view.addSubview(floatActionButton)
        
        switch (tagText) {
        case "TEAM: STREAK":
            self.operatorDictionary = ["-10000" : " IS ",
                                  "=" : " IS ",
                                  "≠" : " IS NOT ",
                                  "<" : " IS WORSE THAN ",
                                  ">" : " IS BETTER THAN ",
                                  "< >" : " IS BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team1ListValue == ["-10000"] || team1ListValue == [] {
                headerLabel = tagText
            } else {
                if team1ListValue[0] == "NEW YORK GIANTS" {
                    team1ButtonLabel = "NEW YORK (G)"
                } else if team1ListValue[0] == "NEW YORK JETS" {
                    team1ButtonLabel = "NEW YORK (J)"
                } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabel = "LOS ANGELES (C)"
                } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabel = team1ListValue[0]
                    var team1TextArray = team1ButtonLabel.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabel = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = winningLosingStreakTeam1Values
            formSliderValue = winningLosingStreakTeam1SliderValue
            formRangeSliderLowerValue = winningLosingStreakTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = winningLosingStreakTeam1RangeSliderUpperValue
            formOperatorValue = winningLosingStreakTeam1OperatorValue
            formOperatorText = winningLosingStreakTeam1OperatorText
        case "OPPONENT: STREAK":
            self.operatorDictionary = ["-10000" : " IS ",
                                  "=" : " IS ",
                                  "≠" : " IS NOT ",
                                  "<" : " IS WORSE THAN ",
                                  ">" : " IS BETTER THAN ",
                                  "< >" : " IS BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                headerLabel = tagText
            } else {
                if team2ListValue[0] == "NEW YORK GIANTS" {
                    team2ButtonLabel = "NEW YORK (G)"
                } else if team2ListValue[0] == "NEW YORK JETS" {
                    team2ButtonLabel = "NEW YORK (J)"
                } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabel = "LOS ANGELES (C)"
                } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabel = team2ListValue[0]
                    var team2TextArray = team2ButtonLabel.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabel = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = winningLosingStreakTeam2Values
            formSliderValue = winningLosingStreakTeam2SliderValue
            formRangeSliderLowerValue = winningLosingStreakTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = winningLosingStreakTeam2RangeSliderUpperValue
            formOperatorValue = winningLosingStreakTeam2OperatorValue
            formOperatorText = winningLosingStreakTeam2OperatorText
        case "TEAM: SEASON WIN %":
            self.operatorDictionary = ["-10000" : " IS ",
                                  "=" : " IS ",
                                  "≠" : " IS NOT ",
                                  "<" : " IS LOWER THAN ",
                                  ">" : " IS HIGHER THAN ",
                                  "< >" : " IS BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team1ListValue == ["-10000"] || team1ListValue == [] {
                headerLabel = tagText
            } else {
                if team1ListValue[0] == "NEW YORK GIANTS" {
                    team1ButtonLabel = "NEW YORK (G)"
                } else if team1ListValue[0] == "NEW YORK JETS" {
                    team1ButtonLabel = "NEW YORK (J)"
                } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabel = "LOS ANGELES (C)"
                } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabel = team1ListValue[0]
                    var team1TextArray = team1ButtonLabel.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabel = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = seasonWinPercentageTeam1Values
            formSliderValue = seasonWinPercentageTeam1SliderValue
            formRangeSliderLowerValue = seasonWinPercentageTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = seasonWinPercentageTeam1RangeSliderUpperValue
            formOperatorValue = seasonWinPercentageTeam1OperatorValue
            formOperatorText = seasonWinPercentageTeam1OperatorText
        case "OPPONENT: SEASON WIN %":
            self.operatorDictionary = ["-10000" : " IS ",
                                  "=" : " IS ",
                                  "≠" : " IS NOT ",
                                  "<" : " IS LOWER THAN ",
                                  ">" : " IS HIGHER THAN ",
                                  "< >" : " IS BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                headerLabel = tagText
            } else {
                if team2ListValue[0] == "NEW YORK GIANTS" {
                    team2ButtonLabel = "NEW YORK (G)"
                } else if team2ListValue[0] == "NEW YORK JETS" {
                    team2ButtonLabel = "NEW YORK (J)"
                } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabel = "LOS ANGELES (C)"
                } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabel = team2ListValue[0]
                    var team2TextArray = team2ButtonLabel.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabel = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = seasonWinPercentageTeam2Values
            formSliderValue = seasonWinPercentageTeam2SliderValue
            formRangeSliderLowerValue = seasonWinPercentageTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = seasonWinPercentageTeam2RangeSliderUpperValue
            formOperatorValue = seasonWinPercentageTeam2OperatorValue
            formOperatorText = seasonWinPercentageTeam2OperatorText
        case "SEASON":
            self.operatorDictionary = ["-10000" : " IS ",
                                  "=" : " IS ",
                                  "≠" : " IS NOT ",
                                  "<" : " IS BEFORE ",
                                  ">" : " IS AFTER ",
                                  "< >" : " IS BETWEEN "]
            headerLabel = tagText
            operatorsArray = allOperators
            sliderValues = seasonValues
            formSliderValue = seasonSliderValue
            formRangeSliderLowerValue = seasonRangeSliderLowerValue
            formRangeSliderUpperValue = seasonRangeSliderUpperValue
            formOperatorValue = seasonOperatorValue
            formOperatorText = seasonOperatorText
        case "WEEK":
            self.operatorDictionary = ["-10000" : " IS ",
                                       "=" : " IS ",
                                       "≠" : " IS NOT ",
                                       "<" : " IS BEFORE ",
                                       ">" : " IS AFTER ",
                                       "< >" : " IS BETWEEN "]
            headerLabel = tagText
            operatorsArray = allOperators
            sliderValues = weekValues
            formSliderValue = weekSliderValue
            formRangeSliderLowerValue = weekRangeSliderLowerValue
            formRangeSliderUpperValue = weekRangeSliderUpperValue
            formOperatorValue = weekOperatorValue
            formOperatorText = weekOperatorText
        case "GAME NUMBER":
            self.operatorDictionary = ["-10000" : " IS ",
                                       "=" : " IS ",
                                       "≠" : " IS NOT ",
                                       "<" : " IS BEFORE ",
                                       ">" : " IS AFTER ",
                                       "< >" : " IS BETWEEN "]
            headerLabel = tagText
            operatorsArray = allOperators
            sliderValues = gameNumberValues
            formSliderValue = gameNumberSliderValue
            formRangeSliderLowerValue = gameNumberRangeSliderLowerValue
            formRangeSliderUpperValue = gameNumberRangeSliderUpperValue
            formOperatorValue = gameNumberOperatorValue
            formOperatorText = gameNumberOperatorText
        case "TEAM: SPREAD":
            self.operatorDictionary = ["-10000" : " IS ",
                                       "=" : " IS ",
                                       "≠" : " IS NOT ",
                                       "<" : " IS BETTER THAN ",
                                       ">" : " IS WORSE THAN ",
                                       "< >" : " IS BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team1ListValue == ["-10000"] || team1ListValue == [] {
                headerLabel = tagText
            } else {
                if team1ListValue[0] == "NEW YORK GIANTS" {
                    team1ButtonLabel = "NEW YORK (G)"
                } else if team1ListValue[0] == "NEW YORK JETS" {
                    team1ButtonLabel = "NEW YORK (J)"
                } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabel = "LOS ANGELES (C)"
                } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabel = team1ListValue[0]
                    var team1TextArray = team1ButtonLabel.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabel = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = spreadValues
            formSliderValue = spreadSliderValue
            formRangeSliderLowerValue = spreadRangeSliderLowerValue
            formRangeSliderUpperValue = spreadRangeSliderUpperValue
            formOperatorValue = spreadOperatorValue
            formOperatorText = spreadOperatorText
        case "OVER/UNDER":
            self.operatorDictionary = ["-10000" : " IS ",
                                       "=" : " IS ",
                                       "≠" : " IS NOT ",
                                       "<" : " IS LESS THAN ",
                                       ">" : " IS MORE THAN ",
                                       "< >" : " IS BETWEEN "]
            headerLabel = tagText
            operatorsArray = allOperators
            sliderValues = overUnderValues
            formSliderValue = overUnderSliderValue
            formRangeSliderLowerValue = overUnderRangeSliderLowerValue
            formRangeSliderUpperValue = overUnderRangeSliderUpperValue
            formOperatorValue = overUnderOperatorValue
            formOperatorText = overUnderOperatorText
        case "TEMPERATURE (F)":
            self.operatorDictionary = ["-10000" : " IS ",
                                  "=" : " IS ",
                                  "≠" : " IS NOT ",
                                  "<" : " IS LOWER THAN ",
                                  ">" : " IS HIGHER THAN ",
                                  "< >" : " IS BETWEEN "]
            headerLabel = tagText
            operatorsArray = allOperators
            sliderValues = temperatureValues
            formSliderValue = temperatureSliderValue
            formRangeSliderLowerValue = temperatureRangeSliderLowerValue
            formRangeSliderUpperValue = temperatureRangeSliderUpperValue
            formOperatorValue = temperatureOperatorValue
            formOperatorText = temperatureOperatorText
        case "TEAM: TOTAL POINTS":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team1ListValue == ["-10000"] || team1ListValue == [] {
                headerLabel = tagText
            } else {
                if team1ListValue[0] == "NEW YORK GIANTS" {
                    team1ButtonLabel = "NEW YORK (G)"
                } else if team1ListValue[0] == "NEW YORK JETS" {
                    team1ButtonLabel = "NEW YORK (J)"
                } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabel = "LOS ANGELES (C)"
                } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabel = team1ListValue[0]
                    var team1TextArray = team1ButtonLabel.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabel = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = totalPointsTeam1Values
            formSliderValue = totalPointsTeam1SliderValue
            formRangeSliderLowerValue = totalPointsTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = totalPointsTeam1RangeSliderUpperValue
            formOperatorValue = totalPointsTeam1OperatorValue
            formOperatorText = totalPointsTeam1OperatorText
        case "OPPONENT: TOTAL POINTS":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                headerLabel = tagText
            } else {
                if team2ListValue[0] == "NEW YORK GIANTS" {
                    team2ButtonLabel = "NEW YORK (G)"
                } else if team2ListValue[0] == "NEW YORK JETS" {
                    team2ButtonLabel = "NEW YORK (J)"
                } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabel = "LOS ANGELES (C)"
                } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabel = team2ListValue[0]
                    var team2TextArray = team2ButtonLabel.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabel = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = totalPointsTeam2Values
            formSliderValue = totalPointsTeam2SliderValue
            formRangeSliderLowerValue = totalPointsTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = totalPointsTeam2RangeSliderUpperValue
            formOperatorValue = totalPointsTeam2OperatorValue
            formOperatorText = totalPointsTeam2OperatorText
        case "TEAM: TOUCHDOWNS":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team1ListValue == ["-10000"] || team1ListValue == [] {
                headerLabel = tagText
            } else {
                if team1ListValue[0] == "NEW YORK GIANTS" {
                    team1ButtonLabel = "NEW YORK (G)"
                } else if team1ListValue[0] == "NEW YORK JETS" {
                    team1ButtonLabel = "NEW YORK (J)"
                } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabel = "LOS ANGELES (C)"
                } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabel = team1ListValue[0]
                    var team1TextArray = team1ButtonLabel.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabel = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = touchdownsTeam1Values
            formSliderValue = touchdownsTeam1SliderValue
            formRangeSliderLowerValue = touchdownsTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = touchdownsTeam1RangeSliderUpperValue
            formOperatorValue = touchdownsTeam1OperatorValue
            formOperatorText = touchdownsTeam1OperatorText
            
            
            
        case "TEAM: OFFENSIVE TOUCHDOWNS":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                       "=" : " EQUAL ",
                                       "≠" : " DO NOT EQUAL ",
                                       "<" : " EQUAL FEWER THAN ",
                                       ">" : " EQUAL MORE THAN ",
                                       "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team1ListValue == ["-10000"] || team1ListValue == [] {
                headerLabel = tagText
            } else {
                if team1ListValue[0] == "NEW YORK GIANTS" {
                    team1ButtonLabel = "NEW YORK (G)"
                } else if team1ListValue[0] == "NEW YORK JETS" {
                    team1ButtonLabel = "NEW YORK (J)"
                } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabel = "LOS ANGELES (C)"
                } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabel = team1ListValue[0]
                    var team1TextArray = team1ButtonLabel.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabel = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = offensiveTouchdownsTeam1Values
            formSliderValue = offensiveTouchdownsTeam1SliderValue
            formRangeSliderLowerValue = offensiveTouchdownsTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = offensiveTouchdownsTeam1RangeSliderUpperValue
            formOperatorValue = offensiveTouchdownsTeam1OperatorValue
            formOperatorText = offensiveTouchdownsTeam1OperatorText
            
        case "OPPONENT: OFFENSIVE TOUCHDOWNS":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                       "=" : " EQUAL ",
                                       "≠" : " DO NOT EQUAL ",
                                       "<" : " EQUAL FEWER THAN ",
                                       ">" : " EQUAL MORE THAN ",
                                       "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team2ListValue == ["-10000"] || team2ListValue == [] {
                headerLabel = tagText
            } else {
                if team2ListValue[0] == "NEW YORK GIANTS" {
                    team2ButtonLabel = "NEW YORK (G)"
                } else if team2ListValue[0] == "NEW YORK JETS" {
                    team2ButtonLabel = "NEW YORK (J)"
                } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabel = "LOS ANGELES (C)"
                } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabel = team2ListValue[0]
                    var team2TextArray = team2ButtonLabel.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabel = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = offensiveTouchdownsTeam2Values
            formSliderValue = offensiveTouchdownsTeam2SliderValue
            formRangeSliderLowerValue = offensiveTouchdownsTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = offensiveTouchdownsTeam2RangeSliderUpperValue
            formOperatorValue = offensiveTouchdownsTeam2OperatorValue
            formOperatorText = offensiveTouchdownsTeam2OperatorText
            
            
            
        case "TEAM: DEFENSIVE TOUCHDOWNS":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                       "=" : " EQUAL ",
                                       "≠" : " DO NOT EQUAL ",
                                       "<" : " EQUAL FEWER THAN ",
                                       ">" : " EQUAL MORE THAN ",
                                       "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team1ListValue == ["-10000"] || team1ListValue == [] {
                headerLabel = tagText
            } else {
                if team1ListValue[0] == "NEW YORK GIANTS" {
                    team1ButtonLabel = "NEW YORK (G)"
                } else if team1ListValue[0] == "NEW YORK JETS" {
                    team1ButtonLabel = "NEW YORK (J)"
                } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabel = "LOS ANGELES (C)"
                } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabel = team1ListValue[0]
                    var team1TextArray = team1ButtonLabel.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabel = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = defensiveTouchdownsTeam1Values
            formSliderValue = defensiveTouchdownsTeam1SliderValue
            formRangeSliderLowerValue = defensiveTouchdownsTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = defensiveTouchdownsTeam1RangeSliderUpperValue
            formOperatorValue = defensiveTouchdownsTeam1OperatorValue
            formOperatorText = defensiveTouchdownsTeam1OperatorText
            
        case "OPPONENT: DEFENSIVE TOUCHDOWNS":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                       "=" : " EQUAL ",
                                       "≠" : " DO NOT EQUAL ",
                                       "<" : " EQUAL FEWER THAN ",
                                       ">" : " EQUAL MORE THAN ",
                                       "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team2ListValue == ["-10000"] || team2ListValue == [] {
                headerLabel = tagText
            } else {
                if team2ListValue[0] == "NEW YORK GIANTS" {
                    team2ButtonLabel = "NEW YORK (G)"
                } else if team2ListValue[0] == "NEW YORK JETS" {
                    team2ButtonLabel = "NEW YORK (J)"
                } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabel = "LOS ANGELES (C)"
                } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabel = team2ListValue[0]
                    var team2TextArray = team2ButtonLabel.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabel = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = defensiveTouchdownsTeam2Values
            formSliderValue = defensiveTouchdownsTeam2SliderValue
            formRangeSliderLowerValue = defensiveTouchdownsTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = defensiveTouchdownsTeam2RangeSliderUpperValue
            formOperatorValue = defensiveTouchdownsTeam2OperatorValue
            formOperatorText = defensiveTouchdownsTeam2OperatorText
            
            
        case "OPPONENT: TOUCHDOWNS":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                headerLabel = tagText
            } else {
                if team2ListValue[0] == "NEW YORK GIANTS" {
                    team2ButtonLabel = "NEW YORK (G)"
                } else if team2ListValue[0] == "NEW YORK JETS" {
                    team2ButtonLabel = "NEW YORK (J)"
                } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabel = "LOS ANGELES (C)"
                } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabel = team2ListValue[0]
                    var team2TextArray = team2ButtonLabel.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabel = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = touchdownsTeam2Values
            formSliderValue = touchdownsTeam2SliderValue
            formRangeSliderLowerValue = touchdownsTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = touchdownsTeam2RangeSliderUpperValue
            formOperatorValue = touchdownsTeam2OperatorValue
            formOperatorText = touchdownsTeam2OperatorText
        case "TEAM: TURNOVERS":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team1ListValue == ["-10000"] || team1ListValue == [] {
                headerLabel = tagText
            } else {
                if team1ListValue[0] == "NEW YORK GIANTS" {
                    team1ButtonLabel = "NEW YORK (G)"
                } else if team1ListValue[0] == "NEW YORK JETS" {
                    team1ButtonLabel = "NEW YORK (J)"
                } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabel = "LOS ANGELES (C)"
                } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabel = team1ListValue[0]
                    var team1TextArray = team1ButtonLabel.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabel = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = turnoversCommittedTeam1Values
            formSliderValue = turnoversCommittedTeam1SliderValue
            formRangeSliderLowerValue = turnoversCommittedTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = turnoversCommittedTeam1RangeSliderUpperValue
            formOperatorValue = turnoversCommittedTeam1OperatorValue
            formOperatorText = turnoversCommittedTeam1OperatorText
        case "OPPONENT: TURNOVERS":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                headerLabel = tagText
            } else {
                if team2ListValue[0] == "NEW YORK GIANTS" {
                    team2ButtonLabel = "NEW YORK (G)"
                } else if team2ListValue[0] == "NEW YORK JETS" {
                    team2ButtonLabel = "NEW YORK (J)"
                } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabel = "LOS ANGELES (C)"
                } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabel = team2ListValue[0]
                    var team2TextArray = team2ButtonLabel.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabel = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = turnoversCommittedTeam2Values
            formSliderValue = turnoversCommittedTeam2SliderValue
            formRangeSliderLowerValue = turnoversCommittedTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = turnoversCommittedTeam2RangeSliderUpperValue
            formOperatorValue = turnoversCommittedTeam2OperatorValue
            formOperatorText = turnoversCommittedTeam2OperatorText
        case "TEAM: PENALTIES":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team1ListValue == ["-10000"] || team1ListValue == [] {
                headerLabel = tagText
            } else {
                if team1ListValue[0] == "NEW YORK GIANTS" {
                    team1ButtonLabel = "NEW YORK (G)"
                } else if team1ListValue[0] == "NEW YORK JETS" {
                    team1ButtonLabel = "NEW YORK (J)"
                } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabel = "LOS ANGELES (C)"
                } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabel = team1ListValue[0]
                    var team1TextArray = team1ButtonLabel.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabel = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = penaltiesCommittedTeam1Values
            formSliderValue = penaltiesCommittedTeam1SliderValue
            formRangeSliderLowerValue = penaltiesCommittedTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = penaltiesCommittedTeam1RangeSliderUpperValue
            formOperatorValue = penaltiesCommittedTeam1OperatorValue
            formOperatorText = penaltiesCommittedTeam1OperatorText
        case "OPPONENT: PENALTIES":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                headerLabel = tagText
            } else {
                if team2ListValue[0] == "NEW YORK GIANTS" {
                    team2ButtonLabel = "NEW YORK (G)"
                } else if team2ListValue[0] == "NEW YORK JETS" {
                    team2ButtonLabel = "NEW YORK (J)"
                } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabel = "LOS ANGELES (C)"
                } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabel = team2ListValue[0]
                    var team2TextArray = team2ButtonLabel.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabel = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = penaltiesCommittedTeam2Values
            formSliderValue = penaltiesCommittedTeam2SliderValue
            formRangeSliderLowerValue = penaltiesCommittedTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = penaltiesCommittedTeam2RangeSliderUpperValue
            formOperatorValue = penaltiesCommittedTeam2OperatorValue
            formOperatorText = penaltiesCommittedTeam2OperatorText
        case "TEAM: TOTAL YARDS":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team1ListValue == ["-10000"] || team1ListValue == [] {
                headerLabel = tagText
            } else {
                if team1ListValue[0] == "NEW YORK GIANTS" {
                    team1ButtonLabel = "NEW YORK (G)"
                } else if team1ListValue[0] == "NEW YORK JETS" {
                    team1ButtonLabel = "NEW YORK (J)"
                } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabel = "LOS ANGELES (C)"
                } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabel = team1ListValue[0]
                    var team1TextArray = team1ButtonLabel.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabel = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = totalYardsTeam1Values
            formSliderValue = totalYardsTeam1SliderValue
            formRangeSliderLowerValue = totalYardsTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = totalYardsTeam1RangeSliderUpperValue
            formOperatorValue = totalYardsTeam1OperatorValue
            formOperatorText = totalYardsTeam1OperatorText
        case "OPPONENT: TOTAL YARDS":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                headerLabel = tagText
            } else {
                if team2ListValue[0] == "NEW YORK GIANTS" {
                    team2ButtonLabel = "NEW YORK (G)"
                } else if team2ListValue[0] == "NEW YORK JETS" {
                    team2ButtonLabel = "NEW YORK (J)"
                } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabel = "LOS ANGELES (C)"
                } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabel = team2ListValue[0]
                    var team2TextArray = team2ButtonLabel.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabel = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = totalYardsTeam2Values
            formSliderValue = totalYardsTeam2SliderValue
            formRangeSliderLowerValue = totalYardsTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = totalYardsTeam2RangeSliderUpperValue
            formOperatorValue = totalYardsTeam2OperatorValue
            formOperatorText = totalYardsTeam2OperatorText
        case "TEAM: PASSING YARDS":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team1ListValue == ["-10000"] || team1ListValue == [] {
                headerLabel = tagText
            } else {
                if team1ListValue[0] == "NEW YORK GIANTS" {
                    team1ButtonLabel = "NEW YORK (G)"
                } else if team1ListValue[0] == "NEW YORK JETS" {
                    team1ButtonLabel = "NEW YORK (J)"
                } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabel = "LOS ANGELES (C)"
                } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabel = team1ListValue[0]
                    var team1TextArray = team1ButtonLabel.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabel = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = passingYardsTeam1Values
            formSliderValue = passingYardsTeam1SliderValue
            formRangeSliderLowerValue = passingYardsTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = passingYardsTeam1RangeSliderUpperValue
            formOperatorValue = passingYardsTeam1OperatorValue
            formOperatorText = passingYardsTeam1OperatorText
        case "OPPONENT: PASSING YARDS":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                headerLabel = tagText
            } else {
                if team2ListValue[0] == "NEW YORK GIANTS" {
                    team2ButtonLabel = "NEW YORK (G)"
                } else if team2ListValue[0] == "NEW YORK JETS" {
                    team2ButtonLabel = "NEW YORK (J)"
                } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabel = "LOS ANGELES (C)"
                } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabel = team2ListValue[0]
                    var team2TextArray = team2ButtonLabel.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabel = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = passingYardsTeam2Values
            formSliderValue = passingYardsTeam2SliderValue
            formRangeSliderLowerValue = passingYardsTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = passingYardsTeam2RangeSliderUpperValue
            formOperatorValue = passingYardsTeam2OperatorValue
            formOperatorText = passingYardsTeam2OperatorText
        case "TEAM: RUSHING YARDS":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team1ListValue == ["-10000"] || team1ListValue == [] {
                headerLabel = tagText
            } else {
                if team1ListValue[0] == "NEW YORK GIANTS" {
                    team1ButtonLabel = "NEW YORK (G)"
                } else if team1ListValue[0] == "NEW YORK JETS" {
                    team1ButtonLabel = "NEW YORK (J)"
                } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabel = "LOS ANGELES (C)"
                } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabel = team1ListValue[0]
                    var team1TextArray = team1ButtonLabel.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabel = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = rushingYardsTeam1Values
            formSliderValue = rushingYardsTeam1SliderValue
            formRangeSliderLowerValue = rushingYardsTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = rushingYardsTeam1RangeSliderUpperValue
            formOperatorValue = rushingYardsTeam1OperatorValue
            formOperatorText = rushingYardsTeam1OperatorText
        case "OPPONENT: RUSHING YARDS":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                headerLabel = tagText
            } else {
                if team2ListValue[0] == "NEW YORK GIANTS" {
                    team2ButtonLabel = "NEW YORK (G)"
                } else if team2ListValue[0] == "NEW YORK JETS" {
                    team2ButtonLabel = "NEW YORK (J)"
                } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabel = "LOS ANGELES (C)"
                } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabel = team2ListValue[0]
                    var team2TextArray = team2ButtonLabel.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabel = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = rushingYardsTeam2Values
            formSliderValue = rushingYardsTeam2SliderValue
            formRangeSliderLowerValue = rushingYardsTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = rushingYardsTeam2RangeSliderUpperValue
            formOperatorValue = rushingYardsTeam2OperatorValue
            formOperatorText = rushingYardsTeam2OperatorText
        case "TEAM: QUARTERBACK RATING":
            self.operatorDictionary = ["-10000" : " IS ",
                                  "=" : " IS ",
                                  "≠" : " IS NOT ",
                                  "<" : " IS LOWER THAN ",
                                  ">" : " IS HIGHER THAN ",
                                  "< >" : " IS BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team1ListValue == ["-10000"] || team1ListValue == [] {
                headerLabel = tagText
            } else {
                if team1ListValue[0] == "NEW YORK GIANTS" {
                    team1ButtonLabel = "NEW YORK (G)"
                } else if team1ListValue[0] == "NEW YORK JETS" {
                    team1ButtonLabel = "NEW YORK (J)"
                } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabel = "LOS ANGELES (C)"
                } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabel = team1ListValue[0]
                    var team1TextArray = team1ButtonLabel.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabel = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = quarterbackRatingTeam1Values
            formSliderValue = quarterbackRatingTeam1SliderValue
            formRangeSliderLowerValue = quarterbackRatingTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = quarterbackRatingTeam1RangeSliderUpperValue
            formOperatorValue = quarterbackRatingTeam1OperatorValue
            formOperatorText = quarterbackRatingTeam1OperatorText
        case "OPPONENT: QUARTERBACK RATING":
            self.operatorDictionary = ["-10000" : " IS ",
                                  "=" : " IS ",
                                  "≠" : " IS NOT ",
                                  "<" : " IS LOWER THAN ",
                                  ">" : " IS HIGHER THAN ",
                                  "< >" : " IS BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                headerLabel = tagText
            } else {
                if team2ListValue[0] == "NEW YORK GIANTS" {
                    team2ButtonLabel = "NEW YORK (G)"
                } else if team2ListValue[0] == "NEW YORK JETS" {
                    team2ButtonLabel = "NEW YORK (J)"
                } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabel = "LOS ANGELES (C)"
                } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabel = team2ListValue[0]
                    var team2TextArray = team2ButtonLabel.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabel = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = quarterbackRatingTeam2Values
            formSliderValue = quarterbackRatingTeam2SliderValue
            formRangeSliderLowerValue = quarterbackRatingTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = quarterbackRatingTeam2RangeSliderUpperValue
            formOperatorValue = quarterbackRatingTeam2OperatorValue
            formOperatorText = quarterbackRatingTeam2OperatorText
        case "TEAM: TIMES SACKED":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team1ListValue == ["-10000"] || team1ListValue == [] {
                headerLabel = tagText
            } else {
                if team1ListValue[0] == "NEW YORK GIANTS" {
                    team1ButtonLabel = "NEW YORK (G)"
                } else if team1ListValue[0] == "NEW YORK JETS" {
                    team1ButtonLabel = "NEW YORK (J)"
                } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabel = "LOS ANGELES (C)"
                } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabel = team1ListValue[0]
                    var team1TextArray = team1ButtonLabel.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabel = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = timesSackedTeam1Values
            formSliderValue = timesSackedTeam1SliderValue
            formRangeSliderLowerValue = timesSackedTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = timesSackedTeam1RangeSliderUpperValue
            formOperatorValue = timesSackedTeam1OperatorValue
            formOperatorText = timesSackedTeam1OperatorText
        case "OPPONENT: TIMES SACKED":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                headerLabel = tagText
            } else {
                if team2ListValue[0] == "NEW YORK GIANTS" {
                    team2ButtonLabel = "NEW YORK (G)"
                } else if team2ListValue[0] == "NEW YORK JETS" {
                    team2ButtonLabel = "NEW YORK (J)"
                } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabel = "LOS ANGELES (C)"
                } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabel = team2ListValue[0]
                    var team2TextArray = team2ButtonLabel.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabel = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = timesSackedTeam2Values
            formSliderValue = timesSackedTeam2SliderValue
            formRangeSliderLowerValue = timesSackedTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = timesSackedTeam2RangeSliderUpperValue
            formOperatorValue = timesSackedTeam2OperatorValue
            formOperatorText = timesSackedTeam2OperatorText
        case "TEAM: INTERCEPTIONS THROWN":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team1ListValue == ["-10000"] || team1ListValue == [] {
                headerLabel = tagText
            } else {
                if team1ListValue[0] == "NEW YORK GIANTS" {
                    team1ButtonLabel = "NEW YORK (G)"
                } else if team1ListValue[0] == "NEW YORK JETS" {
                    team1ButtonLabel = "NEW YORK (J)"
                } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabel = "LOS ANGELES (C)"
                } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabel = team1ListValue[0]
                    var team1TextArray = team1ButtonLabel.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabel = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = interceptionsThrownTeam1Values
            formSliderValue = interceptionsThrownTeam1SliderValue
            formRangeSliderLowerValue = interceptionsThrownTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = interceptionsThrownTeam1RangeSliderUpperValue
            formOperatorValue = interceptionsThrownTeam1OperatorValue
            formOperatorText = interceptionsThrownTeam1OperatorText
        case "OPPONENT: INTERCEPTIONS THROWN":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                headerLabel = tagText
            } else {
                if team2ListValue[0] == "NEW YORK GIANTS" {
                    team2ButtonLabel = "NEW YORK (G)"
                } else if team2ListValue[0] == "NEW YORK JETS" {
                    team2ButtonLabel = "NEW YORK (J)"
                } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabel = "LOS ANGELES (C)"
                } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabel = team2ListValue[0]
                    var team2TextArray = team2ButtonLabel.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabel = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = interceptionsThrownTeam2Values
            formSliderValue = interceptionsThrownTeam2SliderValue
            formRangeSliderLowerValue = interceptionsThrownTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = interceptionsThrownTeam2RangeSliderUpperValue
            formOperatorValue = interceptionsThrownTeam2OperatorValue
            formOperatorText = interceptionsThrownTeam2OperatorText
        case "TEAM: OFFENSIVE PLAYS":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team1ListValue == ["-10000"] || team1ListValue == [] {
                headerLabel = tagText
            } else {
                if team1ListValue[0] == "NEW YORK GIANTS" {
                    team1ButtonLabel = "NEW YORK (G)"
                } else if team1ListValue[0] == "NEW YORK JETS" {
                    team1ButtonLabel = "NEW YORK (J)"
                } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabel = "LOS ANGELES (C)"
                } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabel = team1ListValue[0]
                    var team1TextArray = team1ButtonLabel.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabel = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = defensivePlaysTeam1Values
            formSliderValue = defensivePlaysTeam1SliderValue
            formRangeSliderLowerValue = defensivePlaysTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = defensivePlaysTeam1RangeSliderUpperValue
            formOperatorValue = defensivePlaysTeam1OperatorValue
            formOperatorText = defensivePlaysTeam1OperatorText
        case "OPPONENT: OFFENSIVE PLAYS":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                headerLabel = tagText
            } else {
                if team2ListValue[0] == "NEW YORK GIANTS" {
                    team2ButtonLabel = "NEW YORK (G)"
                } else if team2ListValue[0] == "NEW YORK JETS" {
                    team2ButtonLabel = "NEW YORK (J)"
                } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabel = "LOS ANGELES (C)"
                } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabel = team2ListValue[0]
                    var team2TextArray = team2ButtonLabel.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabel = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = offensivePlaysTeam2Values
            formSliderValue = offensivePlaysTeam2SliderValue
            formRangeSliderLowerValue = offensivePlaysTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = offensivePlaysTeam2RangeSliderUpperValue
            formOperatorValue = offensivePlaysTeam2OperatorValue
            formOperatorText = offensivePlaysTeam2OperatorText
        case "TEAM: YARDS/OFFENSIVE PLAY":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team1ListValue == ["-10000"] || team1ListValue == [] {
                headerLabel = tagText
            } else {
                if team1ListValue[0] == "NEW YORK GIANTS" {
                    team1ButtonLabel = "NEW YORK (G)"
                } else if team1ListValue[0] == "NEW YORK JETS" {
                    team1ButtonLabel = "NEW YORK (J)"
                } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabel = "LOS ANGELES (C)"
                } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabel = team1ListValue[0]
                    var team1TextArray = team1ButtonLabel.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabel = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = yardsPerOffensivePlayTeam1Values
            formSliderValue = yardsPerOffensivePlayTeam1SliderValue
            formRangeSliderLowerValue = yardsPerOffensivePlayTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = yardsPerOffensivePlayTeam1RangeSliderUpperValue
            formOperatorValue = yardsPerOffensivePlayTeam1OperatorValue
            formOperatorText = yardsPerOffensivePlayTeam1OperatorText
        case "OPPONENT: YARDS/OFFENSIVE PLAY":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                headerLabel = tagText
            } else {
                if team2ListValue[0] == "NEW YORK GIANTS" {
                    team2ButtonLabel = "NEW YORK (G)"
                } else if team2ListValue[0] == "NEW YORK JETS" {
                    team2ButtonLabel = "NEW YORK (J)"
                } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabel = "LOS ANGELES (C)"
                } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabel = team2ListValue[0]
                    var team2TextArray = team2ButtonLabel.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabel = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = yardsPerOffensivePlayTeam2Values
            formSliderValue = yardsPerOffensivePlayTeam2SliderValue
            formRangeSliderLowerValue = yardsPerOffensivePlayTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = yardsPerOffensivePlayTeam2RangeSliderUpperValue
            formOperatorValue = yardsPerOffensivePlayTeam2OperatorValue
            formOperatorText = yardsPerOffensivePlayTeam2OperatorText
        case "TEAM: SACKS":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team1ListValue == ["-10000"] || team1ListValue == [] {
                headerLabel = tagText
            } else {
                if team1ListValue[0] == "NEW YORK GIANTS" {
                    team1ButtonLabel = "NEW YORK (G)"
                } else if team1ListValue[0] == "NEW YORK JETS" {
                    team1ButtonLabel = "NEW YORK (J)"
                } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabel = "LOS ANGELES (C)"
                } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabel = team1ListValue[0]
                    var team1TextArray = team1ButtonLabel.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabel = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = sacksTeam1Values
            formSliderValue = sacksTeam1SliderValue
            formRangeSliderLowerValue = sacksTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = sacksTeam1RangeSliderUpperValue
            formOperatorValue = sacksTeam1OperatorValue
            formOperatorText = sacksTeam1OperatorText
        case "OPPONENT: SACKS":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                headerLabel = tagText
            } else {
                if team2ListValue[0] == "NEW YORK GIANTS" {
                    team2ButtonLabel = "NEW YORK (G)"
                } else if team2ListValue[0] == "NEW YORK JETS" {
                    team2ButtonLabel = "NEW YORK (J)"
                } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabel = "LOS ANGELES (C)"
                } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabel = team2ListValue[0]
                    var team2TextArray = team2ButtonLabel.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabel = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = sacksTeam2Values
            formSliderValue = sacksTeam2SliderValue
            formRangeSliderLowerValue = sacksTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = sacksTeam2RangeSliderUpperValue
            formOperatorValue = sacksTeam2OperatorValue
            formOperatorText = sacksTeam2OperatorText
        case "TEAM: INTERCEPTIONS":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team1ListValue == ["-10000"] || team1ListValue == [] {
                headerLabel = tagText
            } else {
                if team1ListValue[0] == "NEW YORK GIANTS" {
                    team1ButtonLabel = "NEW YORK (G)"
                } else if team1ListValue[0] == "NEW YORK JETS" {
                    team1ButtonLabel = "NEW YORK (J)"
                } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabel = "LOS ANGELES (C)"
                } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabel = team1ListValue[0]
                    var team1TextArray = team1ButtonLabel.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabel = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = interceptionsTeam1Values
            formSliderValue = interceptionsTeam1SliderValue
            formRangeSliderLowerValue = interceptionsTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = interceptionsTeam1RangeSliderUpperValue
            formOperatorValue = interceptionsTeam1OperatorValue
            formOperatorText = interceptionsTeam1OperatorText
        case "OPPONENT: INTERCEPTIONS":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                headerLabel = tagText
            } else {
                if team2ListValue[0] == "NEW YORK GIANTS" {
                    team2ButtonLabel = "NEW YORK (G)"
                } else if team2ListValue[0] == "NEW YORK JETS" {
                    team2ButtonLabel = "NEW YORK (J)"
                } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabel = "LOS ANGELES (C)"
                } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabel = team2ListValue[0]
                    var team2TextArray = team2ButtonLabel.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabel = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = interceptionsTeam2Values
            formSliderValue = interceptionsTeam2SliderValue
            formRangeSliderLowerValue = interceptionsTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = interceptionsTeam2RangeSliderUpperValue
            formOperatorValue = interceptionsTeam2OperatorValue
            formOperatorText = interceptionsTeam2OperatorText
        case "TEAM: SAFETIES":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team1ListValue == ["-10000"] || team1ListValue == [] {
                headerLabel = tagText
            } else {
                if team1ListValue[0] == "NEW YORK GIANTS" {
                    team1ButtonLabel = "NEW YORK (G)"
                } else if team1ListValue[0] == "NEW YORK JETS" {
                    team1ButtonLabel = "NEW YORK (J)"
                } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabel = "LOS ANGELES (C)"
                } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabel = team1ListValue[0]
                    var team1TextArray = team1ButtonLabel.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabel = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = safetiesTeam1Values
            formSliderValue = safetiesTeam1SliderValue
            formRangeSliderLowerValue = safetiesTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = safetiesTeam1RangeSliderUpperValue
            formOperatorValue = safetiesTeam1OperatorValue
            formOperatorText = safetiesTeam1OperatorText
        case "OPPONENT: SAFETIES":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                headerLabel = tagText
            } else {
                if team2ListValue[0] == "NEW YORK GIANTS" {
                    team2ButtonLabel = "NEW YORK (G)"
                } else if team2ListValue[0] == "NEW YORK JETS" {
                    team2ButtonLabel = "NEW YORK (J)"
                } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabel = "LOS ANGELES (C)"
                } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabel = team2ListValue[0]
                    var team2TextArray = team2ButtonLabel.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabel = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = safetiesTeam2Values
            formSliderValue = safetiesTeam2SliderValue
            formRangeSliderLowerValue = safetiesTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = safetiesTeam2RangeSliderUpperValue
            formOperatorValue = safetiesTeam2OperatorValue
            formOperatorText = safetiesTeam2OperatorText
        case "TEAM: DEFENSIVE PLAYS":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team1ListValue == ["-10000"] || team1ListValue == [] {
                headerLabel = tagText
            } else {
                if team1ListValue[0] == "NEW YORK GIANTS" {
                    team1ButtonLabel = "NEW YORK (G)"
                } else if team1ListValue[0] == "NEW YORK JETS" {
                    team1ButtonLabel = "NEW YORK (J)"
                } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabel = "LOS ANGELES (C)"
                } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabel = team1ListValue[0]
                    var team1TextArray = team1ButtonLabel.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabel = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = defensivePlaysTeam1Values
            formSliderValue = defensivePlaysTeam1SliderValue
            formRangeSliderLowerValue = defensivePlaysTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = defensivePlaysTeam1RangeSliderUpperValue
            formOperatorValue = defensivePlaysTeam1OperatorValue
            formOperatorText = defensivePlaysTeam1OperatorText
        case "OPPONENT: DEFENSIVE PLAYS":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                headerLabel = tagText
            } else {
                if team2ListValue[0] == "NEW YORK GIANTS" {
                    team2ButtonLabel = "NEW YORK (G)"
                } else if team2ListValue[0] == "NEW YORK JETS" {
                    team2ButtonLabel = "NEW YORK (J)"
                } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabel = "LOS ANGELES (C)"
                } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabel = team2ListValue[0]
                    var team2TextArray = team2ButtonLabel.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabel = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = defensivePlaysTeam2Values
            formSliderValue = defensivePlaysTeam2SliderValue
            formRangeSliderLowerValue = defensivePlaysTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = defensivePlaysTeam2RangeSliderUpperValue
            formOperatorValue = defensivePlaysTeam2OperatorValue
            formOperatorText = defensivePlaysTeam2OperatorText
        case "TEAM: YARDS/DEFENSIVE PLAY":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team1ListValue == ["-10000"] || team1ListValue == [] {
                headerLabel = tagText
            } else {
                if team1ListValue[0] == "NEW YORK GIANTS" {
                    team1ButtonLabel = "NEW YORK (G)"
                } else if team1ListValue[0] == "NEW YORK JETS" {
                    team1ButtonLabel = "NEW YORK (J)"
                } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabel = "LOS ANGELES (C)"
                } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabel = team1ListValue[0]
                    var team1TextArray = team1ButtonLabel.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabel = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = yardsPerDefensivePlayTeam1Values
            formSliderValue = yardsPerDefensivePlayTeam1SliderValue
            formRangeSliderLowerValue = yardsPerDefensivePlayTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = yardsPerDefensivePlayTeam1RangeSliderUpperValue
            formOperatorValue = yardsPerDefensivePlayTeam1OperatorValue
            formOperatorText = yardsPerDefensivePlayTeam1OperatorText
        case "OPPONENT: YARDS/DEFENSIVE PLAY":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                headerLabel = tagText
            } else {
                if team2ListValue[0] == "NEW YORK GIANTS" {
                    team2ButtonLabel = "NEW YORK (G)"
                } else if team2ListValue[0] == "NEW YORK JETS" {
                    team2ButtonLabel = "NEW YORK (J)"
                } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabel = "LOS ANGELES (C)"
                } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabel = team2ListValue[0]
                    var team2TextArray = team2ButtonLabel.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabel = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = yardsPerDefensivePlayTeam2Values
            formSliderValue = yardsPerDefensivePlayTeam2SliderValue
            formRangeSliderLowerValue = yardsPerDefensivePlayTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = yardsPerDefensivePlayTeam2RangeSliderUpperValue
            formOperatorValue = yardsPerDefensivePlayTeam2OperatorValue
            formOperatorText = yardsPerDefensivePlayTeam2OperatorText
        case "TEAM: EXTRA POINT ATTEMPTS":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team1ListValue == ["-10000"] || team1ListValue == [] {
                headerLabel = tagText
            } else {
                if team1ListValue[0] == "NEW YORK GIANTS" {
                    team1ButtonLabel = "NEW YORK (G)"
                } else if team1ListValue[0] == "NEW YORK JETS" {
                    team1ButtonLabel = "NEW YORK (J)"
                } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabel = "LOS ANGELES (C)"
                } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabel = team1ListValue[0]
                    var team1TextArray = team1ButtonLabel.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabel = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = extraPointAttemptsTeam1Values
            formSliderValue = extraPointAttemptsTeam1SliderValue
            formRangeSliderLowerValue = extraPointAttemptsTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = extraPointAttemptsTeam1RangeSliderUpperValue
            formOperatorValue = extraPointAttemptsTeam1OperatorValue
            formOperatorText = extraPointAttemptsTeam1OperatorText
        case "OPPONENT: EXTRA POINT ATTEMPTS":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                headerLabel = tagText
            } else {
                if team2ListValue[0] == "NEW YORK GIANTS" {
                    team2ButtonLabel = "NEW YORK (G)"
                } else if team2ListValue[0] == "NEW YORK JETS" {
                    team2ButtonLabel = "NEW YORK (J)"
                } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabel = "LOS ANGELES (C)"
                } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabel = team2ListValue[0]
                    var team2TextArray = team2ButtonLabel.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabel = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = extraPointAttemptsTeam2Values
            formSliderValue = extraPointAttemptsTeam2SliderValue
            formRangeSliderLowerValue = extraPointAttemptsTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = extraPointAttemptsTeam2RangeSliderUpperValue
            formOperatorValue = extraPointAttemptsTeam2OperatorValue
            formOperatorText = extraPointAttemptsTeam2OperatorText
        case "TEAM: EXTRA POINTS MADE":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team1ListValue == ["-10000"] || team1ListValue == [] {
                headerLabel = tagText
            } else {
                if team1ListValue[0] == "NEW YORK GIANTS" {
                    team1ButtonLabel = "NEW YORK (G)"
                } else if team1ListValue[0] == "NEW YORK JETS" {
                    team1ButtonLabel = "NEW YORK (J)"
                } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabel = "LOS ANGELES (C)"
                } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabel = team1ListValue[0]
                    var team1TextArray = team1ButtonLabel.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabel = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = extraPointsMadeTeam1Values
            formSliderValue = extraPointsMadeTeam1SliderValue
            formRangeSliderLowerValue = extraPointsMadeTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = extraPointsMadeTeam1RangeSliderUpperValue
            formOperatorValue = extraPointsMadeTeam1OperatorValue
            formOperatorText = extraPointsMadeTeam1OperatorText
        case "OPPONENT: EXTRA POINTS MADE":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                headerLabel = tagText
            } else {
                if team2ListValue[0] == "NEW YORK GIANTS" {
                    team2ButtonLabel = "NEW YORK (G)"
                } else if team2ListValue[0] == "NEW YORK JETS" {
                    team2ButtonLabel = "NEW YORK (J)"
                } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabel = "LOS ANGELES (C)"
                } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabel = team2ListValue[0]
                    var team2TextArray = team2ButtonLabel.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabel = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = extraPointsMadeTeam2Values
            formSliderValue = extraPointsMadeTeam2SliderValue
            formRangeSliderLowerValue = extraPointsMadeTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = extraPointsMadeTeam2RangeSliderUpperValue
            formOperatorValue = extraPointsMadeTeam2OperatorValue
            formOperatorText = extraPointsMadeTeam2OperatorText
        case "TEAM: FIELD GOAL ATTEMPTS":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team1ListValue == ["-10000"] || team1ListValue == [] {
                headerLabel = tagText
            } else {
                if team1ListValue[0] == "NEW YORK GIANTS" {
                    team1ButtonLabel = "NEW YORK (G)"
                } else if team1ListValue[0] == "NEW YORK JETS" {
                    team1ButtonLabel = "NEW YORK (J)"
                } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabel = "LOS ANGELES (C)"
                } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabel = team1ListValue[0]
                    var team1TextArray = team1ButtonLabel.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabel = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = fieldGoalAttemptsTeam1Values
            formSliderValue = fieldGoalAttemptsTeam1SliderValue
            formRangeSliderLowerValue = fieldGoalAttemptsTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = fieldGoalAttemptsTeam1RangeSliderUpperValue
            formOperatorValue = fieldGoalAttemptsTeam1OperatorValue
            formOperatorText = fieldGoalAttemptsTeam1OperatorText
        case "OPPONENT: FIELD GOAL ATTEMPTS":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                headerLabel = tagText
            } else {
                if team2ListValue[0] == "NEW YORK GIANTS" {
                    team2ButtonLabel = "NEW YORK (G)"
                } else if team2ListValue[0] == "NEW YORK JETS" {
                    team2ButtonLabel = "NEW YORK (J)"
                } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabel = "LOS ANGELES (C)"
                } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabel = team2ListValue[0]
                    var team2TextArray = team2ButtonLabel.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabel = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = fieldGoalAttemptsTeam2Values
            formSliderValue = fieldGoalAttemptsTeam2SliderValue
            formRangeSliderLowerValue = fieldGoalAttemptsTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = fieldGoalAttemptsTeam2RangeSliderUpperValue
            formOperatorValue = fieldGoalAttemptsTeam2OperatorValue
            formOperatorText = fieldGoalAttemptsTeam2OperatorText
        case "TEAM: FIELD GOALS MADE":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team1ListValue == ["-10000"] || team1ListValue == [] {
                headerLabel = tagText
            } else {
                if team1ListValue[0] == "NEW YORK GIANTS" {
                    team1ButtonLabel = "NEW YORK (G)"
                } else if team1ListValue[0] == "NEW YORK JETS" {
                    team1ButtonLabel = "NEW YORK (J)"
                } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabel = "LOS ANGELES (C)"
                } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabel = team1ListValue[0]
                    var team1TextArray = team1ButtonLabel.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabel = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = fieldGoalsMadeTeam1Values
            formSliderValue = fieldGoalsMadeTeam1SliderValue
            formRangeSliderLowerValue = fieldGoalsMadeTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = fieldGoalsMadeTeam1RangeSliderUpperValue
            formOperatorValue = fieldGoalsMadeTeam1OperatorValue
            formOperatorText = fieldGoalsMadeTeam1OperatorText
        case "OPPONENT: FIELD GOALS MADE":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                headerLabel = tagText
            } else {
                if team2ListValue[0] == "NEW YORK GIANTS" {
                    team2ButtonLabel = "NEW YORK (G)"
                } else if team2ListValue[0] == "NEW YORK JETS" {
                    team2ButtonLabel = "NEW YORK (J)"
                } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabel = "LOS ANGELES (C)"
                } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabel = team2ListValue[0]
                    var team2TextArray = team2ButtonLabel.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabel = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = fieldGoalsMadeTeam2Values
            formSliderValue = fieldGoalsMadeTeam2SliderValue
            formRangeSliderLowerValue = fieldGoalsMadeTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = fieldGoalsMadeTeam2RangeSliderUpperValue
            formOperatorValue = fieldGoalsMadeTeam2OperatorValue
            formOperatorText = fieldGoalsMadeTeam2OperatorText
        case "TEAM: PUNTS":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team1ListValue == ["-10000"] || team1ListValue == [] {
                headerLabel = tagText
            } else {
                if team1ListValue[0] == "NEW YORK GIANTS" {
                    team1ButtonLabel = "NEW YORK (G)"
                } else if team1ListValue[0] == "NEW YORK JETS" {
                    team1ButtonLabel = "NEW YORK (J)"
                } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabel = "LOS ANGELES (C)"
                } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabel = team1ListValue[0]
                    var team1TextArray = team1ButtonLabel.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabel = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = puntsTeam1Values
            formSliderValue = puntsTeam1SliderValue
            formRangeSliderLowerValue = puntsTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = puntsTeam1RangeSliderUpperValue
            formOperatorValue = puntsTeam1OperatorValue
            formOperatorText = puntsTeam1OperatorText
        case "OPPONENT: PUNTS":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                headerLabel = tagText
            } else {
                if team2ListValue[0] == "NEW YORK GIANTS" {
                    team2ButtonLabel = "NEW YORK (G)"
                } else if team2ListValue[0] == "NEW YORK JETS" {
                    team2ButtonLabel = "NEW YORK (J)"
                } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabel = "LOS ANGELES (C)"
                } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabel = team2ListValue[0]
                    var team2TextArray = team2ButtonLabel.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabel = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = puntsTeam2Values
            formSliderValue = puntsTeam2SliderValue
            formRangeSliderLowerValue = puntsTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = puntsTeam2RangeSliderUpperValue
            formOperatorValue = puntsTeam2OperatorValue
            formOperatorText = puntsTeam2OperatorText
        case "TEAM: PUNT YARDS":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team1ListValue == ["-10000"] || team1ListValue == [] {
                headerLabel = tagText
            } else {
                if team1ListValue[0] == "NEW YORK GIANTS" {
                    team1ButtonLabel = "NEW YORK (G)"
                } else if team1ListValue[0] == "NEW YORK JETS" {
                    team1ButtonLabel = "NEW YORK (J)"
                } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabel = "LOS ANGELES (C)"
                } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabel = team1ListValue[0]
                    var team1TextArray = team1ButtonLabel.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabel = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = puntYardsTeam1Values
            formSliderValue = puntYardsTeam1SliderValue
            formRangeSliderLowerValue = puntYardsTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = puntYardsTeam1RangeSliderUpperValue
            formOperatorValue = puntYardsTeam1OperatorValue
            formOperatorText = puntYardsTeam1OperatorText
        case "OPPONENT: PUNT YARDS":
            self.operatorDictionary = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                headerLabel = tagText
            } else {
                if team2ListValue[0] == "NEW YORK GIANTS" {
                    team2ButtonLabel = "NEW YORK (G)"
                } else if team2ListValue[0] == "NEW YORK JETS" {
                    team2ButtonLabel = "NEW YORK (J)"
                } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabel = "LOS ANGELES (C)"
                } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabel = team2ListValue[0]
                    var team2TextArray = team2ButtonLabel.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabel = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabel + ": " + rowTitle
            }
            operatorsArray = allOperators
            sliderValues = puntYardsTeam2Values
            formSliderValue = puntYardsTeam2SliderValue
            formRangeSliderLowerValue = puntYardsTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = puntYardsTeam2RangeSliderUpperValue
            formOperatorValue = puntYardsTeam2OperatorValue
            formOperatorText = puntYardsTeam2OperatorText
        default:
            return
        }
        
        SegmentedRow<String>.defaultCellSetup = { cell, row in
            cell.tintColor = lightGreyColor
            cell.backgroundColor = UIColor.clear
            cell.height = { 45.0 }
            //cell.segmentedControl.
            cell.segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: sixteenLightRoboto!], for: UIControlState.normal)
            cell.segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: sixteenBoldRoboto!], for: UIControlState.selected)
            cell.titleLabel?.textColor = lightGreyColor
            cell.titleLabel?.font = sixteenLightRoboto
        }
        
        SegmentedRow<String>.defaultCellUpdate = { cell, row in
            cell.tintColor = lightGreyColor
            cell.backgroundColor = UIColor.clear
            cell.height = { 45.0 }
            cell.segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: sixteenLightRoboto!], for: UIControlState.normal)
            cell.segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: sixteenBoldRoboto!], for: UIControlState.selected)
            cell.titleLabel?.textColor = lightGreyColor
            cell.titleLabel?.font = sixteenLightRoboto
        }
        
        form +++
            
            Section() { section in
                var header = HeaderFooterView<UILabel>(.class)
                header.height = { 10.0 }
                header.onSetupView = { view, _ in
                    view.textColor = lightGreyColor
                    view.font = twelveSemiboldSFCompact!
                    view.text = ""
                }
                section.header = header
            }
            
            <<< SegmentedRow<String>("OPERATOR") {
                $0.title = nil
                $0.options = operatorsArray as? [String]
                operatorText = self.operatorDictionary[formOperatorValue]!
                switch (formOperatorValue) {
                case "-10000":
                    $0.value = "< >"
                    rangeBoolean = true
                    self.rangeSliderObject.isHidden = false
                    //print("OPERATOR LOADED AS -10000")
                case "=":
                    $0.value = formOperatorValue
                    rangeBoolean = false
                    self.rangeSliderObject.isHidden = true
                case "≠":
                    $0.value = formOperatorValue
                    rangeBoolean = false
                    self.rangeSliderObject.isHidden = true
                case "<":
                    $0.value = formOperatorValue
                    rangeBoolean = false
                    self.rangeSliderObject.isHidden = true
                case ">":
                    $0.value = formOperatorValue
                    rangeBoolean = false
                    self.rangeSliderObject.isHidden = true
                case "< >":
                    $0.value = formOperatorValue
                    rangeBoolean = true
                    self.rangeSliderObject.isHidden = false
                    //print("OPERATOR LOADED AS BETWEEN")
                default:
                   return }
                } .cellSetup { cell, row in
                    cell.height = { 28 }
                }.onChange { row in
                    selectedOperatorValue = row.value!
                    //print("selectedOperatorValue (onChange): ")
                    //print(selectedOperatorValue)
                    operatorText = self.operatorDictionary[selectedOperatorValue]!
                    //print("operatorText (onChange): " + operatorText)
                    switch(selectedOperatorValue) {
                    case "-10000":
                        self.rangeBoolean = true
                        self.rangeSliderActivated()
                        self.rangeSliderObject.isHidden = false
                        //print("OPERATOR CHANGED TO -10000")
                    case "=":
                        self.rangeBoolean = false
                        self.singleSelectionSliderActivated()
                        self.rangeSliderObject.isHidden = true
                    case "≠":
                        self.rangeBoolean = false
                        self.singleSelectionSliderActivated()
                        self.rangeSliderObject.isHidden = true
                    case "<":
                       self.rangeBoolean = false
                        self.singleSelectionSliderActivated()
                        self.rangeSliderObject.isHidden = true
                    case ">":
                        self.rangeBoolean = false
                        self.singleSelectionSliderActivated()
                        self.rangeSliderObject.isHidden = true
                    case "< >":
                        self.rangeBoolean = true
                        self.rangeSliderActivated()
                        self.rangeSliderObject.isHidden = false
                        //print("OPERATOR CHANGED TO BETWEEN")
                    default:
                        self.rangeBoolean = false
                    switch (tagText) {
                    case "TEAM: STREAK":
                        winningLosingStreakTeam1OperatorValue = selectedOperatorValue
                        winningLosingStreakTeam1OperatorText = operatorText
                    case "OPPONENT: STREAK":
                        winningLosingStreakTeam2OperatorValue = selectedOperatorValue
                        winningLosingStreakTeam2OperatorText = operatorText
                    case "TEAM: SEASON WIN %":
                        seasonWinPercentageTeam1OperatorValue = selectedOperatorValue
                        seasonWinPercentageTeam1OperatorText = operatorText
                    case "OPPONENT: SEASON WIN %":
                        seasonWinPercentageTeam2OperatorValue = selectedOperatorValue
                        seasonWinPercentageTeam2OperatorText = operatorText
                    case "SEASON":
                        seasonOperatorValue = selectedOperatorValue
                        seasonOperatorText = operatorText
                    case "GAME NUMBER":
                        gameNumberOperatorValue = selectedOperatorValue
                        gameNumberOperatorText = operatorText
                    case "WEEK":
                        weekOperatorValue = selectedOperatorValue
                        weekOperatorText = operatorText
                    case "TEAM: SPREAD":
                        spreadOperatorValue = selectedOperatorValue
                        spreadOperatorText = operatorText
                    case "OVER/UNDER":
                        overUnderOperatorValue = selectedOperatorValue
                        overUnderOperatorText = operatorText
                    case "TEMPERATURE (F)":
                        temperatureOperatorValue = selectedOperatorValue
                        temperatureOperatorText = operatorText
                    case "TEAM: TOTAL POINTS":
                        totalPointsTeam1OperatorValue = selectedOperatorValue
                        totalPointsTeam1OperatorText = operatorText
                    case "OPPONENT: TOTAL POINTS":
                        totalPointsTeam2OperatorValue = selectedOperatorValue
                        totalPointsTeam2OperatorText = operatorText
                    case "TEAM: TOUCHDOWNS":
                        touchdownsTeam1OperatorValue = selectedOperatorValue
                        touchdownsTeam1OperatorText = operatorText
                    case "OPPONENT: TOUCHDOWNS":
                        touchdownsTeam2OperatorValue = selectedOperatorValue
                        touchdownsTeam2OperatorText = operatorText
                    
                    case "TEAM: OFFENSIVE TOUCHDOWNS":
                        offensiveTouchdownsTeam1OperatorValue = selectedOperatorValue
                        offensiveTouchdownsTeam1OperatorText = operatorText
                    case "OPPONENT: OFFENSIVE TOUCHDOWNS":
                        offensiveTouchdownsTeam2OperatorValue = selectedOperatorValue
                        offensiveTouchdownsTeam2OperatorText = operatorText
                    case "TEAM: DEFENSIVE TOUCHDOWNS":
                        defensiveTouchdownsTeam1OperatorValue = selectedOperatorValue
                        defensiveTouchdownsTeam1OperatorText = operatorText
                    case "OPPONENT: DEFENSIVE TOUCHDOWNS":
                        defensiveTouchdownsTeam2OperatorValue = selectedOperatorValue
                        defensiveTouchdownsTeam2OperatorText = operatorText
                        
                    case "TEAM: TURNOVERS":
                        turnoversCommittedTeam1OperatorValue = selectedOperatorValue
                        turnoversCommittedTeam1OperatorText = operatorText
                    case "OPPONENT: TURNOVERS":
                        turnoversCommittedTeam2OperatorValue = selectedOperatorValue
                        turnoversCommittedTeam2OperatorText = operatorText
                    case "TEAM: PENALTIES":
                        penaltiesCommittedTeam1OperatorValue = selectedOperatorValue
                        penaltiesCommittedTeam1OperatorText = operatorText
                    case "OPPONENT: PENALTIES":
                        penaltiesCommittedTeam2OperatorValue = selectedOperatorValue
                        penaltiesCommittedTeam2OperatorText = operatorText
                    case "TEAM: TOTAL YARDS":
                        totalYardsTeam1OperatorValue = selectedOperatorValue
                        totalYardsTeam1OperatorText = operatorText
                    case "OPPONENT: TOTAL YARDS":
                        totalYardsTeam2OperatorValue = selectedOperatorValue
                        totalYardsTeam2OperatorText = operatorText
                    case "TEAM: PASSING YARDS":
                        passingYardsTeam1OperatorValue = selectedOperatorValue
                        passingYardsTeam1OperatorText = operatorText
                    case "OPPONENT: PASSING YARDS":
                        passingYardsTeam2OperatorValue = selectedOperatorValue
                        passingYardsTeam2OperatorText = operatorText
                    case "TEAM: RUSHING YARDS":
                        rushingYardsTeam1OperatorValue = selectedOperatorValue
                        rushingYardsTeam1OperatorText = operatorText
                    case "OPPONENT: RUSHING YARDS":
                        rushingYardsTeam2OperatorValue = selectedOperatorValue
                        rushingYardsTeam2OperatorText = operatorText
                    case "TEAM: QUARTERBACK RATING":
                        quarterbackRatingTeam1OperatorValue = selectedOperatorValue
                        quarterbackRatingTeam1OperatorText = operatorText
                    case "OPPONENT: QUARTERBACK RATING":
                        quarterbackRatingTeam2OperatorValue = selectedOperatorValue
                        quarterbackRatingTeam2OperatorText = operatorText
                    case "TEAM: TIMES SACKED":
                        timesSackedTeam1OperatorValue = selectedOperatorValue
                        timesSackedTeam1OperatorText = operatorText
                    case "OPPONENT: TIMES SACKED":
                        timesSackedTeam2OperatorValue = selectedOperatorValue
                        timesSackedTeam2OperatorText = operatorText
                    case "TEAM: INTERCEPTIONS THROWN":
                        interceptionsThrownTeam1OperatorValue = selectedOperatorValue
                        interceptionsThrownTeam1OperatorText = operatorText
                    case "OPPONENT: INTERCEPTIONS THROWN":
                        interceptionsThrownTeam2OperatorValue = selectedOperatorValue
                        interceptionsThrownTeam2OperatorText = operatorText
                    case "TEAM: OFFENSIVE PLAYS":
                        offensivePlaysTeam1OperatorValue = selectedOperatorValue
                        offensivePlaysTeam1OperatorText = operatorText
                    case "OPPONENT: OFFENSIVE PLAYS":
                        offensivePlaysTeam2OperatorValue = selectedOperatorValue
                        offensivePlaysTeam2OperatorText = operatorText
                    case "TEAM: YARDS/OFFENSIVE PLAY":
                        yardsPerOffensivePlayTeam1OperatorValue = selectedOperatorValue
                        yardsPerOffensivePlayTeam1OperatorText = operatorText
                    case "OPPONENT: YARDS/OFFENSIVE PLAY":
                        yardsPerOffensivePlayTeam2OperatorValue = selectedOperatorValue
                        yardsPerOffensivePlayTeam2OperatorText = operatorText
                    case "TEAM: SACKS":
                        sacksTeam1OperatorValue = selectedOperatorValue
                        sacksTeam1OperatorText = operatorText
                    case "OPPONENT: SACKS":
                        sacksTeam2OperatorValue = selectedOperatorValue
                        sacksTeam2OperatorText = operatorText
                    case "TEAM: INTERCEPTIONS":
                        interceptionsTeam1OperatorValue = selectedOperatorValue
                        interceptionsTeam1OperatorText = operatorText
                    case "OPPONENT: INTERCEPTIONS":
                        interceptionsTeam2OperatorValue = selectedOperatorValue
                        interceptionsTeam2OperatorText = operatorText
                    case "TEAM: SAFETIES":
                        safetiesTeam1OperatorValue = selectedOperatorValue
                        safetiesTeam1OperatorText = operatorText
                    case "OPPONENT: SAFETIES":
                        safetiesTeam2OperatorValue = selectedOperatorValue
                        safetiesTeam2OperatorText = operatorText
                    case "TEAM: DEFENSIVE PLAYS":
                        defensivePlaysTeam1OperatorValue = selectedOperatorValue
                        defensivePlaysTeam1OperatorText = operatorText
                    case "OPPONENT: DEFENSIVE PLAYS":
                        defensivePlaysTeam2OperatorValue = selectedOperatorValue
                        defensivePlaysTeam2OperatorText = operatorText
                    case "TEAM: YARDS/DEFENSIVE PLAY":
                        yardsPerDefensivePlayTeam1OperatorValue = selectedOperatorValue
                        yardsPerDefensivePlayTeam1OperatorText = operatorText
                    case "OPPONENT: YARDS/DEFENSIVE PLAY":
                        yardsPerDefensivePlayTeam2OperatorValue = selectedOperatorValue
                        yardsPerDefensivePlayTeam2OperatorText = operatorText
                    case "TEAM: EXTRA POINT ATTEMPTS":
                        extraPointAttemptsTeam1OperatorValue = selectedOperatorValue
                        extraPointAttemptsTeam1OperatorText = operatorText
                    case "OPPONENT: EXTRA POINT ATTEMPTS":
                        extraPointAttemptsTeam2OperatorValue = selectedOperatorValue
                        extraPointAttemptsTeam2OperatorText = operatorText
                    case "TEAM: EXTRA POINTS MADE":
                        extraPointsMadeTeam1OperatorValue = selectedOperatorValue
                        extraPointsMadeTeam1OperatorText = operatorText
                    case "OPPONENT: EXTRA POINTS MADE":
                        extraPointsMadeTeam2OperatorValue = selectedOperatorValue
                        extraPointsMadeTeam2OperatorText = operatorText
                    case "TEAM: FIELD GOAL ATTEMPTS":
                        fieldGoalAttemptsTeam1OperatorValue = selectedOperatorValue
                        fieldGoalAttemptsTeam1OperatorText = operatorText
                    case "OPPONENT: FIELD GOAL ATTEMPTS":
                        fieldGoalAttemptsTeam2OperatorValue = selectedOperatorValue
                        fieldGoalAttemptsTeam2OperatorText = operatorText
                    case "TEAM: FIELD GOALS MADE":
                        fieldGoalsMadeTeam1OperatorValue = selectedOperatorValue
                        fieldGoalsMadeTeam1OperatorText = operatorText
                    case "OPPONENT: FIELD GOALS MADE":
                        fieldGoalsMadeTeam2OperatorValue = selectedOperatorValue
                        fieldGoalsMadeTeam2OperatorText = operatorText
                    case "TEAM: PUNTS":
                        puntsTeam1OperatorValue = selectedOperatorValue
                        puntsTeam1OperatorText = operatorText
                    case "OPPONENT: PUNTS":
                        puntsTeam2OperatorValue = selectedOperatorValue
                        puntsTeam2OperatorText = operatorText
                    case "TEAM: PUNT YARDS":
                        puntYardsTeam1OperatorValue = selectedOperatorValue
                        puntYardsTeam1OperatorText = operatorText
                    case "OPPONENT: PUNT YARDS":
                        puntYardsTeam2OperatorValue = selectedOperatorValue
                        puntYardsTeam2OperatorText = operatorText
                    default:
                        return }
                    
                    }
            }

            <<< SliderRow("SLIDER") { row in
                row.minimumValue = sliderValues.first!
                row.maximumValue = sliderValues.last!
                row.steps = UInt(sliderValues.count - 1)
                row.cell.valueLabel.font = UIFont.systemFont(ofSize: 12.5)
                row.cell.valueLabel.textColor = silverColor
                if tagText == "TEAM: SPREAD" || tagText == "OVER/UNDER" {
                    row.title = "\0 "
                } else if tagText == "TEMPERATURE (F)" {
                    row.title = "\0  "
                } else if tagText == "TEAM: SEASON WIN %" || tagText == "OPPONENT: SEASON WIN %" {
                    row.title = "\0   "
                } else if tagText == "TEAM: STREAK" || tagText == "OPPONENT: STREAK" {
                    row.title = "\0    "
                } else {
                    row.title = " "
                }
                row.cell.backgroundColor = darkGreyColor
                switch (formSliderValue) {
                case Float(-10000):
                    row.value = sliderValues.last!
                default:
                    row.value = formSliderValue
                    row.cell.valueLabel.text = String(Int(row.value!))
                }
                } .onChange { row in
                    switch (tagText) {
                    case "TEAM: STREAK":
                        winningLosingStreakTeam1SliderValue = row.value!
                        self.reloadRowValue()
                    case "OPPONENT: STREAK":
                        winningLosingStreakTeam2SliderValue = row.value!
                        self.reloadRowValue()
                    case "TEAM: SEASON WIN %":
                        seasonWinPercentageTeam1SliderValue = row.value!
                        self.reloadRowValue()
                    case "OPPONENT: SEASON WIN %":
                        seasonWinPercentageTeam2SliderValue = row.value!
                        self.reloadRowValue()
                    case "SEASON":
                        seasonSliderValue = row.value!
                        self.reloadRowValue()
                    case "GAME NUMBER":
                        gameNumberSliderValue = row.value!
                        self.reloadRowValue()
                    case "WEEK":
                        weekSliderValue = row.value!
                        self.reloadRowValue()
                    case "TEAM: SPREAD":
                        spreadSliderValue = row.value!
                        self.reloadRowValue()
                    case "OVER/UNDER":
                        overUnderSliderValue = row.value!
                        self.reloadRowValue()
                    case "TEMPERATURE (F)":
                        temperatureSliderValue = row.value!
                        self.reloadRowValue()
                    case "TEAM: TOTAL POINTS":
                        totalPointsTeam1SliderValue = row.value!
                        self.reloadRowValue()
                    case "OPPONENT: TOTAL POINTS":
                        totalPointsTeam2SliderValue = row.value!
                        self.reloadRowValue()
                    case "TEAM: TOUCHDOWNS":
                        touchdownsTeam1SliderValue = row.value!
                        self.reloadRowValue()
                    case "OPPONENT: TOUCHDOWNS":
                        touchdownsTeam2SliderValue = row.value!
                        self.reloadRowValue()
                        
                    case "TEAM: OFFENSIVE TOUCHDOWNS":
                        offensiveTouchdownsTeam1SliderValue = row.value!
                        self.reloadRowValue()
                    case "OPPONENT: OFFENSIVE TOUCHDOWNS":
                        offensiveTouchdownsTeam2SliderValue = row.value!
                        self.reloadRowValue()
                    case "TEAM: DEFENSIVE TOUCHDOWNS":
                        defensiveTouchdownsTeam1SliderValue = row.value!
                        self.reloadRowValue()
                    case "OPPONENT: DEFENSIVE TOUCHDOWNS":
                        defensiveTouchdownsTeam2SliderValue = row.value!
                        self.reloadRowValue()
                        
                    case "TEAM: TURNOVERS":
                        turnoversCommittedTeam1SliderValue = row.value!
                        self.reloadRowValue()
                    case "OPPONENT: TURNOVERS":
                        turnoversCommittedTeam2SliderValue = row.value!
                        self.reloadRowValue()
                    case "TEAM: PENALTIES":
                        penaltiesCommittedTeam1SliderValue = row.value!
                        self.reloadRowValue()
                    case "OPPONENT: PENALTIES":
                        penaltiesCommittedTeam2SliderValue = row.value!
                        self.reloadRowValue()
                    case "TEAM: TOTAL YARDS":
                        totalYardsTeam1SliderValue = row.value!
                        self.reloadRowValue()
                    case "OPPONENT: TOTAL YARDS":
                        totalYardsTeam2SliderValue = row.value!
                        self.reloadRowValue()
                    case "TEAM: PASSING YARDS":
                        passingYardsTeam1SliderValue = row.value!
                        self.reloadRowValue()
                    case "OPPONENT: PASSING YARDS":
                        passingYardsTeam2SliderValue = row.value!
                        self.reloadRowValue()
                    case "TEAM: RUSHING YARDS":
                        rushingYardsTeam1SliderValue = row.value!
                        self.reloadRowValue()
                    case "OPPONENT: RUSHING YARDS":
                        rushingYardsTeam2SliderValue = row.value!
                        self.reloadRowValue()
                    case "TEAM: QUARTERBACK RATING":
                        quarterbackRatingTeam1SliderValue = row.value!
                        self.reloadRowValue()
                    case "OPPONENT: QUARTERBACK RATING":
                        quarterbackRatingTeam2SliderValue = row.value!
                        self.reloadRowValue()
                    case "TEAM: TIMES SACKED":
                        timesSackedTeam1SliderValue = row.value!
                        self.reloadRowValue()
                    case "OPPONENT: TIMES SACKED":
                        timesSackedTeam2SliderValue = row.value!
                        self.reloadRowValue()
                    case "TEAM: INTERCEPTIONS THROWN":
                        interceptionsThrownTeam1SliderValue = row.value!
                        self.reloadRowValue()
                    case "OPPONENT: INTERCEPTIONS THROWN":
                        interceptionsThrownTeam2SliderValue = row.value!
                        self.reloadRowValue()
                    case "TEAM: OFFENSIVE PLAYS":
                        offensivePlaysTeam1SliderValue = row.value!
                        self.reloadRowValue()
                    case "OPPONENT: OFFENSIVE PLAYS":
                        offensivePlaysTeam2SliderValue = row.value!
                        self.reloadRowValue()
                    case "TEAM: YARDS/OFFENSIVE PLAY":
                        yardsPerOffensivePlayTeam1SliderValue = row.value!
                        self.reloadRowValue()
                    case "OPPONENT: YARDS/OFFENSIVE PLAY":
                        yardsPerOffensivePlayTeam2SliderValue = row.value!
                        self.reloadRowValue()
                    case "TEAM: SACKS":
                        sacksTeam1SliderValue = row.value!
                        self.reloadRowValue()
                    case "OPPONENT: SACKS":
                        sacksTeam2SliderValue = row.value!
                        self.reloadRowValue()
                    case "TEAM: INTERCEPTIONS":
                        interceptionsTeam1SliderValue = row.value!
                        self.reloadRowValue()
                    case "OPPONENT: INTERCEPTIONS":
                        interceptionsTeam2SliderValue = row.value!
                        self.reloadRowValue()
                    case "TEAM: SAFETIES":
                        safetiesTeam1SliderValue = row.value!
                        self.reloadRowValue()
                    case "OPPONENT: SAFETIES":
                        safetiesTeam2SliderValue = row.value!
                        self.reloadRowValue()
                    case "TEAM: DEFENSIVE PLAYS":
                        defensivePlaysTeam1SliderValue = row.value!
                        self.reloadRowValue()
                    case "OPPONENT: DEFENSIVE PLAYS":
                        defensivePlaysTeam2SliderValue = row.value!
                        self.reloadRowValue()
                    case "TEAM: YARDS/DEFENSIVE PLAY":
                        yardsPerDefensivePlayTeam1SliderValue = row.value!
                        self.reloadRowValue()
                    case "OPPONENT: YARDS/DEFENSIVE PLAY":
                        yardsPerDefensivePlayTeam2SliderValue = row.value!
                        self.reloadRowValue()
                    case "TEAM: EXTRA POINT ATTEMPTS":
                        extraPointAttemptsTeam1SliderValue = row.value!
                        self.reloadRowValue()
                    case "OPPONENT: EXTRA POINT ATTEMPTS":
                        extraPointAttemptsTeam2SliderValue = row.value!
                        self.reloadRowValue()
                    case "TEAM: EXTRA POINTS MADE":
                        extraPointsMadeTeam1SliderValue = row.value!
                        self.reloadRowValue()
                    case "OPPONENT: EXTRA POINTS MADE":
                        extraPointsMadeTeam2SliderValue = row.value!
                        self.reloadRowValue()
                    case "TEAM: FIELD GOAL ATTEMPTS":
                        fieldGoalAttemptsTeam1SliderValue = row.value!
                        self.reloadRowValue()
                    case "OPPONENT: FIELD GOAL ATTEMPTS":
                        fieldGoalAttemptsTeam2SliderValue = row.value!
                        self.reloadRowValue()
                    case "TEAM: FIELD GOALS MADE":
                        fieldGoalsMadeTeam1SliderValue = row.value!
                        self.reloadRowValue()
                    case "OPPONENT: FIELD GOALS MADE":
                        fieldGoalsMadeTeam2SliderValue = row.value!
                        self.reloadRowValue()
                    case "TEAM: PUNTS":
                        puntsTeam1SliderValue = row.value!
                        self.reloadRowValue()
                    case "OPPONENT: PUNTS":
                        puntsTeam2SliderValue = row.value!
                        self.reloadRowValue()
                    case "TEAM: PUNT YARDS":
                        puntYardsTeam1SliderValue = row.value!
                        self.reloadRowValue()
                    case "OPPONENT: PUNT YARDS":
                        puntYardsTeam2SliderValue = row.value!
                        self.reloadRowValue()
                    default:
                        rowValue = Float(-10000)
                    }

        }
        
        switch (formRangeSliderLowerValue) {
        case Float(-10000):
            rangeSliderObject.minimumValue = Double(sliderValues.first!)
            rangeSliderObject.lowerValue = Double(sliderValues.first!)
            if tagText == "TEAM: SPREAD" || tagText == "OVER/UNDER" {
                rangeSliderObject.stepValue = 0.5
            } else if tagText == "TEAM: TOTAL YARDS" || tagText == "OPPONENT: TOTAL YARDS" || tagText == "TEAM: PASSING YARDS" || tagText == "OPPONENT: PASSING YARDS" || tagText == "TEAM: RUSHING YARDS" || tagText == "OPPONENT: RUSHING YARDS" {
                rangeSliderObject.stepValue = 10.0
            } else {
                rangeSliderObject.stepValue = 1.0
            }
        default:
            rangeSliderObject.minimumValue = Double(sliderValues.first!)
            rangeSliderObject.lowerValue = Double(formRangeSliderLowerValue)
            if tagText == "TEAM: SPREAD" || tagText == "OVER/UNDER" {
                rangeSliderObject.stepValue = 0.5
            } else if tagText == "TEAM: TOTAL YARDS" || tagText == "OPPONENT: TOTAL YARDS" || tagText == "TEAM: PASSING YARDS" || tagText == "OPPONENT: PASSING YARDS" || tagText == "TEAM: RUSHING YARDS" || tagText == "OPPONENT: RUSHING YARDS" {
                rangeSliderObject.stepValue = 10.0
            } else {
                rangeSliderObject.stepValue = 1.0
            }
        }
        
        switch (formRangeSliderUpperValue) {
        case Float(-10000):
            rangeSliderObject.maximumValue = Double(sliderValues.last!)
            rangeSliderObject.upperValue = Double(sliderValues.last!)
            if tagText == "TEAM: SPREAD" || tagText == "OVER/UNDER" {
                rangeSliderObject.stepValue = 0.5
            } else if tagText == "TEAM: TOTAL YARDS" || tagText == "OPPONENT: TOTAL YARDS" || tagText == "TEAM: PASSING YARDS" || tagText == "OPPONENT: PASSING YARDS" || tagText == "TEAM: RUSHING YARDS" || tagText == "OPPONENT: RUSHING YARDS" {
                rangeSliderObject.stepValue = 10.0
            } else {
                rangeSliderObject.stepValue = 1.0
            }
        default:
            rangeSliderObject.maximumValue = Double(sliderValues.last!)
            rangeSliderObject.upperValue = Double(formRangeSliderUpperValue)
            if tagText == "TEAM: SPREAD" || tagText == "OVER/UNDER" {
                rangeSliderObject.stepValue = 0.5
            } else if tagText == "TEAM: TOTAL YARDS" || tagText == "OPPONENT: TOTAL YARDS" || tagText == "TEAM: PASSING YARDS" || tagText == "OPPONENT: PASSING YARDS" || tagText == "TEAM: RUSHING YARDS" || tagText == "OPPONENT: RUSHING YARDS" {
                rangeSliderObject.stepValue = 10.0
            } else {
                rangeSliderObject.stepValue = 1.0
            }
        }
        
        self.view.backgroundColor = darkGreyColor
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = darkGreyColor
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.toolbar.isHidden = true
        self.title = nil
        buttonView.titleLabel?.textColor = lightMediumGreyColor
        buttonView.frame = CGRect(x: 20, y: screenHeight * 0.01, width: screenWidth - 40.0, height: 38.0)
        buttonView.backgroundColor = mediumGreyColor
        buttonView.titleLabel?.textColor = lightGreyColorButton
        buttonView.titleLabel?.contentMode = .center
        buttonView.titleLabel?.lineBreakMode = .byTruncatingTail
        buttonView?.titleLabel?.textAlignment = .center
        //print("rangeBoolean: ")
        //print(rangeBoolean)
        switch (rangeBoolean) {
        case false:
            if formSliderValue == Float(-10000) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = self.headerLabel + "\0" + operatorText + String(Int(formSliderValue))
            }
            switch (tagText) {
            case "TEAM: STREAK":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: STREAK":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: SEASON WIN %":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue)) + "%"
            case "OPPONENT: SEASON WIN %":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue)) + "%"
            case "SEASON":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: SPREAD":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(format: "%.1f", formSliderValue)
            case "OVER/UNDER":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(format: "%.1f", formSliderValue)
            case "WEEK":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "GAME NUMBER":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEMPERATURE":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue)) + "°"
            case "TEAM: TOTAL POINTS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: TOTAL POINTS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: TOUCHDOWNS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: TOUCHDOWNS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            
            case "TEAM: OFFENSIVE TOUCHDOWNS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: OFFENSIVE TOUCHDOWNS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: DEFENSIVE TOUCHDOWNS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: DEFENSIVE TOUCHDOWNS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
                
            case "TEAM: TURNOVERS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: TURNOVERS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: PENALTIES":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: PENALTIES":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: TOTAL YARDS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: TOTAL YARDS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: PASSING YARDS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: PASSING YARDS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: RUSHING YARDS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: RUSHING YARDS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: QUARTERBACK RATING":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: QUARTERBACK RATING":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: TIMES SACKED":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: TIMES SACKED":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: INTERCEPTIONS THROWN":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: INTERCEPTIONS THROWN":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: OFFENSIVE PLAYS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: OFFENSIVE PLAYS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: YARDS/OFFENSIVE PLAY":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: YARDS/OFFENSIVE PLAY":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: SACKS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: SACKS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: INTERCEPTIONS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: INTERCEPTIONS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: SAFETIES":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: SAFETIES":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: DEFENSIVE PLAYS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: DEFENSIVE PLAYS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: YARDS/DEFENSIVE PLAY":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: YARDS/DEFENSIVE PLAY":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: EXTRA POINT ATTEMPTS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: EXTRA POINT ATTEMPTS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: EXTRA POINTS MADE":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: EXTRA POINTS MADE":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: FIELD GOAL ATTEMPTS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: FIELD GOAL ATTEMPTS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: FIELD GOALS MADE":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: PUNTS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: PUNTS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: PUNT YARDS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            case "OPPONENT: PUNT YARDS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            default:
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            }
        case true:
            sliderValue = operatorDictionary[formOperatorValue]! + String(Int(formSliderValue))
            if (rangeSliderObject.lowerValue == Double(sliderValues.first!) && rangeSliderObject.upperValue == Double(sliderValues.last!)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = self.headerLabel + "\0" + operatorText + String(Int(rangeSliderObject.lowerValue)) + " & " + String(Int(rangeSliderObject.upperValue))
            }
            switch (tagText) {
            case "TEAM: STREAK":
                var formRangeSliderLowerValuePrefix: String = ""
                var formRangeSliderUpperValuePrefix: String = ""
                if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) || (formRangeSliderLowerValue == -10000 && formRangeSliderUpperValue == -10000) {
                    buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
                } else {
                    if Int(formRangeSliderLowerValue) > 1 {
                        formRangeSliderLowerValuePrefix = "+"
                    } else {
                        formRangeSliderLowerValuePrefix = ""
                    }
                    if Int(formRangeSliderUpperValue) > 1 {
                        formRangeSliderUpperValuePrefix = "+"
                    } else {
                        formRangeSliderUpperValuePrefix = ""
                    }
                    buttonText = headerLabel + "\0" + formOperatorText + formRangeSliderLowerValuePrefix + String(Int(formRangeSliderLowerValue)) + " & " + formRangeSliderUpperValuePrefix + String(Int(formRangeSliderUpperValue))
                }
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + formRangeSliderLowerValuePrefix + String(Int(formRangeSliderLowerValue)) + " & " + formRangeSliderUpperValuePrefix + String(Int(formRangeSliderUpperValue))
            case "OPPONENT: STREAK":
                var formRangeSliderLowerValuePrefix: String = ""
                var formRangeSliderUpperValuePrefix: String = ""
                if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) || (formRangeSliderLowerValue == -10000 && formRangeSliderUpperValue == -10000) {
                    buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
                } else {
                    if Int(formRangeSliderLowerValue) < 1 {
                        formRangeSliderLowerValuePrefix = "-"
                    } else if Int(formRangeSliderLowerValue) > 1 {
                        formRangeSliderLowerValuePrefix = "+"
                    } else {
                        formRangeSliderLowerValuePrefix = ""
                    }
                    if Int(formRangeSliderUpperValue) < 1 {
                        formRangeSliderUpperValuePrefix = "-"
                    } else if Int(formRangeSliderUpperValue) > 1 {
                        formRangeSliderUpperValuePrefix = "+"
                    } else {
                        formRangeSliderUpperValuePrefix = ""
                    }
                    buttonText = headerLabel + "\0" + formOperatorText + formRangeSliderLowerValuePrefix + String(Int(formRangeSliderLowerValue)) + " & " + formRangeSliderUpperValuePrefix + String(Int(formRangeSliderUpperValue))
                }
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + formRangeSliderLowerValuePrefix + String(Int(formRangeSliderLowerValue)) + " & " + formRangeSliderUpperValuePrefix + String(Int(formRangeSliderUpperValue))
            case "TEAM: SEASON WIN %":
                if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) || (formRangeSliderLowerValue == -10000 && formRangeSliderUpperValue == -10000) {
                    buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
                } else {
                    buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + "%" + " & " + String(Int(formRangeSliderUpperValue)) + "%"
                }
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formRangeSliderLowerValue)) + "%" + " & " + String(Int(formRangeSliderUpperValue)) + "%"
            case "OPPONENT: SEASON WIN %":
                if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) || (formRangeSliderLowerValue == -10000 && formRangeSliderUpperValue == -10000) {
                    buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
                } else {
                    buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + "%" + " & " + String(Int(formRangeSliderUpperValue)) + "%"
                }
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formRangeSliderLowerValue)) + "%" + " & " + String(Int(formRangeSliderUpperValue)) + "%"
            case "SEASON":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: SPREAD":
                if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) || (formRangeSliderLowerValue == -10000 && formRangeSliderUpperValue == -10000) {
                    buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
                } else {
                    buttonText = headerLabel + "\0" + formOperatorText + String(format: "%.1f", formRangeSliderLowerValue) + " & " + String(format: "%.1f", formRangeSliderUpperValue)
                }
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(format: "%.1f", formRangeSliderLowerValue) + " & " + String(format: "%.1f", formRangeSliderUpperValue)
            case "OVER/UNDER":
                if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) || (formRangeSliderLowerValue == -10000 && formRangeSliderUpperValue == -10000) {
                    buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
                } else {
                    buttonText = headerLabel + "\0" + formOperatorText + String(format: "%.1f", formRangeSliderLowerValue) + " & " + String(format: "%.1f", formRangeSliderUpperValue)
                }
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(format: "%.1f", formRangeSliderLowerValue) + " & " + String(format: "%.1f", formRangeSliderUpperValue)
            case "WEEK":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "GAME NUMBER":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEMPERATURE":
                if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) || (formRangeSliderLowerValue == -10000 && formRangeSliderUpperValue == -10000) {
                    buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
                } else {
                    buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + "°" + " & " + String(Int(formRangeSliderUpperValue)) + "°"
                }
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue)) + "°"
            case "TEAM: TOTAL POINTS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: TOTAL POINTS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: TOUCHDOWNS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: TOUCHDOWNS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
                
            case "TEAM: OFFENSIVE TOUCHDOWNS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: OFFENSIVE TOUCHDOWNS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: DEFENSIVE TOUCHDOWNS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: DEFENSIVE TOUCHDOWNS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
                
            case "TEAM: TURNOVERS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: TURNOVERS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: PENALTIES":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: PENALTIES":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: TOTAL YARDS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: TOTAL YARDS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: PASSING YARDS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: PASSING YARDS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: RUSHING YARDS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: RUSHING YARDS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: QUARTERBACK RATING":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: QUARTERBACK RATING":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: TIMES SACKED":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: TIMES SACKED":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: INTERCEPTIONS THROWN":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: INTERCEPTIONS THROWN":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: OFFENSIVE PLAYS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: OFFENSIVE PLAYS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: YARDS/OFFENSIVE PLAY":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: YARDS/OFFENSIVE PLAY":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: SACKS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: SACKS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: INTERCEPTIONS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: INTERCEPTIONS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: SAFETIES":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: SAFETIES":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: DEFENSIVE PLAYS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: DEFENSIVE PLAYS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: YARDS/DEFENSIVE PLAY":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: YARDS/DEFENSIVE PLAY":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: EXTRA POINT ATTEMPTS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: EXTRA POINT ATTEMPTS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: EXTRA POINTS MADE":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: EXTRA POINTS MADE":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.5, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: FIELD GOAL ATTEMPTS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: FIELD GOAL ATTEMPTS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: FIELD GOALS MADE":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.5, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: PUNTS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "OPPONENT: PUNTS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            case "TEAM: PUNT YARDS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            case "OPPONENT: PUNT YARDS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            default:
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValue = operatorText + String(Int(formSliderValue))
            }
        }
        buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
        buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
        self.view.addSubview(buttonView)
        //self.tableView.frame = CGRect(x: 0, y: buttonView.frame.maxY + 2.5, width: screenWidth, height: self.view.frame.height)
        //self.tableView.frame = CGRect(x: 0, y: buttonView.frame.maxY + 5.0, width: screenWidth, height: self.view.frame.height / 2.5)
        self.tableView.frame = CGRect(x: 0, y: buttonView.frame.maxY, width: screenWidth, height: self.view.frame.height)
        //print("Portrait screenWidth & screenHeight: ")
        //print(UIScreen.main.bounds.width)
        //print(UIScreen.main.bounds.height)
        let formSliderRow: SliderRow = self.form.rowBy(tag: "SLIDER")!
        formSliderRow.cell.slider.frame = CGRect(x: CGFloat(frameX), y: CGFloat(sliderFrameHeightRatio * Float(UIScreen.main.bounds.height)), width: UIScreen.main.bounds.width - CGFloat(frameX * 2), height: CGFloat(frameHeight))
        rangeSliderObject.frame = CGRect(x: CGFloat(frameX + 2.0), y: CGFloat(rangeSliderFrameHeightRatio * Float(UIScreen.main.bounds.height)), width: UIScreen.main.bounds.width - CGFloat((frameX + 2.0) * 2), height: CGFloat(frameHeight))
        rangeSliderObject.knobSize = rangeSliderObject.frame.height + (4.0/3.0)
        //print(formSliderRow.cell.slider.frame)
        //print(rangeSliderObject.frame)
        rangeSliderObject.knobTintColor = silverColor
        rangeSliderObject.labelFontSize = CGFloat(12.5)
        rangeSliderObject.labelColor = silverColor
        rangeSliderObject.addTarget(self, action: #selector(setRangeSliderValues), for: .touchUpInside)
        self.view.addSubview(rangeSliderObject)
        if rangeSliderObject.isHidden == false {
            let formSliderRow: SliderRow = self.form.rowBy(tag: "SLIDER")!
            formSliderRow.hidden = true
            formSliderRow.evaluateHidden()
        } else {
            rangeBoolean = false
        }
    }
    
    @objc func setRangeSliderValues() {
        //print("setRangeSliderValues()")
        if tagText == "TEAM: SPREAD" || tagText == "OVER/UNDER" {
            rangeSliderObject.stepValue = 0.5
        } else if tagText == "TEAM: TOTAL YARDS" || tagText == "OPPONENT: TOTAL YARDS" || tagText == "TEAM: PASSING YARDS" || tagText == "OPPONENT: PASSING YARDS" || tagText == "TEAM: RUSHING YARDS" || tagText == "OPPONENT: RUSHING YARDS" {
            rangeSliderObject.stepValue = 10.0
        } else {
            rangeSliderObject.stepValue = 1.0
        }
        reloadRowValue()
    }
    
    func rangeSliderActivated() {
        //print("rangeSliderActivated()")
        let formSliderRow: SliderRow = self.form.rowBy(tag: "SLIDER")!
        formSliderRow.hidden = true
        formSliderRow.evaluateHidden()
        rangeBoolean = true
        rangeSliderObject.minimumValue = Double(sliderValues.first!)
        rangeSliderObject.lowerValue = Double(sliderValues.first!)
        rangeSliderObject.maximumValue = Double(sliderValues.last!)
        rangeSliderObject.upperValue = Double(sliderValues.last!)
        if tagText == "TEAM: SPREAD" || tagText == "OVER/UNDER" {
            rangeSliderObject.stepValue = 0.5
        } else if tagText == "TEAM: TOTAL YARDS" || tagText == "OPPONENT: TOTAL YARDS" || tagText == "TEAM: PASSING YARDS" || tagText == "OPPONENT: PASSING YARDS" || tagText == "TEAM: RUSHING YARDS" || tagText == "OPPONENT: RUSHING YARDS" {
            rangeSliderObject.stepValue = 10.0
        } else {
            rangeSliderObject.stepValue = 1.0
        }
        reloadRowValue()
    }
    
    func singleSelectionSliderActivated() {
        //print("singleSelectionSliderActivated()")
        let formSliderRow: SliderRow = self.form.rowBy(tag: "SLIDER")!
        formSliderRow.hidden = false
        formSliderRow.evaluateHidden()
        rangeBoolean = false
        formSliderRow.cell.update()
        //print(formSliderRow.cell.slider.frame)
        //print("singleSelectionSliderActivated")
        reloadRowValue()
    }
    
    @objc func reloadRowValue() {
        print("reloadRowValue()")
        
        switch (tagText, rangeBoolean) {
        case ("TEAM: STREAK", false):
            //operatorText = operatorDictionary[selectedOperatorValue]!
            //winningLosingStreakTeam1SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                winningLosingStreakTeam1SliderValue = winningLosingStreakTeam1Values.last!
            }
            winningLosingStreakTeam1OperatorValue = selectedOperatorValue
            winningLosingStreakTeam1OperatorText = operatorText
            formSliderValue = winningLosingStreakTeam1SliderValue
            formOperatorValue = winningLosingStreakTeam1OperatorValue
            formOperatorText = winningLosingStreakTeam1OperatorText
            var formSliderValuePrefix: String = ""
            if Int(formSliderValue) > 0 {
               formSliderValuePrefix = "+"
            } else {
                formSliderValuePrefix = ""
            }
            buttonText = headerLabel + "\0" + formOperatorText + formSliderValuePrefix + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(winningLosingStreakTeam1SliderValue))
            winningLosingStreakTeam1SliderFormValue = formSliderValuePrefix + String(Int(winningLosingStreakTeam1SliderValue))
        case ("TEAM: STREAK", true):
            operatorText = operatorDictionary["< >"]!
            winningLosingStreakTeam1RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            winningLosingStreakTeam1RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            winningLosingStreakTeam1OperatorValue = "< >"
            winningLosingStreakTeam1OperatorText = operatorText
            formRangeSliderLowerValue = winningLosingStreakTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = winningLosingStreakTeam1RangeSliderUpperValue
            formOperatorValue = winningLosingStreakTeam1OperatorValue
            formOperatorText = winningLosingStreakTeam1OperatorText
            var formRangeSliderLowerValuePrefix: String = ""
            var formRangeSliderUpperValuePrefix: String = ""
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                if Int(formRangeSliderLowerValue) > 1 {
                    formRangeSliderLowerValuePrefix = "+"
                } else {
                    formRangeSliderLowerValuePrefix = ""
                }
                if Int(formRangeSliderUpperValue) > 1 {
                    formRangeSliderUpperValuePrefix = "+"
                } else {
                    formRangeSliderUpperValuePrefix = ""
                }
                buttonText = headerLabel + "\0" + formOperatorText + formRangeSliderLowerValuePrefix + String(Int(formRangeSliderLowerValue)) + " & " + formRangeSliderUpperValuePrefix + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            winningLosingStreakTeam1SliderFormValue = formRangeSliderLowerValuePrefix + String(Int(winningLosingStreakTeam1RangeSliderLowerValue)) + " & " + formRangeSliderUpperValuePrefix + String(Int(winningLosingStreakTeam1RangeSliderUpperValue))
        case ("OPPONENT: STREAK", false):
            //operatorText = operatorDictionary["< >"]!
            //winningLosingStreakTeam2SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                winningLosingStreakTeam2SliderValue = winningLosingStreakTeam2Values.last!
            }
            winningLosingStreakTeam2OperatorValue = selectedOperatorValue
            winningLosingStreakTeam2OperatorText = operatorText
            formSliderValue = winningLosingStreakTeam2SliderValue
            formOperatorValue = winningLosingStreakTeam2OperatorValue
            formOperatorText = winningLosingStreakTeam2OperatorText
            var formSliderValuePrefix: String = ""
            if Int(formSliderValue) > 0 {
                formSliderValuePrefix = "+"
            } else {
                formSliderValuePrefix = ""
            }
            buttonText = headerLabel + "\0" + formOperatorText + formSliderValuePrefix + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(winningLosingStreakTeam2SliderValue))
            winningLosingStreakTeam2SliderFormValue = formSliderValuePrefix + String(Int(winningLosingStreakTeam2SliderValue))
        case ("OPPONENT: STREAK", true):
            operatorText = operatorDictionary["< >"]!
            winningLosingStreakTeam2RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            winningLosingStreakTeam2RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            winningLosingStreakTeam2OperatorValue = "< >"
            winningLosingStreakTeam2OperatorText = operatorText
            formRangeSliderLowerValue = winningLosingStreakTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = winningLosingStreakTeam2RangeSliderUpperValue
            formOperatorValue = winningLosingStreakTeam2OperatorValue
            formOperatorText = winningLosingStreakTeam2OperatorText
            var formRangeSliderLowerValuePrefix: String = ""
            var formRangeSliderUpperValuePrefix: String = ""
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                if Int(formRangeSliderLowerValue) > 1 {
                    formRangeSliderLowerValuePrefix = "+"
                } else {
                    formRangeSliderLowerValuePrefix = ""
                }
                if Int(formRangeSliderUpperValue) > 1 {
                    formRangeSliderUpperValuePrefix = "+"
                } else {
                    formRangeSliderUpperValuePrefix = ""
                }
                buttonText = headerLabel + "\0" + formOperatorText + formRangeSliderLowerValuePrefix + String(Int(formRangeSliderLowerValue)) + " & " + formRangeSliderUpperValuePrefix + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            winningLosingStreakTeam2SliderFormValue = formRangeSliderLowerValuePrefix + String(Int(winningLosingStreakTeam2RangeSliderLowerValue)) + " & " + formRangeSliderUpperValuePrefix + String(Int(winningLosingStreakTeam2RangeSliderUpperValue))
        case ("TEAM: SEASON WIN %", false):
            //operatorText = operatorDictionary["< >"]!
            //seasonWinPercentageTeam1SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                seasonWinPercentageTeam1SliderValue = seasonWinPercentageTeam1Values.last!
            }
            seasonWinPercentageTeam1OperatorValue = selectedOperatorValue
            seasonWinPercentageTeam1OperatorText = operatorText
            formSliderValue = seasonWinPercentageTeam1SliderValue
            formOperatorValue = seasonWinPercentageTeam1OperatorValue
            formOperatorText = seasonWinPercentageTeam1OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue)) + "%"
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(seasonWinPercentageTeam1SliderValue))
            seasonWinPercentageTeam1SliderFormValue = String(Int(seasonWinPercentageTeam1SliderValue)) + "%"
        case ("TEAM: SEASON WIN %", true):
            operatorText = operatorDictionary["< >"]!
            seasonWinPercentageTeam1RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            seasonWinPercentageTeam1RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            seasonWinPercentageTeam1OperatorValue = "< >"
            seasonWinPercentageTeam1OperatorText = operatorText
            formRangeSliderLowerValue = seasonWinPercentageTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = seasonWinPercentageTeam1RangeSliderUpperValue
            formOperatorValue = seasonWinPercentageTeam1OperatorValue
            formOperatorText = seasonWinPercentageTeam1OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + "%" + " & " + String(Int(formRangeSliderUpperValue)) + "%"
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            seasonWinPercentageTeam1SliderFormValue = String(Int(seasonWinPercentageTeam1RangeSliderLowerValue)) + "%" + " & " + String(Int(seasonWinPercentageTeam1RangeSliderUpperValue)) + "%"
        case ("OPPONENT: SEASON WIN %", false):
            //operatorText = operatorDictionary["< >"]!
            //seasonWinPercentageTeam2SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                seasonWinPercentageTeam2SliderValue = seasonWinPercentageTeam2Values.last!
            }
            seasonWinPercentageTeam2OperatorValue = selectedOperatorValue
            seasonWinPercentageTeam2OperatorText = operatorText
            formSliderValue = seasonWinPercentageTeam2SliderValue
            formOperatorValue = seasonWinPercentageTeam2OperatorValue
            formOperatorText = seasonWinPercentageTeam2OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue)) + "%"
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(seasonWinPercentageTeam2SliderValue))
            seasonWinPercentageTeam2SliderFormValue = String(Int(seasonWinPercentageTeam2SliderValue)) + "%"
        case ("OPPONENT: SEASON WIN %", true):
            operatorText = operatorDictionary["< >"]!
            seasonWinPercentageTeam2RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            seasonWinPercentageTeam2RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            seasonWinPercentageTeam2OperatorValue = "< >"
            seasonWinPercentageTeam2OperatorText = operatorText
            formRangeSliderLowerValue = seasonWinPercentageTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = seasonWinPercentageTeam2RangeSliderUpperValue
            formOperatorValue = seasonWinPercentageTeam2OperatorValue
            formOperatorText = seasonWinPercentageTeam2OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + "%" + " & " + String(Int(formRangeSliderUpperValue)) + "%"
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            seasonWinPercentageTeam2SliderFormValue = String(Int(seasonWinPercentageTeam2RangeSliderLowerValue)) + "%" + " & " + String(Int(seasonWinPercentageTeam2RangeSliderUpperValue)) + "%"
        case ("SEASON", false):
            if formSliderValue == Float(-10000) {
                seasonSliderValue = seasonValues.last!
            }
            seasonOperatorValue = selectedOperatorValue
            seasonOperatorText = operatorText
            formSliderValue = seasonSliderValue
            formOperatorValue = seasonOperatorValue
            formOperatorText = seasonOperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(seasonSliderValue))
            seasonSliderFormValue = String(Int(seasonSliderValue))
            print("seasonSliderFormValue: ")
            print(seasonSliderFormValue)
        case ("SEASON", true):
            operatorText = operatorDictionary["< >"]!
            seasonRangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            seasonRangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            seasonOperatorValue = "< >"
            seasonOperatorText = operatorText
            formRangeSliderLowerValue = seasonRangeSliderLowerValue
            formRangeSliderUpperValue = seasonRangeSliderUpperValue
            formOperatorValue = seasonOperatorValue
            formOperatorText = seasonOperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            seasonSliderFormValue = String(Int(seasonRangeSliderLowerValue)) + " & " + String(Int(seasonRangeSliderUpperValue))
        case ("GAME NUMBER", false):
            //operatorText = operatorDictionary["< >"]!
            //gameNumberSliderValue = rowValue
            if formSliderValue == Float(-10000) {
                gameNumberSliderValue = gameNumberValues.last!
            }
            gameNumberOperatorValue = selectedOperatorValue
            gameNumberOperatorText = operatorText
            formSliderValue = gameNumberSliderValue
            formOperatorValue = gameNumberOperatorValue
            formOperatorText = gameNumberOperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(gameNumberSliderValue))
            gameNumberSliderFormValue = String(Int(gameNumberSliderValue))
        case ("GAME NUMBER", true):
            operatorText = operatorDictionary["< >"]!
            gameNumberRangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            gameNumberRangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            gameNumberOperatorValue = "< >"
            gameNumberOperatorText = operatorText
            formRangeSliderLowerValue = gameNumberRangeSliderLowerValue
            formRangeSliderUpperValue = gameNumberRangeSliderUpperValue
            formOperatorValue = gameNumberOperatorValue
            formOperatorText = gameNumberOperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            gameNumberSliderFormValue = String(Int(gameNumberRangeSliderLowerValue)) + " & " + String(Int(gameNumberRangeSliderUpperValue))
        case ("WEEK", false):
            //operatorText = operatorDictionary["< >"]!
            //weekSliderValue = rowValue
            if formSliderValue == Float(-10000) {
                weekSliderValue = weekValues.last!
            }
            weekOperatorValue = selectedOperatorValue
            weekOperatorText = operatorText
            formSliderValue = weekSliderValue
            formOperatorValue = weekOperatorValue
            formOperatorText = weekOperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(weekSliderValue))
            weekSliderFormValue = String(Int(weekSliderValue))
        case ("WEEK", true):
            operatorText = operatorDictionary["< >"]!
            weekRangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            weekRangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            weekOperatorValue = "< >"
            weekOperatorText = operatorText
            formRangeSliderLowerValue = weekRangeSliderLowerValue
            formRangeSliderUpperValue = weekRangeSliderUpperValue
            formOperatorValue = weekOperatorValue
            formOperatorText = weekOperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            weekSliderFormValue = String(Int(weekRangeSliderLowerValue)) + " & " + String(Int(weekRangeSliderUpperValue))
        case ("TEAM: SPREAD", false):
            //operatorText = operatorDictionary["< >"]!
            //spreadSliderValue = rowValue
            if formSliderValue == Float(-10000) {
                spreadSliderValue = spreadValues.last!
            }
            spreadOperatorValue = selectedOperatorValue
            spreadOperatorText = operatorText
            formSliderValue = spreadSliderValue
            formOperatorValue = spreadOperatorValue
            formOperatorText = spreadOperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(format: "%.1f", formSliderValue)
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(format: "%.1f", spreadSliderValue)
            spreadSliderFormValue = String(format: "%.1f", spreadSliderValue)
        case ("TEAM: SPREAD", true):
            operatorText = operatorDictionary["< >"]!
            spreadRangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            spreadRangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            spreadOperatorValue = "< >"
            spreadOperatorText = operatorText
            formRangeSliderLowerValue = spreadRangeSliderLowerValue
            formRangeSliderUpperValue = spreadRangeSliderUpperValue
            formOperatorValue = spreadOperatorValue
            formOperatorText = spreadOperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(format: "%.1f", formRangeSliderLowerValue) + " & " + String(format: "%.1f", formRangeSliderUpperValue)
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(format: "%.1f", formRangeSliderLowerValue) + " & " + String(format: "%.1f", formRangeSliderUpperValue)
            spreadSliderFormValue = String(format: "%.1f", spreadRangeSliderLowerValue) + " & " + String(format: "%.1f", spreadRangeSliderUpperValue)
        case ("OVER/UNDER", false):
            //operatorText = operatorDictionary["< >"]!
            //overUnderSliderValue = rowValue
            if formSliderValue == Float(-10000) {
                overUnderSliderValue = overUnderValues.last!
            }
            overUnderOperatorValue = selectedOperatorValue
            overUnderOperatorText = operatorText
            formSliderValue = overUnderSliderValue
            formOperatorValue = overUnderOperatorValue
            formOperatorText = overUnderOperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(format: "%.1f", formSliderValue)
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(format: "%.1f", overUnderSliderValue)
            overUnderSliderFormValue = String(format: "%.1f", overUnderSliderValue)
            print("overUnderSliderValue: ")
            print(overUnderSliderValue)
        case ("OVER/UNDER", true):
            operatorText = operatorDictionary["< >"]!
            overUnderRangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            overUnderRangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            overUnderOperatorValue = "< >"
            overUnderOperatorText = operatorText
            formRangeSliderLowerValue = overUnderRangeSliderLowerValue
            formRangeSliderUpperValue = overUnderRangeSliderUpperValue
            formOperatorValue = overUnderOperatorValue
            formOperatorText = overUnderOperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(format: "%.1f", formRangeSliderLowerValue) + " & " + String(format: "%.1f", formRangeSliderUpperValue)
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count)) 
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(format: "%.1f", formRangeSliderLowerValue) + " & " + String(format: "%.1f", formRangeSliderUpperValue)
            overUnderSliderFormValue = String(format: "%.1f", overUnderRangeSliderLowerValue) + " & " + String(format: "%.1f", overUnderRangeSliderUpperValue)
        case ("TEMPERATURE (F)", false):
            //operatorText = operatorDictionary["< >"]!
            //temperatureSliderValue = rowValue
            if formSliderValue == Float(-10000) {
                temperatureSliderValue = temperatureValues.last!
            }
            temperatureOperatorValue = selectedOperatorValue
            temperatureOperatorText = operatorText
            formSliderValue = temperatureSliderValue
            formOperatorValue = temperatureOperatorValue
            formOperatorText = temperatureOperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue)) + "°"
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(temperatureSliderValue))
            temperatureSliderFormValue = String(Int(temperatureSliderValue)) + "°"
        case ("TEMPERATURE (F)", true):
            operatorText = operatorDictionary["< >"]!
            temperatureRangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            temperatureRangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            temperatureOperatorValue = "< >"
            temperatureOperatorText = operatorText
            formRangeSliderLowerValue = temperatureRangeSliderLowerValue
            formRangeSliderUpperValue = temperatureRangeSliderUpperValue
            formOperatorValue = temperatureOperatorValue
            formOperatorText = temperatureOperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + "°" + " & " + String(Int(formRangeSliderUpperValue)) + "°"
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            temperatureSliderFormValue = String(Int(temperatureRangeSliderLowerValue)) + "°" + " & " + String(Int(temperatureRangeSliderUpperValue)) + "°"
        case ("TEAM: TOTAL POINTS", false):
            //operatorText = operatorDictionary["< >"]!
            //totalPointsTeam1SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                totalPointsTeam1SliderValue = totalPointsTeam1Values.last!
            }
            totalPointsTeam1OperatorValue = selectedOperatorValue
            totalPointsTeam1OperatorText = operatorText
            formSliderValue = totalPointsTeam1SliderValue
            formOperatorValue = totalPointsTeam1OperatorValue
            formOperatorText = totalPointsTeam1OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(totalPointsTeam1SliderValue))
            totalPointsTeam1SliderFormValue = String(Int(totalPointsTeam1SliderValue))
        case ("TEAM: TOTAL POINTS", true):
            operatorText = operatorDictionary["< >"]!
            totalPointsTeam1RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            totalPointsTeam1RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            totalPointsTeam1OperatorValue = "< >"
            totalPointsTeam1OperatorText = operatorText
            formRangeSliderLowerValue = totalPointsTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = totalPointsTeam1RangeSliderUpperValue
            formOperatorValue = totalPointsTeam1OperatorValue
            formOperatorText = totalPointsTeam1OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            totalPointsTeam1SliderFormValue = String(Int(totalPointsTeam1RangeSliderLowerValue)) + " & " + String(Int(totalPointsTeam1RangeSliderUpperValue))
        case ("OPPONENT: TOTAL POINTS", false):
            //operatorText = operatorDictionary["< >"]!
            //totalPointsTeam2SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                totalPointsTeam2SliderValue = totalPointsTeam2Values.last!
            }
            totalPointsTeam2OperatorValue = selectedOperatorValue
            totalPointsTeam2OperatorText = operatorText
            formSliderValue = totalPointsTeam2SliderValue
            formOperatorValue = totalPointsTeam2OperatorValue
            formOperatorText = totalPointsTeam2OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(totalPointsTeam2SliderValue))
            totalPointsTeam2SliderFormValue = String(Int(totalPointsTeam2SliderValue))
        case ("OPPONENT: TOTAL POINTS", true):
            operatorText = operatorDictionary["< >"]!
            totalPointsTeam2RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            totalPointsTeam2RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            totalPointsTeam2OperatorValue = "< >"
            totalPointsTeam2OperatorText = operatorText
            formRangeSliderLowerValue = totalPointsTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = totalPointsTeam2RangeSliderUpperValue
            formOperatorValue = totalPointsTeam2OperatorValue
            formOperatorText = totalPointsTeam2OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            totalPointsTeam2SliderFormValue = String(Int(totalPointsTeam2RangeSliderLowerValue)) + " & " + String(Int(totalPointsTeam2RangeSliderUpperValue))
        case ("TEAM: TOUCHDOWNS", false):
            //operatorText = operatorDictionary["< >"]!
            //touchdownsTeam1SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                touchdownsTeam1SliderValue = touchdownsTeam1Values.last!
            }
            touchdownsTeam1OperatorValue = selectedOperatorValue
            touchdownsTeam1OperatorText = operatorText
            formSliderValue = touchdownsTeam1SliderValue
            formOperatorValue = touchdownsTeam1OperatorValue
            formOperatorText = touchdownsTeam1OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(touchdownsTeam1SliderValue))
            touchdownsTeam1SliderFormValue = String(Int(touchdownsTeam1SliderValue))
        case ("TEAM: TOUCHDOWNS", true):
            operatorText = operatorDictionary["< >"]!
            touchdownsTeam1RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            touchdownsTeam1RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            touchdownsTeam1OperatorValue = "< >"
            touchdownsTeam1OperatorText = operatorText
            formRangeSliderLowerValue = touchdownsTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = touchdownsTeam1RangeSliderUpperValue
            formOperatorValue = touchdownsTeam1OperatorValue
            formOperatorText = touchdownsTeam1OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            touchdownsTeam1SliderFormValue = String(Int(touchdownsTeam1RangeSliderLowerValue)) + " & " + String(Int(touchdownsTeam1RangeSliderUpperValue))
        case ("OPPONENT: TOUCHDOWNS", false):
            //operatorText = operatorDictionary["< >"]!
            //touchdownsTeam2SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                touchdownsTeam2SliderValue = touchdownsTeam2Values.last!
            }
            touchdownsTeam2OperatorValue = selectedOperatorValue
            touchdownsTeam2OperatorText = operatorText
            formSliderValue = touchdownsTeam2SliderValue
            formOperatorValue = touchdownsTeam2OperatorValue
            formOperatorText = touchdownsTeam2OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(touchdownsTeam2SliderValue))
            touchdownsTeam2SliderFormValue = String(Int(touchdownsTeam2SliderValue))
        case ("OPPONENT: TOUCHDOWNS", true):
            operatorText = operatorDictionary["< >"]!
            touchdownsTeam2RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            touchdownsTeam2RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            touchdownsTeam2OperatorValue = "< >"
            touchdownsTeam2OperatorText = operatorText
            formRangeSliderLowerValue = touchdownsTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = touchdownsTeam2RangeSliderUpperValue
            formOperatorValue = touchdownsTeam2OperatorValue
            formOperatorText = touchdownsTeam2OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            touchdownsTeam2SliderFormValue = String(Int(touchdownsTeam2RangeSliderLowerValue)) + " & " + String(Int(touchdownsTeam2RangeSliderUpperValue))
            
            
        case ("TEAM: OFFENSIVE TOUCHDOWNS", false):
            //operatorText = operatorDictionary["< >"]!
            //offensiveTouchdownsTeam1SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                offensiveTouchdownsTeam1SliderValue = offensiveTouchdownsTeam1Values.last!
            }
            offensiveTouchdownsTeam1OperatorValue = selectedOperatorValue
            offensiveTouchdownsTeam1OperatorText = operatorText
            formSliderValue = offensiveTouchdownsTeam1SliderValue
            formOperatorValue = offensiveTouchdownsTeam1OperatorValue
            formOperatorText = offensiveTouchdownsTeam1OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(offensiveTouchdownsTeam1SliderValue))
            offensiveTouchdownsTeam1SliderFormValue = String(Int(offensiveTouchdownsTeam1SliderValue))
        case ("TEAM: OFFENSIVE TOUCHDOWNS", true):
            operatorText = operatorDictionary["< >"]!
            offensiveTouchdownsTeam1RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            offensiveTouchdownsTeam1RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            offensiveTouchdownsTeam1OperatorValue = "< >"
            offensiveTouchdownsTeam1OperatorText = operatorText
            formRangeSliderLowerValue = offensiveTouchdownsTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = offensiveTouchdownsTeam1RangeSliderUpperValue
            formOperatorValue = offensiveTouchdownsTeam1OperatorValue
            formOperatorText = offensiveTouchdownsTeam1OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            offensiveTouchdownsTeam1SliderFormValue = String(Int(offensiveTouchdownsTeam1RangeSliderLowerValue)) + " & " + String(Int(offensiveTouchdownsTeam1RangeSliderUpperValue))
            
        case ("OPPONENT: OFFENSIVE TOUCHDOWNS", false):
            //operatorText = operatorDictionary["< >"]!
            //offensiveTouchdownsTeam2SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                offensiveTouchdownsTeam2SliderValue = offensiveTouchdownsTeam2Values.last!
            }
            offensiveTouchdownsTeam2OperatorValue = selectedOperatorValue
            offensiveTouchdownsTeam2OperatorText = operatorText
            formSliderValue = offensiveTouchdownsTeam2SliderValue
            formOperatorValue = offensiveTouchdownsTeam2OperatorValue
            formOperatorText = offensiveTouchdownsTeam2OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(offensiveTouchdownsTeam2SliderValue))
            offensiveTouchdownsTeam2SliderFormValue = String(Int(offensiveTouchdownsTeam2SliderValue))
        case ("OPPONENT: OFFENSIVE TOUCHDOWNS", true):
            operatorText = operatorDictionary["< >"]!
            offensiveTouchdownsTeam2RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            offensiveTouchdownsTeam2RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            offensiveTouchdownsTeam2OperatorValue = "< >"
            offensiveTouchdownsTeam2OperatorText = operatorText
            formRangeSliderLowerValue = offensiveTouchdownsTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = offensiveTouchdownsTeam2RangeSliderUpperValue
            formOperatorValue = offensiveTouchdownsTeam2OperatorValue
            formOperatorText = offensiveTouchdownsTeam2OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            offensiveTouchdownsTeam2SliderFormValue = String(Int(offensiveTouchdownsTeam2RangeSliderLowerValue)) + " & " + String(Int(offensiveTouchdownsTeam2RangeSliderUpperValue))
            
        case ("TEAM: DEFENSIVE TOUCHDOWNS", false):
            //operatorText = operatorDictionary["< >"]!
            //defensiveTouchdownsTeam1SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                defensiveTouchdownsTeam1SliderValue = defensiveTouchdownsTeam1Values.last!
            }
            defensiveTouchdownsTeam1OperatorValue = selectedOperatorValue
            defensiveTouchdownsTeam1OperatorText = operatorText
            formSliderValue = defensiveTouchdownsTeam1SliderValue
            formOperatorValue = defensiveTouchdownsTeam1OperatorValue
            formOperatorText = defensiveTouchdownsTeam1OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(defensiveTouchdownsTeam1SliderValue))
            defensiveTouchdownsTeam1SliderFormValue = String(Int(defensiveTouchdownsTeam1SliderValue))
        case ("TEAM: DEFENSIVE TOUCHDOWNS", true):
            operatorText = operatorDictionary["< >"]!
            defensiveTouchdownsTeam1RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            defensiveTouchdownsTeam1RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            defensiveTouchdownsTeam1OperatorValue = "< >"
            defensiveTouchdownsTeam1OperatorText = operatorText
            formRangeSliderLowerValue = defensiveTouchdownsTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = defensiveTouchdownsTeam1RangeSliderUpperValue
            formOperatorValue = defensiveTouchdownsTeam1OperatorValue
            formOperatorText = defensiveTouchdownsTeam1OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            defensiveTouchdownsTeam1SliderFormValue = String(Int(defensiveTouchdownsTeam1RangeSliderLowerValue)) + " & " + String(Int(defensiveTouchdownsTeam1RangeSliderUpperValue))
            
        case ("OPPONENT: DEFENSIVE TOUCHDOWNS", false):
            //operatorText = operatorDictionary["< >"]!
            //defensiveTouchdownsTeam2SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                defensiveTouchdownsTeam2SliderValue = defensiveTouchdownsTeam2Values.last!
            }
            defensiveTouchdownsTeam2OperatorValue = selectedOperatorValue
            defensiveTouchdownsTeam2OperatorText = operatorText
            formSliderValue = defensiveTouchdownsTeam2SliderValue
            formOperatorValue = defensiveTouchdownsTeam2OperatorValue
            formOperatorText = defensiveTouchdownsTeam2OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(defensiveTouchdownsTeam2SliderValue))
            defensiveTouchdownsTeam2SliderFormValue = String(Int(defensiveTouchdownsTeam2SliderValue))
        case ("OPPONENT: DEFENSIVE TOUCHDOWNS", true):
            operatorText = operatorDictionary["< >"]!
            defensiveTouchdownsTeam2RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            defensiveTouchdownsTeam2RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            defensiveTouchdownsTeam2OperatorValue = "< >"
            defensiveTouchdownsTeam2OperatorText = operatorText
            formRangeSliderLowerValue = defensiveTouchdownsTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = defensiveTouchdownsTeam2RangeSliderUpperValue
            formOperatorValue = defensiveTouchdownsTeam2OperatorValue
            formOperatorText = defensiveTouchdownsTeam2OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            defensiveTouchdownsTeam2SliderFormValue = String(Int(defensiveTouchdownsTeam2RangeSliderLowerValue)) + " & " + String(Int(defensiveTouchdownsTeam2RangeSliderUpperValue))
            
            
        case ("TEAM: TURNOVERS", false):
            //operatorText = operatorDictionary["< >"]!
            //turnoversCommittedTeam1SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                turnoversCommittedTeam1SliderValue = turnoversCommittedTeam1Values.last!
            }
            turnoversCommittedTeam1OperatorValue = selectedOperatorValue
            turnoversCommittedTeam1OperatorText = operatorText
            formSliderValue = turnoversCommittedTeam1SliderValue
            formOperatorValue = turnoversCommittedTeam1OperatorValue
            formOperatorText = turnoversCommittedTeam1OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(turnoversCommittedTeam1SliderValue))
            turnoversCommittedTeam1SliderFormValue = String(Int(turnoversCommittedTeam1SliderValue))
        case ("TEAM: TURNOVERS", true):
            operatorText = operatorDictionary["< >"]!
            turnoversCommittedTeam1RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            turnoversCommittedTeam1RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            turnoversCommittedTeam1OperatorValue = "< >"
            turnoversCommittedTeam1OperatorText = operatorText
            formRangeSliderLowerValue = turnoversCommittedTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = turnoversCommittedTeam1RangeSliderUpperValue
            formOperatorValue = turnoversCommittedTeam1OperatorValue
            formOperatorText = turnoversCommittedTeam1OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            turnoversCommittedTeam1SliderFormValue = String(Int(turnoversCommittedTeam1RangeSliderLowerValue)) + " & " + String(Int(turnoversCommittedTeam1RangeSliderUpperValue))
        case ("OPPONENT: TURNOVERS", false):
            //operatorText = operatorDictionary["< >"]!
            //turnoversCommittedTeam2SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                turnoversCommittedTeam2SliderValue = turnoversCommittedTeam2Values.last!
            }
            turnoversCommittedTeam2OperatorValue = selectedOperatorValue
            turnoversCommittedTeam2OperatorText = operatorText
            formSliderValue = turnoversCommittedTeam2SliderValue
            formOperatorValue = turnoversCommittedTeam2OperatorValue
            formOperatorText = turnoversCommittedTeam2OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(turnoversCommittedTeam2SliderValue))
            turnoversCommittedTeam2SliderFormValue = String(Int(turnoversCommittedTeam2SliderValue))
        case ("OPPONENT: TURNOVERS", true):
            operatorText = operatorDictionary["< >"]!
            turnoversCommittedTeam2RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            turnoversCommittedTeam2RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            turnoversCommittedTeam2OperatorValue = "< >"
            turnoversCommittedTeam2OperatorText = operatorText
            formRangeSliderLowerValue = turnoversCommittedTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = turnoversCommittedTeam2RangeSliderUpperValue
            formOperatorValue = turnoversCommittedTeam2OperatorValue
            formOperatorText = turnoversCommittedTeam2OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            turnoversCommittedTeam2SliderFormValue = String(Int(turnoversCommittedTeam2RangeSliderLowerValue)) + " & " + String(Int(turnoversCommittedTeam2RangeSliderUpperValue))
        case ("TEAM: PENALTIES", false):
            //operatorText = operatorDictionary["< >"]!
            //penaltiesCommittedTeam1SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                penaltiesCommittedTeam1SliderValue = penaltiesCommittedTeam1Values.last!
            }
            penaltiesCommittedTeam1OperatorValue = selectedOperatorValue
            penaltiesCommittedTeam1OperatorText = operatorText
            formSliderValue = penaltiesCommittedTeam1SliderValue
            formOperatorValue = penaltiesCommittedTeam1OperatorValue
            formOperatorText = penaltiesCommittedTeam1OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(penaltiesCommittedTeam1SliderValue))
            penaltiesCommittedTeam1SliderFormValue = String(Int(penaltiesCommittedTeam1SliderValue))
        case ("TEAM: PENALTIES", true):
            operatorText = operatorDictionary["< >"]!
            penaltiesCommittedTeam1RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            penaltiesCommittedTeam1RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            penaltiesCommittedTeam1OperatorValue = "< >"
            penaltiesCommittedTeam1OperatorText = operatorText
            formRangeSliderLowerValue = penaltiesCommittedTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = penaltiesCommittedTeam1RangeSliderUpperValue
            formOperatorValue = penaltiesCommittedTeam1OperatorValue
            formOperatorText = penaltiesCommittedTeam1OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            penaltiesCommittedTeam1SliderFormValue = String(Int(penaltiesCommittedTeam1RangeSliderLowerValue)) + " & " + String(Int(penaltiesCommittedTeam1RangeSliderUpperValue))
        case ("OPPONENT: PENALTIES", false):
            //operatorText = operatorDictionary["< >"]!
            //penaltiesCommittedTeam2SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                penaltiesCommittedTeam2SliderValue = penaltiesCommittedTeam2Values.last!
            }
            penaltiesCommittedTeam2OperatorValue = selectedOperatorValue
            penaltiesCommittedTeam2OperatorText = operatorText
            formSliderValue = penaltiesCommittedTeam2SliderValue
            formOperatorValue = penaltiesCommittedTeam2OperatorValue
            formOperatorText = penaltiesCommittedTeam2OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(penaltiesCommittedTeam2SliderValue))
            penaltiesCommittedTeam2SliderFormValue = String(Int(penaltiesCommittedTeam2SliderValue))
        case ("OPPONENT: PENALTIES", true):
            operatorText = operatorDictionary["< >"]!
            penaltiesCommittedTeam2RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            penaltiesCommittedTeam2RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            penaltiesCommittedTeam2OperatorValue = "< >"
            penaltiesCommittedTeam2OperatorText = operatorText
            formRangeSliderLowerValue = penaltiesCommittedTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = penaltiesCommittedTeam2RangeSliderUpperValue
            formOperatorValue = penaltiesCommittedTeam2OperatorValue
            formOperatorText = penaltiesCommittedTeam2OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            penaltiesCommittedTeam2SliderFormValue = String(Int(penaltiesCommittedTeam2RangeSliderLowerValue)) + " & " + String(Int(penaltiesCommittedTeam2RangeSliderUpperValue))
        case ("TEAM: TOTAL YARDS", false):
            //operatorText = operatorDictionary["< >"]!
            //totalYardsTeam1SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                totalYardsTeam1SliderValue = totalYardsTeam1Values.last!
            }
            totalYardsTeam1OperatorValue = selectedOperatorValue
            totalYardsTeam1OperatorText = operatorText
            formSliderValue = totalYardsTeam1SliderValue
            formOperatorValue = totalYardsTeam1OperatorValue
            formOperatorText = totalYardsTeam1OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(totalYardsTeam1SliderValue))
            totalYardsTeam1SliderFormValue = String(Int(totalYardsTeam1SliderValue))
        case ("TEAM: TOTAL YARDS", true):
            operatorText = operatorDictionary["< >"]!
            totalYardsTeam1RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            totalYardsTeam1RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            totalYardsTeam1OperatorValue = "< >"
            totalYardsTeam1OperatorText = operatorText
            formRangeSliderLowerValue = totalYardsTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = totalYardsTeam1RangeSliderUpperValue
            formOperatorValue = totalYardsTeam1OperatorValue
            formOperatorText = totalYardsTeam1OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            totalYardsTeam1SliderFormValue = String(Int(totalYardsTeam1RangeSliderLowerValue)) + " & " + String(Int(totalYardsTeam1RangeSliderUpperValue))
        case ("OPPONENT: TOTAL YARDS", false):
            //operatorText = operatorDictionary["< >"]!
            //totalYardsTeam2SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                totalYardsTeam2SliderValue = totalYardsTeam2Values.last!
            }
            totalYardsTeam2OperatorValue = selectedOperatorValue
            totalYardsTeam2OperatorText = operatorText
            formSliderValue = totalYardsTeam2SliderValue
            formOperatorValue = totalYardsTeam2OperatorValue
            formOperatorText = totalYardsTeam2OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(totalYardsTeam2SliderValue))
            totalYardsTeam2SliderFormValue = String(Int(totalYardsTeam2SliderValue))
        case ("OPPONENT: TOTAL YARDS", true):
            operatorText = operatorDictionary["< >"]!
            totalYardsTeam2RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            totalYardsTeam2RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            totalYardsTeam2OperatorValue = "< >"
            totalYardsTeam2OperatorText = operatorText
            formRangeSliderLowerValue = totalYardsTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = totalYardsTeam2RangeSliderUpperValue
            formOperatorValue = totalYardsTeam2OperatorValue
            formOperatorText = totalYardsTeam2OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            totalYardsTeam2SliderFormValue = String(Int(totalYardsTeam2RangeSliderLowerValue)) + " & " + String(Int(totalYardsTeam2RangeSliderUpperValue))
        case ("TEAM: PASSING YARDS", false):
            //operatorText = operatorDictionary["< >"]!
            //passingYardsTeam1SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                passingYardsTeam1SliderValue = passingYardsTeam1Values.last!
            }
            passingYardsTeam1OperatorValue = selectedOperatorValue
            passingYardsTeam1OperatorText = operatorText
            formSliderValue = passingYardsTeam1SliderValue
            formOperatorValue = passingYardsTeam1OperatorValue
            formOperatorText = passingYardsTeam1OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(passingYardsTeam1SliderValue))
            passingYardsTeam1SliderFormValue = String(Int(passingYardsTeam1SliderValue))
        case ("TEAM: PASSING YARDS", true):
            operatorText = operatorDictionary["< >"]!
            passingYardsTeam1RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            passingYardsTeam1RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            passingYardsTeam1OperatorValue = "< >"
            passingYardsTeam1OperatorText = operatorText
            formRangeSliderLowerValue = passingYardsTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = passingYardsTeam1RangeSliderUpperValue
            formOperatorValue = passingYardsTeam1OperatorValue
            formOperatorText = passingYardsTeam1OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            passingYardsTeam1SliderFormValue = String(Int(passingYardsTeam1RangeSliderLowerValue)) + " & " + String(Int(passingYardsTeam1RangeSliderUpperValue))
        case ("OPPONENT: PASSING YARDS", false):
            //operatorText = operatorDictionary["< >"]!
            //passingYardsTeam2SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                passingYardsTeam2SliderValue = passingYardsTeam2Values.last!
            }
            passingYardsTeam2OperatorValue = selectedOperatorValue
            passingYardsTeam2OperatorText = operatorText
            formSliderValue = passingYardsTeam2SliderValue
            formOperatorValue = passingYardsTeam2OperatorValue
            formOperatorText = passingYardsTeam2OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(passingYardsTeam2SliderValue))
            passingYardsTeam2SliderFormValue = String(Int(passingYardsTeam2SliderValue))
        case ("OPPONENT: PASSING YARDS", true):
            operatorText = operatorDictionary["< >"]!
            passingYardsTeam2RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            passingYardsTeam2RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            passingYardsTeam2OperatorValue = "< >"
            passingYardsTeam2OperatorText = operatorText
            formRangeSliderLowerValue = passingYardsTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = passingYardsTeam2RangeSliderUpperValue
            formOperatorValue = passingYardsTeam2OperatorValue
            formOperatorText = passingYardsTeam2OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            passingYardsTeam2SliderFormValue = String(Int(passingYardsTeam2RangeSliderLowerValue)) + " & " + String(Int(passingYardsTeam2RangeSliderUpperValue))
        case ("TEAM: RUSHING YARDS", false):
            //operatorText = operatorDictionary["< >"]!
            //rushingYardsTeam1SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                rushingYardsTeam1SliderValue = rushingYardsTeam1Values.last!
            }
            rushingYardsTeam1OperatorValue = selectedOperatorValue
            rushingYardsTeam1OperatorText = operatorText
            formSliderValue = rushingYardsTeam1SliderValue
            formOperatorValue = rushingYardsTeam1OperatorValue
            formOperatorText = rushingYardsTeam1OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(rushingYardsTeam1SliderValue))
            rushingYardsTeam1SliderFormValue = String(Int(rushingYardsTeam1SliderValue))
        case ("TEAM: RUSHING YARDS", true):
            operatorText = operatorDictionary["< >"]!
            rushingYardsTeam1RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            rushingYardsTeam1RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            rushingYardsTeam1OperatorValue = "< >"
            rushingYardsTeam1OperatorText = operatorText
            formRangeSliderLowerValue = rushingYardsTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = rushingYardsTeam1RangeSliderUpperValue
            formOperatorValue = rushingYardsTeam1OperatorValue
            formOperatorText = rushingYardsTeam1OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            rushingYardsTeam1SliderFormValue = String(Int(rushingYardsTeam1RangeSliderLowerValue)) + " & " + String(Int(rushingYardsTeam1RangeSliderUpperValue))
        case ("OPPONENT: RUSHING YARDS", false):
            //operatorText = operatorDictionary["< >"]!
            //rushingYardsTeam2SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                rushingYardsTeam2SliderValue = rushingYardsTeam2Values.last!
            }
            rushingYardsTeam2OperatorValue = selectedOperatorValue
            rushingYardsTeam2OperatorText = operatorText
            formSliderValue = rushingYardsTeam2SliderValue
            formOperatorValue = rushingYardsTeam2OperatorValue
            formOperatorText = rushingYardsTeam2OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(rushingYardsTeam2SliderValue))
            rushingYardsTeam2SliderFormValue = String(Int(rushingYardsTeam2SliderValue))
        case ("OPPONENT: RUSHING YARDS", true):
            operatorText = operatorDictionary["< >"]!
            rushingYardsTeam2RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            rushingYardsTeam2RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            rushingYardsTeam2OperatorValue = "< >"
            rushingYardsTeam2OperatorText = operatorText
            formRangeSliderLowerValue = rushingYardsTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = rushingYardsTeam2RangeSliderUpperValue
            formOperatorValue = rushingYardsTeam2OperatorValue
            formOperatorText = rushingYardsTeam2OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            rushingYardsTeam2SliderFormValue = String(Int(rushingYardsTeam2RangeSliderLowerValue)) + " & " + String(Int(rushingYardsTeam2RangeSliderUpperValue))
        case ("TEAM: QUARTERBACK RATING", false):
            //operatorText = operatorDictionary["< >"]!
            //quarterbackRatingTeam1SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                quarterbackRatingTeam1SliderValue = quarterbackRatingTeam1Values.last!
            }
            quarterbackRatingTeam1OperatorValue = selectedOperatorValue
            quarterbackRatingTeam1OperatorText = operatorText
            formSliderValue = quarterbackRatingTeam1SliderValue
            formOperatorValue = quarterbackRatingTeam1OperatorValue
            formOperatorText = quarterbackRatingTeam1OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(quarterbackRatingTeam1SliderValue))
            quarterbackRatingTeam1SliderFormValue = String(Int(quarterbackRatingTeam1SliderValue))
        case ("TEAM: QUARTERBACK RATING", true):
            operatorText = operatorDictionary["< >"]!
            quarterbackRatingTeam1RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            quarterbackRatingTeam1RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            quarterbackRatingTeam1OperatorValue = "< >"
            quarterbackRatingTeam1OperatorText = operatorText
            formRangeSliderLowerValue = quarterbackRatingTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = quarterbackRatingTeam1RangeSliderUpperValue
            formOperatorValue = quarterbackRatingTeam1OperatorValue
            formOperatorText = quarterbackRatingTeam1OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            quarterbackRatingTeam1SliderFormValue = String(Int(quarterbackRatingTeam1RangeSliderLowerValue)) + " & " + String(Int(quarterbackRatingTeam1RangeSliderUpperValue))
        case ("OPPONENT: QUARTERBACK RATING", false):
            //operatorText = operatorDictionary["< >"]!
            //quarterbackRatingTeam2SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                quarterbackRatingTeam2SliderValue = quarterbackRatingTeam2Values.last!
            }
            quarterbackRatingTeam2OperatorValue = selectedOperatorValue
            quarterbackRatingTeam2OperatorText = operatorText
            formSliderValue = quarterbackRatingTeam2SliderValue
            formOperatorValue = quarterbackRatingTeam2OperatorValue
            formOperatorText = quarterbackRatingTeam2OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.3, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(quarterbackRatingTeam2SliderValue))
            quarterbackRatingTeam2SliderFormValue = String(Int(quarterbackRatingTeam2SliderValue))
        case ("OPPONENT: QUARTERBACK RATING", true):
            operatorText = operatorDictionary["< >"]!
            quarterbackRatingTeam2RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            quarterbackRatingTeam2RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            quarterbackRatingTeam2OperatorValue = "< >"
            quarterbackRatingTeam2OperatorText = operatorText
            formRangeSliderLowerValue = quarterbackRatingTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = quarterbackRatingTeam2RangeSliderUpperValue
            formOperatorValue = quarterbackRatingTeam2OperatorValue
            formOperatorText = quarterbackRatingTeam2OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            quarterbackRatingTeam2SliderFormValue = String(Int(quarterbackRatingTeam2RangeSliderLowerValue)) + " & " + String(Int(quarterbackRatingTeam2RangeSliderUpperValue))
        case ("TEAM: TIMES SACKED", false):
            //operatorText = operatorDictionary["< >"]!
            //timesSackedTeam1SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                timesSackedTeam1SliderValue = timesSackedTeam1Values.last!
            }
            timesSackedTeam1OperatorValue = selectedOperatorValue
            timesSackedTeam1OperatorText = operatorText
            formSliderValue = timesSackedTeam1SliderValue
            formOperatorValue = timesSackedTeam1OperatorValue
            formOperatorText = timesSackedTeam1OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(timesSackedTeam1SliderValue))
            timesSackedTeam1SliderFormValue = String(Int(timesSackedTeam1SliderValue))
        case ("TEAM: TIMES SACKED", true):
            operatorText = operatorDictionary["< >"]!
            timesSackedTeam1RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            timesSackedTeam1RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            timesSackedTeam1OperatorValue = "< >"
            timesSackedTeam1OperatorText = operatorText
            formRangeSliderLowerValue = timesSackedTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = timesSackedTeam1RangeSliderUpperValue
            formOperatorValue = timesSackedTeam1OperatorValue
            formOperatorText = timesSackedTeam1OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            timesSackedTeam1SliderFormValue = String(Int(timesSackedTeam1RangeSliderLowerValue)) + " & " + String(Int(timesSackedTeam1RangeSliderUpperValue))
        case ("OPPONENT: TIMES SACKED", false):
            //operatorText = operatorDictionary["< >"]!
            //timesSackedTeam2SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                timesSackedTeam2SliderValue = timesSackedTeam2Values.last!
            }
            timesSackedTeam2OperatorValue = selectedOperatorValue
            timesSackedTeam2OperatorText = operatorText
            formSliderValue = timesSackedTeam2SliderValue
            formOperatorValue = timesSackedTeam2OperatorValue
            formOperatorText = timesSackedTeam2OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(timesSackedTeam2SliderValue))
            timesSackedTeam2SliderFormValue = String(Int(timesSackedTeam2SliderValue))
        case ("OPPONENT: TIMES SACKED", true):
            operatorText = operatorDictionary["< >"]!
            timesSackedTeam2RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            timesSackedTeam2RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            timesSackedTeam2OperatorValue = "< >"
            timesSackedTeam2OperatorText = operatorText
            formRangeSliderLowerValue = timesSackedTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = timesSackedTeam2RangeSliderUpperValue
            formOperatorValue = timesSackedTeam2OperatorValue
            formOperatorText = timesSackedTeam2OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            timesSackedTeam2SliderFormValue = String(Int(timesSackedTeam2RangeSliderLowerValue)) + " & " + String(Int(timesSackedTeam2RangeSliderUpperValue))
        case ("TEAM: INTERCEPTIONS THROWN", false):
            //operatorText = operatorDictionary["< >"]!
            //interceptionsThrownTeam1SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                interceptionsThrownTeam1SliderValue = interceptionsThrownTeam1Values.last!
            }
            interceptionsThrownTeam1OperatorValue = selectedOperatorValue
            interceptionsThrownTeam1OperatorText = operatorText
            formSliderValue = interceptionsThrownTeam1SliderValue
            formOperatorValue = interceptionsThrownTeam1OperatorValue
            formOperatorText = interceptionsThrownTeam1OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(interceptionsThrownTeam1SliderValue))
            interceptionsThrownTeam1SliderFormValue = String(Int(interceptionsThrownTeam1SliderValue))
        case ("TEAM: INTERCEPTIONS THROWN", true):
            operatorText = operatorDictionary["< >"]!
            interceptionsThrownTeam1RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            interceptionsThrownTeam1RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            interceptionsThrownTeam1OperatorValue = "< >"
            interceptionsThrownTeam1OperatorText = operatorText
            formRangeSliderLowerValue = interceptionsThrownTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = interceptionsThrownTeam1RangeSliderUpperValue
            formOperatorValue = interceptionsThrownTeam1OperatorValue
            formOperatorText = interceptionsThrownTeam1OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            interceptionsThrownTeam1SliderFormValue = String(Int(interceptionsThrownTeam1RangeSliderLowerValue)) + " & " + String(Int(interceptionsThrownTeam1RangeSliderUpperValue))
        case ("OPPONENT: INTERCEPTIONS THROWN", false):
            //operatorText = operatorDictionary["< >"]!
            //interceptionsThrownTeam2SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                interceptionsThrownTeam2SliderValue = interceptionsThrownTeam2Values.last!
            }
            interceptionsThrownTeam2OperatorValue = selectedOperatorValue
            interceptionsThrownTeam2OperatorText = operatorText
            formSliderValue = interceptionsThrownTeam2SliderValue
            formOperatorValue = interceptionsThrownTeam2OperatorValue
            formOperatorText = interceptionsThrownTeam2OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(interceptionsThrownTeam2SliderValue))
            interceptionsThrownTeam2SliderFormValue = String(Int(interceptionsThrownTeam2SliderValue))
        case ("OPPONENT: INTERCEPTIONS THROWN", true):
            operatorText = operatorDictionary["< >"]!
            interceptionsThrownTeam2RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            interceptionsThrownTeam2RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            interceptionsThrownTeam2OperatorValue = "< >"
            interceptionsThrownTeam2OperatorText = operatorText
            formRangeSliderLowerValue = interceptionsThrownTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = interceptionsThrownTeam2RangeSliderUpperValue
            formOperatorValue = interceptionsThrownTeam2OperatorValue
            formOperatorText = interceptionsThrownTeam2OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            interceptionsThrownTeam2SliderFormValue = String(Int(interceptionsThrownTeam2RangeSliderLowerValue)) + " & " + String(Int(interceptionsThrownTeam2RangeSliderUpperValue))
        case ("TEAM: OFFENSIVE PLAYS", false):
            //operatorText = operatorDictionary["< >"]!
            //offensivePlaysTeam1SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                offensivePlaysTeam1SliderValue = offensivePlaysTeam1Values.last!
            }
            offensivePlaysTeam1OperatorValue = selectedOperatorValue
            offensivePlaysTeam1OperatorText = operatorText
            formSliderValue = offensivePlaysTeam1SliderValue
            formOperatorValue = offensivePlaysTeam1OperatorValue
            formOperatorText = offensivePlaysTeam1OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(offensivePlaysTeam1SliderValue))
            offensivePlaysTeam1SliderFormValue = String(Int(offensivePlaysTeam1SliderValue))
        case ("TEAM: OFFENSIVE PLAYS", true):
            operatorText = operatorDictionary["< >"]!
            offensivePlaysTeam1RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            offensivePlaysTeam1RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            offensivePlaysTeam1OperatorValue = "< >"
            offensivePlaysTeam1OperatorText = operatorText
            formRangeSliderLowerValue = offensivePlaysTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = offensivePlaysTeam1RangeSliderUpperValue
            formOperatorValue = offensivePlaysTeam1OperatorValue
            formOperatorText = offensivePlaysTeam1OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            offensivePlaysTeam1SliderFormValue = String(Int(offensivePlaysTeam1RangeSliderLowerValue)) + " & " + String(Int(offensivePlaysTeam1RangeSliderUpperValue))
        case ("OPPONENT: OFFENSIVE PLAYS", false):
            //operatorText = operatorDictionary["< >"]!
            //offensivePlaysTeam2SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                offensivePlaysTeam2SliderValue = offensivePlaysTeam2Values.last!
            }
            offensivePlaysTeam2OperatorValue = selectedOperatorValue
            offensivePlaysTeam2OperatorText = operatorText
            formSliderValue = offensivePlaysTeam2SliderValue
            formOperatorValue = offensivePlaysTeam2OperatorValue
            formOperatorText = offensivePlaysTeam2OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(offensivePlaysTeam2SliderValue))
            offensivePlaysTeam2SliderFormValue = String(Int(offensivePlaysTeam2SliderValue))
        case ("OPPONENT: OFFENSIVE PLAYS", true):
            operatorText = operatorDictionary["< >"]!
            offensivePlaysTeam2RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            offensivePlaysTeam2RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            offensivePlaysTeam2OperatorValue = "< >"
            offensivePlaysTeam2OperatorText = operatorText
            formRangeSliderLowerValue = offensivePlaysTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = offensivePlaysTeam2RangeSliderUpperValue
            formOperatorValue = offensivePlaysTeam2OperatorValue
            formOperatorText = offensivePlaysTeam2OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            offensivePlaysTeam2SliderFormValue = String(Int(offensivePlaysTeam2RangeSliderLowerValue)) + " & " + String(Int(offensivePlaysTeam2RangeSliderUpperValue))
        case ("TEAM: YARDS/OFFENSIVE PLAY", false):
            //operatorText = operatorDictionary["< >"]!
            //yardsPerOffensivePlayTeam1SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                yardsPerOffensivePlayTeam1SliderValue = yardsPerOffensivePlayTeam1Values.last!
            }
            yardsPerOffensivePlayTeam1OperatorValue = selectedOperatorValue
            yardsPerOffensivePlayTeam1OperatorText = operatorText
            formSliderValue = yardsPerOffensivePlayTeam1SliderValue
            formOperatorValue = yardsPerOffensivePlayTeam1OperatorValue
            formOperatorText = yardsPerOffensivePlayTeam1OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(yardsPerOffensivePlayTeam1SliderValue))
            yardsPerOffensivePlayTeam1SliderFormValue = String(Int(yardsPerOffensivePlayTeam1SliderValue))
        case ("TEAM: YARDS/OFFENSIVE PLAY", true):
            operatorText = operatorDictionary["< >"]!
            yardsPerOffensivePlayTeam1RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            yardsPerOffensivePlayTeam1RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            yardsPerOffensivePlayTeam1OperatorValue = "< >"
            yardsPerOffensivePlayTeam1OperatorText = operatorText
            formRangeSliderLowerValue = yardsPerOffensivePlayTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = yardsPerOffensivePlayTeam1RangeSliderUpperValue
            formOperatorValue = yardsPerOffensivePlayTeam1OperatorValue
            formOperatorText = yardsPerOffensivePlayTeam1OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            yardsPerOffensivePlayTeam1SliderFormValue = String(Int(yardsPerOffensivePlayTeam1RangeSliderLowerValue)) + " & " + String(Int(yardsPerOffensivePlayTeam1RangeSliderUpperValue))
        case ("OPPONENT: YARDS/OFFENSIVE PLAY", false):
            //operatorText = operatorDictionary["< >"]!
            //yardsPerOffensivePlayTeam2SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                yardsPerOffensivePlayTeam2SliderValue = yardsPerOffensivePlayTeam2Values.last!
            }
            yardsPerOffensivePlayTeam2OperatorValue = selectedOperatorValue
            yardsPerOffensivePlayTeam2OperatorText = operatorText
            formSliderValue = yardsPerOffensivePlayTeam2SliderValue
            formOperatorValue = yardsPerOffensivePlayTeam2OperatorValue
            formOperatorText = yardsPerOffensivePlayTeam2OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(yardsPerOffensivePlayTeam2SliderValue))
            yardsPerOffensivePlayTeam2SliderFormValue = String(Int(yardsPerOffensivePlayTeam2SliderValue))
        case ("OPPONENT: YARDS/OFFENSIVE PLAY", true):
            operatorText = operatorDictionary["< >"]!
            yardsPerOffensivePlayTeam2RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            yardsPerOffensivePlayTeam2RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            yardsPerOffensivePlayTeam2OperatorValue = "< >"
            yardsPerOffensivePlayTeam2OperatorText = operatorText
            formRangeSliderLowerValue = yardsPerOffensivePlayTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = yardsPerOffensivePlayTeam2RangeSliderUpperValue
            formOperatorValue = yardsPerOffensivePlayTeam2OperatorValue
            formOperatorText = yardsPerOffensivePlayTeam2OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            yardsPerOffensivePlayTeam2SliderFormValue = String(Int(yardsPerOffensivePlayTeam2RangeSliderLowerValue)) + " & " + String(Int(yardsPerOffensivePlayTeam2RangeSliderUpperValue))
        case ("TEAM: SACKS", false):
            //operatorText = operatorDictionary["< >"]!
            //sacksTeam1SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                sacksTeam1SliderValue = sacksTeam1Values.last!
            }
            sacksTeam1OperatorValue = selectedOperatorValue
            sacksTeam1OperatorText = operatorText
            formSliderValue = sacksTeam1SliderValue
            formOperatorValue = sacksTeam1OperatorValue
            formOperatorText = sacksTeam1OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(sacksTeam1SliderValue))
            sacksTeam1SliderFormValue = String(Int(sacksTeam1SliderValue))
        case ("TEAM: SACKS", true):
            operatorText = operatorDictionary["< >"]!
            sacksTeam1RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            sacksTeam1RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            sacksTeam1OperatorValue = "< >"
            sacksTeam1OperatorText = operatorText
            formRangeSliderLowerValue = sacksTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = sacksTeam1RangeSliderUpperValue
            formOperatorValue = sacksTeam1OperatorValue
            formOperatorText = sacksTeam1OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            sacksTeam1SliderFormValue = String(Int(sacksTeam1RangeSliderLowerValue)) + " & " + String(Int(sacksTeam1RangeSliderUpperValue))
        case ("OPPONENT: SACKS", false):
            //operatorText = operatorDictionary["< >"]!
            //sacksTeam2SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                sacksTeam2SliderValue = sacksTeam2Values.last!
            }
            sacksTeam2OperatorValue = selectedOperatorValue
            sacksTeam2OperatorText = operatorText
            formSliderValue = sacksTeam2SliderValue
            formOperatorValue = sacksTeam2OperatorValue
            formOperatorText = sacksTeam2OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(sacksTeam2SliderValue))
            sacksTeam2SliderFormValue = String(Int(sacksTeam2SliderValue))
        case ("OPPONENT: SACKS", true):
            operatorText = operatorDictionary["< >"]!
            sacksTeam2RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            sacksTeam2RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            sacksTeam2OperatorValue = "< >"
            sacksTeam2OperatorText = operatorText
            formRangeSliderLowerValue = sacksTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = sacksTeam2RangeSliderUpperValue
            formOperatorValue = sacksTeam2OperatorValue
            formOperatorText = sacksTeam2OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            sacksTeam2SliderFormValue = String(Int(sacksTeam2RangeSliderLowerValue)) + " & " + String(Int(sacksTeam2RangeSliderUpperValue))
        case ("TEAM: INTERCEPTIONS", false):
            //operatorText = operatorDictionary["< >"]!
            //interceptionsTeam1SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                interceptionsTeam1SliderValue = interceptionsTeam1Values.last!
            }
            interceptionsTeam1OperatorValue = selectedOperatorValue
            interceptionsTeam1OperatorText = operatorText
            formSliderValue = interceptionsTeam1SliderValue
            formOperatorValue = interceptionsTeam1OperatorValue
            formOperatorText = interceptionsTeam1OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(interceptionsTeam1SliderValue))
            interceptionsTeam1SliderFormValue = String(Int(interceptionsTeam1SliderValue))
        case ("TEAM: INTERCEPTIONS", true):
            operatorText = operatorDictionary["< >"]!
            interceptionsTeam1RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            interceptionsTeam1RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            interceptionsTeam1OperatorValue = "< >"
            interceptionsTeam1OperatorText = operatorText
            formRangeSliderLowerValue = interceptionsTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = interceptionsTeam1RangeSliderUpperValue
            formOperatorValue = interceptionsTeam1OperatorValue
            formOperatorText = interceptionsTeam1OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            interceptionsTeam1SliderFormValue = String(Int(interceptionsTeam1RangeSliderLowerValue)) + " & " + String(Int(interceptionsTeam1RangeSliderUpperValue))
        case ("OPPONENT: INTERCEPTIONS", false):
            //operatorText = operatorDictionary["< >"]!
            //interceptionsTeam2SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                interceptionsTeam2SliderValue = interceptionsTeam2Values.last!
            }
            interceptionsTeam2OperatorValue = selectedOperatorValue
            interceptionsTeam2OperatorText = operatorText
            formSliderValue = interceptionsTeam2SliderValue
            formOperatorValue = interceptionsTeam2OperatorValue
            formOperatorText = interceptionsTeam2OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(interceptionsTeam2SliderValue))
            interceptionsTeam2SliderFormValue = String(Int(interceptionsTeam2SliderValue))
        case ("OPPONENT: INTERCEPTIONS", true):
            operatorText = operatorDictionary["< >"]!
            interceptionsTeam2RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            interceptionsTeam2RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            interceptionsTeam2OperatorValue = "< >"
            interceptionsTeam2OperatorText = operatorText
            formRangeSliderLowerValue = interceptionsTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = interceptionsTeam2RangeSliderUpperValue
            formOperatorValue = interceptionsTeam2OperatorValue
            formOperatorText = interceptionsTeam2OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            interceptionsTeam2SliderFormValue = String(Int(interceptionsTeam2RangeSliderLowerValue)) + " & " + String(Int(interceptionsTeam2RangeSliderUpperValue))
        case ("TEAM: SAFETIES", false):
            //operatorText = operatorDictionary["< >"]!
            //safetiesTeam1SliderValue = rowValue'
            if formSliderValue == Float(-10000) {
                safetiesTeam1SliderValue = safetiesTeam1Values.last!
            }
            safetiesTeam1OperatorValue = selectedOperatorValue
            safetiesTeam1OperatorText = operatorText
            formSliderValue = safetiesTeam1SliderValue
            formOperatorValue = safetiesTeam1OperatorValue
            formOperatorText = safetiesTeam1OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(safetiesTeam1SliderValue))
            safetiesTeam1SliderFormValue = String(Int(safetiesTeam1SliderValue))
        case ("TEAM: SAFETIES", true):
            operatorText = operatorDictionary["< >"]!
            safetiesTeam1RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            safetiesTeam1RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            safetiesTeam1OperatorValue = "< >"
            safetiesTeam1OperatorText = operatorText
            formRangeSliderLowerValue = safetiesTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = safetiesTeam1RangeSliderUpperValue
            formOperatorValue = safetiesTeam1OperatorValue
            formOperatorText = safetiesTeam1OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            safetiesTeam1SliderFormValue = String(Int(safetiesTeam1RangeSliderLowerValue)) + " & " + String(Int(safetiesTeam1RangeSliderUpperValue))
        case ("OPPONENT: SAFETIES", false):
            //operatorText = operatorDictionary["< >"]!
            //safetiesTeam2SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                safetiesTeam2SliderValue = safetiesTeam2Values.last!
            }
            safetiesTeam2OperatorValue = selectedOperatorValue
            safetiesTeam2OperatorText = operatorText
            formSliderValue = safetiesTeam2SliderValue
            formOperatorValue = safetiesTeam2OperatorValue
            formOperatorText = safetiesTeam2OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(safetiesTeam2SliderValue))
            safetiesTeam2SliderFormValue = String(Int(safetiesTeam2SliderValue))
        case ("OPPONENT: SAFETIES", true):
            operatorText = operatorDictionary["< >"]!
            safetiesTeam2RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            safetiesTeam2RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            safetiesTeam2OperatorValue = "< >"
            safetiesTeam2OperatorText = operatorText
            formRangeSliderLowerValue = safetiesTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = safetiesTeam2RangeSliderUpperValue
            formOperatorValue = safetiesTeam2OperatorValue
            formOperatorText = safetiesTeam2OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            safetiesTeam2SliderFormValue = String(Int(safetiesTeam2RangeSliderLowerValue)) + " & " + String(Int(safetiesTeam2RangeSliderUpperValue))
        case ("TEAM: DEFENSIVE PLAYS", false):
            //operatorText = operatorDictionary["< >"]!
            //defensivePlaysTeam1SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                defensivePlaysTeam1SliderValue = defensivePlaysTeam1Values.last!
            }
            defensivePlaysTeam1OperatorValue = selectedOperatorValue
            defensivePlaysTeam1OperatorText = operatorText
            formSliderValue = defensivePlaysTeam1SliderValue
            formOperatorValue = defensivePlaysTeam1OperatorValue
            formOperatorText = defensivePlaysTeam1OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(defensivePlaysTeam1SliderValue))
            defensivePlaysTeam1SliderFormValue = String(Int(defensivePlaysTeam1SliderValue))
        case ("TEAM: DEFENSIVE PLAYS", true):
            operatorText = operatorDictionary["< >"]!
            defensivePlaysTeam1RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            defensivePlaysTeam1RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            defensivePlaysTeam1OperatorValue = "< >"
            defensivePlaysTeam1OperatorText = operatorText
            formRangeSliderLowerValue = defensivePlaysTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = defensivePlaysTeam1RangeSliderUpperValue
            formOperatorValue = defensivePlaysTeam1OperatorValue
            formOperatorText = defensivePlaysTeam1OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            defensivePlaysTeam1SliderFormValue = String(Int(defensivePlaysTeam1RangeSliderLowerValue)) + " & " + String(Int(defensivePlaysTeam1RangeSliderUpperValue))
        case ("OPPONENT: DEFENSIVE PLAYS", false):
            //operatorText = operatorDictionary["< >"]!
            //defensivePlaysTeam2SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                defensivePlaysTeam2SliderValue = defensivePlaysTeam2Values.last!
            }
            defensivePlaysTeam2OperatorValue = selectedOperatorValue
            defensivePlaysTeam2OperatorText = operatorText
            formSliderValue = defensivePlaysTeam2SliderValue
            formOperatorValue = defensivePlaysTeam2OperatorValue
            formOperatorText = defensivePlaysTeam2OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(defensivePlaysTeam2SliderValue))
            defensivePlaysTeam2SliderFormValue = String(Int(defensivePlaysTeam2SliderValue))
        case ("OPPONENT: DEFENSIVE PLAYS", true):
            operatorText = operatorDictionary["< >"]!
            defensivePlaysTeam2RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            defensivePlaysTeam2RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            defensivePlaysTeam2OperatorValue = "< >"
            defensivePlaysTeam2OperatorText = operatorText
            formRangeSliderLowerValue = defensivePlaysTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = defensivePlaysTeam2RangeSliderUpperValue
            formOperatorValue = defensivePlaysTeam2OperatorValue
            formOperatorText = defensivePlaysTeam2OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            defensivePlaysTeam2SliderFormValue = String(Int(defensivePlaysTeam2RangeSliderLowerValue)) + " & " + String(Int(defensivePlaysTeam2RangeSliderUpperValue))
        case ("TEAM: YARDS/DEFENSIVE PLAY", false):
            //operatorText = operatorDictionary["< >"]!
            //yardsPerDefensivePlayTeam1SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                yardsPerDefensivePlayTeam1SliderValue = yardsPerDefensivePlayTeam1Values.last!
            }
            yardsPerDefensivePlayTeam1OperatorValue = selectedOperatorValue
            yardsPerDefensivePlayTeam1OperatorText = operatorText
            formSliderValue = yardsPerDefensivePlayTeam1SliderValue
            formOperatorValue = yardsPerDefensivePlayTeam1OperatorValue
            formOperatorText = yardsPerDefensivePlayTeam1OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(yardsPerDefensivePlayTeam1SliderValue))
            yardsPerDefensivePlayTeam1SliderFormValue = String(Int(yardsPerDefensivePlayTeam1SliderValue))
        case ("TEAM: YARDS/DEFENSIVE PLAY", true):
            operatorText = operatorDictionary["< >"]!
            yardsPerDefensivePlayTeam1RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            yardsPerDefensivePlayTeam1RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            yardsPerDefensivePlayTeam1OperatorValue = "< >"
            yardsPerDefensivePlayTeam1OperatorText = operatorText
            formRangeSliderLowerValue = yardsPerDefensivePlayTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = yardsPerDefensivePlayTeam1RangeSliderUpperValue
            formOperatorValue = yardsPerDefensivePlayTeam1OperatorValue
            formOperatorText = yardsPerDefensivePlayTeam1OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            yardsPerDefensivePlayTeam1SliderFormValue = String(Int(yardsPerDefensivePlayTeam1RangeSliderLowerValue)) + " & " + String(Int(yardsPerDefensivePlayTeam1RangeSliderUpperValue))
        case ("OPPONENT: YARDS/DEFENSIVE PLAY", false):
            //operatorText = operatorDictionary["< >"]!
            //yardsPerDefensivePlayTeam2SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                yardsPerDefensivePlayTeam2SliderValue = yardsPerDefensivePlayTeam2Values.last!
            }
            yardsPerDefensivePlayTeam2OperatorValue = selectedOperatorValue
            yardsPerDefensivePlayTeam2OperatorText = operatorText
            formSliderValue = yardsPerDefensivePlayTeam2SliderValue
            formOperatorValue = yardsPerDefensivePlayTeam2OperatorValue
            formOperatorText = yardsPerDefensivePlayTeam2OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(yardsPerDefensivePlayTeam2SliderValue))
            yardsPerDefensivePlayTeam2SliderFormValue = String(Int(yardsPerDefensivePlayTeam2SliderValue))
        case ("OPPONENT: YARDS/DEFENSIVE PLAY", true):
            operatorText = operatorDictionary["< >"]!
            yardsPerDefensivePlayTeam2RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            yardsPerDefensivePlayTeam2RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            yardsPerDefensivePlayTeam2OperatorValue = "< >"
            yardsPerDefensivePlayTeam2OperatorText = operatorText
            formRangeSliderLowerValue = yardsPerDefensivePlayTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = yardsPerDefensivePlayTeam2RangeSliderUpperValue
            formOperatorValue = yardsPerDefensivePlayTeam2OperatorValue
            formOperatorText = yardsPerDefensivePlayTeam2OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            yardsPerDefensivePlayTeam2SliderFormValue = String(Int(yardsPerDefensivePlayTeam2RangeSliderLowerValue)) + " & " + String(Int(yardsPerDefensivePlayTeam2RangeSliderUpperValue))
        case ("TEAM: EXTRA POINT ATTEMPTS", false):
            //operatorText = operatorDictionary["< >"]!
            //extraPointAttemptsTeam1SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                extraPointAttemptsTeam1SliderValue = extraPointAttemptsTeam1Values.last!
            }
            extraPointAttemptsTeam1OperatorValue = selectedOperatorValue
            extraPointAttemptsTeam1OperatorText = operatorText
            formSliderValue = extraPointAttemptsTeam1SliderValue
            formOperatorValue = extraPointAttemptsTeam1OperatorValue
            formOperatorText = extraPointAttemptsTeam1OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(extraPointAttemptsTeam1SliderValue))
            extraPointAttemptsTeam1SliderFormValue = String(Int(extraPointAttemptsTeam1SliderValue))
        case ("TEAM: EXTRA POINT ATTEMPTS", true):
            operatorText = operatorDictionary["< >"]!
            extraPointAttemptsTeam1RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            extraPointAttemptsTeam1RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            extraPointAttemptsTeam1OperatorValue = "< >"
            extraPointAttemptsTeam1OperatorText = operatorText
            formRangeSliderLowerValue = extraPointAttemptsTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = extraPointAttemptsTeam1RangeSliderUpperValue
            formOperatorValue = extraPointAttemptsTeam1OperatorValue
            formOperatorText = extraPointAttemptsTeam1OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            extraPointAttemptsTeam1SliderFormValue = String(Int(extraPointAttemptsTeam1RangeSliderLowerValue)) + " & " + String(Int(extraPointAttemptsTeam1RangeSliderUpperValue))
        case ("OPPONENT: EXTRA POINT ATTEMPTS", false):
            //operatorText = operatorDictionary["< >"]!
            //extraPointAttemptsTeam2SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                extraPointAttemptsTeam2SliderValue = extraPointAttemptsTeam2Values.last!
            }
            extraPointAttemptsTeam2OperatorValue = selectedOperatorValue
            extraPointAttemptsTeam2OperatorText = operatorText
            formSliderValue = extraPointAttemptsTeam2SliderValue
            formOperatorValue = extraPointAttemptsTeam2OperatorValue
            formOperatorText = extraPointAttemptsTeam2OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(extraPointAttemptsTeam2SliderValue))
            extraPointAttemptsTeam2SliderFormValue = String(Int(extraPointAttemptsTeam2SliderValue))
        case ("OPPONENT: EXTRA POINT ATTEMPTS", true):
            operatorText = operatorDictionary["< >"]!
            extraPointAttemptsTeam2RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            extraPointAttemptsTeam2RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            extraPointAttemptsTeam2OperatorValue = "< >"
            extraPointAttemptsTeam2OperatorText = operatorText
            formRangeSliderLowerValue = extraPointAttemptsTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = extraPointAttemptsTeam2RangeSliderUpperValue
            formOperatorValue = extraPointAttemptsTeam2OperatorValue
            formOperatorText = extraPointAttemptsTeam2OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            extraPointAttemptsTeam2SliderFormValue = String(Int(extraPointAttemptsTeam2RangeSliderLowerValue)) + " & " + String(Int(extraPointAttemptsTeam2RangeSliderUpperValue))
        case ("TEAM: EXTRA POINTS MADE", false):
            //operatorText = operatorDictionary["< >"]!
            //extraPointsMadeTeam1SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                extraPointsMadeTeam1SliderValue = extraPointsMadeTeam1Values.last!
            }
            extraPointsMadeTeam1OperatorValue = selectedOperatorValue
            extraPointsMadeTeam1OperatorText = operatorText
            formSliderValue = extraPointsMadeTeam1SliderValue
            formOperatorValue = extraPointsMadeTeam1OperatorValue
            formOperatorText = extraPointsMadeTeam1OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(extraPointsMadeTeam1SliderValue))
            extraPointsMadeTeam1SliderFormValue = String(Int(extraPointsMadeTeam1SliderValue))
        case ("TEAM: EXTRA POINTS MADE", true):
            operatorText = operatorDictionary["< >"]!
            extraPointsMadeTeam1RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            extraPointsMadeTeam1RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            extraPointsMadeTeam1OperatorValue = "< >"
            extraPointsMadeTeam1OperatorText = operatorText
            formRangeSliderLowerValue = extraPointsMadeTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = extraPointsMadeTeam1RangeSliderUpperValue
            formOperatorValue = extraPointsMadeTeam1OperatorValue
            formOperatorText = extraPointsMadeTeam1OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            extraPointsMadeTeam1SliderFormValue = String(Int(extraPointsMadeTeam1RangeSliderLowerValue)) + " & " + String(Int(extraPointsMadeTeam1RangeSliderUpperValue))
        case ("OPPONENT: EXTRA POINTS MADE", false):
            //operatorText = operatorDictionary["< >"]!
            //extraPointsMadeTeam2SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                extraPointsMadeTeam2SliderValue = extraPointsMadeTeam2Values.last!
            }
            extraPointsMadeTeam2OperatorValue = selectedOperatorValue
            extraPointsMadeTeam2OperatorText = operatorText
            formSliderValue = extraPointsMadeTeam2SliderValue
            formOperatorValue = extraPointsMadeTeam2OperatorValue
            formOperatorText = extraPointsMadeTeam2OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(extraPointsMadeTeam2SliderValue))
            extraPointsMadeTeam2SliderFormValue = String(Int(extraPointsMadeTeam2SliderValue))
        case ("OPPONENT: EXTRA POINTS MADE", true):
            operatorText = operatorDictionary["< >"]!
            extraPointsMadeTeam2RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            extraPointsMadeTeam2RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            extraPointsMadeTeam2OperatorValue = "< >"
            extraPointsMadeTeam2OperatorText = operatorText
            formRangeSliderLowerValue = extraPointsMadeTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = extraPointsMadeTeam2RangeSliderUpperValue
            formOperatorValue = extraPointsMadeTeam2OperatorValue
            formOperatorText = extraPointsMadeTeam2OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            extraPointsMadeTeam2SliderFormValue = String(Int(extraPointsMadeTeam2RangeSliderLowerValue)) + " & " + String(Int(extraPointsMadeTeam2RangeSliderUpperValue))
        case ("TEAM: FIELD GOAL ATTEMPTS", false):
            //operatorText = operatorDictionary["< >"]!
            //fieldGoalAttemptsTeam1SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                fieldGoalAttemptsTeam1SliderValue = fieldGoalAttemptsTeam1Values.last!
            }
            fieldGoalAttemptsTeam1OperatorValue = selectedOperatorValue
            fieldGoalAttemptsTeam1OperatorText = operatorText
            formSliderValue = fieldGoalAttemptsTeam1SliderValue
            formOperatorValue = fieldGoalAttemptsTeam1OperatorValue
            formOperatorText = fieldGoalAttemptsTeam1OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(fieldGoalAttemptsTeam1SliderValue))
            fieldGoalAttemptsTeam1SliderFormValue = String(Int(fieldGoalAttemptsTeam1SliderValue))
        case ("TEAM: FIELD GOAL ATTEMPTS", true):
            operatorText = operatorDictionary["< >"]!
            fieldGoalAttemptsTeam1RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            fieldGoalAttemptsTeam1RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            fieldGoalAttemptsTeam1OperatorValue = "< >"
            fieldGoalAttemptsTeam1OperatorText = operatorText
            formRangeSliderLowerValue = fieldGoalAttemptsTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = fieldGoalAttemptsTeam1RangeSliderUpperValue
            formOperatorValue = fieldGoalAttemptsTeam1OperatorValue
            formOperatorText = fieldGoalAttemptsTeam1OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            fieldGoalAttemptsTeam1SliderFormValue = String(Int(fieldGoalAttemptsTeam1RangeSliderLowerValue)) + " & " + String(Int(fieldGoalAttemptsTeam1RangeSliderUpperValue))
        case ("OPPONENT: FIELD GOAL ATTEMPTS", false):
            //operatorText = operatorDictionary["< >"]!
            //fieldGoalAttemptsTeam2SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                fieldGoalAttemptsTeam2SliderValue = fieldGoalAttemptsTeam2Values.last!
            }
            fieldGoalAttemptsTeam2OperatorValue = selectedOperatorValue
            fieldGoalAttemptsTeam2OperatorText = operatorText
            formSliderValue = fieldGoalAttemptsTeam2SliderValue
            formOperatorValue = fieldGoalAttemptsTeam2OperatorValue
            formOperatorText = fieldGoalAttemptsTeam2OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(fieldGoalAttemptsTeam2SliderValue))
            fieldGoalAttemptsTeam2SliderFormValue = String(Int(fieldGoalAttemptsTeam2SliderValue))
        case ("OPPONENT: FIELD GOAL ATTEMPTS", true):
            operatorText = operatorDictionary["< >"]!
            fieldGoalAttemptsTeam2RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            fieldGoalAttemptsTeam2RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            fieldGoalAttemptsTeam2OperatorValue = "< >"
            fieldGoalAttemptsTeam2OperatorText = operatorText
            formRangeSliderLowerValue = fieldGoalAttemptsTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = fieldGoalAttemptsTeam2RangeSliderUpperValue
            formOperatorValue = fieldGoalAttemptsTeam2OperatorValue
            formOperatorText = fieldGoalAttemptsTeam2OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            fieldGoalAttemptsTeam2SliderFormValue = String(Int(fieldGoalAttemptsTeam2RangeSliderLowerValue)) + " & " + String(Int(fieldGoalAttemptsTeam2RangeSliderUpperValue))
        case ("TEAM: FIELD GOALS MADE", false):
            //operatorText = operatorDictionary["< >"]!
            //fieldGoalsMadeTeam1SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                fieldGoalsMadeTeam1SliderValue = fieldGoalsMadeTeam1Values.last!
            }
            fieldGoalsMadeTeam1OperatorValue = selectedOperatorValue
            fieldGoalsMadeTeam1OperatorText = operatorText
            formSliderValue = fieldGoalsMadeTeam1SliderValue
            formOperatorValue = fieldGoalsMadeTeam1OperatorValue
            formOperatorText = fieldGoalsMadeTeam1OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(fieldGoalsMadeTeam1SliderValue))
            fieldGoalsMadeTeam1SliderFormValue = String(Int(fieldGoalsMadeTeam1SliderValue))
        case ("TEAM: FIELD GOALS MADE", true):
            operatorText = operatorDictionary["< >"]!
            fieldGoalsMadeTeam1RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            fieldGoalsMadeTeam1RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            fieldGoalsMadeTeam1OperatorValue = "< >"
            fieldGoalsMadeTeam1OperatorText = operatorText
            formRangeSliderLowerValue = fieldGoalsMadeTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = fieldGoalsMadeTeam1RangeSliderUpperValue
            formOperatorValue = fieldGoalsMadeTeam1OperatorValue
            formOperatorText = fieldGoalsMadeTeam1OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            fieldGoalsMadeTeam1SliderFormValue = String(Int(fieldGoalsMadeTeam1RangeSliderLowerValue)) + " & " + String(Int(fieldGoalsMadeTeam1RangeSliderUpperValue))
        case ("OPPONENT: FIELD GOALS MADE", false):
            //operatorText = operatorDictionary["< >"]!
            //fieldGoalsMadeTeam2SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                fieldGoalsMadeTeam2SliderValue = fieldGoalsMadeTeam2Values.last!
            }
            fieldGoalsMadeTeam2OperatorValue = selectedOperatorValue
            fieldGoalsMadeTeam2OperatorText = operatorText
            formSliderValue = fieldGoalsMadeTeam2SliderValue
            formOperatorValue = fieldGoalsMadeTeam2OperatorValue
            formOperatorText = fieldGoalsMadeTeam2OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(fieldGoalsMadeTeam2SliderValue))
            fieldGoalsMadeTeam2SliderFormValue = String(Int(fieldGoalsMadeTeam2SliderValue))
        case ("OPPONENT: FIELD GOALS MADE", true):
            operatorText = operatorDictionary["< >"]!
            fieldGoalsMadeTeam2RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            fieldGoalsMadeTeam2RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            fieldGoalsMadeTeam2OperatorValue = "< >"
            fieldGoalsMadeTeam2OperatorText = operatorText
            formRangeSliderLowerValue = fieldGoalsMadeTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = fieldGoalsMadeTeam2RangeSliderUpperValue
            formOperatorValue = fieldGoalsMadeTeam2OperatorValue
            formOperatorText = fieldGoalsMadeTeam2OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            fieldGoalsMadeTeam2SliderFormValue = String(Int(fieldGoalsMadeTeam2RangeSliderLowerValue)) + " & " + String(Int(fieldGoalsMadeTeam2RangeSliderUpperValue))
        case ("TEAM: PUNTS", false):
            //operatorText = operatorDictionary["< >"]!
            //puntsTeam1SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                puntsTeam1SliderValue = puntsTeam1Values.last!
            }
            puntsTeam1OperatorValue = selectedOperatorValue
            puntsTeam1OperatorText = operatorText
            formSliderValue = puntsTeam1SliderValue
            formOperatorValue = puntsTeam1OperatorValue
            formOperatorText = puntsTeam1OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(puntsTeam1SliderValue))
            puntsTeam1SliderFormValue = String(Int(puntsTeam1SliderValue))
        case ("TEAM: PUNTS", true):
            operatorText = operatorDictionary["< >"]!
            puntsTeam1RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            puntsTeam1RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            puntsTeam1OperatorValue = "< >"
            puntsTeam1OperatorText = operatorText
            formRangeSliderLowerValue = puntsTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = puntsTeam1RangeSliderUpperValue
            formOperatorValue = puntsTeam1OperatorValue
            formOperatorText = puntsTeam1OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            puntsTeam1SliderFormValue = String(Int(puntsTeam1RangeSliderLowerValue)) + " & " + String(Int(puntsTeam1RangeSliderUpperValue))
        case ("OPPONENT: PUNTS", false):
            //operatorText = operatorDictionary["< >"]!
            //puntsTeam2SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                puntsTeam2SliderValue = puntsTeam2Values.last!
            }
            puntsTeam2OperatorValue = selectedOperatorValue
            puntsTeam2OperatorText = operatorText
            formSliderValue = puntsTeam2SliderValue
            formOperatorValue = puntsTeam2OperatorValue
            formOperatorText = puntsTeam2OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(puntsTeam2SliderValue))
            puntsTeam2SliderFormValue = String(Int(puntsTeam2SliderValue))
        case ("OPPONENT: PUNTS", true):
            operatorText = operatorDictionary["< >"]!
            puntsTeam2RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            puntsTeam2RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            puntsTeam2OperatorValue = "< >"
            puntsTeam2OperatorText = operatorText
            formRangeSliderLowerValue = puntsTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = puntsTeam2RangeSliderUpperValue
            formOperatorValue = puntsTeam2OperatorValue
            formOperatorText = puntsTeam2OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            puntsTeam2SliderFormValue = String(Int(puntsTeam2RangeSliderLowerValue)) + " & " + String(Int(puntsTeam2RangeSliderUpperValue))
        case ("TEAM: PUNT YARDS", false):
            //operatorText = operatorDictionary["< >"]!
            //puntYardsTeam1SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                puntYardsTeam1SliderValue = puntYardsTeam1Values.last!
            }
            puntYardsTeam1OperatorValue = selectedOperatorValue
            puntYardsTeam1OperatorText = operatorText
            formSliderValue = puntYardsTeam1SliderValue
            formOperatorValue = puntYardsTeam1OperatorValue
            formOperatorText = puntYardsTeam1OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(puntYardsTeam1SliderValue))
            puntYardsTeam1SliderFormValue = String(Int(puntYardsTeam1SliderValue))
        case ("TEAM: PUNT YARDS", true):
            operatorText = operatorDictionary["< >"]!
            puntYardsTeam1RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            puntYardsTeam1RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            puntYardsTeam1OperatorValue = "< >"
            puntYardsTeam1OperatorText = operatorText
            formRangeSliderLowerValue = puntYardsTeam1RangeSliderLowerValue
            formRangeSliderUpperValue = puntYardsTeam1RangeSliderUpperValue
            formOperatorValue = puntYardsTeam1OperatorValue
            formOperatorText = puntYardsTeam1OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            puntYardsTeam1SliderFormValue = String(Int(puntYardsTeam1RangeSliderLowerValue)) + " & " + String(Int(puntYardsTeam1RangeSliderUpperValue))
        case ("OPPONENT: PUNT YARDS", false):
            //operatorText = operatorDictionary["< >"]!
            //puntYardsTeam2SliderValue = rowValue
            if formSliderValue == Float(-10000) {
                puntYardsTeam2SliderValue = puntYardsTeam2Values.last!
            }
            puntYardsTeam2OperatorValue = selectedOperatorValue
            puntYardsTeam2OperatorText = operatorText
            formSliderValue = puntYardsTeam2SliderValue
            formOperatorValue = puntYardsTeam2OperatorValue
            formOperatorText = puntYardsTeam2OperatorText
            buttonText = headerLabel + "\0" + formOperatorText + String(Int(formSliderValue))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(puntYardsTeam2SliderValue))
            puntYardsTeam2SliderFormValue = String(Int(puntYardsTeam2SliderValue))
        case ("OPPONENT: PUNT YARDS", true):
            operatorText = operatorDictionary["< >"]!
            puntYardsTeam2RangeSliderLowerValue = Float(rangeSliderObject.lowerValue)
            puntYardsTeam2RangeSliderUpperValue = Float(rangeSliderObject.upperValue)
            puntYardsTeam2OperatorValue = "< >"
            puntYardsTeam2OperatorText = operatorText
            formRangeSliderLowerValue = puntYardsTeam2RangeSliderLowerValue
            formRangeSliderUpperValue = puntYardsTeam2RangeSliderUpperValue
            formOperatorValue = puntYardsTeam2OperatorValue
            formOperatorText = puntYardsTeam2OperatorText
            if (formRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && formRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValue = formOperatorText + String(Int(formRangeSliderLowerValue)) + " & " + String(Int(formRangeSliderUpperValue))
            puntYardsTeam2SliderFormValue = String(Int(puntYardsTeam2RangeSliderLowerValue)) + " & " + String(Int(puntYardsTeam2RangeSliderUpperValue))
        default:
            return
        }
        
        if (rangeSliderObject.lowerValue == rangeSliderObject.minimumValue && rangeSliderObject.upperValue == rangeSliderObject.maximumValue && selectedOperatorValue == "< >") ||
            (rangeSliderObject.lowerValue == rangeSliderObject.minimumValue && rangeSliderObject.upperValue == rangeSliderObject.maximumValue && selectedOperatorValue == "-10000") {
            buttonText = self.headerLabel + "\0" + operatorDictionary["-10000"]! + "ANY"
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sliderNotification"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func labelTapped() {
        //print("labelTapped()")
        switch(tagText) {
        case "TEAM: STREAK":
            if winningLosingStreakTeam1SliderFormValue == "-10000" || (winningLosingStreakTeam1OperatorValue == "< >" && winningLosingStreakTeam1RangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && winningLosingStreakTeam1RangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + winningLosingStreakTeam1OperatorValue
                self.titleString = winningLosingStreakTeam1SliderFormValue
            }
        case "OPPONENT: STREAK":
            if winningLosingStreakTeam2SliderFormValue == "-10000" || (winningLosingStreakTeam2OperatorValue == "< >" && winningLosingStreakTeam2RangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && winningLosingStreakTeam2RangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + winningLosingStreakTeam2OperatorValue
                self.titleString = winningLosingStreakTeam2SliderFormValue
            }
        case "TEAM: SEASON WIN %":
            if seasonWinPercentageTeam1SliderFormValue == "-10000" || (seasonWinPercentageTeam1OperatorValue == "< >" && seasonWinPercentageTeam1RangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && seasonWinPercentageTeam1RangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + seasonWinPercentageTeam1OperatorValue
                self.titleString = seasonWinPercentageTeam1SliderFormValue
            }
        case "OPPONENT: SEASON WIN %":
            if seasonWinPercentageTeam2SliderFormValue == "-10000" || (seasonWinPercentageTeam2OperatorValue == "< >" && seasonWinPercentageTeam2RangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && seasonWinPercentageTeam2RangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + seasonWinPercentageTeam2OperatorValue
                self.titleString = seasonWinPercentageTeam2SliderFormValue
            }
        case "SEASON":
            if seasonSliderFormValue == "-10000" || (seasonOperatorValue == "< >" && seasonRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && seasonRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + seasonOperatorValue
                self.titleString = seasonSliderFormValue
            }
        case "GAME NUMBER":
            if gameNumberSliderFormValue == "-10000" || (gameNumberOperatorValue == "< >" && gameNumberRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && gameNumberRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + gameNumberOperatorValue
                self.titleString = gameNumberSliderFormValue
            }
        case "WEEK":
             if weekSliderFormValue == "-10000" || (weekOperatorValue == "< >" && weekRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && weekRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + weekOperatorValue
                self.titleString = weekSliderFormValue
            }
        case "TEAM: SPREAD":
            //if spreadSliderFormValue == "-10000" || (spreadOperatorValue == "< >" && spreadRangeSliderLowerValue == Float(-30.0) && spreadRangeSliderUpperValue == Float(30.0)) {
            if spreadSliderFormValue == "-10000" || (spreadOperatorValue == "< >" && spreadRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && spreadRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + spreadOperatorValue
                self.titleString = spreadSliderFormValue
            }
        case "OVER/UNDER":
            if overUnderSliderFormValue == "-10000" || (overUnderOperatorValue == "< >" && overUnderRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && overUnderRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + overUnderOperatorValue
                self.titleString = overUnderSliderFormValue
            }
        case "TEMPERATURE (F)":
             if temperatureSliderFormValue == "-10000" || (temperatureOperatorValue == "< >" && temperatureRangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && temperatureRangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + temperatureOperatorValue
                self.titleString = temperatureSliderFormValue + "°"
            }
        case "TEAM: TOTAL POINTS":
             if totalPointsTeam1SliderFormValue == "-10000" || (totalPointsTeam1OperatorValue == "< >" && totalPointsTeam1RangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && totalPointsTeam1RangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + totalPointsTeam1OperatorValue
                self.titleString = totalPointsTeam1SliderFormValue
            }
        case "OPPONENT: TOTAL POINTS":
            if totalPointsTeam2SliderFormValue == "-10000" || (totalPointsTeam2OperatorValue == "< >" && totalPointsTeam2RangeSliderLowerValue == Float(rangeSliderObject.minimumValue) && totalPointsTeam2RangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + totalPointsTeam2OperatorValue
                self.titleString = totalPointsTeam2SliderFormValue
            }
        case "TEAM: TOUCHDOWNS":
             if touchdownsTeam1SliderFormValue == "-10000" || (touchdownsTeam1OperatorValue == "< >" &&
                touchdownsTeam1RangeSliderLowerValue == Float(rangeSliderObject.minimumValue) &&
                touchdownsTeam1RangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + touchdownsTeam1OperatorValue
                self.titleString = touchdownsTeam1SliderFormValue
            }
        case "OPPONENT: TOUCHDOWNS":
            if touchdownsTeam2SliderFormValue == "-10000" || (touchdownsTeam2OperatorValue == "< >" &&
                touchdownsTeam2RangeSliderLowerValue == Float(rangeSliderObject.minimumValue) &&
                touchdownsTeam2RangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + touchdownsTeam2OperatorValue
                self.titleString = touchdownsTeam2SliderFormValue
            }
        
        case "TEAM: OFFENSIVE TOUCHDOWNS":
            if offensiveTouchdownsTeam1SliderFormValue == "-10000" || (offensiveTouchdownsTeam1OperatorValue == "< >" &&
                offensiveTouchdownsTeam1RangeSliderLowerValue == Float(rangeSliderObject.minimumValue) &&
                offensiveTouchdownsTeam1RangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + offensiveTouchdownsTeam1OperatorValue
                self.titleString = offensiveTouchdownsTeam1SliderFormValue
            }
        case "OPPONENT: OFFENSIVE TOUCHDOWNS":
            if offensiveTouchdownsTeam2SliderFormValue == "-10000" || (offensiveTouchdownsTeam2OperatorValue == "< >" &&
                offensiveTouchdownsTeam2RangeSliderLowerValue == Float(rangeSliderObject.minimumValue) &&
                offensiveTouchdownsTeam2RangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + offensiveTouchdownsTeam2OperatorValue
                self.titleString = offensiveTouchdownsTeam2SliderFormValue
            }
        case "TEAM: DEFENSIVE TOUCHDOWNS":
            if defensiveTouchdownsTeam1SliderFormValue == "-10000" || (defensiveTouchdownsTeam1OperatorValue == "< >" &&
                defensiveTouchdownsTeam1RangeSliderLowerValue == Float(rangeSliderObject.minimumValue) &&
                defensiveTouchdownsTeam1RangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + defensiveTouchdownsTeam1OperatorValue
                self.titleString = defensiveTouchdownsTeam1SliderFormValue
            }
        case "OPPONENT: DEFENSIVE TOUCHDOWNS":
            if defensiveTouchdownsTeam2SliderFormValue == "-10000" || (defensiveTouchdownsTeam2OperatorValue == "< >" &&
                defensiveTouchdownsTeam2RangeSliderLowerValue == Float(rangeSliderObject.minimumValue) &&
                defensiveTouchdownsTeam2RangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + defensiveTouchdownsTeam2OperatorValue
                self.titleString = defensiveTouchdownsTeam2SliderFormValue
            }
            
        case "TEAM: TURNOVERS":
            if turnoversCommittedTeam1SliderFormValue == "-10000" || (turnoversCommittedTeam1OperatorValue == "< >" &&
                turnoversCommittedTeam1RangeSliderLowerValue == Float(rangeSliderObject.minimumValue) &&
                turnoversCommittedTeam1RangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + turnoversCommittedTeam1OperatorValue
                self.titleString = turnoversCommittedTeam1SliderFormValue
            }
        case "OPPONENT: TURNOVERS":
            if turnoversCommittedTeam2SliderFormValue == "-10000" || (turnoversCommittedTeam2OperatorValue == "< >" &&
                turnoversCommittedTeam2RangeSliderLowerValue == Float(rangeSliderObject.minimumValue) &&
                turnoversCommittedTeam2RangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + turnoversCommittedTeam2OperatorValue
                self.titleString = turnoversCommittedTeam2SliderFormValue
            }
        case "TEAM: PENALTIES":
            if penaltiesCommittedTeam1SliderFormValue == "-10000" || (penaltiesCommittedTeam1OperatorValue == "< >" &&
                penaltiesCommittedTeam1RangeSliderLowerValue == Float(rangeSliderObject.minimumValue) &&
                penaltiesCommittedTeam1RangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + penaltiesCommittedTeam1OperatorValue
                self.titleString = penaltiesCommittedTeam1SliderFormValue
            }
        case "OPPONENT: PENALTIES":
            if penaltiesCommittedTeam2SliderFormValue == "-10000" || (penaltiesCommittedTeam2OperatorValue == "< >" &&
                penaltiesCommittedTeam2RangeSliderLowerValue == Float(rangeSliderObject.minimumValue) &&
                penaltiesCommittedTeam2RangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + penaltiesCommittedTeam2OperatorValue
                self.titleString = penaltiesCommittedTeam2SliderFormValue
            }
        case "TEAM: TOTAL YARDS":
            if totalYardsTeam1SliderFormValue == "-10000" || (totalYardsTeam1OperatorValue == "< >" &&
                totalYardsTeam1RangeSliderLowerValue == Float(rangeSliderObject.minimumValue) &&
                totalYardsTeam1RangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + totalYardsTeam1OperatorValue
                self.titleString = totalYardsTeam1SliderFormValue
            }
        case "OPPONENT: TOTAL YARDS":
            if totalYardsTeam2SliderFormValue == "-10000" || (totalYardsTeam2OperatorValue == "< >" &&
                totalYardsTeam2RangeSliderLowerValue == Float(rangeSliderObject.minimumValue) &&
                totalYardsTeam2RangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + totalYardsTeam2OperatorValue
                self.titleString = totalYardsTeam2SliderFormValue
            }
        case "TEAM: PASSING YARDS":
            if passingYardsTeam1SliderFormValue == "-10000" || (passingYardsTeam1OperatorValue == "< >" &&
                passingYardsTeam1RangeSliderLowerValue == Float(rangeSliderObject.minimumValue) &&
                passingYardsTeam1RangeSliderUpperValue == Float(rangeSliderObject.maximumValue)) {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + passingYardsTeam1OperatorValue
                self.titleString = passingYardsTeam1SliderFormValue
            }
        case "OPPONENT: PASSING YARDS":
            if passingYardsTeam2SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + passingYardsTeam2OperatorValue
                self.titleString = passingYardsTeam2SliderFormValue
            }
        case "TEAM: RUSHING YARDS":
            if rushingYardsTeam1SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + rushingYardsTeam1OperatorValue
                self.titleString = rushingYardsTeam1SliderFormValue
            }
        case "OPPONENT: RUSHING YARDS":
            if rushingYardsTeam2SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + rushingYardsTeam2OperatorValue
                self.titleString = rushingYardsTeam2SliderFormValue
            }
        case "TEAM: QUARTERBACK RATING":
            if quarterbackRatingTeam1SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + quarterbackRatingTeam1OperatorValue
                self.titleString = quarterbackRatingTeam1SliderFormValue
            }
        case "OPPONENT: QUARTERBACK RATING":
            if quarterbackRatingTeam2SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + quarterbackRatingTeam2OperatorValue
                self.titleString = quarterbackRatingTeam2SliderFormValue
            }
        case "TEAM: TIMES SACKED":
            if timesSackedTeam1SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + timesSackedTeam1OperatorValue
                self.titleString = timesSackedTeam1SliderFormValue
            }
        case "OPPONENT: TIMES SACKED":
            if timesSackedTeam2SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + timesSackedTeam2OperatorValue
                self.titleString = timesSackedTeam2SliderFormValue
            }
        case "TEAM: INTERCEPTIONS THROWN":
            if interceptionsThrownTeam1SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + interceptionsThrownTeam1OperatorValue
                self.titleString = interceptionsThrownTeam1SliderFormValue
            }
        case "OPPONENT: INTERCEPTIONS THROWN":
            if interceptionsThrownTeam2SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + interceptionsThrownTeam2OperatorValue
                self.titleString = interceptionsThrownTeam2SliderFormValue
            }
        case "TEAM: OFFENSIVE PLAYS":
            if offensivePlaysTeam1SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + offensivePlaysTeam1OperatorValue
                self.titleString = offensivePlaysTeam1SliderFormValue
            }
        case "OPPONENT: OFFENSIVE PLAYS":
            if offensivePlaysTeam2SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + offensivePlaysTeam2OperatorValue
                self.titleString = offensivePlaysTeam2SliderFormValue
            }
        case "TEAM: YARDS/OFFENSIVE PLAY":
            if yardsPerOffensivePlayTeam1SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + yardsPerOffensivePlayTeam1OperatorValue
                self.titleString = yardsPerOffensivePlayTeam1SliderFormValue
            }
        case "OPPONENT: YARDS/OFFENSIVE PLAY":
            if yardsPerOffensivePlayTeam2SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + yardsPerOffensivePlayTeam2OperatorValue
                self.titleString = yardsPerOffensivePlayTeam2SliderFormValue
            }
        case "TEAM: SACKS":
            if sacksTeam1SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + sacksTeam1OperatorValue
                self.titleString = sacksTeam1SliderFormValue
            }
        case "OPPONENT: SACKS":
            if sacksTeam2SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + sacksTeam2OperatorValue
                self.titleString = sacksTeam2SliderFormValue
            }
        case "TEAM: INTERCEPTIONS":
            if interceptionsTeam1SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + interceptionsTeam1OperatorValue
                self.titleString = interceptionsTeam1SliderFormValue
            }
        case "OPPONENT: INTERCEPTIONS":
            if interceptionsTeam2SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + interceptionsTeam2OperatorValue
                self.titleString = interceptionsTeam2SliderFormValue
            }
        case "TEAM: SAFETIES":
            if safetiesTeam1SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + safetiesTeam1OperatorValue
                self.titleString = safetiesTeam1SliderFormValue
            }
        case "OPPONENT: SAFETIES":
            if safetiesTeam2SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + safetiesTeam2OperatorValue
                self.titleString = safetiesTeam2SliderFormValue
            }
        case "TEAM: DEFENSIVE PLAYS":
            if defensivePlaysTeam1SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + defensivePlaysTeam1OperatorValue
                self.titleString = defensivePlaysTeam1SliderFormValue
            }
        case "OPPONENT: DEFENSIVE PLAYS":
            if defensivePlaysTeam2SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + defensivePlaysTeam2OperatorValue
                self.titleString = defensivePlaysTeam2SliderFormValue
            }
        case "TEAM: YARDS/DEFENSIVE PLAY":
            if yardsPerDefensivePlayTeam1SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + yardsPerDefensivePlayTeam1OperatorValue
                self.titleString = yardsPerDefensivePlayTeam1SliderFormValue
            }
        case "OPPONENT: YARDS/DEFENSIVE PLAY":
            if yardsPerDefensivePlayTeam2SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + yardsPerDefensivePlayTeam2OperatorValue
                self.titleString = yardsPerDefensivePlayTeam2SliderFormValue
            }
        case "TEAM: EXTRA POINT ATTEMPTS":
            if extraPointAttemptsTeam1SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + extraPointAttemptsTeam1OperatorValue
                self.titleString = extraPointAttemptsTeam1SliderFormValue
            }
        case "OPPONENT: EXTRA POINT ATTEMPTS":
            if extraPointAttemptsTeam2SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + extraPointAttemptsTeam2OperatorValue
                self.titleString = extraPointAttemptsTeam2SliderFormValue
            }
        case "TEAM: EXTRA POINTS MADE":
            if extraPointsMadeTeam1SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + extraPointsMadeTeam1OperatorValue
                self.titleString = extraPointsMadeTeam1SliderFormValue
            }
        case "OPPONENT: EXTRA POINTS MADE":
            if extraPointsMadeTeam2SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + extraPointsMadeTeam2OperatorValue
                self.titleString = extraPointsMadeTeam2SliderFormValue
            }
        case "TEAM: FIELD GOAL ATTEMPTS":
            if fieldGoalAttemptsTeam1SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + fieldGoalAttemptsTeam1OperatorValue
                self.titleString = fieldGoalAttemptsTeam1SliderFormValue
            }
        case "OPPONENT: FIELD GOAL ATTEMPTS":
            if fieldGoalAttemptsTeam2SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + fieldGoalAttemptsTeam2OperatorValue
                self.titleString = fieldGoalAttemptsTeam2SliderFormValue
            }
        case "TEAM: FIELD GOALS MADE":
            if fieldGoalsMadeTeam1SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + fieldGoalsMadeTeam1OperatorValue
                self.titleString = fieldGoalsMadeTeam1SliderFormValue
            }
        case "OPPONENT: FIELD GOALS MADE":
            if fieldGoalsMadeTeam2SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + fieldGoalsMadeTeam2OperatorValue
                self.titleString = fieldGoalsMadeTeam2SliderFormValue
            }
        case "TEAM: PUNTS":
            if puntsTeam1SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + puntsTeam1OperatorValue
                self.titleString = puntsTeam1SliderFormValue
            }
        case "OPPONENT: PUNTS":
            if puntsTeam2SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + puntsTeam2OperatorValue
                self.titleString = puntsTeam2SliderFormValue
            }
        case "TEAM: PUNT YARDS":
            if puntYardsTeam1SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + puntYardsTeam1OperatorValue
                self.titleString = puntYardsTeam1SliderFormValue
            }
        case "OPPONENT: PUNT YARDS":
            if puntYardsTeam2SliderFormValue == "-10000" {
                self.alertController.title = tagText + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagText + " " + puntYardsTeam2OperatorValue
                self.titleString = puntYardsTeam2SliderFormValue
            }
        default:
                self.titleString = "ANY"
                self.alertController.title = tagText + " " + "="
        }
        self.alertController.message = self.titleString
        self.alertController.buttonTitleColor = orangeColor
        self.alertController.buttonFont = fifteenBlackRoboto
        self.alertController.view.backgroundColor = lightGreyColor.withAlphaComponent(0.8)
        self.alertController.titleFont = sixteenBoldRobotoCondensed
        self.alertController.messageFont = fifteenRegularRobotoCondensed
        self.alertController.titleColor = darkGreyColor
        self.alertController.messageColor = dashboardGreyColor
        self.present(alertController, animated: true) {
            //print("present(alertController()")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.backgroundColor = darkGreyColor
        self.view.backgroundColor = darkGreyColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.toolbar.isHidden = true
        //print("viewWillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView.backgroundColor = darkGreyColor
        self.view.backgroundColor = darkGreyColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.toolbar.isHidden = true
    }
    
    @objc func clearSliderSelections() {
        print("-------clearSliderSelections() STARTED-------")
        clearSliderIndicator = tagText
        print("clearSliderIndicator: \(clearSliderIndicator)")
        //let sliderRow: SliderRow! = self.form.rowBy(tag: "SLIDER")
        let segmentedRow: SegmentedRow<String>! = self.form.rowBy(tag: "OPERATOR")
        print("segmentedRow.value: ")
        print(segmentedRow.value!)
        if segmentedRow.value == "< >" {
            //sliderRow.value! = self.sliderValues.last!
            rangeSliderActivated()
        } else {
            segmentedRow.value! = "< >"
            segmentedRow.reload()
            //rangeSliderActivated()
            
            //sliderRow.value! = self.sliderValues.last!
            //This will reset the single value slider to the maximum value
            //Decided not to implement due to increased query time
            //self.tableView.reloadData()
        }
        clearSliderIndicator = ""
        print("clearSliderIndicator: \(clearSliderIndicator)")
        print("-------clearSliderSelections() FINISHED-------")
    }
}
