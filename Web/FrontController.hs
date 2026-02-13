module Web.FrontController where

import IHP.RouterPrelude
import Web.Controller.Prelude
import Web.View.Layout (defaultLayout)

import Web.Controller.TodosController

instance FrontController WebApplication where
    controllers =
        [ startPage TodosAction
        , parseRoute @TodosController
        ]

instance InitControllerContext WebApplication where
    initContext = do
        setLayout defaultLayout
