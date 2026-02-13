module Web.Types where

import Generated.Types
import IHP.ModelSupport
import IHP.Prelude

data WebApplication = WebApplication deriving (Eq, Show)

data TodosController
    = TodosAction
    | CreateTodoAction
    | ToggleTodoAction { todoId :: !(Id Todo) }
    | TouchTodoAction { todoId :: !(Id Todo) }
    | DeleteTodoAction { todoId :: !(Id Todo) }
    deriving (Eq, Show, Data)
