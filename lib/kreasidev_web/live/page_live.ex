defmodule KreasidevWeb.PageLive do
  use KreasidevWeb, :live_view

  def mount(_params, _session, socket) do
    # if connected?(socket), do: Kreasidev.Entries.subscribe()
    posts = fetch()
    socket = socket |> assign(posts: posts)
    {:ok, socket}
  end

  def render(assigns) do
    KreasidevWeb.PageView.render("index.html", assigns)
  end

  def handle_info({:post_updated, current_post}, socket) do
    {:noreply,
     update(socket, :posts, fn _posts ->
       fetch()
     end)}
  end

  def handle_event("upvote", %{"id" => id}, socket) do
    current_post = Kreasidev.Entries.get_post!(id)

    case Kreasidev.Entries.update_post(current_post, %{upvote: current_post.upvote + 1}) do
      {:ok, post} ->
        posts = fetch()
        socket = socket |> assign(posts: posts)
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}

      _ ->
        {:noreply, socket}
    end
  end

  defp fetch() do
    posts = Kreasidev.Entries.list_posts(%{"order_by" => "upvote_desc"})
    Kreasidev.Repo.preload(posts, :comments)
  end
end
