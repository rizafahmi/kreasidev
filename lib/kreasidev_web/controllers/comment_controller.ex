defmodule KreasidevWeb.CommentController do
  use KreasidevWeb, :controller

  def create(conn, %{"comment" => comment_params, "post_id" => post_id}) do
    post = Kreasidev.Repo.get(Kreasidev.Entries.Post, post_id)
    comment_changeset = Ecto.build_assoc(post, :comments, body: comment_params["body"])

    Kreasidev.Repo.insert(comment_changeset)

    conn
    |> put_flash(:info, "Comment created successfully.")
    |> redirect(to: Routes.post_path(conn, :show, post))
  end
end
