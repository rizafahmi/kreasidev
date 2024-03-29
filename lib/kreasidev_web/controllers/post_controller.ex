defmodule KreasidevWeb.PostController do
  use KreasidevWeb, :controller

  alias Kreasidev.Entries
  alias Kreasidev.Entries.Post

  def index(conn, _params) do
    posts = Entries.list_posts()
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Entries.change_post(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    user = conn.assigns[:current_user]
    post_params = Map.put(post_params, "user_id", user.id)

    case Entries.create_post(post_params) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Kreasi baru berhasil ditambahkan.")
        |> redirect(to: "/")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Entries.get_post!(id)
    post = Kreasidev.Repo.preload(post, :comments)
    comment_changeset = Kreasidev.Entries.Comment.changeset(%Kreasidev.Entries.Comment{}, %{})
    render(conn, "show.html", post: post, comment_changeset: comment_changeset)
  end

  def edit(conn, %{"id" => id}) do
    post = Entries.get_post!(id)
    changeset = Entries.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Entries.get_post!(id)

    case Entries.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Kreasi berhasil diubah.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Entries.get_post!(id)
    {:ok, _post} = Entries.delete_post(post)

    conn
    |> put_flash(:info, "Kreasi berhasil dihapus.")
    |> redirect(to: Routes.post_path(conn, :index))
  end
end
