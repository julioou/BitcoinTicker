//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
   
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let simbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var currentSimbol = ""
    
    var finalURL = ""
    

//Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        firstPrice() // Determinando a primeira cotação
    }
    
    
// Função para determinar a primeira cotação
    func firstPrice() {
        finalURL = baseURL + currencyArray[0]
        currentSimbol = simbolArray[0]
        getCurrencyPrice(url: finalURL)
        
    }
    
//UIPickerView delegate methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(simbolArray[row]) \(currencyArray[row])"
    }
    
// Função para fazer o call e selecionar a moeda desejada para fazer a conversão.
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + String(currencyArray[row])
        
        getCurrencyPrice(url: finalURL)
        
        self.currentSimbol = simbolArray[row]
        print(currentSimbol)
    }
    
    
// Funcão para fazer o NETWORKING CALL
    
    func getCurrencyPrice (url: String){
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    print("Sucess! Got currency price")
                    let priceJSON : JSON = JSON(response.result.value!)
                    
                    self.updateCurrencyPrice(json: priceJSON)
                    
                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
        }
    }
    

// JSON Parsing
    func updateCurrencyPrice(json : JSON){
        if let priceResult = json ["bid"].double {
            
            self.bitcoinPriceLabel.text = "\(currentSimbol) \(String(priceResult))"
            print("Got the result: \(priceResult)")
        
        } else {
            self.bitcoinPriceLabel.text = "Price Unavailable"
        }
    }
}

