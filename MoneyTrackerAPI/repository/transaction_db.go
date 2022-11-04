package repository

import (
	"errors"
	"moneytracker/logs"

	_ "github.com/go-sql-driver/mysql"
	"github.com/jmoiron/sqlx"
)

type transactionRepositoryDB struct {
	db *sqlx.DB
}

func NewTransactionRepositoryDB(db *sqlx.DB) transactionRepositoryDB {
	return transactionRepositoryDB{db: db}
}

func (r transactionRepositoryDB) GetAll(username string) ([]Transaction, error) {

	transactions := []Transaction{}
	query := "SELECT ID, Category, Amount, Date, Note, Username FROM TransactionTbl WHERE Username = ? ORDER BY DATE DESC, ID DESC"

	err := r.db.Select(&transactions, query, username)
	if err != nil {
		logs.Error(err)
		return nil, err
	}

	return transactions, err
}

func (r transactionRepositoryDB) GetByID(username string, id int) (*Transaction, error) {
	transaction := Transaction{}
	query := "SELECT ID, Category, Amount, Date, Note, Username FROM TransactionTbl WHERE ID = ? AND Username = ?"

	err := r.db.Get(&transaction, query, id, username)
	if err != nil {
		logs.Error(err)
		return nil, err
	}

	return &transaction, err
}

func (r transactionRepositoryDB) GetByDate(username string, from string, to string) ([]Transaction, error) {
	transactions := []Transaction{}
	query := "SELECT ID, Category, Amount, Date, Note, Username FROM TransactionTbl WHERE Date >= ? AND Date <= ? AND Username = ? ORDER BY DATE DESC, ID DESC"

	err := r.db.Select(&transactions, query, from, to, username)
	if err != nil {
		logs.Error(err)
		return nil, err
	}

	return transactions, err
}

func (r transactionRepositoryDB) Create(transaction Transaction) (*Transaction, error) {
	query := "INSERT INTO TransactionTbl (Category, Amount, Date, Note, Username) VALUES (?, ?, ?, ?, ?)"

	newTransaction, err := r.db.Exec(query, transaction.Category, transaction.Amount, transaction.Date, transaction.Note, transaction.Username)
	if err != nil {
		logs.Error(err)
		return nil, err
	}

	id, err := newTransaction.LastInsertId()
	if err != nil {
		logs.Error(err)
		return nil, err
	}

	transaction.ID = int(id)

	return &transaction, err
}

func (r transactionRepositoryDB) Update(username string, id int, category string, amount float32, date string, note string) (*Transaction, error) {
	query := "UPDATE TransactionTbl SET Category = ?, Amount = ?, Date = ?, Note = ? WHERE ID = ? AND Username = ?"

	_, err := r.db.Exec(query, category, amount, date, note, id, username)
	if err != nil {
		logs.Error(err)
		return nil, err
	}

	transaction, err := r.GetByID(username, id)
	if err != nil {
		logs.Error(err)
		return nil, err
	}

	return transaction, err
}

func (r transactionRepositoryDB) Delete(username string, id int) (*Transaction, error) {
	transaction, err := r.GetByID(username, id)
	if err != nil {
		logs.Error(err)
		return nil, errors.New("no transaction id in database")
	}

	query := "DELETE FROM TransactionTbl WHERE ID = ? AND Username = ?"
	_, err = r.db.Exec(query, id, username)
	if err != nil {
		logs.Error(err)
		return nil, err
	}

	return transaction, err
}

func (r transactionRepositoryDB) GetUserBalance(username string) (*float32, error) {
	user := User{}
	query := "SELECT Balance FROM UserTbl WHERE Username = ?"
	err := r.db.Get(&user, query, username)
	if err != nil {
		logs.Error(err)
		return nil, err
	}

	return &user.Balance, nil

}

func (r transactionRepositoryDB) UpdateUserBalance(username string, balance float32) (*float32, error) {
	query := "UPDATE UserTbl SET Balance = ? WHERE Username = ?"
	_, err := r.db.Exec(query, balance, username)
	if err != nil {
		logs.Error(err)
		return nil, err
	}

	return r.GetUserBalance(username)
}

func (r transactionRepositoryDB) GetUser(username string) (*User, error) {
	user := User{}
	query := "SELECT Username, Balance FROM UserTbl WHERE Username = ?"

	err := r.db.Get(&user, query, username)
	if err != nil {
		logs.Error(err)
		return nil, err
	}

	return &user, err
}
