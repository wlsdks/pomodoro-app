//
//  ViewController.swift
//  pomodoro
//
//  Created by 최진안 on 2023/05/14.
//

import UIKit

// MARK: - emum타입 선언
enum TimerStatus {
    case start
    case pause
    case end
}

class ViewController: UIViewController {

    // MARK: - outlet변수 선언
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    
    //timer에 저장된 시간을 초로 저장하는 변수
    var duration = 60
    // timer의 상태를 가진 변수 선언 - 초기값은 end
    var timerStatus: TimerStatus = .end
    
    // MARK: - 앱 실행시 가장 먼저 동작
    override func viewDidLoad() {
        super.viewDidLoad()
        configureToggleButton()
    }
    
    // MARK: - timer버튼 설정
    func setTimerInfoViewVisible(isHidden: Bool) {
        self.timerLabel.isHidden = isHidden
        self.progressView.isHidden = isHidden
    }
    
    // MARK: - 토글버튼 설정
    func configureToggleButton() {
        // 버튼이 normal이면 시작으로바뀌고 selected면 일시정지로 바뀜
        self.toggleButton.setTitle("시작", for: .normal)
        self.toggleButton.setTitle("일시정지", for: .selected)
    }

    // MARK: - 취소버튼 액션
    @IBAction func tapCancelButton(_ sender: UIButton) {
        switch self.timerStatus {
        case .start, . pause:
            self.timerStatus = .end
            self.cancelButton.isEnabled = false
            self.setTimerInfoViewVisible(isHidden: true)
            self.datePicker.isHidden = false
            self.toggleButton.isSelected = false
            
        default:
            break
        }
    }
    
    // MARK: - 시작버튼 액션
    @IBAction func tapToggleButton(_ sender: UIButton) {
        // 설정한 시간을 duration에 넣어준다.
        self.duration = Int(self.datePicker.countDownDuration)
        
        // 버튼 누를때마다 상태를 변경시켜준다.
        switch self.timerStatus {
        // 맨 처음 시작버튼 누르면 end니까 바로아래 case가 동작
        case .end:
            self.timerStatus = .start
            self.setTimerInfoViewVisible(isHidden: false)
            self.datePicker.isHidden = true
            self.toggleButton.isSelected = true
            self.cancelButton.isEnabled = true
        case .start:
            self.timerStatus = .pause
            self.toggleButton.isSelected = false
        case .pause:
            self.timerStatus = .start
            self.toggleButton.isSelected = true
        }
        
        debugPrint(self.duration)
    }
    
    
}

