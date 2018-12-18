//
//  PlayerDashboardViewController.swift
//  TrendPlay
//
//  Created by Chelsea Smith on 1/31/17.
//  Copyright © 2017 Trending Productions LLC. All rights reserved.
//

import UIKit
//import Eureka
import MaterialComponents
import Foundation
import FMDB


extension Formatter {
    static let withSeparator_: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension BinaryInteger {
    var formattedWithSeparator_: String {
        return Formatter.withSeparator_.string(for: self) ?? ""
    }
}

class PlayerDashboardViewController: UIViewController {
    
    @IBOutlet var playerDashboardView: ShadowedView!
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var opponentLabel: UILabel!
    @IBOutlet weak var receivingCard: MDCCard!
    @IBOutlet weak var winPercentView: CircularProgress!
    @IBOutlet weak var winRateLabel: UILabel!
    @IBOutlet weak var winRateValue: UILabel!
    @IBOutlet weak var gamesSampledValue: UILabel!
    @IBOutlet weak var gameStartsValue: UILabel!
    @IBOutlet weak var playerBioCard: MDCCard!
    @IBOutlet weak var recordValue: UILabel!
    @IBOutlet weak var ATSValue: UILabel!

    //@IBOutlet weak var statsTabBar: MDCTabBar!
    @IBOutlet weak var uniformNumberValue: UILabel!
    @IBOutlet weak var positionValue: UILabel!
    @IBOutlet weak var weightValue: UILabel!
    @IBOutlet weak var heightValue: UILabel!
    @IBOutlet weak var teamValue: UILabel!
    @IBOutlet weak var byeWeekValue: UILabel!
    @IBOutlet weak var ageValue: UILabel!
    @IBOutlet weak var experienceValue: UILabel!
    @IBOutlet weak var statToggle: BetterSegmentedControl!
    @IBOutlet weak var calcToggle: BetterSegmentedControl!
    @IBOutlet weak var gameStatsCard: MDCCard!
    @IBOutlet weak var passingCard: MDCCard!
    @IBOutlet weak var rushingCard: MDCCard!
    // GAME STATS //
    @IBOutlet weak var touchdownValue: UILabel!
    @IBOutlet weak var twoPCValue: UILabel!
    @IBOutlet weak var fumbleValue: UILabel!
    //@IBOutlet weak var fumbleRecoveryValue: UILabel!
    @IBOutlet weak var fantasySTDValue: UILabel!
    @IBOutlet weak var fantasyPPRValue: UILabel!
    @IBOutlet weak var fantasyDKValue: UILabel!
    @IBOutlet weak var fantasyFDValue: UILabel!
    // PASSING STATS //
    @IBOutlet weak var passCompletionsValue: UILabel!
    //@IBOutlet weak var PassesAttemptedValue: UILabel!
    @IBOutlet weak var passPercentageValue: UILabel!
    @IBOutlet weak var passingYardsValue: UILabel!
    @IBOutlet weak var passingYardsAverageValue: UILabel!
    @IBOutlet weak var passing300Value: UILabel!
    @IBOutlet weak var passingTouchdownsValue: UILabel!
    @IBOutlet weak var passesInterceptedValue: UILabel!
    @IBOutlet weak var timesSackedValue: UILabel!
    @IBOutlet weak var sackYardsValue: UILabel!
    @IBOutlet weak var QBRatingValue: UILabel!
    // RUSHING STATS //
    @IBOutlet weak var rushAttemptsValue: UILabel!
    @IBOutlet weak var rushingYardsValue: UILabel!
    @IBOutlet weak var rushingYardsAverageValue: UILabel!
    @IBOutlet weak var rushing300Value: UILabel!
    @IBOutlet weak var rushingTouchdownsValue: UILabel!
    // RECEIVING STATS //
    @IBOutlet weak var receptionsValue: UILabel!
    @IBOutlet weak var targetsValue: UILabel!
    @IBOutlet weak var catchPercentageValue: UILabel!
    @IBOutlet weak var receivingTouchdownsValue: UILabel!
    @IBOutlet weak var receivingYardsAverageValue: UILabel!
    @IBOutlet weak var receivingYardsValue: UILabel!
    @IBOutlet weak var receiving300Value: UILabel!
    var messageString: String = ""
    var titleString: String = ""
    var alertController = MDCAlertController()
    var raisedButton = MDCRaisedButton()
    let numberFormatter = NumberFormatter()
    public let playerDashboardNotification = Notification.Name("NotificationIdentifier")
    var errorIndicator: String = ""

    var queryWinsTeam1: String = ""
    var queryLossesTeam1: String = ""
    var queryTiesTeam1: String = ""
    var playerLabelText: String = "PLAYER"
    var opponentLabelText: String = "OPPONENT"
    var winRateLabelText: String = ""
    var gamesSampledLabelText: String = ""
    var gameStartsLabelText: String = ""
    var recordLabelText: String = ""
    var ATSLabelText: String = ""
    var queryNotCoveredTeam1: String = ""
    var queryCoveredTeam1: String = ""
    var queryPushTeam1: String = ""
    var queryGameStarts: String = ""
    
    let queryColumnTeam1: String = "teamNameToday"
    let queryColumnTeam2: String = "opponentNameToday"
    let queryColumnSpreadTeam1: String = "spread"
    let queryColumnOverUnder: String = "overUnder"
    let queryColumnWinningLosingStreakTeam1: String = "streakValueTeam"
    let queryColumnWinningLosingStreakTeam2: String = "streakValueOpponent"
    let queryColumnSeasonWinPercentageTeam1: String = "seasonWinPercentageTeam"
    let queryColumnSeasonWinPercentageTeam2: String = "seasonWinPercentageOpponent"
    let queryColumnHomeTeam: String = "homeTeam"
    let queryColumnFavorite: String = "favorite"
    let queryColumnPlayer: String = "playerID"
    let queryColumnPlayersTeam1: String = "playerID"
    let queryColumnPlayersTeam2: String = "playerID"
    let queryColumnSeason: String = "season"
    let queryColumnWeek: String = "weekNumber"
    let queryColumnGameNumber: String = "gameNumber"
    let queryColumnDay: String = "day"
    let queryColumnStadium: String = "roofType"
    let queryColumnSurface: String = "surfaceType"
    let queryColumnTemperature: String = "temperature"
    let queryColumnTotalPointsTeam1: String = "pointsTeam"
    let queryColumnTotalPointsTeam2: String = "pointsOpponent"
    let queryColumnTouchdownsTeam1: String = "touchdownsTeam"
    let queryColumnTouchdownsTeam2: String = "touchdownsOpponent"
    let queryColumnTurnoversCommittedTeam1: String = "turnoversTeam"
    let queryColumnTurnoversCommittedTeam2: String = "turnoversOpponent"
    let queryColumnPenaltiesCommittedTeam1: String = "penaltiesTeam"
    let queryColumnPenaltiesCommittedTeam2: String = "penaltiesOpponent"
    let queryColumnTotalYardsTeam1: String = "totalYardsTeam"
    let queryColumnTotalYardsTeam2: String = "totalYardsOpponent"
    let queryColumnPassingYardsTeam1: String = "passingYardsTeam"
    let queryColumnPassingYardsTeam2: String = "passingYardsOpponent"
    let queryColumnRushingYardsTeam1: String = "rushingYardsTeam"
    let queryColumnRushingYardsTeam2: String = "rushingYardsOpponent"
    let queryColumnQuarterbackRatingTeam1: String = "quarterbackRatingTeam"
    let queryColumnQuarterbackRatingTeam2: String = "quarterbackRatingOpponent"
    let queryColumnTimesSackedTeam1: String = "timesSackedTeam"
    let queryColumnTimesSackedTeam2: String = "timesSackedOpponent"
    let queryColumnInterceptionsThrownTeam1: String = "interceptionsThrownTeam"
    let queryColumnInterceptionsThrownTeam2: String = "interceptionsThrownOpponent"
    let queryColumnOffensivePlaysTeam1: String = "offensivePlaysTeam"
    let queryColumnOffensivePlaysTeam2: String = "offensivePlaysOpponent"
    let queryColumnYardsPerOffensivePlayTeam1: String = "yardsPerOffensivePlayTeam"
    let queryColumnYardsPerOffensivePlayTeam2: String = "yardsPerOffensivePlayOpponent"
    let queryColumnSacksTeam1: String = "timesSackedOpponent"
    let queryColumnSacksTeam2: String = "timesSackedTeam"
    let queryColumnInterceptionsTeam1: String = "interceptionsThrownOpponent"
    let queryColumnInterceptionsTeam2: String = "interceptionsThrownTeam"
    let queryColumnSafetiesTeam1: String = "safetiesTeam"
    let queryColumnSafetiesTeam2: String = "safetiesOpponent"
    let queryColumnDefensivePlaysTeam1: String = "offensivePlaysOpponent"
    let queryColumnDefensivePlaysTeam2: String = "offensivePlaysTeam"
    let queryColumnYardsPerDefensivePlayTeam1: String = "yardsPerOffensivePlayOpponent"
    let queryColumnYardsPerDefensivePlayTeam2: String = "yardsPerOffensivePlayTeam"
    let queryColumnExtraPointAttemptsTeam1: String = "extraPointAttemptsTeam"
    let queryColumnExtraPointAttemptsTeam2: String = "extraPointAttemptsOpponent"
    let queryColumnExtraPointsMadeTeam1: String = "extraPointsMadeTeam"
    let queryColumnExtraPointsMadeTeam2: String = "extraPointsMadeOpponent"
    let queryColumnFieldGoalAttemptsTeam1: String = "fieldGoalAttemptsTeam"
    let queryColumnFieldGoalAttemptsTeam2: String = "fieldGoalAttemptsOpponent"
    let queryColumnFieldGoalsMadeTeam1: String = "fieldGoalsMadeTeam"
    let queryColumnFieldGoalsMadeTeam2: String = "fieldGoalsMadeOpponent"
    let queryColumnPuntsTeam1: String = "puntsTeam"
    let queryColumnPuntsTeam2: String = "puntsOpponent"
    let queryColumnPuntYardsTeam1: String = "puntYardsTeam"
    let queryColumnPuntYardsTeam2: String = "puntYardsOpponent"
    var queryOperatorTeam1: String = ""
    var queryOperatorTeam2: String = ""
    var queryOperatorSpreadTeam1: String = ""
    var queryOperatorOverUnder: String = ""
    var queryOperatorWinningLosingStreakTeam1: String = ""
    var queryOperatorWinningLosingStreakTeam2: String = ""
    var queryOperatorSeasonWinPercentageTeam1: String = ""
    var queryOperatorSeasonWinPercentageTeam2: String = ""
    var queryOperatorHomeTeam: String = ""
    var queryOperatorFavorite: String = ""
    var queryOperatorPlayer: String = ""
    var queryOperatorPlayersTeam1: String = ""
    var queryOperatorPlayersTeam2: String = ""
    var queryOperatorSeason: String = ""
    var queryOperatorWeek: String = ""
    var queryOperatorGameNumber: String = ""
    var queryOperatorDay: String = ""
    var queryOperatorStadium: String = ""
    var queryOperatorSurface: String = ""
    var queryOperatorTemperature: String = ""
    var queryOperatorTotalPointsTeam1: String = ""
    var queryOperatorTotalPointsTeam2: String = ""
    var queryOperatorTouchdownsTeam1: String = ""
    var queryOperatorTouchdownsTeam2: String = ""
    var queryOperatorTurnoversCommittedTeam1: String = ""
    var queryOperatorTurnoversCommittedTeam2: String = ""
    var queryOperatorPenaltiesCommittedTeam1: String = ""
    var queryOperatorPenaltiesCommittedTeam2: String = ""
    var queryOperatorTotalYardsTeam1: String = ""
    var queryOperatorTotalYardsTeam2: String = ""
    var queryOperatorPassingYardsTeam1: String = ""
    var queryOperatorPassingYardsTeam2: String = ""
    var queryOperatorRushingYardsTeam1: String = ""
    var queryOperatorRushingYardsTeam2: String = ""
    var queryOperatorQuarterbackRatingTeam1: String = ""
    var queryOperatorQuarterbackRatingTeam2: String = ""
    var queryOperatorTimesSackedTeam1: String = ""
    var queryOperatorTimesSackedTeam2: String = ""
    var queryOperatorInterceptionsThrownTeam1: String = ""
    var queryOperatorInterceptionsThrownTeam2: String = ""
    var queryOperatorOffensivePlaysTeam1: String = ""
    var queryOperatorOffensivePlaysTeam2: String = ""
    var queryOperatorYardsPerOffensivePlayTeam1: String = ""
    var queryOperatorYardsPerOffensivePlayTeam2: String = ""
    var queryOperatorSacksTeam1: String = ""
    var queryOperatorSacksTeam2: String = ""
    var queryOperatorInterceptionsTeam1: String = ""
    var queryOperatorInterceptionsTeam2: String = ""
    var queryOperatorSafetiesTeam1: String = ""
    var queryOperatorSafetiesTeam2: String = ""
    var queryOperatorDefensivePlaysTeam1: String = ""
    var queryOperatorDefensivePlaysTeam2: String = ""
    var queryOperatorYardsPerDefensivePlayTeam1: String = ""
    var queryOperatorYardsPerDefensivePlayTeam2: String = ""
    var queryOperatorExtraPointAttemptsTeam1: String = ""
    var queryOperatorExtraPointAttemptsTeam2: String = ""
    var queryOperatorExtraPointsMadeTeam1: String = ""
    var queryOperatorExtraPointsMadeTeam2: String = ""
    var queryOperatorFieldGoalAttemptsTeam1: String = ""
    var queryOperatorFieldGoalAttemptsTeam2: String = ""
    var queryOperatorFieldGoalsMadeTeam1: String = ""
    var queryOperatorFieldGoalsMadeTeam2: String = ""
    var queryOperatorPuntsTeam1: String = ""
    var queryOperatorPuntsTeam2: String = ""
    var queryOperatorPuntYardsTeam1: String = ""
    var queryOperatorPuntYardsTeam2: String = ""
    var queryValueTeam1: String = ""
    var queryValueTeam2: String = ""
    var queryValueSpreadTeam1: String = ""
    var queryValueOverUnder: String = ""
    var queryValueWinningLosingStreakTeam1: String = ""
    var queryValueWinningLosingStreakTeam2: String = ""
    var queryValueSeasonWinPercentageTeam1: String = ""
    var queryValueSeasonWinPercentageTeam2: String = ""
    var queryValueHomeTeam: String = ""
    var queryValueFavorite: String = ""
    var queryValuePlayer: String = ""
    var queryValuePlayersTeam1: String = ""
    var queryValuePlayersTeam2: String = ""
    var queryValueSeason: String = ""
    var queryValueWeek: String = ""
    var queryValueGameNumber: String = ""
    var queryValueDay: String = ""
    var queryValueStadium: String = ""
    var queryValueSurface: String = ""
    var queryValueTemperature: String = ""
    var queryValueTotalPointsTeam1: String = ""
    var queryValueTotalPointsTeam2: String = ""
    var queryValueTouchdownsTeam1: String = ""
    var queryValueTouchdownsTeam2: String = ""
    var queryValueTurnoversCommittedTeam1: String = ""
    var queryValueTurnoversCommittedTeam2: String = ""
    var queryValuePenaltiesCommittedTeam1: String = ""
    var queryValuePenaltiesCommittedTeam2: String = ""
    var queryValueTotalYardsTeam1: String = ""
    var queryValueTotalYardsTeam2: String = ""
    var queryValuePassingYardsTeam1: String = ""
    var queryValuePassingYardsTeam2: String = ""
    var queryValueRushingYardsTeam1: String = ""
    var queryValueRushingYardsTeam2: String = ""
    var queryValueQuarterbackRatingTeam1: String = ""
    var queryValueQuarterbackRatingTeam2: String = ""
    var queryValueTimesSackedTeam1: String = ""
    var queryValueTimesSackedTeam2: String = ""
    var queryValueInterceptionsThrownTeam1: String = ""
    var queryValueInterceptionsThrownTeam2: String = ""
    var queryValueOffensivePlaysTeam1: String = ""
    var queryValueOffensivePlaysTeam2: String = ""
    var queryValueYardsPerOffensivePlayTeam1: String = ""
    var queryValueYardsPerOffensivePlayTeam2: String = ""
    var queryValueSacksTeam1: String = ""
    var queryValueSacksTeam2: String = ""
    var queryValueInterceptionsTeam1: String = ""
    var queryValueInterceptionsTeam2: String = ""
    var queryValueSafetiesTeam1: String = ""
    var queryValueSafetiesTeam2: String = ""
    var queryValueDefensivePlaysTeam1: String = ""
    var queryValueDefensivePlaysTeam2: String = ""
    var queryValueYardsPerDefensivePlayTeam1: String = ""
    var queryValueYardsPerDefensivePlayTeam2: String = ""
    var queryValueExtraPointAttemptsTeam1: String = ""
    var queryValueExtraPointAttemptsTeam2: String = ""
    var queryValueExtraPointsMadeTeam1: String = ""
    var queryValueExtraPointsMadeTeam2: String = ""
    var queryValueFieldGoalAttemptsTeam1: String = ""
    var queryValueFieldGoalAttemptsTeam2: String = ""
    var queryValueFieldGoalsMadeTeam1: String = ""
    var queryValueFieldGoalsMadeTeam2: String = ""
    var queryValuePuntsTeam1: String = ""
    var queryValuePuntsTeam2: String = ""
    var queryValuePuntYardsTeam1: String = ""
    var queryValuePuntYardsTeam2: String = ""
    var queryStringTeam1: String = ""
    var queryStringTeam2: String = ""
    var queryStringSpreadTeam1: String = ""
    var queryStringOverUnder: String = ""
    var queryStringWinningLosingStreakTeam1: String = ""
    var queryStringWinningLosingStreakTeam2: String = ""
    var queryStringSeasonWinPercentageTeam1: String = ""
    var queryStringSeasonWinPercentageTeam2: String = ""
    var queryStringHomeTeam: String = ""
    var queryStringFavorite: String = ""
    var queryStringPlayer: String = ""
    var queryStringPlayersTeam1: String = ""
    var queryStringPlayersTeam2: String = ""
    var queryStringSeason: String = ""
    var queryStringWeek: String = ""
    var queryStringGameNumber: String = ""
    var queryStringDay: String = ""
    var queryStringStadium: String = ""
    var queryStringSurface: String = ""
    var queryStringTemperature: String = ""
    var queryStringTotalPointsTeam1: String = ""
    var queryStringTotalPointsTeam2: String = ""
    var queryStringTouchdownsTeam1: String = ""
    var queryStringTouchdownsTeam2: String = ""
    var queryStringTurnoversCommittedTeam1: String = ""
    var queryStringTurnoversCommittedTeam2: String = ""
    var queryStringPenaltiesCommittedTeam1: String = ""
    var queryStringPenaltiesCommittedTeam2: String = ""
    var queryStringTotalYardsTeam1: String = ""
    var queryStringTotalYardsTeam2: String = ""
    var queryStringPassingYardsTeam1: String = ""
    var queryStringPassingYardsTeam2: String = ""
    var queryStringRushingYardsTeam1: String = ""
    var queryStringRushingYardsTeam2: String = ""
    var queryStringQuarterbackRatingTeam1: String = ""
    var queryStringQuarterbackRatingTeam2: String = ""
    var queryStringTimesSackedTeam1: String = ""
    var queryStringTimesSackedTeam2: String = ""
    var queryStringInterceptionsThrownTeam1: String = ""
    var queryStringInterceptionsThrownTeam2: String = ""
    var queryStringOffensivePlaysTeam1: String = ""
    var queryStringOffensivePlaysTeam2: String = ""
    var queryStringYardsPerOffensivePlayTeam1: String = ""
    var queryStringYardsPerOffensivePlayTeam2: String = ""
    var queryStringSacksTeam1: String = ""
    var queryStringSacksTeam2: String = ""
    var queryStringInterceptionsTeam1: String = ""
    var queryStringInterceptionsTeam2: String = ""
    var queryStringSafetiesTeam1: String = ""
    var queryStringSafetiesTeam2: String = ""
    var queryStringDefensivePlaysTeam1: String = ""
    var queryStringDefensivePlaysTeam2: String = ""
    var queryStringYardsPerDefensivePlayTeam1: String = ""
    var queryStringYardsPerDefensivePlayTeam2: String = ""
    var queryStringExtraPointAttemptsTeam1: String = ""
    var queryStringExtraPointAttemptsTeam2: String = ""
    var queryStringExtraPointsMadeTeam1: String = ""
    var queryStringExtraPointsMadeTeam2: String = ""
    var queryStringFieldGoalAttemptsTeam1: String = ""
    var queryStringFieldGoalAttemptsTeam2: String = ""
    var queryStringFieldGoalsMadeTeam1: String = ""
    var queryStringFieldGoalsMadeTeam2: String = ""
    var queryStringPuntsTeam1: String = ""
    var queryStringPuntsTeam2: String = ""
    var queryStringPuntYardsTeam1: String = ""
    var queryStringPuntYardsTeam2: String = ""
    
    var winsTeam1: Int = 0
    var lossesTeam1: Int = 0
    var tiesTeam1: Int = 0
    var winRate: Float = 0.0
    var gamesSampled: Int = 0
    var gameStarts: Int = 0
    var coveredTeam1: Int = 0
    var notCoveredTeam1: Int = 0
    var pushTeam1: Int = 0
     //PLAYER BIO
    var playerID: String = ""
    var uniformNumber: String = "--"
    var position: String = "--"
    var team: String = "--"
    var byeWeek: String = "--"
    var height: String = "--"
    var weight: String = "--"
    var age: Int = 0
    var experience: Int = 0
    //GAMES SAMPLED
    var winPercent: String = "--"
    var record: String = "--"
    var ATS: String = "--"
    var passing300: Float = 0
    var rushing300: Float = 0
    var receiving300: Float = 0
    var positionRank: Float = 0
    //SCORING
    var touchdownsTotal: Float = 0
    var twoPointConversions: Float = 0
    //FANTASY
    var fantasySTD: Float = 0
    var fantasyPPR: Float = 0
    var fantasyDK: Float = 0
    var fantasyFD: Float = 0
    //FUMBLES
    var fumblesLost: Float = 0
    var fumblesRecovered: Float = 0
    //PASSING
    var passingCompletions: Float = 0
    var passingAttempts: Float = 0
    var passingCompletionPercentage: Float = 0
    var passingYards: Float = 0
    var passingAverageYardage: Float = 0
    var passingTouchdowns: Float = 0
    var passingInterceptionsThrown: Float = 0
    var passingSacks: Float = 0
    var passingSackYardage: Float = 0
    var quarterbackRating: Float = 0
    //RUSHING
    var rushAttempts: Float = 0
    var rushingYards: Float = 0
    var rushingAverageYardage: Float = 0
    var rushingTouchdowns: Float = 0
    //RECEIVING
    var receivingTargets: Float = 0
    var receivingReceptions: Float = 0
    var receivingCatchPercentage: Float = 0
    var receivingYards: Float = 0
    var receivingAverageYardage: Float = 0
    var receivingTouchdowns: Float = 0
    //KICKING
    var kickingFieldGoalAttempts: Float = 0
    var kickingFieldGoalsMade: Float = 0
    var kickingFieldGoalsBlocked: Float = 0
    var kickingExtraPointAttempts: Float = 0
    var kickingExtraPointsMade: Float = 0
    var kickingExtraPointsBlocked: Float = 0
    ////QUERIES////
    var queryFromFiltersPlayerData: String = ""
    var queryFromFiltersGameData: String = ""
    var queryFromFiltersPlayerDash: String = ""
    let char: Character = "\t"
    var gameStatsDefinitionsMessage: String = ""
    var passingDefinitionsMessage: String = ""
    var rushingDefinitionsMessage: String = ""
    var receivingDefinitionsMessage: String = ""
    var playerBioDefinitionsMessage: String = ""
    var queryOperatorSQL: String = "SUM"
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PlayerDashboardVC viewDidLoad()")
        NotificationCenter.default.addObserver(self, selector: #selector(PlayerDashboardViewController.updatePlayerDashboardValues), name: NSNotification.Name(rawValue: "playerDashboardNotification"), object: nil)
        let deviceType = UIDevice().type
        print("\(UIDevice().type.rawValue)")
        errorIndicator = "No"
        statToggle.segments = LabelSegment.segments(withTitles: ["GAME STATS", "PASSING", "RUSHING", "RECEIVING"], normalFont: elevenAndAHalfRegularRobotoCondensed, normalTextColor: silverColor.withAlphaComponent(0.7), selectedFont: elevenAndAHalfRegularRobotoCondensed, selectedTextColor: offWhiteColor.withAlphaComponent(0.8))
        calcToggle.segments = LabelSegment.segments(withTitles: ["TOTAL", "PER GAME"], normalFont: elevenAndAHalfRegularRobotoCondensed, normalTextColor: silverColor.withAlphaComponent(0.7), selectedFont: elevenAndAHalfRegularRobotoCondensed, selectedTextColor: offWhiteColor.withAlphaComponent(0.8))
        statToggle.addTarget(self, action: #selector(PlayerDashboardViewController.togglesChanged), for: .valueChanged)
        calcToggle.addTarget(self, action: #selector(PlayerDashboardViewController.togglesChanged), for: .valueChanged)
        self.view.addSubview(receivingCard)
        self.view.addSubview(rushingCard)
        self.view.addSubview(passingCard)
        self.view.addSubview(gameStatsCard)
        receivingCard.isHidden = true
        rushingCard.isHidden = true
        passingCard.isHidden = true
        gameStatsCard.isHidden = false
        self.view.bringSubview(toFront: gameStatsCard)
        self.view.addSubview(playerBioCard)
        playerBioCard.isHidden = false
        switch deviceType {
        case .iPhoneXSMax:
            statToggle.cornerRadius = 14.165
            calcToggle.cornerRadius = 14.165
        case .iPhoneXS:
            statToggle.cornerRadius = 12.835
            calcToggle.cornerRadius = 12.835
        case .iPhoneXR:
            statToggle.cornerRadius = 14.0
            calcToggle.cornerRadius = 14.0
        case .iPhoneX:
            statToggle.cornerRadius = 12.835
            calcToggle.cornerRadius = 12.835
        case .iPhone8plus:
            statToggle.cornerRadius = 11.665
            calcToggle.cornerRadius = 11.665
        case .iPhone8:
            statToggle.cornerRadius = 10.5
            calcToggle.cornerRadius = 10.5
        case .iPhoneSE:
            statToggle.cornerRadius = 8.75
            calcToggle.cornerRadius = 8.75
        case .iPhone7plus:
            statToggle.cornerRadius = 11.665
            calcToggle.cornerRadius = 11.665
        case .iPhone7:
            statToggle.cornerRadius = 10.5
            calcToggle.cornerRadius = 10.5
        case .iPhone6Splus:
            statToggle.cornerRadius = 11.665
            calcToggle.cornerRadius = 11.665
        case .iPhone6S:
            statToggle.cornerRadius = 10.5
            calcToggle.cornerRadius = 10.5
        case .iPhone6plus:
            statToggle.cornerRadius = 11.665
            calcToggle.cornerRadius = 11.665
        case .iPhone6:
            statToggle.cornerRadius = 10.5
            calcToggle.cornerRadius = 10.5
        case .iPhone5S:
            statToggle.cornerRadius = 8.75
            calcToggle.cornerRadius = 8.75
        case .iPhone5C:
            statToggle.cornerRadius = 8.8
            calcToggle.cornerRadius = 8.8
        case .iPhone5:
            statToggle.cornerRadius = 8.75
            calcToggle.cornerRadius = 8.75
        case .iPhone4S:
            statToggle.cornerRadius = 7.5
            calcToggle.cornerRadius = 7.5
        case .iPhone4:
            statToggle.cornerRadius = 7.5
            calcToggle.cornerRadius = 7.5
        default:
            statToggle.cornerRadius = 10.0
        }
        
        numberFormatter.groupingSeparator = nil
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        playerDashboardView.setDefaultElevation()
        playerDashboardView.backgroundColor = dashboardGreyColor
        /*playerBioCard.setShadowElevation(ShadowElevation(rawValue: 1.5), for: .normal)
        gameStatsCard.setShadowElevation(ShadowElevation(rawValue: 1.5), for: .normal)
        passingCard.setShadowElevation(ShadowElevation(rawValue: 1.5), for: .normal)
        rushingCard.setShadowElevation(ShadowElevation(rawValue: 1.5), for: .normal)
        receivingCard.setShadowElevation(ShadowElevation(rawValue: 1.5), for: .normal)*/
        
        //playerBioCard.cornerRadius = 6
        playerBioCard.backgroundColor = dashboardButtonGreyColor
        //gameStatsCard.cornerRadius = 6
        gameStatsCard.backgroundColor = dashboardButtonGreyColor
       // passingCard.cornerRadius = 6
        passingCard.backgroundColor = dashboardButtonGreyColor
        //rushingCard.cornerRadius = 6
        rushingCard.backgroundColor = dashboardButtonGreyColor
        //receivingCard.cornerRadius = 6
        receivingCard.backgroundColor = dashboardButtonGreyColor
        playerBioDefinitionsMessage = "NO\t\t\tUniform Number\nPOS\t\t\tPosition\nTEAM\t\tCurrent Team\nBYE\t\t\tBye Week\nHEIGHT\t\tPlayer Height\nWEIGHT\t\tPlayer Weight\nAGE\t\t\tCurrent Age\nEXP\t\t\tSeasons Active"
        gameStatsDefinitionsMessage = "TD\t\tTotal Touchdowns\n2PC\t\tTwo-Point Conversions\nFUM\t\tFumbles Lost\nFF-STD\tFantasy Points, Standard NFL Scoring\nFF-PPR\tFantasy Points, PPR Scoring\nFF-DK\tFantasy Points, DraftKings Scoring\nFF-FD\tFantasy Points, FanDuel Scoring"
        passingDefinitionsMessage = "CMP\t\tPass Completions\nATT\t\tPass Attempts\nPCT\t\tCompletion Percentage\nYDS\t\tPassing Yards\nAVG\t\tYards Per Pass Attempt\n300+\tGames Passing 300+ Yards\nTD\t\tPassing Touchdowns\nINT\t\tInterceptions Thrown\nSCK\t\tSacks\nSCK-Y\tSack Yards Lost\nRATE\tQuarterback Rating"
        rushingDefinitionsMessage = "ATT\t\tRushing Attempts\nYDS\t\tRushing Yards\nAVG\t\tYards Per Carry\n300+\tGames Rushing 300+ Yards\nTD\t\tRushing Touchdowns"
        receivingDefinitionsMessage = "REC\t\tReceptions\nTGT\t\tPass Targets\nPCT\t\tCatch Percentage\nYDS\t\tReceiving Yards\nAVG\t\tYards Per Reception\n300+\tGames Receiving 300+ Yards\nTD\t\tReceiving Touchdowns"
    
        let alertControllerAction = MDCAlertAction(title:"OK") { (action) in print("OK") }
        alertController = MDCAlertController(title: titleString, message: messageString)
        alertController.buttonTitleColor = orangeColor
        alertController.buttonFont = fifteenBlackRoboto
        alertController.addAction(alertControllerAction)
        alertController.view.backgroundColor = lightGreyColor.withAlphaComponent(0.8)
        alertController.titleFont = sixteenBoldRobotoCondensed
        alertController.messageFont = fifteenRegularRobotoCondensed
        alertController.titleColor = dashboardGreyColor
        alertController.messageColor = dashboardButtonGreyColor

        playerBioCard.addTarget(self, action: #selector(PlayerDashboardViewController.playerBioCardTapped), for: .touchUpInside)
        gameStatsCard.addTarget(self, action: #selector(PlayerDashboardViewController.gameStatsCardTapped), for: .touchUpInside)
        passingCard.addTarget(self, action: #selector(PlayerDashboardViewController.passingCardTapped), for: .touchUpInside)
        rushingCard.addTarget(self, action: #selector(PlayerDashboardViewController.rushingCardTapped), for: .touchUpInside)
        receivingCard.addTarget(self, action: #selector(PlayerDashboardViewController.receivingCardTapped), for: .touchUpInside)
    
        
        queryFromFiltersPlayerData = ""
        queryFromFiltersGameData = ""
        queryFromFiltersPlayerDash = "FROM PlayerGameData WHERE " + queryFromFiltersPlayerData + "TeamDateUniqueID IN (SELECT TeamDateUniqueID FROM TeamGameData" + queryFromFiltersGameData
        queryGameStarts = "FROM PlayerGameData WHERE StartedGame = 'STARTED' AND TeamDateUniqueID IN (SELECT TeamDateUniqueID FROM TeamGameData" + queryFromFiltersGameData + ")"
        queryWinsTeam1 = queryFromFiltersPlayerDash + " WHERE winLoseTieValueTeam = 1.0" + ")"
        queryLossesTeam1 = queryFromFiltersPlayerDash + " WHERE winLoseTieValueTeam = 0.0" + ")"
        queryTiesTeam1 = queryFromFiltersPlayerDash + " WHERE winLoseTieValueTeam = 0.5" + ")"
        queryCoveredTeam1 = queryFromFiltersPlayerDash + " WHERE SpreadVsLine = 'covered'" + ")"
        queryNotCoveredTeam1 = queryFromFiltersPlayerDash + " WHERE SpreadVsLine = 'not covered'" + ")"
        queryPushTeam1 = queryFromFiltersPlayerDash + " WHERE SpreadVsLine = 'push'" + ")"
        
        /*print("queryFromFiltersPlayerDash: SELECT * " + queryFromFiltersPlayerDash)
        print("queryGameStarts: SELECT * " + String(queryGameStarts))
        print("queryWinsTeam1: SELECT * " + String(queryWinsTeam1))
        print("queryLossesTeam1: SELECT * " + String(queryLossesTeam1))
        print("queryTiesTeam1: SELECT * " + String(queryTiesTeam1))
        print("queryCoveredTeam1: SELECT * " + String(queryCoveredTeam1))
        print("queryNotCoveredTeam1: SELECT * " + String(queryGameStarts))
        print("queryPushTeam1: SELECT * " + String(queryGameStarts))*/
        
        
        let pathStatsDB = Bundle.main.path(forResource: "StatsDatabase", ofType:"db")
        let db = FMDatabase(path: pathStatsDB)
        guard db.open() else {
            print("Unable to open database 'StatsDB'")
            return
        }
        do {
            let executeGamesSampled = try db.executeQuery("SELECT COUNT(*) \(queryFromFiltersPlayerDash))", values: nil)
            while executeGamesSampled.next() {
                gamesSampled = executeGamesSampled.long(forColumnIndex: 0)
                print("gamesSampled: " + String(gamesSampled))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        
        do {
            let executeGameStarts = try db.executeQuery("SELECT COUNT(*) \(queryGameStarts)", values: nil)
            while executeGameStarts.next() {
                gameStarts = executeGameStarts.long(forColumnIndex: 0)
                print("gameStarts: " + String(gameStarts))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        
        do {
            let executeWinsTeam1 = try db.executeQuery("SELECT COUNT(*) \(queryWinsTeam1)", values: nil)
            while executeWinsTeam1.next() {
                winsTeam1 = executeWinsTeam1.long(forColumnIndex: 0)
                print("winsTeam1: " + String(winsTeam1))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeLossesTeam1 = try db.executeQuery("SELECT COUNT(*) \(queryLossesTeam1)", values: nil)
            while executeLossesTeam1.next() {
                lossesTeam1 = executeLossesTeam1.long(forColumnIndex: 0)
                print("lossesTeam1: " + String(lossesTeam1))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeTiesTeam1 = try db.executeQuery("SELECT COUNT(*) \(queryTiesTeam1)", values: nil)
            while executeTiesTeam1.next() {
                tiesTeam1 = executeTiesTeam1.long(forColumnIndex: 0)
                print("tiesTeam1: " + String(tiesTeam1))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeCoveredTeam1 = try db.executeQuery("SELECT COUNT(*) \(queryCoveredTeam1)", values: nil)
            while executeCoveredTeam1.next() {
                coveredTeam1 = executeCoveredTeam1.long(forColumnIndex: 0)
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeNotCoveredTeam1 = try db.executeQuery("SELECT COUNT(*) \(queryNotCoveredTeam1)", values: nil)
            while executeNotCoveredTeam1.next() {
                notCoveredTeam1 = executeNotCoveredTeam1.long(forColumnIndex: 0)
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executePushTeam1 = try db.executeQuery("SELECT COUNT(*) \(queryPushTeam1)", values: nil)
            while executePushTeam1.next() {
                pushTeam1 = executePushTeam1.long(forColumnIndex: 0)
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        
        playerLabel.adjustsFontSizeToFitWidth = true
        playerLabel.minimumScaleFactor = 0.6
        playerLabel.allowsDefaultTighteningForTruncation = true
        opponentLabel.adjustsFontSizeToFitWidth = true
        opponentLabel.minimumScaleFactor = 0.6
        opponentLabel.allowsDefaultTighteningForTruncation = true
        winRateValue.adjustsFontSizeToFitWidth = true
        winRateValue.minimumScaleFactor = 0.6
        winRateValue.allowsDefaultTighteningForTruncation = true
        winRateLabel.adjustsFontSizeToFitWidth = true
        winRateLabel.minimumScaleFactor = 0.6
        winRateLabel.allowsDefaultTighteningForTruncation = true
        gamesSampledValue.adjustsFontSizeToFitWidth = true
        gamesSampledValue.minimumScaleFactor = 0.6
        gamesSampledValue.allowsDefaultTighteningForTruncation = true
        /*gameSampledLabel.adjustsFontSizeToFitWidth = true
         gameSampledLabel.minimumScaleFactor = 0.6
         gameSampledLabel.allowsDefaultTighteningForTruncation = true*/
        gameStartsValue.adjustsFontSizeToFitWidth = true
        gameStartsValue.minimumScaleFactor = 0.6
        gameStartsValue.allowsDefaultTighteningForTruncation = true
        /*gameStartsLabel.adjustsFontSizeToFitWidth = true
        gameStartsLabel.minimumScaleFactor = 0.6
        gameStartsLabel.allowsDefaultTighteningForTruncation = true*/
        recordValue.adjustsFontSizeToFitWidth = true
        recordValue.minimumScaleFactor = 0.6
        recordValue.allowsDefaultTighteningForTruncation = true
        /*recordLabel.adjustsFontSizeToFitWidth = true
         recordLabel.minimumScaleFactor = 0.6
         recordLabel.allowsDefaultTighteningForTruncation = true*/
        ATSValue.adjustsFontSizeToFitWidth = true
        ATSValue.minimumScaleFactor = 0.6
        ATSValue.allowsDefaultTighteningForTruncation = true
        /*ATSOpponent.adjustsFontSizeToFitWidth = true
        ATSOpponent.minimumScaleFactor = 0.6
        ATSOpponent.allowsDefaultTighteningForTruncation = true*/
        
        /*//-1-//
        playerLabelText = "PLAYER"
        //-2-//
        opponentLabelText = "OPPONENT"
        //-3-//
        winRate = Float((Double(winsTeam1) + (0.5 * (Double(tiesTeam1))))/Double(gamesSampled))
        winRateLabelText = String(format: "%.1f%%", (100.00 * ((Double(winsTeam1) + (0.5 * (Double(tiesTeam1))))/Double(gamesSampled)))) //"50.0%"
        self.perform(#selector(animateProgress), with: nil, afterDelay: 0.3)
        //-4-//
        gamesSampledLabelText = numberFormatter.string(from: NSNumber(value: gamesSampled))!
        //-5-//
        gameStartsLabelText = numberFormatter.string(from: NSNumber(value: gameStarts))!
        //-6-//
        recordLabelText = "(" + winsTeam1.formattedWithSeparator_ + "-" + lossesTeam1.formattedWithSeparator_ + "-" + tiesTeam1.formattedWithSeparator_ + ")"
        //-7-//
        ATSLabelText = "(" + coveredTeam1.formattedWithSeparator + "-" + notCoveredTeam1.formattedWithSeparator + "-" + pushTeam1.formattedWithSeparator + ")"
        */
        playerLabel.text = playerLabelText
        opponentLabel.text = opponentLabelText
        winRateValue.text = "0.0%" //winRateLabelText
        gamesSampledValue.text = "0"// gamesSampledLabelText
        gameStartsValue.text = "0" // gameStarts
        recordValue.text = "0-0-0" // recordLabelText
        ATSValue.text = "0-0-0" // ATSLabelText
        if errorIndicator == "Yes" {
            print("errorIndicator = Yes")
        } else {
            //print("errorIndicator = No")
        }
        db.close()
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLayoutSubviews() {
        print("viewDidLayoutSubviews")
        //print(winPercentView.frame.width)
        //print(winPercentView.frame.height)
        //print(playerBioCard.frame.height)
        winPercentView.contentMode = .redraw
        winPercentView.backgroundColor = dashboardGreyColor //UIColor.clear
        
        winPercentView.layer.cornerRadius = winPercentView.frame.size.width / 2.0
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: (winPercentView.frame.size.width / 2.0), y: (winPercentView.frame.size.height / 2.0)),
                                      radius: (winPercentView.frame.size.width / 2.0) - 1.5, startAngle: CGFloat(-0.5 * Double.pi),
                                      endAngle: CGFloat(1.5 * Double.pi), clockwise: true)
        
        winPercentView.tracklayer.path = circlePath.cgPath
        winPercentView.tracklayer.fillColor = UIColor.clear.cgColor
        winPercentView.tracklayer.strokeColor = winPercentView.trackColor.cgColor
        winPercentView.tracklayer.lineWidth = 3.0
        winPercentView.tracklayer.strokeEnd = 1.0
        winPercentView.layer.addSublayer(winPercentView.tracklayer)
        winPercentView.progressLayer.path = circlePath.cgPath
        winPercentView.progressLayer.fillColor = UIColor.clear.cgColor
        winPercentView.progressLayer.strokeColor = winPercentView.progressColor.cgColor //orangeColorDarkerCG //progressColor.cgColor
        winPercentView.progressLayer.lineWidth = 3.0
        winPercentView.progressLayer.strokeEnd = 0.0
        winPercentView.layer.addSublayer(winPercentView.progressLayer)
        winPercentView.trackColor = greyMatchUpColor.withAlphaComponent(0.8)
        winPercentView.progressColor = orangeColorDarker.withAlphaComponent(0.8)
        winPercentView.tag = 101
        self.view.addSubview(winPercentView)
        winRateValue.textAlignment = .center
        winRateLabel.textAlignment = .center
        self.view.addSubview(winRateValue)
        self.view.addSubview(winRateLabel)
        self.perform(#selector(animateProgress), with: nil, afterDelay: 0.2)
    }
    
    

    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    /*let nullCharIndex = gameStatsDefinitionsMessage.indexDistance(of: char)
     let leftAlignedParagraphStyle = NSMutableParagraphStyle.init()
     leftAlignedParagraphStyle.alignment = .left
     let gameStatsMutableString = NSMutableAttributedString(string: gameStatsDefinitionsMessage, attributes: [NSAttributedStringKey.font : fourteenLightRobotoCondensed!, NSAttributedStringKey.foregroundColor : dashboardGreyColor, NSAttributedStringKey.paragraphStyle : leftAlignedParagraphStyle])
     gameStatsMutableString.addAttribute(NSAttributedStringKey.font, value: fourteenBoldRobotoCondensed!, range: NSRange(location: 0, length: nullCharIndex!))
     gameStatsMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: greyButtonLabels, range: NSRange(location: 0, length: nullCharIndex!))
     //gameStatsDefinitionsMessage.setAttributedTitle(playerBioButtonTextMutableString, for: .normal)*/
    
    @objc func animateProgress() {
        let cp = self.view.viewWithTag(101) as! CircularProgress
        cp.setProgressWithAnimation(duration: 0.9, value: winRate)
        //cp.setProgressWithAnimation(duration: 0.7, value: 0.5)
    }
    @objc func unanimatedProgress() {
        let cp = self.view.viewWithTag(101) as! CircularProgress
        cp.setProgressWithAnimation(duration: 0.3, value: winRate)
        //cp.setProgressWithAnimation(duration: 0.7, value: 0.5)
    }
    
    @objc func playerBioCardTapped() {
        print("playerBioCardTapped")
        self.titleString = "PLAYER BIO"
        self.alertController.title = titleString
        self.alertController.message = playerBioDefinitionsMessage
        //alertController.view.backgroundColor = lightGreyColor.withAlphaComponent(0.8)
        alertController.titleFont = sixteenBoldRobotoCondensed
        alertController.messageFont = fifteenLightRobotoCondensed
        alertController.titleColor = dashboardGreyColor
        alertController.messageColor = greyMatchUpColor
        self.present(alertController, animated: true) {
            //print("present(alertController()")
        }
    }
    @objc func gameStatsCardTapped() {
        print("gameStatsCardTapped")
        self.titleString = "GAME STATS"
        self.alertController.title = titleString
        self.alertController.message = gameStatsDefinitionsMessage
        //alertController.view.backgroundColor = lightGreyColor.withAlphaComponent(0.8)
        alertController.titleFont = sixteenBoldRobotoCondensed
        alertController.messageFont = fifteenLightRobotoCondensed
        alertController.titleColor = dashboardGreyColor
        alertController.messageColor = greyMatchUpColor
        self.present(alertController, animated: true) {
            
            //print("present(alertController()")
        }
    }
    
    @objc func passingCardTapped() {
        print("passingCardTapped")
        self.titleString = "PASSING STATS"
        self.alertController.title = titleString
        self.alertController.message = passingDefinitionsMessage
        //alertController.view.backgroundColor = lightGreyColor.withAlphaComponent(0.8)
        alertController.titleFont = sixteenBoldRobotoCondensed
        alertController.messageFont = fifteenLightRobotoCondensed
        alertController.titleColor = dashboardGreyColor
        alertController.messageColor = greyMatchUpColor
        self.present(alertController, animated: true) {
            //print("present(alertController()")
        }
    }
    @objc func rushingCardTapped() {
        print("rushingCardTapped")
        self.titleString = "RUSHING STATS"
        self.alertController.title = titleString
        self.alertController.message = rushingDefinitionsMessage
        //alertController.view.backgroundColor = lightGreyColor.withAlphaComponent(0.8)
        alertController.titleFont = sixteenBoldRobotoCondensed
        alertController.messageFont = fifteenLightRobotoCondensed
        alertController.titleColor = dashboardGreyColor
        alertController.messageColor = greyMatchUpColor
        self.present(alertController, animated: true) {
            //print("present(alertController()")
        }
    }
    
    @objc func receivingCardTapped() {
        print("receivingCardTapped")
        self.titleString = "RECEIVING STATS"
        self.alertController.title = titleString
        self.alertController.message = receivingDefinitionsMessage
        //alertController.view.backgroundColor = lightGreyColor.withAlphaComponent(0.8)
        alertController.titleFont = sixteenBoldRobotoCondensed
        alertController.messageFont = fifteenLightRobotoCondensed
        alertController.titleColor = dashboardGreyColor
        alertController.messageColor = greyMatchUpColor
        self.present(alertController, animated: true) {
            //print("present(alertController()")
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    @objc func togglesChanged() {
        print("statToggle.index: ")
        print(statToggle.index)
        print("calcToggle.index: ")
        print(calcToggle.index)
        
        if statToggle.index == 0 {
            receivingCard.isHidden = true
            rushingCard.isHidden = true
            passingCard.isHidden = true
            gameStatsCard.isHidden = false
            self.view.bringSubview(toFront: gameStatsCard)
        } else if statToggle.index == 1 {
            receivingCard.isHidden = true
            rushingCard.isHidden = true
            gameStatsCard.isHidden = true
            passingCard.isHidden = false
            self.view.bringSubview(toFront: passingCard)
        } else if statToggle.index == 2 {
            receivingCard.isHidden = true
            passingCard.isHidden = true
            gameStatsCard.isHidden = true
            rushingCard.isHidden = false
            self.view.bringSubview(toFront: rushingCard)
        } else if statToggle.index == 3 {
            passingCard.isHidden = true
            gameStatsCard.isHidden = true
            rushingCard.isHidden = true
            receivingCard.isHidden = false
            self.view.bringSubview(toFront: receivingCard)
        }
        
        
        if calcToggle.index == 0 {
            //self.perform(#selector(animateProgress), with: nil, afterDelay: 0.3)
            queryOperatorSQL = "SUM"
            updateToggleCalculation()
            //updatePlayerDashboardValues()
        } else if calcToggle.index == 1 {
            //self.perform(#selector(animateProgress), with: nil, afterDelay: 0.3)
            queryOperatorSQL = "AVG"
            updateToggleCalculation()
        }
        /*if statToggle.index == 0 {
            receivingCard.isHidden = true
            rushingCard.isHidden = true
            passingCard.isHidden = true
            gameStatsCard.isHidden = false
            self.view.bringSubview(toFront: gameStatsCard)
        } else if statToggle.index == 1 {
            receivingCard.isHidden = true
            rushingCard.isHidden = true
            gameStatsCard.isHidden = true
            passingCard.isHidden = false
            self.view.bringSubview(toFront: passingCard)
        } else if statToggle.index == 2 {
            receivingCard.isHidden = true
            passingCard.isHidden = true
            gameStatsCard.isHidden = true
            rushingCard.isHidden = false
            self.view.bringSubview(toFront: rushingCard)
        } else if statToggle.index == 3 {
            passingCard.isHidden = true
            gameStatsCard.isHidden = true
            rushingCard.isHidden = true
            receivingCard.isHidden = false
            self.view.bringSubview(toFront: receivingCard)
        }*/
    }
    func updateToggleCalculation() {
        print("updateToggleCalculation()")
        //print("clearSliderIndicatorPlayer: ")
        //print(clearSliderIndicatorPlayer)
       //print("seasonWinPercentageTeam1SliderValuePlayer: ")
       // print(seasonWinPercentageTeam1SliderValuePlayer)
        //positionValue.text = "RB"
        queryOperatorTeam1 = " = "
        if clearMultiSelectIndicatorPlayer == "PLAYER" || playerListValuePlayer == ["-10000"] || playerListValuePlayer == [] || playerListValuePlayer == [""] {
            playerLabelText = "PLAYER"
            queryStringPlayer = ""
            queryFromFiltersPlayerData = ""
        } else {
            queryValuePlayer = "('" + playerDictionary[playerListValuePlayer[0]]! + "')"
            playerLabelText = playerListValuePlayer[0]
            playerLabel.adjustsFontSizeToFitWidth = true
            playerLabel.minimumScaleFactor = 0.6
            playerLabel.allowsDefaultTighteningForTruncation = true
            queryStringPlayer = queryColumnPlayer + " IN " + queryValuePlayer
            queryFromFiltersPlayerData = queryStringPlayer + " AND "
        }
        
        if clearMultiSelectIndicatorPlayer == "OPPONENT" || team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count == 32 {
            opponentLabelText = "OPPONENT"
            queryStringTeam2 = ""
        } else {
            opponentLabel.adjustsFontSizeToFitWidth = true
            opponentLabel.minimumScaleFactor = 0.6
            opponentLabel.allowsDefaultTighteningForTruncation = true
            if team2ListValuePlayer.count > 1 || team2OperatorValuePlayer == "≠" {
                opponentLabelText = "OPPONENT"
            } else {
                opponentLabelText = team2ListValuePlayer[0]
                var opponentLabelTextArray = opponentLabelText.components(separatedBy: " ")
                let opponentLabelTextArrayLength = opponentLabelTextArray.count
                opponentLabelTextArray.remove(at: opponentLabelTextArrayLength - 1)
                opponentLabelText = opponentLabelTextArray.joined(separator: " ")
            }
            if team2OperatorValuePlayer == "=" {
                queryOperatorTeam2 = " IN "
            } else if team2OperatorValuePlayer == "≠" {
                queryOperatorTeam2 = " NOT IN "
            }
            queryValueTeam2 = "('" + team2ListValuePlayer.joined(separator: "', '") + "')"
            queryStringTeam2 = " AND " + queryColumnTeam2 + queryOperatorTeam2 + queryValueTeam2
        }
        
        if clearSliderIndicatorPlayer == "PLAYER TEAM: SPREAD" {
            queryStringSpreadTeam1 = ""
        } else {
            if spreadOperatorValuePlayer == "< >" {
                queryOperatorSpreadTeam1 = " BETWEEN "
                let queryLowerValueSpreadTeam1 = spreadRangeSliderLowerValuePlayer
                let queryUpperValueSpreadTeam1 = spreadRangeSliderUpperValuePlayer
                queryValueSpreadTeam1 = String(queryLowerValueSpreadTeam1) + " AND " + String(queryUpperValueSpreadTeam1)
                queryStringSpreadTeam1 = " AND " + queryColumnSpreadTeam1 + queryOperatorSpreadTeam1 + queryValueSpreadTeam1
            } else {
                if spreadSliderValuePlayer == -10000 {
                    queryStringSpreadTeam1 = ""
                } else {
                    if spreadOperatorValuePlayer == "≠" {
                        queryOperatorSpreadTeam1 = " != "
                    } else {
                        queryOperatorSpreadTeam1 = " " + spreadOperatorValuePlayer + " "
                    }
                    queryValueSpreadTeam1 = String(spreadSliderValuePlayer)
                    queryStringSpreadTeam1 = " AND LENGTH(\(queryColumnSpreadTeam1)) !=0 AND " + queryColumnSpreadTeam1 + queryOperatorSpreadTeam1 + queryValueSpreadTeam1
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "PLAYER TEAM: OVER/UNDER" {
            queryValueOverUnder = ""
        } else {
            if overUnderOperatorValuePlayer == "< >" {
                queryOperatorOverUnder = " BETWEEN "
                let queryLowerValueOverUnder = overUnderRangeSliderLowerValuePlayer
                let queryUpperValueOverUnder = overUnderRangeSliderUpperValuePlayer
                queryValueOverUnder = String(queryLowerValueOverUnder) + " AND " + String(queryUpperValueOverUnder)
                queryStringOverUnder = " AND " + queryColumnOverUnder + queryOperatorOverUnder + queryValueOverUnder
            } else {
                if overUnderSliderValuePlayer == -10000 {
                    queryStringOverUnder = ""
                } else {
                    if overUnderOperatorValuePlayer == "≠" {
                        queryOperatorOverUnder = " != "
                    } else {
                        queryOperatorOverUnder = " " + overUnderOperatorValuePlayer + " "
                    }
                    queryValueOverUnder = String(overUnderSliderValuePlayer)
                    queryStringOverUnder = " AND LENGTH(\(queryColumnOverUnder)) !=0 AND " + queryColumnOverUnder + queryOperatorOverUnder + queryValueOverUnder
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "PLAYER TEAM: STREAK" {
            queryValueWinningLosingStreakTeam1 = ""
        } else {
            if winningLosingStreakTeam1OperatorValuePlayer == "< >" {
                queryOperatorWinningLosingStreakTeam1 = " BETWEEN "
                let queryLowerValueWinningLosingStreakTeam1 = winningLosingStreakTeam1RangeSliderLowerValuePlayer
                let queryUpperValueWinningLosingStreakTeam1 = winningLosingStreakTeam1RangeSliderUpperValuePlayer
                queryValueWinningLosingStreakTeam1 = String(queryLowerValueWinningLosingStreakTeam1) + " AND " + String(queryUpperValueWinningLosingStreakTeam1)
                queryStringWinningLosingStreakTeam1 = " AND " + queryColumnWinningLosingStreakTeam1 + queryOperatorWinningLosingStreakTeam1 + queryValueWinningLosingStreakTeam1
            } else {
                if winningLosingStreakTeam1SliderValuePlayer == -10000 {
                    queryStringWinningLosingStreakTeam1 = ""
                } else {
                    if winningLosingStreakTeam1OperatorValuePlayer == "≠" {
                        queryOperatorWinningLosingStreakTeam1 = " != "
                    } else {
                        queryOperatorWinningLosingStreakTeam1 = " " + winningLosingStreakTeam1OperatorValuePlayer + " "
                    }
                    queryValueWinningLosingStreakTeam1 = String(winningLosingStreakTeam1SliderValuePlayer)
                    queryStringWinningLosingStreakTeam1 = " AND LENGTH(\(queryColumnWinningLosingStreakTeam1)) !=0 AND " + queryColumnWinningLosingStreakTeam1 + queryOperatorWinningLosingStreakTeam1 + queryValueWinningLosingStreakTeam1
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "OPPONENT: STREAK" {
            queryValueWinningLosingStreakTeam2 = ""
        } else {
            if winningLosingStreakTeam2OperatorValuePlayer == "< >" {
                queryOperatorWinningLosingStreakTeam2 = " BETWEEN "
                let queryLowerValueWinningLosingStreakTeam2 = winningLosingStreakTeam2RangeSliderLowerValuePlayer
                let queryUpperValueWinningLosingStreakTeam2 = winningLosingStreakTeam2RangeSliderUpperValuePlayer
                queryValueWinningLosingStreakTeam2 = String(queryLowerValueWinningLosingStreakTeam2) + " AND " + String(queryUpperValueWinningLosingStreakTeam2)
                queryStringWinningLosingStreakTeam2 = " AND " + queryColumnWinningLosingStreakTeam2 + queryOperatorWinningLosingStreakTeam2 + queryValueWinningLosingStreakTeam2
            } else {
                if winningLosingStreakTeam2SliderValuePlayer == -10000 {
                    queryStringWinningLosingStreakTeam2 = ""
                } else {
                    if winningLosingStreakTeam2OperatorValuePlayer == "≠" {
                        queryOperatorWinningLosingStreakTeam2 = " != "
                    } else {
                        queryOperatorWinningLosingStreakTeam2 = " " + winningLosingStreakTeam2OperatorValuePlayer + " "
                    }
                    queryValueWinningLosingStreakTeam2 = String(winningLosingStreakTeam2SliderValuePlayer)
                    queryStringWinningLosingStreakTeam2 = " AND LENGTH(\(queryColumnWinningLosingStreakTeam2)) !=0 AND " + queryColumnWinningLosingStreakTeam2 + queryOperatorWinningLosingStreakTeam2 + queryValueWinningLosingStreakTeam2
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "PLAYER TEAM: SEASON WIN %" {
            queryStringSeasonWinPercentageTeam1 = ""
        } else {
            if seasonWinPercentageTeam1OperatorValuePlayer == "< >" {
                queryOperatorSeasonWinPercentageTeam1 = " BETWEEN "
                let queryLowerValueSeasonWinPercentageTeam1 = (Double(seasonWinPercentageTeam1RangeSliderLowerValuePlayer) / 100.00)
                let queryUpperValueSeasonWinPercentageTeam1 = (Double(seasonWinPercentageTeam1RangeSliderUpperValuePlayer) / 100.00)
                queryValueSeasonWinPercentageTeam1 = String(queryLowerValueSeasonWinPercentageTeam1) + " AND " + String(queryUpperValueSeasonWinPercentageTeam1)
                queryStringSeasonWinPercentageTeam1 = " AND " + queryColumnSeasonWinPercentageTeam1 + queryOperatorSeasonWinPercentageTeam1 + queryValueSeasonWinPercentageTeam1
            } else {
                if seasonWinPercentageTeam1SliderValuePlayer == -10000 {
                    queryStringSeasonWinPercentageTeam1 = ""
                } else {
                    if seasonWinPercentageTeam1OperatorValuePlayer == "≠" {
                        queryOperatorSeasonWinPercentageTeam1 = " != "
                    } else {
                        queryOperatorSeasonWinPercentageTeam1 = " " + seasonWinPercentageTeam1OperatorValuePlayer + " "
                    }
                    queryValueSeasonWinPercentageTeam1 = String(seasonWinPercentageTeam1SliderValuePlayer)
                    queryStringSeasonWinPercentageTeam1 = " AND LENGTH(\(queryColumnSeasonWinPercentageTeam1)) !=0 AND " + queryColumnSeasonWinPercentageTeam1 + queryOperatorSeasonWinPercentageTeam1 + String((Double(queryValueSeasonWinPercentageTeam1)! / 100.00))
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "OPPONENT: SEASON WIN %" {
            queryStringSeasonWinPercentageTeam2 = ""
        } else {
            if seasonWinPercentageTeam2OperatorValuePlayer == "< >" {
                queryOperatorSeasonWinPercentageTeam2 = " BETWEEN "
                let queryLowerValueSeasonWinPercentageTeam2 = (Double(seasonWinPercentageTeam2RangeSliderLowerValuePlayer) / 100.00)
                let queryUpperValueSeasonWinPercentageTeam2 = (Double(seasonWinPercentageTeam2RangeSliderUpperValuePlayer) / 100.00)
                queryValueSeasonWinPercentageTeam2 = String(queryLowerValueSeasonWinPercentageTeam2) + " AND " + String(queryUpperValueSeasonWinPercentageTeam2)
                queryStringSeasonWinPercentageTeam2 = " AND " + queryColumnSeasonWinPercentageTeam2 + queryOperatorSeasonWinPercentageTeam2 + queryValueSeasonWinPercentageTeam2
            } else {
                if seasonWinPercentageTeam2SliderValuePlayer == -10000 {
                    queryStringSeasonWinPercentageTeam2 = ""
                } else {
                    if seasonWinPercentageTeam2OperatorValuePlayer == "≠" {
                        queryOperatorSeasonWinPercentageTeam2 = " != "
                    } else {
                        queryOperatorSeasonWinPercentageTeam2 = " " + seasonWinPercentageTeam2OperatorValuePlayer + " "
                    }
                    queryValueSeasonWinPercentageTeam2 = String(seasonWinPercentageTeam2SliderValuePlayer)
                    queryStringSeasonWinPercentageTeam2 = " AND LENGTH(\(queryColumnSeasonWinPercentageTeam2)) !=0 AND " + queryColumnSeasonWinPercentageTeam2 + queryOperatorSeasonWinPercentageTeam2 + String((Double(queryValueSeasonWinPercentageTeam2)! / 100.00))
                }
            }
        }
        
        /*if homeTeamListValuePlayer == ["-10000"] || homeTeamListValuePlayer == [] {
            queryStringHomeTeam = ""
        } else if homeTeamListValuePlayer == ["EITHER"] {
            queryOperatorHomeTeam = " IN "
            queryValueHomeTeam = "('TEAM 1', 'TEAM 2')"
            queryStringHomeTeam = " AND " + queryColumnHomeTeam + queryOperatorHomeTeam + queryValueHomeTeam
        } else {
            queryOperatorHomeTeam = " = "
            queryValueHomeTeam = "'" + homeTeamListValuePlayer[0] + "'"
            queryStringHomeTeam = " AND " + queryColumnHomeTeam + queryOperatorHomeTeam + queryValueHomeTeam
        }
        
        if favoriteListValuePlayer == ["-10000"] || favoriteListValuePlayer == [] {
            queryStringFavorite = ""
        } else if favoriteListValuePlayer == ["EITHER"] {
            queryOperatorFavorite = " IN "
            queryValueFavorite = "('TEAM 1', 'TEAM 2')"
            queryStringFavorite = " AND " + queryColumnFavorite + queryOperatorFavorite + queryValueFavorite
        } else {
            queryOperatorFavorite = " = "
            queryValueFavorite = "'" + favoriteListValuePlayer[0] + "'"
            queryStringFavorite = " AND " + queryColumnFavorite + queryOperatorFavorite + queryValueFavorite
        }*/
        ///////////
        if clearMultiSelectIndicatorPlayer == "HOME TEAM" {
            queryStringHomeTeam = ""
        } else {
            if homeTeamListValuePlayer == ["-10000"] || homeTeamListValuePlayer == [] || homeTeamListValuePlayer.count == 3 {
                queryStringHomeTeam = ""
            } else {
                queryOperatorHomeTeam = " IN "
                let homeTeamDictionaryPlayer = [
                    "TEAM" : "TEAM 1",
                    "OPPONENT" : "TEAM 2",
                    "NEUTRAL" : "NEUTRAL"
                ]
                var homeTeamListValuesMappedPlayer = [String]()
                for homeTeamPlayer in homeTeamListValuePlayer {
                    homeTeamListValuesMappedPlayer.append(homeTeamDictionaryPlayer[homeTeamPlayer]!)
                }
                queryValueHomeTeam = "('" + homeTeamListValuesMappedPlayer.joined(separator: "', '") + "')"
                queryStringHomeTeam = " AND " + queryColumnHomeTeam + queryOperatorHomeTeam + queryValueHomeTeam
            }
        }
        
        if clearMultiSelectIndicatorPlayer == "FAVORITE" {
            queryStringFavorite = ""
        } else {
            if favoriteListValuePlayer == ["-10000"] || favoriteListValuePlayer == [] || favoriteListValuePlayer.count == 3 {
                queryStringFavorite = ""
            } else {
                queryOperatorFavorite = " IN "
                let favoriteDictionaryPlayer = [
                    "TEAM" : "TEAM 1",
                    "OPPONENT" : "TEAM 2",
                    "PUSH" : "NEITHER"
                ]
                var favoriteListValuesMappedPlayer = [String]()
                for favoritePlayer in favoriteListValuePlayer {
                    favoriteListValuesMappedPlayer.append(favoriteDictionaryPlayer[favoritePlayer]!)
                    
                }
                queryValueFavorite = "('" + favoriteListValuesMappedPlayer.joined(separator: "', '") + "')"
                queryStringFavorite = " AND " + queryColumnFavorite + queryOperatorFavorite + queryValueFavorite
            }
        }
        
        
        
        if clearSliderIndicatorPlayer == "SEASON" {
            queryStringSeason = ""
        } else {
            if seasonOperatorValuePlayer == "< >" {
                queryOperatorSeason = " BETWEEN "
                let queryLowerValueSeason = seasonRangeSliderLowerValuePlayer
                let queryUpperValueSeason = seasonRangeSliderUpperValuePlayer
                queryValueSeason = String(queryLowerValueSeason) + " AND " + String(queryUpperValueSeason)
                queryStringSeason = " AND " + queryColumnSeason + queryOperatorSeason + queryValueSeason
            } else {
                if seasonSliderValuePlayer == -10000 {
                    queryStringSeason = ""
                } else {
                    if seasonOperatorValuePlayer == "≠" {
                        queryOperatorSeason = " != "
                    } else {
                        queryOperatorSeason = " " + seasonOperatorValuePlayer + " "
                    }
                    queryValueSeason = String(Int(seasonSliderValuePlayer)) //seasonSliderFormValuePlayer //String(seasonSliderValuePlayer)
                    queryStringSeason = " AND LENGTH(\(queryColumnSeason)) !=0 AND " + queryColumnSeason + queryOperatorSeason + queryValueSeason
                }
            }
        }
        
        //print("seasonOperatorValuePlayer: ")
        //print(seasonOperatorValuePlayer)
        print("seasonSliderValuePlayer: ")
        print(seasonSliderValuePlayer)
        print("seasonSliderFormValuePlayer: ")
        print(seasonSliderFormValuePlayer)
        print("queryValueSeason: ")
        print(queryValueSeason)
        print("seasonRangeSliderLowerValuePlayer: ")
        print(seasonRangeSliderLowerValuePlayer)
        
        if clearSliderIndicatorPlayer == "WEEK" {
            queryStringWeek = ""
        } else {
            if weekOperatorValuePlayer == "< >" {
                queryOperatorWeek = " BETWEEN "
                let queryLowerValueWeek = weekRangeSliderLowerValuePlayer
                let queryUpperValueWeek = weekRangeSliderUpperValuePlayer
                queryValueWeek = String(queryLowerValueWeek) + " AND " + String(queryUpperValueWeek)
                queryStringWeek = " AND " + queryColumnWeek + queryOperatorWeek + queryValueWeek
            } else {
                if weekSliderValuePlayer == -10000 {
                    queryStringWeek = ""
                } else {
                    if weekOperatorValuePlayer == "≠" {
                        queryOperatorWeek = " != "
                    } else {
                        queryOperatorWeek = " " + weekOperatorValuePlayer + " "
                    }
                    queryValueWeek = String(weekSliderValuePlayer)
                    queryStringWeek = " AND LENGTH(\(queryColumnWeek)) !=0 AND " + queryColumnWeek + queryOperatorWeek + queryValueWeek
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "GAME NUMBER" {
            queryStringGameNumber = ""
        } else {
            if gameNumberOperatorValuePlayer == "< >" {
                queryOperatorGameNumber = " BETWEEN "
                let queryLowerValueGameNumber = gameNumberRangeSliderLowerValuePlayer
                let queryUpperValueGameNumber = gameNumberRangeSliderUpperValuePlayer
                queryValueGameNumber = String(queryLowerValueGameNumber) + " AND " + String(queryUpperValueGameNumber)
                queryStringGameNumber = " AND " + queryColumnGameNumber + queryOperatorGameNumber + queryValueGameNumber
            } else {
                if gameNumberSliderValuePlayer == -10000 {
                    queryStringGameNumber = ""
                } else {
                    if gameNumberOperatorValuePlayer == "≠" {
                        queryOperatorGameNumber = " != "
                    } else {
                        queryOperatorGameNumber = " " + gameNumberOperatorValuePlayer + " "
                    }
                    queryValueGameNumber = String(gameNumberSliderValuePlayer)
                    queryStringGameNumber = " AND LENGTH(\(queryColumnGameNumber)) !=0 AND " + queryColumnGameNumber + queryOperatorGameNumber + queryValueGameNumber
                }
            }
        }
        
        /*if dayListValuePlayer == ["-10000"] || dayListValuePlayer == [] || dayListValuePlayer.count == 7 {
            queryStringDay = ""
        } else {
            queryOperatorDay = " IN "
            queryValueDay = "('" + dayListValuePlayer.joined(separator: "', '") + "')"
            queryStringDay = " AND " + queryColumnDay + queryOperatorDay + queryValueDay
        }
        
        if stadiumListValuePlayer == ["-10000"] || stadiumListValuePlayer == [] || stadiumListValuePlayer.count == 3 {
            queryStringStadium = ""
        } else {
            queryOperatorStadium = " IN "
            let stadiumDictionary = [
                "OUTDOORS" : "outdoors",
                "DOME" : "dome",
                "RETRACTABLE ROOF" : "retroof"
            ]
            var stadiumListValuePlayersMapped = [String]()
            for stadium in stadiumListValuePlayer {
                stadiumListValuePlayersMapped.append(stadiumDictionary[stadium]!)
            }
            queryValueStadium = "('" + stadiumListValuePlayersMapped.joined(separator: "', '") + "')"
            queryStringStadium = " AND " + queryColumnStadium + queryOperatorStadium + queryValueStadium
        }
        
        if surfaceListValuePlayer == ["-10000"] || surfaceListValuePlayer == [] || surfaceListValuePlayer == ["EITHER"] {
            queryStringSurface = ""
        } else {
            if surfaceListValuePlayer == ["GRASS"] {
                queryOperatorSurface = " IN "
                queryValueSurface = "('grass')"
            } else {
                queryOperatorSurface = " NOT IN "
                queryValueSurface = "('grass')"
            }
            queryStringSurface = " AND " + queryColumnSurface + queryOperatorSurface + queryValueSurface
        }
        */
        
        if clearMultiSelectIndicatorPlayer == "DAY" {
            queryStringDay = ""
        } else {
            if dayListValuePlayer == ["-10000"] || dayListValuePlayer == [] || dayListValuePlayer.count == 7 {
                queryStringDay = ""
            } else {
                queryOperatorDay = " IN "
                queryValueDay = "('" + dayListValuePlayer.joined(separator: "', '") + "')"
                queryStringDay = " AND " + queryColumnDay + queryOperatorDay + queryValueDay
            }
        }
        
        if clearMultiSelectIndicatorPlayer == "STADIUM" {
            queryStringStadium = ""
        } else {
            if stadiumListValuePlayer == ["-10000"] || stadiumListValuePlayer == [] || stadiumListValuePlayer.count == 3 {
                queryStringStadium = ""
            } else {
                queryOperatorStadium = " IN "
                let stadiumDictionaryPlayer = [
                    "OUTDOORS" : "outdoors",
                    "DOME" : "dome",
                    "RETRACTABLE ROOF" : "retroof"
                ]
                var stadiumListValuesMappedPlayer = [String]()
                for stadiumPlayer in stadiumListValuePlayer {
                    stadiumListValuesMappedPlayer.append(stadiumDictionaryPlayer[stadiumPlayer]!)
                }
                queryValueStadium = "('" + stadiumListValuesMappedPlayer.joined(separator: "', '") + "')"
                queryStringStadium = " AND " + queryColumnStadium + queryOperatorStadium + queryValueStadium
            }
        }
        
        if clearMultiSelectIndicatorPlayer == "SURFACE" {
            queryStringSurface = ""
        } else {
            if surfaceListValuePlayer == ["-10000"] || surfaceListValuePlayer == [] || surfaceListValuePlayer.count == 2 {
                queryStringSurface = ""
            } else {
                if surfaceListValuePlayer == ["GRASS"] {
                    queryOperatorSurface = " IN "
                    queryValueSurface = "('grass')"
                } else {
                    queryOperatorSurface = " NOT IN "
                    queryValueSurface = "('grass')"
                }
                queryStringSurface = " AND " + queryColumnSurface + queryOperatorSurface + queryValueSurface
            }
        }
        ////
        if clearSliderIndicatorPlayer == "TEMPERATURE (F)" {
            queryStringTemperature = ""
        } else {
            if temperatureOperatorValuePlayer == "< >" {
                queryOperatorTemperature = " BETWEEN "
                let queryLowerValueTemperature = temperatureRangeSliderLowerValuePlayer
                let queryUpperValueTemperature = temperatureRangeSliderUpperValuePlayer
                queryValueTemperature = String(queryLowerValueTemperature) + " AND " + String(queryUpperValueTemperature)
                queryStringTemperature = " AND " + queryColumnTemperature + queryOperatorTemperature + queryValueTemperature
            } else {
                if temperatureSliderValuePlayer == -10000 {
                    queryStringTemperature = ""
                } else {
                    if temperatureOperatorValuePlayer == "≠" {
                        queryOperatorTemperature = " != "
                    } else {
                        queryOperatorTemperature = " " + temperatureOperatorValuePlayer + " "
                    }
                    queryValueTemperature = String(temperatureSliderValuePlayer)
                    queryStringTemperature = " AND LENGTH(\(queryColumnTemperature)) !=0 AND " + queryColumnTemperature + queryOperatorTemperature + queryValueTemperature
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "PLAYER TEAM: TOTAL POINTS" {
            queryStringTotalPointsTeam1 = ""
        } else {
            if totalPointsTeam1OperatorValuePlayer == "< >" {
                queryOperatorTotalPointsTeam1 = " BETWEEN "
                let queryLowerValueTotalPointsTeam1 = totalPointsTeam1RangeSliderLowerValuePlayer
                let queryUpperValueTotalPointsTeam1 = totalPointsTeam1RangeSliderUpperValuePlayer
                queryValueTotalPointsTeam1 = String(queryLowerValueTotalPointsTeam1) + " AND " + String(queryUpperValueTotalPointsTeam1)
                queryStringTotalPointsTeam1 = " AND " + queryColumnTotalPointsTeam1 + queryOperatorTotalPointsTeam1 + queryValueTotalPointsTeam1
            } else {
                if totalPointsTeam1SliderValuePlayer == -10000 {
                    queryStringTotalPointsTeam1 = ""
                } else {
                    if totalPointsTeam1OperatorValuePlayer == "≠" {
                        queryOperatorTotalPointsTeam1 = " != "
                    } else {
                        queryOperatorTotalPointsTeam1 = " " + totalPointsTeam1OperatorValuePlayer + " "
                    }
                    queryValueTotalPointsTeam1 = String(totalPointsTeam1SliderValuePlayer)
                    queryStringTotalPointsTeam1 = " AND LENGTH(\(queryColumnTotalPointsTeam1)) !=0 AND " + queryColumnTotalPointsTeam1 + queryOperatorTotalPointsTeam1 + queryValueTotalPointsTeam1
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "OPPONENT: TOTAL POINTS" {
            queryStringTotalPointsTeam2 = ""
        } else {
            if totalPointsTeam2OperatorValuePlayer == "< >" {
                queryOperatorTotalPointsTeam2 = " BETWEEN "
                let queryLowerValueTotalPointsTeam2 = totalPointsTeam2RangeSliderLowerValuePlayer
                let queryUpperValueTotalPointsTeam2 = totalPointsTeam2RangeSliderUpperValuePlayer
                queryValueTotalPointsTeam2 = String(queryLowerValueTotalPointsTeam2) + " AND " + String(queryUpperValueTotalPointsTeam2)
                queryStringTotalPointsTeam2 = " AND " + queryColumnTotalPointsTeam2 + queryOperatorTotalPointsTeam2 + queryValueTotalPointsTeam2
            } else {
                if totalPointsTeam2SliderValuePlayer == -10000 {
                    queryStringTotalPointsTeam2 = ""
                } else {
                    if totalPointsTeam2OperatorValuePlayer == "≠" {
                        queryOperatorTotalPointsTeam2 = " != "
                    } else {
                        queryOperatorTotalPointsTeam2 = " " + totalPointsTeam2OperatorValuePlayer + " "
                    }
                    queryValueTotalPointsTeam2 = String(totalPointsTeam2SliderValuePlayer)
                    queryStringTotalPointsTeam2 = " AND LENGTH(\(queryColumnTotalPointsTeam2)) !=0 AND " + queryColumnTotalPointsTeam2 + queryOperatorTotalPointsTeam2 + queryValueTotalPointsTeam2
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "PLAYER TEAM: TOUCHDOWNS" {
            queryStringTouchdownsTeam1 = ""
        } else {
            if touchdownsTeam1OperatorValuePlayer == "< >" {
                queryOperatorTouchdownsTeam1 = " BETWEEN "
                let queryLowerValueTouchdownsTeam1 = touchdownsTeam1RangeSliderLowerValuePlayer
                let queryUpperValueTouchdownsTeam1 = touchdownsTeam1RangeSliderUpperValuePlayer
                queryValueTouchdownsTeam1 = String(queryLowerValueTouchdownsTeam1) + " AND " + String(queryUpperValueTouchdownsTeam1)
                queryStringTouchdownsTeam1 = " AND " + queryColumnTouchdownsTeam1 + queryOperatorTouchdownsTeam1 + queryValueTouchdownsTeam1
            } else {
                if touchdownsTeam1SliderValuePlayer == -10000 {
                    queryStringTouchdownsTeam1 = ""
                } else {
                    if touchdownsTeam1OperatorValuePlayer == "≠" {
                        queryOperatorTouchdownsTeam1 = " != "
                    } else {
                        queryOperatorTouchdownsTeam1 = " " + touchdownsTeam1OperatorValuePlayer + " "
                    }
                    queryValueTouchdownsTeam1 = String(touchdownsTeam1SliderValuePlayer)
                    queryStringTouchdownsTeam1 = " AND LENGTH(\(queryColumnTouchdownsTeam1)) !=0 AND " + queryColumnTouchdownsTeam1 + queryOperatorTouchdownsTeam1 + queryValueTouchdownsTeam1
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "OPPONENT: TOUCHDOWNS" {
            queryStringTouchdownsTeam2 = ""
        } else {
            if touchdownsTeam2OperatorValuePlayer == "< >" {
                queryOperatorTouchdownsTeam2 = " BETWEEN "
                let queryLowerValueTouchdownsTeam2 = touchdownsTeam2RangeSliderLowerValuePlayer
                let queryUpperValueTouchdownsTeam2 = touchdownsTeam2RangeSliderUpperValuePlayer
                queryValueTouchdownsTeam2 = String(queryLowerValueTouchdownsTeam2) + " AND " + String(queryUpperValueTouchdownsTeam2)
                queryStringTouchdownsTeam2 = " AND " + queryColumnTouchdownsTeam2 + queryOperatorTouchdownsTeam2 + queryValueTouchdownsTeam2
            } else {
                if touchdownsTeam2SliderValuePlayer == -10000 {
                    queryStringTouchdownsTeam2 = ""
                } else {
                    if touchdownsTeam2OperatorValuePlayer == "≠" {
                        queryOperatorTouchdownsTeam2 = " != "
                    } else {
                        queryOperatorTouchdownsTeam2 = " " + touchdownsTeam2OperatorValuePlayer + " "
                    }
                    queryValueTouchdownsTeam2 = String(touchdownsTeam2SliderValuePlayer)
                    queryStringTouchdownsTeam2 = " AND LENGTH(\(queryColumnTouchdownsTeam2)) !=0 AND " + queryColumnTouchdownsTeam2 + queryOperatorTouchdownsTeam2 + queryValueTouchdownsTeam2
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "PLAYER TEAM: TURNOVERS" {
            queryStringTurnoversCommittedTeam1 = ""
        } else {
            if turnoversCommittedTeam1OperatorValuePlayer == "< >" {
                queryOperatorTurnoversCommittedTeam1 = " BETWEEN "
                let queryLowerValueTurnoversCommittedTeam1 = turnoversCommittedTeam1RangeSliderLowerValuePlayer
                let queryUpperValueTurnoversCommittedTeam1 = turnoversCommittedTeam1RangeSliderUpperValuePlayer
                queryValueTurnoversCommittedTeam1 = String(queryLowerValueTurnoversCommittedTeam1) + " AND " + String(queryUpperValueTurnoversCommittedTeam1)
                queryStringTurnoversCommittedTeam1 = " AND " + queryColumnTurnoversCommittedTeam1 + queryOperatorTurnoversCommittedTeam1 + queryValueTurnoversCommittedTeam1
            } else {
                if turnoversCommittedTeam1SliderValuePlayer == -10000 {
                    queryStringTurnoversCommittedTeam1 = ""
                } else {
                    if turnoversCommittedTeam1OperatorValuePlayer == "≠" {
                        queryOperatorTurnoversCommittedTeam1 = " != "
                    } else {
                        queryOperatorTurnoversCommittedTeam1 = " " + turnoversCommittedTeam1OperatorValuePlayer + " "
                    }
                    queryValueTurnoversCommittedTeam1 = String(turnoversCommittedTeam1SliderValuePlayer)
                    queryStringTurnoversCommittedTeam1 = " AND LENGTH(\(queryColumnTurnoversCommittedTeam1)) !=0 AND " + queryColumnTurnoversCommittedTeam1 + queryOperatorTurnoversCommittedTeam1 + queryValueTurnoversCommittedTeam1
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "OPPONENT: TURNOVERS" {
            queryStringTurnoversCommittedTeam2 = ""
        } else {
            if turnoversCommittedTeam2OperatorValuePlayer == "< >" {
                queryOperatorTurnoversCommittedTeam2 = " BETWEEN "
                let queryLowerValueTurnoversCommittedTeam2 = turnoversCommittedTeam2RangeSliderLowerValuePlayer
                let queryUpperValueTurnoversCommittedTeam2 = turnoversCommittedTeam2RangeSliderUpperValuePlayer
                queryValueTurnoversCommittedTeam2 = String(queryLowerValueTurnoversCommittedTeam2) + " AND " + String(queryUpperValueTurnoversCommittedTeam2)
                queryStringTurnoversCommittedTeam2 = " AND " + queryColumnTurnoversCommittedTeam2 + queryOperatorTurnoversCommittedTeam2 + queryValueTurnoversCommittedTeam2
            } else {
                if turnoversCommittedTeam2SliderValuePlayer == -10000 {
                    queryStringTurnoversCommittedTeam2 = ""
                } else {
                    if turnoversCommittedTeam2OperatorValuePlayer == "≠" {
                        queryOperatorTurnoversCommittedTeam2 = " != "
                    } else {
                        queryOperatorTurnoversCommittedTeam2 = " " + turnoversCommittedTeam2OperatorValuePlayer + " "
                    }
                    queryValueTurnoversCommittedTeam2 = String(turnoversCommittedTeam2SliderValuePlayer)
                    queryStringTurnoversCommittedTeam2 = " AND LENGTH(\(queryColumnPenaltiesCommittedTeam1)) !=0 AND " + queryColumnTurnoversCommittedTeam2 + queryOperatorTurnoversCommittedTeam2 + queryValueTurnoversCommittedTeam2
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "PLAYER TEAM: PENALTIES" {
            queryStringPenaltiesCommittedTeam1 = ""
        } else {
            if penaltiesCommittedTeam1OperatorValuePlayer == "< >" {
                queryOperatorPenaltiesCommittedTeam1 = " BETWEEN "
                let queryLowerValuePenaltiesCommittedTeam1 = penaltiesCommittedTeam1RangeSliderLowerValuePlayer
                let queryUpperValuePenaltiesCommittedTeam1 = penaltiesCommittedTeam1RangeSliderUpperValuePlayer
                queryValuePenaltiesCommittedTeam1 = String(queryLowerValuePenaltiesCommittedTeam1) + " AND " + String(queryUpperValuePenaltiesCommittedTeam1)
                queryStringPenaltiesCommittedTeam1 = " AND " + queryColumnPenaltiesCommittedTeam1 + queryOperatorPenaltiesCommittedTeam1 + queryValuePenaltiesCommittedTeam1
            } else {
                if penaltiesCommittedTeam1SliderValuePlayer == -10000 {
                    queryStringPenaltiesCommittedTeam1 = ""
                } else {
                    if penaltiesCommittedTeam1OperatorValuePlayer == "≠" {
                        queryOperatorPenaltiesCommittedTeam1 = " != "
                    } else {
                        queryOperatorPenaltiesCommittedTeam1 = " " + penaltiesCommittedTeam1OperatorValuePlayer + " "
                    }
                    queryValuePenaltiesCommittedTeam1 = String(penaltiesCommittedTeam1SliderValuePlayer)
                    queryStringPenaltiesCommittedTeam1 = " AND LENGTH(\(queryColumnPenaltiesCommittedTeam1)) !=0 AND " + queryColumnPenaltiesCommittedTeam1 + queryOperatorPenaltiesCommittedTeam1 + queryValuePenaltiesCommittedTeam1
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "OPPONENT: PENALTIES" {
            queryStringPenaltiesCommittedTeam2 = ""
        } else {
            if penaltiesCommittedTeam2OperatorValuePlayer == "< >" {
                queryOperatorPenaltiesCommittedTeam2 = " BETWEEN "
                let queryLowerValuePenaltiesCommittedTeam2 = penaltiesCommittedTeam2RangeSliderLowerValuePlayer
                let queryUpperValuePenaltiesCommittedTeam2 = penaltiesCommittedTeam2RangeSliderUpperValuePlayer
                queryValuePenaltiesCommittedTeam2 = String(queryLowerValuePenaltiesCommittedTeam2) + " AND " + String(queryUpperValuePenaltiesCommittedTeam2)
                queryStringPenaltiesCommittedTeam2 = " AND " + queryColumnPenaltiesCommittedTeam2 + queryOperatorPenaltiesCommittedTeam2 + queryValuePenaltiesCommittedTeam2
            } else {
                if penaltiesCommittedTeam2SliderValuePlayer == -10000 {
                    queryStringPenaltiesCommittedTeam2 = ""
                } else {
                    if penaltiesCommittedTeam2OperatorValuePlayer == "≠" {
                        queryOperatorPenaltiesCommittedTeam2 = " != "
                    } else {
                        queryOperatorPenaltiesCommittedTeam2 = " " + penaltiesCommittedTeam2OperatorValuePlayer + " "
                    }
                    queryValuePenaltiesCommittedTeam2 = String(penaltiesCommittedTeam2SliderValuePlayer)
                    queryStringPenaltiesCommittedTeam2 = " AND LENGTH(\(queryColumnPenaltiesCommittedTeam2)) !=0 AND " + queryColumnPenaltiesCommittedTeam2 + queryOperatorPenaltiesCommittedTeam2 + queryValuePenaltiesCommittedTeam2
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "PLAYER TEAM: TOTAL YARDS" {
            queryStringTotalYardsTeam1 = ""
        } else {
            if totalYardsTeam1OperatorValuePlayer == "< >" {
                queryOperatorTotalYardsTeam1 = " BETWEEN "
                let queryLowerValueTotalYardsTeam1 = totalYardsTeam1RangeSliderLowerValuePlayer
                let queryUpperValueTotalYardsTeam1 = totalYardsTeam1RangeSliderUpperValuePlayer
                queryValueTotalYardsTeam1 = String(queryLowerValueTotalYardsTeam1) + " AND " + String(queryUpperValueTotalYardsTeam1)
                queryStringTotalYardsTeam1 = " AND " + queryColumnTotalYardsTeam1 + queryOperatorTotalYardsTeam1 + queryValueTotalYardsTeam1
            } else {
                if totalYardsTeam1SliderValuePlayer == -10000 {
                    queryStringTotalYardsTeam1 = ""
                } else {
                    if totalYardsTeam1OperatorValuePlayer == "≠" {
                        queryOperatorTotalYardsTeam1 = " != "
                    } else {
                        queryOperatorTotalYardsTeam1 = " " + totalYardsTeam1OperatorValuePlayer + " "
                    }
                    queryValueTotalYardsTeam1 = String(totalYardsTeam1SliderValuePlayer)
                    queryStringTotalYardsTeam1 = " AND LENGTH(\(queryColumnTotalYardsTeam1)) !=0 AND " + queryColumnTotalYardsTeam1 + queryOperatorTotalYardsTeam1 + queryValueTotalYardsTeam1
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "OPPONENT: TOTAL YARDS" {
            queryStringTotalYardsTeam2 = ""
        } else {
            if totalYardsTeam2OperatorValuePlayer == "< >" {
                queryOperatorTotalYardsTeam2 = " BETWEEN "
                let queryLowerValueTotalYardsTeam2 = totalYardsTeam2RangeSliderLowerValuePlayer
                let queryUpperValueTotalYardsTeam2 = totalYardsTeam2RangeSliderUpperValuePlayer
                queryValueTotalYardsTeam2 = String(queryLowerValueTotalYardsTeam2) + " AND " + String(queryUpperValueTotalYardsTeam2)
                queryStringTotalYardsTeam2 = " AND " + queryColumnTotalYardsTeam2 + queryOperatorTotalYardsTeam2 + queryValueTotalYardsTeam2
            } else {
                if totalYardsTeam2SliderValuePlayer == -10000 {
                    queryStringTotalYardsTeam2 = ""
                } else {
                    if totalYardsTeam2OperatorValuePlayer == "≠" {
                        queryOperatorTotalYardsTeam2 = " != "
                    } else {
                        queryOperatorTotalYardsTeam2 = " " + totalYardsTeam2OperatorValuePlayer + " "
                    }
                    queryValueTotalYardsTeam2 = String(totalYardsTeam2SliderValuePlayer)
                    queryStringTotalYardsTeam2 = " AND LENGTH(\(queryColumnTotalYardsTeam2)) !=0 AND " + queryColumnTotalYardsTeam2 + queryOperatorTotalYardsTeam2 + queryValueTotalYardsTeam2
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "PLAYER TEAM: PASSING YARDS" {
            queryStringPassingYardsTeam1 = ""
        } else {
            if passingYardsTeam1OperatorValuePlayer == "< >" {
                queryOperatorPassingYardsTeam1 = " BETWEEN "
                let queryLowerValuePassingYardsTeam1 = passingYardsTeam1RangeSliderLowerValuePlayer
                let queryUpperValuePassingYardsTeam1 = passingYardsTeam1RangeSliderUpperValuePlayer
                queryValuePassingYardsTeam1 = String(queryLowerValuePassingYardsTeam1) + " AND " + String(queryUpperValuePassingYardsTeam1)
                queryStringPassingYardsTeam1 = " AND " + queryColumnPassingYardsTeam1 + queryOperatorPassingYardsTeam1 + queryValuePassingYardsTeam1
            } else {
                if passingYardsTeam1SliderValuePlayer == -10000 {
                    queryStringPassingYardsTeam1 = ""
                } else {
                    if passingYardsTeam1OperatorValuePlayer == "≠" {
                        queryOperatorPassingYardsTeam1 = " != "
                    } else {
                        queryOperatorPassingYardsTeam1 = " " + passingYardsTeam1OperatorValuePlayer + " "
                    }
                    queryValuePassingYardsTeam1 = String(passingYardsTeam1SliderValuePlayer)
                    queryStringPassingYardsTeam1 = " AND LENGTH(\(queryColumnPassingYardsTeam1)) !=0 AND " + queryColumnPassingYardsTeam1 + queryOperatorPassingYardsTeam1 + queryValuePassingYardsTeam1
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "OPPONENT: PASSING YARDS" {
            queryStringPassingYardsTeam2 = ""
        } else {
            if passingYardsTeam2OperatorValuePlayer == "< >" {
                queryOperatorPassingYardsTeam2 = " BETWEEN "
                let queryLowerValuePassingYardsTeam2 = passingYardsTeam2RangeSliderLowerValuePlayer
                let queryUpperValuePassingYardsTeam2 = passingYardsTeam2RangeSliderUpperValuePlayer
                queryValuePassingYardsTeam2 = String(queryLowerValuePassingYardsTeam2) + " AND " + String(queryUpperValuePassingYardsTeam2)
                queryStringPassingYardsTeam2 = " AND " + queryColumnPassingYardsTeam2 + queryOperatorPassingYardsTeam2 + queryValuePassingYardsTeam2
            } else {
                if passingYardsTeam2SliderValuePlayer == -10000 {
                    queryStringPassingYardsTeam2 = ""
                } else {
                    if passingYardsTeam2OperatorValuePlayer == "≠" {
                        queryOperatorPassingYardsTeam2 = " != "
                    } else {
                        queryOperatorPassingYardsTeam2 = " " + passingYardsTeam2OperatorValuePlayer + " "
                    }
                    queryValuePassingYardsTeam2 = String(passingYardsTeam2SliderValuePlayer)
                    queryStringPassingYardsTeam2 = " AND LENGTH(\(queryColumnPassingYardsTeam2)) !=0 AND " + queryColumnPassingYardsTeam2 + queryOperatorPassingYardsTeam2 + queryValuePassingYardsTeam2
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "PLAYER TEAM: RUSHING YARDS" {
            queryStringRushingYardsTeam1 = ""
        } else {
            if rushingYardsTeam1OperatorValuePlayer == "< >" {
                queryOperatorRushingYardsTeam1 = " BETWEEN "
                let queryLowerValueRushingYardsTeam1 = rushingYardsTeam1RangeSliderLowerValuePlayer
                let queryUpperValueRushingYardsTeam1 = rushingYardsTeam1RangeSliderUpperValuePlayer
                queryValueRushingYardsTeam1 = String(queryLowerValueRushingYardsTeam1) + " AND " + String(queryUpperValueRushingYardsTeam1)
                queryStringRushingYardsTeam1 = " AND " + queryColumnRushingYardsTeam1 + queryOperatorRushingYardsTeam1 + queryValueRushingYardsTeam1
            } else {
                if rushingYardsTeam1SliderValuePlayer == -10000 {
                    queryStringRushingYardsTeam1 = ""
                } else {
                    if rushingYardsTeam1OperatorValuePlayer == "≠" {
                        queryOperatorRushingYardsTeam1 = " != "
                    } else {
                        queryOperatorRushingYardsTeam1 = " " + rushingYardsTeam1OperatorValuePlayer + " "
                    }
                    queryValueRushingYardsTeam1 = String(rushingYardsTeam1SliderValuePlayer)
                    queryStringRushingYardsTeam1 = " AND LENGTH(\(queryColumnRushingYardsTeam1)) !=0 AND " + queryColumnRushingYardsTeam1 + queryOperatorRushingYardsTeam1 + queryValueRushingYardsTeam1
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "OPPONENT: RUSHING YARDS" {
            queryStringRushingYardsTeam2 = ""
        } else {
            if rushingYardsTeam2OperatorValuePlayer == "< >" {
                queryOperatorRushingYardsTeam2 = " BETWEEN "
                let queryLowerValueRushingYardsTeam2 = rushingYardsTeam2RangeSliderLowerValuePlayer
                let queryUpperValueRushingYardsTeam2 = rushingYardsTeam2RangeSliderUpperValuePlayer
                queryValueRushingYardsTeam2 = String(queryLowerValueRushingYardsTeam2) + " AND " + String(queryUpperValueRushingYardsTeam2)
                queryStringRushingYardsTeam2 = " AND " + queryColumnRushingYardsTeam2 + queryOperatorRushingYardsTeam2 + queryValueRushingYardsTeam2
            } else {
                if rushingYardsTeam2SliderValuePlayer == -10000 {
                    queryStringRushingYardsTeam2 = ""
                } else {
                    if rushingYardsTeam2OperatorValuePlayer == "≠" {
                        queryOperatorRushingYardsTeam2 = " != "
                    } else {
                        queryOperatorRushingYardsTeam2 = " " + rushingYardsTeam2OperatorValuePlayer + " "
                    }
                    queryValueRushingYardsTeam2 = String(rushingYardsTeam2SliderValuePlayer)
                    queryStringRushingYardsTeam2 = " AND LENGTH(\(queryColumnRushingYardsTeam2)) !=0 AND " + queryColumnRushingYardsTeam2 + queryOperatorRushingYardsTeam2 + queryValueRushingYardsTeam2
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "PLAYER TEAM: QUARTERBACK RATING" {
            queryOperatorQuarterbackRatingTeam1 = ""
        } else {
            if quarterbackRatingTeam1OperatorValuePlayer == "< >" {
                queryOperatorQuarterbackRatingTeam1 = " BETWEEN "
                let queryLowerValueQuarterbackRatingTeam1 = quarterbackRatingTeam1RangeSliderLowerValuePlayer
                let queryUpperValueQuarterbackRatingTeam1 = quarterbackRatingTeam1RangeSliderUpperValuePlayer
                queryValueQuarterbackRatingTeam1 = String(queryLowerValueQuarterbackRatingTeam1) + " AND " + String(queryUpperValueQuarterbackRatingTeam1)
                queryStringQuarterbackRatingTeam1 = " AND " + queryColumnQuarterbackRatingTeam1 + queryOperatorQuarterbackRatingTeam1 + queryValueQuarterbackRatingTeam1
            } else {
                if quarterbackRatingTeam1SliderValuePlayer == -10000 {
                    queryStringQuarterbackRatingTeam1 = ""
                } else {
                    if quarterbackRatingTeam1OperatorValuePlayer == "≠" {
                        queryOperatorQuarterbackRatingTeam1 = " != "
                    } else {
                        queryOperatorQuarterbackRatingTeam1 = " " + quarterbackRatingTeam1OperatorValuePlayer + " "
                    }
                    queryValueQuarterbackRatingTeam1 = String(quarterbackRatingTeam1SliderValuePlayer)
                    queryStringQuarterbackRatingTeam1 = " AND LENGTH(\(queryColumnQuarterbackRatingTeam1)) !=0 AND " + queryColumnQuarterbackRatingTeam1 + queryOperatorQuarterbackRatingTeam1 + queryValueQuarterbackRatingTeam1
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "OPPONENT: QUARTERBACK RATING" {
            queryStringQuarterbackRatingTeam2 = ""
        } else {
            if quarterbackRatingTeam2OperatorValuePlayer == "< >" {
                queryOperatorQuarterbackRatingTeam2 = " BETWEEN "
                let queryLowerValueQuarterbackRatingTeam2 = quarterbackRatingTeam2RangeSliderLowerValuePlayer
                let queryUpperValueQuarterbackRatingTeam2 = quarterbackRatingTeam2RangeSliderUpperValuePlayer
                queryValueQuarterbackRatingTeam2 = String(queryLowerValueQuarterbackRatingTeam2) + " AND " + String(queryUpperValueQuarterbackRatingTeam2)
                queryStringQuarterbackRatingTeam2 = " AND " + queryColumnQuarterbackRatingTeam2 + queryOperatorQuarterbackRatingTeam2 + queryValueQuarterbackRatingTeam2
            } else {
                if quarterbackRatingTeam2SliderValuePlayer == -10000 {
                    queryStringQuarterbackRatingTeam2 = ""
                } else {
                    if quarterbackRatingTeam2OperatorValuePlayer == "≠" {
                        queryOperatorQuarterbackRatingTeam2 = " != "
                    } else {
                        queryOperatorQuarterbackRatingTeam2 = " " + quarterbackRatingTeam2OperatorValuePlayer + " "
                    }
                    queryValueQuarterbackRatingTeam2 = String(quarterbackRatingTeam2SliderValuePlayer)
                    queryStringQuarterbackRatingTeam2 = " AND LENGTH(\(queryColumnQuarterbackRatingTeam2)) !=0 AND " + queryColumnQuarterbackRatingTeam2 + queryOperatorQuarterbackRatingTeam2 + queryValueQuarterbackRatingTeam2
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "PLAYER TEAM: TIMES SACKED" {
            queryStringTimesSackedTeam1 = ""
        } else {
            if timesSackedTeam1OperatorValuePlayer == "< >" {
                queryOperatorTimesSackedTeam1 = " BETWEEN "
                let queryLowerValueTimesSackedTeam1 = timesSackedTeam1RangeSliderLowerValuePlayer
                let queryUpperValueTimesSackedTeam1 = timesSackedTeam1RangeSliderUpperValuePlayer
                queryValueTimesSackedTeam1 = String(queryLowerValueTimesSackedTeam1) + " AND " + String(queryUpperValueTimesSackedTeam1)
                queryStringTimesSackedTeam1 = " AND " + queryColumnTimesSackedTeam1 + queryOperatorTimesSackedTeam1 + queryValueTimesSackedTeam1
            } else {
                if timesSackedTeam1SliderValuePlayer == -10000 {
                    queryStringTimesSackedTeam1 = ""
                } else {
                    if timesSackedTeam1OperatorValuePlayer == "≠" {
                        queryOperatorTimesSackedTeam1 = " != "
                    } else {
                        queryOperatorTimesSackedTeam1 = " " + timesSackedTeam1OperatorValuePlayer + " "
                    }
                    queryValueTimesSackedTeam1 = String(timesSackedTeam1SliderValuePlayer)
                    queryStringTimesSackedTeam1 = " AND LENGTH(\(queryColumnTimesSackedTeam1)) !=0 AND " + queryColumnTimesSackedTeam1 + queryOperatorTimesSackedTeam1 + queryValueTimesSackedTeam1
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "OPPONENT: TIMES SACKED" {
            queryStringTimesSackedTeam2 = ""
        } else {
            if timesSackedTeam2OperatorValuePlayer == "< >" {
                queryOperatorTimesSackedTeam2 = " BETWEEN "
                let queryLowerValueTimesSackedTeam2 = timesSackedTeam2RangeSliderLowerValuePlayer
                let queryUpperValueTimesSackedTeam2 = timesSackedTeam2RangeSliderUpperValuePlayer
                queryValueTimesSackedTeam2 = String(queryLowerValueTimesSackedTeam2) + " AND " + String(queryUpperValueTimesSackedTeam2)
                queryStringTimesSackedTeam2 = " AND " + queryColumnTimesSackedTeam2 + queryOperatorTimesSackedTeam2 + queryValueTimesSackedTeam2
            } else {
                if timesSackedTeam2SliderValuePlayer == -10000 {
                    queryStringTimesSackedTeam2 = ""
                } else {
                    if timesSackedTeam2OperatorValuePlayer == "≠" {
                        queryOperatorTimesSackedTeam2 = " != "
                    } else {
                        queryOperatorTimesSackedTeam2 = " " + timesSackedTeam2OperatorValuePlayer + " "
                    }
                    queryValueTimesSackedTeam2 = String(timesSackedTeam2SliderValuePlayer)
                    queryStringTimesSackedTeam2 = " AND LENGTH(\(queryColumnTimesSackedTeam2)) !=0 AND " + queryColumnTimesSackedTeam2 + queryOperatorTimesSackedTeam2 + queryValueTimesSackedTeam2
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "PLAYER TEAM: INTERCEPTIONS THROWN" {
            queryStringInterceptionsThrownTeam1 = ""
        } else {
            if interceptionsThrownTeam1OperatorValuePlayer == "< >" {
                queryOperatorInterceptionsThrownTeam1 = " BETWEEN "
                let queryLowerValueInterceptionsThrownTeam1 = interceptionsThrownTeam1RangeSliderLowerValuePlayer
                let queryUpperValueInterceptionsThrownTeam1 = interceptionsThrownTeam1RangeSliderUpperValuePlayer
                queryValueInterceptionsThrownTeam1 = String(queryLowerValueInterceptionsThrownTeam1) + " AND " + String(queryUpperValueInterceptionsThrownTeam1)
                queryStringInterceptionsThrownTeam1 = " AND " + queryColumnInterceptionsThrownTeam1 + queryOperatorInterceptionsThrownTeam1 + queryValueInterceptionsThrownTeam1
            } else {
                if interceptionsThrownTeam1SliderValuePlayer == -10000 {
                    queryStringInterceptionsThrownTeam1 = ""
                } else {
                    if interceptionsThrownTeam1OperatorValuePlayer == "≠" {
                        queryOperatorInterceptionsThrownTeam1 = " != "
                    } else {
                        queryOperatorInterceptionsThrownTeam1 = " " + interceptionsThrownTeam1OperatorValuePlayer + " "
                    }
                    queryValueInterceptionsThrownTeam1 = String(interceptionsThrownTeam1SliderValuePlayer)
                    queryStringInterceptionsThrownTeam1 = " AND LENGTH(\(queryColumnInterceptionsThrownTeam1)) !=0 AND " + queryColumnInterceptionsThrownTeam1 + queryOperatorInterceptionsThrownTeam1 + queryValueInterceptionsThrownTeam1
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "OPPONENT: INTERCEPTIONS THROWN" {
            queryStringInterceptionsThrownTeam2 = ""
        } else {
            if interceptionsThrownTeam2OperatorValuePlayer == "< >" {
                queryOperatorInterceptionsThrownTeam2 = " BETWEEN "
                let queryLowerValueInterceptionsThrownTeam2 = interceptionsThrownTeam2RangeSliderLowerValuePlayer
                let queryUpperValueInterceptionsThrownTeam2 = interceptionsThrownTeam2RangeSliderUpperValuePlayer
                queryValueInterceptionsThrownTeam2 = String(queryLowerValueInterceptionsThrownTeam2) + " AND " + String(queryUpperValueInterceptionsThrownTeam2)
                queryStringInterceptionsThrownTeam2 = " AND " + queryColumnInterceptionsThrownTeam2 + queryOperatorInterceptionsThrownTeam2 + queryValueInterceptionsThrownTeam2
            } else {
                if interceptionsThrownTeam2SliderValuePlayer == -10000 {
                    queryStringInterceptionsThrownTeam2 = ""
                } else {
                    if interceptionsThrownTeam2OperatorValuePlayer == "≠" {
                        queryOperatorInterceptionsThrownTeam2 = " != "
                    } else {
                        queryOperatorInterceptionsThrownTeam2 = " " + interceptionsThrownTeam2OperatorValuePlayer + " "
                    }
                    queryValueInterceptionsThrownTeam2 = String(interceptionsThrownTeam2SliderValuePlayer)
                    queryStringInterceptionsThrownTeam2 = " AND LENGTH(\(queryColumnInterceptionsThrownTeam2)) !=0 AND " + queryColumnInterceptionsThrownTeam2 + queryOperatorInterceptionsThrownTeam2 + queryValueInterceptionsThrownTeam2
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "PLAYER TEAM: OFFENSIVE PLAYS" {
            queryStringOffensivePlaysTeam1 = ""
        } else {
            if offensivePlaysTeam1OperatorValuePlayer == "< >" {
                queryOperatorOffensivePlaysTeam1 = " BETWEEN "
                let queryLowerValueOffensivePlaysTeam1 = offensivePlaysTeam1RangeSliderLowerValuePlayer
                let queryUpperValueOffensivePlaysTeam1 = offensivePlaysTeam1RangeSliderUpperValuePlayer
                queryValueOffensivePlaysTeam1 = String(queryLowerValueOffensivePlaysTeam1) + " AND " + String(queryUpperValueOffensivePlaysTeam1)
                queryStringOffensivePlaysTeam1 = " AND " + queryColumnOffensivePlaysTeam1 + queryOperatorOffensivePlaysTeam1 + queryValueOffensivePlaysTeam1
            } else {
                if offensivePlaysTeam1SliderValuePlayer == -10000 {
                    queryStringOffensivePlaysTeam1 = ""
                } else {
                    if offensivePlaysTeam1OperatorValuePlayer == "≠" {
                        queryOperatorOffensivePlaysTeam1 = " != "
                    } else {
                        queryOperatorOffensivePlaysTeam1 = " " + offensivePlaysTeam1OperatorValuePlayer + " "
                    }
                    queryValueOffensivePlaysTeam1 = String(offensivePlaysTeam1SliderValuePlayer)
                    queryStringOffensivePlaysTeam1 = " AND LENGTH(\(queryColumnOffensivePlaysTeam1)) !=0 AND " + queryColumnOffensivePlaysTeam1 + queryOperatorOffensivePlaysTeam1 + queryValueOffensivePlaysTeam1
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "OPPONENT: OFFENSIVE PLAYS" {
            queryStringOffensivePlaysTeam2 = ""
        } else {
            if offensivePlaysTeam2OperatorValuePlayer == "< >" {
                queryOperatorOffensivePlaysTeam2 = " BETWEEN "
                let queryLowerValueOffensivePlaysTeam2 = offensivePlaysTeam2RangeSliderLowerValuePlayer
                let queryUpperValueOffensivePlaysTeam2 = offensivePlaysTeam2RangeSliderUpperValuePlayer
                queryValueOffensivePlaysTeam2 = String(queryLowerValueOffensivePlaysTeam2) + " AND " + String(queryUpperValueOffensivePlaysTeam2)
                queryStringOffensivePlaysTeam2 = " AND " + queryColumnOffensivePlaysTeam2 + queryOperatorOffensivePlaysTeam2 + queryValueOffensivePlaysTeam2
            } else {
                if offensivePlaysTeam2SliderValuePlayer == -10000 {
                    queryStringOffensivePlaysTeam2 = ""
                } else {
                    if offensivePlaysTeam2OperatorValuePlayer == "≠" {
                        queryOperatorOffensivePlaysTeam2 = " != "
                    } else {
                        queryOperatorOffensivePlaysTeam2 = " " + offensivePlaysTeam2OperatorValuePlayer + " "
                    }
                    queryValueOffensivePlaysTeam2 = String(offensivePlaysTeam2SliderValuePlayer)
                    queryStringOffensivePlaysTeam2 = " AND LENGTH(\(queryColumnOffensivePlaysTeam2)) !=0 AND " + queryColumnOffensivePlaysTeam2 + queryOperatorOffensivePlaysTeam2 + queryValueOffensivePlaysTeam2
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "PLAYER TEAM: YARDS/OFFENSIVE PLAY" {
            queryStringYardsPerOffensivePlayTeam1 = ""
        } else {
            if yardsPerOffensivePlayTeam1OperatorValuePlayer == "< >" {
                queryOperatorYardsPerOffensivePlayTeam1 = " BETWEEN "
                let queryLowerValueYardsPerOffensivePlayTeam1 = yardsPerOffensivePlayTeam1RangeSliderLowerValuePlayer
                let queryUpperValueYardsPerOffensivePlayTeam1 = yardsPerOffensivePlayTeam1RangeSliderUpperValuePlayer
                queryValueYardsPerOffensivePlayTeam1 = String(queryLowerValueYardsPerOffensivePlayTeam1) + " AND " + String(queryUpperValueYardsPerOffensivePlayTeam1)
                queryStringYardsPerOffensivePlayTeam1 = " AND " + queryColumnYardsPerOffensivePlayTeam1 + queryOperatorYardsPerOffensivePlayTeam1 + queryValueYardsPerOffensivePlayTeam1
            } else {
                if yardsPerOffensivePlayTeam1SliderValuePlayer == -10000 {
                    queryStringYardsPerOffensivePlayTeam1 = ""
                } else {
                    if yardsPerOffensivePlayTeam1OperatorValuePlayer == "≠" {
                        queryOperatorYardsPerOffensivePlayTeam1 = " != "
                    } else {
                        queryOperatorYardsPerOffensivePlayTeam1 = " " + yardsPerOffensivePlayTeam1OperatorValuePlayer + " "
                    }
                    queryValueYardsPerOffensivePlayTeam1 = String(yardsPerOffensivePlayTeam1SliderValuePlayer)
                    queryStringYardsPerOffensivePlayTeam1 = " AND LENGTH(\(queryColumnYardsPerOffensivePlayTeam1)) !=0 AND " + queryColumnYardsPerOffensivePlayTeam1 + queryOperatorYardsPerOffensivePlayTeam1 + queryValueYardsPerOffensivePlayTeam1
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "OPPONENT: YARDS/OFFENSIVE PLAY" {
            queryStringYardsPerOffensivePlayTeam2 = ""
        } else {
            if yardsPerOffensivePlayTeam2OperatorValuePlayer == "< >" {
                queryOperatorYardsPerOffensivePlayTeam2 = " BETWEEN "
                let queryLowerValueYardsPerOffensivePlayTeam2 = yardsPerOffensivePlayTeam2RangeSliderLowerValuePlayer
                let queryUpperValueYardsPerOffensivePlayTeam2 = yardsPerOffensivePlayTeam2RangeSliderUpperValuePlayer
                queryValueYardsPerOffensivePlayTeam2 = String(queryLowerValueYardsPerOffensivePlayTeam2) + " AND " + String(queryUpperValueYardsPerOffensivePlayTeam2)
                queryStringYardsPerOffensivePlayTeam2 = " AND " + queryColumnYardsPerOffensivePlayTeam2 + queryOperatorYardsPerOffensivePlayTeam2 + queryValueYardsPerOffensivePlayTeam2
            } else {
                if yardsPerOffensivePlayTeam2SliderValuePlayer == -10000 {
                    queryStringYardsPerOffensivePlayTeam2 = ""
                } else {
                    if yardsPerOffensivePlayTeam2OperatorValuePlayer == "≠" {
                        queryOperatorYardsPerOffensivePlayTeam2 = " != "
                    } else {
                        queryOperatorYardsPerOffensivePlayTeam2 = " " + yardsPerOffensivePlayTeam2OperatorValuePlayer + " "
                    }
                    queryValueYardsPerOffensivePlayTeam2 = String(yardsPerOffensivePlayTeam2SliderValuePlayer)
                    queryStringYardsPerOffensivePlayTeam2 = " AND LENGTH(\(queryColumnYardsPerOffensivePlayTeam2)) !=0 AND " + queryColumnYardsPerOffensivePlayTeam2 + queryOperatorYardsPerOffensivePlayTeam2 + queryValueYardsPerOffensivePlayTeam2
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "PLAYER TEAM: SACKS" {
            queryValueSacksTeam1 = ""
        } else {
            if sacksTeam1OperatorValuePlayer == "< >" {
                queryOperatorSacksTeam1 = " BETWEEN "
                let queryLowerValueSacksTeam1 = sacksTeam1RangeSliderLowerValuePlayer
                let queryUpperValueSacksTeam1 = sacksTeam1RangeSliderUpperValuePlayer
                queryValueSacksTeam1 = String(queryLowerValueSacksTeam1) + " AND " + String(queryUpperValueSacksTeam1)
                queryStringSacksTeam1 = " AND " + queryColumnSacksTeam1 + queryOperatorSacksTeam1 + queryValueSacksTeam1
            } else {
                if sacksTeam1SliderValuePlayer == -10000 {
                    queryStringSacksTeam1 = ""
                } else {
                    if sacksTeam1OperatorValuePlayer == "≠" {
                        queryOperatorSacksTeam1 = " != "
                    } else {
                        queryOperatorSacksTeam1 = " " + sacksTeam1OperatorValuePlayer + " "
                    }
                    queryValueSacksTeam1 = String(sacksTeam1SliderValuePlayer)
                    queryStringSacksTeam1 = " AND LENGTH(\(queryColumnSacksTeam1)) !=0 AND " + queryColumnSacksTeam1 + queryOperatorSacksTeam1 + queryValueSacksTeam1
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "OPPONENT: SACKS" {
            queryValueSacksTeam2 = ""
        } else {
            if sacksTeam2OperatorValuePlayer == "< >" {
                queryOperatorSacksTeam2 = " BETWEEN "
                let queryLowerValueSacksTeam2 = sacksTeam2RangeSliderLowerValuePlayer
                let queryUpperValueSacksTeam2 = sacksTeam2RangeSliderUpperValuePlayer
                queryValueSacksTeam2 = String(queryLowerValueSacksTeam2) + " AND " + String(queryUpperValueSacksTeam2)
                queryStringSacksTeam2 = " AND " + queryColumnSacksTeam2 + queryOperatorSacksTeam2 + queryValueSacksTeam2
            } else {
                if sacksTeam2SliderValuePlayer == -10000 {
                    queryStringSacksTeam2 = ""
                } else {
                    if sacksTeam2OperatorValuePlayer == "≠" {
                        queryOperatorSacksTeam2 = " != "
                    } else {
                        queryOperatorSacksTeam2 = " " + sacksTeam2OperatorValuePlayer + " "
                    }
                    queryValueSacksTeam2 = String(sacksTeam2SliderValuePlayer)
                    queryStringSacksTeam2 = " AND LENGTH(\(queryColumnSacksTeam2)) !=0 AND " + queryColumnSacksTeam2 + queryOperatorSacksTeam2 + queryValueSacksTeam2
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "PLAYER TEAM: INTERCEPTIONS" {
            queryStringInterceptionsTeam1 = ""
        } else {
            if interceptionsTeam1OperatorValuePlayer == "< >" {
                queryOperatorInterceptionsTeam1 = " BETWEEN "
                let queryLowerValueInterceptionsTeam1 = interceptionsTeam1RangeSliderLowerValuePlayer
                let queryUpperValueInterceptionsTeam1 = interceptionsTeam1RangeSliderUpperValuePlayer
                queryValueInterceptionsTeam1 = String(queryLowerValueInterceptionsTeam1) + " AND " + String(queryUpperValueInterceptionsTeam1)
                queryStringInterceptionsTeam1 = " AND " + queryColumnInterceptionsTeam1 + queryOperatorInterceptionsTeam1 + queryValueInterceptionsTeam1
            } else {
                if interceptionsTeam1SliderValuePlayer == -10000 {
                    queryStringInterceptionsTeam1 = ""
                } else {
                    if interceptionsTeam1OperatorValuePlayer == "≠" {
                        queryOperatorInterceptionsTeam1 = " != "
                    } else {
                        queryOperatorInterceptionsTeam1 = " " + interceptionsTeam1OperatorValuePlayer + " "
                    }
                    queryValueInterceptionsTeam1 = String(interceptionsTeam1SliderValuePlayer)
                    queryStringInterceptionsTeam1 = " AND LENGTH(\(queryColumnInterceptionsTeam1)) !=0 AND " + queryColumnInterceptionsTeam1 + queryOperatorInterceptionsTeam1 + queryValueInterceptionsTeam1
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "OPPONENT: INTERCEPTIONS" {
            queryStringInterceptionsTeam2 = ""
        } else {
            if interceptionsTeam2OperatorValuePlayer == "< >" {
                queryOperatorInterceptionsTeam2 = " BETWEEN "
                let queryLowerValueInterceptionsTeam2 = interceptionsTeam2RangeSliderLowerValuePlayer
                let queryUpperValueInterceptionsTeam2 = interceptionsTeam2RangeSliderUpperValuePlayer
                queryValueInterceptionsTeam2 = String(queryLowerValueInterceptionsTeam2) + " AND " + String(queryUpperValueInterceptionsTeam2)
                queryStringInterceptionsTeam2 = " AND " + queryColumnInterceptionsTeam2 + queryOperatorInterceptionsTeam2 + queryValueInterceptionsTeam2
            } else {
                if interceptionsTeam2SliderValuePlayer == -10000 {
                    queryStringInterceptionsTeam2 = ""
                } else {
                    if interceptionsTeam2OperatorValuePlayer == "≠" {
                        queryOperatorInterceptionsTeam2 = " != "
                    } else {
                        queryOperatorInterceptionsTeam2 = " " + interceptionsTeam2OperatorValuePlayer + " "
                    }
                    queryValueInterceptionsTeam2 = String(interceptionsTeam2SliderValuePlayer)
                    queryStringInterceptionsTeam2 = " AND LENGTH(\(queryColumnInterceptionsTeam2)) !=0 AND " + queryColumnInterceptionsTeam2 + queryOperatorInterceptionsTeam2 + queryValueInterceptionsTeam2
                }
                
            }
        }
        
        if clearSliderIndicatorPlayer == "PLAYER TEAM: SAFETIES" {
            queryValueSafetiesTeam1 = ""
        } else {
            if safetiesTeam1OperatorValuePlayer == "< >" {
                queryOperatorSafetiesTeam1 = " BETWEEN "
                let queryLowerValueSafetiesTeam1 = safetiesTeam1RangeSliderLowerValuePlayer
                let queryUpperValueSafetiesTeam1 = safetiesTeam1RangeSliderUpperValuePlayer
                queryValueSafetiesTeam1 = String(queryLowerValueSafetiesTeam1) + " AND " + String(queryUpperValueSafetiesTeam1)
                queryStringSafetiesTeam1 = " AND " + queryColumnSafetiesTeam1 + queryOperatorSafetiesTeam1 + queryValueSafetiesTeam1
            } else {
                if safetiesTeam1SliderValuePlayer == -10000 {
                    queryStringSafetiesTeam1 = ""
                } else {
                    if safetiesTeam1OperatorValuePlayer == "≠" {
                        queryOperatorSafetiesTeam1 = " != "
                    } else {
                        queryOperatorSafetiesTeam1 = " " + safetiesTeam1OperatorValuePlayer + " "
                    }
                    queryValueSafetiesTeam1 = String(safetiesTeam1SliderValuePlayer)
                    queryStringSafetiesTeam1 = " AND LENGTH(\(queryColumnSafetiesTeam1)) !=0 AND " + queryColumnSafetiesTeam1 + queryOperatorSafetiesTeam1 + queryValueSafetiesTeam1
                }
                
            }
        }
        
        if clearSliderIndicatorPlayer == "OPPONENT: SAFETIES" {
            queryValueSafetiesTeam2 = ""
        } else {
            if safetiesTeam2OperatorValuePlayer == "< >" {
                queryOperatorSafetiesTeam2 = " BETWEEN "
                let queryLowerValueSafetiesTeam2 = safetiesTeam2RangeSliderLowerValuePlayer
                let queryUpperValueSafetiesTeam2 = safetiesTeam2RangeSliderUpperValuePlayer
                queryValueSafetiesTeam2 = String(queryLowerValueSafetiesTeam2) + " AND " + String(queryUpperValueSafetiesTeam2)
                queryStringSafetiesTeam2 = " AND " + queryColumnSafetiesTeam2 + queryOperatorSafetiesTeam2 + queryValueSafetiesTeam2
            } else {
                if safetiesTeam2SliderValuePlayer == -10000 {
                    queryStringSafetiesTeam2 = ""
                } else {
                    if safetiesTeam2OperatorValuePlayer == "≠" {
                        queryOperatorSafetiesTeam2 = " != "
                    } else {
                        queryOperatorSafetiesTeam2 = " " + safetiesTeam2OperatorValuePlayer + " "
                    }
                    queryValueSafetiesTeam2 = String(safetiesTeam2SliderValuePlayer)
                    queryStringSafetiesTeam2 = " AND LENGTH(\(queryColumnSafetiesTeam2)) !=0 AND " + queryColumnSafetiesTeam2 + queryOperatorSafetiesTeam2 + queryValueSafetiesTeam2
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "PLAYER TEAM: DEFENSIVE PLAYS" {
            queryStringDefensivePlaysTeam1 = ""
        } else {
            if defensivePlaysTeam1OperatorValuePlayer == "< >" {
                queryOperatorDefensivePlaysTeam1 = " BETWEEN "
                let queryLowerValueDefensivePlaysTeam1 = defensivePlaysTeam1RangeSliderLowerValuePlayer
                let queryUpperValueDefensivePlaysTeam1 = defensivePlaysTeam1RangeSliderUpperValuePlayer
                queryValueDefensivePlaysTeam1 = String(queryLowerValueDefensivePlaysTeam1) + " AND " + String(queryUpperValueDefensivePlaysTeam1)
                queryStringDefensivePlaysTeam1 = " AND " + queryColumnDefensivePlaysTeam1 + queryOperatorDefensivePlaysTeam1 + queryValueDefensivePlaysTeam1
            } else {
                if defensivePlaysTeam1SliderValuePlayer == -10000 {
                    queryStringDefensivePlaysTeam1 = ""
                } else {
                    if defensivePlaysTeam1OperatorValuePlayer == "≠" {
                        queryOperatorDefensivePlaysTeam1 = " != "
                    } else {
                        queryOperatorDefensivePlaysTeam1 = " " + defensivePlaysTeam1OperatorValuePlayer + " "
                    }
                    queryValueDefensivePlaysTeam1 = String(defensivePlaysTeam1SliderValuePlayer)
                    queryStringDefensivePlaysTeam1 = " AND LENGTH(\(queryColumnDefensivePlaysTeam1)) !=0 AND " + queryColumnDefensivePlaysTeam1 + queryOperatorDefensivePlaysTeam1 + queryValueDefensivePlaysTeam1
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "OPPONENT: DEFENSIVE PLAYS" {
            queryStringDefensivePlaysTeam2 = ""
        } else {
            if defensivePlaysTeam2OperatorValuePlayer == "< >" {
                queryOperatorDefensivePlaysTeam2 = " BETWEEN "
                let queryLowerValueDefensivePlaysTeam2 = defensivePlaysTeam2RangeSliderLowerValuePlayer
                let queryUpperValueDefensivePlaysTeam2 = defensivePlaysTeam2RangeSliderUpperValuePlayer
                queryValueDefensivePlaysTeam2 = String(queryLowerValueDefensivePlaysTeam2) + " AND " + String(queryUpperValueDefensivePlaysTeam2)
                queryStringDefensivePlaysTeam2 = " AND " + queryColumnDefensivePlaysTeam2 + queryOperatorDefensivePlaysTeam2 + queryValueDefensivePlaysTeam2
            } else {
                if defensivePlaysTeam2SliderValuePlayer == -10000 {
                    queryStringDefensivePlaysTeam2 = ""
                } else {
                    if defensivePlaysTeam2OperatorValuePlayer == "≠" {
                        queryOperatorDefensivePlaysTeam2 = " != "
                    } else {
                        queryOperatorDefensivePlaysTeam2 = " " + defensivePlaysTeam2OperatorValuePlayer + " "
                    }
                    queryValueDefensivePlaysTeam2 = String(defensivePlaysTeam2SliderValuePlayer)
                    queryStringDefensivePlaysTeam2 = " AND LENGTH(\(queryColumnDefensivePlaysTeam2)) !=0 AND " + queryColumnDefensivePlaysTeam2 + queryOperatorDefensivePlaysTeam2 + queryValueDefensivePlaysTeam2
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "PLAYER TEAM: YARDS/DEFENSIVE PLAY" {
            queryStringYardsPerDefensivePlayTeam1 = ""
        } else {
            if yardsPerDefensivePlayTeam1OperatorValuePlayer == "< >" {
                queryOperatorYardsPerDefensivePlayTeam1 = " BETWEEN "
                let queryLowerValueYardsPerDefensivePlayTeam1 = yardsPerDefensivePlayTeam1RangeSliderLowerValuePlayer
                let queryUpperValueYardsPerDefensivePlayTeam1 = yardsPerDefensivePlayTeam1RangeSliderUpperValuePlayer
                queryValueYardsPerDefensivePlayTeam1 = String(queryLowerValueYardsPerDefensivePlayTeam1) + " AND " + String(queryUpperValueYardsPerDefensivePlayTeam1)
                queryStringYardsPerDefensivePlayTeam1 = " AND " + queryColumnYardsPerDefensivePlayTeam1 + queryOperatorYardsPerDefensivePlayTeam1 + queryValueYardsPerDefensivePlayTeam1
            } else {
                if yardsPerDefensivePlayTeam1SliderValuePlayer == -10000 {
                    queryStringYardsPerDefensivePlayTeam1 = ""
                } else {
                    if yardsPerDefensivePlayTeam1OperatorValuePlayer == "≠" {
                        queryOperatorYardsPerDefensivePlayTeam1 = " != "
                    } else {
                        queryOperatorYardsPerDefensivePlayTeam1 = " " + yardsPerDefensivePlayTeam1OperatorValuePlayer + " "
                    }
                    queryValueYardsPerDefensivePlayTeam1 = String(yardsPerDefensivePlayTeam1SliderValuePlayer)
                    queryStringYardsPerDefensivePlayTeam1 = " AND LENGTH(\(queryColumnYardsPerDefensivePlayTeam1)) !=0 AND " + queryColumnYardsPerDefensivePlayTeam1 + queryOperatorYardsPerDefensivePlayTeam1 + queryValueYardsPerDefensivePlayTeam1
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "OPPONENT: YARDS/DEFENSIVE PLAY" {
            queryStringYardsPerDefensivePlayTeam2 = ""
        } else {
            if yardsPerDefensivePlayTeam2OperatorValuePlayer == "< >" {
                queryOperatorYardsPerDefensivePlayTeam2 = " BETWEEN "
                let queryLowerValueYardsPerDefensivePlayTeam2 = yardsPerDefensivePlayTeam2RangeSliderLowerValuePlayer
                let queryUpperValueYardsPerDefensivePlayTeam2 = yardsPerDefensivePlayTeam2RangeSliderUpperValuePlayer
                queryValueYardsPerDefensivePlayTeam2 = String(queryLowerValueYardsPerDefensivePlayTeam2) + " AND " + String(queryUpperValueYardsPerDefensivePlayTeam2)
                queryStringYardsPerDefensivePlayTeam2 = " AND " + queryColumnYardsPerDefensivePlayTeam2 + queryOperatorYardsPerDefensivePlayTeam2 + queryValueYardsPerDefensivePlayTeam2
            } else {
                if yardsPerDefensivePlayTeam2SliderValuePlayer == -10000 {
                    queryStringYardsPerDefensivePlayTeam2 = ""
                } else {
                    if yardsPerDefensivePlayTeam2OperatorValuePlayer == "≠" {
                        queryOperatorYardsPerDefensivePlayTeam2 = " != "
                    } else {
                        queryOperatorYardsPerDefensivePlayTeam2 = " " + yardsPerDefensivePlayTeam2OperatorValuePlayer + " "
                    }
                    queryValueYardsPerDefensivePlayTeam2 = String(yardsPerDefensivePlayTeam2SliderValuePlayer)
                    queryStringYardsPerDefensivePlayTeam2 = " AND LENGTH(\(queryColumnYardsPerDefensivePlayTeam2)) !=0 AND " + queryColumnYardsPerDefensivePlayTeam2 + queryOperatorYardsPerDefensivePlayTeam2 + queryValueYardsPerDefensivePlayTeam2
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "PLAYER TEAM: EXTRA POINT ATTEMPTS" {
            queryStringExtraPointAttemptsTeam1 = ""
        } else {
            if extraPointAttemptsTeam1OperatorValuePlayer == "< >" {
                queryOperatorExtraPointAttemptsTeam1 = " BETWEEN "
                let queryLowerValueExtraPointAttemptsTeam1 = extraPointAttemptsTeam1RangeSliderLowerValuePlayer
                let queryUpperValueExtraPointAttemptsTeam1 = extraPointAttemptsTeam1RangeSliderUpperValuePlayer
                queryValueExtraPointAttemptsTeam1 = String(queryLowerValueExtraPointAttemptsTeam1) + " AND " + String(queryUpperValueExtraPointAttemptsTeam1)
                queryStringExtraPointAttemptsTeam1 = " AND " + queryColumnExtraPointAttemptsTeam1 + queryOperatorExtraPointAttemptsTeam1 + queryValueExtraPointAttemptsTeam1
            } else {
                if extraPointAttemptsTeam1SliderValuePlayer == -10000 {
                    queryStringExtraPointAttemptsTeam1 = ""
                } else {
                    if extraPointAttemptsTeam1OperatorValuePlayer == "≠" {
                        queryOperatorExtraPointAttemptsTeam1 = " != "
                    } else {
                        queryOperatorExtraPointAttemptsTeam1 = " " + extraPointAttemptsTeam1OperatorValuePlayer + " "
                    }
                    queryValueExtraPointAttemptsTeam1 = String(extraPointAttemptsTeam1SliderValuePlayer)
                    queryStringExtraPointAttemptsTeam1 = " AND LENGTH(\(queryColumnExtraPointAttemptsTeam1)) !=0 AND " + queryColumnExtraPointAttemptsTeam1 + queryOperatorExtraPointAttemptsTeam1 + queryValueExtraPointAttemptsTeam1
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "OPPONENT: EXTRA POINTS ATTEMPTS" {
            queryStringExtraPointAttemptsTeam2 = ""
        } else {
            if extraPointAttemptsTeam2OperatorValuePlayer == "< >" {
                queryOperatorExtraPointAttemptsTeam2 = " BETWEEN "
                let queryLowerValueExtraPointAttemptsTeam2 = extraPointAttemptsTeam2RangeSliderLowerValuePlayer
                let queryUpperValueExtraPointAttemptsTeam2 = extraPointAttemptsTeam2RangeSliderUpperValuePlayer
                queryValueExtraPointAttemptsTeam2 = String(queryLowerValueExtraPointAttemptsTeam2) + " AND " + String(queryUpperValueExtraPointAttemptsTeam2)
                queryStringExtraPointAttemptsTeam2 = " AND " + queryColumnExtraPointAttemptsTeam2 + queryOperatorExtraPointAttemptsTeam2 + queryValueExtraPointAttemptsTeam2
            } else {
                if extraPointAttemptsTeam2SliderValuePlayer == -10000 {
                    queryStringExtraPointAttemptsTeam2 = ""
                } else {
                    if extraPointAttemptsTeam2OperatorValuePlayer == "≠" {
                        queryOperatorExtraPointAttemptsTeam2 = " != "
                    } else {
                        queryOperatorExtraPointAttemptsTeam2 = " " + extraPointAttemptsTeam2OperatorValuePlayer + " "
                    }
                    queryValueExtraPointAttemptsTeam2 = String(extraPointAttemptsTeam2SliderValuePlayer)
                    queryStringExtraPointAttemptsTeam2 = " AND LENGTH(\(queryColumnExtraPointAttemptsTeam2)) !=0 AND " + queryColumnExtraPointAttemptsTeam2 + queryOperatorExtraPointAttemptsTeam2 + queryValueExtraPointAttemptsTeam2
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "PLAYER TEAM: EXTRA POINTS MADE" {
            queryStringExtraPointsMadeTeam1 = ""
        } else {
            if extraPointsMadeTeam1OperatorValuePlayer == "< >" {
                queryOperatorExtraPointsMadeTeam1 = " BETWEEN "
                let queryLowerValueExtraPointsMadeTeam1 = extraPointsMadeTeam1RangeSliderLowerValuePlayer
                let queryUpperValueExtraPointsMadeTeam1 = extraPointsMadeTeam1RangeSliderUpperValuePlayer
                queryValueExtraPointsMadeTeam1 = String(queryLowerValueExtraPointsMadeTeam1) + " AND " + String(queryUpperValueExtraPointsMadeTeam1)
                queryStringExtraPointsMadeTeam1 = " AND " + queryColumnExtraPointsMadeTeam1 + queryOperatorExtraPointsMadeTeam1 + queryValueExtraPointsMadeTeam1
            } else {
                if extraPointsMadeTeam1SliderValuePlayer == -10000 {
                    queryStringExtraPointsMadeTeam1 = ""
                } else {
                    if extraPointsMadeTeam1OperatorValuePlayer == "≠" {
                        queryOperatorExtraPointsMadeTeam1 = " != "
                    } else {
                        queryOperatorExtraPointsMadeTeam1 = " " + extraPointsMadeTeam1OperatorValuePlayer + " "
                    }
                    queryValueExtraPointsMadeTeam1 = String(extraPointsMadeTeam1SliderValuePlayer)
                    queryStringExtraPointsMadeTeam1 = " AND LENGTH(\(queryColumnExtraPointsMadeTeam1)) !=0 AND " + queryColumnExtraPointsMadeTeam1 + queryOperatorExtraPointsMadeTeam1 + queryValueExtraPointsMadeTeam1
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "OPPONENT: EXTRA POINTS MADE" {
            queryStringExtraPointsMadeTeam2 = ""
        } else {
            if extraPointsMadeTeam2OperatorValuePlayer == "< >" {
                queryOperatorExtraPointsMadeTeam2 = " BETWEEN "
                let queryLowerValueExtraPointsMadeTeam2 = extraPointsMadeTeam2RangeSliderLowerValuePlayer
                let queryUpperValueExtraPointsMadeTeam2 = extraPointsMadeTeam2RangeSliderUpperValuePlayer
                queryValueExtraPointsMadeTeam2 = String(queryLowerValueExtraPointsMadeTeam2) + " AND " + String(queryUpperValueExtraPointsMadeTeam2)
                queryStringExtraPointsMadeTeam2 = " AND " + queryColumnExtraPointsMadeTeam2 + queryOperatorExtraPointsMadeTeam2 + queryValueExtraPointsMadeTeam2
            } else {
                if extraPointsMadeTeam2SliderValuePlayer == -10000 {
                    queryStringExtraPointsMadeTeam2 = ""
                } else {
                    if extraPointsMadeTeam2OperatorValuePlayer == "≠" {
                        queryOperatorExtraPointsMadeTeam2 = " != "
                    } else {
                        queryOperatorExtraPointsMadeTeam2 = " " + extraPointsMadeTeam2OperatorValuePlayer + " "
                    }
                    queryValueExtraPointsMadeTeam2 = String(extraPointsMadeTeam2SliderValuePlayer)
                    queryStringExtraPointsMadeTeam2 = " AND LENGTH(\(queryColumnExtraPointsMadeTeam2)) !=0 AND " + queryColumnExtraPointsMadeTeam2 + queryOperatorExtraPointsMadeTeam2 + queryValueExtraPointsMadeTeam2
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "PLAYER TEAM: FIELD GOAL ATTEMPTS" {
            queryStringFieldGoalAttemptsTeam1 = ""
        } else {
            if fieldGoalAttemptsTeam1OperatorValuePlayer == "< >" {
                queryOperatorFieldGoalAttemptsTeam1 = " BETWEEN "
                let queryLowerValueFieldGoalAttemptsTeam1 = fieldGoalAttemptsTeam1RangeSliderLowerValuePlayer
                let queryUpperValueFieldGoalAttemptsTeam1 = fieldGoalAttemptsTeam1RangeSliderUpperValuePlayer
                queryValueFieldGoalAttemptsTeam1 = String(queryLowerValueFieldGoalAttemptsTeam1) + " AND " + String(queryUpperValueFieldGoalAttemptsTeam1)
                queryStringFieldGoalAttemptsTeam1 = " AND " + queryColumnFieldGoalAttemptsTeam1 + queryOperatorFieldGoalAttemptsTeam1 + queryValueFieldGoalAttemptsTeam1
            } else {
                if fieldGoalAttemptsTeam1SliderValuePlayer == -10000 {
                    queryStringFieldGoalAttemptsTeam1 = ""
                } else {
                    if fieldGoalAttemptsTeam1OperatorValuePlayer == "≠" {
                        queryOperatorFieldGoalAttemptsTeam1 = " != "
                    } else {
                        queryOperatorFieldGoalAttemptsTeam1 = " " + fieldGoalAttemptsTeam1OperatorValuePlayer + " "
                    }
                    queryValueFieldGoalAttemptsTeam1 = String(fieldGoalAttemptsTeam1SliderValuePlayer)
                    queryStringFieldGoalAttemptsTeam1 = " AND LENGTH(\(queryColumnFieldGoalAttemptsTeam1)) !=0 AND " + queryColumnFieldGoalAttemptsTeam1 + queryOperatorFieldGoalAttemptsTeam1 + queryValueFieldGoalAttemptsTeam1
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "OPPONENT: FIELD GOAL ATTEMPTS" {
            queryStringFieldGoalAttemptsTeam2 = ""
        } else {
            if fieldGoalAttemptsTeam2OperatorValuePlayer == "< >" {
                queryOperatorFieldGoalAttemptsTeam2 = " BETWEEN "
                let queryLowerValueFieldGoalAttemptsTeam2 = fieldGoalAttemptsTeam2RangeSliderLowerValuePlayer
                let queryUpperValueFieldGoalAttemptsTeam2 = fieldGoalAttemptsTeam2RangeSliderUpperValuePlayer
                queryValueFieldGoalAttemptsTeam2 = String(queryLowerValueFieldGoalAttemptsTeam2) + " AND " + String(queryUpperValueFieldGoalAttemptsTeam2)
                queryStringFieldGoalAttemptsTeam2 = " AND " + queryColumnFieldGoalAttemptsTeam2 + queryOperatorFieldGoalAttemptsTeam2 + queryValueFieldGoalAttemptsTeam2
            } else {
                if fieldGoalAttemptsTeam2SliderValuePlayer == -10000 {
                    queryStringFieldGoalAttemptsTeam2 = ""
                } else {
                    if fieldGoalAttemptsTeam2OperatorValuePlayer == "≠" {
                        queryOperatorFieldGoalAttemptsTeam2 = " != "
                    } else {
                        queryOperatorFieldGoalAttemptsTeam2 = " " + fieldGoalAttemptsTeam2OperatorValuePlayer + " "
                    }
                    queryValueFieldGoalAttemptsTeam2 = String(fieldGoalAttemptsTeam2SliderValuePlayer)
                    queryStringFieldGoalAttemptsTeam2 = " AND LENGTH(\(queryColumnFieldGoalAttemptsTeam2)) !=0 AND " + queryColumnFieldGoalAttemptsTeam2 + queryOperatorFieldGoalAttemptsTeam2 + queryValueFieldGoalAttemptsTeam2
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "PLAYER TEAM: FIELD GOALS MADE" {
            queryStringFieldGoalsMadeTeam1 = ""
        } else {
            if fieldGoalsMadeTeam1OperatorValuePlayer == "< >" {
                queryOperatorFieldGoalsMadeTeam1 = " BETWEEN "
                let queryLowerValueFieldGoalsMadeTeam1 = fieldGoalsMadeTeam1RangeSliderLowerValuePlayer
                let queryUpperValueFieldGoalsMadeTeam1 = fieldGoalsMadeTeam1RangeSliderUpperValuePlayer
                queryValueFieldGoalsMadeTeam1 = String(queryLowerValueFieldGoalsMadeTeam1) + " AND " + String(queryUpperValueFieldGoalsMadeTeam1)
                queryStringFieldGoalsMadeTeam1 = " AND " + queryColumnFieldGoalsMadeTeam1 + queryOperatorFieldGoalsMadeTeam1 + queryValueFieldGoalsMadeTeam1
            } else {
                if fieldGoalsMadeTeam1SliderValuePlayer == -10000 {
                    queryStringFieldGoalsMadeTeam1 = ""
                } else {
                    if fieldGoalsMadeTeam1OperatorValuePlayer == "≠" {
                        queryOperatorFieldGoalsMadeTeam1 = " != "
                    } else {
                        queryOperatorFieldGoalsMadeTeam1 = " " + fieldGoalsMadeTeam1OperatorValuePlayer + " "
                    }
                    queryValueFieldGoalsMadeTeam1 = String(fieldGoalsMadeTeam1SliderValuePlayer)
                    queryStringFieldGoalsMadeTeam1 = " AND LENGTH(\(queryColumnFieldGoalsMadeTeam1)) !=0 AND " + queryColumnFieldGoalsMadeTeam1 + queryOperatorFieldGoalsMadeTeam1 + queryValueFieldGoalsMadeTeam1
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "OPPONENT: FIELD GOALS MADE" {
            queryStringFieldGoalsMadeTeam2 = ""
        } else {
            if fieldGoalsMadeTeam2OperatorValuePlayer == "< >" {
                queryOperatorFieldGoalsMadeTeam2 = " BETWEEN "
                let queryLowerValueFieldGoalsMadeTeam2 = fieldGoalsMadeTeam2RangeSliderLowerValuePlayer
                let queryUpperValueFieldGoalsMadeTeam2 = fieldGoalsMadeTeam2RangeSliderUpperValuePlayer
                queryValueFieldGoalsMadeTeam2 = String(queryLowerValueFieldGoalsMadeTeam2) + " AND " + String(queryUpperValueFieldGoalsMadeTeam2)
                queryStringFieldGoalsMadeTeam2 = " AND " + queryColumnFieldGoalsMadeTeam2 + queryOperatorFieldGoalsMadeTeam2 + queryValueFieldGoalsMadeTeam2
            } else {
                if fieldGoalsMadeTeam2SliderValuePlayer == -10000 {
                    queryStringFieldGoalsMadeTeam2 = ""
                } else {
                    if fieldGoalsMadeTeam2OperatorValuePlayer == "≠" {
                        queryOperatorFieldGoalsMadeTeam2 = " != "
                    } else {
                        queryOperatorFieldGoalsMadeTeam2 = " " + fieldGoalsMadeTeam2OperatorValuePlayer + " "
                    }
                    queryValueFieldGoalsMadeTeam2 = String(fieldGoalsMadeTeam2SliderValuePlayer)
                    queryStringFieldGoalsMadeTeam2 = " AND LENGTH(\(queryColumnFieldGoalsMadeTeam2)) !=0 AND " + queryColumnFieldGoalsMadeTeam2 + queryOperatorFieldGoalsMadeTeam2 + queryValueFieldGoalsMadeTeam2
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "PLAYER TEAM: PUNTS" {
            queryStringPuntsTeam1 = ""
        } else {
            if puntsTeam1OperatorValuePlayer == "< >" {
                queryOperatorPuntsTeam1 = " BETWEEN "
                let queryLowerValuePuntsTeam1 = puntsTeam1RangeSliderLowerValuePlayer
                let queryUpperValuePuntsTeam1 = puntsTeam1RangeSliderUpperValuePlayer
                queryValuePuntsTeam1 = String(queryLowerValuePuntsTeam1) + " AND " + String(queryUpperValuePuntsTeam1)
                queryStringPuntsTeam1 = " AND " + queryColumnPuntsTeam1 + queryOperatorPuntsTeam1 + queryValuePuntsTeam1
            } else {
                if puntsTeam1SliderValuePlayer == -10000 {
                    queryStringPuntsTeam1 = ""
                } else {
                    if puntsTeam1OperatorValuePlayer == "≠" {
                        queryOperatorPuntsTeam1 = " != "
                    } else {
                        queryOperatorPuntsTeam1 = " " + puntsTeam1OperatorValuePlayer + " "
                    }
                    queryValuePuntsTeam1 = String(puntsTeam1SliderValuePlayer)
                    queryStringPuntsTeam1 = " AND LENGTH(\(queryColumnPuntsTeam1)) !=0 AND " + queryColumnPuntsTeam1 + queryOperatorPuntsTeam1 + queryValuePuntsTeam1
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "OPPONENT: PUNTS" {
            queryStringPuntsTeam2 = ""
        } else {
            if puntsTeam2OperatorValuePlayer == "< >" {
                queryOperatorPuntsTeam2 = " BETWEEN "
                let queryLowerValuePuntsTeam2 = puntsTeam2RangeSliderLowerValuePlayer
                let queryUpperValuePuntsTeam2 = puntsTeam2RangeSliderUpperValuePlayer
                queryValuePuntsTeam2 = String(queryLowerValuePuntsTeam2) + " AND " + String(queryUpperValuePuntsTeam2)
                queryStringPuntsTeam2 = " AND " + queryColumnPuntsTeam2 + queryOperatorPuntsTeam2 + queryValuePuntsTeam2
            } else {
                if puntsTeam2SliderValuePlayer == -10000 {
                    queryStringPuntsTeam2 = ""
                } else {
                    if puntsTeam2OperatorValuePlayer == "≠" {
                        queryOperatorPuntsTeam2 = " != "
                    } else {
                        queryOperatorPuntsTeam2 = " " + puntsTeam2OperatorValuePlayer + " "
                    }
                    queryValuePuntsTeam2 = String(puntsTeam2SliderValuePlayer)
                    queryStringPuntsTeam2 = " AND LENGTH(\(queryColumnPuntsTeam2)) !=0 AND " + queryColumnPuntsTeam2 + queryOperatorPuntsTeam2 + queryValuePuntsTeam2
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "PLAYER TEAM: PUNT YARDS" {
            queryStringPuntYardsTeam1 = ""
        } else {
            if puntYardsTeam1OperatorValuePlayer == "< >" {
                queryOperatorPuntYardsTeam1 = " BETWEEN "
                let queryLowerValuePuntYardsTeam1 = puntYardsTeam1RangeSliderLowerValuePlayer
                let queryUpperValuePuntYardsTeam1 = puntYardsTeam1RangeSliderUpperValuePlayer
                queryValuePuntYardsTeam1 = String(queryLowerValuePuntYardsTeam1) + " AND " + String(queryUpperValuePuntYardsTeam1)
                queryStringPuntYardsTeam1 = " AND " + queryColumnPuntYardsTeam1 + queryOperatorPuntYardsTeam1 + queryValuePuntYardsTeam1
            } else {
                if puntYardsTeam1SliderValuePlayer == -10000 {
                    queryStringPuntYardsTeam1 = ""
                } else {
                    if puntYardsTeam1OperatorValuePlayer == "≠" {
                        queryOperatorPuntYardsTeam1 = " != "
                    } else {
                        queryOperatorPuntYardsTeam1 = " " + puntYardsTeam1OperatorValuePlayer + " "
                    }
                    queryValuePuntYardsTeam1 = String(puntYardsTeam1SliderValuePlayer)
                    queryStringPuntYardsTeam1 = " AND LENGTH(\(queryColumnPuntYardsTeam1)) !=0 AND " + queryColumnPuntYardsTeam1 + queryOperatorPuntYardsTeam1 + queryValuePuntYardsTeam1
                }
            }
        }
        
        if clearSliderIndicatorPlayer == "OPPONENT: PUNT YARDS" {
            queryStringPuntYardsTeam2 = ""
        } else {
            if puntYardsTeam2OperatorValuePlayer == "< >" {
                queryOperatorPuntYardsTeam2 = " BETWEEN "
                let queryLowerValuePuntYardsTeam2 = puntYardsTeam2RangeSliderLowerValuePlayer
                let queryUpperValuePuntYardsTeam2 = puntYardsTeam2RangeSliderUpperValuePlayer
                queryValuePuntYardsTeam2 = String(queryLowerValuePuntYardsTeam2) + " AND " + String(queryUpperValuePuntYardsTeam2)
                queryStringPuntYardsTeam2 = " AND " + queryColumnPuntYardsTeam2 + queryOperatorPuntYardsTeam2 + queryValuePuntYardsTeam2
            } else {
                if puntYardsTeam2SliderValuePlayer == -10000 {
                    queryStringPuntYardsTeam2 = ""
                } else {
                    if puntYardsTeam2OperatorValuePlayer == "≠" {
                        queryOperatorPuntYardsTeam2 = " != "
                    } else {
                        queryOperatorPuntYardsTeam2 = " " + puntYardsTeam2OperatorValuePlayer + " "
                    }
                    queryValuePuntYardsTeam2 = String(puntYardsTeam2SliderValuePlayer)
                    queryStringPuntYardsTeam2 = " AND LENGTH(\(queryColumnPuntYardsTeam2)) !=0 AND " + queryColumnPuntYardsTeam2 + queryOperatorPuntYardsTeam2 + queryValuePuntYardsTeam2
                }
            }
        }
        /*if queryStringTeam2 == "" {
         print("queryStringTeam2 is NULL")
         queryFromFiltersGameData = ""
         queryFromFiltersPlayerDash = "FROM PlayerGameData WHERE " + queryFromFiltersPlayerData + "TeamDateUniqueID IN (SELECT TeamDateUniqueID FROM TeamGameData" + queryFromFiltersGameData
         queryGameStarts = "FROM PlayerGameData WHERE " + queryFromFiltersPlayerData + "StartedGame = 'STARTED' AND TeamDateUniqueID IN (SELECT TeamDateUniqueID FROM TeamGameData" + queryFromFiltersGameData + ")"
         queryWinsTeam1 = queryFromFiltersPlayerDash + " WHERE winLoseTieValueTeam = 1.0" + ")"
         queryLossesTeam1 = queryFromFiltersPlayerDash + " WHERE winLoseTieValueTeam = 0.0" + ")"
         queryTiesTeam1 = queryFromFiltersPlayerDash + " WHERE winLoseTieValueTeam = 0.5" + ")"
         queryCoveredTeam1 = queryFromFiltersPlayerDash + " WHERE SpreadVsLine = 'covered'" + ")"
         queryNotCoveredTeam1 = queryFromFiltersPlayerDash + " WHERE SpreadVsLine = 'not covered'" + ")"
         queryPushTeam1 = queryFromFiltersPlayerDash + " WHERE SpreadVsLine = 'push'" + ")"
         
         } else {
         print("queryStringTeam2 is NOT NULL")*/
        queryFromFiltersGameData = " WHERE TeamDateUniqueID IS NOT NULL" + queryStringTeam2 + queryStringTeam1 + queryStringSpreadTeam1 + queryStringOverUnder + queryStringWinningLosingStreakTeam1 + queryStringWinningLosingStreakTeam2 + queryStringSeasonWinPercentageTeam1 + queryStringSeasonWinPercentageTeam2 + queryStringHomeTeam + queryStringFavorite + queryStringPlayersTeam1 + queryStringSeason + queryStringWeek + queryStringGameNumber + queryStringDay + queryStringStadium + queryStringSurface + queryStringTemperature + queryStringTotalPointsTeam1 + queryStringTotalPointsTeam2 + queryStringTouchdownsTeam1 + queryStringTouchdownsTeam2 + queryStringTurnoversCommittedTeam1 + queryStringTurnoversCommittedTeam2 + queryStringPenaltiesCommittedTeam1 + queryStringPenaltiesCommittedTeam2 + queryStringTotalYardsTeam1 + queryStringTotalYardsTeam2 + queryStringPassingYardsTeam1 + queryStringPassingYardsTeam2 + queryStringRushingYardsTeam1 + queryStringRushingYardsTeam2 + queryStringQuarterbackRatingTeam1 + queryStringQuarterbackRatingTeam2 + queryStringTimesSackedTeam1 + queryStringTimesSackedTeam2 + queryStringInterceptionsThrownTeam1 + queryStringInterceptionsThrownTeam2 + queryStringOffensivePlaysTeam1 + queryStringOffensivePlaysTeam2 + queryStringYardsPerOffensivePlayTeam1 + queryStringYardsPerOffensivePlayTeam2 + queryStringSacksTeam1 + queryStringSacksTeam2 + queryStringInterceptionsTeam1 + queryStringInterceptionsTeam2 + queryStringSafetiesTeam1 + queryStringSafetiesTeam2 + queryStringDefensivePlaysTeam1 + queryStringDefensivePlaysTeam2 + queryStringYardsPerDefensivePlayTeam1 + queryStringYardsPerDefensivePlayTeam2 + queryStringExtraPointAttemptsTeam1 + queryStringExtraPointAttemptsTeam2 + queryStringExtraPointsMadeTeam1 + queryStringExtraPointsMadeTeam2 + queryStringFieldGoalAttemptsTeam1 + queryStringFieldGoalAttemptsTeam2 + queryStringFieldGoalsMadeTeam1 + queryStringFieldGoalsMadeTeam2 + queryStringPuntsTeam1 + queryStringPuntsTeam2 + queryStringPuntYardsTeam1 + queryStringPuntYardsTeam2
        
        queryFromFiltersPlayerDash = "FROM PlayerGameData WHERE " + queryFromFiltersPlayerData + "TeamDateUniqueID IN (SELECT TeamDateUniqueID FROM TeamGameData" + queryFromFiltersGameData
        queryGameStarts = "FROM PlayerGameData WHERE " + queryFromFiltersPlayerData + "StartedGame = 'STARTED' AND TeamDateUniqueID IN (SELECT TeamDateUniqueID FROM TeamGameData" + queryFromFiltersGameData + ")"
        queryWinsTeam1 = queryFromFiltersPlayerDash + " AND winLoseTieValueTeam = 1.0" + ")"
        queryLossesTeam1 = queryFromFiltersPlayerDash + " AND winLoseTieValueTeam = 0.0" + ")"
        queryTiesTeam1 = queryFromFiltersPlayerDash + " AND winLoseTieValueTeam = 0.5" + ")"
        queryCoveredTeam1 = queryFromFiltersPlayerDash + " AND SpreadVsLine = 'covered'" + ")"
        queryNotCoveredTeam1 = queryFromFiltersPlayerDash + " AND SpreadVsLine = 'not covered'" + ")"
        queryPushTeam1 = queryFromFiltersPlayerDash + " AND SpreadVsLine = 'push'" + ")"
            
        let pathStatsDB = Bundle.main.path(forResource: "StatsDatabase", ofType:"db")
        let db = FMDatabase(path: pathStatsDB)
        guard db.open() else {
            print("Unable to open database 'StatsDB'")
            return
        }
         do {
         let executeTotalTouchdowns = try db.executeQuery("SELECT \(queryOperatorSQL)(TotalTouchdowns) \(queryFromFiltersPlayerDash))", values: nil)
         while executeTotalTouchdowns.next() {
            touchdownsTotal = Float(executeTotalTouchdowns.double(forColumnIndex: 0))
         print("touchdownsTotal: " + String(touchdownsTotal))
         }
         } catch let error as NSError {
         errorIndicator = "Yes"
         print("Query failed: \(error.localizedDescription)")
         }
         do {
         let executeTwoPointConversionsMade = try db.executeQuery("SELECT \(queryOperatorSQL)(TwoPointsConversionsMade) \(queryFromFiltersPlayerDash))", values: nil)
         while executeTwoPointConversionsMade.next() {
            twoPointConversions = Float(executeTwoPointConversionsMade.double(forColumnIndex: 0))
         print("twoPointConversions: " + String(twoPointConversions))
         }
         } catch let error as NSError {
         errorIndicator = "Yes"
         print("Query failed: \(error.localizedDescription)")
         }
         do {
         let executeFumblesLost = try db.executeQuery("SELECT \(queryOperatorSQL)(FumblesLost) \(queryFromFiltersPlayerDash))", values: nil)
         while executeFumblesLost.next() {
            fumblesLost = Float(executeFumblesLost.double(forColumnIndex: 0))
         print("fumblesLost: " + String(fumblesLost))
         }
         } catch let error as NSError {
         errorIndicator = "Yes"
         print("Query failed: \(error.localizedDescription)")
         }
         do {
         let executeFFSTD = try db.executeQuery("SELECT \(queryOperatorSQL)(FantasyPointsNFLScoring) \(queryFromFiltersPlayerDash))", values: nil)
         while executeFFSTD.next() {
            fantasySTD = Float(executeFFSTD.double(forColumnIndex: 0))
         print("fantasySTD: " + String(fantasySTD))
         }
         } catch let error as NSError {
         errorIndicator = "Yes"
         print("Query failed: \(error.localizedDescription)")
         }
         do {
         let executeFFPPR = try db.executeQuery("SELECT \(queryOperatorSQL)(FantasyPointsPPRScoring) \(queryFromFiltersPlayerDash))", values: nil)
         while executeFFPPR.next() {
            fantasyPPR = Float(executeFFPPR.double(forColumnIndex: 0))
         print("fantasyPPR: " + String(fantasyPPR))
         }
         } catch let error as NSError {
         errorIndicator = "Yes"
         print("Query failed: \(error.localizedDescription)")
         }
         do {
         let executeFFDK = try db.executeQuery("SELECT \(queryOperatorSQL)(FantasyPointsDraftKingsScoring) \(queryFromFiltersPlayerDash))", values: nil)
         while executeFFDK.next() {
            fantasyDK = Float(executeFFDK.double(forColumnIndex: 0))
         print("fantasyDK: " + String(fantasyDK))
         }
         } catch let error as NSError {
         errorIndicator = "Yes"
         print("Query failed: \(error.localizedDescription)")
         }
         do {
         let executeFFFD = try db.executeQuery("SELECT \(queryOperatorSQL)(FantasyPointsFanDuelScoring) \(queryFromFiltersPlayerDash))", values: nil)
         while executeFFFD.next() {
            fantasyFD = Float(executeFFFD.double(forColumnIndex: 0))
         print("fantasyFD: " + String(fantasyFD))
         }
         } catch let error as NSError {
         errorIndicator = "Yes"
         print("Query failed: \(error.localizedDescription)")
         }
            do {
                let executePassesCompleted = try db.executeQuery("SELECT \(queryOperatorSQL)(PassesCompleted) \(queryFromFiltersPlayerDash))", values: nil)
                while executePassesCompleted.next() {
                    passingCompletions = Float(executePassesCompleted.double(forColumnIndex: 0))
                    print("passingCompletions: " + String(passingCompletions))
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            do {
                let executePassesAttempted = try db.executeQuery("SELECT \(queryOperatorSQL)(PassesAttempted) \(queryFromFiltersPlayerDash))", values: nil)
                while executePassesAttempted.next() {
                    passingAttempts = Float(executePassesAttempted.double(forColumnIndex: 0))
                    print("passingAttempts: " + String(passingAttempts))
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            do {
                let executePassCompletionPercentage = try db.executeQuery("SELECT AVG(PassCompletionPercentage) \(queryFromFiltersPlayerDash)) AND LENGTH(PassesAttempted) !=0)", values: nil)
                while executePassCompletionPercentage.next() {
                    passingCompletionPercentage = Float(executePassCompletionPercentage.double(forColumnIndex: 0))
                    //print("passingCompletionPercentage: " + String(passingCompletionPercentage))
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            do {
                let executePassingYards = try db.executeQuery("SELECT \(queryOperatorSQL)(PassingYardsGained) \(queryFromFiltersPlayerDash))", values: nil)
                while executePassingYards.next() {
                    passingYards = Float(executePassingYards.double(forColumnIndex: 0))
                    print("passingYards: " + String(passingYards))
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            do {
                let executePassingYardsAverage = try db.executeQuery("SELECT AVG(YardsGainedPerPassAttempt) \(queryFromFiltersPlayerDash)) AND LENGTH(PassesAttempted) !=0)", values: nil)
                while executePassingYardsAverage.next() {
                    passingAverageYardage = Float(executePassingYardsAverage.double(forColumnIndex: 0))
                    //print("passingAverageYardage: " + String(passingAverageYardage))
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            do {
                let executePassing300 = try db.executeQuery("SELECT COUNT(*) FROM PlayerGameData WHERE PassingYardsGained >= 300 AND PlayerID IN (SELECT PlayerID \(queryFromFiltersPlayerDash)))", values: nil)
                while executePassing300.next() {
                    passing300 = Float(executePassing300.double(forColumnIndex: 0))
                    print("passing300: " + String(passing300))
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            do {
                let executePassingTouchdowns = try db.executeQuery("SELECT \(queryOperatorSQL)(PassingTouchdowns) \(queryFromFiltersPlayerDash))", values: nil)
                while executePassingTouchdowns.next() {
                    passingTouchdowns = Float(executePassingTouchdowns.double(forColumnIndex: 0))
                    print("passingTouchdowns: " + String(passingTouchdowns))
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            do {
                let executePassingInterceptionsThrown = try db.executeQuery("SELECT \(queryOperatorSQL)(InterceptionsThrown) \(queryFromFiltersPlayerDash))", values: nil)
                while executePassingInterceptionsThrown.next() {
                    passingInterceptionsThrown = Float(executePassingInterceptionsThrown.double(forColumnIndex: 0))
                    print("passingInterceptionsThrown: " + String(passingInterceptionsThrown))
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            do {
                let executeTimesSacked = try db.executeQuery("SELECT \(queryOperatorSQL)(TimesSacked) \(queryFromFiltersPlayerDash))", values: nil)
                while executeTimesSacked.next() {
                    passingSacks = Float(executeTimesSacked.double(forColumnIndex: 0))
                    print("passingSacks: " + String(passingSacks))
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            do {
                let executeSackYardsLost = try db.executeQuery("SELECT \(queryOperatorSQL)(YardsLostDueToSacks) \(queryFromFiltersPlayerDash))", values: nil)
                while executeSackYardsLost.next() {
                    passingSackYardage = Float(executeSackYardsLost.double(forColumnIndex: 0))
                    print("passingSackYardage: " + String(passingSackYardage))
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            do {
                let executeQuarterbackRating = try db.executeQuery("SELECT AVG(QuarterbackRating) \(queryFromFiltersPlayerDash))", values: nil)
                while executeQuarterbackRating.next() {
                    quarterbackRating = Float(executeQuarterbackRating.double(forColumnIndex: 0))
                    print("quarterbackRating: " + String(quarterbackRating))
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            do {
                let executeRushAttempts = try db.executeQuery("SELECT \(queryOperatorSQL)(RushingAttempts) \(queryFromFiltersPlayerDash))", values: nil)
                while executeRushAttempts.next() {
                    rushAttempts = Float(executeRushAttempts.double(forColumnIndex: 0))
                    print("rushAttempts: " + String(rushAttempts))
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            do {
                let executeRushingYards = try db.executeQuery("SELECT \(queryOperatorSQL)(RushingYardsGained) \(queryFromFiltersPlayerDash))", values: nil)
                while executeRushingYards.next() {
                    rushingYards = Float(executeRushingYards.double(forColumnIndex: 0))
                    print("rushingYards: " + String(rushingYards))
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            do {
                let executeRushingYardsAverage = try db.executeQuery("SELECT AVG(YardsPerRushingAttempt) \(queryFromFiltersPlayerDash)) AND LENGTH(RushingAttempts) !=0)", values: nil)
                while executeRushingYardsAverage.next() {
                    rushingAverageYardage = Float(executeRushingYardsAverage.double(forColumnIndex: 0))
                    print("rushingAverageYardage: " + String(rushingAverageYardage))
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            do {
                let executeRushingTouchdowns = try db.executeQuery("SELECT \(queryOperatorSQL)(RushingTouchdowns) \(queryFromFiltersPlayerDash))", values: nil)
                while executeRushingTouchdowns.next() {
                    rushingTouchdowns = Float(executeRushingTouchdowns.double(forColumnIndex: 0))
                    print("rushingTouchdowns: " + String(rushingTouchdowns))
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            do {
                let executeReceivingTargets = try db.executeQuery("SELECT \(queryOperatorSQL)(PassTargets) \(queryFromFiltersPlayerDash))", values: nil)
                while executeReceivingTargets.next() {
                    receivingTargets = Float(executeReceivingTargets.double(forColumnIndex: 0))
                    print("receivingTargets: " + String(receivingTargets))
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            do {
                let executeReceivingReceptions = try db.executeQuery("SELECT \(queryOperatorSQL)(Receptions) \(queryFromFiltersPlayerDash))", values: nil)
                while executeReceivingReceptions.next() {
                    receivingReceptions = Float(executeReceivingReceptions.double(forColumnIndex: 0))
                    print("receivingReceptions: " + String(receivingReceptions))
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            do {
                let executeReceivingCatchPercentage = try db.executeQuery("SELECT AVG(CatchPercentage) \(queryFromFiltersPlayerDash)) AND LENGTH(PassTargets) !=0)", values: nil)
                while executeReceivingCatchPercentage.next() {
                    receivingCatchPercentage = Float(executeReceivingCatchPercentage.double(forColumnIndex: 0))
                    print("receivingCatchPercentage: " + String(receivingCatchPercentage))
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            do {
                let executeReceivingYards = try db.executeQuery("SELECT \(queryOperatorSQL)(ReceivingYards) \(queryFromFiltersPlayerDash))", values: nil)
                while executeReceivingYards.next() {
                    receivingYards = Float(executeReceivingYards.double(forColumnIndex: 0))
                    print("receivingYards: " + String(receivingYards))
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            do {
                let executeReceivingYardsAverage = try db.executeQuery("SELECT AVG(ReceivingYardsPerTarget) \(queryFromFiltersPlayerDash)) AND LENGTH(PassTargets) !=0)", values: nil)
                while executeReceivingYardsAverage.next() {
                    receivingAverageYardage = Float(executeReceivingYardsAverage.double(forColumnIndex: 0))
                    print("receivingAverageYardage: " + String(receivingAverageYardage))
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            do {
                let executeReceivingTouchdowns = try db.executeQuery("SELECT \(queryOperatorSQL)(ReceivingTouchdowns) \(queryFromFiltersPlayerDash))", values: nil)
                while executeReceivingTouchdowns.next() {
                    receivingTouchdowns = Float(executeReceivingTouchdowns.double(forColumnIndex: 0))
                    print("receivingTouchdowns: " + String(receivingTouchdowns))
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            
            
            if gamesSampled == 0 || playerListValuePlayer.count == 0 || playerListValuePlayer == ["-10000"] {
                // GAMES SAMPLED //
                print("gamesSampled = 0")
                gamesSampledValue.text = "0"
                gameStartsValue.text = "0"
                recordValue.text = "0-0-0"
                ATSValue.text = "0-0-0"
                winRate = 0.0
                self.perform(#selector(animateProgress), with: nil, afterDelay: 0.3)
                winRateValue.text = "0.0%"
                // GAME STATS //
                touchdownValue.text = "--"
                twoPCValue.text = "--"
                fumbleValue.text = "--"
                //fumbleRecoveryValue.text = "--"
                fantasySTDValue.text = "--"
                fantasyPPRValue.text = "--"
                fantasyDKValue.text = "--"
                fantasyFDValue.text = "--"
                // PASSING //
                passCompletionsValue.text = "--"
                //PassesAttemptedValue.text = "--"
                passCompletionsValue.text = "--"
                passingYardsValue.text = "--"
                passingYardsAverageValue.text = "--"
                passing300Value.text = "--"
                passingTouchdownsValue.text = "--"
                passesInterceptedValue.text = "--"
                timesSackedValue.text = "--"
                sackYardsValue.text = "--"
                QBRatingValue.text = "--"
                // RUSHING //
                rushAttemptsValue.text = "--"
                rushingYardsValue.text = "--"
                rushingYardsAverageValue.text = "--"
                rushing300Value.text = "--"
                rushingTouchdownsValue.text = "--"
                // RECEIVING //
                receptionsValue.text = "--"
                targetsValue.text = "--"
                catchPercentageValue.text = "--"
                receivingYardsValue.text = "--"
                receivingYardsAverageValue.text = "--"
                receiving300Value.text = "--"
                receivingTouchdownsValue.text = "--"
            } else {
                print("gamesSampled <> 0")
                if queryOperatorSQL == "AVG" {
                    // Game Stats//
                    touchdownValue.text = String(format: "%.1f",  touchdownsTotal)
                    twoPCValue.text = String(format: "%.1f", twoPointConversions)
                    fumbleValue.text = String(format: "%.1f", fumblesLost)
                    //fumbleRecoveryValue.text = numberFormatter.string(from: NSNumber(value: fumblesRecovered))!
                    fantasySTDValue.text = numberFormatter.string(from: NSNumber(value: fantasySTD))!
                    fantasyPPRValue.text = numberFormatter.string(from: NSNumber(value: fantasyPPR))!
                    fantasyDKValue.text = numberFormatter.string(from: NSNumber(value: fantasyDK))!
                    fantasyFDValue.text = numberFormatter.string(from: NSNumber(value: fantasyFD))!
                    // Passing //
                    passCompletionsValue.text = String(format: "%.1f", passingCompletions)
                    passPercentageValue.text = String(format: "%.1f%%", (100.00 * passingCompletionPercentage))
                    passingYardsValue.text = String(format: "%.1f", passingYards)
                    passingYardsAverageValue.text = String(format: "%.1f", passingAverageYardage)
                    passing300Value.text = "--"
                    passingTouchdownsValue.text = String(format: "%.1f", passingTouchdowns)
                    passesInterceptedValue.text = String(format: "%.1f", passingInterceptionsThrown)
                    timesSackedValue.text = String(format: "%.1f", passingSacks)
                    sackYardsValue.text = String(format: "%.1f", passingSackYardage)
                    QBRatingValue.text = String(format: "%.1f", quarterbackRating)
                    // Rushing //
                    rushAttemptsValue.text = String(format: "%.1f", rushAttempts)
                    rushingYardsValue.text = String(format: "%.1f", rushingYards)
                    rushingYardsAverageValue.text = String(format: "%.1f", rushingAverageYardage)
                    rushing300Value.text = "--"
                    rushingTouchdownsValue.text = String(format: "%.1f", rushingTouchdowns)
                    // Receiving //
                    receptionsValue.text = String(format: "%.1f", receivingReceptions)
                    targetsValue.text = String(format: "%.1f", receivingTargets)
                    catchPercentageValue.text = String(format: "%.1f%%", (100.00 * receivingCatchPercentage))
                    receivingYardsValue.text = String(format: "%.1f", receivingYards)
                    receivingYardsAverageValue.text = String(format: "%.1f", receivingAverageYardage)
                    receiving300Value.text = "--"
                    receivingTouchdownsValue.text = String(format: "%.1f", receivingTouchdowns)
                } else {
                    // Game Stats//
                    touchdownValue.text = numberFormatter.string(from: NSNumber(value: touchdownsTotal))!
                    twoPCValue.text = numberFormatter.string(from: NSNumber(value: twoPointConversions))!
                    fumbleValue.text = numberFormatter.string(from: NSNumber(value: fumblesLost))!
                    //fumbleRecoveryValue.text = numberFormatter.string(from: NSNumber(value: fumblesRecovered))!
                    fantasySTDValue.text = numberFormatter.string(from: NSNumber(value: fantasySTD))!
                    fantasyPPRValue.text = numberFormatter.string(from: NSNumber(value: fantasyPPR))!
                    fantasyDKValue.text = numberFormatter.string(from: NSNumber(value: fantasyDK))!
                    fantasyFDValue.text = numberFormatter.string(from: NSNumber(value: fantasyFD))!
                    // Passing //
                    passCompletionsValue.text = numberFormatter.string(from: NSNumber(value: passingCompletions))!
                    //PassesAttemptedValue.text = numberFormatter.string(from: NSNumber(value: passingAttempts))!
                    passPercentageValue.text =  String(format: "%.0f%%", (100.00 * passingCompletionPercentage))
                    passingYardsValue.text = numberFormatter.string(from: NSNumber(value: passingYards))!
                    passingYardsAverageValue.text = numberFormatter.string(from: NSNumber(value: passingAverageYardage))!
                    passing300Value.text = numberFormatter.string(from: NSNumber(value: passing300))!
                    passingTouchdownsValue.text = numberFormatter.string(from: NSNumber(value: passingTouchdowns))!
                    passesInterceptedValue.text = numberFormatter.string(from: NSNumber(value: passingInterceptionsThrown))!
                    timesSackedValue.text = numberFormatter.string(from: NSNumber(value: passingSacks))!
                    sackYardsValue.text = numberFormatter.string(from: NSNumber(value: passingSackYardage))!
                    QBRatingValue.text = String(format: "%.1f", quarterbackRating)
                    // Rushing //
                    rushAttemptsValue.text = numberFormatter.string(from: NSNumber(value: rushAttempts))!
                    rushingYardsValue.text = numberFormatter.string(from: NSNumber(value: rushingYards))!
                    rushingYardsAverageValue.text = numberFormatter.string(from: NSNumber(value: rushingAverageYardage))!
                    rushing300Value.text = numberFormatter.string(from: NSNumber(value: rushing300))!
                    rushingTouchdownsValue.text = numberFormatter.string(from: NSNumber(value: rushingTouchdowns))!
                    // Receiving //
                    receptionsValue.text = numberFormatter.string(from: NSNumber(value: receivingReceptions))!
                    targetsValue.text = numberFormatter.string(from: NSNumber(value: receivingTargets))!
                    catchPercentageValue.text = String(format: "%.0f%%", (100.00 * receivingCatchPercentage))
                    receivingYardsValue.text = numberFormatter.string(from: NSNumber(value: receivingYards))!
                    receivingYardsAverageValue.text = numberFormatter.string(from: NSNumber(value: receivingAverageYardage))!
                    receiving300Value.text = numberFormatter.string(from: NSNumber(value: receiving300))!
                    receivingTouchdownsValue.text = numberFormatter.string(from: NSNumber(value: receivingTouchdowns))!
                }
                
        }
         
         playerLabel.adjustsFontSizeToFitWidth = true
         playerLabel.minimumScaleFactor = 0.6
         playerLabel.allowsDefaultTighteningForTruncation = true
         opponentLabel.adjustsFontSizeToFitWidth = true
         opponentLabel.minimumScaleFactor = 0.6
         opponentLabel.allowsDefaultTighteningForTruncation = true
         winRateValue.adjustsFontSizeToFitWidth = true
         winRateValue.minimumScaleFactor = 0.6
         winRateValue.allowsDefaultTighteningForTruncation = true
         winRateLabel.adjustsFontSizeToFitWidth = true
         winRateLabel.minimumScaleFactor = 0.6
         winRateLabel.allowsDefaultTighteningForTruncation = true
         gamesSampledValue.adjustsFontSizeToFitWidth = true
         gamesSampledValue.minimumScaleFactor = 0.6
         gamesSampledValue.allowsDefaultTighteningForTruncation = true
         /*gameSampledLabel.adjustsFontSizeToFitWidth = true
         gameSampledLabel.minimumScaleFactor = 0.6
         gameSampledLabel.allowsDefaultTighteningForTruncation = true*/
         gameStartsValue.adjustsFontSizeToFitWidth = true
         gameStartsValue.minimumScaleFactor = 0.6
         gameStartsValue.allowsDefaultTighteningForTruncation = true
         /*gameStartsLabel.adjustsFontSizeToFitWidth = true
         gameStartsLabel.minimumScaleFactor = 0.6
         gameStartsLabel.allowsDefaultTighteningForTruncation = true*/
         recordValue.adjustsFontSizeToFitWidth = true
         recordValue.minimumScaleFactor = 0.6
         recordValue.allowsDefaultTighteningForTruncation = true
         /*recordLabel.adjustsFontSizeToFitWidth = true
         recordLabel.minimumScaleFactor = 0.6
         recordLabel.allowsDefaultTighteningForTruncation = true*/
         ATSValue.adjustsFontSizeToFitWidth = true
         ATSValue.minimumScaleFactor = 0.6
         ATSValue.allowsDefaultTighteningForTruncation = true
         /*ATSOpponent.adjustsFontSizeToFitWidth = true
         ATSOpponent.minimumScaleFactor = 0.6
         ATSOpponent.allowsDefaultTighteningForTruncation = true*/
         
         // MATCH-UP //
         playerLabel.text = playerLabelText
         if team2ListValuePlayer.count == 1 {
         if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
         opponentLabel.text = "NEW YORK (G)"
         } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
         opponentLabel.text = "NEW YORK (J)"
         } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
         opponentLabel.text = "LOS ANGELES (C)"
         } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
         opponentLabel.text = "LOS ANGELES (R)"
         } else {
         opponentLabel.text = opponentLabelText
         }
         } else {
         opponentLabel.text = opponentLabelText
         }
         
         // PLAYER BIO CARD //
         if playerListValuePlayer.count == 0 {
         uniformNumberValue.text = "--"
         positionValue.text = "--"
         teamValue.text = "--"
         byeWeekValue.text = "--"
         heightValue.text = "--"
         weightValue.text = "--"
         ageValue.text = "--"
         experienceValue.text = "--"
         } else {
         uniformNumberValue.text = uniformNumber
         positionValue.text = position
         teamValue.text = team
         byeWeekValue.text = byeWeek
         heightValue.text = height
         weightValue.text = weight
         ageValue.text = numberFormatter.string(from: NSNumber(value: age))!
         experienceValue.text = numberFormatter.string(from: NSNumber(value: experience))!
         }
        if errorIndicator == "Yes" {
            print("errorIndicator = Yes")
        }
        db.close()
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    @objc func updatePlayerDashboardValues() {
     print("updatePlayerDashboardValues()")
        print("playerListValuePlayer: ")
        print(playerListValuePlayer)
     queryOperatorTeam1 = " = "
     if clearMultiSelectIndicatorPlayer == "PLAYER" || playerListValuePlayer == ["-10000"] || playerListValuePlayer == [] || playerListValuePlayer == [""] {
        playerLabelText = "PLAYER"
        queryStringPlayer = ""
        queryFromFiltersPlayerData = ""
     } else {
        queryValuePlayer = "('" + playerDictionary[playerListValuePlayer[0]]! + "')"
        playerLabelText = playerListValuePlayer[0]
        playerLabel.adjustsFontSizeToFitWidth = true
        playerLabel.minimumScaleFactor = 0.6
        playerLabel.allowsDefaultTighteningForTruncation = true
        queryStringPlayer = queryColumnPlayer + " IN " + queryValuePlayer
        queryFromFiltersPlayerData = queryStringPlayer + " AND "
     }
     
     if clearMultiSelectIndicatorPlayer == "OPPONENT" || team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count == 32 {
        opponentLabelText = "OPPONENT"
        queryStringTeam2 = ""
     } else {
        opponentLabel.adjustsFontSizeToFitWidth = true
        opponentLabel.minimumScaleFactor = 0.6
        opponentLabel.allowsDefaultTighteningForTruncation = true
        if team2ListValuePlayer.count > 1 || team2OperatorValuePlayer == "≠" {
            opponentLabelText = "OPPONENT"
        } else {
            opponentLabelText = team2ListValuePlayer[0]
            var opponentLabelTextArray = opponentLabelText.components(separatedBy: " ")
            let opponentLabelTextArrayLength = opponentLabelTextArray.count
            opponentLabelTextArray.remove(at: opponentLabelTextArrayLength - 1)
            opponentLabelText = opponentLabelTextArray.joined(separator: " ")
        }
        if team2OperatorValuePlayer == "=" {
            queryOperatorTeam2 = " IN "
        } else if team2OperatorValuePlayer == "≠" {
            queryOperatorTeam2 = " NOT IN "
        }
        queryValueTeam2 = "('" + team2ListValuePlayer.joined(separator: "', '") + "')"
        queryStringTeam2 = " AND " + queryColumnTeam2 + queryOperatorTeam2 + queryValueTeam2
        }
     
     if clearSliderIndicatorPlayer == "PLAYER TEAM: SPREAD" {
     queryStringSpreadTeam1 = ""
     } else {
     if spreadOperatorValuePlayer == "< >" {
     queryOperatorSpreadTeam1 = " BETWEEN "
     let queryLowerValueSpreadTeam1 = spreadRangeSliderLowerValuePlayer
     let queryUpperValueSpreadTeam1 = spreadRangeSliderUpperValuePlayer
     queryValueSpreadTeam1 = String(queryLowerValueSpreadTeam1) + " AND " + String(queryUpperValueSpreadTeam1)
     queryStringSpreadTeam1 = " AND " + queryColumnSpreadTeam1 + queryOperatorSpreadTeam1 + queryValueSpreadTeam1
     } else {
     if spreadSliderValuePlayer == -10000 {
     queryStringSpreadTeam1 = ""
     } else {
     if spreadOperatorValuePlayer == "≠" {
     queryOperatorSpreadTeam1 = " != "
     } else {
     queryOperatorSpreadTeam1 = " " + spreadOperatorValuePlayer + " "
     }
     queryValueSpreadTeam1 = String(spreadSliderValuePlayer)
     queryStringSpreadTeam1 = " AND LENGTH(\(queryColumnSpreadTeam1)) !=0 AND " + queryColumnSpreadTeam1 + queryOperatorSpreadTeam1 + queryValueSpreadTeam1
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "PLAYER TEAM: OVER/UNDER" {
     queryValueOverUnder = ""
     } else {
     if overUnderOperatorValuePlayer == "< >" {
     queryOperatorOverUnder = " BETWEEN "
     let queryLowerValueOverUnder = overUnderRangeSliderLowerValuePlayer
     let queryUpperValueOverUnder = overUnderRangeSliderUpperValuePlayer
     queryValueOverUnder = String(queryLowerValueOverUnder) + " AND " + String(queryUpperValueOverUnder)
     queryStringOverUnder = " AND " + queryColumnOverUnder + queryOperatorOverUnder + queryValueOverUnder
     } else {
     if overUnderSliderValuePlayer == -10000 {
     queryStringOverUnder = ""
     } else {
     if overUnderOperatorValuePlayer == "≠" {
     queryOperatorOverUnder = " != "
     } else {
     queryOperatorOverUnder = " " + overUnderOperatorValuePlayer + " "
     }
     queryValueOverUnder = String(overUnderSliderValuePlayer)
     queryStringOverUnder = " AND LENGTH(\(queryColumnOverUnder)) !=0 AND " + queryColumnOverUnder + queryOperatorOverUnder + queryValueOverUnder
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "PLAYER TEAM: STREAK" {
     queryValueWinningLosingStreakTeam1 = ""
     } else {
     if winningLosingStreakTeam1OperatorValuePlayer == "< >" {
     queryOperatorWinningLosingStreakTeam1 = " BETWEEN "
     let queryLowerValueWinningLosingStreakTeam1 = winningLosingStreakTeam1RangeSliderLowerValuePlayer
     let queryUpperValueWinningLosingStreakTeam1 = winningLosingStreakTeam1RangeSliderUpperValuePlayer
     queryValueWinningLosingStreakTeam1 = String(queryLowerValueWinningLosingStreakTeam1) + " AND " + String(queryUpperValueWinningLosingStreakTeam1)
     queryStringWinningLosingStreakTeam1 = " AND " + queryColumnWinningLosingStreakTeam1 + queryOperatorWinningLosingStreakTeam1 + queryValueWinningLosingStreakTeam1
     } else {
     if winningLosingStreakTeam1SliderValuePlayer == -10000 {
     queryStringWinningLosingStreakTeam1 = ""
     } else {
     if winningLosingStreakTeam1OperatorValuePlayer == "≠" {
     queryOperatorWinningLosingStreakTeam1 = " != "
     } else {
     queryOperatorWinningLosingStreakTeam1 = " " + winningLosingStreakTeam1OperatorValuePlayer + " "
     }
     queryValueWinningLosingStreakTeam1 = String(winningLosingStreakTeam1SliderValuePlayer)
     queryStringWinningLosingStreakTeam1 = " AND LENGTH(\(queryColumnWinningLosingStreakTeam1)) !=0 AND " + queryColumnWinningLosingStreakTeam1 + queryOperatorWinningLosingStreakTeam1 + queryValueWinningLosingStreakTeam1
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "OPPONENT: STREAK" {
     queryValueWinningLosingStreakTeam2 = ""
     } else {
     if winningLosingStreakTeam2OperatorValuePlayer == "< >" {
     queryOperatorWinningLosingStreakTeam2 = " BETWEEN "
     let queryLowerValueWinningLosingStreakTeam2 = winningLosingStreakTeam2RangeSliderLowerValuePlayer
     let queryUpperValueWinningLosingStreakTeam2 = winningLosingStreakTeam2RangeSliderUpperValuePlayer
     queryValueWinningLosingStreakTeam2 = String(queryLowerValueWinningLosingStreakTeam2) + " AND " + String(queryUpperValueWinningLosingStreakTeam2)
     queryStringWinningLosingStreakTeam2 = " AND " + queryColumnWinningLosingStreakTeam2 + queryOperatorWinningLosingStreakTeam2 + queryValueWinningLosingStreakTeam2
     } else {
     if winningLosingStreakTeam2SliderValuePlayer == -10000 {
     queryStringWinningLosingStreakTeam2 = ""
     } else {
     if winningLosingStreakTeam2OperatorValuePlayer == "≠" {
     queryOperatorWinningLosingStreakTeam2 = " != "
     } else {
     queryOperatorWinningLosingStreakTeam2 = " " + winningLosingStreakTeam2OperatorValuePlayer + " "
     }
     queryValueWinningLosingStreakTeam2 = String(winningLosingStreakTeam2SliderValuePlayer)
     queryStringWinningLosingStreakTeam2 = " AND LENGTH(\(queryColumnWinningLosingStreakTeam2)) !=0 AND " + queryColumnWinningLosingStreakTeam2 + queryOperatorWinningLosingStreakTeam2 + queryValueWinningLosingStreakTeam2
     }
     }
     }
     
    print("clearSliderIndicatorPlayer: ")
    print(clearSliderIndicatorPlayer)

     if clearSliderIndicatorPlayer == "PLAYER TEAM: SEASON WIN %" {
     queryStringSeasonWinPercentageTeam1 = ""
     } else {
     if seasonWinPercentageTeam1OperatorValuePlayer == "< >" {
     queryOperatorSeasonWinPercentageTeam1 = " BETWEEN "
     let queryLowerValueSeasonWinPercentageTeam1 = (Double(seasonWinPercentageTeam1RangeSliderLowerValuePlayer) / 100.00)
     let queryUpperValueSeasonWinPercentageTeam1 = (Double(seasonWinPercentageTeam1RangeSliderUpperValuePlayer) / 100.00)
     queryValueSeasonWinPercentageTeam1 = String(queryLowerValueSeasonWinPercentageTeam1) + " AND " + String(queryUpperValueSeasonWinPercentageTeam1)
     queryStringSeasonWinPercentageTeam1 = " AND " + queryColumnSeasonWinPercentageTeam1 + queryOperatorSeasonWinPercentageTeam1 + queryValueSeasonWinPercentageTeam1
     } else {
     if seasonWinPercentageTeam1SliderValuePlayer == -10000 {
     queryStringSeasonWinPercentageTeam1 = ""
     } else {
     if seasonWinPercentageTeam1OperatorValuePlayer == "≠" {
     queryOperatorSeasonWinPercentageTeam1 = " != "
     } else {
     queryOperatorSeasonWinPercentageTeam1 = " " + seasonWinPercentageTeam1OperatorValuePlayer + " "
     }
     queryValueSeasonWinPercentageTeam1 = String(seasonWinPercentageTeam1SliderValuePlayer)
     queryStringSeasonWinPercentageTeam1 = " AND LENGTH(\(queryColumnSeasonWinPercentageTeam1)) !=0 AND " + queryColumnSeasonWinPercentageTeam1 + queryOperatorSeasonWinPercentageTeam1 + String((Double(queryValueSeasonWinPercentageTeam1)! / 100.00))
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "OPPONENT: SEASON WIN %" {
     queryStringSeasonWinPercentageTeam2 = ""
     } else {
     if seasonWinPercentageTeam2OperatorValuePlayer == "< >" {
     queryOperatorSeasonWinPercentageTeam2 = " BETWEEN "
     let queryLowerValueSeasonWinPercentageTeam2 = (Double(seasonWinPercentageTeam2RangeSliderLowerValuePlayer) / 100.00)
     let queryUpperValueSeasonWinPercentageTeam2 = (Double(seasonWinPercentageTeam2RangeSliderUpperValuePlayer) / 100.00)
     queryValueSeasonWinPercentageTeam2 = String(queryLowerValueSeasonWinPercentageTeam2) + " AND " + String(queryUpperValueSeasonWinPercentageTeam2)
     queryStringSeasonWinPercentageTeam2 = " AND " + queryColumnSeasonWinPercentageTeam2 + queryOperatorSeasonWinPercentageTeam2 + queryValueSeasonWinPercentageTeam2
     } else {
     if seasonWinPercentageTeam2SliderValuePlayer == -10000 {
     queryStringSeasonWinPercentageTeam2 = ""
     } else {
     if seasonWinPercentageTeam2OperatorValuePlayer == "≠" {
     queryOperatorSeasonWinPercentageTeam2 = " != "
     } else {
     queryOperatorSeasonWinPercentageTeam2 = " " + seasonWinPercentageTeam2OperatorValuePlayer + " "
     }
     queryValueSeasonWinPercentageTeam2 = String(seasonWinPercentageTeam2SliderValuePlayer)
     queryStringSeasonWinPercentageTeam2 = " AND LENGTH(\(queryColumnSeasonWinPercentageTeam2)) !=0 AND " + queryColumnSeasonWinPercentageTeam2 + queryOperatorSeasonWinPercentageTeam2 + String((Double(queryValueSeasonWinPercentageTeam2)! / 100.00))
     }
     }
     }
     
     /*if homeTeamListValuePlayer == ["-10000"] || homeTeamListValuePlayer == [] {
     queryStringHomeTeam = ""
     } else if homeTeamListValuePlayer == ["EITHER"] {
     queryOperatorHomeTeam = " IN "
     queryValueHomeTeam = "('TEAM 1', 'TEAM 2')"
     queryStringHomeTeam = " AND " + queryColumnHomeTeam + queryOperatorHomeTeam + queryValueHomeTeam
     } else {
     queryOperatorHomeTeam = " = "
     queryValueHomeTeam = "'" + homeTeamListValuePlayer[0] + "'"
     queryStringHomeTeam = " AND " + queryColumnHomeTeam + queryOperatorHomeTeam + queryValueHomeTeam
     }
     
     if favoriteListValuePlayer == ["-10000"] || favoriteListValuePlayer == [] {
     queryStringFavorite = ""
     } else if favoriteListValuePlayer == ["EITHER"] {
     queryOperatorFavorite = " IN "
     queryValueFavorite = "('TEAM 1', 'TEAM 2')"
     queryStringFavorite = " AND " + queryColumnFavorite + queryOperatorFavorite + queryValueFavorite
     } else {
     queryOperatorFavorite = " = "
     queryValueFavorite = "'" + favoriteListValuePlayer[0] + "'"
     queryStringFavorite = " AND " + queryColumnFavorite + queryOperatorFavorite + queryValueFavorite
     }*/
        print("homeTeamListValuePlayer: ")
        print(homeTeamListValuePlayer)
        if clearMultiSelectIndicatorPlayer == "HOME TEAM" {
            queryStringHomeTeam = ""
        } else {
            if homeTeamListValuePlayer == ["-10000"] || homeTeamListValuePlayer == [] || homeTeamListValuePlayer.count == 3 {
                queryStringHomeTeam = ""
            } else {
                queryOperatorHomeTeam = " IN "
                let homeTeamDictionaryPlayer = [
                    "TEAM" : "TEAM 1",
                    "OPPONENT" : "TEAM 2",
                    "NEUTRAL" : "NEUTRAL"
                ]
                var homeTeamListValuesMappedPlayer = [String]()
                for homeTeamPlayer in homeTeamListValuePlayer {
                    homeTeamListValuesMappedPlayer.append(homeTeamDictionaryPlayer[homeTeamPlayer]!)
                }
                queryValueHomeTeam = "('" + homeTeamListValuesMappedPlayer.joined(separator: "', '") + "')"
                queryStringHomeTeam = " AND " + queryColumnHomeTeam + queryOperatorHomeTeam + queryValueHomeTeam
            }
        }
        
        if clearMultiSelectIndicatorPlayer == "FAVORITE" {
            queryStringFavorite = ""
        } else {
            if favoriteListValuePlayer == ["-10000"] || favoriteListValuePlayer == [] || favoriteListValuePlayer.count == 3 {
                queryStringFavorite = ""
            } else {
                queryOperatorFavorite = " IN "
                let favoriteDictionaryPlayer = [
                    "TEAM" : "TEAM 1",
                    "OPPONENT" : "TEAM 2",
                    "PUSH" : "NEITHER"
                ]
                var favoriteListValuesMappedPlayer = [String]()
                for favoritePlayer in favoriteListValuePlayer {
                    favoriteListValuesMappedPlayer.append(favoriteDictionaryPlayer[favoritePlayer]!)
                    
                }
                queryValueFavorite = "('" + favoriteListValuesMappedPlayer.joined(separator: "', '") + "')"
                queryStringFavorite = " AND " + queryColumnFavorite + queryOperatorFavorite + queryValueFavorite
            }
        }
 
        if clearSliderIndicatorPlayer == "SEASON" {
            queryStringSeason = ""
        } else {
            if seasonOperatorValuePlayer == "< >" {
                queryOperatorSeason = " BETWEEN "
                let queryLowerValueSeason = seasonRangeSliderLowerValuePlayer
                let queryUpperValueSeason = seasonRangeSliderUpperValuePlayer
                queryValueSeason = String(queryLowerValueSeason) + " AND " + String(queryUpperValueSeason)
                queryStringSeason = " AND " + queryColumnSeason + queryOperatorSeason + queryValueSeason
            } else {
                if seasonSliderValuePlayer == -10000 {
                    queryStringSeason = ""
                } else {
                    if seasonOperatorValuePlayer == "≠" {
                        queryOperatorSeason = " != "
                    } else {
                        queryOperatorSeason = " " + seasonOperatorValuePlayer + " "
                    }
                    queryValueSeason = String(Int(seasonSliderValuePlayer))
                    queryStringSeason = " AND LENGTH(\(queryColumnSeason)) !=0 AND " + queryColumnSeason + queryOperatorSeason + queryValueSeason
                }
            }
        }
        
        //print("seasonOperatorValuePlayer: ")
        //print(seasonOperatorValuePlayer)
        print("seasonSliderValuePlayer: ")
        print(seasonSliderValuePlayer)
        print("seasonSliderFormValuePlayer: ")
        print(seasonSliderFormValuePlayer)
        print("queryValueSeason: ")
        print(queryValueSeason)
        print("seasonRangeSliderLowerValuePlayer: ")
        print(seasonRangeSliderLowerValuePlayer)
        
        if clearSliderIndicatorPlayer == "WEEK" {
            queryStringWeek = ""
        } else {
            if weekOperatorValuePlayer == "< >" {
                queryOperatorWeek = " BETWEEN "
                let queryLowerValueWeek = weekRangeSliderLowerValuePlayer
                let queryUpperValueWeek = weekRangeSliderUpperValuePlayer
                queryValueWeek = String(queryLowerValueWeek) + " AND " + String(queryUpperValueWeek)
                queryStringWeek = " AND " + queryColumnWeek + queryOperatorWeek + queryValueWeek
            } else {
                if weekSliderValuePlayer == -10000 {
                    queryStringWeek = ""
                } else {
                    if weekOperatorValuePlayer == "≠" {
                        queryOperatorWeek = " != "
                    } else {
                        queryOperatorWeek = " " + weekOperatorValuePlayer + " "
                    }
                    queryValueWeek = String(weekSliderValuePlayer)
                    queryStringWeek = " AND LENGTH(\(queryColumnWeek)) !=0 AND " + queryColumnWeek + queryOperatorWeek + queryValueWeek
                }
            }
        }
   
     if clearSliderIndicatorPlayer == "GAME NUMBER" {
     queryStringGameNumber = ""
     } else {
     if gameNumberOperatorValuePlayer == "< >" {
     queryOperatorGameNumber = " BETWEEN "
     let queryLowerValueGameNumber = gameNumberRangeSliderLowerValuePlayer
     let queryUpperValueGameNumber = gameNumberRangeSliderUpperValuePlayer
     queryValueGameNumber = String(queryLowerValueGameNumber) + " AND " + String(queryUpperValueGameNumber)
     queryStringGameNumber = " AND " + queryColumnGameNumber + queryOperatorGameNumber + queryValueGameNumber
     } else {
     if gameNumberSliderValuePlayer == -10000 {
     queryStringGameNumber = ""
     } else {
     if gameNumberOperatorValuePlayer == "≠" {
     queryOperatorGameNumber = " != "
     } else {
     queryOperatorGameNumber = " " + gameNumberOperatorValuePlayer + " "
     }
     queryValueGameNumber = String(gameNumberSliderValuePlayer)
     queryStringGameNumber = " AND LENGTH(\(queryColumnGameNumber)) !=0 AND " + queryColumnGameNumber + queryOperatorGameNumber + queryValueGameNumber
     }
     }
     }
     
     /*if dayListValuePlayer == ["-10000"] || dayListValuePlayer == [] || dayListValuePlayer.count == 7 {
     queryStringDay = ""
     } else {
     queryOperatorDay = " IN "
     queryValueDay = "('" + dayListValuePlayer.joined(separator: "', '") + "')"
     queryStringDay = " AND " + queryColumnDay + queryOperatorDay + queryValueDay
     }
     
     if stadiumListValuePlayer == ["-10000"] || stadiumListValuePlayer == [] || stadiumListValuePlayer.count == 3 {
     queryStringStadium = ""
     } else {
     queryOperatorStadium = " IN "
     let stadiumDictionary = [
     "OUTDOORS" : "outdoors",
     "DOME" : "dome",
     "RETRACTABLE ROOF" : "retroof"
     ]
     var stadiumListValuePlayersMapped = [String]()
     for stadium in stadiumListValuePlayer {
     stadiumListValuePlayersMapped.append(stadiumDictionary[stadium]!)
     }
     queryValueStadium = "('" + stadiumListValuePlayersMapped.joined(separator: "', '") + "')"
     queryStringStadium = " AND " + queryColumnStadium + queryOperatorStadium + queryValueStadium
     }
     
     if surfaceListValuePlayer == ["-10000"] || surfaceListValuePlayer == [] || surfaceListValuePlayer == ["EITHER"] {
     queryStringSurface = ""
     } else {
     if surfaceListValuePlayer == ["GRASS"] {
     queryOperatorSurface = " IN "
     queryValueSurface = "('grass')"
     } else {
     queryOperatorSurface = " NOT IN "
     queryValueSurface = "('grass')"
     }
     queryStringSurface = " AND " + queryColumnSurface + queryOperatorSurface + queryValueSurface
     }
     */
        
        if clearMultiSelectIndicatorPlayer == "DAY" {
            queryStringDay = ""
        } else {
            if dayListValuePlayer == ["-10000"] || dayListValuePlayer == [] || dayListValuePlayer.count == 7 {
                queryStringDay = ""
            } else {
                queryOperatorDay = " IN "
                queryValueDay = "('" + dayListValuePlayer.joined(separator: "', '") + "')"
                queryStringDay = " AND " + queryColumnDay + queryOperatorDay + queryValueDay
            }
        }
        
        if clearMultiSelectIndicatorPlayer == "STADIUM" {
            queryStringStadium = ""
        } else {
            if stadiumListValuePlayer == ["-10000"] || stadiumListValuePlayer == [] || stadiumListValuePlayer.count == 3 {
                queryStringStadium = ""
            } else {
                queryOperatorStadium = " IN "
                let stadiumDictionaryPlayer = [
                    "OUTDOORS" : "outdoors",
                    "DOME" : "dome",
                    "RETRACTABLE ROOF" : "retroof"
                ]
                var stadiumListValuesMappedPlayer = [String]()
                for stadiumPlayer in stadiumListValuePlayer {
                    stadiumListValuesMappedPlayer.append(stadiumDictionaryPlayer[stadiumPlayer]!)
                }
                queryValueStadium = "('" + stadiumListValuesMappedPlayer.joined(separator: "', '") + "')"
                queryStringStadium = " AND " + queryColumnStadium + queryOperatorStadium + queryValueStadium
            }
        }
        
        if clearMultiSelectIndicatorPlayer == "SURFACE" {
            queryStringSurface = ""
        } else {
            if surfaceListValuePlayer == ["-10000"] || surfaceListValuePlayer == [] || surfaceListValuePlayer.count == 2 {
                queryStringSurface = ""
            } else {
                if surfaceListValuePlayer == ["GRASS"] {
                    queryOperatorSurface = " IN "
                    queryValueSurface = "('grass')"
                } else {
                    queryOperatorSurface = " NOT IN "
                    queryValueSurface = "('grass')"
                }
                queryStringSurface = " AND " + queryColumnSurface + queryOperatorSurface + queryValueSurface
            }
        }
     if clearSliderIndicatorPlayer == "TEMPERATURE (F)" {
     queryStringTemperature = ""
     } else {
     if temperatureOperatorValuePlayer == "< >" {
     queryOperatorTemperature = " BETWEEN "
     let queryLowerValueTemperature = temperatureRangeSliderLowerValuePlayer
     let queryUpperValueTemperature = temperatureRangeSliderUpperValuePlayer
     queryValueTemperature = String(queryLowerValueTemperature) + " AND " + String(queryUpperValueTemperature)
     queryStringTemperature = " AND " + queryColumnTemperature + queryOperatorTemperature + queryValueTemperature
     } else {
     if temperatureSliderValuePlayer == -10000 {
     queryStringTemperature = ""
     } else {
     if temperatureOperatorValuePlayer == "≠" {
     queryOperatorTemperature = " != "
     } else {
     queryOperatorTemperature = " " + temperatureOperatorValuePlayer + " "
     }
     queryValueTemperature = String(temperatureSliderValuePlayer)
     queryStringTemperature = " AND LENGTH(\(queryColumnTemperature)) !=0 AND " + queryColumnTemperature + queryOperatorTemperature + queryValueTemperature
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "PLAYER TEAM: TOTAL POINTS" {
     queryStringTotalPointsTeam1 = ""
     } else {
     if totalPointsTeam1OperatorValuePlayer == "< >" {
     queryOperatorTotalPointsTeam1 = " BETWEEN "
     let queryLowerValueTotalPointsTeam1 = totalPointsTeam1RangeSliderLowerValuePlayer
     let queryUpperValueTotalPointsTeam1 = totalPointsTeam1RangeSliderUpperValuePlayer
     queryValueTotalPointsTeam1 = String(queryLowerValueTotalPointsTeam1) + " AND " + String(queryUpperValueTotalPointsTeam1)
     queryStringTotalPointsTeam1 = " AND " + queryColumnTotalPointsTeam1 + queryOperatorTotalPointsTeam1 + queryValueTotalPointsTeam1
     } else {
     if totalPointsTeam1SliderValuePlayer == -10000 {
     queryStringTotalPointsTeam1 = ""
     } else {
     if totalPointsTeam1OperatorValuePlayer == "≠" {
     queryOperatorTotalPointsTeam1 = " != "
     } else {
     queryOperatorTotalPointsTeam1 = " " + totalPointsTeam1OperatorValuePlayer + " "
     }
     queryValueTotalPointsTeam1 = String(totalPointsTeam1SliderValuePlayer)
     queryStringTotalPointsTeam1 = " AND LENGTH(\(queryColumnTotalPointsTeam1)) !=0 AND " + queryColumnTotalPointsTeam1 + queryOperatorTotalPointsTeam1 + queryValueTotalPointsTeam1
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "OPPONENT: TOTAL POINTS" {
     queryStringTotalPointsTeam2 = ""
     } else {
     if totalPointsTeam2OperatorValuePlayer == "< >" {
     queryOperatorTotalPointsTeam2 = " BETWEEN "
     let queryLowerValueTotalPointsTeam2 = totalPointsTeam2RangeSliderLowerValuePlayer
     let queryUpperValueTotalPointsTeam2 = totalPointsTeam2RangeSliderUpperValuePlayer
     queryValueTotalPointsTeam2 = String(queryLowerValueTotalPointsTeam2) + " AND " + String(queryUpperValueTotalPointsTeam2)
     queryStringTotalPointsTeam2 = " AND " + queryColumnTotalPointsTeam2 + queryOperatorTotalPointsTeam2 + queryValueTotalPointsTeam2
     } else {
     if totalPointsTeam2SliderValuePlayer == -10000 {
     queryStringTotalPointsTeam2 = ""
     } else {
     if totalPointsTeam2OperatorValuePlayer == "≠" {
     queryOperatorTotalPointsTeam2 = " != "
     } else {
     queryOperatorTotalPointsTeam2 = " " + totalPointsTeam2OperatorValuePlayer + " "
     }
     queryValueTotalPointsTeam2 = String(totalPointsTeam2SliderValuePlayer)
     queryStringTotalPointsTeam2 = " AND LENGTH(\(queryColumnTotalPointsTeam2)) !=0 AND " + queryColumnTotalPointsTeam2 + queryOperatorTotalPointsTeam2 + queryValueTotalPointsTeam2
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "PLAYER TEAM: TOUCHDOWNS" {
     queryStringTouchdownsTeam1 = ""
     } else {
     if touchdownsTeam1OperatorValuePlayer == "< >" {
     queryOperatorTouchdownsTeam1 = " BETWEEN "
     let queryLowerValueTouchdownsTeam1 = touchdownsTeam1RangeSliderLowerValuePlayer
     let queryUpperValueTouchdownsTeam1 = touchdownsTeam1RangeSliderUpperValuePlayer
     queryValueTouchdownsTeam1 = String(queryLowerValueTouchdownsTeam1) + " AND " + String(queryUpperValueTouchdownsTeam1)
     queryStringTouchdownsTeam1 = " AND " + queryColumnTouchdownsTeam1 + queryOperatorTouchdownsTeam1 + queryValueTouchdownsTeam1
     } else {
     if touchdownsTeam1SliderValuePlayer == -10000 {
     queryStringTouchdownsTeam1 = ""
     } else {
     if touchdownsTeam1OperatorValuePlayer == "≠" {
     queryOperatorTouchdownsTeam1 = " != "
     } else {
     queryOperatorTouchdownsTeam1 = " " + touchdownsTeam1OperatorValuePlayer + " "
     }
     queryValueTouchdownsTeam1 = String(touchdownsTeam1SliderValuePlayer)
     queryStringTouchdownsTeam1 = " AND LENGTH(\(queryColumnTouchdownsTeam1)) !=0 AND " + queryColumnTouchdownsTeam1 + queryOperatorTouchdownsTeam1 + queryValueTouchdownsTeam1
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "OPPONENT: TOUCHDOWNS" {
     queryStringTouchdownsTeam2 = ""
     } else {
     if touchdownsTeam2OperatorValuePlayer == "< >" {
     queryOperatorTouchdownsTeam2 = " BETWEEN "
     let queryLowerValueTouchdownsTeam2 = touchdownsTeam2RangeSliderLowerValuePlayer
     let queryUpperValueTouchdownsTeam2 = touchdownsTeam2RangeSliderUpperValuePlayer
     queryValueTouchdownsTeam2 = String(queryLowerValueTouchdownsTeam2) + " AND " + String(queryUpperValueTouchdownsTeam2)
     queryStringTouchdownsTeam2 = " AND " + queryColumnTouchdownsTeam2 + queryOperatorTouchdownsTeam2 + queryValueTouchdownsTeam2
     } else {
     if touchdownsTeam2SliderValuePlayer == -10000 {
     queryStringTouchdownsTeam2 = ""
     } else {
     if touchdownsTeam2OperatorValuePlayer == "≠" {
     queryOperatorTouchdownsTeam2 = " != "
     } else {
     queryOperatorTouchdownsTeam2 = " " + touchdownsTeam2OperatorValuePlayer + " "
     }
     queryValueTouchdownsTeam2 = String(touchdownsTeam2SliderValuePlayer)
     queryStringTouchdownsTeam2 = " AND LENGTH(\(queryColumnTouchdownsTeam2)) !=0 AND " + queryColumnTouchdownsTeam2 + queryOperatorTouchdownsTeam2 + queryValueTouchdownsTeam2
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "PLAYER TEAM: TURNOVERS" {
     queryStringTurnoversCommittedTeam1 = ""
     } else {
     if turnoversCommittedTeam1OperatorValuePlayer == "< >" {
     queryOperatorTurnoversCommittedTeam1 = " BETWEEN "
     let queryLowerValueTurnoversCommittedTeam1 = turnoversCommittedTeam1RangeSliderLowerValuePlayer
     let queryUpperValueTurnoversCommittedTeam1 = turnoversCommittedTeam1RangeSliderUpperValuePlayer
     queryValueTurnoversCommittedTeam1 = String(queryLowerValueTurnoversCommittedTeam1) + " AND " + String(queryUpperValueTurnoversCommittedTeam1)
     queryStringTurnoversCommittedTeam1 = " AND " + queryColumnTurnoversCommittedTeam1 + queryOperatorTurnoversCommittedTeam1 + queryValueTurnoversCommittedTeam1
     } else {
     if turnoversCommittedTeam1SliderValuePlayer == -10000 {
     queryStringTurnoversCommittedTeam1 = ""
     } else {
     if turnoversCommittedTeam1OperatorValuePlayer == "≠" {
     queryOperatorTurnoversCommittedTeam1 = " != "
     } else {
     queryOperatorTurnoversCommittedTeam1 = " " + turnoversCommittedTeam1OperatorValuePlayer + " "
     }
     queryValueTurnoversCommittedTeam1 = String(turnoversCommittedTeam1SliderValuePlayer)
     queryStringTurnoversCommittedTeam1 = " AND LENGTH(\(queryColumnTurnoversCommittedTeam1)) !=0 AND " + queryColumnTurnoversCommittedTeam1 + queryOperatorTurnoversCommittedTeam1 + queryValueTurnoversCommittedTeam1
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "OPPONENT: TURNOVERS" {
     queryStringTurnoversCommittedTeam2 = ""
     } else {
     if turnoversCommittedTeam2OperatorValuePlayer == "< >" {
     queryOperatorTurnoversCommittedTeam2 = " BETWEEN "
     let queryLowerValueTurnoversCommittedTeam2 = turnoversCommittedTeam2RangeSliderLowerValuePlayer
     let queryUpperValueTurnoversCommittedTeam2 = turnoversCommittedTeam2RangeSliderUpperValuePlayer
     queryValueTurnoversCommittedTeam2 = String(queryLowerValueTurnoversCommittedTeam2) + " AND " + String(queryUpperValueTurnoversCommittedTeam2)
     queryStringTurnoversCommittedTeam2 = " AND " + queryColumnTurnoversCommittedTeam2 + queryOperatorTurnoversCommittedTeam2 + queryValueTurnoversCommittedTeam2
     } else {
     if turnoversCommittedTeam2SliderValuePlayer == -10000 {
     queryStringTurnoversCommittedTeam2 = ""
     } else {
     if turnoversCommittedTeam2OperatorValuePlayer == "≠" {
     queryOperatorTurnoversCommittedTeam2 = " != "
     } else {
     queryOperatorTurnoversCommittedTeam2 = " " + turnoversCommittedTeam2OperatorValuePlayer + " "
     }
     queryValueTurnoversCommittedTeam2 = String(turnoversCommittedTeam2SliderValuePlayer)
     queryStringTurnoversCommittedTeam2 = " AND LENGTH(\(queryColumnPenaltiesCommittedTeam1)) !=0 AND " + queryColumnTurnoversCommittedTeam2 + queryOperatorTurnoversCommittedTeam2 + queryValueTurnoversCommittedTeam2
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "PLAYER TEAM: PENALTIES" {
     queryStringPenaltiesCommittedTeam1 = ""
     } else {
     if penaltiesCommittedTeam1OperatorValuePlayer == "< >" {
     queryOperatorPenaltiesCommittedTeam1 = " BETWEEN "
     let queryLowerValuePenaltiesCommittedTeam1 = penaltiesCommittedTeam1RangeSliderLowerValuePlayer
     let queryUpperValuePenaltiesCommittedTeam1 = penaltiesCommittedTeam1RangeSliderUpperValuePlayer
     queryValuePenaltiesCommittedTeam1 = String(queryLowerValuePenaltiesCommittedTeam1) + " AND " + String(queryUpperValuePenaltiesCommittedTeam1)
     queryStringPenaltiesCommittedTeam1 = " AND " + queryColumnPenaltiesCommittedTeam1 + queryOperatorPenaltiesCommittedTeam1 + queryValuePenaltiesCommittedTeam1
     } else {
     if penaltiesCommittedTeam1SliderValuePlayer == -10000 {
     queryStringPenaltiesCommittedTeam1 = ""
     } else {
     if penaltiesCommittedTeam1OperatorValuePlayer == "≠" {
     queryOperatorPenaltiesCommittedTeam1 = " != "
     } else {
     queryOperatorPenaltiesCommittedTeam1 = " " + penaltiesCommittedTeam1OperatorValuePlayer + " "
     }
     queryValuePenaltiesCommittedTeam1 = String(penaltiesCommittedTeam1SliderValuePlayer)
     queryStringPenaltiesCommittedTeam1 = " AND LENGTH(\(queryColumnPenaltiesCommittedTeam1)) !=0 AND " + queryColumnPenaltiesCommittedTeam1 + queryOperatorPenaltiesCommittedTeam1 + queryValuePenaltiesCommittedTeam1
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "OPPONENT: PENALTIES" {
     queryStringPenaltiesCommittedTeam2 = ""
     } else {
     if penaltiesCommittedTeam2OperatorValuePlayer == "< >" {
     queryOperatorPenaltiesCommittedTeam2 = " BETWEEN "
     let queryLowerValuePenaltiesCommittedTeam2 = penaltiesCommittedTeam2RangeSliderLowerValuePlayer
     let queryUpperValuePenaltiesCommittedTeam2 = penaltiesCommittedTeam2RangeSliderUpperValuePlayer
     queryValuePenaltiesCommittedTeam2 = String(queryLowerValuePenaltiesCommittedTeam2) + " AND " + String(queryUpperValuePenaltiesCommittedTeam2)
     queryStringPenaltiesCommittedTeam2 = " AND " + queryColumnPenaltiesCommittedTeam2 + queryOperatorPenaltiesCommittedTeam2 + queryValuePenaltiesCommittedTeam2
     } else {
     if penaltiesCommittedTeam2SliderValuePlayer == -10000 {
     queryStringPenaltiesCommittedTeam2 = ""
     } else {
     if penaltiesCommittedTeam2OperatorValuePlayer == "≠" {
     queryOperatorPenaltiesCommittedTeam2 = " != "
     } else {
     queryOperatorPenaltiesCommittedTeam2 = " " + penaltiesCommittedTeam2OperatorValuePlayer + " "
     }
     queryValuePenaltiesCommittedTeam2 = String(penaltiesCommittedTeam2SliderValuePlayer)
     queryStringPenaltiesCommittedTeam2 = " AND LENGTH(\(queryColumnPenaltiesCommittedTeam2)) !=0 AND " + queryColumnPenaltiesCommittedTeam2 + queryOperatorPenaltiesCommittedTeam2 + queryValuePenaltiesCommittedTeam2
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "PLAYER TEAM: TOTAL YARDS" {
     queryStringTotalYardsTeam1 = ""
     } else {
     if totalYardsTeam1OperatorValuePlayer == "< >" {
     queryOperatorTotalYardsTeam1 = " BETWEEN "
     let queryLowerValueTotalYardsTeam1 = totalYardsTeam1RangeSliderLowerValuePlayer
     let queryUpperValueTotalYardsTeam1 = totalYardsTeam1RangeSliderUpperValuePlayer
     queryValueTotalYardsTeam1 = String(queryLowerValueTotalYardsTeam1) + " AND " + String(queryUpperValueTotalYardsTeam1)
     queryStringTotalYardsTeam1 = " AND " + queryColumnTotalYardsTeam1 + queryOperatorTotalYardsTeam1 + queryValueTotalYardsTeam1
     } else {
     if totalYardsTeam1SliderValuePlayer == -10000 {
     queryStringTotalYardsTeam1 = ""
     } else {
     if totalYardsTeam1OperatorValuePlayer == "≠" {
     queryOperatorTotalYardsTeam1 = " != "
     } else {
     queryOperatorTotalYardsTeam1 = " " + totalYardsTeam1OperatorValuePlayer + " "
     }
     queryValueTotalYardsTeam1 = String(totalYardsTeam1SliderValuePlayer)
     queryStringTotalYardsTeam1 = " AND LENGTH(\(queryColumnTotalYardsTeam1)) !=0 AND " + queryColumnTotalYardsTeam1 + queryOperatorTotalYardsTeam1 + queryValueTotalYardsTeam1
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "OPPONENT: TOTAL YARDS" {
     queryStringTotalYardsTeam2 = ""
     } else {
     if totalYardsTeam2OperatorValuePlayer == "< >" {
     queryOperatorTotalYardsTeam2 = " BETWEEN "
     let queryLowerValueTotalYardsTeam2 = totalYardsTeam2RangeSliderLowerValuePlayer
     let queryUpperValueTotalYardsTeam2 = totalYardsTeam2RangeSliderUpperValuePlayer
     queryValueTotalYardsTeam2 = String(queryLowerValueTotalYardsTeam2) + " AND " + String(queryUpperValueTotalYardsTeam2)
     queryStringTotalYardsTeam2 = " AND " + queryColumnTotalYardsTeam2 + queryOperatorTotalYardsTeam2 + queryValueTotalYardsTeam2
     } else {
     if totalYardsTeam2SliderValuePlayer == -10000 {
     queryStringTotalYardsTeam2 = ""
     } else {
     if totalYardsTeam2OperatorValuePlayer == "≠" {
     queryOperatorTotalYardsTeam2 = " != "
     } else {
     queryOperatorTotalYardsTeam2 = " " + totalYardsTeam2OperatorValuePlayer + " "
     }
     queryValueTotalYardsTeam2 = String(totalYardsTeam2SliderValuePlayer)
     queryStringTotalYardsTeam2 = " AND LENGTH(\(queryColumnTotalYardsTeam2)) !=0 AND " + queryColumnTotalYardsTeam2 + queryOperatorTotalYardsTeam2 + queryValueTotalYardsTeam2
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "PLAYER TEAM: PASSING YARDS" {
     queryStringPassingYardsTeam1 = ""
     } else {
     if passingYardsTeam1OperatorValuePlayer == "< >" {
     queryOperatorPassingYardsTeam1 = " BETWEEN "
     let queryLowerValuePassingYardsTeam1 = passingYardsTeam1RangeSliderLowerValuePlayer
     let queryUpperValuePassingYardsTeam1 = passingYardsTeam1RangeSliderUpperValuePlayer
     queryValuePassingYardsTeam1 = String(queryLowerValuePassingYardsTeam1) + " AND " + String(queryUpperValuePassingYardsTeam1)
     queryStringPassingYardsTeam1 = " AND " + queryColumnPassingYardsTeam1 + queryOperatorPassingYardsTeam1 + queryValuePassingYardsTeam1
     } else {
     if passingYardsTeam1SliderValuePlayer == -10000 {
     queryStringPassingYardsTeam1 = ""
     } else {
     if passingYardsTeam1OperatorValuePlayer == "≠" {
     queryOperatorPassingYardsTeam1 = " != "
     } else {
     queryOperatorPassingYardsTeam1 = " " + passingYardsTeam1OperatorValuePlayer + " "
     }
     queryValuePassingYardsTeam1 = String(passingYardsTeam1SliderValuePlayer)
     queryStringPassingYardsTeam1 = " AND LENGTH(\(queryColumnPassingYardsTeam1)) !=0 AND " + queryColumnPassingYardsTeam1 + queryOperatorPassingYardsTeam1 + queryValuePassingYardsTeam1
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "OPPONENT: PASSING YARDS" {
     queryStringPassingYardsTeam2 = ""
     } else {
     if passingYardsTeam2OperatorValuePlayer == "< >" {
     queryOperatorPassingYardsTeam2 = " BETWEEN "
     let queryLowerValuePassingYardsTeam2 = passingYardsTeam2RangeSliderLowerValuePlayer
     let queryUpperValuePassingYardsTeam2 = passingYardsTeam2RangeSliderUpperValuePlayer
     queryValuePassingYardsTeam2 = String(queryLowerValuePassingYardsTeam2) + " AND " + String(queryUpperValuePassingYardsTeam2)
     queryStringPassingYardsTeam2 = " AND " + queryColumnPassingYardsTeam2 + queryOperatorPassingYardsTeam2 + queryValuePassingYardsTeam2
     } else {
     if passingYardsTeam2SliderValuePlayer == -10000 {
     queryStringPassingYardsTeam2 = ""
     } else {
     if passingYardsTeam2OperatorValuePlayer == "≠" {
     queryOperatorPassingYardsTeam2 = " != "
     } else {
     queryOperatorPassingYardsTeam2 = " " + passingYardsTeam2OperatorValuePlayer + " "
     }
     queryValuePassingYardsTeam2 = String(passingYardsTeam2SliderValuePlayer)
     queryStringPassingYardsTeam2 = " AND LENGTH(\(queryColumnPassingYardsTeam2)) !=0 AND " + queryColumnPassingYardsTeam2 + queryOperatorPassingYardsTeam2 + queryValuePassingYardsTeam2
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "PLAYER TEAM: RUSHING YARDS" {
     queryStringRushingYardsTeam1 = ""
     } else {
     if rushingYardsTeam1OperatorValuePlayer == "< >" {
     queryOperatorRushingYardsTeam1 = " BETWEEN "
     let queryLowerValueRushingYardsTeam1 = rushingYardsTeam1RangeSliderLowerValuePlayer
     let queryUpperValueRushingYardsTeam1 = rushingYardsTeam1RangeSliderUpperValuePlayer
     queryValueRushingYardsTeam1 = String(queryLowerValueRushingYardsTeam1) + " AND " + String(queryUpperValueRushingYardsTeam1)
     queryStringRushingYardsTeam1 = " AND " + queryColumnRushingYardsTeam1 + queryOperatorRushingYardsTeam1 + queryValueRushingYardsTeam1
     } else {
     if rushingYardsTeam1SliderValuePlayer == -10000 {
     queryStringRushingYardsTeam1 = ""
     } else {
     if rushingYardsTeam1OperatorValuePlayer == "≠" {
     queryOperatorRushingYardsTeam1 = " != "
     } else {
     queryOperatorRushingYardsTeam1 = " " + rushingYardsTeam1OperatorValuePlayer + " "
     }
     queryValueRushingYardsTeam1 = String(rushingYardsTeam1SliderValuePlayer)
     queryStringRushingYardsTeam1 = " AND LENGTH(\(queryColumnRushingYardsTeam1)) !=0 AND " + queryColumnRushingYardsTeam1 + queryOperatorRushingYardsTeam1 + queryValueRushingYardsTeam1
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "OPPONENT: RUSHING YARDS" {
     queryStringRushingYardsTeam2 = ""
     } else {
     if rushingYardsTeam2OperatorValuePlayer == "< >" {
     queryOperatorRushingYardsTeam2 = " BETWEEN "
     let queryLowerValueRushingYardsTeam2 = rushingYardsTeam2RangeSliderLowerValuePlayer
     let queryUpperValueRushingYardsTeam2 = rushingYardsTeam2RangeSliderUpperValuePlayer
     queryValueRushingYardsTeam2 = String(queryLowerValueRushingYardsTeam2) + " AND " + String(queryUpperValueRushingYardsTeam2)
     queryStringRushingYardsTeam2 = " AND " + queryColumnRushingYardsTeam2 + queryOperatorRushingYardsTeam2 + queryValueRushingYardsTeam2
     } else {
     if rushingYardsTeam2SliderValuePlayer == -10000 {
     queryStringRushingYardsTeam2 = ""
     } else {
     if rushingYardsTeam2OperatorValuePlayer == "≠" {
     queryOperatorRushingYardsTeam2 = " != "
     } else {
     queryOperatorRushingYardsTeam2 = " " + rushingYardsTeam2OperatorValuePlayer + " "
     }
     queryValueRushingYardsTeam2 = String(rushingYardsTeam2SliderValuePlayer)
     queryStringRushingYardsTeam2 = " AND LENGTH(\(queryColumnRushingYardsTeam2)) !=0 AND " + queryColumnRushingYardsTeam2 + queryOperatorRushingYardsTeam2 + queryValueRushingYardsTeam2
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "PLAYER TEAM: QUARTERBACK RATING" {
     queryOperatorQuarterbackRatingTeam1 = ""
     } else {
     if quarterbackRatingTeam1OperatorValuePlayer == "< >" {
     queryOperatorQuarterbackRatingTeam1 = " BETWEEN "
     let queryLowerValueQuarterbackRatingTeam1 = quarterbackRatingTeam1RangeSliderLowerValuePlayer
     let queryUpperValueQuarterbackRatingTeam1 = quarterbackRatingTeam1RangeSliderUpperValuePlayer
     queryValueQuarterbackRatingTeam1 = String(queryLowerValueQuarterbackRatingTeam1) + " AND " + String(queryUpperValueQuarterbackRatingTeam1)
     queryStringQuarterbackRatingTeam1 = " AND " + queryColumnQuarterbackRatingTeam1 + queryOperatorQuarterbackRatingTeam1 + queryValueQuarterbackRatingTeam1
     } else {
     if quarterbackRatingTeam1SliderValuePlayer == -10000 {
     queryStringQuarterbackRatingTeam1 = ""
     } else {
     if quarterbackRatingTeam1OperatorValuePlayer == "≠" {
     queryOperatorQuarterbackRatingTeam1 = " != "
     } else {
     queryOperatorQuarterbackRatingTeam1 = " " + quarterbackRatingTeam1OperatorValuePlayer + " "
     }
     queryValueQuarterbackRatingTeam1 = String(quarterbackRatingTeam1SliderValuePlayer)
     queryStringQuarterbackRatingTeam1 = " AND LENGTH(\(queryColumnQuarterbackRatingTeam1)) !=0 AND " + queryColumnQuarterbackRatingTeam1 + queryOperatorQuarterbackRatingTeam1 + queryValueQuarterbackRatingTeam1
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "OPPONENT: QUARTERBACK RATING" {
     queryStringQuarterbackRatingTeam2 = ""
     } else {
     if quarterbackRatingTeam2OperatorValuePlayer == "< >" {
     queryOperatorQuarterbackRatingTeam2 = " BETWEEN "
     let queryLowerValueQuarterbackRatingTeam2 = quarterbackRatingTeam2RangeSliderLowerValuePlayer
     let queryUpperValueQuarterbackRatingTeam2 = quarterbackRatingTeam2RangeSliderUpperValuePlayer
     queryValueQuarterbackRatingTeam2 = String(queryLowerValueQuarterbackRatingTeam2) + " AND " + String(queryUpperValueQuarterbackRatingTeam2)
     queryStringQuarterbackRatingTeam2 = " AND " + queryColumnQuarterbackRatingTeam2 + queryOperatorQuarterbackRatingTeam2 + queryValueQuarterbackRatingTeam2
     } else {
     if quarterbackRatingTeam2SliderValuePlayer == -10000 {
     queryStringQuarterbackRatingTeam2 = ""
     } else {
     if quarterbackRatingTeam2OperatorValuePlayer == "≠" {
     queryOperatorQuarterbackRatingTeam2 = " != "
     } else {
     queryOperatorQuarterbackRatingTeam2 = " " + quarterbackRatingTeam2OperatorValuePlayer + " "
     }
     queryValueQuarterbackRatingTeam2 = String(quarterbackRatingTeam2SliderValuePlayer)
     queryStringQuarterbackRatingTeam2 = " AND LENGTH(\(queryColumnQuarterbackRatingTeam2)) !=0 AND " + queryColumnQuarterbackRatingTeam2 + queryOperatorQuarterbackRatingTeam2 + queryValueQuarterbackRatingTeam2
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "PLAYER TEAM: TIMES SACKED" {
     queryStringTimesSackedTeam1 = ""
     } else {
     if timesSackedTeam1OperatorValuePlayer == "< >" {
     queryOperatorTimesSackedTeam1 = " BETWEEN "
     let queryLowerValueTimesSackedTeam1 = timesSackedTeam1RangeSliderLowerValuePlayer
     let queryUpperValueTimesSackedTeam1 = timesSackedTeam1RangeSliderUpperValuePlayer
     queryValueTimesSackedTeam1 = String(queryLowerValueTimesSackedTeam1) + " AND " + String(queryUpperValueTimesSackedTeam1)
     queryStringTimesSackedTeam1 = " AND " + queryColumnTimesSackedTeam1 + queryOperatorTimesSackedTeam1 + queryValueTimesSackedTeam1
     } else {
     if timesSackedTeam1SliderValuePlayer == -10000 {
     queryStringTimesSackedTeam1 = ""
     } else {
     if timesSackedTeam1OperatorValuePlayer == "≠" {
     queryOperatorTimesSackedTeam1 = " != "
     } else {
     queryOperatorTimesSackedTeam1 = " " + timesSackedTeam1OperatorValuePlayer + " "
     }
     queryValueTimesSackedTeam1 = String(timesSackedTeam1SliderValuePlayer)
     queryStringTimesSackedTeam1 = " AND LENGTH(\(queryColumnTimesSackedTeam1)) !=0 AND " + queryColumnTimesSackedTeam1 + queryOperatorTimesSackedTeam1 + queryValueTimesSackedTeam1
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "OPPONENT: TIMES SACKED" {
     queryStringTimesSackedTeam2 = ""
     } else {
     if timesSackedTeam2OperatorValuePlayer == "< >" {
     queryOperatorTimesSackedTeam2 = " BETWEEN "
     let queryLowerValueTimesSackedTeam2 = timesSackedTeam2RangeSliderLowerValuePlayer
     let queryUpperValueTimesSackedTeam2 = timesSackedTeam2RangeSliderUpperValuePlayer
     queryValueTimesSackedTeam2 = String(queryLowerValueTimesSackedTeam2) + " AND " + String(queryUpperValueTimesSackedTeam2)
     queryStringTimesSackedTeam2 = " AND " + queryColumnTimesSackedTeam2 + queryOperatorTimesSackedTeam2 + queryValueTimesSackedTeam2
     } else {
     if timesSackedTeam2SliderValuePlayer == -10000 {
     queryStringTimesSackedTeam2 = ""
     } else {
     if timesSackedTeam2OperatorValuePlayer == "≠" {
     queryOperatorTimesSackedTeam2 = " != "
     } else {
     queryOperatorTimesSackedTeam2 = " " + timesSackedTeam2OperatorValuePlayer + " "
     }
     queryValueTimesSackedTeam2 = String(timesSackedTeam2SliderValuePlayer)
     queryStringTimesSackedTeam2 = " AND LENGTH(\(queryColumnTimesSackedTeam2)) !=0 AND " + queryColumnTimesSackedTeam2 + queryOperatorTimesSackedTeam2 + queryValueTimesSackedTeam2
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "PLAYER TEAM: INTERCEPTIONS THROWN" {
     queryStringInterceptionsThrownTeam1 = ""
     } else {
     if interceptionsThrownTeam1OperatorValuePlayer == "< >" {
     queryOperatorInterceptionsThrownTeam1 = " BETWEEN "
     let queryLowerValueInterceptionsThrownTeam1 = interceptionsThrownTeam1RangeSliderLowerValuePlayer
     let queryUpperValueInterceptionsThrownTeam1 = interceptionsThrownTeam1RangeSliderUpperValuePlayer
     queryValueInterceptionsThrownTeam1 = String(queryLowerValueInterceptionsThrownTeam1) + " AND " + String(queryUpperValueInterceptionsThrownTeam1)
     queryStringInterceptionsThrownTeam1 = " AND " + queryColumnInterceptionsThrownTeam1 + queryOperatorInterceptionsThrownTeam1 + queryValueInterceptionsThrownTeam1
     } else {
     if interceptionsThrownTeam1SliderValuePlayer == -10000 {
     queryStringInterceptionsThrownTeam1 = ""
     } else {
     if interceptionsThrownTeam1OperatorValuePlayer == "≠" {
     queryOperatorInterceptionsThrownTeam1 = " != "
     } else {
     queryOperatorInterceptionsThrownTeam1 = " " + interceptionsThrownTeam1OperatorValuePlayer + " "
     }
     queryValueInterceptionsThrownTeam1 = String(interceptionsThrownTeam1SliderValuePlayer)
     queryStringInterceptionsThrownTeam1 = " AND LENGTH(\(queryColumnInterceptionsThrownTeam1)) !=0 AND " + queryColumnInterceptionsThrownTeam1 + queryOperatorInterceptionsThrownTeam1 + queryValueInterceptionsThrownTeam1
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "OPPONENT: INTERCEPTIONS THROWN" {
     queryStringInterceptionsThrownTeam2 = ""
     } else {
     if interceptionsThrownTeam2OperatorValuePlayer == "< >" {
     queryOperatorInterceptionsThrownTeam2 = " BETWEEN "
     let queryLowerValueInterceptionsThrownTeam2 = interceptionsThrownTeam2RangeSliderLowerValuePlayer
     let queryUpperValueInterceptionsThrownTeam2 = interceptionsThrownTeam2RangeSliderUpperValuePlayer
     queryValueInterceptionsThrownTeam2 = String(queryLowerValueInterceptionsThrownTeam2) + " AND " + String(queryUpperValueInterceptionsThrownTeam2)
     queryStringInterceptionsThrownTeam2 = " AND " + queryColumnInterceptionsThrownTeam2 + queryOperatorInterceptionsThrownTeam2 + queryValueInterceptionsThrownTeam2
     } else {
     if interceptionsThrownTeam2SliderValuePlayer == -10000 {
     queryStringInterceptionsThrownTeam2 = ""
     } else {
     if interceptionsThrownTeam2OperatorValuePlayer == "≠" {
     queryOperatorInterceptionsThrownTeam2 = " != "
     } else {
     queryOperatorInterceptionsThrownTeam2 = " " + interceptionsThrownTeam2OperatorValuePlayer + " "
     }
     queryValueInterceptionsThrownTeam2 = String(interceptionsThrownTeam2SliderValuePlayer)
     queryStringInterceptionsThrownTeam2 = " AND LENGTH(\(queryColumnInterceptionsThrownTeam2)) !=0 AND " + queryColumnInterceptionsThrownTeam2 + queryOperatorInterceptionsThrownTeam2 + queryValueInterceptionsThrownTeam2
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "PLAYER TEAM: OFFENSIVE PLAYS" {
     queryStringOffensivePlaysTeam1 = ""
     } else {
     if offensivePlaysTeam1OperatorValuePlayer == "< >" {
     queryOperatorOffensivePlaysTeam1 = " BETWEEN "
     let queryLowerValueOffensivePlaysTeam1 = offensivePlaysTeam1RangeSliderLowerValuePlayer
     let queryUpperValueOffensivePlaysTeam1 = offensivePlaysTeam1RangeSliderUpperValuePlayer
     queryValueOffensivePlaysTeam1 = String(queryLowerValueOffensivePlaysTeam1) + " AND " + String(queryUpperValueOffensivePlaysTeam1)
     queryStringOffensivePlaysTeam1 = " AND " + queryColumnOffensivePlaysTeam1 + queryOperatorOffensivePlaysTeam1 + queryValueOffensivePlaysTeam1
     } else {
     if offensivePlaysTeam1SliderValuePlayer == -10000 {
     queryStringOffensivePlaysTeam1 = ""
     } else {
     if offensivePlaysTeam1OperatorValuePlayer == "≠" {
     queryOperatorOffensivePlaysTeam1 = " != "
     } else {
     queryOperatorOffensivePlaysTeam1 = " " + offensivePlaysTeam1OperatorValuePlayer + " "
     }
     queryValueOffensivePlaysTeam1 = String(offensivePlaysTeam1SliderValuePlayer)
     queryStringOffensivePlaysTeam1 = " AND LENGTH(\(queryColumnOffensivePlaysTeam1)) !=0 AND " + queryColumnOffensivePlaysTeam1 + queryOperatorOffensivePlaysTeam1 + queryValueOffensivePlaysTeam1
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "OPPONENT: OFFENSIVE PLAYS" {
     queryStringOffensivePlaysTeam2 = ""
     } else {
     if offensivePlaysTeam2OperatorValuePlayer == "< >" {
     queryOperatorOffensivePlaysTeam2 = " BETWEEN "
     let queryLowerValueOffensivePlaysTeam2 = offensivePlaysTeam2RangeSliderLowerValuePlayer
     let queryUpperValueOffensivePlaysTeam2 = offensivePlaysTeam2RangeSliderUpperValuePlayer
     queryValueOffensivePlaysTeam2 = String(queryLowerValueOffensivePlaysTeam2) + " AND " + String(queryUpperValueOffensivePlaysTeam2)
     queryStringOffensivePlaysTeam2 = " AND " + queryColumnOffensivePlaysTeam2 + queryOperatorOffensivePlaysTeam2 + queryValueOffensivePlaysTeam2
     } else {
     if offensivePlaysTeam2SliderValuePlayer == -10000 {
     queryStringOffensivePlaysTeam2 = ""
     } else {
     if offensivePlaysTeam2OperatorValuePlayer == "≠" {
     queryOperatorOffensivePlaysTeam2 = " != "
     } else {
     queryOperatorOffensivePlaysTeam2 = " " + offensivePlaysTeam2OperatorValuePlayer + " "
     }
     queryValueOffensivePlaysTeam2 = String(offensivePlaysTeam2SliderValuePlayer)
     queryStringOffensivePlaysTeam2 = " AND LENGTH(\(queryColumnOffensivePlaysTeam2)) !=0 AND " + queryColumnOffensivePlaysTeam2 + queryOperatorOffensivePlaysTeam2 + queryValueOffensivePlaysTeam2
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "PLAYER TEAM: YARDS/OFFENSIVE PLAY" {
     queryStringYardsPerOffensivePlayTeam1 = ""
     } else {
     if yardsPerOffensivePlayTeam1OperatorValuePlayer == "< >" {
     queryOperatorYardsPerOffensivePlayTeam1 = " BETWEEN "
     let queryLowerValueYardsPerOffensivePlayTeam1 = yardsPerOffensivePlayTeam1RangeSliderLowerValuePlayer
     let queryUpperValueYardsPerOffensivePlayTeam1 = yardsPerOffensivePlayTeam1RangeSliderUpperValuePlayer
     queryValueYardsPerOffensivePlayTeam1 = String(queryLowerValueYardsPerOffensivePlayTeam1) + " AND " + String(queryUpperValueYardsPerOffensivePlayTeam1)
     queryStringYardsPerOffensivePlayTeam1 = " AND " + queryColumnYardsPerOffensivePlayTeam1 + queryOperatorYardsPerOffensivePlayTeam1 + queryValueYardsPerOffensivePlayTeam1
     } else {
     if yardsPerOffensivePlayTeam1SliderValuePlayer == -10000 {
     queryStringYardsPerOffensivePlayTeam1 = ""
     } else {
     if yardsPerOffensivePlayTeam1OperatorValuePlayer == "≠" {
     queryOperatorYardsPerOffensivePlayTeam1 = " != "
     } else {
     queryOperatorYardsPerOffensivePlayTeam1 = " " + yardsPerOffensivePlayTeam1OperatorValuePlayer + " "
     }
     queryValueYardsPerOffensivePlayTeam1 = String(yardsPerOffensivePlayTeam1SliderValuePlayer)
     queryStringYardsPerOffensivePlayTeam1 = " AND LENGTH(\(queryColumnYardsPerOffensivePlayTeam1)) !=0 AND " + queryColumnYardsPerOffensivePlayTeam1 + queryOperatorYardsPerOffensivePlayTeam1 + queryValueYardsPerOffensivePlayTeam1
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "OPPONENT: YARDS/OFFENSIVE PLAY" {
     queryStringYardsPerOffensivePlayTeam2 = ""
     } else {
     if yardsPerOffensivePlayTeam2OperatorValuePlayer == "< >" {
     queryOperatorYardsPerOffensivePlayTeam2 = " BETWEEN "
     let queryLowerValueYardsPerOffensivePlayTeam2 = yardsPerOffensivePlayTeam2RangeSliderLowerValuePlayer
     let queryUpperValueYardsPerOffensivePlayTeam2 = yardsPerOffensivePlayTeam2RangeSliderUpperValuePlayer
     queryValueYardsPerOffensivePlayTeam2 = String(queryLowerValueYardsPerOffensivePlayTeam2) + " AND " + String(queryUpperValueYardsPerOffensivePlayTeam2)
     queryStringYardsPerOffensivePlayTeam2 = " AND " + queryColumnYardsPerOffensivePlayTeam2 + queryOperatorYardsPerOffensivePlayTeam2 + queryValueYardsPerOffensivePlayTeam2
     } else {
     if yardsPerOffensivePlayTeam2SliderValuePlayer == -10000 {
     queryStringYardsPerOffensivePlayTeam2 = ""
     } else {
     if yardsPerOffensivePlayTeam2OperatorValuePlayer == "≠" {
     queryOperatorYardsPerOffensivePlayTeam2 = " != "
     } else {
     queryOperatorYardsPerOffensivePlayTeam2 = " " + yardsPerOffensivePlayTeam2OperatorValuePlayer + " "
     }
     queryValueYardsPerOffensivePlayTeam2 = String(yardsPerOffensivePlayTeam2SliderValuePlayer)
     queryStringYardsPerOffensivePlayTeam2 = " AND LENGTH(\(queryColumnYardsPerOffensivePlayTeam2)) !=0 AND " + queryColumnYardsPerOffensivePlayTeam2 + queryOperatorYardsPerOffensivePlayTeam2 + queryValueYardsPerOffensivePlayTeam2
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "PLAYER TEAM: SACKS" {
     queryValueSacksTeam1 = ""
     } else {
     if sacksTeam1OperatorValuePlayer == "< >" {
     queryOperatorSacksTeam1 = " BETWEEN "
     let queryLowerValueSacksTeam1 = sacksTeam1RangeSliderLowerValuePlayer
     let queryUpperValueSacksTeam1 = sacksTeam1RangeSliderUpperValuePlayer
     queryValueSacksTeam1 = String(queryLowerValueSacksTeam1) + " AND " + String(queryUpperValueSacksTeam1)
     queryStringSacksTeam1 = " AND " + queryColumnSacksTeam1 + queryOperatorSacksTeam1 + queryValueSacksTeam1
     } else {
     if sacksTeam1SliderValuePlayer == -10000 {
     queryStringSacksTeam1 = ""
     } else {
     if sacksTeam1OperatorValuePlayer == "≠" {
     queryOperatorSacksTeam1 = " != "
     } else {
     queryOperatorSacksTeam1 = " " + sacksTeam1OperatorValuePlayer + " "
     }
     queryValueSacksTeam1 = String(sacksTeam1SliderValuePlayer)
     queryStringSacksTeam1 = " AND LENGTH(\(queryColumnSacksTeam1)) !=0 AND " + queryColumnSacksTeam1 + queryOperatorSacksTeam1 + queryValueSacksTeam1
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "OPPONENT: SACKS" {
     queryValueSacksTeam2 = ""
     } else {
     if sacksTeam2OperatorValuePlayer == "< >" {
     queryOperatorSacksTeam2 = " BETWEEN "
     let queryLowerValueSacksTeam2 = sacksTeam2RangeSliderLowerValuePlayer
     let queryUpperValueSacksTeam2 = sacksTeam2RangeSliderUpperValuePlayer
     queryValueSacksTeam2 = String(queryLowerValueSacksTeam2) + " AND " + String(queryUpperValueSacksTeam2)
     queryStringSacksTeam2 = " AND " + queryColumnSacksTeam2 + queryOperatorSacksTeam2 + queryValueSacksTeam2
     } else {
     if sacksTeam2SliderValuePlayer == -10000 {
     queryStringSacksTeam2 = ""
     } else {
     if sacksTeam2OperatorValuePlayer == "≠" {
     queryOperatorSacksTeam2 = " != "
     } else {
     queryOperatorSacksTeam2 = " " + sacksTeam2OperatorValuePlayer + " "
     }
     queryValueSacksTeam2 = String(sacksTeam2SliderValuePlayer)
     queryStringSacksTeam2 = " AND LENGTH(\(queryColumnSacksTeam2)) !=0 AND " + queryColumnSacksTeam2 + queryOperatorSacksTeam2 + queryValueSacksTeam2
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "PLAYER TEAM: INTERCEPTIONS" {
     queryStringInterceptionsTeam1 = ""
     } else {
     if interceptionsTeam1OperatorValuePlayer == "< >" {
     queryOperatorInterceptionsTeam1 = " BETWEEN "
     let queryLowerValueInterceptionsTeam1 = interceptionsTeam1RangeSliderLowerValuePlayer
     let queryUpperValueInterceptionsTeam1 = interceptionsTeam1RangeSliderUpperValuePlayer
     queryValueInterceptionsTeam1 = String(queryLowerValueInterceptionsTeam1) + " AND " + String(queryUpperValueInterceptionsTeam1)
     queryStringInterceptionsTeam1 = " AND " + queryColumnInterceptionsTeam1 + queryOperatorInterceptionsTeam1 + queryValueInterceptionsTeam1
     } else {
     if interceptionsTeam1SliderValuePlayer == -10000 {
     queryStringInterceptionsTeam1 = ""
     } else {
     if interceptionsTeam1OperatorValuePlayer == "≠" {
     queryOperatorInterceptionsTeam1 = " != "
     } else {
     queryOperatorInterceptionsTeam1 = " " + interceptionsTeam1OperatorValuePlayer + " "
     }
     queryValueInterceptionsTeam1 = String(interceptionsTeam1SliderValuePlayer)
     queryStringInterceptionsTeam1 = " AND LENGTH(\(queryColumnInterceptionsTeam1)) !=0 AND " + queryColumnInterceptionsTeam1 + queryOperatorInterceptionsTeam1 + queryValueInterceptionsTeam1
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "OPPONENT: INTERCEPTIONS" {
     queryStringInterceptionsTeam2 = ""
     } else {
     if interceptionsTeam2OperatorValuePlayer == "< >" {
     queryOperatorInterceptionsTeam2 = " BETWEEN "
     let queryLowerValueInterceptionsTeam2 = interceptionsTeam2RangeSliderLowerValuePlayer
     let queryUpperValueInterceptionsTeam2 = interceptionsTeam2RangeSliderUpperValuePlayer
     queryValueInterceptionsTeam2 = String(queryLowerValueInterceptionsTeam2) + " AND " + String(queryUpperValueInterceptionsTeam2)
     queryStringInterceptionsTeam2 = " AND " + queryColumnInterceptionsTeam2 + queryOperatorInterceptionsTeam2 + queryValueInterceptionsTeam2
     } else {
     if interceptionsTeam2SliderValuePlayer == -10000 {
     queryStringInterceptionsTeam2 = ""
     } else {
     if interceptionsTeam2OperatorValuePlayer == "≠" {
     queryOperatorInterceptionsTeam2 = " != "
     } else {
     queryOperatorInterceptionsTeam2 = " " + interceptionsTeam2OperatorValuePlayer + " "
     }
     queryValueInterceptionsTeam2 = String(interceptionsTeam2SliderValuePlayer)
     queryStringInterceptionsTeam2 = " AND LENGTH(\(queryColumnInterceptionsTeam2)) !=0 AND " + queryColumnInterceptionsTeam2 + queryOperatorInterceptionsTeam2 + queryValueInterceptionsTeam2
     }
     
     }
     }
     
     if clearSliderIndicatorPlayer == "PLAYER TEAM: SAFETIES" {
     queryValueSafetiesTeam1 = ""
     } else {
     if safetiesTeam1OperatorValuePlayer == "< >" {
     queryOperatorSafetiesTeam1 = " BETWEEN "
     let queryLowerValueSafetiesTeam1 = safetiesTeam1RangeSliderLowerValuePlayer
     let queryUpperValueSafetiesTeam1 = safetiesTeam1RangeSliderUpperValuePlayer
     queryValueSafetiesTeam1 = String(queryLowerValueSafetiesTeam1) + " AND " + String(queryUpperValueSafetiesTeam1)
     queryStringSafetiesTeam1 = " AND " + queryColumnSafetiesTeam1 + queryOperatorSafetiesTeam1 + queryValueSafetiesTeam1
     } else {
     if safetiesTeam1SliderValuePlayer == -10000 {
     queryStringSafetiesTeam1 = ""
     } else {
     if safetiesTeam1OperatorValuePlayer == "≠" {
     queryOperatorSafetiesTeam1 = " != "
     } else {
     queryOperatorSafetiesTeam1 = " " + safetiesTeam1OperatorValuePlayer + " "
     }
     queryValueSafetiesTeam1 = String(safetiesTeam1SliderValuePlayer)
     queryStringSafetiesTeam1 = " AND LENGTH(\(queryColumnSafetiesTeam1)) !=0 AND " + queryColumnSafetiesTeam1 + queryOperatorSafetiesTeam1 + queryValueSafetiesTeam1
     }
     
     }
     }
     
     if clearSliderIndicatorPlayer == "OPPONENT: SAFETIES" {
     queryValueSafetiesTeam2 = ""
     } else {
     if safetiesTeam2OperatorValuePlayer == "< >" {
     queryOperatorSafetiesTeam2 = " BETWEEN "
     let queryLowerValueSafetiesTeam2 = safetiesTeam2RangeSliderLowerValuePlayer
     let queryUpperValueSafetiesTeam2 = safetiesTeam2RangeSliderUpperValuePlayer
     queryValueSafetiesTeam2 = String(queryLowerValueSafetiesTeam2) + " AND " + String(queryUpperValueSafetiesTeam2)
     queryStringSafetiesTeam2 = " AND " + queryColumnSafetiesTeam2 + queryOperatorSafetiesTeam2 + queryValueSafetiesTeam2
     } else {
     if safetiesTeam2SliderValuePlayer == -10000 {
     queryStringSafetiesTeam2 = ""
     } else {
     if safetiesTeam2OperatorValuePlayer == "≠" {
     queryOperatorSafetiesTeam2 = " != "
     } else {
     queryOperatorSafetiesTeam2 = " " + safetiesTeam2OperatorValuePlayer + " "
     }
     queryValueSafetiesTeam2 = String(safetiesTeam2SliderValuePlayer)
     queryStringSafetiesTeam2 = " AND LENGTH(\(queryColumnSafetiesTeam2)) !=0 AND " + queryColumnSafetiesTeam2 + queryOperatorSafetiesTeam2 + queryValueSafetiesTeam2
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "PLAYER TEAM: DEFENSIVE PLAYS" {
     queryStringDefensivePlaysTeam1 = ""
     } else {
     if defensivePlaysTeam1OperatorValuePlayer == "< >" {
     queryOperatorDefensivePlaysTeam1 = " BETWEEN "
     let queryLowerValueDefensivePlaysTeam1 = defensivePlaysTeam1RangeSliderLowerValuePlayer
     let queryUpperValueDefensivePlaysTeam1 = defensivePlaysTeam1RangeSliderUpperValuePlayer
     queryValueDefensivePlaysTeam1 = String(queryLowerValueDefensivePlaysTeam1) + " AND " + String(queryUpperValueDefensivePlaysTeam1)
     queryStringDefensivePlaysTeam1 = " AND " + queryColumnDefensivePlaysTeam1 + queryOperatorDefensivePlaysTeam1 + queryValueDefensivePlaysTeam1
     } else {
     if defensivePlaysTeam1SliderValuePlayer == -10000 {
     queryStringDefensivePlaysTeam1 = ""
     } else {
     if defensivePlaysTeam1OperatorValuePlayer == "≠" {
     queryOperatorDefensivePlaysTeam1 = " != "
     } else {
     queryOperatorDefensivePlaysTeam1 = " " + defensivePlaysTeam1OperatorValuePlayer + " "
     }
     queryValueDefensivePlaysTeam1 = String(defensivePlaysTeam1SliderValuePlayer)
     queryStringDefensivePlaysTeam1 = " AND LENGTH(\(queryColumnDefensivePlaysTeam1)) !=0 AND " + queryColumnDefensivePlaysTeam1 + queryOperatorDefensivePlaysTeam1 + queryValueDefensivePlaysTeam1
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "OPPONENT: DEFENSIVE PLAYS" {
     queryStringDefensivePlaysTeam2 = ""
     } else {
     if defensivePlaysTeam2OperatorValuePlayer == "< >" {
     queryOperatorDefensivePlaysTeam2 = " BETWEEN "
     let queryLowerValueDefensivePlaysTeam2 = defensivePlaysTeam2RangeSliderLowerValuePlayer
     let queryUpperValueDefensivePlaysTeam2 = defensivePlaysTeam2RangeSliderUpperValuePlayer
     queryValueDefensivePlaysTeam2 = String(queryLowerValueDefensivePlaysTeam2) + " AND " + String(queryUpperValueDefensivePlaysTeam2)
     queryStringDefensivePlaysTeam2 = " AND " + queryColumnDefensivePlaysTeam2 + queryOperatorDefensivePlaysTeam2 + queryValueDefensivePlaysTeam2
     } else {
     if defensivePlaysTeam2SliderValuePlayer == -10000 {
     queryStringDefensivePlaysTeam2 = ""
     } else {
     if defensivePlaysTeam2OperatorValuePlayer == "≠" {
     queryOperatorDefensivePlaysTeam2 = " != "
     } else {
     queryOperatorDefensivePlaysTeam2 = " " + defensivePlaysTeam2OperatorValuePlayer + " "
     }
     queryValueDefensivePlaysTeam2 = String(defensivePlaysTeam2SliderValuePlayer)
     queryStringDefensivePlaysTeam2 = " AND LENGTH(\(queryColumnDefensivePlaysTeam2)) !=0 AND " + queryColumnDefensivePlaysTeam2 + queryOperatorDefensivePlaysTeam2 + queryValueDefensivePlaysTeam2
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "PLAYER TEAM: YARDS/DEFENSIVE PLAY" {
     queryStringYardsPerDefensivePlayTeam1 = ""
     } else {
     if yardsPerDefensivePlayTeam1OperatorValuePlayer == "< >" {
     queryOperatorYardsPerDefensivePlayTeam1 = " BETWEEN "
     let queryLowerValueYardsPerDefensivePlayTeam1 = yardsPerDefensivePlayTeam1RangeSliderLowerValuePlayer
     let queryUpperValueYardsPerDefensivePlayTeam1 = yardsPerDefensivePlayTeam1RangeSliderUpperValuePlayer
     queryValueYardsPerDefensivePlayTeam1 = String(queryLowerValueYardsPerDefensivePlayTeam1) + " AND " + String(queryUpperValueYardsPerDefensivePlayTeam1)
     queryStringYardsPerDefensivePlayTeam1 = " AND " + queryColumnYardsPerDefensivePlayTeam1 + queryOperatorYardsPerDefensivePlayTeam1 + queryValueYardsPerDefensivePlayTeam1
     } else {
     if yardsPerDefensivePlayTeam1SliderValuePlayer == -10000 {
     queryStringYardsPerDefensivePlayTeam1 = ""
     } else {
     if yardsPerDefensivePlayTeam1OperatorValuePlayer == "≠" {
     queryOperatorYardsPerDefensivePlayTeam1 = " != "
     } else {
     queryOperatorYardsPerDefensivePlayTeam1 = " " + yardsPerDefensivePlayTeam1OperatorValuePlayer + " "
     }
     queryValueYardsPerDefensivePlayTeam1 = String(yardsPerDefensivePlayTeam1SliderValuePlayer)
     queryStringYardsPerDefensivePlayTeam1 = " AND LENGTH(\(queryColumnYardsPerDefensivePlayTeam1)) !=0 AND " + queryColumnYardsPerDefensivePlayTeam1 + queryOperatorYardsPerDefensivePlayTeam1 + queryValueYardsPerDefensivePlayTeam1
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "OPPONENT: YARDS/DEFENSIVE PLAY" {
     queryStringYardsPerDefensivePlayTeam2 = ""
     } else {
     if yardsPerDefensivePlayTeam2OperatorValuePlayer == "< >" {
     queryOperatorYardsPerDefensivePlayTeam2 = " BETWEEN "
     let queryLowerValueYardsPerDefensivePlayTeam2 = yardsPerDefensivePlayTeam2RangeSliderLowerValuePlayer
     let queryUpperValueYardsPerDefensivePlayTeam2 = yardsPerDefensivePlayTeam2RangeSliderUpperValuePlayer
     queryValueYardsPerDefensivePlayTeam2 = String(queryLowerValueYardsPerDefensivePlayTeam2) + " AND " + String(queryUpperValueYardsPerDefensivePlayTeam2)
     queryStringYardsPerDefensivePlayTeam2 = " AND " + queryColumnYardsPerDefensivePlayTeam2 + queryOperatorYardsPerDefensivePlayTeam2 + queryValueYardsPerDefensivePlayTeam2
     } else {
     if yardsPerDefensivePlayTeam2SliderValuePlayer == -10000 {
     queryStringYardsPerDefensivePlayTeam2 = ""
     } else {
     if yardsPerDefensivePlayTeam2OperatorValuePlayer == "≠" {
     queryOperatorYardsPerDefensivePlayTeam2 = " != "
     } else {
     queryOperatorYardsPerDefensivePlayTeam2 = " " + yardsPerDefensivePlayTeam2OperatorValuePlayer + " "
     }
     queryValueYardsPerDefensivePlayTeam2 = String(yardsPerDefensivePlayTeam2SliderValuePlayer)
     queryStringYardsPerDefensivePlayTeam2 = " AND LENGTH(\(queryColumnYardsPerDefensivePlayTeam2)) !=0 AND " + queryColumnYardsPerDefensivePlayTeam2 + queryOperatorYardsPerDefensivePlayTeam2 + queryValueYardsPerDefensivePlayTeam2
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "PLAYER TEAM: EXTRA POINT ATTEMPTS" {
     queryStringExtraPointAttemptsTeam1 = ""
     } else {
     if extraPointAttemptsTeam1OperatorValuePlayer == "< >" {
     queryOperatorExtraPointAttemptsTeam1 = " BETWEEN "
     let queryLowerValueExtraPointAttemptsTeam1 = extraPointAttemptsTeam1RangeSliderLowerValuePlayer
     let queryUpperValueExtraPointAttemptsTeam1 = extraPointAttemptsTeam1RangeSliderUpperValuePlayer
     queryValueExtraPointAttemptsTeam1 = String(queryLowerValueExtraPointAttemptsTeam1) + " AND " + String(queryUpperValueExtraPointAttemptsTeam1)
     queryStringExtraPointAttemptsTeam1 = " AND " + queryColumnExtraPointAttemptsTeam1 + queryOperatorExtraPointAttemptsTeam1 + queryValueExtraPointAttemptsTeam1
     } else {
     if extraPointAttemptsTeam1SliderValuePlayer == -10000 {
     queryStringExtraPointAttemptsTeam1 = ""
     } else {
     if extraPointAttemptsTeam1OperatorValuePlayer == "≠" {
     queryOperatorExtraPointAttemptsTeam1 = " != "
     } else {
     queryOperatorExtraPointAttemptsTeam1 = " " + extraPointAttemptsTeam1OperatorValuePlayer + " "
     }
     queryValueExtraPointAttemptsTeam1 = String(extraPointAttemptsTeam1SliderValuePlayer)
     queryStringExtraPointAttemptsTeam1 = " AND LENGTH(\(queryColumnExtraPointAttemptsTeam1)) !=0 AND " + queryColumnExtraPointAttemptsTeam1 + queryOperatorExtraPointAttemptsTeam1 + queryValueExtraPointAttemptsTeam1
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "OPPONENT: EXTRA POINTS ATTEMPTS" {
     queryStringExtraPointAttemptsTeam2 = ""
     } else {
     if extraPointAttemptsTeam2OperatorValuePlayer == "< >" {
     queryOperatorExtraPointAttemptsTeam2 = " BETWEEN "
     let queryLowerValueExtraPointAttemptsTeam2 = extraPointAttemptsTeam2RangeSliderLowerValuePlayer
     let queryUpperValueExtraPointAttemptsTeam2 = extraPointAttemptsTeam2RangeSliderUpperValuePlayer
     queryValueExtraPointAttemptsTeam2 = String(queryLowerValueExtraPointAttemptsTeam2) + " AND " + String(queryUpperValueExtraPointAttemptsTeam2)
     queryStringExtraPointAttemptsTeam2 = " AND " + queryColumnExtraPointAttemptsTeam2 + queryOperatorExtraPointAttemptsTeam2 + queryValueExtraPointAttemptsTeam2
     } else {
     if extraPointAttemptsTeam2SliderValuePlayer == -10000 {
     queryStringExtraPointAttemptsTeam2 = ""
     } else {
     if extraPointAttemptsTeam2OperatorValuePlayer == "≠" {
     queryOperatorExtraPointAttemptsTeam2 = " != "
     } else {
     queryOperatorExtraPointAttemptsTeam2 = " " + extraPointAttemptsTeam2OperatorValuePlayer + " "
     }
     queryValueExtraPointAttemptsTeam2 = String(extraPointAttemptsTeam2SliderValuePlayer)
     queryStringExtraPointAttemptsTeam2 = " AND LENGTH(\(queryColumnExtraPointAttemptsTeam2)) !=0 AND " + queryColumnExtraPointAttemptsTeam2 + queryOperatorExtraPointAttemptsTeam2 + queryValueExtraPointAttemptsTeam2
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "PLAYER TEAM: EXTRA POINTS MADE" {
     queryStringExtraPointsMadeTeam1 = ""
     } else {
     if extraPointsMadeTeam1OperatorValuePlayer == "< >" {
     queryOperatorExtraPointsMadeTeam1 = " BETWEEN "
     let queryLowerValueExtraPointsMadeTeam1 = extraPointsMadeTeam1RangeSliderLowerValuePlayer
     let queryUpperValueExtraPointsMadeTeam1 = extraPointsMadeTeam1RangeSliderUpperValuePlayer
     queryValueExtraPointsMadeTeam1 = String(queryLowerValueExtraPointsMadeTeam1) + " AND " + String(queryUpperValueExtraPointsMadeTeam1)
     queryStringExtraPointsMadeTeam1 = " AND " + queryColumnExtraPointsMadeTeam1 + queryOperatorExtraPointsMadeTeam1 + queryValueExtraPointsMadeTeam1
     } else {
     if extraPointsMadeTeam1SliderValuePlayer == -10000 {
     queryStringExtraPointsMadeTeam1 = ""
     } else {
     if extraPointsMadeTeam1OperatorValuePlayer == "≠" {
     queryOperatorExtraPointsMadeTeam1 = " != "
     } else {
     queryOperatorExtraPointsMadeTeam1 = " " + extraPointsMadeTeam1OperatorValuePlayer + " "
     }
     queryValueExtraPointsMadeTeam1 = String(extraPointsMadeTeam1SliderValuePlayer)
     queryStringExtraPointsMadeTeam1 = " AND LENGTH(\(queryColumnExtraPointsMadeTeam1)) !=0 AND " + queryColumnExtraPointsMadeTeam1 + queryOperatorExtraPointsMadeTeam1 + queryValueExtraPointsMadeTeam1
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "OPPONENT: EXTRA POINTS MADE" {
     queryStringExtraPointsMadeTeam2 = ""
     } else {
     if extraPointsMadeTeam2OperatorValuePlayer == "< >" {
     queryOperatorExtraPointsMadeTeam2 = " BETWEEN "
     let queryLowerValueExtraPointsMadeTeam2 = extraPointsMadeTeam2RangeSliderLowerValuePlayer
     let queryUpperValueExtraPointsMadeTeam2 = extraPointsMadeTeam2RangeSliderUpperValuePlayer
     queryValueExtraPointsMadeTeam2 = String(queryLowerValueExtraPointsMadeTeam2) + " AND " + String(queryUpperValueExtraPointsMadeTeam2)
     queryStringExtraPointsMadeTeam2 = " AND " + queryColumnExtraPointsMadeTeam2 + queryOperatorExtraPointsMadeTeam2 + queryValueExtraPointsMadeTeam2
     } else {
     if extraPointsMadeTeam2SliderValuePlayer == -10000 {
     queryStringExtraPointsMadeTeam2 = ""
     } else {
     if extraPointsMadeTeam2OperatorValuePlayer == "≠" {
     queryOperatorExtraPointsMadeTeam2 = " != "
     } else {
     queryOperatorExtraPointsMadeTeam2 = " " + extraPointsMadeTeam2OperatorValuePlayer + " "
     }
     queryValueExtraPointsMadeTeam2 = String(extraPointsMadeTeam2SliderValuePlayer)
     queryStringExtraPointsMadeTeam2 = " AND LENGTH(\(queryColumnExtraPointsMadeTeam2)) !=0 AND " + queryColumnExtraPointsMadeTeam2 + queryOperatorExtraPointsMadeTeam2 + queryValueExtraPointsMadeTeam2
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "PLAYER TEAM: FIELD GOAL ATTEMPTS" {
     queryStringFieldGoalAttemptsTeam1 = ""
     } else {
     if fieldGoalAttemptsTeam1OperatorValuePlayer == "< >" {
     queryOperatorFieldGoalAttemptsTeam1 = " BETWEEN "
     let queryLowerValueFieldGoalAttemptsTeam1 = fieldGoalAttemptsTeam1RangeSliderLowerValuePlayer
     let queryUpperValueFieldGoalAttemptsTeam1 = fieldGoalAttemptsTeam1RangeSliderUpperValuePlayer
     queryValueFieldGoalAttemptsTeam1 = String(queryLowerValueFieldGoalAttemptsTeam1) + " AND " + String(queryUpperValueFieldGoalAttemptsTeam1)
     queryStringFieldGoalAttemptsTeam1 = " AND " + queryColumnFieldGoalAttemptsTeam1 + queryOperatorFieldGoalAttemptsTeam1 + queryValueFieldGoalAttemptsTeam1
     } else {
     if fieldGoalAttemptsTeam1SliderValuePlayer == -10000 {
     queryStringFieldGoalAttemptsTeam1 = ""
     } else {
     if fieldGoalAttemptsTeam1OperatorValuePlayer == "≠" {
     queryOperatorFieldGoalAttemptsTeam1 = " != "
     } else {
     queryOperatorFieldGoalAttemptsTeam1 = " " + fieldGoalAttemptsTeam1OperatorValuePlayer + " "
     }
     queryValueFieldGoalAttemptsTeam1 = String(fieldGoalAttemptsTeam1SliderValuePlayer)
     queryStringFieldGoalAttemptsTeam1 = " AND LENGTH(\(queryColumnFieldGoalAttemptsTeam1)) !=0 AND " + queryColumnFieldGoalAttemptsTeam1 + queryOperatorFieldGoalAttemptsTeam1 + queryValueFieldGoalAttemptsTeam1
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "OPPONENT: FIELD GOAL ATTEMPTS" {
     queryStringFieldGoalAttemptsTeam2 = ""
     } else {
     if fieldGoalAttemptsTeam2OperatorValuePlayer == "< >" {
     queryOperatorFieldGoalAttemptsTeam2 = " BETWEEN "
     let queryLowerValueFieldGoalAttemptsTeam2 = fieldGoalAttemptsTeam2RangeSliderLowerValuePlayer
     let queryUpperValueFieldGoalAttemptsTeam2 = fieldGoalAttemptsTeam2RangeSliderUpperValuePlayer
     queryValueFieldGoalAttemptsTeam2 = String(queryLowerValueFieldGoalAttemptsTeam2) + " AND " + String(queryUpperValueFieldGoalAttemptsTeam2)
     queryStringFieldGoalAttemptsTeam2 = " AND " + queryColumnFieldGoalAttemptsTeam2 + queryOperatorFieldGoalAttemptsTeam2 + queryValueFieldGoalAttemptsTeam2
     } else {
     if fieldGoalAttemptsTeam2SliderValuePlayer == -10000 {
     queryStringFieldGoalAttemptsTeam2 = ""
     } else {
     if fieldGoalAttemptsTeam2OperatorValuePlayer == "≠" {
     queryOperatorFieldGoalAttemptsTeam2 = " != "
     } else {
     queryOperatorFieldGoalAttemptsTeam2 = " " + fieldGoalAttemptsTeam2OperatorValuePlayer + " "
     }
     queryValueFieldGoalAttemptsTeam2 = String(fieldGoalAttemptsTeam2SliderValuePlayer)
     queryStringFieldGoalAttemptsTeam2 = " AND LENGTH(\(queryColumnFieldGoalAttemptsTeam2)) !=0 AND " + queryColumnFieldGoalAttemptsTeam2 + queryOperatorFieldGoalAttemptsTeam2 + queryValueFieldGoalAttemptsTeam2
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "PLAYER TEAM: FIELD GOALS MADE" {
     queryStringFieldGoalsMadeTeam1 = ""
     } else {
     if fieldGoalsMadeTeam1OperatorValuePlayer == "< >" {
     queryOperatorFieldGoalsMadeTeam1 = " BETWEEN "
     let queryLowerValueFieldGoalsMadeTeam1 = fieldGoalsMadeTeam1RangeSliderLowerValuePlayer
     let queryUpperValueFieldGoalsMadeTeam1 = fieldGoalsMadeTeam1RangeSliderUpperValuePlayer
     queryValueFieldGoalsMadeTeam1 = String(queryLowerValueFieldGoalsMadeTeam1) + " AND " + String(queryUpperValueFieldGoalsMadeTeam1)
     queryStringFieldGoalsMadeTeam1 = " AND " + queryColumnFieldGoalsMadeTeam1 + queryOperatorFieldGoalsMadeTeam1 + queryValueFieldGoalsMadeTeam1
     } else {
     if fieldGoalsMadeTeam1SliderValuePlayer == -10000 {
     queryStringFieldGoalsMadeTeam1 = ""
     } else {
     if fieldGoalsMadeTeam1OperatorValuePlayer == "≠" {
     queryOperatorFieldGoalsMadeTeam1 = " != "
     } else {
     queryOperatorFieldGoalsMadeTeam1 = " " + fieldGoalsMadeTeam1OperatorValuePlayer + " "
     }
     queryValueFieldGoalsMadeTeam1 = String(fieldGoalsMadeTeam1SliderValuePlayer)
     queryStringFieldGoalsMadeTeam1 = " AND LENGTH(\(queryColumnFieldGoalsMadeTeam1)) !=0 AND " + queryColumnFieldGoalsMadeTeam1 + queryOperatorFieldGoalsMadeTeam1 + queryValueFieldGoalsMadeTeam1
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "OPPONENT: FIELD GOALS MADE" {
     queryStringFieldGoalsMadeTeam2 = ""
     } else {
     if fieldGoalsMadeTeam2OperatorValuePlayer == "< >" {
     queryOperatorFieldGoalsMadeTeam2 = " BETWEEN "
     let queryLowerValueFieldGoalsMadeTeam2 = fieldGoalsMadeTeam2RangeSliderLowerValuePlayer
     let queryUpperValueFieldGoalsMadeTeam2 = fieldGoalsMadeTeam2RangeSliderUpperValuePlayer
     queryValueFieldGoalsMadeTeam2 = String(queryLowerValueFieldGoalsMadeTeam2) + " AND " + String(queryUpperValueFieldGoalsMadeTeam2)
     queryStringFieldGoalsMadeTeam2 = " AND " + queryColumnFieldGoalsMadeTeam2 + queryOperatorFieldGoalsMadeTeam2 + queryValueFieldGoalsMadeTeam2
     } else {
     if fieldGoalsMadeTeam2SliderValuePlayer == -10000 {
     queryStringFieldGoalsMadeTeam2 = ""
     } else {
     if fieldGoalsMadeTeam2OperatorValuePlayer == "≠" {
     queryOperatorFieldGoalsMadeTeam2 = " != "
     } else {
     queryOperatorFieldGoalsMadeTeam2 = " " + fieldGoalsMadeTeam2OperatorValuePlayer + " "
     }
     queryValueFieldGoalsMadeTeam2 = String(fieldGoalsMadeTeam2SliderValuePlayer)
     queryStringFieldGoalsMadeTeam2 = " AND LENGTH(\(queryColumnFieldGoalsMadeTeam2)) !=0 AND " + queryColumnFieldGoalsMadeTeam2 + queryOperatorFieldGoalsMadeTeam2 + queryValueFieldGoalsMadeTeam2
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "PLAYER TEAM: PUNTS" {
     queryStringPuntsTeam1 = ""
     } else {
     if puntsTeam1OperatorValuePlayer == "< >" {
     queryOperatorPuntsTeam1 = " BETWEEN "
     let queryLowerValuePuntsTeam1 = puntsTeam1RangeSliderLowerValuePlayer
     let queryUpperValuePuntsTeam1 = puntsTeam1RangeSliderUpperValuePlayer
     queryValuePuntsTeam1 = String(queryLowerValuePuntsTeam1) + " AND " + String(queryUpperValuePuntsTeam1)
     queryStringPuntsTeam1 = " AND " + queryColumnPuntsTeam1 + queryOperatorPuntsTeam1 + queryValuePuntsTeam1
     } else {
     if puntsTeam1SliderValuePlayer == -10000 {
     queryStringPuntsTeam1 = ""
     } else {
     if puntsTeam1OperatorValuePlayer == "≠" {
     queryOperatorPuntsTeam1 = " != "
     } else {
     queryOperatorPuntsTeam1 = " " + puntsTeam1OperatorValuePlayer + " "
     }
     queryValuePuntsTeam1 = String(puntsTeam1SliderValuePlayer)
     queryStringPuntsTeam1 = " AND LENGTH(\(queryColumnPuntsTeam1)) !=0 AND " + queryColumnPuntsTeam1 + queryOperatorPuntsTeam1 + queryValuePuntsTeam1
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "OPPONENT: PUNTS" {
     queryStringPuntsTeam2 = ""
     } else {
     if puntsTeam2OperatorValuePlayer == "< >" {
     queryOperatorPuntsTeam2 = " BETWEEN "
     let queryLowerValuePuntsTeam2 = puntsTeam2RangeSliderLowerValuePlayer
     let queryUpperValuePuntsTeam2 = puntsTeam2RangeSliderUpperValuePlayer
     queryValuePuntsTeam2 = String(queryLowerValuePuntsTeam2) + " AND " + String(queryUpperValuePuntsTeam2)
     queryStringPuntsTeam2 = " AND " + queryColumnPuntsTeam2 + queryOperatorPuntsTeam2 + queryValuePuntsTeam2
     } else {
     if puntsTeam2SliderValuePlayer == -10000 {
     queryStringPuntsTeam2 = ""
     } else {
     if puntsTeam2OperatorValuePlayer == "≠" {
     queryOperatorPuntsTeam2 = " != "
     } else {
     queryOperatorPuntsTeam2 = " " + puntsTeam2OperatorValuePlayer + " "
     }
     queryValuePuntsTeam2 = String(puntsTeam2SliderValuePlayer)
     queryStringPuntsTeam2 = " AND LENGTH(\(queryColumnPuntsTeam2)) !=0 AND " + queryColumnPuntsTeam2 + queryOperatorPuntsTeam2 + queryValuePuntsTeam2
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "PLAYER TEAM: PUNT YARDS" {
     queryStringPuntYardsTeam1 = ""
     } else {
     if puntYardsTeam1OperatorValuePlayer == "< >" {
     queryOperatorPuntYardsTeam1 = " BETWEEN "
     let queryLowerValuePuntYardsTeam1 = puntYardsTeam1RangeSliderLowerValuePlayer
     let queryUpperValuePuntYardsTeam1 = puntYardsTeam1RangeSliderUpperValuePlayer
     queryValuePuntYardsTeam1 = String(queryLowerValuePuntYardsTeam1) + " AND " + String(queryUpperValuePuntYardsTeam1)
     queryStringPuntYardsTeam1 = " AND " + queryColumnPuntYardsTeam1 + queryOperatorPuntYardsTeam1 + queryValuePuntYardsTeam1
     } else {
     if puntYardsTeam1SliderValuePlayer == -10000 {
     queryStringPuntYardsTeam1 = ""
     } else {
     if puntYardsTeam1OperatorValuePlayer == "≠" {
     queryOperatorPuntYardsTeam1 = " != "
     } else {
     queryOperatorPuntYardsTeam1 = " " + puntYardsTeam1OperatorValuePlayer + " "
     }
     queryValuePuntYardsTeam1 = String(puntYardsTeam1SliderValuePlayer)
     queryStringPuntYardsTeam1 = " AND LENGTH(\(queryColumnPuntYardsTeam1)) !=0 AND " + queryColumnPuntYardsTeam1 + queryOperatorPuntYardsTeam1 + queryValuePuntYardsTeam1
     }
     }
     }
     
     if clearSliderIndicatorPlayer == "OPPONENT: PUNT YARDS" {
     queryStringPuntYardsTeam2 = ""
     } else {
     if puntYardsTeam2OperatorValuePlayer == "< >" {
     queryOperatorPuntYardsTeam2 = " BETWEEN "
     let queryLowerValuePuntYardsTeam2 = puntYardsTeam2RangeSliderLowerValuePlayer
     let queryUpperValuePuntYardsTeam2 = puntYardsTeam2RangeSliderUpperValuePlayer
     queryValuePuntYardsTeam2 = String(queryLowerValuePuntYardsTeam2) + " AND " + String(queryUpperValuePuntYardsTeam2)
     queryStringPuntYardsTeam2 = " AND " + queryColumnPuntYardsTeam2 + queryOperatorPuntYardsTeam2 + queryValuePuntYardsTeam2
     } else {
     if puntYardsTeam2SliderValuePlayer == -10000 {
     queryStringPuntYardsTeam2 = ""
     } else {
     if puntYardsTeam2OperatorValuePlayer == "≠" {
     queryOperatorPuntYardsTeam2 = " != "
     } else {
     queryOperatorPuntYardsTeam2 = " " + puntYardsTeam2OperatorValuePlayer + " "
     }
     queryValuePuntYardsTeam2 = String(puntYardsTeam2SliderValuePlayer)
     queryStringPuntYardsTeam2 = " AND LENGTH(\(queryColumnPuntYardsTeam2)) !=0 AND " + queryColumnPuntYardsTeam2 + queryOperatorPuntYardsTeam2 + queryValuePuntYardsTeam2
     }
     }
     }
    /*if queryStringTeam2 == "" {
        print("queryStringTeam2 is NULL")
        queryFromFiltersGameData = ""
        queryFromFiltersPlayerDash = "FROM PlayerGameData WHERE " + queryFromFiltersPlayerData + "TeamDateUniqueID IN (SELECT TeamDateUniqueID FROM TeamGameData" + queryFromFiltersGameData
        queryGameStarts = "FROM PlayerGameData WHERE " + queryFromFiltersPlayerData + "StartedGame = 'STARTED' AND TeamDateUniqueID IN (SELECT TeamDateUniqueID FROM TeamGameData" + queryFromFiltersGameData + ")"
        queryWinsTeam1 = queryFromFiltersPlayerDash + " WHERE winLoseTieValueTeam = 1.0" + ")"
        queryLossesTeam1 = queryFromFiltersPlayerDash + " WHERE winLoseTieValueTeam = 0.0" + ")"
        queryTiesTeam1 = queryFromFiltersPlayerDash + " WHERE winLoseTieValueTeam = 0.5" + ")"
        queryCoveredTeam1 = queryFromFiltersPlayerDash + " WHERE SpreadVsLine = 'covered'" + ")"
        queryNotCoveredTeam1 = queryFromFiltersPlayerDash + " WHERE SpreadVsLine = 'not covered'" + ")"
        queryPushTeam1 = queryFromFiltersPlayerDash + " WHERE SpreadVsLine = 'push'" + ")"
        
    } else {
        print("queryStringTeam2 is NOT NULL")*/
        queryFromFiltersGameData = " WHERE TeamDateUniqueID IS NOT NULL" + queryStringTeam2 + queryStringTeam1 + queryStringSpreadTeam1 + queryStringOverUnder + queryStringWinningLosingStreakTeam1 + queryStringWinningLosingStreakTeam2 + queryStringSeasonWinPercentageTeam1 + queryStringSeasonWinPercentageTeam2 + queryStringHomeTeam + queryStringFavorite + queryStringPlayersTeam1 + queryStringSeason + queryStringWeek + queryStringGameNumber + queryStringDay + queryStringStadium + queryStringSurface + queryStringTemperature + queryStringTotalPointsTeam1 + queryStringTotalPointsTeam2 + queryStringTouchdownsTeam1 + queryStringTouchdownsTeam2 + queryStringTurnoversCommittedTeam1 + queryStringTurnoversCommittedTeam2 + queryStringPenaltiesCommittedTeam1 + queryStringPenaltiesCommittedTeam2 + queryStringTotalYardsTeam1 + queryStringTotalYardsTeam2 + queryStringPassingYardsTeam1 + queryStringPassingYardsTeam2 + queryStringRushingYardsTeam1 + queryStringRushingYardsTeam2 + queryStringQuarterbackRatingTeam1 + queryStringQuarterbackRatingTeam2 + queryStringTimesSackedTeam1 + queryStringTimesSackedTeam2 + queryStringInterceptionsThrownTeam1 + queryStringInterceptionsThrownTeam2 + queryStringOffensivePlaysTeam1 + queryStringOffensivePlaysTeam2 + queryStringYardsPerOffensivePlayTeam1 + queryStringYardsPerOffensivePlayTeam2 + queryStringSacksTeam1 + queryStringSacksTeam2 + queryStringInterceptionsTeam1 + queryStringInterceptionsTeam2 + queryStringSafetiesTeam1 + queryStringSafetiesTeam2 + queryStringDefensivePlaysTeam1 + queryStringDefensivePlaysTeam2 + queryStringYardsPerDefensivePlayTeam1 + queryStringYardsPerDefensivePlayTeam2 + queryStringExtraPointAttemptsTeam1 + queryStringExtraPointAttemptsTeam2 + queryStringExtraPointsMadeTeam1 + queryStringExtraPointsMadeTeam2 + queryStringFieldGoalAttemptsTeam1 + queryStringFieldGoalAttemptsTeam2 + queryStringFieldGoalsMadeTeam1 + queryStringFieldGoalsMadeTeam2 + queryStringPuntsTeam1 + queryStringPuntsTeam2 + queryStringPuntYardsTeam1 + queryStringPuntYardsTeam2
        
        queryFromFiltersPlayerDash = "FROM PlayerGameData WHERE " + queryFromFiltersPlayerData + "TeamDateUniqueID IN (SELECT TeamDateUniqueID FROM TeamGameData" + queryFromFiltersGameData
        queryGameStarts = "FROM PlayerGameData WHERE " + queryFromFiltersPlayerData + "StartedGame = 'STARTED' AND TeamDateUniqueID IN (SELECT TeamDateUniqueID FROM TeamGameData" + queryFromFiltersGameData + ")"
        queryWinsTeam1 = queryFromFiltersPlayerDash + " AND winLoseTieValueTeam = 1.0" + ")"
        queryLossesTeam1 = queryFromFiltersPlayerDash + " AND winLoseTieValueTeam = 0.0" + ")"
        queryTiesTeam1 = queryFromFiltersPlayerDash + " AND winLoseTieValueTeam = 0.5" + ")"
        queryCoveredTeam1 = queryFromFiltersPlayerDash + " AND SpreadVsLine = 'covered'" + ")"
        queryNotCoveredTeam1 = queryFromFiltersPlayerDash + " AND SpreadVsLine = 'not covered'" + ")"
        queryPushTeam1 = queryFromFiltersPlayerDash + " AND SpreadVsLine = 'push'" + ")"
        
        print("queryFromFiltersPlayerDash: " + queryFromFiltersPlayerDash + ")")
        print("queryGameStarts: " + String(queryGameStarts))
        print("queryWinsTeam1:  " + String(queryWinsTeam1))
        print("queryLossesTeam1:  " + String(queryLossesTeam1))
        print("queryTiesTeam1:  " + String(queryTiesTeam1))
        print("queryCoveredTeam1:  " + String(queryCoveredTeam1))
        print("queryNotCoveredTeam1:  " + String(queryNotCoveredTeam1))
        print("queryPushTeam1:  " + String(queryPushTeam1))
        
        let pathStatsDB = Bundle.main.path(forResource: "StatsDatabase", ofType:"db")
        let db = FMDatabase(path: pathStatsDB)
        guard db.open() else {
            print("Unable to open database 'StatsDB'")
            return
        }
        do {
            let executeGamesSampled = try db.executeQuery("SELECT COUNT(*) \(queryFromFiltersPlayerDash))", values: nil)
            while executeGamesSampled.next() {
                gamesSampled = executeGamesSampled.long(forColumnIndex: 0)
                //print("gamesSampled: " + String(gamesSampled))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        
        do {
            let executeGameStarts = try db.executeQuery("SELECT COUNT(*) \(queryGameStarts)", values: nil)
            while executeGameStarts.next() {
                gameStarts = executeGameStarts.long(forColumnIndex: 0)
                //print("gameStarts: " + String(gameStarts))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        
        do {
            let executeWinsTeam1 = try db.executeQuery("SELECT COUNT(*) \(queryWinsTeam1)", values: nil)
            while executeWinsTeam1.next() {
                winsTeam1 = executeWinsTeam1.long(forColumnIndex: 0)
                //print("winsTeam1: " + String(winsTeam1))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeLossesTeam1 = try db.executeQuery("SELECT COUNT(*) \(queryLossesTeam1)", values: nil)
            while executeLossesTeam1.next() {
                lossesTeam1 = executeLossesTeam1.long(forColumnIndex: 0)
                //print("lossesTeam1: " + String(lossesTeam1))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeTiesTeam1 = try db.executeQuery("SELECT COUNT(*) \(queryTiesTeam1)", values: nil)
            while executeTiesTeam1.next() {
                tiesTeam1 = executeTiesTeam1.long(forColumnIndex: 0)
                //print("tiesTeam1: " + String(tiesTeam1))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeCoveredTeam1 = try db.executeQuery("SELECT COUNT(*) \(queryCoveredTeam1)", values: nil)
            while executeCoveredTeam1.next() {
                coveredTeam1 = executeCoveredTeam1.long(forColumnIndex: 0)
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeNotCoveredTeam1 = try db.executeQuery("SELECT COUNT(*) \(queryNotCoveredTeam1)", values: nil)
            while executeNotCoveredTeam1.next() {
                notCoveredTeam1 = executeNotCoveredTeam1.long(forColumnIndex: 0)
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executePushTeam1 = try db.executeQuery("SELECT COUNT(*) \(queryPushTeam1)", values: nil)
            while executePushTeam1.next() {
                pushTeam1 = executePushTeam1.long(forColumnIndex: 0)
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeUniformNumber = try db.executeQuery("SELECT UniformNumber FROM TeamRosterData WHERE PlayerID IN (SELECT PlayerID \(queryFromFiltersPlayerDash)))", values: nil)
            while executeUniformNumber.next() {
                uniformNumber = executeUniformNumber.string(forColumnIndex: 0)!
                //print("uniformNumber: " + String(uniformNumber))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executePosition = try db.executeQuery("SELECT Position FROM TeamRosterData WHERE PlayerID IN (SELECT PlayerID \(queryFromFiltersPlayerDash)))", values: nil)
            while executePosition.next() {
                position = executePosition.string(forColumnIndex: 0)!
                //print("position: " + String(position))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeTeam = try db.executeQuery("SELECT TeamNameAbbrev FROM TeamRosterData WHERE PlayerID IN (SELECT PlayerID \(queryFromFiltersPlayerDash)))", values: nil)
            while executeTeam.next() {
                team = executeTeam.string(forColumnIndex: 0)!
                //print("team: " + String(team))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeByeWeek = try db.executeQuery("SELECT ByeWeek FROM TeamRosterData WHERE PlayerID IN (SELECT PlayerID \(queryFromFiltersPlayerDash)))", values: nil)
            while executeByeWeek.next() {
                byeWeek = executeByeWeek.string(forColumnIndex: 0)!
                //print("byeWeek: " + String(byeWeek))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeHeight = try db.executeQuery("SELECT Height FROM TeamRosterData WHERE PlayerID IN (SELECT PlayerID \(queryFromFiltersPlayerDash)))", values: nil)
            while executeHeight.next() {
                height = executeHeight.string(forColumnIndex: 0)!
                //print("height: " + String(height))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeWeight = try db.executeQuery("SELECT Weight FROM TeamRosterData WHERE PlayerID IN (SELECT PlayerID \(queryFromFiltersPlayerDash)))", values: nil)
            while executeWeight.next() {
                weight = executeWeight.string(forColumnIndex: 0)!
                //print("weight: " + String(weight))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeAge = try db.executeQuery("SELECT Age FROM TeamRosterData WHERE PlayerID IN (SELECT PlayerID \(queryFromFiltersPlayerDash)))", values: nil)
            while executeAge.next() {
                age = Int(executeAge.double(forColumnIndex: 0))
                //print("age: " + String(age))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeExperience = try db.executeQuery("SELECT YearsActive FROM TeamRosterData WHERE PlayerID IN (SELECT PlayerID \(queryFromFiltersPlayerDash)))", values: nil)
            while executeExperience.next() {
                experience = Int(executeExperience.double(forColumnIndex: 0))
                //print("experience: " + String(experience))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        
        do {
            let executeTotalTouchdowns = try db.executeQuery("SELECT \(queryOperatorSQL)(TotalTouchdowns) \(queryFromFiltersPlayerDash))", values: nil)
            //let executeTotalTouchdowns = try db.executeQuery("SELECT \(queryOperatorSQL)(TotalTouchdowns) \(queryFromFiltersPlayerDash))", values: nil)
            //queryWinsTeam1 = queryFromFiltersPlayerDash + " AND winLoseTieValueTeam = 1.0" + ")"
            //"SELECT COUNT(*) \(queryNotCoveredTeam1)", values: nil)
            while executeTotalTouchdowns.next() {
                touchdownsTotal = Float(executeTotalTouchdowns.double(forColumnIndex: 0))
                //print("touchdownsTotal: " + String(touchdownsTotal))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
    
        
        do {
            let executeTwoPointConversionsMade = try db.executeQuery("SELECT \(queryOperatorSQL)(TwoPointsConversionsMade) \(queryFromFiltersPlayerDash))", values: nil)
            while executeTwoPointConversionsMade.next() {
                twoPointConversions = Float(executeTwoPointConversionsMade.double(forColumnIndex: 0))
                //print("twoPointConversions: " + String(twoPointConversions))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeFumblesLost = try db.executeQuery("SELECT \(queryOperatorSQL)(FumblesLost) \(queryFromFiltersPlayerDash))", values: nil)
            while executeFumblesLost.next() {
                fumblesLost = Float(executeFumblesLost.double(forColumnIndex: 0))
                //print("fumblesLost: " + String(fumblesLost))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        
        do {
            let executeFFSTD = try db.executeQuery("SELECT \(queryOperatorSQL)(FantasyPointsNFLScoring) \(queryFromFiltersPlayerDash))", values: nil)
            while executeFFSTD.next() {
                fantasySTD = Float(executeFFSTD.double(forColumnIndex: 0))
                //print("fantasySTD: " + String(fantasySTD))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeFFPPR = try db.executeQuery("SELECT \(queryOperatorSQL)(FantasyPointsPPRScoring) \(queryFromFiltersPlayerDash))", values: nil)
            while executeFFPPR.next() {
                fantasyPPR = Float(executeFFPPR.double(forColumnIndex: 0))
                //print("fantasyPPR: " + String(fantasyPPR))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeFFDK = try db.executeQuery("SELECT \(queryOperatorSQL)(FantasyPointsDraftKingsScoring) \(queryFromFiltersPlayerDash))", values: nil)
            while executeFFDK.next() {
                fantasyDK = Float(executeFFDK.double(forColumnIndex: 0))
                //print("fantasyDK: " + String(fantasyDK))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        
        do {
            let executeFFFD = try db.executeQuery("SELECT \(queryOperatorSQL)(FantasyPointsFanDuelScoring) \(queryFromFiltersPlayerDash))", values: nil)
            while executeFFFD.next() {
                fantasyFD = Float(executeFFFD.double(forColumnIndex: 0))
                //print("fantasyFD: " + String(fantasyFD))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executePassesCompleted = try db.executeQuery("SELECT \(queryOperatorSQL)(PassesCompleted) \(queryFromFiltersPlayerDash))", values: nil)
            while executePassesCompleted.next() {
                passingCompletions = Float(executePassesCompleted.double(forColumnIndex: 0))
                //print("passingCompletions: " + String(passingCompletions))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executePassesAttempted = try db.executeQuery("SELECT \(queryOperatorSQL)(PassesAttempted) \(queryFromFiltersPlayerDash))", values: nil)
            while executePassesAttempted.next() {
                passingAttempts = Float(executePassesAttempted.double(forColumnIndex: 0))
                //print("passingAttempts: " + String(passingAttempts))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executePassCompletionPercentage = try db.executeQuery("SELECT AVG(PassCompletionPercentage) \(queryFromFiltersPlayerDash)) AND LENGTH(PassesAttempted) !=0", values: nil)
            while executePassCompletionPercentage.next() {
                passingCompletionPercentage = Float(executePassCompletionPercentage.double(forColumnIndex: 0))
                //print("passingCompletionPercentage: " + String(passingCompletionPercentage))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executePassingYards = try db.executeQuery("SELECT \(queryOperatorSQL)(PassingYardsGained) \(queryFromFiltersPlayerDash))", values: nil)
            while executePassingYards.next() {
                passingYards = Float(executePassingYards.double(forColumnIndex: 0))
                //print("passingYards: " + String(passingYards))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executePassingYardsAverage = try db.executeQuery("SELECT AVG(YardsGainedPerPassAttempt) \(queryFromFiltersPlayerDash)) AND LENGTH(PassesAttempted) !=0", values: nil)
            while executePassingYardsAverage.next() {
                passingAverageYardage = Float(executePassingYardsAverage.double(forColumnIndex: 0))
                //print("passingAverageYardage: " + String(passingAverageYardage))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executePassing300 = try db.executeQuery("SELECT COUNT(*) FROM PlayerGameData WHERE PassingYardsGained >= 300 AND PlayerID IN (SELECT PlayerID \(queryFromFiltersPlayerDash)))", values: nil)
            while executePassing300.next() {
                passing300 = Float(executePassing300.double(forColumnIndex: 0))
                //print("passing300: " + String(passing300))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executePassingTouchdowns = try db.executeQuery("SELECT \(queryOperatorSQL)(PassingTouchdowns) \(queryFromFiltersPlayerDash))", values: nil)
            while executePassingTouchdowns.next() {
                passingTouchdowns = Float(executePassingTouchdowns.double(forColumnIndex: 0))
                //print("passingTouchdowns: " + String(passingTouchdowns))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executePassingInterceptionsThrown = try db.executeQuery("SELECT \(queryOperatorSQL)(InterceptionsThrown) \(queryFromFiltersPlayerDash))", values: nil)
            while executePassingInterceptionsThrown.next() {
                passingInterceptionsThrown = Float(executePassingInterceptionsThrown.double(forColumnIndex: 0))
                //print("passingInterceptionsThrown: " + String(passingInterceptionsThrown))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeTimesSacked = try db.executeQuery("SELECT \(queryOperatorSQL)(TimesSacked) \(queryFromFiltersPlayerDash))", values: nil)
            while executeTimesSacked.next() {
                passingSacks = Float(executeTimesSacked.double(forColumnIndex: 0))
                //print("passingSacks: " + String(passingSacks))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeSackYardsLost = try db.executeQuery("SELECT \(queryOperatorSQL)(YardsLostDueToSacks) \(queryFromFiltersPlayerDash))", values: nil)
            while executeSackYardsLost.next() {
                passingSackYardage = Float(executeSackYardsLost.double(forColumnIndex: 0))
                //print("passingSackYardage: " + String(passingSackYardage))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeQuarterbackRating = try db.executeQuery("SELECT AVG(QuarterbackRating) \(queryFromFiltersPlayerDash))", values: nil)
            while executeQuarterbackRating.next() {
                quarterbackRating = Float(executeQuarterbackRating.double(forColumnIndex: 0))
                //print("quarterbackRating: " + String(quarterbackRating))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeRushAttempts = try db.executeQuery("SELECT \(queryOperatorSQL)(RushingAttempts) \(queryFromFiltersPlayerDash))", values: nil)
            while executeRushAttempts.next() {
                rushAttempts = Float(executeRushAttempts.double(forColumnIndex: 0))
                //print("rushAttempts: " + String(rushAttempts))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeRushingYards = try db.executeQuery("SELECT \(queryOperatorSQL)(RushingYardsGained) \(queryFromFiltersPlayerDash))", values: nil)
            while executeRushingYards.next() {
                rushingYards = Float(executeRushingYards.double(forColumnIndex: 0))
                //print("rushingYards: " + String(rushingYards))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeRushingYardsAverage = try db.executeQuery("SELECT AVG(YardsPerRushingAttempt) \(queryFromFiltersPlayerDash)) AND LENGTH(RushingAttempts) !=0", values: nil)
            while executeRushingYardsAverage.next() {
                rushingAverageYardage = Float(executeRushingYardsAverage.double(forColumnIndex: 0))
                //print("rushingAverageYardage: " + String(rushingAverageYardage))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeRushingTouchdowns = try db.executeQuery("SELECT \(queryOperatorSQL)(RushingTouchdowns) \(queryFromFiltersPlayerDash))", values: nil)
            while executeRushingTouchdowns.next() {
                rushingTouchdowns = Float(executeRushingTouchdowns.double(forColumnIndex: 0))
                //print("rushingTouchdowns: " + String(rushingTouchdowns))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeReceivingTargets = try db.executeQuery("SELECT \(queryOperatorSQL)(PassTargets) \(queryFromFiltersPlayerDash))", values: nil)
            while executeReceivingTargets.next() {
                receivingTargets = Float(executeReceivingTargets.double(forColumnIndex: 0))
                //print("receivingTargets: " + String(receivingTargets))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeReceivingReceptions = try db.executeQuery("SELECT \(queryOperatorSQL)(Receptions) \(queryFromFiltersPlayerDash))", values: nil)
            while executeReceivingReceptions.next() {
                receivingReceptions = Float(executeReceivingReceptions.double(forColumnIndex: 0))
                //print("receivingReceptions: " + String(receivingReceptions))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeReceivingCatchPercentage = try db.executeQuery("SELECT AVG(CatchPercentage) \(queryFromFiltersPlayerDash)) AND LENGTH(PassTargets) !=0", values: nil)
            while executeReceivingCatchPercentage.next() {
                receivingCatchPercentage = Float(executeReceivingCatchPercentage.double(forColumnIndex: 0))
                //print("receivingCatchPercentage: " + String(receivingCatchPercentage))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeReceivingYards = try db.executeQuery("SELECT \(queryOperatorSQL)(ReceivingYards) \(queryFromFiltersPlayerDash))", values: nil)
            while executeReceivingYards.next() {
                receivingYards = Float(executeReceivingYards.double(forColumnIndex: 0))
                //print("receivingYards: " + String(receivingYards))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeReceivingYardsAverage = try db.executeQuery("SELECT AVG(ReceivingYardsPerTarget) \(queryFromFiltersPlayerDash)) AND LENGTH(PassTargets) !=0", values: nil)
            while executeReceivingYardsAverage.next() {
                receivingAverageYardage = Float(executeReceivingYardsAverage.double(forColumnIndex: 0))
                //print("receivingAverageYardage: " + String(receivingAverageYardage))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeReceivingTouchdowns = try db.executeQuery("SELECT \(queryOperatorSQL)(ReceivingTouchdowns) \(queryFromFiltersPlayerDash))", values: nil)
            while executeReceivingTouchdowns.next() {
                receivingTouchdowns = Float(executeReceivingTouchdowns.double(forColumnIndex: 0))
                //print("receivingTouchdowns: " + String(receivingTouchdowns))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        
        
        playerLabel.adjustsFontSizeToFitWidth = true
        playerLabel.minimumScaleFactor = 0.6
        playerLabel.allowsDefaultTighteningForTruncation = true
        opponentLabel.adjustsFontSizeToFitWidth = true
        opponentLabel.minimumScaleFactor = 0.6
        opponentLabel.allowsDefaultTighteningForTruncation = true
        winRateValue.adjustsFontSizeToFitWidth = true
        winRateValue.minimumScaleFactor = 0.6
        winRateValue.allowsDefaultTighteningForTruncation = true
        winRateLabel.adjustsFontSizeToFitWidth = true
        winRateLabel.minimumScaleFactor = 0.6
        winRateLabel.allowsDefaultTighteningForTruncation = true
        gamesSampledValue.adjustsFontSizeToFitWidth = true
        gamesSampledValue.minimumScaleFactor = 0.6
        gamesSampledValue.allowsDefaultTighteningForTruncation = true
        /*gameSampledLabel.adjustsFontSizeToFitWidth = true
         gameSampledLabel.minimumScaleFactor = 0.6
         gameSampledLabel.allowsDefaultTighteningForTruncation = true*/
        gameStartsValue.adjustsFontSizeToFitWidth = true
        gameStartsValue.minimumScaleFactor = 0.6
        gameStartsValue.allowsDefaultTighteningForTruncation = true
        /*gameStartsLabel.adjustsFontSizeToFitWidth = true
         gameStartsLabel.minimumScaleFactor = 0.6
         gameStartsLabel.allowsDefaultTighteningForTruncation = true*/
        recordValue.adjustsFontSizeToFitWidth = true
        recordValue.minimumScaleFactor = 0.6
        recordValue.allowsDefaultTighteningForTruncation = true
        /*recordLabel.adjustsFontSizeToFitWidth = true
         recordLabel.minimumScaleFactor = 0.6
         recordLabel.allowsDefaultTighteningForTruncation = true*/
        ATSValue.adjustsFontSizeToFitWidth = true
        ATSValue.minimumScaleFactor = 0.6
        ATSValue.allowsDefaultTighteningForTruncation = true
        /*ATSOpponent.adjustsFontSizeToFitWidth = true
         ATSOpponent.minimumScaleFactor = 0.6
         ATSOpponent.allowsDefaultTighteningForTruncation = true*/
        
        // MATCH-UP //
        playerLabel.text = playerLabelText
        if team2ListValuePlayer.count == 1 {
            if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                opponentLabel.text = "NEW YORK (G)"
            } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                opponentLabel.text = "NEW YORK (J)"
            } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                opponentLabel.text = "LOS ANGELES (C)"
            } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                opponentLabel.text = "LOS ANGELES (R)"
            } else {
                opponentLabel.text = opponentLabelText
            }
        } else {
            opponentLabel.text = opponentLabelText
        }
        
        // PLAYER BIO CARD //
        if playerListValuePlayer.count == 0 || playerListValuePlayer == ["-10000"] {
            uniformNumberValue.text = "--"
            positionValue.text = "--"
            teamValue.text = "--"
            byeWeekValue.text = "--"
            heightValue.text = "--"
            weightValue.text = "--"
            ageValue.text = "--"
            experienceValue.text = "--"
        } else {
            uniformNumberValue.text = uniformNumber
            positionValue.text = position
            teamValue.text = team
            byeWeekValue.text = byeWeek
            heightValue.text = height
            weightValue.text = weight
            ageValue.text = numberFormatter.string(from: NSNumber(value: age))!
            experienceValue.text = numberFormatter.string(from: NSNumber(value: experience))!
        }
        
        if gamesSampled == 0 || playerListValuePlayer.count == 0 || playerListValuePlayer == ["-10000"] {
            // GAMES SAMPLED //
            print("gamesSampled = 0")
            gamesSampledValue.text = "0"
            gameStartsValue.text = "0"
            recordValue.text = "0-0-0"
            ATSValue.text = "0-0-0"
            winRate = 0.0
            //self.perform(#selector(animateProgress), with: nil, afterDelay: 0.3)
            winRateValue.text = "0.0%"
            // GAME STATS //
            touchdownValue.text = "--"
            twoPCValue.text = "--"
            fumbleValue.text = "--"
            //fumbleRecoveryValue.text = "--"
            fantasySTDValue.text = "--"
            fantasyPPRValue.text = "--"
            fantasyDKValue.text = "--"
            fantasyFDValue.text = "--"
            // PASSING //
            passCompletionsValue.text = "--"
            //PassesAttemptedValue.text = "--"
            passCompletionsValue.text = "--"
            passingYardsValue.text = "--"
            passingYardsAverageValue.text = "--"
            passing300Value.text = "--"
            passingTouchdownsValue.text = "--"
            passesInterceptedValue.text = "--"
            timesSackedValue.text = "--"
            sackYardsValue.text = "--"
            QBRatingValue.text = "--"
            // RUSHING //
            rushAttemptsValue.text = "--"
            rushingYardsValue.text = "--"
            rushingYardsAverageValue.text = "--"
            rushing300Value.text = "--"
            rushingTouchdownsValue.text = "--"
            // RECEIVING //
            receptionsValue.text = "--"
            targetsValue.text = "--"
            catchPercentageValue.text = "--"
            receivingYardsValue.text = "--"
            receivingYardsAverageValue.text = "--"
            receiving300Value.text = "--"
            receivingTouchdownsValue.text = "--"
        } else {
            print("gamesSampled <> 0")
            winRate = Float((Double(winsTeam1) + (0.5 * (Double(tiesTeam1))))/Double(gamesSampled))
            winRateLabelText = String(format: "%.1f%%", (100.00 * ((Double(winsTeam1) + (0.5 * (Double(tiesTeam1))))/Double(gamesSampled)))) //"50.0%"
            gamesSampledLabelText = numberFormatter.string(from: NSNumber(value: gamesSampled))!
            gameStartsLabelText = numberFormatter.string(from: NSNumber(value: gameStarts))!
            recordLabelText = "(" + winsTeam1.formattedWithSeparator_ + "-" + lossesTeam1.formattedWithSeparator_ + "-" + tiesTeam1.formattedWithSeparator_ + ")"
            ATSLabelText = "(" + coveredTeam1.formattedWithSeparator + "-" + notCoveredTeam1.formattedWithSeparator + "-" + pushTeam1.formattedWithSeparator + ")"
            
            gamesSampledValue.text = gamesSampledLabelText
            gameStartsValue.text = gameStartsLabelText
            recordValue.text = recordLabelText
            ATSValue.text = ATSLabelText
            winRateValue.text = winRateLabelText
            
            if queryOperatorSQL == "AVG" {
                // Game Stats//
                touchdownValue.text = String(format: "%.1f",  touchdownsTotal)
                twoPCValue.text = String(format: "%.1f", twoPointConversions)
                fumbleValue.text = String(format: "%.1f", fumblesLost)
                //fumbleRecoveryValue.text = numberFormatter.string(from: NSNumber(value: fumblesRecovered))!
                fantasySTDValue.text = numberFormatter.string(from: NSNumber(value: fantasySTD))!
                fantasyPPRValue.text = numberFormatter.string(from: NSNumber(value: fantasyPPR))!
                fantasyDKValue.text = numberFormatter.string(from: NSNumber(value: fantasyDK))!
                fantasyFDValue.text = numberFormatter.string(from: NSNumber(value: fantasyFD))!
                // Passing //
                passCompletionsValue.text = String(format: "%.1f", passingCompletions)
                passPercentageValue.text = String(format: "%.1f%%", (100.00 * passingCompletionPercentage))
                passingYardsValue.text = String(format: "%.1f", passingYards)
                passingYardsAverageValue.text = String(format: "%.1f", passingAverageYardage)
                passing300Value.text = "--"
                passingTouchdownsValue.text = String(format: "%.1f", passingTouchdowns)
                passesInterceptedValue.text = String(format: "%.1f", passingInterceptionsThrown)
                timesSackedValue.text = String(format: "%.1f", passingSacks)
                sackYardsValue.text = String(format: "%.1f", passingSackYardage)
                QBRatingValue.text = String(format: "%.1f", quarterbackRating)
                // Rushing //
                rushAttemptsValue.text = String(format: "%.1f", rushAttempts)
                rushingYardsValue.text = String(format: "%.1f", rushingYards)
                rushingYardsAverageValue.text = String(format: "%.1f", rushingAverageYardage)
                rushing300Value.text = "--"
                rushingTouchdownsValue.text = String(format: "%.1f", rushingTouchdowns)
                // Receiving //
                receptionsValue.text = String(format: "%.1f", receivingReceptions)
                targetsValue.text = String(format: "%.1f", receivingTargets)
                catchPercentageValue.text = String(format: "%.1f%%", (100.00 * receivingCatchPercentage))
                receivingYardsValue.text = String(format: "%.1f", receivingYards)
                receivingYardsAverageValue.text = String(format: "%.1f", receivingAverageYardage)
                receiving300Value.text = "--"
                receivingTouchdownsValue.text = String(format: "%.1f", receivingTouchdowns)
            } else {
                // Game Stats//
                touchdownValue.text = numberFormatter.string(from: NSNumber(value: touchdownsTotal))!
                twoPCValue.text = numberFormatter.string(from: NSNumber(value: twoPointConversions))!
                fumbleValue.text = numberFormatter.string(from: NSNumber(value: fumblesLost))!
                //fumbleRecoveryValue.text = numberFormatter.string(from: NSNumber(value: fumblesRecovered))!
                fantasySTDValue.text = numberFormatter.string(from: NSNumber(value: fantasySTD))!
                fantasyPPRValue.text = numberFormatter.string(from: NSNumber(value: fantasyPPR))!
                fantasyDKValue.text = numberFormatter.string(from: NSNumber(value: fantasyDK))!
                fantasyFDValue.text = numberFormatter.string(from: NSNumber(value: fantasyFD))!
                // Passing //
                passCompletionsValue.text = numberFormatter.string(from: NSNumber(value: passingCompletions))!
                //PassesAttemptedValue.text = numberFormatter.string(from: NSNumber(value: passingAttempts))!
                passPercentageValue.text =  String(format: "%.0f%%", (100.00 * passingCompletionPercentage))
                passingYardsValue.text = numberFormatter.string(from: NSNumber(value: passingYards))!
                passingYardsAverageValue.text = numberFormatter.string(from: NSNumber(value: passingAverageYardage))!
                passing300Value.text = numberFormatter.string(from: NSNumber(value: passing300))!
                passingTouchdownsValue.text = numberFormatter.string(from: NSNumber(value: passingTouchdowns))!
                passesInterceptedValue.text = numberFormatter.string(from: NSNumber(value: passingInterceptionsThrown))!
                timesSackedValue.text = numberFormatter.string(from: NSNumber(value: passingSacks))!
                sackYardsValue.text = numberFormatter.string(from: NSNumber(value: passingSackYardage))!
                QBRatingValue.text = String(format: "%.1f", quarterbackRating)
                // Rushing //
                rushAttemptsValue.text = numberFormatter.string(from: NSNumber(value: rushAttempts))!
                rushingYardsValue.text = numberFormatter.string(from: NSNumber(value: rushingYards))!
                rushingYardsAverageValue.text = numberFormatter.string(from: NSNumber(value: rushingAverageYardage))!
                rushing300Value.text = numberFormatter.string(from: NSNumber(value: rushing300))!
                rushingTouchdownsValue.text = numberFormatter.string(from: NSNumber(value: rushingTouchdowns))!
                // Receiving //
                receptionsValue.text = numberFormatter.string(from: NSNumber(value: receivingReceptions))!
                targetsValue.text = numberFormatter.string(from: NSNumber(value: receivingTargets))!
                catchPercentageValue.text = String(format: "%.0f%%", (100.00 * receivingCatchPercentage))
                receivingYardsValue.text = numberFormatter.string(from: NSNumber(value: receivingYards))!
                receivingYardsAverageValue.text = numberFormatter.string(from: NSNumber(value: receivingAverageYardage))!
                receiving300Value.text = numberFormatter.string(from: NSNumber(value: receiving300))!
                receivingTouchdownsValue.text = numberFormatter.string(from: NSNumber(value: receivingTouchdowns))!
            }
            
            if errorIndicator == "Yes" {
                print("errorIndicator = Yes")
            }
            db.close()
        }
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
