//
//  ViewController.swift
//  dices
//
//  Created by 簡吟真 on 2021/4/26.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {


    @IBOutlet var diceImages: [UIImageView]!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var dicesumText: UILabel!
    @IBOutlet weak var statusText: UITextView!
    @IBOutlet weak var moneyText: UILabel!
    @IBOutlet weak var gambleSelecter: UISegmentedControl!
    @IBOutlet weak var gambleMoney: UILabel!
    @IBOutlet weak var gambleMoneyStepper: UIStepper!
    
    let imageNames = ["1","2","3","4","5","6"]
    var player: AVAudioPlayer?
    var money = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.statusText.layoutManager.allowsNonContiguousLayout = false
        }


    @IBAction func startButtonCheck(_ sender: Any) {
        //優先判斷賭金是否足夠支付下注金額
        if Int(gambleMoneyStepper.value) > money {
            self.statusText.text = String("資產不足！\n") + self.statusText.text
        }else{
            
            //每次按下按鈕時都先把總合歸零，並開始跑骰子聲
            var diceSum = 0
            self.playSound(name: "dice_shake")
            //時間間隔起算
            let diceTime:TimeInterval = 1.42
        DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + diceTime)
            {
            //跑隨機骰子及計算總和
            for i in 0...5 {
            let diceNum = Int.random(in: 1...6)
            diceSum += diceNum
            self.diceImages[i].image = UIImage(named: self.imageNames[diceNum-1])
            }
            //將總和顯示在畫面上
            self.dicesumText.text = String(diceSum) + "點"
            //開始判斷大小21點情形
            switch diceSum
            {
            case 6...20:
                if self.gambleSelecter.selectedSegmentIndex == 0 {
                    self.win(Odds: 2)
                }else{
                    self.lose()
                }
            case 22...36:
                if self.gambleSelecter.selectedSegmentIndex == 2 {
                    self.win(Odds: 5)
                }else{
                    self.lose()
                }
            default:
                if self.gambleSelecter.selectedSegmentIndex == 1 {
                    self.win(Odds: 10)
                }else{
                    self.lose()
                }
            }
            self.startButton.isEnabled = true
            }
        }
    }
     
  
    @IBAction func addmoneyPressed(_ sender: Any) {
        money += 1000
        moneyUpdate()
        playSound(name: "cash")
        self.statusText.text += String("\n1000元...加值成功")
        showtextBottom()
    }
    
    @IBAction func moneystepperPressed(_ sender: Any) {
        gamblemoneyUpdate()
    }
    
    func showtextBottom(){
        statusText.scrollRangeToVisible(NSRange(location: .max, length: 0))
    }
    
    func gamblemoneyUpdate(){
        gambleMoney.text = "此次下注：" + String(format: "%.f", gambleMoneyStepper.value) + "元"
    }
    
    func moneyUpdate(){
        moneyText.text = "總資產：" + String(money) + "元"
    }
    
    func playSound(name: String){
        //播放各種音效
        if let url = Bundle.main.url(forResource: name, withExtension: "mp3") {
        self.player = try? AVAudioPlayer(contentsOf: url)
        self.player?.play()
        }
    }

    func win(Odds: Double){
        self.playSound(name: "win")
        let gamoney = Int(Odds * self.gambleMoneyStepper.value)
        self.money += gamoney
        self.moneyUpdate()
        self.statusText.text += String("\n恭喜您贏了\(gamoney)元，總資產\(self.money)元")
        showtextBottom()
    }
    
    func lose(){
        self.playSound(name: "lose")
        let gamoney = Int(self.gambleMoneyStepper.value)
        self.money -= gamoney
        self.moneyUpdate()
        self.statusText.text += String("\n您輸了\(gamoney)元，總資產\(self.money)元")
        showtextBottom()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        //賭金是否足夠支付下注金額
        if Int(gambleMoneyStepper.value) > money {
            self.statusText.text = String("資產不足！\n") + self.statusText.text
        }else{
           //按下按鈕時先把總合歸零
            var diceSum = 0
            self.playSound(name: "dice_shake")
      
            
        
            //跑隨機骰子及計算總和
            for i in 0...5 {
            let diceNum = Int.random(in: 1...6)
            diceSum += diceNum
            self.diceImages[i].image = UIImage(named: self.imageNames[diceNum-1])
            }
            //將總和顯示在畫面上
            self.dicesumText.text = String(diceSum) + "點"
            //開始判斷大小21點情形
            switch diceSum
            {
            case 6...20:
                if self.gambleSelecter.selectedSegmentIndex == 0 {
                    self.win(Odds: 2)
                }else{
                    self.lose()
                }
            case 22...36:
                if self.gambleSelecter.selectedSegmentIndex == 2 {
                    self.win(Odds: 2)
                }else{
                    self.lose()
                }
            default:
                if self.gambleSelecter.selectedSegmentIndex == 1 {
                    self.win(Odds: 10)
                }else{
                    self.lose()
                }
            }
            self.startButton.isEnabled = true
            }
        }
    }

