package repository

import (
	"moneytracker/logs"

	_ "github.com/go-sql-driver/mysql"
	"gorm.io/gorm"
)

type transactionRepositoryGORM struct {
	db *gorm.DB
}

func NewTransactionRepositoryGORM(db *gorm.DB) transactionRepositoryGORM {
	return transactionRepositoryGORM{db: db}
}

func (r transactionRepositoryGORM) GetAll(username string) ([]Transaction, error) {
	transactions := []Transaction{}
	tx := r.db.Where(&Transaction{Username: username}).Order("Date DESC").Order("ID DESC").Find(&transactions)
	if tx.Error != nil {
		logs.Error(tx.Error)
		return nil, tx.Error
	}

	return transactions, nil
}

func (r transactionRepositoryGORM) GetByID(username string, id int) (*Transaction, error) {
	transaction := Transaction{}
	tx := r.db.Where(&Transaction{ID: id, Username: username}).First(&transaction)
	if tx.Error != nil {
		logs.Error(tx.Error)
		return nil, tx.Error
	}

	return &transaction, nil
}

func (r transactionRepositoryGORM) GetByDate(username string, from string, to string) ([]Transaction, error) {
	transactions := []Transaction{}
	tx := r.db.Where(&Transaction{Username: username}).Where("Date > ? AND Date < ?", from, to).Order("Date DESC").Order("ID DESC").Find(&transactions)

	if tx.Error != nil {
		logs.Error(tx.Error)
		return nil, tx.Error
	}

	return transactions, nil
}

func (r transactionRepositoryGORM) Create(transaction Transaction) (*Transaction, error) {
	tx := r.db.Create(&transaction)
	if tx.Error != nil {
		logs.Error(tx.Error)
		return nil, tx.Error
	}

	return &transaction, nil
}

func (r transactionRepositoryGORM) Update(username string, id int, category string, amount float32, date string, note string) (*Transaction, error) {
	transaction := Transaction{
		ID:       id,
		Category: category,
		Amount:   amount,
		Date:     date,
		Note:     note,
		Username: username,
	}
	tx := r.db.Where(&Transaction{ID: id, Username: username}).Save(&transaction)
	if tx.Error != nil {
		logs.Error(tx.Error)
		return nil, tx.Error
	}

	return &transaction, nil
}

func (r transactionRepositoryGORM) Delete(username string, id int) (*Transaction, error) {
	transaction, err := r.GetByID(username, id)
	if err != nil {
		logs.Error(err)
		return nil, err
	}

	tx := r.db.Delete(transaction)
	if tx.Error != nil {
		logs.Error(tx.Error)
		return nil, tx.Error
	}
	return transaction, nil

}

func (r transactionRepositoryGORM) GetUserBalance(username string) (*float32, error) {
	user := User{}

	tx := r.db.Where(&User{Username: username}).Find(&user)
	if tx.Error != nil {
		logs.Error(tx.Error)
		return nil, tx.Error
	}

	return &user.Balance, nil

}

func (r transactionRepositoryGORM) UpdateUserBalance(username string, balance float32) (*float32, error) {
	user := User{Balance: balance}

	tx := r.db.Model(&user).Where(&User{Username: username}).Update("balance", balance)

	if tx.Error != nil {
		logs.Error(tx.Error)
		return nil, tx.Error
	}

	return r.GetUserBalance(username)

}

func (r transactionRepositoryGORM) GetUser(username string) (*User, error) {
	user := User{}
	tx := r.db.Where(&User{Username: username}).Find(&user)
	if tx.Error != nil {
		logs.Error(tx.Error)
		return nil, tx.Error
	}

	return &user, nil

}
