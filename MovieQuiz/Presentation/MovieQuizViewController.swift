import UIKit

final class MovieQuizViewController: UIViewController {
    
    
    
    // MARK: - Private Properties
    weak var delegate: QuestionFactoryDelegate?
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizeQuestion?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticServices?
    
    private var currentQuestionIndex = 0             // номер вопроса
    private var correctAnswers = 0                    // счетчик правильных ответов
    
    
    // MARK: - IBAction
    
    @IBAction func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        let giveAnswer = false
            
        self.showAnswerResult(isCorrect: giveAnswer == currentQuestion.correctAnswer)
        }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        let giveAnswer = true
        
        showAnswerResult(isCorrect: giveAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textView: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    @IBOutlet private var noButton: UIButton!
    
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.requestNextQuestion()
        alertPresenter = AlertPresenterImp(viewController: self)
        statisticService = StatisticServicesImp()
        
        textView.text = ""
        imageView.layer.cornerRadius = 20
        imageView.backgroundColor = UIColor.clear
        activityIndicator.hidesWhenStopped = true
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
   
    // MARK: - Struct
    
    struct ViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    // MARK: - Private Methods
    
    private func convert(_ model: QuizeQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }

    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textView.text = step.question
        counterLabel.text = step.questionNumber
        
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func showAnswerResult(isCorrect: Bool) {
       if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            showFinalResults()
        } else {
            currentQuestionIndex += 1
            showLoadingIndicator()
            questionFactory?.requestNextQuestion()
            
        }
    }
      
    private func showFinalResults() {
        statisticService?.store(correct: correctAnswers, total: questionsAmount)
        let alertModel = AlertModel(
            title: "Игра окончена",
            message: makeResultMessage(),
            buttonText: "Сыграть еще раз",
            completion: { [weak self] in
            guard let self = self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.showLoadingIndicator()
                self.questionFactory?.loadData()
        }
    )
        
        alertPresenter?.show(alertModel: alertModel)
    }
    
    
    private func makeResultMessage() -> String {
        guard let statisticService = statisticService else {
            assertionFailure("error message")
            return ""
        }
        
        let resultMessage = """
        Ваш результат: \(correctAnswers)/\(questionsAmount)
        Количество сыгранных квизов: \(statisticService.gameCount)
        Лучший результат: \(statisticService.bestGame.correct)/10 (\(statisticService.bestGame.date.dateTimeString))
        Cредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        """
        return resultMessage

    }
    
    private func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError (message: String) {
        let alert = AlertModel(
            title: "Что-то пошло не так",
            message:  message,
            buttonText: "Попробовать еще раз",
            completion: { [weak self] in 
                guard let self = self else { return }
                self.questionFactory?.loadData()
                self.showLoadingIndicator()
            }
        )
        
        alertPresenter?.show(alertModel: alert)
    }
    
    
    private func showImageError(message: String) {
        let alert = AlertModel(
            title: "Что-то пошло не так",
            message: message,
            buttonText: "Загрузить другой вопрос",
            completion: { [weak self] in
                guard let self = self else { return }
                self.questionFactory?.requestNextQuestion()
                self.showLoadingIndicator()
            }
        )
    }
}
// MARK: - Extension
extension MovieQuizViewController: QuestionFactoryDelegate {
    //MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(_ question: QuizeQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
}






/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
