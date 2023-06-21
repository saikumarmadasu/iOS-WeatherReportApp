//
//  WeatherDataModel.swift
//  WeatherReport
//
//  Created by SaiMadasu on 6/20/23.
//


import Foundation

struct WeatherDataModel:Codable {
    let main: Main
    let weather: [Weather]
    let name: String
}

struct Main:Codable{
    let temp:Double
    let temp_min:Double
    let temp_max:Double
}

struct Weather:Codable {
    let id : Int
    let main: String
    let description: String
    let icon: String
}
