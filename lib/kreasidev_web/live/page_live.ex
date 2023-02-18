defmodule KreasidevWeb.PageLive do
  alias Pow.Store.Backend.EtsCache
  alias Pow.Store.CredentialsCache
  use KreasidevWeb, :live_view

  def mount(_params, %{"kreasidev_auth" => user_token}, socket) do
    posts = fetch()

    current_user = get_user(socket, user_token)

    socket =
      socket
      |> assign(posts: posts)
      |> assign(current_user: current_user)

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

    if check_voters(current_post.voters, socket.assigns.current_user) do
      {:noreply, socket}
    else
      case Kreasidev.Entries.update_post(current_post, %{
             upvote: current_post.upvote + 1,
             voters: append_voters(current_post.voters, socket.assigns.current_user.id)
           }) do
        {:ok, _post} ->
          posts = fetch()
          socket = socket |> assign(posts: posts)
          {:noreply, socket}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, changeset: changeset)}

        _ ->
          {:noreply, socket}
      end
    end
  end

  defp fetch() do
    posts = Kreasidev.Entries.list_posts(%{"order_by" => "upvote_desc"})
    Kreasidev.Repo.preload(posts, :comments)
  end

  defp check_voters(nil, _) do
    false
  end

  defp check_voters([], _) do
    false
  end

  defp check_voters(_voters, nil) do
    false
  end

  defp check_voters(voters, current_user) do
    case Enum.find_index(voters, fn voter -> voter == current_user.id end) do
      nil -> false
      _ -> true
    end
  end

  defp get_user(socket, user_token, config \\ [otp_app: :kreasidev]) do
    conn = struct!(Plug.Conn, secret_key_base: socket.endpoint.config(:secret_key_base))
    salt = Atom.to_string(Pow.Plug.Session)

    with {:ok, token} <- Pow.Plug.verify_token(conn, salt, user_token, config),
         {user, _metadata} <- CredentialsCache.get([backend: EtsCache], token) do
      user
    else
      _ -> nil
    end
  end

  defp get_user(_, _, _), do: nil

  defp append_voters(nil, userid) do
    [userid]
  end

  defp append_voters(voters, userid) do
    voters ++ [userid]
  end
end
