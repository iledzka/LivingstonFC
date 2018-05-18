//
//  Game.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 23/04/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import Foundation

//  Game is a model class that is used to store data about a match, used in FixturesAndResultsViewController,
//  MatchUpcomingViewController, and MatchPastViewController. Is also feeds to CollectionViewController that
//  is used to create carousel-like view in NewsfeedViewController.
class Game: CustomStringConvertible {
    public let id: String
    public var opponent: String
    public let competition: String
    public let competitionYearStarted: String
    public var dateTime: (String, String)?
    public let scoreLivingston: String?
    public let scoreOpponent: String?
    public let venue: String
    public let referee: String
    public let commentary: String?
    public let travelLink: URL?
    
    //  (upcoming: false, current: false) = match happened
    //  (upcoming: true, current: false) = match will happen in the future
    //  (upcoming: nil, current: true) = match is being played
    //  (upcoming: nil, current: false) = something went wrong!
    public lazy var upcomingOrCurrent = (upcoming: self.upcoming, current: self.current)
    
    public var description: String { return "Match id: \(self.id), upcommingOrCurrent: \(self.upcomingOrCurrent), opponent: \(self.opponent), competition: \(self.competition) \(competitionYearStarted), dateAndTime: \(String(describing: self.dateAndTime)), scoreLivingston: \(self.scoreLivingston ?? "not available"), scoreOpponent: \(self.scoreOpponent ?? "not available"), venue: \(self.venue), referee: \(self.referee), commentary: \(self.commentary ?? "not yet available"), travelLink: \(String(describing: self.travelLink))" }
    
    public var dateAndTime: Date?
    
    init?(data: [String: Any])
    {
        guard
            let id = data["id"] as? Int,
            let opponent = data["opponent"] as? String,
            let competition = data["competition"] as? String,
            let competitionYearStarted = data["competitionYearStarted"] as? String,
            let date = data["date"] as? String,
            let time = data["time"] as? String,
            let venue = data["venue"] as? String,
            let referee = data["referee"] as? String
            else {
                return nil
            }
        
        
        self.id = String(id)
        self.opponent = opponent
        self.competition = competition
        self.competitionYearStarted = competitionYearStarted
        self.venue = venue
        self.referee = referee
        self.dateAndTime = createDateTime(from: date, and: time)
        if self.dateAndTime != nil {
            self.dateTime = (date, time)
        }
        //travel link can be nil for both upcoming and past match (may not be always available)
        let travelLinkString = data["travelLink"] as? String
        //these values are nil when the match is upcoming
        let commentary = data["commentary"] as? String
        if let scoreLivingston = data["scoreLivingston"] as? Int, let scoreOpponent = data["scoreOpponent"] as? Int {
            self.scoreLivingston = String(describing: scoreLivingston)
            self.scoreOpponent = String(describing: scoreOpponent)
        } else {
            self.scoreLivingston = nil
            self.scoreOpponent = nil
        }
        self.commentary = commentary
        self.travelLink = URL(string: travelLinkString ?? "")
        
        //make sure that they are nil only when match is upcoming
        if self.upcoming == false {
            guard scoreLivingston != nil,
                scoreOpponent != nil,
                commentary != nil
                else {
                    return nil
            }
        }
    }
    
    
    
    private var current: Bool = false

    private var upcoming: Bool? {
        let currentDate = getCurrentDate()!
        if let unwrappedDateTime = dateAndTime {
            let result = unwrappedDateTime.compare(currentDate)
            switch result {
            case .orderedDescending:
                return true
            case .orderedAscending:
                let elapsedTimeInMinutes = Date().timeIntervalSince(unwrappedDateTime) / 60
                print(elapsedTimeInMinutes)
                if elapsedTimeInMinutes < 90 {
                    current = true
                    return nil
                }
                return false
            case .orderedSame:
                current = true
                return nil
            }
        }
        return nil
    }
}

private func getCurrentDate() -> Date? {
    let now = Date()
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone.current
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    let dateString = formatter.string(from: now)
    return formatter.date(from: dateString)
}

private func createDateTime(from date: String, and time: String) -> Date? {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_GB")
    formatter.dateStyle = .medium
    formatter.timeZone = TimeZone.current
    formatter.dateFormat = "yyyy/MM/dd HH:mm"
    let date = formatter.date(from: "\(date) \(time.dropLast(3))")
    return date
}

class Team {
    
    public let name: String
    public let badgeUrl: URL
    
    init?(data: [String: Any])
    {
        let apiAddress = LivingstonFCAPIManager.sharedInstance.baseURL
        
        guard
            let name = data["name"] as? String,
            let badgeUrl = URL(string: apiAddress + (data["badge"] as? String)!)
            else { return nil }
        
        self.name = name
        self.badgeUrl = badgeUrl
    }
}

