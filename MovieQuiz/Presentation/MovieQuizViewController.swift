import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    
    
    
    // MARK: - Private Properties
    
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticServices?
    private var presenter: MovieQuizPresenter!
    
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
        
        
        alertPresenter = AlertPresenterImp(viewController: self)
        statisticService = StatisticServicesImp()
        presenter = MovieQuizPresenter(viewController: self)
        
        textView.text = ""
        imageView.backgroundColor = UIColor.clear
        activityIndicator.hidesWhenStopped = true
        self.switchOfButton()
    }
    
    // MARK: - Internal Methods
    
    func showQuestion(quiz step: QuizStepViewModel) {
        imageView.layer.cornerRadius = 20
        imageView.image = step.image
        textView.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderColor = UIColor.clear.cgColor
        switchOfButton()
        
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func showFinalAlert(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            completion: { [weak self] in
                guard let self = self else { return }
                self.presenter.restartGame()
            }
        )
        
        alertPresenter?.show(alertModel: alertModel)
    }
    
    func showErrorAlert(alertModel: AlertModel) {
        alertPresenter?.show(alertModel: alertModel)
    }
    
    func showLoadingIndicator() {
        activityIndicator?.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator?.stopAnimating()
    }
    
    
    func switchOfButton() {
        yesButton.isEnabled.toggle()
        noButton.isEnabled.toggle()
    }
    
    // MARK: - IBAction
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        self.switchOfButton()
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        self.switchOfButton()
        presenter.yesButtonClicked()
    }
}
