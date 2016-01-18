//
//  ViewController.swift
//  fitTimer
//
//  Created by itkang on 16/1/18.
//  Copyright © 2016年 itkang. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var doTime: UITextField!
    
    @IBOutlet weak var resetTime: UITextField!
    
    @IBOutlet weak var times: UITextField!
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var currStu: UILabel!
    
    @IBOutlet weak var currTimes: UILabel!
    @IBOutlet weak var totalMin: UILabel!
    @IBOutlet weak var runMin: UILabel!
    
    @IBOutlet weak var currSec: UILabel!
    @IBOutlet weak var totalSec: UILabel!
    @IBOutlet weak var runSec: UILabel!
    
    //播放声音
    private var audioPlayer:AVAudioPlayer!
    
    //全局变量
    var start_flag = false; //起始标记
    var do_flag = false;
    var timer:NSTimer! //计时器
    var _runSec = 0;
    var _dotime = 0;
    var _resettime = 0;
    var _times = 0;
    var _totalSec = 0;
    var _runtotalSec=0;
    var _oneTimes = 0;
    var _showsec = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView();
        //播放音乐
        let url = NSBundle.mainBundle().URLForResource("5sec", withExtension: "wav");
        if let u = url {
            do {
                audioPlayer = try AVAudioPlayer(contentsOfURL: u)
                if self.audioPlayer == nil {
                    print("error");
                }
            } catch {
                print("error");
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //init method
    func initView() {
        totalMin.text="00";
        runMin.text="00";
        currSec.text="00";
        totalSec.text="00";
        runSec.text="00";
        currStu.text="unstart";
        currTimes.text="0";
        start_flag = false;
        btn.setTitle("start", forState: .Normal);
        //初始化输入框
        doTime.text="30";
        resetTime.text="10";
        times.text="12";
    }
    //点击起始按钮
    @IBAction func pressBtn(sender: UIButton) {
        if (!start_flag) {
            start_flag = true;
            btn.setTitle("stop", forState: .Normal);
            startTimer();
        } else {
            initView();
            stopTimer();
        }
    }
    //开始计时
    func startTimer(){
         _dotime = NSInteger(doTime.text!)!;
         _resettime = NSInteger(resetTime.text!)!;
         _times = NSInteger(times.text!)!;
         _oneTimes = (_dotime + _resettime);
         _totalSec = (_dotime + _resettime) * _times;
         _runtotalSec = _totalSec;
        currTimes.text = times.text!;
        //实例化计时器
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "runTimer", userInfo: nil, repeats: true)
        currStu.text="Do time";
    }
    
    
    //结束计时
    func stopTimer(){
        start_flag = false;
        btn.setTitle("start", forState: .Normal);
        currSec.text="00";
        timer.invalidate(); //销毁计时器
        _runSec = 0;
    }
    //执行计时
    func runTimer() {
        //计算剩余次数
        if (_runSec%_oneTimes < _dotime) {
            currStu.text="Do time";
            //如果Do_flag是false,就设置为true;
            if (!do_flag) {
                do_flag = !do_flag;
                _showsec = _dotime;
            }
        } else {
            currStu.text="Recover time";
            //如果Do_flag是true,就设置为false;
            if (do_flag) {
                do_flag = !do_flag;
                _showsec = _resettime;
            }
        }
        //倒计时音效
        if (_showsec == 5){
            audioPlayer.play();
        }
        currSec.text="\(_showsec--)";
        
        
        //计算次数
        if (_runSec%_oneTimes == 0) {
            currTimes.text = "\(--_times)";
        }
        
        //加减计时
        _runSec++;
        _runtotalSec--;
        totalMin.text="\(_runtotalSec/60)";
        totalSec.text="\(_runtotalSec%60)";
        //计算已运行时间
        runMin.text="\(_runSec/60)";
        runSec.text="\(_runSec%60)";
        //计算是否已经全部完成
        if (_runSec == _totalSec) {
            stopTimer();
        }
    }
}

