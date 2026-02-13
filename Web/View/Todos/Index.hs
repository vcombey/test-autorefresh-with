module Web.View.Todos.Index where

import Web.View.Prelude

data IndexView = IndexView
    { todos :: [Todo]
    , newTodo :: Todo
    }

instance View IndexView where
    html IndexView { .. } = [hsx|
        <div class="container">
            <div class="header">
                <h1>Todos</h1>
                <p>Fine-grained auto refresh with <code>autoRefreshWith</code></p>
            </div>

            <div class="card">
                {renderForm newTodo}
            </div>

            <ul class="todo-list">
                {forEach todos renderTodo}
            </ul>
        </div>
    |]

renderTodo :: Todo -> Html
renderTodo todo = [hsx|
    <li class={itemClass}>
        <div>
            <span class="title">{todo.title}</span>
            <small class="updated-at">Updated: {tshow todo.updatedAt}</small>
        </div>
        <span class="actions">
            <a href={togglePath} class="toggle">
                {if todo.isDone then ("Undo" :: Text) else "Done"}
            </a>
            <a href={touchPath} class="touch">Touch</a>
            <a href={deletePath} class="delete js-delete js-delete-no-confirm">Delete</a>
        </span>
    </li>
|]
    where
        itemClass = if todo.isDone then ("todo done" :: Text) else "todo"
        togglePath = pathTo ToggleTodoAction { todoId = todo.id }
        touchPath = pathTo TouchTodoAction { todoId = todo.id }
        deletePath = pathTo DeleteTodoAction { todoId = todo.id }

renderForm :: Todo -> Html
renderForm todo = formFor todo [hsx|
    {(textField #title) { fieldLabel = "New todo", placeholder = "Buy milk" }}
    {submitButton { label = "Add todo" }}
|]
