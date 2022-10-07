package handler

import (
	"encoding/json"
	"moneytracker/errs"
	"moneytracker/logs"
	"moneytracker/service"

	"github.com/gofiber/fiber/v2"
)

type transactionHandler struct {
	transactionSrv service.TransactionService
}

func NewTransactionHandler(transactionSrv service.TransactionService) transactionHandler {
	return transactionHandler{transactionSrv: transactionSrv}
}

func (h transactionHandler) GetAll(c *fiber.Ctx) error {
	username := c.Params("username")
	transactions, err := h.transactionSrv.GetAll(username)
	if err != nil {
		logs.Error(err)
		return err
	}
	return c.JSON(transactions)
}

func (h transactionHandler) GetByID(c *fiber.Ctx) error {
	username := c.Params("username")
	id, err := c.ParamsInt("id")
	if err != nil {
		logs.Error(err)
		return err
	}
	transaction, err := h.transactionSrv.GetByID(username, id)
	if err != nil {
		logs.Error(err)
		return err
	}
	return c.JSON(transaction)
}

func (h transactionHandler) GetByDate(c *fiber.Ctx) error {
	username := c.Params("username")
	date := c.Query("date")
	transactions, err := h.transactionSrv.GetByDate(username, date)
	if err != nil {
		logs.Error(err)
		return err
	}
	return c.JSON(transactions)
}

func (h transactionHandler) Create(c *fiber.Ctx) error {
	if c.Is("application/json") {
		logs.Error(errs.NewValidationError("request body is not in json format"))
		return errs.NewValidationError("request body is not in json format")
	}

	t := service.TransactionPost{}
	err := c.BodyParser(&t)
	if err != nil {
		logs.Error(errs.NewValidationError("request body incorrect format"))
		return errs.NewValidationError("request body incorrect format")
	}

	t.Username = c.Params("username")

	response, err := h.transactionSrv.Create(t)
	if err != nil {
		logs.Error(err)
		return err
	}
	return c.JSON(response)

}

func (h transactionHandler) Update(c *fiber.Ctx) error {
	username := c.Params("username")
	if c.Is("application/json") {
		logs.Error(errs.NewValidationError("request body is not in json format"))
		return errs.NewValidationError("request body is not in json format")
	}

	t := service.Transaction{}
	err := c.BodyParser(&t)
	if err != nil {
		logs.Error(errs.NewValidationError("request body incorrect format"))
		return errs.NewValidationError("request body incorrect format")
	}

	transactionJSON := c.Body()

	err = json.Unmarshal(transactionJSON, &t)
	if err != nil {
		logs.Error(err)
		return err
	}

	response, err := h.transactionSrv.Update(username, t.ID, t.Category, t.Amount, t.Date, t.Note)
	if err != nil {
		logs.Error(err)
		return err
	}

	return c.JSON(response)

}

func (h transactionHandler) Delete(c *fiber.Ctx) error {
	username := c.Params("username")
	id, err := c.ParamsInt("id")
	if err != nil {
		logs.Error(err)
		return err
	}

	weather, err := h.transactionSrv.Delete(username, id)
	if err != nil {
		logs.Error(err)
		return err
	}

	return c.JSON(weather)
}
