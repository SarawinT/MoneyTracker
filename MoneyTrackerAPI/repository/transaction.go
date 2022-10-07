package repository

type Transaction struct {
	ID       int     `db:"ID"`
	Category string  `db:"Category"`
	Amount   float32 `db:"Amount"`
	Date     string  `db:"Date"`
	Note     string  `db:"Note"`
	Username string  `db:"Username"`
}

type TransactionRepository interface {
	GetAll(username string) ([]Transaction, error)
	GetByID(username string, id int) (*Transaction, error)
	GetByDate(username string, date string) ([]Transaction, error)
	Create(Transaction) (*Transaction, error)
	Update(username string, id int, category string, amount float32, date string, note string) (*Transaction, error)
	Delete(username string, id int) (*Transaction, error)
	GetUserBalance(username string) (*float32, error)
	UpdateUserBalance(username string, balance float32) (*float32, error)
}
