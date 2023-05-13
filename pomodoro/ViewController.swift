//
//  ViewController.swift
//  pomodoro
//
//  Created by 최진안 on 2023/05/14.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - outlet변수 선언
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    
    //timer에 저장된 시간을 초로 저장하는 변수
    var duration = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tapCancelButton(_ sender: UIButton) {
        
    }
    
    @IBAction func tapToggleButton(_ sender: UIButton) {
        // 설정한 시간을 duration에 넣어준다.
        self.duration = Int(self.datePicker.countDownDuration)
        debugPrint(self.duration)
    }
    
    
}

