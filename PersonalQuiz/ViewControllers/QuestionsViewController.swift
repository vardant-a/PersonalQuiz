//
//  QuestionsViewController.swift
//  PersonalQuiz
//
//  Created by Алексей on 09.07.2022.
//

import UIKit

class QuestionsViewController: UIViewController {
    
    
    @IBOutlet var questionProgressView: UIProgressView!
    @IBOutlet var questionLabel: UILabel!
    
    @IBOutlet var singleStackView: UIStackView!
    @IBOutlet var singleButtons: [UIButton]!
    
    @IBOutlet var multipleStackView: UIStackView!
    @IBOutlet var multipleLabels: [UILabel]!
    @IBOutlet var multipleSwitches: [UISwitch]!
    
    @IBOutlet var rangedStackView: UIStackView!
    @IBOutlet var rangedLabels: [UILabel]!
    @IBOutlet var rangedSlider: UISlider! {
        didSet {
            let answerCount = Float(currentAnswers.count - 1)
            rangedSlider.maximumValue = answerCount
            rangedSlider.value = answerCount / 2
        }
    }
    
    private let questions = Question.getQuestions()
    private var questionIndex = 0
    private var currentAnswers: [Answer] {
        questions[questionIndex].answers
    }
    private var answersChosen: [Answer] = []
    private var test = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let resultVC = segue.destination as? ResultViewController else { return }
        resultVC.answersChosen = answersChosen
    }
    
    @IBAction func singleButtonAnswerPressed(_ sender: UIButton) {
        guard let buttonIndex = singleButtons.firstIndex(of: sender) else { return }
        let answerUser = currentAnswers[buttonIndex]
        answersChosen.append(answerUser)
        nextQuestion()
    }
    
    @IBAction func multipleButtonAnswerPressed() {
        for (multipleSwitch, answer) in zip(multipleSwitches, currentAnswers) {
            if multipleSwitch.isOn {
                answersChosen.append(answer)
            }
        }
        nextQuestion()
    }
    
    @IBAction func rangedButtonAnswerPressed() {
        let index = lrintf(rangedSlider.value)
        answersChosen.append(currentAnswers[index])
        nextQuestion()
    }
}

extension QuestionsViewController {
    
    private func updateUI() {
        for stackView in [singleStackView, multipleStackView, rangedStackView] {
            stackView?.isHidden = true
        }
        //  Выводим вопрос на View
        let currentQuestion = questions[questionIndex]
        questionLabel.text = currentQuestion.title
        // Отображение шкалы прогресса
        let totalProgress = Float(questionIndex) / Float(questions.count)
        questionProgressView.setProgress(totalProgress, animated: true)
        title = "Вопрос № \(questionIndex + 1) из \(questions.count)"
        
        showCurrentAnswers(for: currentQuestion.responseType)
    }
    private func showCurrentAnswers(for type: ResponseType) {
        switch type {
        case .signle:
            showSingleStackView(with: currentAnswers)
        case .multiple:
            showMultipleStackView(with: currentAnswers)
        case .renged:
            showRangedStackView(with: currentAnswers)
        }
    }
    
    private func showSingleStackView(with answers: [Answer]) {
        singleStackView.isHidden = false
        
        for (button, answer) in zip(singleButtons, answers) {
            button.setTitle(answer.title, for: .normal)
        }
    }
    
    private func showMultipleStackView(with answers: [Answer]) {
        multipleStackView.isHidden = false
        
        for (label, answer) in zip(multipleLabels, answers) {
            label.text = answer.title
        }
    }
    
    private func showRangedStackView(with answers: [Answer]) {
        rangedStackView.isHidden = false
        
        rangedLabels.first?.text = answers.first?.title
        rangedLabels.last?.text = answers.last?.title
    }
    
    private func nextQuestion() {
        questionIndex += 1
        if questionIndex < questions.count {
            updateUI()
            return
        }
        performSegue(withIdentifier: "showResultViewController", sender: nil)
    }
}
