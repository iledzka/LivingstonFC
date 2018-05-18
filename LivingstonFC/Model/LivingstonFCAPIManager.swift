//
//  LivingstonFCAPIManager.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 07/05/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import Foundation

import UIKit
import SwiftyJSON

//  This class is used to prepare and send requests to the Livingston FC API.
//  Use ApiEndpoints enum to append the api verb to the url.
//  Instance of this class can be accessed by using sharedInstance var.
//  Change host address var to connect to the API (local or live server)
class LivingstonFCAPIManager: NSObject {
    
    let hostAddress = "" //add hostAdress
    
    var baseURL: String { return hostAddress + "/LivingstonFC-API/" }
    
    var session: URLSession { return URLSession.shared }
    
    static let sharedInstance = LivingstonFCAPIManager()
    
    //  Use this function to prepare HTTP request. APiEndpoints enum is used to represent available verbs.
    //  options dictionary defaults to nil, but can be populater when the HTTP body is required (e.g. login
    //  and register)
    private func prepareRequest(with endpoint: ApiEndpoints, _ options: [String:String]? = nil) -> NSMutableURLRequest? {
        let url : String = baseURL + endpoint.rawValue
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        
        switch endpoint {
        case .login:
            guard let credentials = options else { return nil }
            let apiKey = UserDefaultsManager.getApiKey() ?? "NjIzODMxNjc5"
            request.httpMethod = "POST"
            let bearer = "Bearer " + apiKey
            request.setValue(bearer, forHTTPHeaderField: "Authorization")
            
            //serialize params body
            do {
                let data = try JSONSerialization.data(withJSONObject: credentials, options: JSONSerialization.WritingOptions.prettyPrinted)
                request.httpBody = data
            } catch let error {
                print(error.localizedDescription)
            }
        case .register:
            request.httpMethod = "POST"
            guard let credentials = options else { return nil }
            //serialize params body
            do {
                let data = try JSONSerialization.data(withJSONObject: credentials, options: JSONSerialization.WritingOptions.prettyPrinted)
                request.httpBody = data
            } catch let error {
                print(error.localizedDescription)
            }
        default:
            request.httpMethod = "GET"
            request.setValue(UserDefaultsManager.getAccessToken(), forHTTPHeaderField: "Access_token")
            request.setValue(UserDefaultsManager.getApiKey(), forHTTPHeaderField: "Authorization")
        }
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    //  Retrieve all matches
    public func getGames(onSuccess: @escaping([Game]) -> Void, onFailure: @escaping(Error) -> Void){
        let request = prepareRequest(with: ApiEndpoints.livingstonGame)
        
        let task = session.dataTask(with: request! as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                print(response.debugDescription)
                do {
                    let result = try JSON(data: data!)
                    var games = [Game]()
                    if let gamesDict = result.dictionary {
                        guard !gamesDict.isEmpty else { print("Didn't find any games!"); return }
                        for (_, object) in gamesDict{
                            print(object.dictionaryObject!)
                            if let game = Game(data: object.dictionaryObject! ) {
                                games.append(game)
                            }
                        }
                    }
                    onSuccess(games)
                } catch let error {
                    onFailure(error)
                    print("parse error: \(error.localizedDescription)")
                }
            }
        })
        task.resume()
    }
    
    //  Retrieve all teams
    public func getTeams(onSuccess: @escaping([Team]) -> Void, onFailure: @escaping(Error) -> Void){
        let request = prepareRequest(with: ApiEndpoints.team)
        let task = session.dataTask(with: request! as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                print(response.debugDescription)
                do {
                    let result = try JSON(data: data!)
                    var teams = [Team]()
                    if let teamsDict = result.dictionary {
                        guard !teamsDict.isEmpty else { print("Didn't find any teams!"); return }
                        for (_, object) in teamsDict{
                            print(object.dictionaryObject!)
                            if let team = Team(data: object.dictionaryObject! ) {
                                teams.append(team)
                            }
                        }
                    }
                    onSuccess(teams)
                } catch let error {
                    onFailure(error)
                    print("parse error: \(error.localizedDescription)")
                }
            }
        })
        task.resume()
    }
    
    //  Retrieve all players
    public func getPlayers(onSuccess: @escaping([Player]) -> Void, onFailure: @escaping(Error) -> Void){
        let request = prepareRequest(with: ApiEndpoints.player)
        let task = session.dataTask(with: request! as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                print(response.debugDescription)
                do {
                    let result = try JSON(data: data!)
                    var players = [Player]()
                    if let playersDict = result.dictionary {
                        guard !playersDict.isEmpty else { print("Didn't find any players!"); return }
                        for (_, object) in playersDict{
                            print(object.dictionaryObject!)
                            if let player = Player(data: object.dictionaryObject! as NSDictionary) {
                                players.append(player)
                            }
                        }
                    }
                    onSuccess(players)
                } catch let error {
                    onFailure(error)
                    print("parse error: \(error.localizedDescription)")
                }
            }
        })
        task.resume()
    }
    
    //  Retrieve current league table
    public func getCompetitionStats(onSuccess: @escaping([LeagueTableStatsItem]) -> Void, onFailure: @escaping(Error) -> Void){
        let request = prepareRequest(with: ApiEndpoints.competitionstats)
        let task = session.dataTask(with: request! as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                print(response.debugDescription)
                do {
                    let result = try JSON(data: data!)
                    var stats = [LeagueTableStatsItem]()
                    if let teamsDict = result.dictionary {
                        guard !teamsDict.isEmpty else { print("Didn't find any stats!"); return }
                        for (_, object) in teamsDict{
                            print(object.dictionaryObject!)
                            if let statsItem = LeagueTableStatsItem(data: object.dictionaryObject! as NSDictionary) {
                                stats.append(statsItem)
                            } else {
                                print("b")
                            }
                        }
                    }
                    onSuccess(stats)
                } catch let error {
                    onFailure(error)
                    print("parse error: \(error.localizedDescription)")
                }
            }
        })
        task.resume()
    }
    
    //  Retrieve all events
    public func getCommunityEvents(onSuccess: @escaping([Community]) -> Void, onFailure: @escaping(Error) -> Void){
        let request = prepareRequest(with: ApiEndpoints.communityEvents)
        let task = session.dataTask(with: request! as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                print(response.debugDescription)
                do {
                    let result = try JSON(data: data!)
                    var events = [Community]()
                    if let eventsDict = result.dictionary {
                        guard !eventsDict.isEmpty else { print("Didn't find any events!"); return }
                        for (_, object) in eventsDict{
                            print(object.dictionaryObject!)
                            if let event = Community(data: object.dictionaryObject! as NSDictionary) {
                                events.append(event)
                            } else {
                                print("b")
                            }
                        }
                    }
                    onSuccess(events)
                } catch let error {
                    onFailure(error)
                    print("parse error: \(error.localizedDescription)")
                }
            }
        })
        task.resume()
    }
    
    //  Retrieve all coaching staff members
    public func getCoachingStaff(onSuccess: @escaping([CoachingStaff]) -> Void, onFailure: @escaping(Error) -> Void){
        let request = prepareRequest(with: ApiEndpoints.coachingStaff)
        let task = session.dataTask(with: request! as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                print(response.debugDescription)
                do {
                    let result = try JSON(data: data!)
                    var coachingStaff = [CoachingStaff]()
                    if let coachDict = result.dictionary {
                        guard !coachDict.isEmpty else { print("Didn't find any events!"); return }
                        for (_, object) in coachDict{
                            print(object.dictionaryObject!)
                            if let coach = CoachingStaff(data: object.dictionaryObject! as NSDictionary) {
                                coachingStaff.append(coach)
                            } else {
                                print("b")
                            }
                        }
                    }
                    onSuccess(coachingStaff)
                } catch let error {
                    onFailure(error)
                    print("parse error: \(error.localizedDescription)")
                }
            }
        })
        task.resume()
    }
    
    //  Login to the app.
    //  Params: username/email address and password.
    //  On success returns JWT token valid for an hour.
    public func login(params: [String:String], onSuccess: @escaping(String) -> Void, onFailure: @escaping(Error) -> Void){
        guard let request = prepareRequest(with: ApiEndpoints.login, params) else {
            print("Invalid request")
            onFailure(ErrorResponse.invalidRequest)
            return
        }
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(ErrorResponse.connectionFailed)
            } else{
                print(response.debugDescription)
                do {
                    let result = try JSON(data: data!)
                    if let tokenDict = result.dictionary {
                        guard !tokenDict.isEmpty else { print("Token is empty!"); return }
                            if let token = tokenDict["access_token"] {
                                let stringToken = String(describing: token)
                                onSuccess(stringToken)
                            }
                    }
                } catch let error {
                    if let response = response as? HTTPURLResponse {
                        switch response.statusCode {
                            case 401:
                                onFailure(ErrorResponse.unauthorized)
                            case 422:
                                onFailure(ErrorResponse.unprocessableEntity)
                            case 500:
                                onFailure(ErrorResponse.internalServerError)
                            default:
                                onFailure(error)
                        }
                    }
                }
            }
        })
        task.resume()
    }
    
    //  Register to the App.
    //  Params is the username, email address, password and a boolean value for the full membership.
    //  On success returns a custoim API key created for this User.
    public func register(params: [String:String], onSuccess: @escaping(String) -> Void, onFailure: @escaping(Error) -> Void){
        guard let request = prepareRequest(with: ApiEndpoints.register, params) else {
            print("Invalid request")
            onFailure(ErrorResponse.invalidRequest)
            return
        }
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(ErrorResponse.connectionFailed)
            } else{
                print(response.debugDescription)
                do {
                    let result = try JSON(data: data!)
                    if let tokenDict = result.dictionary {
                        guard !tokenDict.isEmpty else { print("Token is empty!"); return }
                        if let apiKey = tokenDict["userApiKey"] {
                            let stringApiKey = String(describing: apiKey)
                            onSuccess(stringApiKey)
                        }
                    }
                } catch let error {
                    if let response = response as? HTTPURLResponse {
                        switch response.statusCode {
                        case 401:
                            onFailure(ErrorResponse.unauthorized)
                        case 422:
                            onFailure(ErrorResponse.unprocessableEntity)
                        case 500:
                            onFailure(ErrorResponse.internalServerError)
                        default:
                            onFailure(error)
                        }
                    }
                }
            }
        })
        task.resume()
    }
}

//  Types of error
enum ErrorResponse: Error {
    case unauthorized
    case internalServerError
    case unprocessableEntity
    case connectionFailed
    case invalidRequest
}

//  Livingston API verbs
enum ApiEndpoints: String {
    case livingstonGame = "livingstongame"
    case team = "team"
    case player = "player"
    case competitionstats = "competitionstats"
    case login = "login"
    case register = "register"
    case communityEvents = "communityevent"
    case coachingStaff = "coachingstaff"
}
