package handler

import (
	"encoding/json"
	"moneytracker/errs"
	"moneytracker/logs"
	"moneytracker/service"

	"github.com/gofiber/fiber/v2"
)

type userHandler struct {
	userSrv service.UserService
}

func NewUserHandler(userSrv service.UserService) userHandler {
	return userHandler{userSrv: userSrv}
}

func (h userHandler) GetByUsername(c *fiber.Ctx) error {
	username := c.Params("username")
	user, err := h.userSrv.GetByUsername(username)
	if err != nil {
		logs.Error(err)
		return err
	}
	return c.JSON(user)
}

func (h userHandler) Create(c *fiber.Ctx) error {
	if c.Is("application/json") {
		logs.Error(errs.NewValidationError("request body is not in json format"))
		return errs.NewValidationError("request body is not in json format")
	}

	u := service.User{}
	err := c.BodyParser(&u)
	if err != nil {
		logs.Error(errs.NewValidationError("request body incorrect format"))
		return errs.NewValidationError("request body incorrect format")
	}

	response, err := h.userSrv.Create(u)
	if err != nil {
		logs.Error(err)
		return err
	}
	return c.JSON(response)

}

func (h userHandler) Update(c *fiber.Ctx) error {
	if c.Is("application/json") {
		logs.Error(errs.NewValidationError("request body is not in json format"))
		return errs.NewValidationError("request body is not in json format")
	}

	u := service.User{}
	err := c.BodyParser(&u)
	if err != nil {
		logs.Error(errs.NewValidationError("request body incorrect format"))
		return errs.NewValidationError("request body incorrect format")
	}

	userJSON := c.Body()

	err = json.Unmarshal(userJSON, &u)
	if err != nil {
		logs.Error(err)
		return err
	}

	response, err := h.userSrv.Update(u)
	if err != nil {
		logs.Error(err)
		return err
	}

	return c.JSON(response)

}

func (h userHandler) Delete(c *fiber.Ctx) error {
	username := c.Params("username")

	weather, err := h.userSrv.Delete(username)
	if err != nil {
		logs.Error(err)
		return err
	}

	return c.JSON(weather)
}
