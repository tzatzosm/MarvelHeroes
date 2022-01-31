//
//  ViewController.swift
//  AsyncAwaitMarvelHeroes
//
//  Created by Marsel Tzatzos on 31/01/2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Task.detached {
            do {
                let response = try await MarvelService.shared.getCharacters(nameStartsWith: nil, order: "name", offset: 0, limit: 10)
                print(response)
            } catch {
                print(error)
            }
        }
    }


}

