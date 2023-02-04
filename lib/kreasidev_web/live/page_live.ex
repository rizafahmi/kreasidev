defmodule KreasidevWeb.PageLive do
  use KreasidevWeb, :live_view
  alias Kreasidev.Accounts

  def mount(_params, %{"user_token" => user_token}, socket) do
    posts = fetch()

    socket =
      socket
      |> assign(posts: posts)
      |> assign(current_user: Accounts.get_user_by_session_token(user_token))

    {:ok, socket}
  end

  def mount(_params, _session, socket) do
    posts = fetch()
    socket = socket |> assign(posts: posts, current_user: nil)
    {:ok, socket}
  end

  def render(assigns) do
    KreasidevWeb.PageView.render("index.html", assigns)
  end

  def handle_info({:post_updated, _current_post}, socket) do
    {:noreply,
     update(socket, :posts, fn _posts ->
       fetch()
     end)}
  end

  def handle_event("upvote", %{"id" => id}, socket) do
    current_post = Kreasidev.Entries.get_post!(id)

    if check_voters(current_post.voters, socket.assigns.current_user.id) do
      {:noreply, socket}
    else
      case Kreasidev.Entries.update_post(current_post, %{
             upvote: current_post.upvote + 1,
             voters: append_voters(current_post.voters, socket.assigns.current_user.id)
           }) do
        {:ok, _post} ->
          posts = fetch()
          socket = socket |> assign(posts: posts)
          IO.inspect(posts)
          {:noreply, socket}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, changeset: changeset)}

        _ ->
          {:noreply, socket}
      end
    end
  end

  defp check_voters(nil, _) do
    false
  end

  defp check_voters([], _) do
    false
  end

  defp check_voters(voters, current_userid) do
    case Enum.find_index(voters, fn voter -> voter == current_userid end) do
      nil -> false
      _ -> true
    end
  end

  defp fetch() do
    posts = Kreasidev.Entries.list_posts(%{"order_by" => "upvote_desc"})
    Kreasidev.Repo.preload(posts, :comments)
  end

  defp append_voters(nil, userid) do
    [userid]
  end

  defp append_voters(voters, userid) do
    voters ++ [userid]
  end
end
