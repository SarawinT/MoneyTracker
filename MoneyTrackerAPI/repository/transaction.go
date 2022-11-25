package repository

type Transaction struct {
	ID       int     `db:"ID"`
	Category string  `db:"Category"`
	Amount   float32 `db:"Amount"`
	Date     string  `db:"Date"`
	Note     string  `db:"Note"`
	Username string  `db:"Username"`
}

func (t Transaction) TableName() string {
	return "transactiontbl"
}

type TransactionRepository interface {
	GetAll(username string) ([]Transaction, error)
	GetByID(username string, id int) (*Transaction, error)
	GetByDate(username string, from string, to string) ([]Transaction, error)
	Create(Transaction) (*Transaction, error)
	Update(username string, id int, category string, amount float32, date string, note string) (*Transaction, error)
	Delete(username string, id int) (*Transaction, error)
	GetUserBalance(username string) (*float32, error)
	UpdateUserBalance(username string, balance float32) (*float32, error)
	GetUser(username string) (*User, error)
}
