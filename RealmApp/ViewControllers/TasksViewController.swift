//
//  TasksViewController.swift
//  RealmApp
//
//  Created by Alexey Efimov on 02.07.2018.
//  Copyright © 2018 Alexey Efimov. All rights reserved.
//

import RealmSwift

class TasksViewController: UITableViewController {
    
    var taskList: TaskList!
    
    var currentTasks: Results<Task>!
    var completedTasks: Results<Task>!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = taskList.name
        currentTasks = taskList.tasks.filter("isComplete = false")
        completedTasks = taskList.tasks.filter("isComplete = true")
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonPressed)
        )
        navigationItem.rightBarButtonItems = [addButton, editButtonItem]
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? currentTasks.count : completedTasks.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "CURRENT TASKS" : "COMPLETED TASKS"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasksCell", for: indexPath)
        let task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.name
        content.secondaryText = task.note
        cell.contentConfiguration = content
        return cell
    }
    
    @objc private func addButtonPressed() {
        showAlert()
    }

// MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        
    let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
        StorageManager.shared.delete(task)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        print(task)
    }
    
//    let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
//        self.showEditAlert()
//        tableView.reloadRows(at: [indexPath], with: .automatic)
//    }
    
//    let doneAction = UIContextualAction(style: .normal, title: "Done") {_, _, isDone in
//        StorageManager.shared.done(taskList)
//        tableView.reloadRows(at: [indexPath], with: .automatic)
//        isDone(true)
//    }
    
    //editAction.backgroundColor = .orange
    //doneAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
    
    return UISwipeActionsConfiguration(actions: [deleteAction])
}
}

extension TasksViewController {
    
    private func showAlert() {
        
        let alert = AlertController.createAlert(withTitle: "New Task", andMessage: "What do you want to do?")
        
        alert.action { newValue, note in
            self.saveTask(withName: newValue, andNote: note)
        }
        
        present(alert, animated: true)
    }
    
//    private func showEditAlert() {
//        
//        let alert = AlertController.createAlert(withTitle: "Edit Task", andMessage: "What do you want to edit?")
//        
//        alert.action { newValue, note in
//            self.editTask(withName: newValue, andNote: note)
//        }
//        
//        present(alert, animated: true)
//    }
    
    private func saveTask(withName name: String, andNote note: String) {
        let task = Task(value: [name, note])
        StorageManager.shared.save(task, to: taskList)
        let rowIndex = IndexPath(row: currentTasks.index(of: task) ?? 0, section: 0)
        tableView.insertRows(at: [rowIndex], with: .automatic)
    }
    
//    private func editTask(withName name: String, andNote note: String) {
//        let task = Task(value: [name, note])
//        StorageManager.shared.edit(task, to: name, to: note)
//let rowIndex = IndexPath(row: currentTasks.index(of: task) ?? 0, section: 0)
//        tableView.insertRows(at: [rowIndex], with: .automatic)
//    }
}

