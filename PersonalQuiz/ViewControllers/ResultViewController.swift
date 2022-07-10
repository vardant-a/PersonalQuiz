//
//  ResultViewController.swift
//  PersonalQuiz
//
//  Created by Алексей on 09.07.2022.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet var yourAnimalLabels: [UILabel]!
    
    var answersChosen: [Answer]!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true

        showResult()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true)
    }
    
    private func showResult() {
        guard let resultAnimal = seachYourAnimal() else { return }
        yourAnimalLabels.first?.text = "Вы - \(resultAnimal.rawValue)"
        yourAnimalLabels.last?.text = resultAnimal.definition
    }
}

extension ResultViewController {
    
    private func seachYourAnimal() -> Animal? {
        var animals = [answersChosen.first?.animal: 0]
        
        answersChosen.forEach { answerChosen in
            if animals[answerChosen.animal] == nil {
                animals[answerChosen.animal] = 1
            } else {
                animals[answerChosen.animal]! += 1
            }
        }
        
        let sortiredAnimals = animals.sorted(by: { $0.value > $1.value })
        return sortiredAnimals.first?.key
    }
}

