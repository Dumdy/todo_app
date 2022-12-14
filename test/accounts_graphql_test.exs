defmodule AccountsGraphqlTest do
  use TodoWeb.ConnCase, async: true
  import Todo.AccountsFixtures

  describe "users queries and mutations test" do
    test "querying all users" do
      user = user_fixture()

      user_query = """
      query{
        users{
          id
          userName
          email
        }
      }
      """

      response =
        build_conn()
        |> post("/api", %{query: user_query})

      assert json_response(response, 200) == %{
               "data" => %{
                 "users" => [
                   %{
                     "email" => "janny@email.com",
                     "id" => "#{user.id}",
                     "userName" => "Janny"
                   }
                 ]
               }
             }
    end

    test "creates a new user with valid attributes" do
      mutation = """
      mutation createUser($userName: String, $email: String) {
        createUser(input: {userName: $userName, email: $email}) {
          userName
          email
        }
      }
      """

      variables = %{userName: "Mazi Eduno", email: "test@email.com"}

      response =
        build_conn()
        |> post("/api", %{query: mutation, variables: variables})

      assert json_response(response, 200) == %{
               "data" => %{
                 "createUser" => %{"userName" => "Mazi Eduno", "email" => "test@email.com"}
               }
             }
    end

    test "Update a user with valid data" do
      mutation = """
      mutation updateUser($userId: ID!, $userName: String, $email: String) {
        updateUser(userId: $userId, input: {userName: $userName, email: $email}) {
          userName
          email
        }
      }
      """

      user = user_fixture()

      variables = %{userId: user.id, userName: "Alex Manny", email: "alexmanny@email.com"}

      response =
        build_conn()
        |> post("/api", %{query: mutation, variables: variables})

      assert json_response(response, 200) == %{
               "data" => %{
                 "updateUser" => %{"userName" => "Alex Manny", "email" => "alexmanny@email.com"}
               }
             }
    end

    test "delete a user" do
      mutation = """
      mutation deleteUser($userId: ID!) {
        deleteUser(userId: $userId) {
          userName
          email
        }
      }
      """

      user = user_fixture()

      variables = %{userId: user.id}

      response =
        build_conn()
        |> post("/api", %{query: mutation, variables: variables})

      assert json_response(response, 200) == %{
               "data" => %{
                 "deleteUser" => %{"userName" => "Janny", "email" => "janny@email.com"}
               }
             }
    end
  end

  describe "todo queries and mutations test" do
    test "querying all todos" do
      todo = todo_activity_fixture()

      todo_query = """
      query{
        todoActivities{
        id
        activity
        }
      }
      """

      response =
        build_conn()
        |> post("/api", %{query: todo_query})

      assert json_response(response, 200) == %{
               "data" => %{
                 "todoActivities" => [
                   %{
                     "activity" => "Do some dirty dishes",
                     "id" => "#{todo.id}"
                   }
                 ]
               }
             }
    end

    test "creating a new todo activity" do
      mutation = """
      mutation createTodoActivity($activity: String, $userId: ID!) {
        createTodoActivity(input: {activity: $activity, userId: $userId}) {

         activity

        }
      }
      """

      user = user_fixture()
      variables = %{activity: "Prepare dinner", userId: user.id}

      response =
        build_conn()
        |> post("/api", %{query: mutation, variables: variables})

      assert json_response(response, 200) == %{
               "data" => %{
                 "createTodoActivity" => %{"activity" => "Prepare dinner"}
               }
             }
    end

    test "Update a users todo activity" do
      mutation = """
      mutation updateTodo($todoActivityId: ID!, $activity: String) {
        updateTodo(todoActivityId: $todoActivityId, input: {activity: $activity}) {
      activity
        }
      }
      """

      todo = todo_activity_fixture()
      variables = %{todoActivityId: todo.id, activity: "Write some erlang code"}

      response =
        build_conn()
        |> post("/api", %{query: mutation, variables: variables})

      assert json_response(response, 200) == %{
               "data" => %{
                 "updateTodo" => %{"activity" => "Write some erlang code"}
               }
             }
    end

    test "delete a todo" do
      mutation = """
      mutation deleteTodo($todoActivityId: ID!) {
        deleteTodo(todoActivityId: $todoActivityId) {
         activity
        }
      }
      """

      todo = todo_activity_fixture()
      variables = %{todoActivityId: todo.id}

      response =
        build_conn()
        |> post("/api", %{query: mutation, variables: variables})

      assert json_response(response, 200) == %{
               "data" => %{
                 "deleteTodo" => %{"activity" => "Do some dirty dishes"}
               }
             }
    end
  end
end
