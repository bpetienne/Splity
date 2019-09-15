//
//  NoteViewController.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 14/08/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController, UITextViewDelegate  {
    
    @IBOutlet weak var noteTextView: UITextView!
    var trip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let trip = self.trip {
            noteTextView.text = trip.note
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.parent?.navigationItem.rightBarButtonItem = nil
    }
    
    func save() {
        self.parent?.navigationItem.rightBarButtonItem = nil
        noteTextView.resignFirstResponder()
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        updateNote()
    }
    
    func textViewDidEndEditing(_ textView: UITextView){
        updateNote()
        textView.resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textView: UITextView) -> Bool {
        //Hide the keyboard
        updateNote()
        textView.resignFirstResponder()
        return true
    }
    
    
    func updateNote(){
        trip?.note = noteTextView.text
        trip?.saveText(noteText: trip!.note)
    }
    
    
    
    
}
