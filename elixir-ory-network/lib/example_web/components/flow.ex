defmodule ExampleWeb.Flow do
  use Phoenix.Component

  alias Phoenix.LiveView.JS

  import ExampleWeb.Gettext
  import ExampleWeb.CoreComponents

  # TODO(@tobbbles): Figure out if this can be dynamically set up as a type union from Ory LoginFlow and RegistrationFlow
  attr :flow, :map, required: true

  @spec flow(map()) :: Phoenix.LiveView.Rendered.t()
  def flow(assigns) when not is_nil(assigns.flow) do
    IO.inspect(assigns)

    ~H"""
    <.ui_message_group flow={@flow} />

    <%= if @flow.ui do %>
      <form action={@flow.ui.action} method={@flow.ui.method}>
        <%= for node <- @flow.ui.nodes do %>
          <.ui_node node={node} />
        <% end %>
      </form>
    <% end %>
    """
  end

  attr :flow, :map

  def ui_message_group(%{flow: %{ui: %{messages: messages}}} = assigns) do
    ~H"""
    <%= if @flow.ui.messages do %>
      <%= for message <- @flow.ui.messages do %>
        <.ui_message text={message.text} />
      <% end %>
    <% end %>
    """
  end

  def ui_message_group(assigns) do
    ~H"""

    """
  end

  attr :text, :string

  def ui_message(assigns) do
    ~H"""
    <span class="flex items-center font-medium tracking-wide text-red-500 text-xs mt-1 ml-1">
      <%= @text %>
    </span>
    """
  end

  @doc """
  Renders UI nodes conditionally on their attribute type(s)
  """
  attr :node, Ory.Model.UiNode

  def ui_node(%{node: %{type: "input", attributes: %{type: "hidden"}} = node} = assigns) do
    ~H"""
    <div class="mb-4" class="invisible">
      <.ui_input attributes={@node.attributes} />
    </div>
    """
  end

  def ui_node(%{node: %{type: "input", attributes: %{type: "submit"}} = node} = assigns) do
    ~H"""
    <div class="mb-4">
      <.button
        name={@node.attributes.name}
        type={@node.attributes.type}
        value={@node.attributes.value}
      >
        <%= @node.meta.label.text %>
      </.button>
    </div>
    """
  end

  def ui_node(
        %{
          node:
            %{
              type: "input",
              attributes: %{type: "checkbox"}
            } = node
        } = assigns
      ) do
    ~H"""
    <fieldset class="flex items-center mb-4 ">
      <input
        name={@node.attributes.name}
        type="hidden"
        value="false"
        class="mr-4 text-blue-600
        bg-neutral-300 border-gray-300 rounded
        focus:ring-blue-500 focus:ring-2
        dark:focus:ring-blue-600 dark:ring-offset-gray-800 dark:bg-gray-700 dark:border-gray-600"
      />
      <input
        name={@node.attributes.name}
        id={@node.attributes.name}
        type={@node.attributes.type}
        value="true"
        placeholder="getNodeLabel"
        checked={@node.attributes.value}
        disabled={@node.attributes.disabled}
        class="mr-4 text-blue-600 border-gray-300 border-gray-300 rounded
        focus:ring-blue-500 focus:ring-2
        dark:focus:ring-blue-600 dark:ring-offset-gray-800 dark:bg-gray-700 dark:border-gray-600"
      />
      <.ui_label
        class="l-2 block text-gray-800 text-sm font-bold"
        for={@node.attributes.name}
        text={@node.meta.label.text}
      />
      <%= if @node.messages do %>
        <%= for message <- @node.messages do %>
          <.ui_message text={message.text} />
        <% end %>
      <% end %>
    </fieldset>
    """
  end

  def ui_node(%{node: %{type: "script"} = node} = assigns) do
    ~H"""
    <script
      src={@node.attributes.src}
      type={@node.attributes.type}
      integrity={@node.attributes.integrity}
      referrerpolicy={@node.attributes.referrerpolicy}
      crossorigin={@node.attributes.crossorigin}
      async={@node.attributes.async}
    >
    </script>
    """
  end

  # TODO(@tobbbles): Implement
  def ui_node(%{node: %{type: "a"} = node} = assigns) do
    ~H"""
    <.button>
      <.link
        id={@node.attributes.id}
        href={@node.attributes.href}
        class="text-sm font-semibold leading-6 ext-gray-100"
      >
        <span><%= @node.meta.label.text %></span>
      </.link>
    </.button>
    """
  end

  def ui_node(%{node: %{type: "img"} = node} = assigns) do
    ~H"""
    <img
      id={@node.attributes.id}
      src={@node.attributes.src}
      width={@node.attributes.width}
      height={@node.attributes.height}
      alt={@node.meta.label.text}
    />
    """
  end

  # TODO(@tobbbles): Implement text ID 1050015 for multiple secrets as a table
  def ui_node(%{node: %{type: "text"} = node} = assigns) do
    ~H"""
    <div id={@node.attributes.id}>
      <pre>
        <code><%= @node.attributes.text.text %></code>
      </pre>
    </div>
    """
  end

  def ui_node(%{node: node} = assigns) do
    ~H"""
    <div class="mb-4">
      <.ui_label for={@node.attributes.name} text={@node.meta.label.text} />
      <.ui_input attributes={@node.attributes} />
      <%= if @node.messages do %>
        <%= for message <- @node.messages do %>
          <.ui_message text={message.text} />
        <% end %>
      <% end %>
    </div>
    """
  end

  attr :for, :string, required: true
  attr :text, :string, required: true
  attr :class, :string, default: "block mb-2 text-sm font-medium text-gray-900"

  def ui_label(assigns) do
    ~H"""
    <label class={@class} for={@for}><%= @text %></label>
    """
  end

  attr :attributes, Ory.Model.UiNodeAttributes, required: true

  def ui_input(assigns) do
    ~H"""
    <input
      class={[
        "block w-full p-2.5",
        "bg-white border border-gray-300 text-gray-900 text-sm rounded-lg",
        "focus:ring-blue-500 focus:border-blue-500",
        "dark:border-gray-600 dark:bg-gray-700 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
      ]}
      name={@attributes.name}
      id={@attributes.name}
      text={@attributes.text}
      type={@attributes.type}
      value={@attributes.value}
      required={@attributes.required}
    />
    """
  end

  # attr :message, :string, required: true
  # def ui_node_message(assigns) do
  #   ~H"""
  #   <span><%= @message %></span>
  #   """
  # end
end
