//
//  ViewController.swift
//  pomodoro
//
//  Created by 최진안 on 2023/05/14.
//

import UIKit
import AudioToolbox

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
    var timer: DispatchSourceTimer?
    var currentSeconds = 0
    
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

    // MARK: - 시작버튼을 누르면 타이머가 동작하도록 하는 함수
    func startTimer() {
        if self.timer == nil {
            // main쓰레드에서 동작하도록 설정 - UI와 관련된 작업은 반드시 main쓰레드에서 처리해야함
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
            // 즉시 실행되도록 now로 해줌 반복은 1초마다 하도록 설정함
            self.timer?.schedule(deadline: .now(), repeating: 1)
            // 타이머가 반복할때마다 이 메서드가 동작해서 handler에 부여된 클로져 함수가 동작한다.
            self.timer?.setEventHandler(handler: { [weak self] in
                guard let self = self else { return }
                self.currentSeconds -= 1
                let hour = self.currentSeconds / 3600 // 시를 구한다.
                let minutes = (self.currentSeconds % 3600) / 60 // 분을 구한다.
                let secondes = (self.currentSeconds % 3600) % 60 // 초를 구한다.
                self.timerLabel.text = String(format: "%02d:%02d:%02d", hour, minutes, secondes) // 시 분 초가 표시된다.
                self.progressView.progress = Float(self.currentSeconds) / Float(self.duration) // 카운트다운 될때마다 게이지가 줄어들게 한다.
                
                // 카운트 다운이 다 되었을때
                if self.currentSeconds <= 0 {
                    // 타이머가 종료
                    self.stopTimer()
                    // 아이폰 기본 사운드가 동작
                    AudioServicesPlaySystemSound(1005)
                }
            })
            // 타이머를 실행시킨다.
            self.timer?.resume()
        }
    }
    
    // MARK: - 타이머를 종료시키는 함수
    func stopTimer() {
        if self.timerStatus == .pause {
            // 일시정지일때는 resume함수를 써줘야 일시정지를 누르고 취소했을때 런타임 오류가 안생긴다.
            self.timer?.resume()
        }
        self.timerStatus = .end
        self.cancelButton.isEnabled = false
        UIView.animate(withDuration: 0.5) {
            self.timerLabel.alpha = 0
            self.progressView.alpha = 0
            self.datePicker.alpha = 1
        }
        self.toggleButton.isSelected = false
        self.timer?.cancel()
        self.timer = nil // nil로 초기화해줘야함
    }
    
    // MARK: - 취소버튼 액션
    @IBAction func tapCancelButton(_ sender: UIButton) {
        switch self.timerStatus {
        case .start, . pause:
            self.stopTimer()
            
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
            self.currentSeconds = self.duration
            self.timerStatus = .start
            UIView.animate(withDuration: 0.5) {
                self.timerLabel.alpha = 1
                self.progressView.alpha = 1
                self.datePicker.alpha = 0
            }
            self.toggleButton.isSelected = true
            self.cancelButton.isEnabled = true
            self.startTimer()
        case .start:
            self.timerStatus = .pause
            self.toggleButton.isSelected = false
            self.timer?.suspend() // 타이머를 일시정지 시킨다.
        case .pause:
            self.timerStatus = .start
            self.toggleButton.isSelected = true
            self.timer?.resume() // 다시 타이머를 시작시킨다.
        }
        
    }
    
    
}

