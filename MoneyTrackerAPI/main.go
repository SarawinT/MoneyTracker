package main

import (
	"fmt"
	"log"
	"moneytracker/handler"
	"moneytracker/repository"
	"moneytracker/service"
	"strings"
	"time"

	// "github.com/go-sql-driver/mysql"
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/logger"
	"github.com/jmoiron/sqlx"
	"github.com/spf13/viper"
	gormMysql "gorm.io/driver/mysql"
	"gorm.io/gorm"
)

func main() {
	initConfig()
	db := initDatabaseGORM()

	transactionRepositoryDB := repository.NewTransactionRepositoryGORM(db)
	transactionService := service.NewTransactionService(transactionRepositoryDB)
	transactionHandler := handler.NewTransactionHandler(transactionService)

	userRepository := repository.NewUserRepositoryGORM(db)
	userService := service.NewUserService(userRepository)
	userHandler := handler.NewUserHandler(userService)

	app := fiber.New()
	app.Use(logger.New())

	transactionGet := app.Group("/transaction/:username")
	transactionGet.Get("/", transactionHandler.GetAllDated)
	transactionGet.Get("/id/:id", transactionHandler.GetByID)
	transactionGet.Get("/date/", transactionHandler.GetByDateDated)
	transactionGetRaw := app.Group("/transaction/raw/:username")
	transactionGetRaw.Get("/", transactionHandler.GetAll)
	transactionGetRaw.Get("/id/:id", transactionHandler.GetByID)
	transactionGetRaw.Get("/date/", transactionHandler.GetByDate)
	app.Post("/transaction/:username/", transactionHandler.Create)
	app.Put("/transaction/:username/", transactionHandler.Update)
	app.Delete("/transaction/:username/:id/", transactionHandler.Delete)

	app.Get("/user/:username/", userHandler.GetByUsername)
	app.Post("/user/", userHandler.Create)
	app.Put("/user/", userHandler.Update)
	app.Delete("/user/:username", userHandler.Delete)

	log.Fatal(app.Listen(viper.GetString("app.port")))

}

func initConfig() {
	viper.SetConfigName("config")
	viper.SetConfigType("yaml")
	viper.AddConfigPath(".")
	viper.AutomaticEnv()
	viper.SetEnvKeyReplacer(strings.NewReplacer(".", "_"))

	err := viper.ReadInConfig()
	if err != nil {
		panic(err)
	}
}

func initDatabase() *sqlx.DB {
	dsn := fmt.Sprintf("%v:%v@tcp(%v:%v)/%v",
		viper.GetString("db.username"),
		viper.GetString("db.password"),
		viper.GetString("db.host"),
		viper.GetInt("db.port"),
		viper.GetString("db.database"),
	)

	db, err := sqlx.Open(viper.GetString("db.driver"), dsn)

	if err != nil {
		panic(err)
	}

	db.SetConnMaxLifetime(3 * time.Minute)
	db.SetMaxOpenConns(10)
	db.SetMaxIdleConns(10)

	return db
}

func initDatabaseGORM() *gorm.DB {
	dsn := fmt.Sprintf("%v:%v@tcp(%v:%v)/%v?parseTime=true",
		viper.GetString("db.username"),
		viper.GetString("db.password"),
		viper.GetString("db.host"),
		viper.GetInt("db.port"),
		viper.GetString("db.database"),
	)

	db, err := gorm.Open(gormMysql.Open(dsn))

	if err != nil {
		panic(err)
	}

	return db
}
