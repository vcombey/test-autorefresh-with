module Web.Controller.TodosController where

import IHP.AutoRefresh
import IHP.AutoRefresh.ChangeSet
import Web.Controller.Prelude
import Web.View.Todos.Index

instance Controller TodosController where
    action TodosAction = autoRefreshWith AutoRefreshOptions { shouldRefresh } do
        todos <- query @Todo |> orderByDesc #createdAt |> fetch
        let newTodo = newRecord @Todo
        render IndexView { .. }
      where
        shouldRefresh changes = do
            let todoChanges = changesForTable "todos" changes
            let isVisibleChange change = case change.operation of
                    AutoRefreshInsert -> True
                    AutoRefreshDelete -> True
                    AutoRefreshUpdate ->
                        rowFieldNew @"title" @Text change /= rowFieldOld @"title" @Text change
                        || rowFieldNew @"isDone" @Bool change /= rowFieldOld @"isDone" @Bool change
            pure (any isVisibleChange todoChanges)

    action CreateTodoAction = do
        let newTodo = newRecord @Todo
        newTodo
            |> fill @'["title"]
            |> ifValid \case
                Left todo -> do
                    todos <- query @Todo |> orderByDesc #createdAt |> fetch
                    let newTodo = todo
                    render IndexView { .. }
                Right todo -> do
                    todo |> set #isDone False |> createRecord
                    redirectTo TodosAction

    action ToggleTodoAction { todoId } = do
        todo <- fetch todoId
        todo |> set #isDone (not todo.isDone) |> updateRecord
        redirectTo TodosAction

    action TouchTodoAction { todoId } = do
        todo <- fetch todoId
        now <- getCurrentTime
        todo |> set #updatedAt now |> updateRecord
        redirectTo TodosAction

    action DeleteTodoAction { todoId } = do
        todo <- fetch todoId
        deleteRecord todo
        redirectTo TodosAction
