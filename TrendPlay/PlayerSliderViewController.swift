//
//  PlayerSliderViewController.swift
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

class PlayerSliderViewController: FormViewController, FloatyDelegate {
    @IBOutlet weak var playerRangeSliderObject: CustomRangeSlider!
    @IBOutlet weak var buttonView: UIButton!
    let doneButtonImage = UIImage(named: "doneEmpty")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    
    var headerLabel: String = ""
    var sliderValuesPlayer = [Float(0), Float(1), Float(2), Float(3), Float(4), Float(5)]
    var buttonText: String = ""
    var buttonTextMutableString = NSMutableAttributedString()
    let char: Character = "\0"
    let spacing = CGFloat(-0.2)
    var queryEnglishString: String = ""
    var rangeBooleanPlayer: Bool = false
    let frameX: Float = 23.0
    let sliderFrameHeightRatio: Float = Float(35.0/screenHeight) //Float(35.0/667.0)
    let rangeSliderFrameHeightRatio: Float = Float(130.0/screenHeight) //Float(screenHeight * 0.1874) //Float(125.0/667.0)
    let sliderFrameWidthRatio: Float = Float(329.0/screenWidth) //Float(329.0/375.0)
    let rangeSliderFrameWidthRatio: Float = Float(327.0/screenWidth) //Float(327.0/375.0)
    let frameHeight: Float = 31.0
    var playerRangeSliderObjectMinimumValue: Double = -10000
    var playerRangeSliderObjectMaximumValue: Double = -10000
    var team1ButtonLabelPlayer: String = ""
    var team2ButtonLabelPlayer: String = ""
    var operatorDictionaryPlayer = ["-10000" : " EQUAL ",
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
        print("PlayerSliderVC Loaded")
        let floatActionButton = Floaty()
        let floatyItem = FloatyItem()
        var operatorsArrayPlayer: Array<Any>
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
        raisedButton.addTarget(self, action: #selector(PlayerSliderViewController.labelTapped), for: .touchUpInside)
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
        
        switch (tagTextPlayer) {
        case "PLAYER TEAM: STREAK":
            self.operatorDictionaryPlayer = ["-10000" : " IS ",
                                  "=" : " IS ",
                                  "≠" : " IS NOT ",
                                  "<" : " IS WORSE THAN ",
                                  ">" : " IS BETTER THAN ",
                                  "< >" : " IS BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                headerLabel = tagTextPlayer
            } else {
                if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team1ButtonLabelPlayer = "NEW YORK (G)"
                } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                    team1ButtonLabelPlayer = "NEW YORK (J)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabelPlayer = team1ListValuePlayer[0]
                    var team1TextArray = team1ButtonLabelPlayer.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabelPlayer = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = winningLosingStreakTeam1ValuesPlayer
            formSliderValuePlayer = winningLosingStreakTeam1SliderValuePlayer
            formRangeSliderLowerValuePlayer = winningLosingStreakTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = winningLosingStreakTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = winningLosingStreakTeam1OperatorValuePlayer
            formOperatorTextPlayer = winningLosingStreakTeam1OperatorTextPlayer
        case "OPPONENT: STREAK":
            self.operatorDictionaryPlayer = ["-10000" : " IS ",
                                  "=" : " IS ",
                                  "≠" : " IS NOT ",
                                  "<" : " IS WORSE THAN ",
                                  ">" : " IS BETTER THAN ",
                                  "< >" : " IS BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                headerLabel = tagTextPlayer
            } else {
                if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team2ButtonLabelPlayer = "NEW YORK (G)"
                } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                    team2ButtonLabelPlayer = "NEW YORK (J)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabelPlayer = team2ListValuePlayer[0]
                    var team2TextArray = team2ButtonLabelPlayer.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabelPlayer = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = winningLosingStreakTeam2ValuesPlayer
            formSliderValuePlayer = winningLosingStreakTeam2SliderValuePlayer
            formRangeSliderLowerValuePlayer = winningLosingStreakTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = winningLosingStreakTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = winningLosingStreakTeam2OperatorValuePlayer
            formOperatorTextPlayer = winningLosingStreakTeam2OperatorTextPlayer
        case "PLAYER TEAM: SEASON WIN %":
            self.operatorDictionaryPlayer = ["-10000" : " IS ",
                                  "=" : " IS ",
                                  "≠" : " IS NOT ",
                                  "<" : " IS LOWER THAN ",
                                  ">" : " IS HIGHER THAN ",
                                  "< >" : " IS BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                headerLabel = tagTextPlayer
            } else {
                if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team1ButtonLabelPlayer = "NEW YORK (G)"
                } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                    team1ButtonLabelPlayer = "NEW YORK (J)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabelPlayer = team1ListValuePlayer[0]
                    var team1TextArray = team1ButtonLabelPlayer.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabelPlayer = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = seasonWinPercentageTeam1ValuesPlayer
            formSliderValuePlayer = seasonWinPercentageTeam1SliderValuePlayer
            formRangeSliderLowerValuePlayer = seasonWinPercentageTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = seasonWinPercentageTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = seasonWinPercentageTeam1OperatorValuePlayer
            formOperatorTextPlayer = seasonWinPercentageTeam1OperatorTextPlayer
        case "OPPONENT: SEASON WIN %":
            self.operatorDictionaryPlayer = ["-10000" : " IS ",
                                  "=" : " IS ",
                                  "≠" : " IS NOT ",
                                  "<" : " IS LOWER THAN ",
                                  ">" : " IS HIGHER THAN ",
                                  "< >" : " IS BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                headerLabel = tagTextPlayer
            } else {
                if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team2ButtonLabelPlayer = "NEW YORK (G)"
                } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                    team2ButtonLabelPlayer = "NEW YORK (J)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabelPlayer = team2ListValuePlayer[0]
                    var team2TextArray = team2ButtonLabelPlayer.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabelPlayer = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = seasonWinPercentageTeam2ValuesPlayer
            formSliderValuePlayer = seasonWinPercentageTeam2SliderValuePlayer
            formRangeSliderLowerValuePlayer = seasonWinPercentageTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = seasonWinPercentageTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = seasonWinPercentageTeam2OperatorValuePlayer
            formOperatorTextPlayer = seasonWinPercentageTeam2OperatorTextPlayer
        case "SEASON":
            self.operatorDictionaryPlayer = ["-10000" : " IS ",
                                  "=" : " IS ",
                                  "≠" : " IS NOT ",
                                  "<" : " IS BEFORE ",
                                  ">" : " IS AFTER ",
                                  "< >" : " IS BETWEEN "]
            headerLabel = tagTextPlayer
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = seasonValuesPlayer
            formSliderValuePlayer = seasonSliderValuePlayer
            formRangeSliderLowerValuePlayer = seasonRangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = seasonRangeSliderUpperValuePlayer
            formOperatorValuePlayer = seasonOperatorValuePlayer
            formOperatorTextPlayer = seasonOperatorTextPlayer
        case "WEEK":
            self.operatorDictionaryPlayer = ["-10000" : " IS ",
                                       "=" : " IS ",
                                       "≠" : " IS NOT ",
                                       "<" : " IS BEFORE ",
                                       ">" : " IS AFTER ",
                                       "< >" : " IS BETWEEN "]
            headerLabel = tagTextPlayer
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = weekValuesPlayer
            formSliderValuePlayer = weekSliderValuePlayer
            formRangeSliderLowerValuePlayer = weekRangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = weekRangeSliderUpperValuePlayer
            formOperatorValuePlayer = weekOperatorValuePlayer
            formOperatorTextPlayer = weekOperatorTextPlayer
        case "GAME NUMBER":
            self.operatorDictionaryPlayer = ["-10000" : " IS ",
                                       "=" : " IS ",
                                       "≠" : " IS NOT ",
                                       "<" : " IS BEFORE ",
                                       ">" : " IS AFTER ",
                                       "< >" : " IS BETWEEN "]
            headerLabel = tagTextPlayer
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = gameNumberValuesPlayer
            formSliderValuePlayer = gameNumberSliderValuePlayer
            formRangeSliderLowerValuePlayer = gameNumberRangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = gameNumberRangeSliderUpperValuePlayer
            formOperatorValuePlayer = gameNumberOperatorValuePlayer
            formOperatorTextPlayer = gameNumberOperatorTextPlayer
        case "PLAYER TEAM: SPREAD":
            self.operatorDictionaryPlayer = ["-10000" : " IS ",
                                       "=" : " IS ",
                                       "≠" : " IS NOT ",
                                       "<" : " IS BETTER THAN ",
                                       ">" : " IS WORSE THAN ",
                                       "< >" : " IS BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                headerLabel = tagTextPlayer
            } else {
                if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team1ButtonLabelPlayer = "NEW YORK (G)"
                } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                    team1ButtonLabelPlayer = "NEW YORK (J)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabelPlayer = team1ListValuePlayer[0]
                    var team1TextArray = team1ButtonLabelPlayer.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabelPlayer = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = spreadValuesPlayer
            formSliderValuePlayer = spreadSliderValuePlayer
            formRangeSliderLowerValuePlayer = spreadRangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = spreadRangeSliderUpperValuePlayer
            formOperatorValuePlayer = spreadOperatorValuePlayer
            formOperatorTextPlayer = spreadOperatorTextPlayer
        case "OVER/UNDER":
            self.operatorDictionaryPlayer = ["-10000" : " IS ",
                                       "=" : " IS ",
                                       "≠" : " IS NOT ",
                                       "<" : " IS LESS THAN ",
                                       ">" : " IS MORE THAN ",
                                       "< >" : " IS BETWEEN "]
            headerLabel = tagTextPlayer
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = overUnderValuesPlayer
            formSliderValuePlayer = overUnderSliderValuePlayer
            formRangeSliderLowerValuePlayer = overUnderRangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = overUnderRangeSliderUpperValuePlayer
            formOperatorValuePlayer = overUnderOperatorValuePlayer
            formOperatorTextPlayer = overUnderOperatorTextPlayer
        case "TEMPERATURE (F)":
            self.operatorDictionaryPlayer = ["-10000" : " IS ",
                                  "=" : " IS ",
                                  "≠" : " IS NOT ",
                                  "<" : " IS LOWER THAN ",
                                  ">" : " IS HIGHER THAN ",
                                  "< >" : " IS BETWEEN "]
            headerLabel = tagTextPlayer
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = temperatureValuesPlayer
            formSliderValuePlayer = temperatureSliderValuePlayer
            formRangeSliderLowerValuePlayer = temperatureRangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = temperatureRangeSliderUpperValuePlayer
            formOperatorValuePlayer = temperatureOperatorValuePlayer
            formOperatorTextPlayer = temperatureOperatorTextPlayer
        case "PLAYER TEAM: TOTAL POINTS":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                headerLabel = tagTextPlayer
            } else {
                if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team1ButtonLabelPlayer = "NEW YORK (G)"
                } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                    team1ButtonLabelPlayer = "NEW YORK (J)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabelPlayer = team1ListValuePlayer[0]
                    var team1TextArray = team1ButtonLabelPlayer.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabelPlayer = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = totalPointsTeam1ValuesPlayer
            formSliderValuePlayer = totalPointsTeam1SliderValuePlayer
            formRangeSliderLowerValuePlayer = totalPointsTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = totalPointsTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = totalPointsTeam1OperatorValuePlayer
            formOperatorTextPlayer = totalPointsTeam1OperatorTextPlayer
        case "OPPONENT: TOTAL POINTS":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                headerLabel = tagTextPlayer
            } else {
                if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team2ButtonLabelPlayer = "NEW YORK (G)"
                } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                    team2ButtonLabelPlayer = "NEW YORK (J)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabelPlayer = team2ListValuePlayer[0]
                    var team2TextArray = team2ButtonLabelPlayer.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabelPlayer = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = totalPointsTeam2ValuesPlayer
            formSliderValuePlayer = totalPointsTeam2SliderValuePlayer
            formRangeSliderLowerValuePlayer = totalPointsTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = totalPointsTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = totalPointsTeam2OperatorValuePlayer
            formOperatorTextPlayer = totalPointsTeam2OperatorTextPlayer
        case "PLAYER TEAM: TOUCHDOWNS":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                headerLabel = tagTextPlayer
            } else {
                if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team1ButtonLabelPlayer = "NEW YORK (G)"
                } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                    team1ButtonLabelPlayer = "NEW YORK (J)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabelPlayer = team1ListValuePlayer[0]
                    var team1TextArray = team1ButtonLabelPlayer.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabelPlayer = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = touchdownsTeam1ValuesPlayer
            formSliderValuePlayer = touchdownsTeam1SliderValuePlayer
            formRangeSliderLowerValuePlayer = touchdownsTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = touchdownsTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = touchdownsTeam1OperatorValuePlayer
            formOperatorTextPlayer = touchdownsTeam1OperatorTextPlayer
            
        case "PLAYER TEAM: OFFENSIVE TOUCHDOWNS":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                       "=" : " EQUAL ",
                                       "≠" : " DO NOT EQUAL ",
                                       "<" : " EQUAL FEWER THAN ",
                                       ">" : " EQUAL MORE THAN ",
                                       "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                headerLabel = tagTextPlayer
            } else {
                if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team1ButtonLabelPlayer = "NEW YORK (G)"
                } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                    team1ButtonLabelPlayer = "NEW YORK (J)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabelPlayer = team1ListValuePlayer[0]
                    var team1TextArray = team1ButtonLabelPlayer.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabelPlayer = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = offensiveTouchdownsTeam1ValuesPlayer
            formSliderValuePlayer = offensiveTouchdownsTeam1SliderValuePlayer
            formRangeSliderLowerValuePlayer = offensiveTouchdownsTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = offensiveTouchdownsTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = offensiveTouchdownsTeam1OperatorValuePlayer
            formOperatorTextPlayer = offensiveTouchdownsTeam1OperatorTextPlayer
            
        case "OPPONENT: OFFENSIVE TOUCHDOWNS":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                       "=" : " EQUAL ",
                                       "≠" : " DO NOT EQUAL ",
                                       "<" : " EQUAL FEWER THAN ",
                                       ">" : " EQUAL MORE THAN ",
                                       "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] {
                headerLabel = tagTextPlayer
            } else {
                if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team2ButtonLabelPlayer = "NEW YORK (G)"
                } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                    team2ButtonLabelPlayer = "NEW YORK (J)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabelPlayer = team2ListValuePlayer[0]
                    var team2TextArray = team2ButtonLabelPlayer.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabelPlayer = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = offensiveTouchdownsTeam2ValuesPlayer
            formSliderValuePlayer = offensiveTouchdownsTeam2SliderValuePlayer
            formRangeSliderLowerValuePlayer = offensiveTouchdownsTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = offensiveTouchdownsTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = offensiveTouchdownsTeam2OperatorValuePlayer
            formOperatorTextPlayer = offensiveTouchdownsTeam2OperatorTextPlayer
            
            
            
        case "PLAYER TEAM: DEFENSIVE TOUCHDOWNS":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                       "=" : " EQUAL ",
                                       "≠" : " DO NOT EQUAL ",
                                       "<" : " EQUAL FEWER THAN ",
                                       ">" : " EQUAL MORE THAN ",
                                       "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                headerLabel = tagTextPlayer
            } else {
                if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team1ButtonLabelPlayer = "NEW YORK (G)"
                } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                    team1ButtonLabelPlayer = "NEW YORK (J)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabelPlayer = team1ListValuePlayer[0]
                    var team1TextArray = team1ButtonLabelPlayer.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabelPlayer = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = defensiveTouchdownsTeam1ValuesPlayer
            formSliderValuePlayer = defensiveTouchdownsTeam1SliderValuePlayer
            formRangeSliderLowerValuePlayer = defensiveTouchdownsTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = defensiveTouchdownsTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = defensiveTouchdownsTeam1OperatorValuePlayer
            formOperatorTextPlayer = defensiveTouchdownsTeam1OperatorTextPlayer
            
        case "OPPONENT: DEFENSIVE TOUCHDOWNS":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                       "=" : " EQUAL ",
                                       "≠" : " DO NOT EQUAL ",
                                       "<" : " EQUAL FEWER THAN ",
                                       ">" : " EQUAL MORE THAN ",
                                       "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] {
                headerLabel = tagTextPlayer
            } else {
                if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team2ButtonLabelPlayer = "NEW YORK (G)"
                } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                    team2ButtonLabelPlayer = "NEW YORK (J)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabelPlayer = team2ListValuePlayer[0]
                    var team2TextArray = team2ButtonLabelPlayer.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabelPlayer = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = defensiveTouchdownsTeam2ValuesPlayer
            formSliderValuePlayer = defensiveTouchdownsTeam2SliderValuePlayer
            formRangeSliderLowerValuePlayer = defensiveTouchdownsTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = defensiveTouchdownsTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = defensiveTouchdownsTeam2OperatorValuePlayer
            formOperatorTextPlayer = defensiveTouchdownsTeam2OperatorTextPlayer
            
            
        case "OPPONENT: TOUCHDOWNS":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                headerLabel = tagTextPlayer
            } else {
                if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team2ButtonLabelPlayer = "NEW YORK (G)"
                } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                    team2ButtonLabelPlayer = "NEW YORK (J)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabelPlayer = team2ListValuePlayer[0]
                    var team2TextArray = team2ButtonLabelPlayer.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabelPlayer = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = touchdownsTeam2ValuesPlayer
            formSliderValuePlayer = touchdownsTeam2SliderValuePlayer
            formRangeSliderLowerValuePlayer = touchdownsTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = touchdownsTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = touchdownsTeam2OperatorValuePlayer
            formOperatorTextPlayer = touchdownsTeam2OperatorTextPlayer
        case "PLAYER TEAM: TURNOVERS":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                headerLabel = tagTextPlayer
            } else {
                if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team1ButtonLabelPlayer = "NEW YORK (G)"
                } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                    team1ButtonLabelPlayer = "NEW YORK (J)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabelPlayer = team1ListValuePlayer[0]
                    var team1TextArray = team1ButtonLabelPlayer.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabelPlayer = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = turnoversCommittedTeam1ValuesPlayer
            formSliderValuePlayer = turnoversCommittedTeam1SliderValuePlayer
            formRangeSliderLowerValuePlayer = turnoversCommittedTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = turnoversCommittedTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = turnoversCommittedTeam1OperatorValuePlayer
            formOperatorTextPlayer = turnoversCommittedTeam1OperatorTextPlayer
        case "OPPONENT: TURNOVERS":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                headerLabel = tagTextPlayer
            } else {
                if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team2ButtonLabelPlayer = "NEW YORK (G)"
                } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                    team2ButtonLabelPlayer = "NEW YORK (J)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabelPlayer = team2ListValuePlayer[0]
                    var team2TextArray = team2ButtonLabelPlayer.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabelPlayer = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = turnoversCommittedTeam2ValuesPlayer
            formSliderValuePlayer = turnoversCommittedTeam2SliderValuePlayer
            formRangeSliderLowerValuePlayer = turnoversCommittedTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = turnoversCommittedTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = turnoversCommittedTeam2OperatorValuePlayer
            formOperatorTextPlayer = turnoversCommittedTeam2OperatorTextPlayer
        case "PLAYER TEAM: PENALTIES":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                headerLabel = tagTextPlayer
            } else {
                if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team1ButtonLabelPlayer = "NEW YORK (G)"
                } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                    team1ButtonLabelPlayer = "NEW YORK (J)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabelPlayer = team1ListValuePlayer[0]
                    var team1TextArray = team1ButtonLabelPlayer.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabelPlayer = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = penaltiesCommittedTeam1ValuesPlayer
            formSliderValuePlayer = penaltiesCommittedTeam1SliderValuePlayer
            formRangeSliderLowerValuePlayer = penaltiesCommittedTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = penaltiesCommittedTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = penaltiesCommittedTeam1OperatorValuePlayer
            formOperatorTextPlayer = penaltiesCommittedTeam1OperatorTextPlayer
        case "OPPONENT: PENALTIES":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                headerLabel = tagTextPlayer
            } else {
                if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team2ButtonLabelPlayer = "NEW YORK (G)"
                } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                    team2ButtonLabelPlayer = "NEW YORK (J)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabelPlayer = team2ListValuePlayer[0]
                    var team2TextArray = team2ButtonLabelPlayer.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabelPlayer = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = penaltiesCommittedTeam2ValuesPlayer
            formSliderValuePlayer = penaltiesCommittedTeam2SliderValuePlayer
            formRangeSliderLowerValuePlayer = penaltiesCommittedTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = penaltiesCommittedTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = penaltiesCommittedTeam2OperatorValuePlayer
            formOperatorTextPlayer = penaltiesCommittedTeam2OperatorTextPlayer
        case "PLAYER TEAM: TOTAL YARDS":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                headerLabel = tagTextPlayer
            } else {
                if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team1ButtonLabelPlayer = "NEW YORK (G)"
                } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                    team1ButtonLabelPlayer = "NEW YORK (J)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabelPlayer = team1ListValuePlayer[0]
                    var team1TextArray = team1ButtonLabelPlayer.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabelPlayer = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = totalYardsTeam1ValuesPlayer
            formSliderValuePlayer = totalYardsTeam1SliderValuePlayer
            formRangeSliderLowerValuePlayer = totalYardsTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = totalYardsTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = totalYardsTeam1OperatorValuePlayer
            formOperatorTextPlayer = totalYardsTeam1OperatorTextPlayer
        case "OPPONENT: TOTAL YARDS":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                headerLabel = tagTextPlayer
            } else {
                if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team2ButtonLabelPlayer = "NEW YORK (G)"
                } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                    team2ButtonLabelPlayer = "NEW YORK (J)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabelPlayer = team2ListValuePlayer[0]
                    var team2TextArray = team2ButtonLabelPlayer.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabelPlayer = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = totalYardsTeam2ValuesPlayer
            formSliderValuePlayer = totalYardsTeam2SliderValuePlayer
            formRangeSliderLowerValuePlayer = totalYardsTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = totalYardsTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = totalYardsTeam2OperatorValuePlayer
            formOperatorTextPlayer = totalYardsTeam2OperatorTextPlayer
        case "PLAYER TEAM: PASSING YARDS":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                headerLabel = tagTextPlayer
            } else {
                if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team1ButtonLabelPlayer = "NEW YORK (G)"
                } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                    team1ButtonLabelPlayer = "NEW YORK (J)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabelPlayer = team1ListValuePlayer[0]
                    var team1TextArray = team1ButtonLabelPlayer.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabelPlayer = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = passingYardsTeam1ValuesPlayer
            formSliderValuePlayer = passingYardsTeam1SliderValuePlayer
            formRangeSliderLowerValuePlayer = passingYardsTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = passingYardsTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = passingYardsTeam1OperatorValuePlayer
            formOperatorTextPlayer = passingYardsTeam1OperatorTextPlayer
        case "OPPONENT: PASSING YARDS":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                headerLabel = tagTextPlayer
            } else {
                if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team2ButtonLabelPlayer = "NEW YORK (G)"
                } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                    team2ButtonLabelPlayer = "NEW YORK (J)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabelPlayer = team2ListValuePlayer[0]
                    var team2TextArray = team2ButtonLabelPlayer.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabelPlayer = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = passingYardsTeam2ValuesPlayer
            formSliderValuePlayer = passingYardsTeam2SliderValuePlayer
            formRangeSliderLowerValuePlayer = passingYardsTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = passingYardsTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = passingYardsTeam2OperatorValuePlayer
            formOperatorTextPlayer = passingYardsTeam2OperatorTextPlayer
        case "PLAYER TEAM: RUSHING YARDS":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                headerLabel = tagTextPlayer
            } else {
                if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team1ButtonLabelPlayer = "NEW YORK (G)"
                } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                    team1ButtonLabelPlayer = "NEW YORK (J)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabelPlayer = team1ListValuePlayer[0]
                    var team1TextArray = team1ButtonLabelPlayer.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabelPlayer = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = rushingYardsTeam1ValuesPlayer
            formSliderValuePlayer = rushingYardsTeam1SliderValuePlayer
            formRangeSliderLowerValuePlayer = rushingYardsTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = rushingYardsTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = rushingYardsTeam1OperatorValuePlayer
            formOperatorTextPlayer = rushingYardsTeam1OperatorTextPlayer
        case "OPPONENT: RUSHING YARDS":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                headerLabel = tagTextPlayer
            } else {
                if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team2ButtonLabelPlayer = "NEW YORK (G)"
                } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                    team2ButtonLabelPlayer = "NEW YORK (J)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabelPlayer = team2ListValuePlayer[0]
                    var team2TextArray = team2ButtonLabelPlayer.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabelPlayer = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = rushingYardsTeam2ValuesPlayer
            formSliderValuePlayer = rushingYardsTeam2SliderValuePlayer
            formRangeSliderLowerValuePlayer = rushingYardsTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = rushingYardsTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = rushingYardsTeam2OperatorValuePlayer
            formOperatorTextPlayer = rushingYardsTeam2OperatorTextPlayer
        case "PLAYER TEAM: QUARTERBACK RATING":
            self.operatorDictionaryPlayer = ["-10000" : " IS ",
                                  "=" : " IS ",
                                  "≠" : " IS NOT ",
                                  "<" : " IS LOWER THAN ",
                                  ">" : " IS HIGHER THAN ",
                                  "< >" : " IS BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                headerLabel = tagTextPlayer
            } else {
                if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team1ButtonLabelPlayer = "NEW YORK (G)"
                } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                    team1ButtonLabelPlayer = "NEW YORK (J)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabelPlayer = team1ListValuePlayer[0]
                    var team1TextArray = team1ButtonLabelPlayer.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabelPlayer = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = quarterbackRatingTeam1ValuesPlayer
            formSliderValuePlayer = quarterbackRatingTeam1SliderValuePlayer
            formRangeSliderLowerValuePlayer = quarterbackRatingTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = quarterbackRatingTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = quarterbackRatingTeam1OperatorValuePlayer
            formOperatorTextPlayer = quarterbackRatingTeam1OperatorTextPlayer
        case "OPPONENT: QUARTERBACK RATING":
            self.operatorDictionaryPlayer = ["-10000" : " IS ",
                                  "=" : " IS ",
                                  "≠" : " IS NOT ",
                                  "<" : " IS LOWER THAN ",
                                  ">" : " IS HIGHER THAN ",
                                  "< >" : " IS BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                headerLabel = tagTextPlayer
            } else {
                if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team2ButtonLabelPlayer = "NEW YORK (G)"
                } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                    team2ButtonLabelPlayer = "NEW YORK (J)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabelPlayer = team2ListValuePlayer[0]
                    var team2TextArray = team2ButtonLabelPlayer.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabelPlayer = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = quarterbackRatingTeam2ValuesPlayer
            formSliderValuePlayer = quarterbackRatingTeam2SliderValuePlayer
            formRangeSliderLowerValuePlayer = quarterbackRatingTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = quarterbackRatingTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = quarterbackRatingTeam2OperatorValuePlayer
            formOperatorTextPlayer = quarterbackRatingTeam2OperatorTextPlayer
        case "PLAYER TEAM: TIMES SACKED":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                headerLabel = tagTextPlayer
            } else {
                if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team1ButtonLabelPlayer = "NEW YORK (G)"
                } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                    team1ButtonLabelPlayer = "NEW YORK (J)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabelPlayer = team1ListValuePlayer[0]
                    var team1TextArray = team1ButtonLabelPlayer.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabelPlayer = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = timesSackedTeam1ValuesPlayer
            formSliderValuePlayer = timesSackedTeam1SliderValuePlayer
            formRangeSliderLowerValuePlayer = timesSackedTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = timesSackedTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = timesSackedTeam1OperatorValuePlayer
            formOperatorTextPlayer = timesSackedTeam1OperatorTextPlayer
        case "OPPONENT: TIMES SACKED":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                headerLabel = tagTextPlayer
            } else {
                if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team2ButtonLabelPlayer = "NEW YORK (G)"
                } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                    team2ButtonLabelPlayer = "NEW YORK (J)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabelPlayer = team2ListValuePlayer[0]
                    var team2TextArray = team2ButtonLabelPlayer.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabelPlayer = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = timesSackedTeam2ValuesPlayer
            formSliderValuePlayer = timesSackedTeam2SliderValuePlayer
            formRangeSliderLowerValuePlayer = timesSackedTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = timesSackedTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = timesSackedTeam2OperatorValuePlayer
            formOperatorTextPlayer = timesSackedTeam2OperatorTextPlayer
        case "PLAYER TEAM: INTERCEPTIONS THROWN":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                headerLabel = tagTextPlayer
            } else {
                if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team1ButtonLabelPlayer = "NEW YORK (G)"
                } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                    team1ButtonLabelPlayer = "NEW YORK (J)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabelPlayer = team1ListValuePlayer[0]
                    var team1TextArray = team1ButtonLabelPlayer.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabelPlayer = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = interceptionsThrownTeam1ValuesPlayer
            formSliderValuePlayer = interceptionsThrownTeam1SliderValuePlayer
            formRangeSliderLowerValuePlayer = interceptionsThrownTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = interceptionsThrownTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = interceptionsThrownTeam1OperatorValuePlayer
            formOperatorTextPlayer = interceptionsThrownTeam1OperatorTextPlayer
        case "OPPONENT: INTERCEPTIONS THROWN":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                headerLabel = tagTextPlayer
            } else {
                if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team2ButtonLabelPlayer = "NEW YORK (G)"
                } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                    team2ButtonLabelPlayer = "NEW YORK (J)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabelPlayer = team2ListValuePlayer[0]
                    var team2TextArray = team2ButtonLabelPlayer.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabelPlayer = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = interceptionsThrownTeam2ValuesPlayer
            formSliderValuePlayer = interceptionsThrownTeam2SliderValuePlayer
            formRangeSliderLowerValuePlayer = interceptionsThrownTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = interceptionsThrownTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = interceptionsThrownTeam2OperatorValuePlayer
            formOperatorTextPlayer = interceptionsThrownTeam2OperatorTextPlayer
        case "PLAYER TEAM: OFFENSIVE PLAYS":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                headerLabel = tagTextPlayer
            } else {
                if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team1ButtonLabelPlayer = "NEW YORK (G)"
                } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                    team1ButtonLabelPlayer = "NEW YORK (J)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabelPlayer = team1ListValuePlayer[0]
                    var team1TextArray = team1ButtonLabelPlayer.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabelPlayer = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = defensivePlaysTeam1ValuesPlayer
            formSliderValuePlayer = defensivePlaysTeam1SliderValuePlayer
            formRangeSliderLowerValuePlayer = defensivePlaysTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = defensivePlaysTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = defensivePlaysTeam1OperatorValuePlayer
            formOperatorTextPlayer = defensivePlaysTeam1OperatorTextPlayer
        case "OPPONENT: OFFENSIVE PLAYS":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                headerLabel = tagTextPlayer
            } else {
                if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team2ButtonLabelPlayer = "NEW YORK (G)"
                } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                    team2ButtonLabelPlayer = "NEW YORK (J)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabelPlayer = team2ListValuePlayer[0]
                    var team2TextArray = team2ButtonLabelPlayer.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabelPlayer = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = offensivePlaysTeam2ValuesPlayer
            formSliderValuePlayer = offensivePlaysTeam2SliderValuePlayer
            formRangeSliderLowerValuePlayer = offensivePlaysTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = offensivePlaysTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = offensivePlaysTeam2OperatorValuePlayer
            formOperatorTextPlayer = offensivePlaysTeam2OperatorTextPlayer
        case "PLAYER TEAM: YARDS/OFFENSIVE PLAY":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                headerLabel = tagTextPlayer
            } else {
                if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team1ButtonLabelPlayer = "NEW YORK (G)"
                } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                    team1ButtonLabelPlayer = "NEW YORK (J)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabelPlayer = team1ListValuePlayer[0]
                    var team1TextArray = team1ButtonLabelPlayer.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabelPlayer = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = yardsPerOffensivePlayTeam1ValuesPlayer
            formSliderValuePlayer = yardsPerOffensivePlayTeam1SliderValuePlayer
            formRangeSliderLowerValuePlayer = yardsPerOffensivePlayTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = yardsPerOffensivePlayTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = yardsPerOffensivePlayTeam1OperatorValuePlayer
            formOperatorTextPlayer = yardsPerOffensivePlayTeam1OperatorTextPlayer
        case "OPPONENT: YARDS/OFFENSIVE PLAY":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                headerLabel = tagTextPlayer
            } else {
                if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team2ButtonLabelPlayer = "NEW YORK (G)"
                } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                    team2ButtonLabelPlayer = "NEW YORK (J)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabelPlayer = team2ListValuePlayer[0]
                    var team2TextArray = team2ButtonLabelPlayer.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabelPlayer = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = yardsPerOffensivePlayTeam2ValuesPlayer
            formSliderValuePlayer = yardsPerOffensivePlayTeam2SliderValuePlayer
            formRangeSliderLowerValuePlayer = yardsPerOffensivePlayTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = yardsPerOffensivePlayTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = yardsPerOffensivePlayTeam2OperatorValuePlayer
            formOperatorTextPlayer = yardsPerOffensivePlayTeam2OperatorTextPlayer
        case "PLAYER TEAM: SACKS":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                headerLabel = tagTextPlayer
            } else {
                if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team1ButtonLabelPlayer = "NEW YORK (G)"
                } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                    team1ButtonLabelPlayer = "NEW YORK (J)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabelPlayer = team1ListValuePlayer[0]
                    var team1TextArray = team1ButtonLabelPlayer.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabelPlayer = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = sacksTeam1ValuesPlayer
            formSliderValuePlayer = sacksTeam1SliderValuePlayer
            formRangeSliderLowerValuePlayer = sacksTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = sacksTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = sacksTeam1OperatorValuePlayer
            formOperatorTextPlayer = sacksTeam1OperatorTextPlayer
        case "OPPONENT: SACKS":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                headerLabel = tagTextPlayer
            } else {
                if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team2ButtonLabelPlayer = "NEW YORK (G)"
                } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                    team2ButtonLabelPlayer = "NEW YORK (J)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabelPlayer = team2ListValuePlayer[0]
                    var team2TextArray = team2ButtonLabelPlayer.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabelPlayer = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = sacksTeam2ValuesPlayer
            formSliderValuePlayer = sacksTeam2SliderValuePlayer
            formRangeSliderLowerValuePlayer = sacksTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = sacksTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = sacksTeam2OperatorValuePlayer
            formOperatorTextPlayer = sacksTeam2OperatorTextPlayer
        case "PLAYER TEAM: INTERCEPTIONS":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                headerLabel = tagTextPlayer
            } else {
                if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team1ButtonLabelPlayer = "NEW YORK (G)"
                } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                    team1ButtonLabelPlayer = "NEW YORK (J)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabelPlayer = team1ListValuePlayer[0]
                    var team1TextArray = team1ButtonLabelPlayer.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabelPlayer = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = interceptionsTeam1ValuesPlayer
            formSliderValuePlayer = interceptionsTeam1SliderValuePlayer
            formRangeSliderLowerValuePlayer = interceptionsTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = interceptionsTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = interceptionsTeam1OperatorValuePlayer
            formOperatorTextPlayer = interceptionsTeam1OperatorTextPlayer
        case "OPPONENT: INTERCEPTIONS":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                headerLabel = tagTextPlayer
            } else {
                if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team2ButtonLabelPlayer = "NEW YORK (G)"
                } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                    team2ButtonLabelPlayer = "NEW YORK (J)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabelPlayer = team2ListValuePlayer[0]
                    var team2TextArray = team2ButtonLabelPlayer.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabelPlayer = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = interceptionsTeam2ValuesPlayer
            formSliderValuePlayer = interceptionsTeam2SliderValuePlayer
            formRangeSliderLowerValuePlayer = interceptionsTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = interceptionsTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = interceptionsTeam2OperatorValuePlayer
            formOperatorTextPlayer = interceptionsTeam2OperatorTextPlayer
        case "PLAYER TEAM: SAFETIES":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                headerLabel = tagTextPlayer
            } else {
                if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team1ButtonLabelPlayer = "NEW YORK (G)"
                } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                    team1ButtonLabelPlayer = "NEW YORK (J)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabelPlayer = team1ListValuePlayer[0]
                    var team1TextArray = team1ButtonLabelPlayer.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabelPlayer = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = safetiesTeam1ValuesPlayer
            formSliderValuePlayer = safetiesTeam1SliderValuePlayer
            formRangeSliderLowerValuePlayer = safetiesTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = safetiesTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = safetiesTeam1OperatorValuePlayer
            formOperatorTextPlayer = safetiesTeam1OperatorTextPlayer
        case "OPPONENT: SAFETIES":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                headerLabel = tagTextPlayer
            } else {
                if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team2ButtonLabelPlayer = "NEW YORK (G)"
                } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                    team2ButtonLabelPlayer = "NEW YORK (J)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabelPlayer = team2ListValuePlayer[0]
                    var team2TextArray = team2ButtonLabelPlayer.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabelPlayer = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = safetiesTeam2ValuesPlayer
            formSliderValuePlayer = safetiesTeam2SliderValuePlayer
            formRangeSliderLowerValuePlayer = safetiesTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = safetiesTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = safetiesTeam2OperatorValuePlayer
            formOperatorTextPlayer = safetiesTeam2OperatorTextPlayer
        case "PLAYER TEAM: DEFENSIVE PLAYS":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                headerLabel = tagTextPlayer
            } else {
                if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team1ButtonLabelPlayer = "NEW YORK (G)"
                } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                    team1ButtonLabelPlayer = "NEW YORK (J)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabelPlayer = team1ListValuePlayer[0]
                    var team1TextArray = team1ButtonLabelPlayer.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabelPlayer = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = defensivePlaysTeam1ValuesPlayer
            formSliderValuePlayer = defensivePlaysTeam1SliderValuePlayer
            formRangeSliderLowerValuePlayer = defensivePlaysTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = defensivePlaysTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = defensivePlaysTeam1OperatorValuePlayer
            formOperatorTextPlayer = defensivePlaysTeam1OperatorTextPlayer
        case "OPPONENT: DEFENSIVE PLAYS":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                headerLabel = tagTextPlayer
            } else {
                if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team2ButtonLabelPlayer = "NEW YORK (G)"
                } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                    team2ButtonLabelPlayer = "NEW YORK (J)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabelPlayer = team2ListValuePlayer[0]
                    var team2TextArray = team2ButtonLabelPlayer.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabelPlayer = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = defensivePlaysTeam2ValuesPlayer
            formSliderValuePlayer = defensivePlaysTeam2SliderValuePlayer
            formRangeSliderLowerValuePlayer = defensivePlaysTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = defensivePlaysTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = defensivePlaysTeam2OperatorValuePlayer
            formOperatorTextPlayer = defensivePlaysTeam2OperatorTextPlayer
        case "PLAYER TEAM: YARDS/DEFENSIVE PLAY":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                headerLabel = tagTextPlayer
            } else {
                if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team1ButtonLabelPlayer = "NEW YORK (G)"
                } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                    team1ButtonLabelPlayer = "NEW YORK (J)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabelPlayer = team1ListValuePlayer[0]
                    var team1TextArray = team1ButtonLabelPlayer.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabelPlayer = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = yardsPerDefensivePlayTeam1ValuesPlayer
            formSliderValuePlayer = yardsPerDefensivePlayTeam1SliderValuePlayer
            formRangeSliderLowerValuePlayer = yardsPerDefensivePlayTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = yardsPerDefensivePlayTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = yardsPerDefensivePlayTeam1OperatorValuePlayer
            formOperatorTextPlayer = yardsPerDefensivePlayTeam1OperatorTextPlayer
        case "OPPONENT: YARDS/DEFENSIVE PLAY":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                headerLabel = tagTextPlayer
            } else {
                if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team2ButtonLabelPlayer = "NEW YORK (G)"
                } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                    team2ButtonLabelPlayer = "NEW YORK (J)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabelPlayer = team2ListValuePlayer[0]
                    var team2TextArray = team2ButtonLabelPlayer.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabelPlayer = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = yardsPerDefensivePlayTeam2ValuesPlayer
            formSliderValuePlayer = yardsPerDefensivePlayTeam2SliderValuePlayer
            formRangeSliderLowerValuePlayer = yardsPerDefensivePlayTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = yardsPerDefensivePlayTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = yardsPerDefensivePlayTeam2OperatorValuePlayer
            formOperatorTextPlayer = yardsPerDefensivePlayTeam2OperatorTextPlayer
        case "PLAYER TEAM: EXTRA POINT ATTEMPTS":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                headerLabel = tagTextPlayer
            } else {
                if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team1ButtonLabelPlayer = "NEW YORK (G)"
                } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                    team1ButtonLabelPlayer = "NEW YORK (J)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabelPlayer = team1ListValuePlayer[0]
                    var team1TextArray = team1ButtonLabelPlayer.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabelPlayer = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = extraPointAttemptsTeam1ValuesPlayer
            formSliderValuePlayer = extraPointAttemptsTeam1SliderValuePlayer
            formRangeSliderLowerValuePlayer = extraPointAttemptsTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = extraPointAttemptsTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = extraPointAttemptsTeam1OperatorValuePlayer
            formOperatorTextPlayer = extraPointAttemptsTeam1OperatorTextPlayer
        case "OPPONENT: EXTRA POINT ATTEMPTS":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                headerLabel = tagTextPlayer
            } else {
                if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team2ButtonLabelPlayer = "NEW YORK (G)"
                } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                    team2ButtonLabelPlayer = "NEW YORK (J)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabelPlayer = team2ListValuePlayer[0]
                    var team2TextArray = team2ButtonLabelPlayer.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabelPlayer = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = extraPointAttemptsTeam2ValuesPlayer
            formSliderValuePlayer = extraPointAttemptsTeam2SliderValuePlayer
            formRangeSliderLowerValuePlayer = extraPointAttemptsTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = extraPointAttemptsTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = extraPointAttemptsTeam2OperatorValuePlayer
            formOperatorTextPlayer = extraPointAttemptsTeam2OperatorTextPlayer
        case "PLAYER TEAM: EXTRA POINTS MADE":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                headerLabel = tagTextPlayer
            } else {
                if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team1ButtonLabelPlayer = "NEW YORK (G)"
                } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                    team1ButtonLabelPlayer = "NEW YORK (J)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabelPlayer = team1ListValuePlayer[0]
                    var team1TextArray = team1ButtonLabelPlayer.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabelPlayer = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = extraPointsMadeTeam1ValuesPlayer
            formSliderValuePlayer = extraPointsMadeTeam1SliderValuePlayer
            formRangeSliderLowerValuePlayer = extraPointsMadeTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = extraPointsMadeTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = extraPointsMadeTeam1OperatorValuePlayer
            formOperatorTextPlayer = extraPointsMadeTeam1OperatorTextPlayer
        case "OPPONENT: EXTRA POINTS MADE":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                headerLabel = tagTextPlayer
            } else {
                if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team2ButtonLabelPlayer = "NEW YORK (G)"
                } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                    team2ButtonLabelPlayer = "NEW YORK (J)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabelPlayer = team2ListValuePlayer[0]
                    var team2TextArray = team2ButtonLabelPlayer.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabelPlayer = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = extraPointsMadeTeam2ValuesPlayer
            formSliderValuePlayer = extraPointsMadeTeam2SliderValuePlayer
            formRangeSliderLowerValuePlayer = extraPointsMadeTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = extraPointsMadeTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = extraPointsMadeTeam2OperatorValuePlayer
            formOperatorTextPlayer = extraPointsMadeTeam2OperatorTextPlayer
        case "PLAYER TEAM: FIELD GOAL ATTEMPTS":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                headerLabel = tagTextPlayer
            } else {
                if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team1ButtonLabelPlayer = "NEW YORK (G)"
                } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                    team1ButtonLabelPlayer = "NEW YORK (J)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabelPlayer = team1ListValuePlayer[0]
                    var team1TextArray = team1ButtonLabelPlayer.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabelPlayer = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = fieldGoalAttemptsTeam1ValuesPlayer
            formSliderValuePlayer = fieldGoalAttemptsTeam1SliderValuePlayer
            formRangeSliderLowerValuePlayer = fieldGoalAttemptsTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = fieldGoalAttemptsTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = fieldGoalAttemptsTeam1OperatorValuePlayer
            formOperatorTextPlayer = fieldGoalAttemptsTeam1OperatorTextPlayer
        case "OPPONENT: FIELD GOAL ATTEMPTS":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                headerLabel = tagTextPlayer
            } else {
                if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team2ButtonLabelPlayer = "NEW YORK (G)"
                } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                    team2ButtonLabelPlayer = "NEW YORK (J)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabelPlayer = team2ListValuePlayer[0]
                    var team2TextArray = team2ButtonLabelPlayer.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabelPlayer = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = fieldGoalAttemptsTeam2ValuesPlayer
            formSliderValuePlayer = fieldGoalAttemptsTeam2SliderValuePlayer
            formRangeSliderLowerValuePlayer = fieldGoalAttemptsTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = fieldGoalAttemptsTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = fieldGoalAttemptsTeam2OperatorValuePlayer
            formOperatorTextPlayer = fieldGoalAttemptsTeam2OperatorTextPlayer
        case "PLAYER TEAM: FIELD GOALS MADE":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                headerLabel = tagTextPlayer
            } else {
                if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team1ButtonLabelPlayer = "NEW YORK (G)"
                } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                    team1ButtonLabelPlayer = "NEW YORK (J)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabelPlayer = team1ListValuePlayer[0]
                    var team1TextArray = team1ButtonLabelPlayer.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabelPlayer = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = fieldGoalsMadeTeam1ValuesPlayer
            formSliderValuePlayer = fieldGoalsMadeTeam1SliderValuePlayer
            formRangeSliderLowerValuePlayer = fieldGoalsMadeTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = fieldGoalsMadeTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = fieldGoalsMadeTeam1OperatorValuePlayer
            formOperatorTextPlayer = fieldGoalsMadeTeam1OperatorTextPlayer
        case "OPPONENT: FIELD GOALS MADE":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                headerLabel = tagTextPlayer
            } else {
                if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team2ButtonLabelPlayer = "NEW YORK (G)"
                } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                    team2ButtonLabelPlayer = "NEW YORK (J)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabelPlayer = team2ListValuePlayer[0]
                    var team2TextArray = team2ButtonLabelPlayer.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabelPlayer = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = fieldGoalsMadeTeam2ValuesPlayer
            formSliderValuePlayer = fieldGoalsMadeTeam2SliderValuePlayer
            formRangeSliderLowerValuePlayer = fieldGoalsMadeTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = fieldGoalsMadeTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = fieldGoalsMadeTeam2OperatorValuePlayer
            formOperatorTextPlayer = fieldGoalsMadeTeam2OperatorTextPlayer
        case "PLAYER TEAM: PUNTS":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                headerLabel = tagTextPlayer
            } else {
                if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team1ButtonLabelPlayer = "NEW YORK (G)"
                } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                    team1ButtonLabelPlayer = "NEW YORK (J)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabelPlayer = team1ListValuePlayer[0]
                    var team1TextArray = team1ButtonLabelPlayer.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabelPlayer = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = puntsTeam1ValuesPlayer
            formSliderValuePlayer = puntsTeam1SliderValuePlayer
            formRangeSliderLowerValuePlayer = puntsTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = puntsTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = puntsTeam1OperatorValuePlayer
            formOperatorTextPlayer = puntsTeam1OperatorTextPlayer
        case "OPPONENT: PUNTS":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                headerLabel = tagTextPlayer
            } else {
                if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team2ButtonLabelPlayer = "NEW YORK (G)"
                } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                    team2ButtonLabelPlayer = "NEW YORK (J)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabelPlayer = team2ListValuePlayer[0]
                    var team2TextArray = team2ButtonLabelPlayer.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabelPlayer = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = puntsTeam2ValuesPlayer
            formSliderValuePlayer = puntsTeam2SliderValuePlayer
            formRangeSliderLowerValuePlayer = puntsTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = puntsTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = puntsTeam2OperatorValuePlayer
            formOperatorTextPlayer = puntsTeam2OperatorTextPlayer
        case "PLAYER TEAM: PUNT YARDS":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                headerLabel = tagTextPlayer
            } else {
                if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team1ButtonLabelPlayer = "NEW YORK (G)"
                } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                    team1ButtonLabelPlayer = "NEW YORK (J)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabelPlayer = team1ListValuePlayer[0]
                    var team1TextArray = team1ButtonLabelPlayer.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabelPlayer = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = puntYardsTeam1ValuesPlayer
            formSliderValuePlayer = puntYardsTeam1SliderValuePlayer
            formRangeSliderLowerValuePlayer = puntYardsTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = puntYardsTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = puntYardsTeam1OperatorValuePlayer
            formOperatorTextPlayer = puntYardsTeam1OperatorTextPlayer
        case "OPPONENT: PUNT YARDS":
            self.operatorDictionaryPlayer = ["-10000" : " EQUAL ",
                                  "=" : " EQUAL ",
                                  "≠" : " DO NOT EQUAL ",
                                  "<" : " EQUAL FEWER THAN ",
                                  ">" : " EQUAL MORE THAN ",
                                  "< >" : " EQUAL BETWEEN "]
            var rowTitlePlayerPlayer = tagTextPlayer
            var rowTitlePlayerPlayerTextArray = rowTitlePlayerPlayer.components(separatedBy: ": ")
            rowTitlePlayerPlayer = rowTitlePlayerPlayerTextArray[1]
            if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                headerLabel = tagTextPlayer
            } else {
                if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team2ButtonLabelPlayer = "NEW YORK (G)"
                } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                    team2ButtonLabelPlayer = "NEW YORK (J)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabelPlayer = team2ListValuePlayer[0]
                    var team2TextArray = team2ButtonLabelPlayer.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabelPlayer = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabelPlayer + ": " + rowTitlePlayerPlayer
            }
            operatorsArrayPlayer = allOperators
            sliderValuesPlayer = puntYardsTeam2ValuesPlayer
            formSliderValuePlayer = puntYardsTeam2SliderValuePlayer
            formRangeSliderLowerValuePlayer = puntYardsTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = puntYardsTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = puntYardsTeam2OperatorValuePlayer
            formOperatorTextPlayer = puntYardsTeam2OperatorTextPlayer
        default:
            return
        }
        
        SegmentedRow<String>.defaultCellSetup = { cell, row in
            cell.tintColor = lightGreyColor
            cell.backgroundColor = UIColor.clear
            cell.height = { 45.0 }
            cell.segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: sixteenLightRoboto!], for: UIControlState.normal)
            cell.segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: sixteenBoldRoboto!], for: UIControlState.selected)
            cell.titleLabel?.textColor = lightGreyColor
            cell.titleLabel?.font = sixteenThin
        }

        SegmentedRow<String>.defaultCellUpdate = { cell, row in
            cell.tintColor = lightGreyColor
            cell.backgroundColor = UIColor.clear
            cell.height = { 45.0 }
            cell.segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: sixteenLightRoboto!], for: UIControlState.normal)
            cell.segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: sixteenBoldRoboto!], for: UIControlState.selected)
            cell.titleLabel?.textColor = lightGreyColor
            cell.titleLabel?.font = sixteenThin
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
                $0.options = operatorsArrayPlayer as? [String]
                operatorTextPlayer = self.operatorDictionaryPlayer[formOperatorValuePlayer]!
                //print("formOperatorValuePlayer: ")
                //print(formOperatorValuePlayer)
                //print("operatorTextPlayer: " + operatorTextPlayer)
                switch (formOperatorValuePlayer) {
                case "-10000":
                    $0.value = "< >"
                    rangeBooleanPlayer = true
                    self.playerRangeSliderObject.isHidden = false
                    //print("OPERATOR LOADED AS -10000")
                case "=":
                    $0.value = formOperatorValuePlayer
                    rangeBooleanPlayer = false
                    self.playerRangeSliderObject.isHidden = true
                case "≠":
                    $0.value = formOperatorValuePlayer
                    rangeBooleanPlayer = false
                    self.playerRangeSliderObject.isHidden = true
                case "<":
                    $0.value = formOperatorValuePlayer
                    rangeBooleanPlayer = false
                    self.playerRangeSliderObject.isHidden = true
                case ">":
                    $0.value = formOperatorValuePlayer
                    rangeBooleanPlayer = false
                    self.playerRangeSliderObject.isHidden = true
                case "< >":
                    $0.value = formOperatorValuePlayer
                    rangeBooleanPlayer = true
                    self.playerRangeSliderObject.isHidden = false
                    //print("OPERATOR LOADED AS BETWEEN")
                default:
                   return }
                } .onChange { row in
                    selectedOperatorValuePlayer = row.value!
                    //print("selectedOperatorValuePlayer (onChange): ")
                    //print(selectedOperatorValuePlayer)
                    operatorTextPlayer = self.operatorDictionaryPlayer[selectedOperatorValuePlayer]!
                    //print("operatorTextPlayer (onChange): " + operatorTextPlayer)
                    switch(selectedOperatorValuePlayer) {
                    case "-10000":
                        self.rangeBooleanPlayer = true
                        self.rangeSliderActivated()
                        self.playerRangeSliderObject.isHidden = false
                        //print("OPERATOR CHANGED TO -10000")
                    case "=":
                        self.rangeBooleanPlayer = false
                        self.singleSelectionSliderActivated()
                        self.playerRangeSliderObject.isHidden = true
                    case "≠":
                        self.rangeBooleanPlayer = false
                        self.singleSelectionSliderActivated()
                        self.playerRangeSliderObject.isHidden = true
                    case "<":
                       self.rangeBooleanPlayer = false
                        self.singleSelectionSliderActivated()
                        self.playerRangeSliderObject.isHidden = true
                    case ">":
                        self.rangeBooleanPlayer = false
                        self.singleSelectionSliderActivated()
                        self.playerRangeSliderObject.isHidden = true
                    case "< >":
                        self.rangeBooleanPlayer = true
                        self.rangeSliderActivated()
                        self.playerRangeSliderObject.isHidden = false
                        //print("OPERATOR CHANGED TO BETWEEN")
                    default:
                        self.rangeBooleanPlayer = false
                    switch (tagTextPlayer) {
                    case "PLAYER TEAM: STREAK":
                        winningLosingStreakTeam1OperatorValuePlayer = selectedOperatorValuePlayer
                        winningLosingStreakTeam1OperatorTextPlayer = operatorTextPlayer
                    case "OPPONENT: STREAK":
                        winningLosingStreakTeam2OperatorValuePlayer = selectedOperatorValuePlayer
                        winningLosingStreakTeam2OperatorTextPlayer = operatorTextPlayer
                    case "PLAYER TEAM: SEASON WIN %":
                        seasonWinPercentageTeam1OperatorValuePlayer = selectedOperatorValuePlayer
                        seasonWinPercentageTeam1OperatorTextPlayer = operatorTextPlayer
                    case "OPPONENT: SEASON WIN %":
                        seasonWinPercentageTeam2OperatorValuePlayer = selectedOperatorValuePlayer
                        seasonWinPercentageTeam2OperatorTextPlayer = operatorTextPlayer
                    case "SEASON":
                        seasonOperatorValuePlayer = selectedOperatorValuePlayer
                        seasonOperatorTextPlayer = operatorTextPlayer
                    case "GAME NUMBER":
                        gameNumberOperatorValuePlayer = selectedOperatorValuePlayer
                        gameNumberOperatorTextPlayer = operatorTextPlayer
                    case "WEEK":
                        weekOperatorValuePlayer = selectedOperatorValuePlayer
                        weekOperatorTextPlayer = operatorTextPlayer
                    case "PLAYER TEAM: SPREAD":
                        spreadOperatorValuePlayer = selectedOperatorValuePlayer
                        spreadOperatorTextPlayer = operatorTextPlayer
                    case "OVER/UNDER":
                        overUnderOperatorValuePlayer = selectedOperatorValuePlayer
                        overUnderOperatorTextPlayer = operatorTextPlayer
                    case "TEMPERATURE (F)":
                        temperatureOperatorValuePlayer = selectedOperatorValuePlayer
                        temperatureOperatorTextPlayer = operatorTextPlayer
                    case "PLAYER TEAM: TOTAL POINTS":
                        totalPointsTeam1OperatorValuePlayer = selectedOperatorValuePlayer
                        totalPointsTeam1OperatorTextPlayer = operatorTextPlayer
                    case "OPPONENT: TOTAL POINTS":
                        totalPointsTeam2OperatorValuePlayer = selectedOperatorValuePlayer
                        totalPointsTeam2OperatorTextPlayer = operatorTextPlayer
                    case "PLAYER TEAM: TOUCHDOWNS":
                        touchdownsTeam1OperatorValuePlayer = selectedOperatorValuePlayer
                        touchdownsTeam1OperatorTextPlayer = operatorTextPlayer
                    case "OPPONENT: TOUCHDOWNS":
                        touchdownsTeam2OperatorValuePlayer = selectedOperatorValuePlayer
                        touchdownsTeam2OperatorTextPlayer = operatorTextPlayer
                    
                    case "PLAYER TEAM: OFFENSIVE TOUCHDOWNS":
                        offensiveTouchdownsTeam1OperatorValuePlayer = selectedOperatorValuePlayer
                        offensiveTouchdownsTeam1OperatorTextPlayer = operatorTextPlayer
                    case "OPPONENT: OFFENSIVE TOUCHDOWNS":
                        offensiveTouchdownsTeam2OperatorValuePlayer = selectedOperatorValuePlayer
                        offensiveTouchdownsTeam2OperatorTextPlayer = operatorTextPlayer
                    case "PLAYER TEAM: DEFENSIVE TOUCHDOWNS":
                        defensiveTouchdownsTeam1OperatorValuePlayer = selectedOperatorValuePlayer
                        defensiveTouchdownsTeam1OperatorTextPlayer = operatorTextPlayer
                    case "OPPONENT: DEFENSIVE TOUCHDOWNS":
                        defensiveTouchdownsTeam2OperatorValuePlayer = selectedOperatorValuePlayer
                        defensiveTouchdownsTeam2OperatorTextPlayer = operatorTextPlayer
                        
                    case "PLAYER TEAM: TURNOVERS":
                        turnoversCommittedTeam1OperatorValuePlayer = selectedOperatorValuePlayer
                        turnoversCommittedTeam1OperatorTextPlayer = operatorTextPlayer
                    case "OPPONENT: TURNOVERS":
                        turnoversCommittedTeam2OperatorValuePlayer = selectedOperatorValuePlayer
                        turnoversCommittedTeam2OperatorTextPlayer = operatorTextPlayer
                    case "PLAYER TEAM: PENALTIES":
                        penaltiesCommittedTeam1OperatorValuePlayer = selectedOperatorValuePlayer
                        penaltiesCommittedTeam1OperatorTextPlayer = operatorTextPlayer
                    case "OPPONENT: PENALTIES":
                        penaltiesCommittedTeam2OperatorValuePlayer = selectedOperatorValuePlayer
                        penaltiesCommittedTeam2OperatorTextPlayer = operatorTextPlayer
                    case "PLAYER TEAM: TOTAL YARDS":
                        totalYardsTeam1OperatorValuePlayer = selectedOperatorValuePlayer
                        totalYardsTeam1OperatorTextPlayer = operatorTextPlayer
                    case "OPPONENT: TOTAL YARDS":
                        totalYardsTeam2OperatorValuePlayer = selectedOperatorValuePlayer
                        totalYardsTeam2OperatorTextPlayer = operatorTextPlayer
                    case "PLAYER TEAM: PASSING YARDS":
                        passingYardsTeam1OperatorValuePlayer = selectedOperatorValuePlayer
                        passingYardsTeam1OperatorTextPlayer = operatorTextPlayer
                    case "OPPONENT: PASSING YARDS":
                        passingYardsTeam2OperatorValuePlayer = selectedOperatorValuePlayer
                        passingYardsTeam2OperatorTextPlayer = operatorTextPlayer
                    case "PLAYER TEAM: RUSHING YARDS":
                        rushingYardsTeam1OperatorValuePlayer = selectedOperatorValuePlayer
                        rushingYardsTeam1OperatorTextPlayer = operatorTextPlayer
                    case "OPPONENT: RUSHING YARDS":
                        rushingYardsTeam2OperatorValuePlayer = selectedOperatorValuePlayer
                        rushingYardsTeam2OperatorTextPlayer = operatorTextPlayer
                    case "PLAYER TEAM: QUARTERBACK RATING":
                        quarterbackRatingTeam1OperatorValuePlayer = selectedOperatorValuePlayer
                        quarterbackRatingTeam1OperatorTextPlayer = operatorTextPlayer
                    case "OPPONENT: QUARTERBACK RATING":
                        quarterbackRatingTeam2OperatorValuePlayer = selectedOperatorValuePlayer
                        quarterbackRatingTeam2OperatorTextPlayer = operatorTextPlayer
                    case "PLAYER TEAM: TIMES SACKED":
                        timesSackedTeam1OperatorValuePlayer = selectedOperatorValuePlayer
                        timesSackedTeam1OperatorTextPlayer = operatorTextPlayer
                    case "OPPONENT: TIMES SACKED":
                        timesSackedTeam2OperatorValuePlayer = selectedOperatorValuePlayer
                        timesSackedTeam2OperatorTextPlayer = operatorTextPlayer
                    case "PLAYER TEAM: INTERCEPTIONS THROWN":
                        interceptionsThrownTeam1OperatorValuePlayer = selectedOperatorValuePlayer
                        interceptionsThrownTeam1OperatorTextPlayer = operatorTextPlayer
                    case "OPPONENT: INTERCEPTIONS THROWN":
                        interceptionsThrownTeam2OperatorValuePlayer = selectedOperatorValuePlayer
                        interceptionsThrownTeam2OperatorTextPlayer = operatorTextPlayer
                    case "PLAYER TEAM: OFFENSIVE PLAYS":
                        offensivePlaysTeam1OperatorValuePlayer = selectedOperatorValuePlayer
                        offensivePlaysTeam1OperatorTextPlayer = operatorTextPlayer
                    case "OPPONENT: OFFENSIVE PLAYS":
                        offensivePlaysTeam2OperatorValuePlayer = selectedOperatorValuePlayer
                        offensivePlaysTeam2OperatorTextPlayer = operatorTextPlayer
                    case "PLAYER TEAM: YARDS/OFFENSIVE PLAY":
                        yardsPerOffensivePlayTeam1OperatorValuePlayer = selectedOperatorValuePlayer
                        yardsPerOffensivePlayTeam1OperatorTextPlayer = operatorTextPlayer
                    case "OPPONENT: YARDS/OFFENSIVE PLAY":
                        yardsPerOffensivePlayTeam2OperatorValuePlayer = selectedOperatorValuePlayer
                        yardsPerOffensivePlayTeam2OperatorTextPlayer = operatorTextPlayer
                    case "PLAYER TEAM: SACKS":
                        sacksTeam1OperatorValuePlayer = selectedOperatorValuePlayer
                        sacksTeam1OperatorTextPlayer = operatorTextPlayer
                    case "OPPONENT: SACKS":
                        sacksTeam2OperatorValuePlayer = selectedOperatorValuePlayer
                        sacksTeam2OperatorTextPlayer = operatorTextPlayer
                    case "PLAYER TEAM: INTERCEPTIONS":
                        interceptionsTeam1OperatorValuePlayer = selectedOperatorValuePlayer
                        interceptionsTeam1OperatorTextPlayer = operatorTextPlayer
                    case "OPPONENT: INTERCEPTIONS":
                        interceptionsTeam2OperatorValuePlayer = selectedOperatorValuePlayer
                        interceptionsTeam2OperatorTextPlayer = operatorTextPlayer
                    case "PLAYER TEAM: SAFETIES":
                        safetiesTeam1OperatorValuePlayer = selectedOperatorValuePlayer
                        safetiesTeam1OperatorTextPlayer = operatorTextPlayer
                    case "OPPONENT: SAFETIES":
                        safetiesTeam2OperatorValuePlayer = selectedOperatorValuePlayer
                        safetiesTeam2OperatorTextPlayer = operatorTextPlayer
                    case "PLAYER TEAM: DEFENSIVE PLAYS":
                        defensivePlaysTeam1OperatorValuePlayer = selectedOperatorValuePlayer
                        defensivePlaysTeam1OperatorTextPlayer = operatorTextPlayer
                    case "OPPONENT: DEFENSIVE PLAYS":
                        defensivePlaysTeam2OperatorValuePlayer = selectedOperatorValuePlayer
                        defensivePlaysTeam2OperatorTextPlayer = operatorTextPlayer
                    case "PLAYER TEAM: YARDS/DEFENSIVE PLAY":
                        yardsPerDefensivePlayTeam1OperatorValuePlayer = selectedOperatorValuePlayer
                        yardsPerDefensivePlayTeam1OperatorTextPlayer = operatorTextPlayer
                    case "OPPONENT: YARDS/DEFENSIVE PLAY":
                        yardsPerDefensivePlayTeam2OperatorValuePlayer = selectedOperatorValuePlayer
                        yardsPerDefensivePlayTeam2OperatorTextPlayer = operatorTextPlayer
                    case "PLAYER TEAM: EXTRA POINT ATTEMPTS":
                        extraPointAttemptsTeam1OperatorValuePlayer = selectedOperatorValuePlayer
                        extraPointAttemptsTeam1OperatorTextPlayer = operatorTextPlayer
                    case "OPPONENT: EXTRA POINT ATTEMPTS":
                        extraPointAttemptsTeam2OperatorValuePlayer = selectedOperatorValuePlayer
                        extraPointAttemptsTeam2OperatorTextPlayer = operatorTextPlayer
                    case "PLAYER TEAM: EXTRA POINTS MADE":
                        extraPointsMadeTeam1OperatorValuePlayer = selectedOperatorValuePlayer
                        extraPointsMadeTeam1OperatorTextPlayer = operatorTextPlayer
                    case "OPPONENT: EXTRA POINTS MADE":
                        extraPointsMadeTeam2OperatorValuePlayer = selectedOperatorValuePlayer
                        extraPointsMadeTeam2OperatorTextPlayer = operatorTextPlayer
                    case "PLAYER TEAM: FIELD GOAL ATTEMPTS":
                        fieldGoalAttemptsTeam1OperatorValuePlayer = selectedOperatorValuePlayer
                        fieldGoalAttemptsTeam1OperatorTextPlayer = operatorTextPlayer
                    case "OPPONENT: FIELD GOAL ATTEMPTS":
                        fieldGoalAttemptsTeam2OperatorValuePlayer = selectedOperatorValuePlayer
                        fieldGoalAttemptsTeam2OperatorTextPlayer = operatorTextPlayer
                    case "PLAYER TEAM: FIELD GOALS MADE":
                        fieldGoalsMadeTeam1OperatorValuePlayer = selectedOperatorValuePlayer
                        fieldGoalsMadeTeam1OperatorTextPlayer = operatorTextPlayer
                    case "OPPONENT: FIELD GOALS MADE":
                        fieldGoalsMadeTeam2OperatorValuePlayer = selectedOperatorValuePlayer
                        fieldGoalsMadeTeam2OperatorTextPlayer = operatorTextPlayer
                    case "PLAYER TEAM: PUNTS":
                        puntsTeam1OperatorValuePlayer = selectedOperatorValuePlayer
                        puntsTeam1OperatorTextPlayer = operatorTextPlayer
                    case "OPPONENT: PUNTS":
                        puntsTeam2OperatorValuePlayer = selectedOperatorValuePlayer
                        puntsTeam2OperatorTextPlayer = operatorTextPlayer
                    case "PLAYER TEAM: PUNT YARDS":
                        puntYardsTeam1OperatorValuePlayer = selectedOperatorValuePlayer
                        puntYardsTeam1OperatorTextPlayer = operatorTextPlayer
                    case "OPPONENT: PUNT YARDS":
                        puntYardsTeam2OperatorValuePlayer = selectedOperatorValuePlayer
                        puntYardsTeam2OperatorTextPlayer = operatorTextPlayer
                    default:
                        return }
                    
                    }
            }
         
            <<< SliderRow("SLIDER") { row in
                row.minimumValue = sliderValuesPlayer.first!
                row.maximumValue = sliderValuesPlayer.last!
                row.steps = UInt(sliderValuesPlayer.count - 1)
                row.cell.valueLabel.font = UIFont.systemFont(ofSize: 12.5)
                row.cell.valueLabel.textColor = silverColor
                /*print(tagTextPlayer + ": Slider Minimum Value = " + String(row.minimumValue) + "\n"
                    + tagTextPlayer + ": Slider Maximum Value = " + String(row.maximumValue) + "\n"
                    + tagTextPlayer + ": Slider Steps = " + String(row.steps))*/
                
 
                if tagTextPlayer == "PLAYER TEAM: SPREAD" || tagTextPlayer == "OVER/UNDER" {
                    row.title = "\0 "
                } else if tagTextPlayer == "TEMPERATURE (F)" {
                    row.title = "\0  "
                } else if tagTextPlayer == "PLAYER TEAM: SEASON WIN %" || tagTextPlayer == "OPPONENT: SEASON WIN %" {
                    row.title = "\0   "
                } else if tagTextPlayer == "PLAYER TEAM: STREAK" || tagTextPlayer == "OPPONENT: STREAK" {
                    row.title = "\0    "
                } else {
                    row.title = " "
                }
                row.cell.backgroundColor = darkGreyColor
                switch (formSliderValuePlayer) {
                case Float(-10000):
                    row.value = sliderValuesPlayer.last!
                default:
                    row.value = formSliderValuePlayer
                    row.cell.valueLabel.text = String(Int(row.value!))
                }
                } .onChange { row in
                    print("playerSliderVC onChange")
                    print("tagTextPlayer: " + tagTextPlayer)
                    switch (tagTextPlayer) {
                    case "PLAYER TEAM: STREAK":
                        winningLosingStreakTeam1SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "OPPONENT: STREAK":
                        winningLosingStreakTeam2SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "PLAYER TEAM: SEASON WIN %":
                        seasonWinPercentageTeam1SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "OPPONENT: SEASON WIN %":
                        seasonWinPercentageTeam2SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "SEASON":
                        seasonSliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "GAME NUMBER":
                        gameNumberSliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "WEEK":
                        weekSliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "PLAYER TEAM: SPREAD":
                        spreadSliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "OVER/UNDER":
                        overUnderSliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "TEMPERATURE (F)":
                        temperatureSliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "PLAYER TEAM: TOTAL POINTS":
                        totalPointsTeam1SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "OPPONENT: TOTAL POINTS":
                        totalPointsTeam2SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "PLAYER TEAM: TOUCHDOWNS":
                        touchdownsTeam1SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "OPPONENT: TOUCHDOWNS":
                        touchdownsTeam2SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                        
                    case "PLAYER TEAM: OFFENSIVE TOUCHDOWNS":
                        offensiveTouchdownsTeam1SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "OPPONENT: OFFENSIVE TOUCHDOWNS":
                        offensiveTouchdownsTeam2SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "PLAYER TEAM: DEFENSIVE TOUCHDOWNS":
                        defensiveTouchdownsTeam1SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "OPPONENT: DEFENSIVE TOUCHDOWNS":
                        defensiveTouchdownsTeam2SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                        
                    case "PLAYER TEAM: TURNOVERS":
                        turnoversCommittedTeam1SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "OPPONENT: TURNOVERS":
                        turnoversCommittedTeam2SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "PLAYER TEAM: PENALTIES":
                        penaltiesCommittedTeam1SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "OPPONENT: PENALTIES":
                        penaltiesCommittedTeam2SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "PLAYER TEAM: TOTAL YARDS":
                        totalYardsTeam1SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "OPPONENT: TOTAL YARDS":
                        totalYardsTeam2SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "PLAYER TEAM: PASSING YARDS":
                        passingYardsTeam1SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "OPPONENT: PASSING YARDS":
                        passingYardsTeam2SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "PLAYER TEAM: RUSHING YARDS":
                        rushingYardsTeam1SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "OPPONENT: RUSHING YARDS":
                        rushingYardsTeam2SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "PLAYER TEAM: QUARTERBACK RATING":
                        quarterbackRatingTeam1SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "OPPONENT: QUARTERBACK RATING":
                        quarterbackRatingTeam2SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "PLAYER TEAM: TIMES SACKED":
                        timesSackedTeam1SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "OPPONENT: TIMES SACKED":
                        timesSackedTeam2SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "PLAYER TEAM: INTERCEPTIONS THROWN":
                        interceptionsThrownTeam1SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "OPPONENT: INTERCEPTIONS THROWN":
                        interceptionsThrownTeam2SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "PLAYER TEAM: OFFENSIVE PLAYS":
                        offensivePlaysTeam1SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "OPPONENT: OFFENSIVE PLAYS":
                        offensivePlaysTeam2SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "PLAYER TEAM: YARDS/OFFENSIVE PLAY":
                        yardsPerOffensivePlayTeam1SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "OPPONENT: YARDS/OFFENSIVE PLAY":
                        yardsPerOffensivePlayTeam2SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "PLAYER TEAM: SACKS":
                        sacksTeam1SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "OPPONENT: SACKS":
                        sacksTeam2SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "PLAYER TEAM: INTERCEPTIONS":
                        interceptionsTeam1SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "OPPONENT: INTERCEPTIONS":
                        interceptionsTeam2SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "PLAYER TEAM: SAFETIES":
                        safetiesTeam1SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "OPPONENT: SAFETIES":
                        safetiesTeam2SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "PLAYER TEAM: DEFENSIVE PLAYS":
                        defensivePlaysTeam1SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "OPPONENT: DEFENSIVE PLAYS":
                        defensivePlaysTeam2SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "PLAYER TEAM: YARDS/DEFENSIVE PLAY":
                        yardsPerDefensivePlayTeam1SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "OPPONENT: YARDS/DEFENSIVE PLAY":
                        yardsPerDefensivePlayTeam2SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "PLAYER TEAM: EXTRA POINT ATTEMPTS":
                        extraPointAttemptsTeam1SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "OPPONENT: EXTRA POINT ATTEMPTS":
                        extraPointAttemptsTeam2SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "PLAYER TEAM: EXTRA POINTS MADE":
                        extraPointsMadeTeam1SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "OPPONENT: EXTRA POINTS MADE":
                        extraPointsMadeTeam2SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "PLAYER TEAM: FIELD GOAL ATTEMPTS":
                        fieldGoalAttemptsTeam1SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "OPPONENT: FIELD GOAL ATTEMPTS":
                        fieldGoalAttemptsTeam2SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "PLAYER TEAM: FIELD GOALS MADE":
                        fieldGoalsMadeTeam1SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "OPPONENT: FIELD GOALS MADE":
                        fieldGoalsMadeTeam2SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "PLAYER TEAM: PUNTS":
                        puntsTeam1SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "OPPONENT: PUNTS":
                        puntsTeam2SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "PLAYER TEAM: PUNT YARDS":
                        puntYardsTeam1SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    case "OPPONENT: PUNT YARDS":
                        puntYardsTeam2SliderValuePlayer = row.value!
                        self.reloadRowValuePlayer()
                    default:
                        rowValue = Float(-10000)
                    }

        }
        
        switch (formRangeSliderLowerValuePlayer) {
        case Float(-10000):
            playerRangeSliderObject.minimumValue = Double(sliderValuesPlayer.first!)
            playerRangeSliderObject.lowerValue = Double(sliderValuesPlayer.first!)
            if tagTextPlayer == "PLAYER TEAM: SPREAD" || tagTextPlayer == "OVER/UNDER" {
                playerRangeSliderObject.stepValue = 0.5
            } else if tagTextPlayer == "PLAYER TEAM: TOTAL YARDS" || tagTextPlayer == "OPPONENT: TOTAL YARDS" || tagTextPlayer == "PLAYER TEAM: PASSING YARDS" || tagTextPlayer == "OPPONENT: PASSING YARDS" || tagTextPlayer == "PLAYER TEAM: RUSHING YARDS" || tagTextPlayer == "OPPONENT: RUSHING YARDS" {
                playerRangeSliderObject.stepValue = 10.0
            } else {
                playerRangeSliderObject.stepValue = 1.0
            }
        default:
            playerRangeSliderObject.minimumValue = Double(sliderValuesPlayer.first!)
            playerRangeSliderObject.lowerValue = Double(formRangeSliderLowerValuePlayer)
            if tagTextPlayer == "PLAYER TEAM: SPREAD" || tagTextPlayer == "OVER/UNDER" {
                playerRangeSliderObject.stepValue = 0.5
            } else if tagTextPlayer == "PLAYER TEAM: TOTAL YARDS" || tagTextPlayer == "OPPONENT: TOTAL YARDS" || tagTextPlayer == "PLAYER TEAM: PASSING YARDS" || tagTextPlayer == "OPPONENT: PASSING YARDS" || tagTextPlayer == "PLAYER TEAM: RUSHING YARDS" || tagTextPlayer == "OPPONENT: RUSHING YARDS" {
                playerRangeSliderObject.stepValue = 10.0
            } else {
                playerRangeSliderObject.stepValue = 1.0
            }
        }
        
        switch (formRangeSliderUpperValuePlayer) {
        case Float(-10000):
            playerRangeSliderObject.maximumValue = Double(sliderValuesPlayer.last!)
            playerRangeSliderObject.upperValue = Double(sliderValuesPlayer.last!)
            if tagTextPlayer == "PLAYER TEAM: SPREAD" || tagTextPlayer == "OVER/UNDER" {
                playerRangeSliderObject.stepValue = 0.5
            } else if tagTextPlayer == "PLAYER TEAM: TOTAL YARDS" || tagTextPlayer == "OPPONENT: TOTAL YARDS" || tagTextPlayer == "PLAYER TEAM: PASSING YARDS" || tagTextPlayer == "OPPONENT: PASSING YARDS" || tagTextPlayer == "PLAYER TEAM: RUSHING YARDS" || tagTextPlayer == "OPPONENT: RUSHING YARDS" {
                playerRangeSliderObject.stepValue = 10.0
            } else {
                playerRangeSliderObject.stepValue = 1.0
            }
        default:
            playerRangeSliderObject.maximumValue = Double(sliderValuesPlayer.last!)
            playerRangeSliderObject.upperValue = Double(formRangeSliderUpperValuePlayer)
            if tagTextPlayer == "PLAYER TEAM: SPREAD" || tagTextPlayer == "OVER/UNDER" {
                playerRangeSliderObject.stepValue = 0.5
            } else if tagTextPlayer == "PLAYER TEAM: TOTAL YARDS" || tagTextPlayer == "OPPONENT: TOTAL YARDS" || tagTextPlayer == "PLAYER TEAM: PASSING YARDS" || tagTextPlayer == "OPPONENT: PASSING YARDS" || tagTextPlayer == "PLAYER TEAM: RUSHING YARDS" || tagTextPlayer == "OPPONENT: RUSHING YARDS" {
                playerRangeSliderObject.stepValue = 10.0
            } else {
                playerRangeSliderObject.stepValue = 1.0
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
        //print("rangeBooleanPlayer: ")
        //print(rangeBooleanPlayer)
        switch (rangeBooleanPlayer) {
        case false:
            if formSliderValuePlayer == Float(-10000) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = self.headerLabel + "\0" + operatorTextPlayer + String(Int(formSliderValuePlayer))
            }
            switch (tagTextPlayer) {
            case "PLAYER TEAM: STREAK":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: STREAK":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: SEASON WIN %":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer)) + "%"
            case "OPPONENT: SEASON WIN %":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer)) + "%"
            case "SEASON":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: SPREAD":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(format: "%.1f", formSliderValuePlayer)
            case "OVER/UNDER":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(format: "%.1f", formSliderValuePlayer)
            case "WEEK":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "GAME NUMBER":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer)) + "°"
            case "TEMPERATURE":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer)) + "°"
            case "PLAYER TEAM: TOTAL POINTS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: TOTAL POINTS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: TOUCHDOWNS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: TOUCHDOWNS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            
            case "PLAYER TEAM: OFFENSIVE TOUCHDOWNS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: OFFENSIVE TOUCHDOWNS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: DEFENSIVE TOUCHDOWNS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: DEFENSIVE TOUCHDOWNS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
                
            case "PLAYER TEAM: TURNOVERS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: TURNOVERS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: PENALTIES":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: PENALTIES":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: TOTAL YARDS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: TOTAL YARDS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: PASSING YARDS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: PASSING YARDS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: RUSHING YARDS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: RUSHING YARDS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: QUARTERBACK RATING":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: QUARTERBACK RATING":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: TIMES SACKED":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: TIMES SACKED":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: INTERCEPTIONS THROWN":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: INTERCEPTIONS THROWN":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: OFFENSIVE PLAYS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: OFFENSIVE PLAYS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: YARDS/OFFENSIVE PLAY":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: YARDS/OFFENSIVE PLAY":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: SACKS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: SACKS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: INTERCEPTIONS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: INTERCEPTIONS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: SAFETIES":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: SAFETIES":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: DEFENSIVE PLAYS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: DEFENSIVE PLAYS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: YARDS/DEFENSIVE PLAY":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: YARDS/DEFENSIVE PLAY":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: EXTRA POINT ATTEMPTS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: EXTRA POINT ATTEMPTS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: EXTRA POINTS MADE":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: EXTRA POINTS MADE":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: FIELD GOAL ATTEMPTS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: FIELD GOAL ATTEMPTS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: FIELD GOALS MADE":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: PUNTS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: PUNTS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: PUNT YARDS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            case "OPPONENT: PUNT YARDS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            default:
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            }
        case true:
            sliderValuePlayer = operatorDictionaryPlayer[formOperatorValuePlayer]! + String(Int(formSliderValuePlayer))
            if (playerRangeSliderObject.lowerValue == Double(sliderValuesPlayer.first!) && playerRangeSliderObject.upperValue == Double(sliderValuesPlayer.last!)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = self.headerLabel + "\0" + operatorTextPlayer + String(Int(playerRangeSliderObject.lowerValue)) + " & " + String(Int(playerRangeSliderObject.upperValue))
            }
            switch (tagTextPlayer) {
            case "PLAYER TEAM: STREAK":
                var formRangeSliderLowerValuePlayerPrefix: String = ""
                var formRangeSliderUpperValuePlayerPrefix: String = ""
                if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) || (formRangeSliderLowerValuePlayer == -10000 && formRangeSliderUpperValuePlayer == -10000) {
                    buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
                } else {
                    if Int(formRangeSliderLowerValuePlayer) > 1 {
                        formRangeSliderLowerValuePlayerPrefix = "+"
                    } else {
                        formRangeSliderLowerValuePlayerPrefix = ""
                    }
                    if Int(formRangeSliderUpperValuePlayer) > 1 {
                        formRangeSliderUpperValuePlayerPrefix = "+"
                    } else {
                        formRangeSliderUpperValuePlayerPrefix = ""
                    }
                    buttonText = headerLabel + "\0" + formOperatorTextPlayer + formRangeSliderLowerValuePlayerPrefix + String(Int(formRangeSliderLowerValuePlayer)) + " & " + formRangeSliderUpperValuePlayerPrefix + String(Int(formRangeSliderUpperValuePlayer))
                }
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + formRangeSliderLowerValuePlayerPrefix + String(Int(formRangeSliderLowerValuePlayer)) + " & " + formRangeSliderUpperValuePlayerPrefix + String(Int(formRangeSliderUpperValuePlayer))
            case "OPPONENT: STREAK":
                var formRangeSliderLowerValuePlayerPrefix: String = ""
                var formRangeSliderUpperValuePlayerPrefix: String = ""
                if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) || (formRangeSliderLowerValuePlayer == -10000 && formRangeSliderUpperValuePlayer == -10000) {
                    buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
                } else {
                    if Int(formRangeSliderLowerValuePlayer) < 1 {
                        formRangeSliderLowerValuePlayerPrefix = "-"
                    } else if Int(formRangeSliderLowerValuePlayer) > 1 {
                        formRangeSliderLowerValuePlayerPrefix = "+"
                    } else {
                        formRangeSliderLowerValuePlayerPrefix = ""
                    }
                    if Int(formRangeSliderUpperValuePlayer) < 1 {
                        formRangeSliderUpperValuePlayerPrefix = "-"
                    } else if Int(formRangeSliderUpperValuePlayer) > 1 {
                        formRangeSliderUpperValuePlayerPrefix = "+"
                    } else {
                        formRangeSliderUpperValuePlayerPrefix = ""
                    }
                    buttonText = headerLabel + "\0" + formOperatorTextPlayer + formRangeSliderLowerValuePlayerPrefix + String(Int(formRangeSliderLowerValuePlayer)) + " & " + formRangeSliderUpperValuePlayerPrefix + String(Int(formRangeSliderUpperValuePlayer))
                }
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + formRangeSliderLowerValuePlayerPrefix + String(Int(formRangeSliderLowerValuePlayer)) + " & " + formRangeSliderUpperValuePlayerPrefix + String(Int(formRangeSliderUpperValuePlayer))
            case "PLAYER TEAM: SEASON WIN %":
                if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) || (formRangeSliderLowerValuePlayer == -10000 && formRangeSliderUpperValuePlayer == -10000) {
                    buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
                } else {
                    buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + "%" + " & " + String(Int(formRangeSliderUpperValuePlayer)) + "%"
                }
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + "%" + " & " + String(Int(formRangeSliderUpperValuePlayer)) + "%"
            case "OPPONENT: SEASON WIN %":
                if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) || (formRangeSliderLowerValuePlayer == -10000 && formRangeSliderUpperValuePlayer == -10000) {
                    buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
                } else {
                    buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + "%" + " & " + String(Int(formRangeSliderUpperValuePlayer)) + "%"
                }
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + "%" + " & " + String(Int(formRangeSliderUpperValuePlayer)) + "%"
            case "SEASON":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: SPREAD":
                if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) || (formRangeSliderLowerValuePlayer == -10000 && formRangeSliderUpperValuePlayer == -10000) {
                    buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
                } else {
                    buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(format: "%.1f", formRangeSliderLowerValuePlayer) + " & " + String(format: "%.1f", formRangeSliderUpperValuePlayer)
                }
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(format: "%.1f", formRangeSliderLowerValuePlayer) + " & " + String(format: "%.1f", formRangeSliderUpperValuePlayer)
            case "OVER/UNDER":
                if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) || (formRangeSliderLowerValuePlayer == -10000 && formRangeSliderUpperValuePlayer == -10000) {
                    buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
                } else {
                    buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(format: "%.1f", formRangeSliderLowerValuePlayer) + " & " + String(format: "%.1f", formRangeSliderUpperValuePlayer)
                }
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(format: "%.1f", formRangeSliderLowerValuePlayer) + " & " + String(format: "%.1f", formRangeSliderUpperValuePlayer)
            case "WEEK":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "GAME NUMBER":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "TEMPERATURE":
                if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) || (formRangeSliderLowerValuePlayer == -10000 && formRangeSliderUpperValuePlayer == -10000) {
                    buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
                } else {
                    buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + "°" + " & " + String(Int(formRangeSliderUpperValuePlayer)) + "°"
                }
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer)) + "°"
            case "PLAYER TEAM: TOTAL POINTS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: TOTAL POINTS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: TOUCHDOWNS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: TOUCHDOWNS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
                
            case "PLAYER TEAM: OFFENSIVE TOUCHDOWNS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: OFFENSIVE TOUCHDOWNS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: DEFENSIVE TOUCHDOWNS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: DEFENSIVE TOUCHDOWNS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
                
            case "PLAYER TEAM: TURNOVERS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: TURNOVERS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: PENALTIES":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: PENALTIES":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: TOTAL YARDS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: TOTAL YARDS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: PASSING YARDS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: PASSING YARDS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: RUSHING YARDS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: RUSHING YARDS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: QUARTERBACK RATING":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: QUARTERBACK RATING":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: TIMES SACKED":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: TIMES SACKED":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: INTERCEPTIONS THROWN":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: INTERCEPTIONS THROWN":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: OFFENSIVE PLAYS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: OFFENSIVE PLAYS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: YARDS/OFFENSIVE PLAY":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: YARDS/OFFENSIVE PLAY":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: SACKS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: SACKS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: INTERCEPTIONS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: INTERCEPTIONS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: SAFETIES":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: SAFETIES":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: DEFENSIVE PLAYS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: DEFENSIVE PLAYS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: YARDS/DEFENSIVE PLAY":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: YARDS/DEFENSIVE PLAY":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: EXTRA POINT ATTEMPTS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: EXTRA POINT ATTEMPTS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: EXTRA POINTS MADE":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: EXTRA POINTS MADE":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.5, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: FIELD GOAL ATTEMPTS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: FIELD GOAL ATTEMPTS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: FIELD GOALS MADE":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.5, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: PUNTS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "OPPONENT: PUNTS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            case "PLAYER TEAM: PUNT YARDS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            case "OPPONENT: PUNT YARDS":
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            default:
                let nullCharIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
                sliderValuePlayer = operatorTextPlayer + String(Int(formSliderValuePlayer))
            }
        }
        
        buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
        buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
        self.view.addSubview(buttonView)
        self.tableView.frame = CGRect(x: 0, y: buttonView.frame.maxY, width: screenWidth, height: self.view.frame.height)
        //print("Portrait screenWidth & screenHeight: ")
        //print(UIScreen.main.bounds.width)
        //print(UIScreen.main.bounds.height)
        let formSliderRow: SliderRow = self.form.rowBy(tag: "SLIDER")!
        formSliderRow.cell.slider.frame = CGRect(x: CGFloat(frameX), y: CGFloat(sliderFrameHeightRatio * Float(UIScreen.main.bounds.height)), width: UIScreen.main.bounds.width - CGFloat(frameX * 2), height: CGFloat(frameHeight))
        playerRangeSliderObject.frame = CGRect(x: CGFloat(frameX + 2.0), y: CGFloat(rangeSliderFrameHeightRatio * Float(UIScreen.main.bounds.height)), width: UIScreen.main.bounds.width - CGFloat((frameX + 2.0) * 2), height: CGFloat(frameHeight))
        playerRangeSliderObject.knobSize = playerRangeSliderObject.frame.height + (4.0/3.0)
        //print(formSliderRow.cell.slider.frame)
        //print(playerRangeSliderObject.frame)
        playerRangeSliderObject.knobTintColor = silverColor
        playerRangeSliderObject.labelFontSize = CGFloat(12.5)
        playerRangeSliderObject.labelColor = silverColor
        playerRangeSliderObject.addTarget(self, action: #selector(setRangeSliderValues), for: .touchUpInside)
        self.view.addSubview(playerRangeSliderObject)
        if playerRangeSliderObject.isHidden == false {
            let formSliderRow: SliderRow = self.form.rowBy(tag: "SLIDER")!
            formSliderRow.hidden = true
            formSliderRow.evaluateHidden()
        } else {
            rangeBooleanPlayer = false
        }
    }
    
    @objc func setRangeSliderValues() {
        //print("setRangeSliderValues()")
        if tagTextPlayer == "PLAYER TEAM: SPREAD" || tagTextPlayer == "OVER/UNDER" {
            playerRangeSliderObject.stepValue = 0.5
        } else if tagTextPlayer == "PLAYER TEAM: TOTAL YARDS" || tagTextPlayer == "OPPONENT: TOTAL YARDS" || tagTextPlayer == "PLAYER TEAM: PASSING YARDS" || tagTextPlayer == "OPPONENT: PASSING YARDS" || tagTextPlayer == "PLAYER TEAM: RUSHING YARDS" || tagTextPlayer == "OPPONENT: RUSHING YARDS" {
            playerRangeSliderObject.stepValue = 10.0
        } else {
            playerRangeSliderObject.stepValue = 1.0
        }
        reloadRowValuePlayer()
    }
    
    func rangeSliderActivated() {
        //print("rangeSliderActivated()")
        let formSliderRow: SliderRow = self.form.rowBy(tag: "SLIDER")!
        formSliderRow.hidden = true
        formSliderRow.evaluateHidden()
        rangeBooleanPlayer = true
        playerRangeSliderObject.minimumValue = Double(sliderValuesPlayer.first!)
        playerRangeSliderObject.lowerValue = Double(sliderValuesPlayer.first!)
        playerRangeSliderObject.maximumValue = Double(sliderValuesPlayer.last!)
        playerRangeSliderObject.upperValue = Double(sliderValuesPlayer.last!)
        if tagTextPlayer == "PLAYER TEAM: SPREAD" || tagTextPlayer == "OVER/UNDER" {
            playerRangeSliderObject.stepValue = 0.5
        } else if tagTextPlayer == "PLAYER TEAM: TOTAL YARDS" || tagTextPlayer == "OPPONENT: TOTAL YARDS" || tagTextPlayer == "PLAYER TEAM: PASSING YARDS" || tagTextPlayer == "OPPONENT: PASSING YARDS" || tagTextPlayer == "PLAYER TEAM: RUSHING YARDS" || tagTextPlayer == "OPPONENT: RUSHING YARDS" {
            playerRangeSliderObject.stepValue = 10.0
        } else {
            playerRangeSliderObject.stepValue = 1.0
        }
        reloadRowValuePlayer()
    }
    
    func singleSelectionSliderActivated() {
        //print("singleSelectionSliderActivated()")
        let formSliderRow: SliderRow = self.form.rowBy(tag: "SLIDER")!
        formSliderRow.hidden = false
        formSliderRow.evaluateHidden()
        rangeBooleanPlayer = false
        formSliderRow.cell.update()
        //print(formSliderRow.cell.slider.frame)
        //print("singleSelectionSliderActivated")
        reloadRowValuePlayer()
    }
    
    @objc func reloadRowValuePlayer() {
        print("reloadRowValuePlayer()")
        
        switch (tagTextPlayer, rangeBooleanPlayer) {
        case ("PLAYER TEAM: STREAK", false):
            //operatorTextPlayer = operatorDictionaryPlayer[selectedOperatorValuePlayer]!
            //winningLosingStreakTeam1SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                winningLosingStreakTeam1SliderValuePlayer = winningLosingStreakTeam1ValuesPlayer.last!
            }
            winningLosingStreakTeam1OperatorValuePlayer = selectedOperatorValuePlayer
            winningLosingStreakTeam1OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = winningLosingStreakTeam1SliderValuePlayer
            formOperatorValuePlayer = winningLosingStreakTeam1OperatorValuePlayer
            formOperatorTextPlayer = winningLosingStreakTeam1OperatorTextPlayer
            var formSliderValuePlayerPrefix: String = ""
            if Int(formSliderValuePlayer) > 0 {
               formSliderValuePlayerPrefix = "+"
            } else {
                formSliderValuePlayerPrefix = ""
            }
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + formSliderValuePlayerPrefix + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(winningLosingStreakTeam1SliderValuePlayer))
            winningLosingStreakTeam1SliderFormValuePlayer = formSliderValuePlayerPrefix + String(Int(winningLosingStreakTeam1SliderValuePlayer))
        case ("PLAYER TEAM: STREAK", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            winningLosingStreakTeam1RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            winningLosingStreakTeam1RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            winningLosingStreakTeam1OperatorValuePlayer = "< >"
            winningLosingStreakTeam1OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = winningLosingStreakTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = winningLosingStreakTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = winningLosingStreakTeam1OperatorValuePlayer
            formOperatorTextPlayer = winningLosingStreakTeam1OperatorTextPlayer
            var formRangeSliderLowerValuePlayerPrefix: String = ""
            var formRangeSliderUpperValuePlayerPrefix: String = ""
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                if Int(formRangeSliderLowerValuePlayer) > 1 {
                    formRangeSliderLowerValuePlayerPrefix = "+"
                } else {
                    formRangeSliderLowerValuePlayerPrefix = ""
                }
                if Int(formRangeSliderUpperValuePlayer) > 1 {
                    formRangeSliderUpperValuePlayerPrefix = "+"
                } else {
                    formRangeSliderUpperValuePlayerPrefix = ""
                }
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + formRangeSliderLowerValuePlayerPrefix + String(Int(formRangeSliderLowerValuePlayer)) + " & " + formRangeSliderUpperValuePlayerPrefix + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            winningLosingStreakTeam1SliderFormValuePlayer = formRangeSliderLowerValuePlayerPrefix + String(Int(winningLosingStreakTeam1RangeSliderLowerValuePlayer)) + " & " + formRangeSliderUpperValuePlayerPrefix + String(Int(winningLosingStreakTeam1RangeSliderUpperValuePlayer))
        case ("OPPONENT: STREAK", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //winningLosingStreakTeam2SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                winningLosingStreakTeam2SliderValuePlayer = winningLosingStreakTeam2ValuesPlayer.last!
            }
            winningLosingStreakTeam2OperatorValuePlayer = selectedOperatorValuePlayer
            winningLosingStreakTeam2OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = winningLosingStreakTeam2SliderValuePlayer
            formOperatorValuePlayer = winningLosingStreakTeam2OperatorValuePlayer
            formOperatorTextPlayer = winningLosingStreakTeam2OperatorTextPlayer
            var formSliderValuePlayerPrefix: String = ""
            if Int(formSliderValuePlayer) > 0 {
                formSliderValuePlayerPrefix = "+"
            } else {
                formSliderValuePlayerPrefix = ""
            }
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + formSliderValuePlayerPrefix + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(winningLosingStreakTeam2SliderValuePlayer))
            winningLosingStreakTeam2SliderFormValuePlayer = formSliderValuePlayerPrefix + String(Int(winningLosingStreakTeam2SliderValuePlayer))
        case ("OPPONENT: STREAK", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            winningLosingStreakTeam2RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            winningLosingStreakTeam2RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            winningLosingStreakTeam2OperatorValuePlayer = "< >"
            winningLosingStreakTeam2OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = winningLosingStreakTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = winningLosingStreakTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = winningLosingStreakTeam2OperatorValuePlayer
            formOperatorTextPlayer = winningLosingStreakTeam2OperatorTextPlayer
            var formRangeSliderLowerValuePlayerPrefix: String = ""
            var formRangeSliderUpperValuePlayerPrefix: String = ""
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                if Int(formRangeSliderLowerValuePlayer) > 1 {
                    formRangeSliderLowerValuePlayerPrefix = "+"
                } else {
                    formRangeSliderLowerValuePlayerPrefix = ""
                }
                if Int(formRangeSliderUpperValuePlayer) > 1 {
                    formRangeSliderUpperValuePlayerPrefix = "+"
                } else {
                    formRangeSliderUpperValuePlayerPrefix = ""
                }
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + formRangeSliderLowerValuePlayerPrefix + String(Int(formRangeSliderLowerValuePlayer)) + " & " + formRangeSliderUpperValuePlayerPrefix + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            winningLosingStreakTeam2SliderFormValuePlayer = formRangeSliderLowerValuePlayerPrefix + String(Int(winningLosingStreakTeam2RangeSliderLowerValuePlayer)) + " & " + formRangeSliderUpperValuePlayerPrefix + String(Int(winningLosingStreakTeam2RangeSliderUpperValuePlayer))
        case ("PLAYER TEAM: SEASON WIN %", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //seasonWinPercentageTeam1SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                seasonWinPercentageTeam1SliderValuePlayer = seasonWinPercentageTeam1ValuesPlayer.last!
            }
            seasonWinPercentageTeam1OperatorValuePlayer = selectedOperatorValuePlayer
            seasonWinPercentageTeam1OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = seasonWinPercentageTeam1SliderValuePlayer
            formOperatorValuePlayer = seasonWinPercentageTeam1OperatorValuePlayer
            formOperatorTextPlayer = seasonWinPercentageTeam1OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer)) + "%"
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(seasonWinPercentageTeam1SliderValuePlayer))
            seasonWinPercentageTeam1SliderFormValuePlayer = String(Int(seasonWinPercentageTeam1SliderValuePlayer)) + "%"
        case ("PLAYER TEAM: SEASON WIN %", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            seasonWinPercentageTeam1RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            seasonWinPercentageTeam1RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            seasonWinPercentageTeam1OperatorValuePlayer = "< >"
            seasonWinPercentageTeam1OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = seasonWinPercentageTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = seasonWinPercentageTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = seasonWinPercentageTeam1OperatorValuePlayer
            formOperatorTextPlayer = seasonWinPercentageTeam1OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + "%" + " & " + String(Int(formRangeSliderUpperValuePlayer)) + "%"
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            seasonWinPercentageTeam1SliderFormValuePlayer = String(Int(seasonWinPercentageTeam1RangeSliderLowerValuePlayer)) + "%" + " & " + String(Int(seasonWinPercentageTeam1RangeSliderUpperValuePlayer)) + "%"
        case ("OPPONENT: SEASON WIN %", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //seasonWinPercentageTeam2SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                seasonWinPercentageTeam2SliderValuePlayer = seasonWinPercentageTeam2ValuesPlayer.last!
            }
            seasonWinPercentageTeam2OperatorValuePlayer = selectedOperatorValuePlayer
            seasonWinPercentageTeam2OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = seasonWinPercentageTeam2SliderValuePlayer
            formOperatorValuePlayer = seasonWinPercentageTeam2OperatorValuePlayer
            formOperatorTextPlayer = seasonWinPercentageTeam2OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer)) + "%"
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(seasonWinPercentageTeam2SliderValuePlayer))
            seasonWinPercentageTeam2SliderFormValuePlayer = String(Int(seasonWinPercentageTeam2SliderValuePlayer)) + "%"
        case ("OPPONENT: SEASON WIN %", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            seasonWinPercentageTeam2RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            seasonWinPercentageTeam2RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            seasonWinPercentageTeam2OperatorValuePlayer = "< >"
            seasonWinPercentageTeam2OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = seasonWinPercentageTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = seasonWinPercentageTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = seasonWinPercentageTeam2OperatorValuePlayer
            formOperatorTextPlayer = seasonWinPercentageTeam2OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + "%" + " & " + String(Int(formRangeSliderUpperValuePlayer)) + "%"
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            seasonWinPercentageTeam2SliderFormValuePlayer = String(Int(seasonWinPercentageTeam2RangeSliderLowerValuePlayer)) + "%" + " & " + String(Int(seasonWinPercentageTeam2RangeSliderUpperValuePlayer)) + "%"
        case ("SEASON", false):
            if formSliderValuePlayer == Float(-10000) {
                seasonSliderValuePlayer = seasonValuesPlayer.last!
            }
            seasonOperatorValuePlayer = selectedOperatorValuePlayer
            seasonOperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = seasonSliderValuePlayer
            formOperatorValuePlayer = seasonOperatorValuePlayer
            formOperatorTextPlayer = seasonOperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(seasonSliderValuePlayer))
            seasonSliderFormValuePlayer = String(Int(seasonSliderValuePlayer))
            print("seasonSliderFormValuePlayer: ")
            print(seasonSliderFormValuePlayer)
        case ("SEASON", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            seasonRangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            seasonRangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            seasonOperatorValuePlayer = "< >"
            seasonOperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = seasonRangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = seasonRangeSliderUpperValuePlayer
            formOperatorValuePlayer = seasonOperatorValuePlayer
            formOperatorTextPlayer = seasonOperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            seasonSliderFormValuePlayer = String(Int(seasonRangeSliderLowerValuePlayer)) + " & " + String(Int(seasonRangeSliderUpperValuePlayer))
            print("seasonSliderFormValuePlayer_Range: ")
            print(seasonSliderFormValuePlayer)
        case ("GAME NUMBER", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //gameNumberSliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                gameNumberSliderValuePlayer = gameNumberValuesPlayer.last!
            }
            gameNumberOperatorValuePlayer = selectedOperatorValuePlayer
            gameNumberOperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = gameNumberSliderValuePlayer
            formOperatorValuePlayer = gameNumberOperatorValuePlayer
            formOperatorTextPlayer = gameNumberOperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(gameNumberSliderValuePlayer))
            gameNumberSliderFormValuePlayer = String(Int(gameNumberSliderValuePlayer))
        case ("GAME NUMBER", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            gameNumberRangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            gameNumberRangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            gameNumberOperatorValuePlayer = "< >"
            gameNumberOperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = gameNumberRangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = gameNumberRangeSliderUpperValuePlayer
            formOperatorValuePlayer = gameNumberOperatorValuePlayer
            formOperatorTextPlayer = gameNumberOperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            gameNumberSliderFormValuePlayer = String(Int(gameNumberRangeSliderLowerValuePlayer)) + " & " + String(Int(gameNumberRangeSliderUpperValuePlayer))
        case ("WEEK", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //weekSliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                weekSliderValuePlayer = weekValuesPlayer.last!
            }
            weekOperatorValuePlayer = selectedOperatorValuePlayer
            weekOperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = weekSliderValuePlayer
            formOperatorValuePlayer = weekOperatorValuePlayer
            formOperatorTextPlayer = weekOperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(weekSliderValuePlayer))
            weekSliderFormValuePlayer = String(Int(weekSliderValuePlayer))
        case ("WEEK", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            weekRangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            weekRangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            weekOperatorValuePlayer = "< >"
            weekOperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = weekRangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = weekRangeSliderUpperValuePlayer
            formOperatorValuePlayer = weekOperatorValuePlayer
            formOperatorTextPlayer = weekOperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            weekSliderFormValuePlayer = String(Int(weekRangeSliderLowerValuePlayer)) + " & " + String(Int(weekRangeSliderUpperValuePlayer))
        case ("PLAYER TEAM: SPREAD", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //spreadSliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                spreadSliderValuePlayer = spreadValuesPlayer.last!
            }
            spreadOperatorValuePlayer = selectedOperatorValuePlayer
            spreadOperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = spreadSliderValuePlayer
            formOperatorValuePlayer = spreadOperatorValuePlayer
            formOperatorTextPlayer = spreadOperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(format: "%.1f", formSliderValuePlayer)
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(format: "%.1f", spreadSliderValuePlayer)
            spreadSliderFormValuePlayer = String(format: "%.1f", spreadSliderValuePlayer)
        case ("PLAYER TEAM: SPREAD", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            spreadRangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            spreadRangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            spreadOperatorValuePlayer = "< >"
            spreadOperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = spreadRangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = spreadRangeSliderUpperValuePlayer
            formOperatorValuePlayer = spreadOperatorValuePlayer
            formOperatorTextPlayer = spreadOperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(format: "%.1f", formRangeSliderLowerValuePlayer) + " & " + String(format: "%.1f", formRangeSliderUpperValuePlayer)
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(format: "%.1f", formRangeSliderLowerValuePlayer) + " & " + String(format: "%.1f", formRangeSliderUpperValuePlayer)
            spreadSliderFormValuePlayer = String(format: "%.1f", spreadRangeSliderLowerValuePlayer) + " & " + String(format: "%.1f", spreadRangeSliderUpperValuePlayer)
        case ("OVER/UNDER", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //overUnderSliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                overUnderSliderValuePlayer = overUnderValuesPlayer.last!
            }
            overUnderOperatorValuePlayer = selectedOperatorValuePlayer
            overUnderOperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = overUnderSliderValuePlayer
            formOperatorValuePlayer = overUnderOperatorValuePlayer
            formOperatorTextPlayer = overUnderOperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(format: "%.1f", formSliderValuePlayer)
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(format: "%.1f", overUnderSliderValuePlayer)
            overUnderSliderFormValuePlayer = String(format: "%.1f", overUnderSliderValuePlayer)
        case ("OVER/UNDER", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            overUnderRangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            overUnderRangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            overUnderOperatorValuePlayer = "< >"
            overUnderOperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = overUnderRangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = overUnderRangeSliderUpperValuePlayer
            formOperatorValuePlayer = overUnderOperatorValuePlayer
            formOperatorTextPlayer = overUnderOperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(format: "%.1f", formRangeSliderLowerValuePlayer) + " & " + String(format: "%.1f", formRangeSliderUpperValuePlayer)
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count)) 
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(format: "%.1f", formRangeSliderLowerValuePlayer) + " & " + String(format: "%.1f", formRangeSliderUpperValuePlayer)
            overUnderSliderFormValuePlayer = String(format: "%.1f", overUnderRangeSliderLowerValuePlayer) + " & " + String(format: "%.1f", overUnderRangeSliderUpperValuePlayer)
        case ("TEMPERATURE (F)", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //temperatureSliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                temperatureSliderValuePlayer = temperatureValuesPlayer.last!
            }
            temperatureOperatorValuePlayer = selectedOperatorValuePlayer
            temperatureOperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = temperatureSliderValuePlayer
            formOperatorValuePlayer = temperatureOperatorValuePlayer
            formOperatorTextPlayer = temperatureOperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer)) + "°"
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(temperatureSliderValuePlayer))
            temperatureSliderFormValuePlayer = String(Int(temperatureSliderValuePlayer)) + "°"
        case ("TEMPERATURE (F)", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            temperatureRangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            temperatureRangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            temperatureOperatorValuePlayer = "< >"
            temperatureOperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = temperatureRangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = temperatureRangeSliderUpperValuePlayer
            formOperatorValuePlayer = temperatureOperatorValuePlayer
            formOperatorTextPlayer = temperatureOperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + "°" + " & " + String(Int(formRangeSliderUpperValuePlayer)) + "°"
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            temperatureSliderFormValuePlayer = String(Int(temperatureRangeSliderLowerValuePlayer)) + "°" + " & " + String(Int(temperatureRangeSliderUpperValuePlayer)) + "°"
        case ("PLAYER TEAM: TOTAL POINTS", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //totalPointsTeam1SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                totalPointsTeam1SliderValuePlayer = totalPointsTeam1ValuesPlayer.last!
            }
            totalPointsTeam1OperatorValuePlayer = selectedOperatorValuePlayer
            totalPointsTeam1OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = totalPointsTeam1SliderValuePlayer
            formOperatorValuePlayer = totalPointsTeam1OperatorValuePlayer
            formOperatorTextPlayer = totalPointsTeam1OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(totalPointsTeam1SliderValuePlayer))
            totalPointsTeam1SliderFormValuePlayer = String(Int(totalPointsTeam1SliderValuePlayer))
        case ("PLAYER TEAM: TOTAL POINTS", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            totalPointsTeam1RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            totalPointsTeam1RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            totalPointsTeam1OperatorValuePlayer = "< >"
            totalPointsTeam1OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = totalPointsTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = totalPointsTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = totalPointsTeam1OperatorValuePlayer
            formOperatorTextPlayer = totalPointsTeam1OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            totalPointsTeam1SliderFormValuePlayer = String(Int(totalPointsTeam1RangeSliderLowerValuePlayer)) + " & " + String(Int(totalPointsTeam1RangeSliderUpperValuePlayer))
        case ("OPPONENT: TOTAL POINTS", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //totalPointsTeam2SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                totalPointsTeam2SliderValuePlayer = totalPointsTeam2ValuesPlayer.last!
            }
            totalPointsTeam2OperatorValuePlayer = selectedOperatorValuePlayer
            totalPointsTeam2OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = totalPointsTeam2SliderValuePlayer
            formOperatorValuePlayer = totalPointsTeam2OperatorValuePlayer
            formOperatorTextPlayer = totalPointsTeam2OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(totalPointsTeam2SliderValuePlayer))
            totalPointsTeam2SliderFormValuePlayer = String(Int(totalPointsTeam2SliderValuePlayer))
        case ("OPPONENT: TOTAL POINTS", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            totalPointsTeam2RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            totalPointsTeam2RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            totalPointsTeam2OperatorValuePlayer = "< >"
            totalPointsTeam2OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = totalPointsTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = totalPointsTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = totalPointsTeam2OperatorValuePlayer
            formOperatorTextPlayer = totalPointsTeam2OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            totalPointsTeam2SliderFormValuePlayer = String(Int(totalPointsTeam2RangeSliderLowerValuePlayer)) + " & " + String(Int(totalPointsTeam2RangeSliderUpperValuePlayer))
        case ("PLAYER TEAM: TOUCHDOWNS", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //touchdownsTeam1SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                touchdownsTeam1SliderValuePlayer = touchdownsTeam1ValuesPlayer.last!
            }
            touchdownsTeam1OperatorValuePlayer = selectedOperatorValuePlayer
            touchdownsTeam1OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = touchdownsTeam1SliderValuePlayer
            formOperatorValuePlayer = touchdownsTeam1OperatorValuePlayer
            formOperatorTextPlayer = touchdownsTeam1OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(touchdownsTeam1SliderValuePlayer))
            touchdownsTeam1SliderFormValuePlayer = String(Int(touchdownsTeam1SliderValuePlayer))
        case ("PLAYER TEAM: TOUCHDOWNS", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            touchdownsTeam1RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            touchdownsTeam1RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            touchdownsTeam1OperatorValuePlayer = "< >"
            touchdownsTeam1OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = touchdownsTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = touchdownsTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = touchdownsTeam1OperatorValuePlayer
            formOperatorTextPlayer = touchdownsTeam1OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            touchdownsTeam1SliderFormValuePlayer = String(Int(touchdownsTeam1RangeSliderLowerValuePlayer)) + " & " + String(Int(touchdownsTeam1RangeSliderUpperValuePlayer))
        case ("OPPONENT: TOUCHDOWNS", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //touchdownsTeam2SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                touchdownsTeam2SliderValuePlayer = touchdownsTeam2ValuesPlayer.last!
            }
            touchdownsTeam2OperatorValuePlayer = selectedOperatorValuePlayer
            touchdownsTeam2OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = touchdownsTeam2SliderValuePlayer
            formOperatorValuePlayer = touchdownsTeam2OperatorValuePlayer
            formOperatorTextPlayer = touchdownsTeam2OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(touchdownsTeam2SliderValuePlayer))
            touchdownsTeam2SliderFormValuePlayer = String(Int(touchdownsTeam2SliderValuePlayer))
        case ("OPPONENT: TOUCHDOWNS", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            touchdownsTeam2RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            touchdownsTeam2RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            touchdownsTeam2OperatorValuePlayer = "< >"
            touchdownsTeam2OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = touchdownsTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = touchdownsTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = touchdownsTeam2OperatorValuePlayer
            formOperatorTextPlayer = touchdownsTeam2OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            touchdownsTeam2SliderFormValuePlayer = String(Int(touchdownsTeam2RangeSliderLowerValuePlayer)) + " & " + String(Int(touchdownsTeam2RangeSliderUpperValuePlayer))
            
            
        case ("PLAYER TEAM: OFFENSIVE TOUCHDOWNS", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //offensiveTouchdownsTeam1SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                offensiveTouchdownsTeam1SliderValuePlayer = offensiveTouchdownsTeam1ValuesPlayer.last!
            }
            offensiveTouchdownsTeam1OperatorValuePlayer = selectedOperatorValuePlayer
            offensiveTouchdownsTeam1OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = offensiveTouchdownsTeam1SliderValuePlayer
            formOperatorValuePlayer = offensiveTouchdownsTeam1OperatorValuePlayer
            formOperatorTextPlayer = offensiveTouchdownsTeam1OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(offensiveTouchdownsTeam1SliderValuePlayer))
            offensiveTouchdownsTeam1SliderFormValuePlayer = String(Int(offensiveTouchdownsTeam1SliderValuePlayer))
        case ("PLAYER TEAM: OFFENSIVE TOUCHDOWNS", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            offensiveTouchdownsTeam1RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            offensiveTouchdownsTeam1RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            offensiveTouchdownsTeam1OperatorValuePlayer = "< >"
            offensiveTouchdownsTeam1OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = offensiveTouchdownsTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = offensiveTouchdownsTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = offensiveTouchdownsTeam1OperatorValuePlayer
            formOperatorTextPlayer = offensiveTouchdownsTeam1OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            offensiveTouchdownsTeam1SliderFormValuePlayer = String(Int(offensiveTouchdownsTeam1RangeSliderLowerValuePlayer)) + " & " + String(Int(offensiveTouchdownsTeam1RangeSliderUpperValuePlayer))
            
        case ("OPPONENT: OFFENSIVE TOUCHDOWNS", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //offensiveTouchdownsTeam2SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                offensiveTouchdownsTeam2SliderValuePlayer = offensiveTouchdownsTeam2ValuesPlayer.last!
            }
            offensiveTouchdownsTeam2OperatorValuePlayer = selectedOperatorValuePlayer
            offensiveTouchdownsTeam2OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = offensiveTouchdownsTeam2SliderValuePlayer
            formOperatorValuePlayer = offensiveTouchdownsTeam2OperatorValuePlayer
            formOperatorTextPlayer = offensiveTouchdownsTeam2OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(offensiveTouchdownsTeam2SliderValuePlayer))
            offensiveTouchdownsTeam2SliderFormValuePlayer = String(Int(offensiveTouchdownsTeam2SliderValuePlayer))
        case ("OPPONENT: OFFENSIVE TOUCHDOWNS", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            offensiveTouchdownsTeam2RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            offensiveTouchdownsTeam2RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            offensiveTouchdownsTeam2OperatorValuePlayer = "< >"
            offensiveTouchdownsTeam2OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = offensiveTouchdownsTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = offensiveTouchdownsTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = offensiveTouchdownsTeam2OperatorValuePlayer
            formOperatorTextPlayer = offensiveTouchdownsTeam2OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            offensiveTouchdownsTeam2SliderFormValuePlayer = String(Int(offensiveTouchdownsTeam2RangeSliderLowerValuePlayer)) + " & " + String(Int(offensiveTouchdownsTeam2RangeSliderUpperValuePlayer))
            
        case ("PLAYER TEAM: DEFENSIVE TOUCHDOWNS", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //defensiveTouchdownsTeam1SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                defensiveTouchdownsTeam1SliderValuePlayer = defensiveTouchdownsTeam1ValuesPlayer.last!
            }
            defensiveTouchdownsTeam1OperatorValuePlayer = selectedOperatorValuePlayer
            defensiveTouchdownsTeam1OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = defensiveTouchdownsTeam1SliderValuePlayer
            formOperatorValuePlayer = defensiveTouchdownsTeam1OperatorValuePlayer
            formOperatorTextPlayer = defensiveTouchdownsTeam1OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(defensiveTouchdownsTeam1SliderValuePlayer))
            defensiveTouchdownsTeam1SliderFormValuePlayer = String(Int(defensiveTouchdownsTeam1SliderValuePlayer))
        case ("PLAYER TEAM: DEFENSIVE TOUCHDOWNS", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            defensiveTouchdownsTeam1RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            defensiveTouchdownsTeam1RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            defensiveTouchdownsTeam1OperatorValuePlayer = "< >"
            defensiveTouchdownsTeam1OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = defensiveTouchdownsTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = defensiveTouchdownsTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = defensiveTouchdownsTeam1OperatorValuePlayer
            formOperatorTextPlayer = defensiveTouchdownsTeam1OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            defensiveTouchdownsTeam1SliderFormValuePlayer = String(Int(defensiveTouchdownsTeam1RangeSliderLowerValuePlayer)) + " & " + String(Int(defensiveTouchdownsTeam1RangeSliderUpperValuePlayer))
            
        case ("OPPONENT: DEFENSIVE TOUCHDOWNS", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //defensiveTouchdownsTeam2SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                defensiveTouchdownsTeam2SliderValuePlayer = defensiveTouchdownsTeam2ValuesPlayer.last!
            }
            defensiveTouchdownsTeam2OperatorValuePlayer = selectedOperatorValuePlayer
            defensiveTouchdownsTeam2OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = defensiveTouchdownsTeam2SliderValuePlayer
            formOperatorValuePlayer = defensiveTouchdownsTeam2OperatorValuePlayer
            formOperatorTextPlayer = defensiveTouchdownsTeam2OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(defensiveTouchdownsTeam2SliderValuePlayer))
            defensiveTouchdownsTeam2SliderFormValuePlayer = String(Int(defensiveTouchdownsTeam2SliderValuePlayer))
        case ("OPPONENT: DEFENSIVE TOUCHDOWNS", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            defensiveTouchdownsTeam2RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            defensiveTouchdownsTeam2RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            defensiveTouchdownsTeam2OperatorValuePlayer = "< >"
            defensiveTouchdownsTeam2OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = defensiveTouchdownsTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = defensiveTouchdownsTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = defensiveTouchdownsTeam2OperatorValuePlayer
            formOperatorTextPlayer = defensiveTouchdownsTeam2OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            defensiveTouchdownsTeam2SliderFormValuePlayer = String(Int(defensiveTouchdownsTeam2RangeSliderLowerValuePlayer)) + " & " + String(Int(defensiveTouchdownsTeam2RangeSliderUpperValuePlayer))
            
            
        case ("PLAYER TEAM: TURNOVERS", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //turnoversCommittedTeam1SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                turnoversCommittedTeam1SliderValuePlayer = turnoversCommittedTeam1ValuesPlayer.last!
            }
            turnoversCommittedTeam1OperatorValuePlayer = selectedOperatorValuePlayer
            turnoversCommittedTeam1OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = turnoversCommittedTeam1SliderValuePlayer
            formOperatorValuePlayer = turnoversCommittedTeam1OperatorValuePlayer
            formOperatorTextPlayer = turnoversCommittedTeam1OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(turnoversCommittedTeam1SliderValuePlayer))
            turnoversCommittedTeam1SliderFormValuePlayer = String(Int(turnoversCommittedTeam1SliderValuePlayer))
        case ("PLAYER TEAM: TURNOVERS", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            turnoversCommittedTeam1RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            turnoversCommittedTeam1RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            turnoversCommittedTeam1OperatorValuePlayer = "< >"
            turnoversCommittedTeam1OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = turnoversCommittedTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = turnoversCommittedTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = turnoversCommittedTeam1OperatorValuePlayer
            formOperatorTextPlayer = turnoversCommittedTeam1OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            turnoversCommittedTeam1SliderFormValuePlayer = String(Int(turnoversCommittedTeam1RangeSliderLowerValuePlayer)) + " & " + String(Int(turnoversCommittedTeam1RangeSliderUpperValuePlayer))
        case ("OPPONENT: TURNOVERS", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //turnoversCommittedTeam2SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                turnoversCommittedTeam2SliderValuePlayer = turnoversCommittedTeam2ValuesPlayer.last!
            }
            turnoversCommittedTeam2OperatorValuePlayer = selectedOperatorValuePlayer
            turnoversCommittedTeam2OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = turnoversCommittedTeam2SliderValuePlayer
            formOperatorValuePlayer = turnoversCommittedTeam2OperatorValuePlayer
            formOperatorTextPlayer = turnoversCommittedTeam2OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(turnoversCommittedTeam2SliderValuePlayer))
            turnoversCommittedTeam2SliderFormValuePlayer = String(Int(turnoversCommittedTeam2SliderValuePlayer))
        case ("OPPONENT: TURNOVERS", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            turnoversCommittedTeam2RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            turnoversCommittedTeam2RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            turnoversCommittedTeam2OperatorValuePlayer = "< >"
            turnoversCommittedTeam2OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = turnoversCommittedTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = turnoversCommittedTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = turnoversCommittedTeam2OperatorValuePlayer
            formOperatorTextPlayer = turnoversCommittedTeam2OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            turnoversCommittedTeam2SliderFormValuePlayer = String(Int(turnoversCommittedTeam2RangeSliderLowerValuePlayer)) + " & " + String(Int(turnoversCommittedTeam2RangeSliderUpperValuePlayer))
        case ("PLAYER TEAM: PENALTIES", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //penaltiesCommittedTeam1SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                penaltiesCommittedTeam1SliderValuePlayer = penaltiesCommittedTeam1ValuesPlayer.last!
            }
            penaltiesCommittedTeam1OperatorValuePlayer = selectedOperatorValuePlayer
            penaltiesCommittedTeam1OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = penaltiesCommittedTeam1SliderValuePlayer
            formOperatorValuePlayer = penaltiesCommittedTeam1OperatorValuePlayer
            formOperatorTextPlayer = penaltiesCommittedTeam1OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(penaltiesCommittedTeam1SliderValuePlayer))
            penaltiesCommittedTeam1SliderFormValuePlayer = String(Int(penaltiesCommittedTeam1SliderValuePlayer))
        case ("PLAYER TEAM: PENALTIES", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            penaltiesCommittedTeam1RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            penaltiesCommittedTeam1RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            penaltiesCommittedTeam1OperatorValuePlayer = "< >"
            penaltiesCommittedTeam1OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = penaltiesCommittedTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = penaltiesCommittedTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = penaltiesCommittedTeam1OperatorValuePlayer
            formOperatorTextPlayer = penaltiesCommittedTeam1OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            penaltiesCommittedTeam1SliderFormValuePlayer = String(Int(penaltiesCommittedTeam1RangeSliderLowerValuePlayer)) + " & " + String(Int(penaltiesCommittedTeam1RangeSliderUpperValuePlayer))
        case ("OPPONENT: PENALTIES", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //penaltiesCommittedTeam2SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                penaltiesCommittedTeam2SliderValuePlayer = penaltiesCommittedTeam2ValuesPlayer.last!
            }
            penaltiesCommittedTeam2OperatorValuePlayer = selectedOperatorValuePlayer
            penaltiesCommittedTeam2OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = penaltiesCommittedTeam2SliderValuePlayer
            formOperatorValuePlayer = penaltiesCommittedTeam2OperatorValuePlayer
            formOperatorTextPlayer = penaltiesCommittedTeam2OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(penaltiesCommittedTeam2SliderValuePlayer))
            penaltiesCommittedTeam2SliderFormValuePlayer = String(Int(penaltiesCommittedTeam2SliderValuePlayer))
        case ("OPPONENT: PENALTIES", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            penaltiesCommittedTeam2RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            penaltiesCommittedTeam2RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            penaltiesCommittedTeam2OperatorValuePlayer = "< >"
            penaltiesCommittedTeam2OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = penaltiesCommittedTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = penaltiesCommittedTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = penaltiesCommittedTeam2OperatorValuePlayer
            formOperatorTextPlayer = penaltiesCommittedTeam2OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            penaltiesCommittedTeam2SliderFormValuePlayer = String(Int(penaltiesCommittedTeam2RangeSliderLowerValuePlayer)) + " & " + String(Int(penaltiesCommittedTeam2RangeSliderUpperValuePlayer))
        case ("PLAYER TEAM: TOTAL YARDS", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //totalYardsTeam1SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                totalYardsTeam1SliderValuePlayer = totalYardsTeam1ValuesPlayer.last!
            }
            totalYardsTeam1OperatorValuePlayer = selectedOperatorValuePlayer
            totalYardsTeam1OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = totalYardsTeam1SliderValuePlayer
            formOperatorValuePlayer = totalYardsTeam1OperatorValuePlayer
            formOperatorTextPlayer = totalYardsTeam1OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(totalYardsTeam1SliderValuePlayer))
            totalYardsTeam1SliderFormValuePlayer = String(Int(totalYardsTeam1SliderValuePlayer))
        case ("PLAYER TEAM: TOTAL YARDS", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            totalYardsTeam1RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            totalYardsTeam1RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            totalYardsTeam1OperatorValuePlayer = "< >"
            totalYardsTeam1OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = totalYardsTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = totalYardsTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = totalYardsTeam1OperatorValuePlayer
            formOperatorTextPlayer = totalYardsTeam1OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            totalYardsTeam1SliderFormValuePlayer = String(Int(totalYardsTeam1RangeSliderLowerValuePlayer)) + " & " + String(Int(totalYardsTeam1RangeSliderUpperValuePlayer))
        case ("OPPONENT: TOTAL YARDS", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //totalYardsTeam2SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                totalYardsTeam2SliderValuePlayer = totalYardsTeam2ValuesPlayer.last!
            }
            totalYardsTeam2OperatorValuePlayer = selectedOperatorValuePlayer
            totalYardsTeam2OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = totalYardsTeam2SliderValuePlayer
            formOperatorValuePlayer = totalYardsTeam2OperatorValuePlayer
            formOperatorTextPlayer = totalYardsTeam2OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(totalYardsTeam2SliderValuePlayer))
            totalYardsTeam2SliderFormValuePlayer = String(Int(totalYardsTeam2SliderValuePlayer))
        case ("OPPONENT: TOTAL YARDS", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            totalYardsTeam2RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            totalYardsTeam2RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            totalYardsTeam2OperatorValuePlayer = "< >"
            totalYardsTeam2OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = totalYardsTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = totalYardsTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = totalYardsTeam2OperatorValuePlayer
            formOperatorTextPlayer = totalYardsTeam2OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            totalYardsTeam2SliderFormValuePlayer = String(Int(totalYardsTeam2RangeSliderLowerValuePlayer)) + " & " + String(Int(totalYardsTeam2RangeSliderUpperValuePlayer))
        case ("PLAYER TEAM: PASSING YARDS", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //passingYardsTeam1SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                passingYardsTeam1SliderValuePlayer = passingYardsTeam1ValuesPlayer.last!
            }
            passingYardsTeam1OperatorValuePlayer = selectedOperatorValuePlayer
            passingYardsTeam1OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = passingYardsTeam1SliderValuePlayer
            formOperatorValuePlayer = passingYardsTeam1OperatorValuePlayer
            formOperatorTextPlayer = passingYardsTeam1OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(passingYardsTeam1SliderValuePlayer))
            passingYardsTeam1SliderFormValuePlayer = String(Int(passingYardsTeam1SliderValuePlayer))
        case ("PLAYER TEAM: PASSING YARDS", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            passingYardsTeam1RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            passingYardsTeam1RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            passingYardsTeam1OperatorValuePlayer = "< >"
            passingYardsTeam1OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = passingYardsTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = passingYardsTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = passingYardsTeam1OperatorValuePlayer
            formOperatorTextPlayer = passingYardsTeam1OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            passingYardsTeam1SliderFormValuePlayer = String(Int(passingYardsTeam1RangeSliderLowerValuePlayer)) + " & " + String(Int(passingYardsTeam1RangeSliderUpperValuePlayer))
        case ("OPPONENT: PASSING YARDS", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //passingYardsTeam2SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                passingYardsTeam2SliderValuePlayer = passingYardsTeam2ValuesPlayer.last!
            }
            passingYardsTeam2OperatorValuePlayer = selectedOperatorValuePlayer
            passingYardsTeam2OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = passingYardsTeam2SliderValuePlayer
            formOperatorValuePlayer = passingYardsTeam2OperatorValuePlayer
            formOperatorTextPlayer = passingYardsTeam2OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(passingYardsTeam2SliderValuePlayer))
            passingYardsTeam2SliderFormValuePlayer = String(Int(passingYardsTeam2SliderValuePlayer))
        case ("OPPONENT: PASSING YARDS", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            passingYardsTeam2RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            passingYardsTeam2RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            passingYardsTeam2OperatorValuePlayer = "< >"
            passingYardsTeam2OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = passingYardsTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = passingYardsTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = passingYardsTeam2OperatorValuePlayer
            formOperatorTextPlayer = passingYardsTeam2OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            passingYardsTeam2SliderFormValuePlayer = String(Int(passingYardsTeam2RangeSliderLowerValuePlayer)) + " & " + String(Int(passingYardsTeam2RangeSliderUpperValuePlayer))
        case ("PLAYER TEAM: RUSHING YARDS", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //rushingYardsTeam1SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                rushingYardsTeam1SliderValuePlayer = rushingYardsTeam1ValuesPlayer.last!
            }
            rushingYardsTeam1OperatorValuePlayer = selectedOperatorValuePlayer
            rushingYardsTeam1OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = rushingYardsTeam1SliderValuePlayer
            formOperatorValuePlayer = rushingYardsTeam1OperatorValuePlayer
            formOperatorTextPlayer = rushingYardsTeam1OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(rushingYardsTeam1SliderValuePlayer))
            rushingYardsTeam1SliderFormValuePlayer = String(Int(rushingYardsTeam1SliderValuePlayer))
        case ("PLAYER TEAM: RUSHING YARDS", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            rushingYardsTeam1RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            rushingYardsTeam1RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            rushingYardsTeam1OperatorValuePlayer = "< >"
            rushingYardsTeam1OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = rushingYardsTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = rushingYardsTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = rushingYardsTeam1OperatorValuePlayer
            formOperatorTextPlayer = rushingYardsTeam1OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            rushingYardsTeam1SliderFormValuePlayer = String(Int(rushingYardsTeam1RangeSliderLowerValuePlayer)) + " & " + String(Int(rushingYardsTeam1RangeSliderUpperValuePlayer))
        case ("OPPONENT: RUSHING YARDS", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //rushingYardsTeam2SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                rushingYardsTeam2SliderValuePlayer = rushingYardsTeam2ValuesPlayer.last!
            }
            rushingYardsTeam2OperatorValuePlayer = selectedOperatorValuePlayer
            rushingYardsTeam2OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = rushingYardsTeam2SliderValuePlayer
            formOperatorValuePlayer = rushingYardsTeam2OperatorValuePlayer
            formOperatorTextPlayer = rushingYardsTeam2OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(rushingYardsTeam2SliderValuePlayer))
            rushingYardsTeam2SliderFormValuePlayer = String(Int(rushingYardsTeam2SliderValuePlayer))
        case ("OPPONENT: RUSHING YARDS", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            rushingYardsTeam2RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            rushingYardsTeam2RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            rushingYardsTeam2OperatorValuePlayer = "< >"
            rushingYardsTeam2OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = rushingYardsTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = rushingYardsTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = rushingYardsTeam2OperatorValuePlayer
            formOperatorTextPlayer = rushingYardsTeam2OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            rushingYardsTeam2SliderFormValuePlayer = String(Int(rushingYardsTeam2RangeSliderLowerValuePlayer)) + " & " + String(Int(rushingYardsTeam2RangeSliderUpperValuePlayer))
        case ("PLAYER TEAM: QUARTERBACK RATING", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //quarterbackRatingTeam1SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                quarterbackRatingTeam1SliderValuePlayer = quarterbackRatingTeam1ValuesPlayer.last!
            }
            quarterbackRatingTeam1OperatorValuePlayer = selectedOperatorValuePlayer
            quarterbackRatingTeam1OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = quarterbackRatingTeam1SliderValuePlayer
            formOperatorValuePlayer = quarterbackRatingTeam1OperatorValuePlayer
            formOperatorTextPlayer = quarterbackRatingTeam1OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(quarterbackRatingTeam1SliderValuePlayer))
            quarterbackRatingTeam1SliderFormValuePlayer = String(Int(quarterbackRatingTeam1SliderValuePlayer))
        case ("PLAYER TEAM: QUARTERBACK RATING", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            quarterbackRatingTeam1RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            quarterbackRatingTeam1RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            quarterbackRatingTeam1OperatorValuePlayer = "< >"
            quarterbackRatingTeam1OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = quarterbackRatingTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = quarterbackRatingTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = quarterbackRatingTeam1OperatorValuePlayer
            formOperatorTextPlayer = quarterbackRatingTeam1OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            quarterbackRatingTeam1SliderFormValuePlayer = String(Int(quarterbackRatingTeam1RangeSliderLowerValuePlayer)) + " & " + String(Int(quarterbackRatingTeam1RangeSliderUpperValuePlayer))
        case ("OPPONENT: QUARTERBACK RATING", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //quarterbackRatingTeam2SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                quarterbackRatingTeam2SliderValuePlayer = quarterbackRatingTeam2ValuesPlayer.last!
            }
            quarterbackRatingTeam2OperatorValuePlayer = selectedOperatorValuePlayer
            quarterbackRatingTeam2OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = quarterbackRatingTeam2SliderValuePlayer
            formOperatorValuePlayer = quarterbackRatingTeam2OperatorValuePlayer
            formOperatorTextPlayer = quarterbackRatingTeam2OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.3, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(quarterbackRatingTeam2SliderValuePlayer))
            quarterbackRatingTeam2SliderFormValuePlayer = String(Int(quarterbackRatingTeam2SliderValuePlayer))
        case ("OPPONENT: QUARTERBACK RATING", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            quarterbackRatingTeam2RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            quarterbackRatingTeam2RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            quarterbackRatingTeam2OperatorValuePlayer = "< >"
            quarterbackRatingTeam2OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = quarterbackRatingTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = quarterbackRatingTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = quarterbackRatingTeam2OperatorValuePlayer
            formOperatorTextPlayer = quarterbackRatingTeam2OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            quarterbackRatingTeam2SliderFormValuePlayer = String(Int(quarterbackRatingTeam2RangeSliderLowerValuePlayer)) + " & " + String(Int(quarterbackRatingTeam2RangeSliderUpperValuePlayer))
        case ("PLAYER TEAM: TIMES SACKED", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //timesSackedTeam1SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                timesSackedTeam1SliderValuePlayer = timesSackedTeam1ValuesPlayer.last!
            }
            timesSackedTeam1OperatorValuePlayer = selectedOperatorValuePlayer
            timesSackedTeam1OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = timesSackedTeam1SliderValuePlayer
            formOperatorValuePlayer = timesSackedTeam1OperatorValuePlayer
            formOperatorTextPlayer = timesSackedTeam1OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(timesSackedTeam1SliderValuePlayer))
            timesSackedTeam1SliderFormValuePlayer = String(Int(timesSackedTeam1SliderValuePlayer))
        case ("PLAYER TEAM: TIMES SACKED", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            timesSackedTeam1RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            timesSackedTeam1RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            timesSackedTeam1OperatorValuePlayer = "< >"
            timesSackedTeam1OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = timesSackedTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = timesSackedTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = timesSackedTeam1OperatorValuePlayer
            formOperatorTextPlayer = timesSackedTeam1OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            timesSackedTeam1SliderFormValuePlayer = String(Int(timesSackedTeam1RangeSliderLowerValuePlayer)) + " & " + String(Int(timesSackedTeam1RangeSliderUpperValuePlayer))
        case ("OPPONENT: TIMES SACKED", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //timesSackedTeam2SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                timesSackedTeam2SliderValuePlayer = timesSackedTeam2ValuesPlayer.last!
            }
            timesSackedTeam2OperatorValuePlayer = selectedOperatorValuePlayer
            timesSackedTeam2OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = timesSackedTeam2SliderValuePlayer
            formOperatorValuePlayer = timesSackedTeam2OperatorValuePlayer
            formOperatorTextPlayer = timesSackedTeam2OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(timesSackedTeam2SliderValuePlayer))
            timesSackedTeam2SliderFormValuePlayer = String(Int(timesSackedTeam2SliderValuePlayer))
        case ("OPPONENT: TIMES SACKED", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            timesSackedTeam2RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            timesSackedTeam2RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            timesSackedTeam2OperatorValuePlayer = "< >"
            timesSackedTeam2OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = timesSackedTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = timesSackedTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = timesSackedTeam2OperatorValuePlayer
            formOperatorTextPlayer = timesSackedTeam2OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            timesSackedTeam2SliderFormValuePlayer = String(Int(timesSackedTeam2RangeSliderLowerValuePlayer)) + " & " + String(Int(timesSackedTeam2RangeSliderUpperValuePlayer))
        case ("PLAYER TEAM: INTERCEPTIONS THROWN", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //interceptionsThrownTeam1SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                interceptionsThrownTeam1SliderValuePlayer = interceptionsThrownTeam1ValuesPlayer.last!
            }
            interceptionsThrownTeam1OperatorValuePlayer = selectedOperatorValuePlayer
            interceptionsThrownTeam1OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = interceptionsThrownTeam1SliderValuePlayer
            formOperatorValuePlayer = interceptionsThrownTeam1OperatorValuePlayer
            formOperatorTextPlayer = interceptionsThrownTeam1OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(interceptionsThrownTeam1SliderValuePlayer))
            interceptionsThrownTeam1SliderFormValuePlayer = String(Int(interceptionsThrownTeam1SliderValuePlayer))
        case ("PLAYER TEAM: INTERCEPTIONS THROWN", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            interceptionsThrownTeam1RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            interceptionsThrownTeam1RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            interceptionsThrownTeam1OperatorValuePlayer = "< >"
            interceptionsThrownTeam1OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = interceptionsThrownTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = interceptionsThrownTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = interceptionsThrownTeam1OperatorValuePlayer
            formOperatorTextPlayer = interceptionsThrownTeam1OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            interceptionsThrownTeam1SliderFormValuePlayer = String(Int(interceptionsThrownTeam1RangeSliderLowerValuePlayer)) + " & " + String(Int(interceptionsThrownTeam1RangeSliderUpperValuePlayer))
        case ("OPPONENT: INTERCEPTIONS THROWN", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //interceptionsThrownTeam2SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                interceptionsThrownTeam2SliderValuePlayer = interceptionsThrownTeam2ValuesPlayer.last!
            }
            interceptionsThrownTeam2OperatorValuePlayer = selectedOperatorValuePlayer
            interceptionsThrownTeam2OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = interceptionsThrownTeam2SliderValuePlayer
            formOperatorValuePlayer = interceptionsThrownTeam2OperatorValuePlayer
            formOperatorTextPlayer = interceptionsThrownTeam2OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(interceptionsThrownTeam2SliderValuePlayer))
            interceptionsThrownTeam2SliderFormValuePlayer = String(Int(interceptionsThrownTeam2SliderValuePlayer))
        case ("OPPONENT: INTERCEPTIONS THROWN", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            interceptionsThrownTeam2RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            interceptionsThrownTeam2RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            interceptionsThrownTeam2OperatorValuePlayer = "< >"
            interceptionsThrownTeam2OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = interceptionsThrownTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = interceptionsThrownTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = interceptionsThrownTeam2OperatorValuePlayer
            formOperatorTextPlayer = interceptionsThrownTeam2OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            interceptionsThrownTeam2SliderFormValuePlayer = String(Int(interceptionsThrownTeam2RangeSliderLowerValuePlayer)) + " & " + String(Int(interceptionsThrownTeam2RangeSliderUpperValuePlayer))
        case ("PLAYER TEAM: OFFENSIVE PLAYS", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //offensivePlaysTeam1SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                offensivePlaysTeam1SliderValuePlayer = offensivePlaysTeam1ValuesPlayer.last!
            }
            offensivePlaysTeam1OperatorValuePlayer = selectedOperatorValuePlayer
            offensivePlaysTeam1OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = offensivePlaysTeam1SliderValuePlayer
            formOperatorValuePlayer = offensivePlaysTeam1OperatorValuePlayer
            formOperatorTextPlayer = offensivePlaysTeam1OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(offensivePlaysTeam1SliderValuePlayer))
            offensivePlaysTeam1SliderFormValuePlayer = String(Int(offensivePlaysTeam1SliderValuePlayer))
        case ("PLAYER TEAM: OFFENSIVE PLAYS", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            offensivePlaysTeam1RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            offensivePlaysTeam1RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            offensivePlaysTeam1OperatorValuePlayer = "< >"
            offensivePlaysTeam1OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = offensivePlaysTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = offensivePlaysTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = offensivePlaysTeam1OperatorValuePlayer
            formOperatorTextPlayer = offensivePlaysTeam1OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            offensivePlaysTeam1SliderFormValuePlayer = String(Int(offensivePlaysTeam1RangeSliderLowerValuePlayer)) + " & " + String(Int(offensivePlaysTeam1RangeSliderUpperValuePlayer))
        case ("OPPONENT: OFFENSIVE PLAYS", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //offensivePlaysTeam2SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                offensivePlaysTeam2SliderValuePlayer = offensivePlaysTeam2ValuesPlayer.last!
            }
            offensivePlaysTeam2OperatorValuePlayer = selectedOperatorValuePlayer
            offensivePlaysTeam2OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = offensivePlaysTeam2SliderValuePlayer
            formOperatorValuePlayer = offensivePlaysTeam2OperatorValuePlayer
            formOperatorTextPlayer = offensivePlaysTeam2OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(offensivePlaysTeam2SliderValuePlayer))
            offensivePlaysTeam2SliderFormValuePlayer = String(Int(offensivePlaysTeam2SliderValuePlayer))
        case ("OPPONENT: OFFENSIVE PLAYS", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            offensivePlaysTeam2RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            offensivePlaysTeam2RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            offensivePlaysTeam2OperatorValuePlayer = "< >"
            offensivePlaysTeam2OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = offensivePlaysTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = offensivePlaysTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = offensivePlaysTeam2OperatorValuePlayer
            formOperatorTextPlayer = offensivePlaysTeam2OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            offensivePlaysTeam2SliderFormValuePlayer = String(Int(offensivePlaysTeam2RangeSliderLowerValuePlayer)) + " & " + String(Int(offensivePlaysTeam2RangeSliderUpperValuePlayer))
        case ("PLAYER TEAM: YARDS/OFFENSIVE PLAY", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //yardsPerOffensivePlayTeam1SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                yardsPerOffensivePlayTeam1SliderValuePlayer = yardsPerOffensivePlayTeam1ValuesPlayer.last!
            }
            yardsPerOffensivePlayTeam1OperatorValuePlayer = selectedOperatorValuePlayer
            yardsPerOffensivePlayTeam1OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = yardsPerOffensivePlayTeam1SliderValuePlayer
            formOperatorValuePlayer = yardsPerOffensivePlayTeam1OperatorValuePlayer
            formOperatorTextPlayer = yardsPerOffensivePlayTeam1OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(yardsPerOffensivePlayTeam1SliderValuePlayer))
            yardsPerOffensivePlayTeam1SliderFormValuePlayer = String(Int(yardsPerOffensivePlayTeam1SliderValuePlayer))
        case ("PLAYER TEAM: YARDS/OFFENSIVE PLAY", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            yardsPerOffensivePlayTeam1RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            yardsPerOffensivePlayTeam1RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            yardsPerOffensivePlayTeam1OperatorValuePlayer = "< >"
            yardsPerOffensivePlayTeam1OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = yardsPerOffensivePlayTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = yardsPerOffensivePlayTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = yardsPerOffensivePlayTeam1OperatorValuePlayer
            formOperatorTextPlayer = yardsPerOffensivePlayTeam1OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            yardsPerOffensivePlayTeam1SliderFormValuePlayer = String(Int(yardsPerOffensivePlayTeam1RangeSliderLowerValuePlayer)) + " & " + String(Int(yardsPerOffensivePlayTeam1RangeSliderUpperValuePlayer))
        case ("OPPONENT: YARDS/OFFENSIVE PLAY", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //yardsPerOffensivePlayTeam2SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                yardsPerOffensivePlayTeam2SliderValuePlayer = yardsPerOffensivePlayTeam2ValuesPlayer.last!
            }
            yardsPerOffensivePlayTeam2OperatorValuePlayer = selectedOperatorValuePlayer
            yardsPerOffensivePlayTeam2OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = yardsPerOffensivePlayTeam2SliderValuePlayer
            formOperatorValuePlayer = yardsPerOffensivePlayTeam2OperatorValuePlayer
            formOperatorTextPlayer = yardsPerOffensivePlayTeam2OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(yardsPerOffensivePlayTeam2SliderValuePlayer))
            yardsPerOffensivePlayTeam2SliderFormValuePlayer = String(Int(yardsPerOffensivePlayTeam2SliderValuePlayer))
        case ("OPPONENT: YARDS/OFFENSIVE PLAY", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            yardsPerOffensivePlayTeam2RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            yardsPerOffensivePlayTeam2RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            yardsPerOffensivePlayTeam2OperatorValuePlayer = "< >"
            yardsPerOffensivePlayTeam2OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = yardsPerOffensivePlayTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = yardsPerOffensivePlayTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = yardsPerOffensivePlayTeam2OperatorValuePlayer
            formOperatorTextPlayer = yardsPerOffensivePlayTeam2OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            yardsPerOffensivePlayTeam2SliderFormValuePlayer = String(Int(yardsPerOffensivePlayTeam2RangeSliderLowerValuePlayer)) + " & " + String(Int(yardsPerOffensivePlayTeam2RangeSliderUpperValuePlayer))
        case ("PLAYER TEAM: SACKS", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //sacksTeam1SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                sacksTeam1SliderValuePlayer = sacksTeam1ValuesPlayer.last!
            }
            sacksTeam1OperatorValuePlayer = selectedOperatorValuePlayer
            sacksTeam1OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = sacksTeam1SliderValuePlayer
            formOperatorValuePlayer = sacksTeam1OperatorValuePlayer
            formOperatorTextPlayer = sacksTeam1OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(sacksTeam1SliderValuePlayer))
            sacksTeam1SliderFormValuePlayer = String(Int(sacksTeam1SliderValuePlayer))
        case ("PLAYER TEAM: SACKS", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            sacksTeam1RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            sacksTeam1RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            sacksTeam1OperatorValuePlayer = "< >"
            sacksTeam1OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = sacksTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = sacksTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = sacksTeam1OperatorValuePlayer
            formOperatorTextPlayer = sacksTeam1OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            sacksTeam1SliderFormValuePlayer = String(Int(sacksTeam1RangeSliderLowerValuePlayer)) + " & " + String(Int(sacksTeam1RangeSliderUpperValuePlayer))
        case ("OPPONENT: SACKS", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //sacksTeam2SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                sacksTeam2SliderValuePlayer = sacksTeam2ValuesPlayer.last!
            }
            sacksTeam2OperatorValuePlayer = selectedOperatorValuePlayer
            sacksTeam2OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = sacksTeam2SliderValuePlayer
            formOperatorValuePlayer = sacksTeam2OperatorValuePlayer
            formOperatorTextPlayer = sacksTeam2OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(sacksTeam2SliderValuePlayer))
            sacksTeam2SliderFormValuePlayer = String(Int(sacksTeam2SliderValuePlayer))
        case ("OPPONENT: SACKS", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            sacksTeam2RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            sacksTeam2RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            sacksTeam2OperatorValuePlayer = "< >"
            sacksTeam2OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = sacksTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = sacksTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = sacksTeam2OperatorValuePlayer
            formOperatorTextPlayer = sacksTeam2OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            sacksTeam2SliderFormValuePlayer = String(Int(sacksTeam2RangeSliderLowerValuePlayer)) + " & " + String(Int(sacksTeam2RangeSliderUpperValuePlayer))
        case ("PLAYER TEAM: INTERCEPTIONS", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //interceptionsTeam1SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                interceptionsTeam1SliderValuePlayer = interceptionsTeam1ValuesPlayer.last!
            }
            interceptionsTeam1OperatorValuePlayer = selectedOperatorValuePlayer
            interceptionsTeam1OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = interceptionsTeam1SliderValuePlayer
            formOperatorValuePlayer = interceptionsTeam1OperatorValuePlayer
            formOperatorTextPlayer = interceptionsTeam1OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(interceptionsTeam1SliderValuePlayer))
            interceptionsTeam1SliderFormValuePlayer = String(Int(interceptionsTeam1SliderValuePlayer))
        case ("PLAYER TEAM: INTERCEPTIONS", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            interceptionsTeam1RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            interceptionsTeam1RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            interceptionsTeam1OperatorValuePlayer = "< >"
            interceptionsTeam1OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = interceptionsTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = interceptionsTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = interceptionsTeam1OperatorValuePlayer
            formOperatorTextPlayer = interceptionsTeam1OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            interceptionsTeam1SliderFormValuePlayer = String(Int(interceptionsTeam1RangeSliderLowerValuePlayer)) + " & " + String(Int(interceptionsTeam1RangeSliderUpperValuePlayer))
        case ("OPPONENT: INTERCEPTIONS", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //interceptionsTeam2SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                interceptionsTeam2SliderValuePlayer = interceptionsTeam2ValuesPlayer.last!
            }
            interceptionsTeam2OperatorValuePlayer = selectedOperatorValuePlayer
            interceptionsTeam2OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = interceptionsTeam2SliderValuePlayer
            formOperatorValuePlayer = interceptionsTeam2OperatorValuePlayer
            formOperatorTextPlayer = interceptionsTeam2OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(interceptionsTeam2SliderValuePlayer))
            interceptionsTeam2SliderFormValuePlayer = String(Int(interceptionsTeam2SliderValuePlayer))
        case ("OPPONENT: INTERCEPTIONS", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            interceptionsTeam2RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            interceptionsTeam2RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            interceptionsTeam2OperatorValuePlayer = "< >"
            interceptionsTeam2OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = interceptionsTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = interceptionsTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = interceptionsTeam2OperatorValuePlayer
            formOperatorTextPlayer = interceptionsTeam2OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            interceptionsTeam2SliderFormValuePlayer = String(Int(interceptionsTeam2RangeSliderLowerValuePlayer)) + " & " + String(Int(interceptionsTeam2RangeSliderUpperValuePlayer))
        case ("PLAYER TEAM: SAFETIES", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //safetiesTeam1SliderValuePlayer = rowValue'
            if formSliderValuePlayer == Float(-10000) {
                safetiesTeam1SliderValuePlayer = safetiesTeam1ValuesPlayer.last!
            }
            safetiesTeam1OperatorValuePlayer = selectedOperatorValuePlayer
            safetiesTeam1OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = safetiesTeam1SliderValuePlayer
            formOperatorValuePlayer = safetiesTeam1OperatorValuePlayer
            formOperatorTextPlayer = safetiesTeam1OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(safetiesTeam1SliderValuePlayer))
            safetiesTeam1SliderFormValuePlayer = String(Int(safetiesTeam1SliderValuePlayer))
        case ("PLAYER TEAM: SAFETIES", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            safetiesTeam1RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            safetiesTeam1RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            safetiesTeam1OperatorValuePlayer = "< >"
            safetiesTeam1OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = safetiesTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = safetiesTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = safetiesTeam1OperatorValuePlayer
            formOperatorTextPlayer = safetiesTeam1OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            safetiesTeam1SliderFormValuePlayer = String(Int(safetiesTeam1RangeSliderLowerValuePlayer)) + " & " + String(Int(safetiesTeam1RangeSliderUpperValuePlayer))
        case ("OPPONENT: SAFETIES", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //safetiesTeam2SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                safetiesTeam2SliderValuePlayer = safetiesTeam2ValuesPlayer.last!
            }
            safetiesTeam2OperatorValuePlayer = selectedOperatorValuePlayer
            safetiesTeam2OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = safetiesTeam2SliderValuePlayer
            formOperatorValuePlayer = safetiesTeam2OperatorValuePlayer
            formOperatorTextPlayer = safetiesTeam2OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(safetiesTeam2SliderValuePlayer))
            safetiesTeam2SliderFormValuePlayer = String(Int(safetiesTeam2SliderValuePlayer))
        case ("OPPONENT: SAFETIES", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            safetiesTeam2RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            safetiesTeam2RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            safetiesTeam2OperatorValuePlayer = "< >"
            safetiesTeam2OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = safetiesTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = safetiesTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = safetiesTeam2OperatorValuePlayer
            formOperatorTextPlayer = safetiesTeam2OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            safetiesTeam2SliderFormValuePlayer = String(Int(safetiesTeam2RangeSliderLowerValuePlayer)) + " & " + String(Int(safetiesTeam2RangeSliderUpperValuePlayer))
        case ("PLAYER TEAM: DEFENSIVE PLAYS", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //defensivePlaysTeam1SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                defensivePlaysTeam1SliderValuePlayer = defensivePlaysTeam1ValuesPlayer.last!
            }
            defensivePlaysTeam1OperatorValuePlayer = selectedOperatorValuePlayer
            defensivePlaysTeam1OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = defensivePlaysTeam1SliderValuePlayer
            formOperatorValuePlayer = defensivePlaysTeam1OperatorValuePlayer
            formOperatorTextPlayer = defensivePlaysTeam1OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(defensivePlaysTeam1SliderValuePlayer))
            defensivePlaysTeam1SliderFormValuePlayer = String(Int(defensivePlaysTeam1SliderValuePlayer))
        case ("PLAYER TEAM: DEFENSIVE PLAYS", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            defensivePlaysTeam1RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            defensivePlaysTeam1RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            defensivePlaysTeam1OperatorValuePlayer = "< >"
            defensivePlaysTeam1OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = defensivePlaysTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = defensivePlaysTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = defensivePlaysTeam1OperatorValuePlayer
            formOperatorTextPlayer = defensivePlaysTeam1OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            defensivePlaysTeam1SliderFormValuePlayer = String(Int(defensivePlaysTeam1RangeSliderLowerValuePlayer)) + " & " + String(Int(defensivePlaysTeam1RangeSliderUpperValuePlayer))
        case ("OPPONENT: DEFENSIVE PLAYS", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //defensivePlaysTeam2SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                defensivePlaysTeam2SliderValuePlayer = defensivePlaysTeam2ValuesPlayer.last!
            }
            defensivePlaysTeam2OperatorValuePlayer = selectedOperatorValuePlayer
            defensivePlaysTeam2OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = defensivePlaysTeam2SliderValuePlayer
            formOperatorValuePlayer = defensivePlaysTeam2OperatorValuePlayer
            formOperatorTextPlayer = defensivePlaysTeam2OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(defensivePlaysTeam2SliderValuePlayer))
            defensivePlaysTeam2SliderFormValuePlayer = String(Int(defensivePlaysTeam2SliderValuePlayer))
        case ("OPPONENT: DEFENSIVE PLAYS", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            defensivePlaysTeam2RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            defensivePlaysTeam2RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            defensivePlaysTeam2OperatorValuePlayer = "< >"
            defensivePlaysTeam2OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = defensivePlaysTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = defensivePlaysTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = defensivePlaysTeam2OperatorValuePlayer
            formOperatorTextPlayer = defensivePlaysTeam2OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            defensivePlaysTeam2SliderFormValuePlayer = String(Int(defensivePlaysTeam2RangeSliderLowerValuePlayer)) + " & " + String(Int(defensivePlaysTeam2RangeSliderUpperValuePlayer))
        case ("PLAYER TEAM: YARDS/DEFENSIVE PLAY", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //yardsPerDefensivePlayTeam1SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                yardsPerDefensivePlayTeam1SliderValuePlayer = yardsPerDefensivePlayTeam1ValuesPlayer.last!
            }
            yardsPerDefensivePlayTeam1OperatorValuePlayer = selectedOperatorValuePlayer
            yardsPerDefensivePlayTeam1OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = yardsPerDefensivePlayTeam1SliderValuePlayer
            formOperatorValuePlayer = yardsPerDefensivePlayTeam1OperatorValuePlayer
            formOperatorTextPlayer = yardsPerDefensivePlayTeam1OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(yardsPerDefensivePlayTeam1SliderValuePlayer))
            yardsPerDefensivePlayTeam1SliderFormValuePlayer = String(Int(yardsPerDefensivePlayTeam1SliderValuePlayer))
        case ("PLAYER TEAM: YARDS/DEFENSIVE PLAY", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            yardsPerDefensivePlayTeam1RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            yardsPerDefensivePlayTeam1RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            yardsPerDefensivePlayTeam1OperatorValuePlayer = "< >"
            yardsPerDefensivePlayTeam1OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = yardsPerDefensivePlayTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = yardsPerDefensivePlayTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = yardsPerDefensivePlayTeam1OperatorValuePlayer
            formOperatorTextPlayer = yardsPerDefensivePlayTeam1OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            yardsPerDefensivePlayTeam1SliderFormValuePlayer = String(Int(yardsPerDefensivePlayTeam1RangeSliderLowerValuePlayer)) + " & " + String(Int(yardsPerDefensivePlayTeam1RangeSliderUpperValuePlayer))
        case ("OPPONENT: YARDS/DEFENSIVE PLAY", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //yardsPerDefensivePlayTeam2SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                yardsPerDefensivePlayTeam2SliderValuePlayer = yardsPerDefensivePlayTeam2ValuesPlayer.last!
            }
            yardsPerDefensivePlayTeam2OperatorValuePlayer = selectedOperatorValuePlayer
            yardsPerDefensivePlayTeam2OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = yardsPerDefensivePlayTeam2SliderValuePlayer
            formOperatorValuePlayer = yardsPerDefensivePlayTeam2OperatorValuePlayer
            formOperatorTextPlayer = yardsPerDefensivePlayTeam2OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(yardsPerDefensivePlayTeam2SliderValuePlayer))
            yardsPerDefensivePlayTeam2SliderFormValuePlayer = String(Int(yardsPerDefensivePlayTeam2SliderValuePlayer))
        case ("OPPONENT: YARDS/DEFENSIVE PLAY", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            yardsPerDefensivePlayTeam2RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            yardsPerDefensivePlayTeam2RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            yardsPerDefensivePlayTeam2OperatorValuePlayer = "< >"
            yardsPerDefensivePlayTeam2OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = yardsPerDefensivePlayTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = yardsPerDefensivePlayTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = yardsPerDefensivePlayTeam2OperatorValuePlayer
            formOperatorTextPlayer = yardsPerDefensivePlayTeam2OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            yardsPerDefensivePlayTeam2SliderFormValuePlayer = String(Int(yardsPerDefensivePlayTeam2RangeSliderLowerValuePlayer)) + " & " + String(Int(yardsPerDefensivePlayTeam2RangeSliderUpperValuePlayer))
        case ("PLAYER TEAM: EXTRA POINT ATTEMPTS", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //extraPointAttemptsTeam1SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                extraPointAttemptsTeam1SliderValuePlayer = extraPointAttemptsTeam1ValuesPlayer.last!
            }
            extraPointAttemptsTeam1OperatorValuePlayer = selectedOperatorValuePlayer
            extraPointAttemptsTeam1OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = extraPointAttemptsTeam1SliderValuePlayer
            formOperatorValuePlayer = extraPointAttemptsTeam1OperatorValuePlayer
            formOperatorTextPlayer = extraPointAttemptsTeam1OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(extraPointAttemptsTeam1SliderValuePlayer))
            extraPointAttemptsTeam1SliderFormValuePlayer = String(Int(extraPointAttemptsTeam1SliderValuePlayer))
        case ("PLAYER TEAM: EXTRA POINT ATTEMPTS", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            extraPointAttemptsTeam1RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            extraPointAttemptsTeam1RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            extraPointAttemptsTeam1OperatorValuePlayer = "< >"
            extraPointAttemptsTeam1OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = extraPointAttemptsTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = extraPointAttemptsTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = extraPointAttemptsTeam1OperatorValuePlayer
            formOperatorTextPlayer = extraPointAttemptsTeam1OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            extraPointAttemptsTeam1SliderFormValuePlayer = String(Int(extraPointAttemptsTeam1RangeSliderLowerValuePlayer)) + " & " + String(Int(extraPointAttemptsTeam1RangeSliderUpperValuePlayer))
        case ("OPPONENT: EXTRA POINT ATTEMPTS", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //extraPointAttemptsTeam2SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                extraPointAttemptsTeam2SliderValuePlayer = extraPointAttemptsTeam2ValuesPlayer.last!
            }
            extraPointAttemptsTeam2OperatorValuePlayer = selectedOperatorValuePlayer
            extraPointAttemptsTeam2OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = extraPointAttemptsTeam2SliderValuePlayer
            formOperatorValuePlayer = extraPointAttemptsTeam2OperatorValuePlayer
            formOperatorTextPlayer = extraPointAttemptsTeam2OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(extraPointAttemptsTeam2SliderValuePlayer))
            extraPointAttemptsTeam2SliderFormValuePlayer = String(Int(extraPointAttemptsTeam2SliderValuePlayer))
        case ("OPPONENT: EXTRA POINT ATTEMPTS", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            extraPointAttemptsTeam2RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            extraPointAttemptsTeam2RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            extraPointAttemptsTeam2OperatorValuePlayer = "< >"
            extraPointAttemptsTeam2OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = extraPointAttemptsTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = extraPointAttemptsTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = extraPointAttemptsTeam2OperatorValuePlayer
            formOperatorTextPlayer = extraPointAttemptsTeam2OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length: nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            extraPointAttemptsTeam2SliderFormValuePlayer = String(Int(extraPointAttemptsTeam2RangeSliderLowerValuePlayer)) + " & " + String(Int(extraPointAttemptsTeam2RangeSliderUpperValuePlayer))
        case ("PLAYER TEAM: EXTRA POINTS MADE", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //extraPointsMadeTeam1SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                extraPointsMadeTeam1SliderValuePlayer = extraPointsMadeTeam1ValuesPlayer.last!
            }
            extraPointsMadeTeam1OperatorValuePlayer = selectedOperatorValuePlayer
            extraPointsMadeTeam1OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = extraPointsMadeTeam1SliderValuePlayer
            formOperatorValuePlayer = extraPointsMadeTeam1OperatorValuePlayer
            formOperatorTextPlayer = extraPointsMadeTeam1OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(extraPointsMadeTeam1SliderValuePlayer))
            extraPointsMadeTeam1SliderFormValuePlayer = String(Int(extraPointsMadeTeam1SliderValuePlayer))
        case ("PLAYER TEAM: EXTRA POINTS MADE", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            extraPointsMadeTeam1RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            extraPointsMadeTeam1RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            extraPointsMadeTeam1OperatorValuePlayer = "< >"
            extraPointsMadeTeam1OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = extraPointsMadeTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = extraPointsMadeTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = extraPointsMadeTeam1OperatorValuePlayer
            formOperatorTextPlayer = extraPointsMadeTeam1OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            extraPointsMadeTeam1SliderFormValuePlayer = String(Int(extraPointsMadeTeam1RangeSliderLowerValuePlayer)) + " & " + String(Int(extraPointsMadeTeam1RangeSliderUpperValuePlayer))
        case ("OPPONENT: EXTRA POINTS MADE", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //extraPointsMadeTeam2SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                extraPointsMadeTeam2SliderValuePlayer = extraPointsMadeTeam2ValuesPlayer.last!
            }
            extraPointsMadeTeam2OperatorValuePlayer = selectedOperatorValuePlayer
            extraPointsMadeTeam2OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = extraPointsMadeTeam2SliderValuePlayer
            formOperatorValuePlayer = extraPointsMadeTeam2OperatorValuePlayer
            formOperatorTextPlayer = extraPointsMadeTeam2OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(extraPointsMadeTeam2SliderValuePlayer))
            extraPointsMadeTeam2SliderFormValuePlayer = String(Int(extraPointsMadeTeam2SliderValuePlayer))
        case ("OPPONENT: EXTRA POINTS MADE", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            extraPointsMadeTeam2RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            extraPointsMadeTeam2RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            extraPointsMadeTeam2OperatorValuePlayer = "< >"
            extraPointsMadeTeam2OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = extraPointsMadeTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = extraPointsMadeTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = extraPointsMadeTeam2OperatorValuePlayer
            formOperatorTextPlayer = extraPointsMadeTeam2OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            extraPointsMadeTeam2SliderFormValuePlayer = String(Int(extraPointsMadeTeam2RangeSliderLowerValuePlayer)) + " & " + String(Int(extraPointsMadeTeam2RangeSliderUpperValuePlayer))
        case ("PLAYER TEAM: FIELD GOAL ATTEMPTS", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //fieldGoalAttemptsTeam1SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                fieldGoalAttemptsTeam1SliderValuePlayer = fieldGoalAttemptsTeam1ValuesPlayer.last!
            }
            fieldGoalAttemptsTeam1OperatorValuePlayer = selectedOperatorValuePlayer
            fieldGoalAttemptsTeam1OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = fieldGoalAttemptsTeam1SliderValuePlayer
            formOperatorValuePlayer = fieldGoalAttemptsTeam1OperatorValuePlayer
            formOperatorTextPlayer = fieldGoalAttemptsTeam1OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(fieldGoalAttemptsTeam1SliderValuePlayer))
            fieldGoalAttemptsTeam1SliderFormValuePlayer = String(Int(fieldGoalAttemptsTeam1SliderValuePlayer))
        case ("PLAYER TEAM: FIELD GOAL ATTEMPTS", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            fieldGoalAttemptsTeam1RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            fieldGoalAttemptsTeam1RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            fieldGoalAttemptsTeam1OperatorValuePlayer = "< >"
            fieldGoalAttemptsTeam1OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = fieldGoalAttemptsTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = fieldGoalAttemptsTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = fieldGoalAttemptsTeam1OperatorValuePlayer
            formOperatorTextPlayer = fieldGoalAttemptsTeam1OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            fieldGoalAttemptsTeam1SliderFormValuePlayer = String(Int(fieldGoalAttemptsTeam1RangeSliderLowerValuePlayer)) + " & " + String(Int(fieldGoalAttemptsTeam1RangeSliderUpperValuePlayer))
        case ("OPPONENT: FIELD GOAL ATTEMPTS", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //fieldGoalAttemptsTeam2SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                fieldGoalAttemptsTeam2SliderValuePlayer = fieldGoalAttemptsTeam2ValuesPlayer.last!
            }
            fieldGoalAttemptsTeam2OperatorValuePlayer = selectedOperatorValuePlayer
            fieldGoalAttemptsTeam2OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = fieldGoalAttemptsTeam2SliderValuePlayer
            formOperatorValuePlayer = fieldGoalAttemptsTeam2OperatorValuePlayer
            formOperatorTextPlayer = fieldGoalAttemptsTeam2OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(fieldGoalAttemptsTeam2SliderValuePlayer))
            fieldGoalAttemptsTeam2SliderFormValuePlayer = String(Int(fieldGoalAttemptsTeam2SliderValuePlayer))
        case ("OPPONENT: FIELD GOAL ATTEMPTS", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            fieldGoalAttemptsTeam2RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            fieldGoalAttemptsTeam2RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            fieldGoalAttemptsTeam2OperatorValuePlayer = "< >"
            fieldGoalAttemptsTeam2OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = fieldGoalAttemptsTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = fieldGoalAttemptsTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = fieldGoalAttemptsTeam2OperatorValuePlayer
            formOperatorTextPlayer = fieldGoalAttemptsTeam2OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            fieldGoalAttemptsTeam2SliderFormValuePlayer = String(Int(fieldGoalAttemptsTeam2RangeSliderLowerValuePlayer)) + " & " + String(Int(fieldGoalAttemptsTeam2RangeSliderUpperValuePlayer))
        case ("PLAYER TEAM: FIELD GOALS MADE", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //fieldGoalsMadeTeam1SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                fieldGoalsMadeTeam1SliderValuePlayer = fieldGoalsMadeTeam1ValuesPlayer.last!
            }
            fieldGoalsMadeTeam1OperatorValuePlayer = selectedOperatorValuePlayer
            fieldGoalsMadeTeam1OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = fieldGoalsMadeTeam1SliderValuePlayer
            formOperatorValuePlayer = fieldGoalsMadeTeam1OperatorValuePlayer
            formOperatorTextPlayer = fieldGoalsMadeTeam1OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(fieldGoalsMadeTeam1SliderValuePlayer))
            fieldGoalsMadeTeam1SliderFormValuePlayer = String(Int(fieldGoalsMadeTeam1SliderValuePlayer))
        case ("PLAYER TEAM: FIELD GOALS MADE", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            fieldGoalsMadeTeam1RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            fieldGoalsMadeTeam1RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            fieldGoalsMadeTeam1OperatorValuePlayer = "< >"
            fieldGoalsMadeTeam1OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = fieldGoalsMadeTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = fieldGoalsMadeTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = fieldGoalsMadeTeam1OperatorValuePlayer
            formOperatorTextPlayer = fieldGoalsMadeTeam1OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            fieldGoalsMadeTeam1SliderFormValuePlayer = String(Int(fieldGoalsMadeTeam1RangeSliderLowerValuePlayer)) + " & " + String(Int(fieldGoalsMadeTeam1RangeSliderUpperValuePlayer))
        case ("OPPONENT: FIELD GOALS MADE", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //fieldGoalsMadeTeam2SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                fieldGoalsMadeTeam2SliderValuePlayer = fieldGoalsMadeTeam2ValuesPlayer.last!
            }
            fieldGoalsMadeTeam2OperatorValuePlayer = selectedOperatorValuePlayer
            fieldGoalsMadeTeam2OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = fieldGoalsMadeTeam2SliderValuePlayer
            formOperatorValuePlayer = fieldGoalsMadeTeam2OperatorValuePlayer
            formOperatorTextPlayer = fieldGoalsMadeTeam2OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(fieldGoalsMadeTeam2SliderValuePlayer))
            fieldGoalsMadeTeam2SliderFormValuePlayer = String(Int(fieldGoalsMadeTeam2SliderValuePlayer))
        case ("OPPONENT: FIELD GOALS MADE", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            fieldGoalsMadeTeam2RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            fieldGoalsMadeTeam2RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            fieldGoalsMadeTeam2OperatorValuePlayer = "< >"
            fieldGoalsMadeTeam2OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = fieldGoalsMadeTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = fieldGoalsMadeTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = fieldGoalsMadeTeam2OperatorValuePlayer
            formOperatorTextPlayer = fieldGoalsMadeTeam2OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            fieldGoalsMadeTeam2SliderFormValuePlayer = String(Int(fieldGoalsMadeTeam2RangeSliderLowerValuePlayer)) + " & " + String(Int(fieldGoalsMadeTeam2RangeSliderUpperValuePlayer))
        case ("PLAYER TEAM: PUNTS", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //puntsTeam1SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                puntsTeam1SliderValuePlayer = puntsTeam1ValuesPlayer.last!
            }
            puntsTeam1OperatorValuePlayer = selectedOperatorValuePlayer
            puntsTeam1OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = puntsTeam1SliderValuePlayer
            formOperatorValuePlayer = puntsTeam1OperatorValuePlayer
            formOperatorTextPlayer = puntsTeam1OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(puntsTeam1SliderValuePlayer))
            puntsTeam1SliderFormValuePlayer = String(Int(puntsTeam1SliderValuePlayer))
        case ("PLAYER TEAM: PUNTS", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            puntsTeam1RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            puntsTeam1RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            puntsTeam1OperatorValuePlayer = "< >"
            puntsTeam1OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = puntsTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = puntsTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = puntsTeam1OperatorValuePlayer
            formOperatorTextPlayer = puntsTeam1OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            puntsTeam1SliderFormValuePlayer = String(Int(puntsTeam1RangeSliderLowerValuePlayer)) + " & " + String(Int(puntsTeam1RangeSliderUpperValuePlayer))
        case ("OPPONENT: PUNTS", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //puntsTeam2SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                puntsTeam2SliderValuePlayer = puntsTeam2ValuesPlayer.last!
            }
            puntsTeam2OperatorValuePlayer = selectedOperatorValuePlayer
            puntsTeam2OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = puntsTeam2SliderValuePlayer
            formOperatorValuePlayer = puntsTeam2OperatorValuePlayer
            formOperatorTextPlayer = puntsTeam2OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(puntsTeam2SliderValuePlayer))
            puntsTeam2SliderFormValuePlayer = String(Int(puntsTeam2SliderValuePlayer))
        case ("OPPONENT: PUNTS", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            puntsTeam2RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            puntsTeam2RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            puntsTeam2OperatorValuePlayer = "< >"
            puntsTeam2OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = puntsTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = puntsTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = puntsTeam2OperatorValuePlayer
            formOperatorTextPlayer = puntsTeam2OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            puntsTeam2SliderFormValuePlayer = String(Int(puntsTeam2RangeSliderLowerValuePlayer)) + " & " + String(Int(puntsTeam2RangeSliderUpperValuePlayer))
        case ("PLAYER TEAM: PUNT YARDS", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //puntYardsTeam1SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                puntYardsTeam1SliderValuePlayer = puntYardsTeam1ValuesPlayer.last!
            }
            puntYardsTeam1OperatorValuePlayer = selectedOperatorValuePlayer
            puntYardsTeam1OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = puntYardsTeam1SliderValuePlayer
            formOperatorValuePlayer = puntYardsTeam1OperatorValuePlayer
            formOperatorTextPlayer = puntYardsTeam1OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(puntYardsTeam1SliderValuePlayer))
            puntYardsTeam1SliderFormValuePlayer = String(Int(puntYardsTeam1SliderValuePlayer))
        case ("PLAYER TEAM: PUNT YARDS", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            puntYardsTeam1RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            puntYardsTeam1RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            puntYardsTeam1OperatorValuePlayer = "< >"
            puntYardsTeam1OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = puntYardsTeam1RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = puntYardsTeam1RangeSliderUpperValuePlayer
            formOperatorValuePlayer = puntYardsTeam1OperatorValuePlayer
            formOperatorTextPlayer = puntYardsTeam1OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            puntYardsTeam1SliderFormValuePlayer = String(Int(puntYardsTeam1RangeSliderLowerValuePlayer)) + " & " + String(Int(puntYardsTeam1RangeSliderUpperValuePlayer))
        case ("OPPONENT: PUNT YARDS", false):
            //operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            //puntYardsTeam2SliderValuePlayer = rowValue
            if formSliderValuePlayer == Float(-10000) {
                puntYardsTeam2SliderValuePlayer = puntYardsTeam2ValuesPlayer.last!
            }
            puntYardsTeam2OperatorValuePlayer = selectedOperatorValuePlayer
            puntYardsTeam2OperatorTextPlayer = operatorTextPlayer
            formSliderValuePlayer = puntYardsTeam2SliderValuePlayer
            formOperatorValuePlayer = puntYardsTeam2OperatorValuePlayer
            formOperatorTextPlayer = puntYardsTeam2OperatorTextPlayer
            buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formSliderValuePlayer))
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(puntYardsTeam2SliderValuePlayer))
            puntYardsTeam2SliderFormValuePlayer = String(Int(puntYardsTeam2SliderValuePlayer))
        case ("OPPONENT: PUNT YARDS", true):
            operatorTextPlayer = operatorDictionaryPlayer["< >"]!
            puntYardsTeam2RangeSliderLowerValuePlayer = Float(playerRangeSliderObject.lowerValue)
            puntYardsTeam2RangeSliderUpperValuePlayer = Float(playerRangeSliderObject.upperValue)
            puntYardsTeam2OperatorValuePlayer = "< >"
            puntYardsTeam2OperatorTextPlayer = operatorTextPlayer
            formRangeSliderLowerValuePlayer = puntYardsTeam2RangeSliderLowerValuePlayer
            formRangeSliderUpperValuePlayer = puntYardsTeam2RangeSliderUpperValuePlayer
            formOperatorValuePlayer = puntYardsTeam2OperatorValuePlayer
            formOperatorTextPlayer = puntYardsTeam2OperatorTextPlayer
            if (formRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && formRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
            } else {
                buttonText = headerLabel + "\0" + formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            }
            let nullCharIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:nullCharIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length:nullCharIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            sliderValuePlayer = formOperatorTextPlayer + String(Int(formRangeSliderLowerValuePlayer)) + " & " + String(Int(formRangeSliderUpperValuePlayer))
            puntYardsTeam2SliderFormValuePlayer = String(Int(puntYardsTeam2RangeSliderLowerValuePlayer)) + " & " + String(Int(puntYardsTeam2RangeSliderUpperValuePlayer))
        default:
            return
        }
        
        if (playerRangeSliderObject.lowerValue == playerRangeSliderObject.minimumValue && playerRangeSliderObject.upperValue == playerRangeSliderObject.maximumValue && selectedOperatorValuePlayer == "< >") ||
            (playerRangeSliderObject.lowerValue == playerRangeSliderObject.minimumValue && playerRangeSliderObject.upperValue == playerRangeSliderObject.maximumValue && selectedOperatorValuePlayer == "-10000") {
            buttonText = self.headerLabel + "\0" + operatorDictionaryPlayer["-10000"]! + "ANY"
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playerSliderNotification"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func labelTapped() {
        //print("labelTapped()")
        switch(tagTextPlayer) {
        case "PLAYER TEAM: STREAK":
            if winningLosingStreakTeam1SliderFormValuePlayer == "-10000" || (winningLosingStreakTeam1OperatorValuePlayer == "< >" && winningLosingStreakTeam1RangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && winningLosingStreakTeam1RangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + winningLosingStreakTeam1OperatorValuePlayer
                self.titleString = winningLosingStreakTeam1SliderFormValuePlayer
            }
        case "OPPONENT: STREAK":
            if winningLosingStreakTeam2SliderFormValuePlayer == "-10000" || (winningLosingStreakTeam2OperatorValuePlayer == "< >" && winningLosingStreakTeam2RangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && winningLosingStreakTeam2RangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + winningLosingStreakTeam2OperatorValuePlayer
                self.titleString = winningLosingStreakTeam2SliderFormValuePlayer
            }
        case "PLAYER TEAM: SEASON WIN %":
            if seasonWinPercentageTeam1SliderFormValuePlayer == "-10000" || (seasonWinPercentageTeam1OperatorValuePlayer == "< >" && seasonWinPercentageTeam1RangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && seasonWinPercentageTeam1RangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + seasonWinPercentageTeam1OperatorValuePlayer
                self.titleString = seasonWinPercentageTeam1SliderFormValuePlayer
            }
        case "OPPONENT: SEASON WIN %":
            if seasonWinPercentageTeam2SliderFormValuePlayer == "-10000" || (seasonWinPercentageTeam2OperatorValuePlayer == "< >" && seasonWinPercentageTeam2RangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && seasonWinPercentageTeam2RangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + seasonWinPercentageTeam2OperatorValuePlayer
                self.titleString = seasonWinPercentageTeam2SliderFormValuePlayer
            }
        case "SEASON":
            if seasonSliderFormValuePlayer == "-10000" || (seasonOperatorValuePlayer == "< >" && seasonRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && seasonRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + seasonOperatorValuePlayer
                self.titleString = seasonSliderFormValuePlayer
            }
        case "GAME NUMBER":
            if gameNumberSliderFormValuePlayer == "-10000" || (gameNumberOperatorValuePlayer == "< >" && gameNumberRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && gameNumberRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + gameNumberOperatorValuePlayer
                self.titleString = gameNumberSliderFormValuePlayer
            }
        case "WEEK":
             if weekSliderFormValuePlayer == "-10000" || (weekOperatorValuePlayer == "< >" && weekRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && weekRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + weekOperatorValuePlayer
                self.titleString = weekSliderFormValuePlayer
            }
        case "PLAYER TEAM: SPREAD":
            //if spreadSliderFormValuePlayer == "-10000" || (spreadOperatorValuePlayer == "< >" && spreadRangeSliderLowerValuePlayer == Float(-30.0) && spreadRangeSliderUpperValuePlayer == Float(30.0)) {
            if spreadSliderFormValuePlayer == "-10000" || (spreadOperatorValuePlayer == "< >" && spreadRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && spreadRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + spreadOperatorValuePlayer
                self.titleString = spreadSliderFormValuePlayer
            }
        case "OVER/UNDER":
            if overUnderSliderFormValuePlayer == "-10000" || (overUnderOperatorValuePlayer == "< >" && overUnderRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && overUnderRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + overUnderOperatorValuePlayer
                self.titleString = overUnderSliderFormValuePlayer
            }
        case "TEMPERATURE (F)":
             if temperatureSliderFormValuePlayer == "-10000" || (temperatureOperatorValuePlayer == "< >" && temperatureRangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && temperatureRangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + temperatureOperatorValuePlayer
                self.titleString = temperatureSliderFormValuePlayer + "°"
            }
        case "PLAYER TEAM: TOTAL POINTS":
             if totalPointsTeam1SliderFormValuePlayer == "-10000" || (totalPointsTeam1OperatorValuePlayer == "< >" && totalPointsTeam1RangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && totalPointsTeam1RangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + totalPointsTeam1OperatorValuePlayer
                self.titleString = totalPointsTeam1SliderFormValuePlayer
            }
        case "OPPONENT: TOTAL POINTS":
            if totalPointsTeam2SliderFormValuePlayer == "-10000" || (totalPointsTeam2OperatorValuePlayer == "< >" && totalPointsTeam2RangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) && totalPointsTeam2RangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + totalPointsTeam2OperatorValuePlayer
                self.titleString = totalPointsTeam2SliderFormValuePlayer
            }
        case "PLAYER TEAM: TOUCHDOWNS":
             if touchdownsTeam1SliderFormValuePlayer == "-10000" || (touchdownsTeam1OperatorValuePlayer == "< >" &&
                touchdownsTeam1RangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) &&
                touchdownsTeam1RangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + touchdownsTeam1OperatorValuePlayer
                self.titleString = touchdownsTeam1SliderFormValuePlayer
            }
        case "OPPONENT: TOUCHDOWNS":
            if touchdownsTeam2SliderFormValuePlayer == "-10000" || (touchdownsTeam2OperatorValuePlayer == "< >" &&
                touchdownsTeam2RangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) &&
                touchdownsTeam2RangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + touchdownsTeam2OperatorValuePlayer
                self.titleString = touchdownsTeam2SliderFormValuePlayer
            }
        
        case "PLAYER TEAM: OFFENSIVE TOUCHDOWNS":
            if offensiveTouchdownsTeam1SliderFormValuePlayer == "-10000" || (offensiveTouchdownsTeam1OperatorValuePlayer == "< >" &&
                offensiveTouchdownsTeam1RangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) &&
                offensiveTouchdownsTeam1RangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + offensiveTouchdownsTeam1OperatorValuePlayer
                self.titleString = offensiveTouchdownsTeam1SliderFormValuePlayer
            }
        case "OPPONENT: OFFENSIVE TOUCHDOWNS":
            if offensiveTouchdownsTeam2SliderFormValuePlayer == "-10000" || (offensiveTouchdownsTeam2OperatorValuePlayer == "< >" &&
                offensiveTouchdownsTeam2RangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) &&
                offensiveTouchdownsTeam2RangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + offensiveTouchdownsTeam2OperatorValuePlayer
                self.titleString = offensiveTouchdownsTeam2SliderFormValuePlayer
            }
        case "PLAYER TEAM: DEFENSIVE TOUCHDOWNS":
            if defensiveTouchdownsTeam1SliderFormValuePlayer == "-10000" || (defensiveTouchdownsTeam1OperatorValuePlayer == "< >" &&
                defensiveTouchdownsTeam1RangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) &&
                defensiveTouchdownsTeam1RangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + defensiveTouchdownsTeam1OperatorValuePlayer
                self.titleString = defensiveTouchdownsTeam1SliderFormValuePlayer
            }
        case "OPPONENT: DEFENSIVE TOUCHDOWNS":
            if defensiveTouchdownsTeam2SliderFormValuePlayer == "-10000" || (defensiveTouchdownsTeam2OperatorValuePlayer == "< >" &&
                defensiveTouchdownsTeam2RangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) &&
                defensiveTouchdownsTeam2RangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + defensiveTouchdownsTeam2OperatorValuePlayer
                self.titleString = defensiveTouchdownsTeam2SliderFormValuePlayer
            }
            
        case "PLAYER TEAM: TURNOVERS":
            if turnoversCommittedTeam1SliderFormValuePlayer == "-10000" || (turnoversCommittedTeam1OperatorValuePlayer == "< >" &&
                turnoversCommittedTeam1RangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) &&
                turnoversCommittedTeam1RangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + turnoversCommittedTeam1OperatorValuePlayer
                self.titleString = turnoversCommittedTeam1SliderFormValuePlayer
            }
        case "OPPONENT: TURNOVERS":
            if turnoversCommittedTeam2SliderFormValuePlayer == "-10000" || (turnoversCommittedTeam2OperatorValuePlayer == "< >" &&
                turnoversCommittedTeam2RangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) &&
                turnoversCommittedTeam2RangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + turnoversCommittedTeam2OperatorValuePlayer
                self.titleString = turnoversCommittedTeam2SliderFormValuePlayer
            }
        case "PLAYER TEAM: PENALTIES":
            if penaltiesCommittedTeam1SliderFormValuePlayer == "-10000" || (penaltiesCommittedTeam1OperatorValuePlayer == "< >" &&
                penaltiesCommittedTeam1RangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) &&
                penaltiesCommittedTeam1RangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + penaltiesCommittedTeam1OperatorValuePlayer
                self.titleString = penaltiesCommittedTeam1SliderFormValuePlayer
            }
        case "OPPONENT: PENALTIES":
            if penaltiesCommittedTeam2SliderFormValuePlayer == "-10000" || (penaltiesCommittedTeam2OperatorValuePlayer == "< >" &&
                penaltiesCommittedTeam2RangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) &&
                penaltiesCommittedTeam2RangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + penaltiesCommittedTeam2OperatorValuePlayer
                self.titleString = penaltiesCommittedTeam2SliderFormValuePlayer
            }
        case "PLAYER TEAM: TOTAL YARDS":
            if totalYardsTeam1SliderFormValuePlayer == "-10000" || (totalYardsTeam1OperatorValuePlayer == "< >" &&
                totalYardsTeam1RangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) &&
                totalYardsTeam1RangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + totalYardsTeam1OperatorValuePlayer
                self.titleString = totalYardsTeam1SliderFormValuePlayer
            }
        case "OPPONENT: TOTAL YARDS":
            if totalYardsTeam2SliderFormValuePlayer == "-10000" || (totalYardsTeam2OperatorValuePlayer == "< >" &&
                totalYardsTeam2RangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) &&
                totalYardsTeam2RangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + totalYardsTeam2OperatorValuePlayer
                self.titleString = totalYardsTeam2SliderFormValuePlayer
            }
        case "PLAYER TEAM: PASSING YARDS":
            if passingYardsTeam1SliderFormValuePlayer == "-10000" || (passingYardsTeam1OperatorValuePlayer == "< >" &&
                passingYardsTeam1RangeSliderLowerValuePlayer == Float(playerRangeSliderObject.minimumValue) &&
                passingYardsTeam1RangeSliderUpperValuePlayer == Float(playerRangeSliderObject.maximumValue)) {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + passingYardsTeam1OperatorValuePlayer
                self.titleString = passingYardsTeam1SliderFormValuePlayer
            }
        case "OPPONENT: PASSING YARDS":
            if passingYardsTeam2SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + passingYardsTeam2OperatorValuePlayer
                self.titleString = passingYardsTeam2SliderFormValuePlayer
            }
        case "PLAYER TEAM: RUSHING YARDS":
            if rushingYardsTeam1SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + rushingYardsTeam1OperatorValuePlayer
                self.titleString = rushingYardsTeam1SliderFormValuePlayer
            }
        case "OPPONENT: RUSHING YARDS":
            if rushingYardsTeam2SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + rushingYardsTeam2OperatorValuePlayer
                self.titleString = rushingYardsTeam2SliderFormValuePlayer
            }
        case "PLAYER TEAM: QUARTERBACK RATING":
            if quarterbackRatingTeam1SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + quarterbackRatingTeam1OperatorValuePlayer
                self.titleString = quarterbackRatingTeam1SliderFormValuePlayer
            }
        case "OPPONENT: QUARTERBACK RATING":
            if quarterbackRatingTeam2SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + quarterbackRatingTeam2OperatorValuePlayer
                self.titleString = quarterbackRatingTeam2SliderFormValuePlayer
            }
        case "PLAYER TEAM: TIMES SACKED":
            if timesSackedTeam1SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + timesSackedTeam1OperatorValuePlayer
                self.titleString = timesSackedTeam1SliderFormValuePlayer
            }
        case "OPPONENT: TIMES SACKED":
            if timesSackedTeam2SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + timesSackedTeam2OperatorValuePlayer
                self.titleString = timesSackedTeam2SliderFormValuePlayer
            }
        case "PLAYER TEAM: INTERCEPTIONS THROWN":
            if interceptionsThrownTeam1SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + interceptionsThrownTeam1OperatorValuePlayer
                self.titleString = interceptionsThrownTeam1SliderFormValuePlayer
            }
        case "OPPONENT: INTERCEPTIONS THROWN":
            if interceptionsThrownTeam2SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + interceptionsThrownTeam2OperatorValuePlayer
                self.titleString = interceptionsThrownTeam2SliderFormValuePlayer
            }
        case "PLAYER TEAM: OFFENSIVE PLAYS":
            if offensivePlaysTeam1SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + offensivePlaysTeam1OperatorValuePlayer
                self.titleString = offensivePlaysTeam1SliderFormValuePlayer
            }
        case "OPPONENT: OFFENSIVE PLAYS":
            if offensivePlaysTeam2SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + offensivePlaysTeam2OperatorValuePlayer
                self.titleString = offensivePlaysTeam2SliderFormValuePlayer
            }
        case "PLAYER TEAM: YARDS/OFFENSIVE PLAY":
            if yardsPerOffensivePlayTeam1SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + yardsPerOffensivePlayTeam1OperatorValuePlayer
                self.titleString = yardsPerOffensivePlayTeam1SliderFormValuePlayer
            }
        case "OPPONENT: YARDS/OFFENSIVE PLAY":
            if yardsPerOffensivePlayTeam2SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + yardsPerOffensivePlayTeam2OperatorValuePlayer
                self.titleString = yardsPerOffensivePlayTeam2SliderFormValuePlayer
            }
        case "PLAYER TEAM: SACKS":
            if sacksTeam1SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + sacksTeam1OperatorValuePlayer
                self.titleString = sacksTeam1SliderFormValuePlayer
            }
        case "OPPONENT: SACKS":
            if sacksTeam2SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + sacksTeam2OperatorValuePlayer
                self.titleString = sacksTeam2SliderFormValuePlayer
            }
        case "PLAYER TEAM: INTERCEPTIONS":
            if interceptionsTeam1SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + interceptionsTeam1OperatorValuePlayer
                self.titleString = interceptionsTeam1SliderFormValuePlayer
            }
        case "OPPONENT: INTERCEPTIONS":
            if interceptionsTeam2SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + interceptionsTeam2OperatorValuePlayer
                self.titleString = interceptionsTeam2SliderFormValuePlayer
            }
        case "PLAYER TEAM: SAFETIES":
            if safetiesTeam1SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + safetiesTeam1OperatorValuePlayer
                self.titleString = safetiesTeam1SliderFormValuePlayer
            }
        case "OPPONENT: SAFETIES":
            if safetiesTeam2SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + safetiesTeam2OperatorValuePlayer
                self.titleString = safetiesTeam2SliderFormValuePlayer
            }
        case "PLAYER TEAM: DEFENSIVE PLAYS":
            if defensivePlaysTeam1SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + defensivePlaysTeam1OperatorValuePlayer
                self.titleString = defensivePlaysTeam1SliderFormValuePlayer
            }
        case "OPPONENT: DEFENSIVE PLAYS":
            if defensivePlaysTeam2SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + defensivePlaysTeam2OperatorValuePlayer
                self.titleString = defensivePlaysTeam2SliderFormValuePlayer
            }
        case "PLAYER TEAM: YARDS/DEFENSIVE PLAY":
            if yardsPerDefensivePlayTeam1SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + yardsPerDefensivePlayTeam1OperatorValuePlayer
                self.titleString = yardsPerDefensivePlayTeam1SliderFormValuePlayer
            }
        case "OPPONENT: YARDS/DEFENSIVE PLAY":
            if yardsPerDefensivePlayTeam2SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + yardsPerDefensivePlayTeam2OperatorValuePlayer
                self.titleString = yardsPerDefensivePlayTeam2SliderFormValuePlayer
            }
        case "PLAYER TEAM: EXTRA POINT ATTEMPTS":
            if extraPointAttemptsTeam1SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + extraPointAttemptsTeam1OperatorValuePlayer
                self.titleString = extraPointAttemptsTeam1SliderFormValuePlayer
            }
        case "OPPONENT: EXTRA POINT ATTEMPTS":
            if extraPointAttemptsTeam2SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + extraPointAttemptsTeam2OperatorValuePlayer
                self.titleString = extraPointAttemptsTeam2SliderFormValuePlayer
            }
        case "PLAYER TEAM: EXTRA POINTS MADE":
            if extraPointsMadeTeam1SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + extraPointsMadeTeam1OperatorValuePlayer
                self.titleString = extraPointsMadeTeam1SliderFormValuePlayer
            }
        case "OPPONENT: EXTRA POINTS MADE":
            if extraPointsMadeTeam2SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + extraPointsMadeTeam2OperatorValuePlayer
                self.titleString = extraPointsMadeTeam2SliderFormValuePlayer
            }
        case "PLAYER TEAM: FIELD GOAL ATTEMPTS":
            if fieldGoalAttemptsTeam1SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + fieldGoalAttemptsTeam1OperatorValuePlayer
                self.titleString = fieldGoalAttemptsTeam1SliderFormValuePlayer
            }
        case "OPPONENT: FIELD GOAL ATTEMPTS":
            if fieldGoalAttemptsTeam2SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + fieldGoalAttemptsTeam2OperatorValuePlayer
                self.titleString = fieldGoalAttemptsTeam2SliderFormValuePlayer
            }
        case "PLAYER TEAM: FIELD GOALS MADE":
            if fieldGoalsMadeTeam1SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + fieldGoalsMadeTeam1OperatorValuePlayer
                self.titleString = fieldGoalsMadeTeam1SliderFormValuePlayer
            }
        case "OPPONENT: FIELD GOALS MADE":
            if fieldGoalsMadeTeam2SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + fieldGoalsMadeTeam2OperatorValuePlayer
                self.titleString = fieldGoalsMadeTeam2SliderFormValuePlayer
            }
        case "PLAYER TEAM: PUNTS":
            if puntsTeam1SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + puntsTeam1OperatorValuePlayer
                self.titleString = puntsTeam1SliderFormValuePlayer
            }
        case "OPPONENT: PUNTS":
            if puntsTeam2SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + puntsTeam2OperatorValuePlayer
                self.titleString = puntsTeam2SliderFormValuePlayer
            }
        case "PLAYER TEAM: PUNT YARDS":
            if puntYardsTeam1SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + puntYardsTeam1OperatorValuePlayer
                self.titleString = puntYardsTeam1SliderFormValuePlayer
            }
        case "OPPONENT: PUNT YARDS":
            if puntYardsTeam2SliderFormValuePlayer == "-10000" {
                self.alertController.title = tagTextPlayer + " ="
                self.titleString = "ANY"
            } else {
                self.alertController.title = tagTextPlayer + " " + puntYardsTeam2OperatorValuePlayer
                self.titleString = puntYardsTeam2SliderFormValuePlayer
            }
        default:
                self.titleString = "ANY"
                self.alertController.title = tagTextPlayer + " " + "="
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
        clearSliderIndicatorPlayer = tagTextPlayer
        print("clearSliderIndicatorPlayer: \(clearSliderIndicatorPlayer)")
        //let sliderRow: SliderRow! = self.form.rowBy(tag: "SLIDER")
        let segmentedRow: SegmentedRow<String>! = self.form.rowBy(tag: "OPERATOR")
        print("segmentedRow.value: ")
        print(segmentedRow.value!)
        if segmentedRow.value == "< >" {
            //sliderRow.value! = self.sliderValuesPlayer.last!
            rangeSliderActivated()
        } else {
            segmentedRow.value! = "< >"
            segmentedRow.reload()
            //rangeSliderActivated()
            
            //sliderRow.value! = self.sliderValuesPlayer.last!
            //This will reset the single value slider to the maximum value
            //Decided not to implement due to increased query time
            //self.tableView.reloadData()
        }
        clearSliderIndicatorPlayer = ""
        print("clearSliderIndicatorPlayer: \(clearSliderIndicatorPlayer)")
        print("-------clearSliderSelections() FINISHED-------")
    }
}
