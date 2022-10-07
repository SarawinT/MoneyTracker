package service

import (
	"moneytracker/errs"
	"moneytracker/logs"
	"moneytracker/repository"
)

type transactionService struct {
	transactionRepo repository.TransactionRepository
}

func NewTransactionService(transactionRepo repository.TransactionRepository) transactionService {
	return transactionService{transactionRepo: transactionRepo}
}

func (s transactionService) GetAll(username string) ([]Transaction, error) {
	transactions, err := s.transactionRepo.GetAll(username)
	if err != nil {
		logs.Error(err)
		return nil, errs.NewUnexpectedError()
	}

	transactionsResponses := []Transaction{}
	for _, t := range transactions {
		transactionsResponse := Transaction{
			ID:       t.ID,
			Category: t.Category,
			Amount:   t.Amount,
			Date:     t.Date,
			Note:     t.Note,
			Username: t.Username,
		}
		transactionsResponses = append(transactionsResponses, transactionsResponse)
	}

	return transactionsResponses, nil

}

func (s transactionService) GetByID(username string, id int) (*Transaction, error) {
	transaction, err := s.transactionRepo.GetByID(username, id)
	if transaction == nil {
		return nil, errs.NewNotFoundError("id not found")
	}
	if err != nil {
		logs.Error(err)
		return nil, errs.NewUnexpectedError()
	}

	t := Transaction{
		ID:       transaction.ID,
		Category: transaction.Category,
		Amount:   transaction.Amount,
		Date:     transaction.Date,
		Note:     transaction.Note,
		Username: transaction.Username,
	}

	return &t, nil

}

func (s transactionService) GetByDate(username string, date string) ([]Transaction, error) {
	transactions, err := s.transactionRepo.GetByDate(username, date)
	if err != nil {
		logs.Error(err)
		return nil, errs.NewUnexpectedError()
	}

	transactionsResponses := []Transaction{}
	for _, t := range transactions {
		transactionsResponse := Transaction{
			ID:       t.ID,
			Category: t.Category,
			Amount:   t.Amount,
			Date:     t.Date,
			Note:     t.Note,
			Username: t.Username,
		}
		transactionsResponses = append(transactionsResponses, transactionsResponse)
	}

	return transactionsResponses, nil

}

func (s transactionService) Create(post TransactionPost) (*Transaction, error) {

	transaction := repository.Transaction{
		Category: post.Category,
		Amount:   post.Amount,
		Date:     post.Date,
		Note:     post.Note,
		Username: post.Username,
	}

	balance, err := s.transactionRepo.GetUserBalance(post.Username)
	if err != nil {
		logs.Error(err)
		return nil, errs.NewUnexpectedError()
	}
	newBalance := (*balance) + post.Amount
	if newBalance < 0 {
		return nil, errs.NewValidationError("not enough money")
	}

	t, err := s.transactionRepo.Create(transaction)
	if err != nil {
		logs.Error(err)
		return nil, errs.NewUnexpectedError()
	}
	_, err = s.transactionRepo.UpdateUserBalance(post.Username, newBalance)
	if err != nil {
		logs.Error(err)
		return nil, errs.NewUnexpectedError()
	}

	transactionsResponse := Transaction{
		ID:       t.ID,
		Category: t.Category,
		Amount:   t.Amount,
		Date:     t.Date,
		Note:     t.Note,
		Username: t.Username,
	}

	return &transactionsResponse, nil

}

func (s transactionService) Update(username string, id int, category string, amount float32, date string, note string) (*Transaction, error) {

	checkID, err := s.transactionRepo.GetByID(username, id)
	if checkID == nil || err != nil {
		return nil, errs.NewNotFoundError("id not found")
	}

	amountDif := -1 * (checkID.Amount - amount)
	balance, err := s.transactionRepo.GetUserBalance(username)
	if err != nil {
		logs.Error(err)
		return nil, errs.NewUnexpectedError()
	}
	newBalance := amountDif + (*balance)
	if newBalance < 0 {
		return nil, errs.NewValidationError("not enough money")
	}

	t, err := s.transactionRepo.Update(username, id, category, amount, date, note)
	if err != nil {
		logs.Error(err)
		return nil, errs.NewUnexpectedError()
	}
	_, err = s.transactionRepo.UpdateUserBalance(username, newBalance)
	if err != nil {
		logs.Error(err)
		return nil, errs.NewUnexpectedError()
	}

	transactionsResponse := Transaction{
		ID:       t.ID,
		Category: t.Category,
		Amount:   t.Amount,
		Date:     t.Date,
		Note:     t.Note,
		Username: t.Username,
	}

	return &transactionsResponse, nil
}

func (s transactionService) Delete(username string, id int) (*Transaction, error) {
	transaction, err := s.transactionRepo.Delete(username, id)
	if err != nil {
		logs.Error(err)
		return nil, errs.NewUnexpectedError()
	}

	balance, err := s.transactionRepo.GetUserBalance(username)
	if err != nil {
		logs.Error(err)
		return nil, errs.NewUnexpectedError()
	}

	_, err = s.transactionRepo.UpdateUserBalance(username, *balance+(transaction.Amount*-1))
	if err != nil {
		logs.Error(err)
		return nil, errs.NewUnexpectedError()
	}

	t := Transaction{
		ID:       transaction.ID,
		Category: transaction.Category,
		Amount:   transaction.Amount,
		Date:     transaction.Date,
		Note:     transaction.Note,
		Username: transaction.Username,
	}

	return &t, nil

}
