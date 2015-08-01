//
//  AudioRecorderViewController.swift
//  Voice Changer
//
//  Created by Luke on 2015/06/08.
//  Copyright (c) 2015年 Luke Tunnicliffe. All rights reserved.
//

import UIKit
import AVFoundation

class AudioRecorderViewController: UIViewController, AVAudioRecorderDelegate{
    
    @IBOutlet var recordingStatus: UILabel!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var pauseButton: UIButton!
    @IBOutlet var resumeButton: UIButton!
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    var previousData = [String]()

    @IBAction func recordButton(sender: AnyObject) {
        stopButton.hidden = false
        pauseButton.hidden = false
        //Change label to the now recording
        recordingStatus.text = "Now recording"
        //Show directory for where recording is
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        //Give all recordings the following name
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        previousData.append(recordingName)
        saveData(previousData)
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: nil)
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        if audioAlreadyExists() == true {
            previousData = NSUserDefaults.standardUserDefaults().objectForKey("audio") as! [String]!
        }
    }
    
    func saveData(previousData:[String]){
        NSUserDefaults.standardUserDefaults().setObject(previousData, forKey: "audio")
    }
    
    func audioAlreadyExists() -> Bool {
        if (NSUserDefaults.standardUserDefaults().objectForKey("audio") != nil) {
            return true
        }else {
            return false
        }
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
        recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent!, filePathUrl: recorder.url!)
        performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else {
            println("Recording was not successful!")
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopButtonAction(sender: AnyObject) {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    @IBAction func pauseButton(sender: AnyObject) {
        audioRecorder.pause()
        resumeButton.hidden = false
        pauseButton.hidden = true
    }
    
    @IBAction func resumeButton(sender: AnyObject) {
        audioRecorder.record()
        resumeButton.hidden = true
        pauseButton.hidden = false
    }
   
    override func viewDidAppear(animated: Bool) {
        stopButton.hidden = true
        pauseButton.hidden = true
        resumeButton.hidden = true
        recordingStatus.text = "Press to record"
    }
}

