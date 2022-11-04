package service

type Transaction struct {
	ID       int     `json:"ID"`
	Category string  `json:"Category"`
	Amount   float32 `json:"Amount"`
	Date     string  `json:"Date"`
	Note     string  `json:"Note"`
	Username string  `json:"Username"`
}

type TransactionPost struct {
	Category string  `json:"Category"`
	Amount   float32 `json:"Amount"`
	Date     string  `json:"Date"`
	Note     string  `json:"Note"`
	Username string  `json:"Username"`
}

type DatedTransactions struct {
	Date         string        `json:"Date"`
	Transactions []Transaction `json:"Transactions"`
}

type TransactionService interface {
	GetAll(username string) ([]Transaction, error)
	GetAllDated(username string) ([]DatedTransactions, error)
	GetByID(username string, id int) (*Transaction, error)
	GetByDate(username string, from string, to string) ([]Transaction, error)
	GetDatedByDate(username string, from string, to string) ([]DatedTransactions, error)
	Create(TransactionPost) (*Transaction, error)
	Update(username string, id int, category string, amount float32, date string, note string) (*Transaction, error)
	Delete(username string, id int) (*Transaction, error)
}
