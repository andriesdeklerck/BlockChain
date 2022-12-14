// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.9;

contract OpenWeatherData {
    struct WeatherData{
        uint256 Temperature;
        uint256 WindSpeed;
        uint256 PercentageRain;
        string WindDirection;
    }

    mapping(string => WeatherData) public weatherByPlace;
    mapping(string => uint) public age;

    function AddNewData(string[] memory cities, WeatherData[] memory _weatherData) public {
        for(uint i = 0; i < cities.length; i++){
            weatherByPlace[cities[i]] = _weatherData[i];
            age[cities[i]] = block.number;
        }
    }

    function GetCityData(string memory place) public view returns(WeatherData memory _weatherData){
        return weatherByPlace[place];
    }

    function GetCityTime(string memory place) public view returns(uint time){
        return age[place];
    }
}