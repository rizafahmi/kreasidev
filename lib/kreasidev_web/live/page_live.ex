defmodule KreasidevWeb.PageLive do
  use KreasidevWeb, :live_view

  def mount(_params, _session, socket) do
    posts = Kreasidev.Entries.list_posts(%{"order_by" => "upvote_desc"})
    posts = Kreasidev.Repo.preload(posts, :comments)
    IO.inspect(posts)
    socket = socket |> assign(posts: posts)
    {:ok, socket}
  end

  def handle_event("upvote", %{"id" => id}, socket) do
    current_post = Kreasidev.Entries.get_post!(id)

    case Kreasidev.Entries.update_post(current_post, %{upvote: current_post.upvote + 1}) do
      {:ok, post} ->
        {:noreply, live_redirect(to: Routes.live_path(socket, PageLive))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}

      _ ->
        {:noreply, socket}
    end
  end
end
